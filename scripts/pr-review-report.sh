#!/usr/bin/env bash
# Consolidated, idempotent PR review summary (add-automated-pr-review-pipeline).
# Posts or updates one sticky comment identified by a stable HTML marker.
# LLM findings are advisory; deterministic failures remain blocking.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SELF_TEST=0
DET_JSON=""
LLM_JSON=""
MARKER="<!-- sdd-automated-pr-review -->"
RUN_URL=""
OUTPUT=""
POST=0
EVENT="create"
OWNER=""
REPO=""
PR_NUMBER=""
SKIP_REASON=""

usage() {
  cat <<'EOF'
Usage: bash scripts/pr-review-report.sh [options]

Build (and optionally post) one idempotent PR review summary.

  --self-test                 Run fixture matrix and exit
  --deterministic-json PATH   result.json from pr-review-check.sh
  --llm-json PATH             schema-bounded LLM result (optional)
  --run-url URL               Actions run URL
  --output PATH               Write markdown
  --marker TEXT               Sticky comment marker
  --post                      Create or update the sticky PR comment
  --event NAME                create|synchronize|timeout|deterministic-failure|fork-skip
  --skip-reason TEXT          Explicit skipped/degraded reason
  --owner OWNER               GitHub owner (for --post)
  --repo REPO                 GitHub repo (for --post)
  --pr NUMBER                 Pull request number (for --post)
  --help
EOF
}

die() { echo "ERROR: $*" >&2; exit 2; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --self-test) SELF_TEST=1; shift ;;
    --deterministic-json) DET_JSON="${2:-}"; shift 2 ;;
    --llm-json) LLM_JSON="${2:-}"; shift 2 ;;
    --run-url) RUN_URL="${2:-}"; shift 2 ;;
    --output) OUTPUT="${2:-}"; shift 2 ;;
    --marker) MARKER="${2:-}"; shift 2 ;;
    --post) POST=1; shift ;;
    --event) EVENT="${2:-}"; shift 2 ;;
    --skip-reason) SKIP_REASON="${2:-}"; shift 2 ;;
    --owner) OWNER="${2:-}"; shift 2 ;;
    --repo) REPO="${2:-}"; shift 2 ;;
    --pr) PR_NUMBER="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown option: $1" ;;
  esac
done

render_markdown() {
  local det_path="$1" llm_path="$2" run_url="$3" skip="$4" event="$5"
  python3 - "$det_path" "$llm_path" "$run_url" "$skip" "$event" "$MARKER" <<'PY'
import json, pathlib, sys
det_path, llm_path, run_url, skip, event, marker = sys.argv[1:7]

def load(path):
    if not path or path == "-":
        return None
    p = pathlib.Path(path)
    if not p.is_file() or p.stat().st_size == 0:
        return None
    return json.loads(p.read_text(encoding="utf-8"))

det = load(det_path) or {
    "status": "unknown",
    "blocking": False,
    "security_sensitive": False,
    "checks": [],
    "base_sha": None,
    "head_sha": None,
    "policy_hashes": {},
}
llm = load(llm_path)

def lens(llm, key, skipped_default):
    if not llm or not isinstance(llm, dict):
        return skipped_default, []
    block = llm.get(key) or {}
    verdict = block.get("verdict") or skipped_default[0]
    findings = block.get("findings") or []
    return verdict, findings

def fmt_findings(findings):
    if not findings:
        return "_No findings recorded._"
    lines = []
    for f in findings:
        loc = f.get("path") or "?"
        if f.get("line"):
            loc = f"{loc}:{f['line']}"
        tag = f.get("tag") or ""
        summary = f.get("summary") or f.get("description") or ""
        evidence = f.get("evidence") or ""
        extra = f" — {evidence}" if evidence else ""
        lines.append(f"- `{loc}` {tag}: {summary}{extra}")
    return "\n".join(lines)

det_status = det.get("status") or "unknown"
blocking = bool(det.get("blocking"))
sensitive = bool(det.get("security_sensitive"))
base_sha = det.get("base_sha") or "unknown"
head_sha = det.get("head_sha") or "unknown"

llm_state = "not-run"
llm_claim = "No successful model-review claim is emitted."
if skip:
    llm_state = "skipped"
    llm_claim = f"LLM review: skipped — {skip}"
elif event == "timeout":
    llm_state = "degraded"
    llm_claim = "LLM review: degraded — provider timeout. Machine check is independent."
elif event == "fork-skip":
    llm_state = "skipped"
    llm_claim = "LLM review: skipped — untrusted fork/credential unavailable"
elif llm is None:
    llm_state = "skipped"
    llm_claim = "LLM review: skipped — result unavailable"
else:
    llm_state = "advisory"
    llm_claim = "LLM findings are advisory and do not override deterministic checks."

if det_status == "fail":
    machine = "FAIL (blocking)"
else:
    machine = "PASS"

# Never represent a missing/degraded LLM stage as a passed review.
correctness_default = ("SKIPPED", [])
simplify_default = ("SKIPPED", [])
security_default = ("SKIPPED", [])
c_verdict, c_findings = lens(llm, "correctness", correctness_default)
s_verdict, s_findings = lens(llm, "simplification", simplify_default)
sec_verdict, sec_findings = lens(llm, "security", security_default)
if llm_state in ("skipped", "degraded", "not-run"):
    c_verdict = "SKIPPED" if llm_state != "degraded" else "DEGRADED"
    s_verdict = c_verdict
    if not (llm and (llm.get("security") or {}).get("included")):
        sec_verdict = c_verdict

sec_included = False
if llm and isinstance(llm, dict):
    sec_included = bool((llm.get("security") or {}).get("included")) or sensitive
if not sec_included:
    sec_section = "_Security lens not included (diff not classified security-sensitive)._"
else:
    sec_section = f"**Verdict:** `{sec_verdict}` (advisory)\n\n{fmt_findings(sec_findings)}"

check_lines = []
for ch in det.get("checks") or []:
    check_lines.append(
        f"- `{ch.get('path')}` ({ch.get('kind')} / {ch.get('command')}): `{ch.get('status')}` — {ch.get('detail')}"
    )
checks_md = "\n".join(check_lines) if check_lines else "_No changed files classified._"

policy = det.get("policy_hashes") or {}
policy_lines = [f"- `{k}`: `{v}`" for k, v in sorted(policy.items())]
policy_md = "\n".join(policy_lines) if policy_lines else "_No policy hashes recorded._"

run_md = run_url or "_Run URL not provided._"

body = f"""{marker}
## Automated PR review

Machine evidence is blocking. Model judgment is advisory. A missing or timed-out LLM stage is never a passed review.

### Deterministic checks

**Status:** `{machine}`

{checks_md}

Existing `sdd-gates` conclusions are unchanged by this workflow.

### Correctness (advisory)

**Verdict:** `{c_verdict}`

{fmt_findings(c_findings)}

### Simplification (advisory)

**Verdict:** `{s_verdict}`

{fmt_findings(s_findings)}

### Security (conditional, advisory)

{sec_section}

### Tested revisions

- Base: `{base_sha}`
- Head: `{head_sha}`

### Policy files (base revision hashes)

{policy_md}

### Run evidence

{run_md}

### Limitations / skipped / degraded

- Event: `{event}`
- LLM state: `{llm_state}`
- {llm_claim}
- No successful model-review claim is emitted unless an LLM result file was produced; timeout, skip, and missing authentication are never a pass.
"""
print(body)
PY
}

post_comment() {
  local body_file="$1"
  [[ -n "$OWNER" && -n "$REPO" && -n "$PR_NUMBER" ]] || die "--post requires --owner --repo --pr"
  command -v gh >/dev/null 2>&1 || die "gh CLI is required for --post"
  local comments json_id
  comments="$(gh api "repos/${OWNER}/${REPO}/issues/${PR_NUMBER}/comments" --paginate)"
  json_id="$(MARKER="$MARKER" python3 - "$comments" <<'PY'
import json, os, sys
marker = os.environ["MARKER"]
comments = json.loads(sys.argv[1] or "[]")
if isinstance(comments, dict):
    comments = [comments]
for c in comments:
    body = c.get("body") or ""
    if marker in body:
        print(c.get("id") or "")
        break
PY
)"
  if [[ -n "$json_id" ]]; then
    gh api --method PATCH "repos/${OWNER}/${REPO}/issues/comments/${json_id}" \
      -f body="$(cat "$body_file")" >/dev/null
    echo "Updated sticky review comment id=$json_id"
  else
    gh api --method POST "repos/${OWNER}/${REPO}/issues/${PR_NUMBER}/comments" \
      -f body="$(cat "$body_file")" >/dev/null
    echo "Created sticky review comment"
  fi
}

run_self_test() {
  local root fail=0
  root="$(mktemp -d)"
  trap 'rm -rf "$root"' RETURN

  cat > "$root/det-pass.json" <<'JSON'
{
  "schema": "sdd-pr-review-deterministic-v1",
  "status": "pass",
  "blocking": false,
  "security_sensitive": false,
  "base_sha": "aaa",
  "head_sha": "bbb",
  "checks": [{"path": "docs/a.md", "kind": "other", "status": "pass", "detail": "classified", "command": "classify"}],
  "policy_hashes": {".claude/skills/correctness-review/SKILL.md": "abc"}
}
JSON
  cat > "$root/det-fail.json" <<'JSON'
{
  "schema": "sdd-pr-review-deterministic-v1",
  "status": "fail",
  "blocking": true,
  "security_sensitive": false,
  "base_sha": "aaa",
  "head_sha": "ccc",
  "checks": [{"path": "scripts/bad.sh", "kind": "shell", "status": "fail", "detail": "syntax", "command": "bash -n"}],
  "policy_hashes": {}
}
JSON
  cat > "$root/llm-ok.json" <<'JSON'
{
  "correctness": {"verdict": "CORRECT", "findings": []},
  "simplification": {"verdict": "CLEAN", "findings": []},
  "security": {"verdict": "SKIPPED", "included": false, "findings": []}
}
JSON

  bash "$REPO_ROOT/scripts/pr-review-report.sh" \
    --deterministic-json "$root/det-pass.json" --llm-json "$root/llm-ok.json" \
    --run-url "https://example.test/run/1" --event create \
    --output "$root/create.md"
  bash "$REPO_ROOT/scripts/pr-review-report.sh" \
    --deterministic-json "$root/det-pass.json" --llm-json "$root/llm-ok.json" \
    --run-url "https://example.test/run/2" --event synchronize \
    --output "$root/sync.md"
  bash "$REPO_ROOT/scripts/pr-review-report.sh" \
    --deterministic-json "$root/det-pass.json" --event timeout \
    --skip-reason "provider timeout" --run-url "https://example.test/run/3" \
    --output "$root/timeout.md"
  bash "$REPO_ROOT/scripts/pr-review-report.sh" \
    --deterministic-json "$root/det-fail.json" --llm-json "$root/llm-ok.json" \
    --event deterministic-failure --run-url "https://example.test/run/4" \
    --output "$root/detfail.md"

  python3 - "$root" "$MARKER" <<'PY'
import pathlib, sys
root = pathlib.Path(sys.argv[1])
marker = sys.argv[2]
fail = 0

def read(name):
    return (root / name).read_text(encoding="utf-8")

create, sync, timeout, detfail = map(read, ["create.md", "sync.md", "timeout.md", "detfail.md"])
for name, text in [("create", create), ("sync", sync), ("timeout", timeout), ("detfail", detfail)]:
    count = text.count(marker)
    if count != 1:
        print("FAIL", name, "marker count", count)
        fail = 1
    else:
        print("PASS", name, "single marker")

if "bbb" not in create or "ccc" not in detfail:
    print("FAIL tested SHA missing")
    fail = 1
else:
    print("PASS tested revisions recorded")

if "https://example.test/run/2" not in sync:
    print("FAIL synchronize run link")
    fail = 1
else:
    print("PASS synchronize updates run link")

if "degraded" not in timeout.lower() and "timeout" not in timeout.lower():
    print("FAIL timeout not degraded")
    fail = 1
elif "PASS" in timeout and "model" in timeout.lower() and "successful model-review" in timeout and "never" not in timeout:
    print("FAIL timeout claimed model pass")
    fail = 1
else:
    print("PASS timeout is degraded, not a model pass")

# Explicit: timeout body must not claim a successful LLM review
if "successful model-review claim" not in timeout:
    print("FAIL timeout missing no-false-pass sentence")
    fail = 1
else:
    print("PASS no false model pass sentence present")

if "FAIL (blocking)" not in detfail:
    print("FAIL deterministic failure not blocking in summary")
    fail = 1
else:
    print("PASS deterministic failure remains blocking despite LLM CORRECT")

if "CORRECT" in detfail and "advisory" in detfail.lower():
    print("PASS LLM CORRECT did not convert machine failure")

sys.exit(fail)
PY
}

if [[ "$SELF_TEST" -eq 1 ]]; then
  run_self_test
  exit $?
fi

[[ -n "$DET_JSON" ]] || die "--deterministic-json is required (or --self-test)"
BODY="$(render_markdown "$DET_JSON" "${LLM_JSON:-}" "$RUN_URL" "$SKIP_REASON" "$EVENT")"
if [[ -n "$OUTPUT" ]]; then
  mkdir -p "$(dirname "$OUTPUT")"
  printf '%s\n' "$BODY" > "$OUTPUT"
fi
if [[ "$POST" -eq 1 ]]; then
  tmp="$(mktemp)"
  printf '%s\n' "$BODY" > "$tmp"
  post_comment "$tmp"
  rm -f "$tmp"
fi
if [[ -z "$OUTPUT" && "$POST" -eq 0 ]]; then
  printf '%s\n' "$BODY"
fi
