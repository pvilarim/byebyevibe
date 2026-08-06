#!/usr/bin/env bash
# ByeByeVibe (sdd-kit) — release-readiness checks (repo-state only)
# Extracted from sdd-kit/verify.sh (add-release-readiness-gate, issue #348):
# version-sync, kit-integrity, and hub scripts<->templates parity are pure
# facts about files in the repo, independent of which CLIs a runner has
# installed — unlike verify-infra.sh, which legitimately FAILs when
# GitNexus/Graphify are absent. This script carries its own exit code so CI
# can block on it without inheriting verify-infra.sh's environment noise.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

FAILURES=0

# SDD_PYTHON: env value trusted as-is; else resolve by capability (kit floor 3.8).
# Unquoted expansions are deliberate — "py -3" is two words (fix-install-python-boundary D1/D3).
if [[ -z "${SDD_PYTHON:-}" ]]; then
  for _cand in "python3" "python" "py -3"; do
    if $_cand -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 8) else 1)' 2>/dev/null; then SDD_PYTHON="$_cand"; break; fi
  done
fi
[[ -n "${SDD_PYTHON:-}" ]] || { echo "ERROR: no usable Python interpreter (tried: python3, python, py -3; kit minimum 3.8)." >&2; exit 1; }

# Compare one version string declared in prose against its MANIFEST authority.
# Degrades per design D3: file absent -> INFO skip; claim missing or unparseable -> WARN;
# mismatch -> FAIL (increments FAILURES). Each call is independent of the others.
check_version_claim() {
  local file="$1" claim_re="$2" label="$3" auth_field="$4" auth_val="$5"
  local path="$REPO_ROOT/$file"
  local line declared

  if [[ ! -f "$path" ]]; then
    echo "INFO: $file absent — $label version check skipped"
    return 0
  fi

  line="$(grep -m1 -E "$claim_re" "$path" || true)"
  if [[ -z "$line" ]]; then
    echo "WARN: $file has no $label line — no version claim to check" >&2
    return 0
  fi

  declared="$(printf '%s\n' "$line" | grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"
  declared="${declared#v}"
  if [[ -z "$declared" ]]; then
    echo "WARN: $file $label declares no MAJOR.MINOR.PATCH token — not checked" >&2
    return 0
  fi

  if [[ -z "$auth_val" || "$auth_val" == "?" ]]; then
    echo "WARN: MANIFEST $auth_field unreadable — $file $label not checked" >&2
    return 0
  fi

  if [[ "$declared" == "$auth_val" ]]; then
    echo "OK: $file $label declares $declared (= MANIFEST $auth_field)"
  else
    echo "FAIL: $file $label declares $declared but MANIFEST $auth_field is $auth_val" >&2
    ((FAILURES++)) || true
  fi
}

echo "=== scripts/verify-release-readiness.sh ==="
echo "Repo: $REPO_ROOT"

KIT_VER=""
GUIDE_VER=""
if [[ -f "$REPO_ROOT/sdd-kit/MANIFEST.yaml" ]]; then
  KIT_VER="$(grep -E '^version:' "$REPO_ROOT/sdd-kit/MANIFEST.yaml" | head -1 | sed 's/.*"\(.*\)".*/\1/' || echo '?')"
  GUIDE_VER="$(grep -E '^guide_version:' "$REPO_ROOT/sdd-kit/MANIFEST.yaml" | head -1 | sed 's/.*"\(.*\)".*/\1/' || echo '?')"
  echo "Kit version: $KIT_VER"
  echo "Guide version: $GUIDE_VER"
else
  echo "WARN: sdd-kit/MANIFEST.yaml not found in repo"
fi

# Version sync: every declared version string must match its MANIFEST authority
# (sdd-post-install-verification). Guarded per file, not per hub, because a consumer
# may hold sdd-kit/README.md without holding templates/.
echo ""
echo "==> version sync"
if [[ -f "$REPO_ROOT/sdd-kit/MANIFEST.yaml" ]]; then
  check_version_claim "sdd-kit/README.md" '^# ' \
    "heading" "version" "$KIT_VER"
  check_version_claim "doc/byebyevibe-guide.md" 'Canonical install guide' \
    "canonical-guide header" "guide_version" "$GUIDE_VER"
  check_version_claim "doc/byebyevibe-guide.md" '\*\*Guide version:\*\*' \
    "'Guide version' line" "guide_version" "$GUIDE_VER"
else
  echo "INFO: sdd-kit/MANIFEST.yaml absent — version sync checks skipped"
fi

# Kit integrity parity check (hub only — skipped in consumer repos without templates/)
if [[ -d "$REPO_ROOT/sdd-kit/templates" ]] && [[ -f "$REPO_ROOT/sdd-kit/MANIFEST.yaml" ]]; then
  echo ""
  echo "==> kit-integrity (hub only)"

  if ! command -v sha256sum &>/dev/null && ! command -v shasum &>/dev/null; then
    echo "WARN: sha256sum/shasum not available — kit-integrity check skipped"
  else
    # $SDD_PYTHON unquoted by convention ("py -3" is two words); rc captured so
    # a failed helper can never be recorded as a green check (non-vacuity).
    KIT_INTEGRITY_RC=0
    KIT_INTEGRITY_RESULT="$($SDD_PYTHON - "$REPO_ROOT/sdd-kit/MANIFEST.yaml" "$REPO_ROOT/sdd-kit" << 'PY'
import sys, re, subprocess, os

manifest_path = sys.argv[1]
kit_dir       = sys.argv[2]
text = open(manifest_path).read()

import shutil
if shutil.which("sha256sum"):
    sha256_cmd = ["sha256sum"]
elif shutil.which("shasum"):
    sha256_cmd = ["shasum", "-a", "256"]
else:
    print("SKIP: no sha256 utility")
    sys.exit(0)

sources = re.findall(r"^\s{4}source:\s+\"?([^\"'\n]+)\"?\s*$", text, re.MULTILINE)

errors   = 0
warnings = 0
compared = 0

for src in sources:
    # Join with "/" explicitly: a native-separator join puts a backslash in the
    # path on Windows, and sha256sum then escapes its whole output line.
    template_path = kit_dir.rstrip("/") + "/" + src
    # Find sha256 for this source in MANIFEST
    m = re.search(
        r"    source:\s*\"?" + re.escape(src) + r"\"?\n    sha256:\s*\"?([a-f0-9]+)\"?",
        text
    )
    if not m:
        print(f"WARN: no sha256 field for {src}")
        warnings += 1
        continue

    expected = m.group(1)

    if not os.path.isfile(template_path):
        print(f"FAIL: template not found: {src}")
        errors += 1
        continue

    result = subprocess.run(sha256_cmd + [template_path], capture_output=True, text=True)
    actual = result.stdout.split()[0] if result.returncode == 0 and result.stdout.split() else ""
    # Bare 64-hex only: GNU sha256sum escapes its whole output line (leading
    # backslash) when the filename contains one — never compare that token.
    if actual and not re.fullmatch(r"[0-9a-f]{64}", actual):
        print(f"WARN: unreadable digest for {src} (escaped output?)")
        warnings += 1
        continue

    if not actual:
        print(f"WARN: could not hash {src}")
        warnings += 1
    elif actual != expected:
        print(f"FAIL: sha256 mismatch: {src}")
        print(f"  expected: {expected}")
        print(f"  actual:   {actual}")
        errors += 1
    else:
        compared += 1

# Non-vacuity: entries with sha256 fields were selected; comparing none of
# them is machinery failure, never a pass ("compared 0" must fail loudly).
if sources and warnings < len(sources) and compared == 0 and errors == 0:
    print(f"FAIL: compared 0 of {len(sources)} entries — kit-integrity checked nothing")
    errors += 1

print(f"entries={len(sources)} errors={errors} compared={compared} warnings={warnings}")
sys.exit(1 if errors else 0)
PY
    )" || KIT_INTEGRITY_RC=$?

    if [[ "$KIT_INTEGRITY_RC" -ne 0 && -z "$KIT_INTEGRITY_RESULT" ]]; then
      # Helper produced nothing: the python interpreter itself failed to run.
      echo "FAIL: kit-integrity — python interpreter failed (SDD_PYTHON=${SDD_PYTHON}); check produced no result" >&2
      ((FAILURES++)) || true
    elif echo "$KIT_INTEGRITY_RESULT" | grep -q "^FAIL:"; then
      echo "$KIT_INTEGRITY_RESULT"
      echo "FAIL: kit-integrity" >&2
      ((FAILURES++)) || true
    elif echo "$KIT_INTEGRITY_RESULT" | grep -q "^WARN:"; then
      echo "$KIT_INTEGRITY_RESULT"
      echo "OK: kit-integrity (with warnings)"
    else
      echo "$KIT_INTEGRITY_RESULT"
      echo "OK: kit-integrity"
    fi
  fi
fi

# Hub drift gate: live scripts/ must match sdd-kit/templates/scripts/ (hub only — D8)
if [[ -d "$REPO_ROOT/sdd-kit/templates/scripts" ]]; then
  echo ""
  echo "==> hub scripts↔templates parity (hub only)"
  DRIFT=0
  for tmpl in "$REPO_ROOT"/sdd-kit/templates/scripts/*.sh; do
    live="$REPO_ROOT/scripts/$(basename "$tmpl")"
    [[ -f "$live" ]] || continue
    if ! diff -q "$live" "$tmpl" >/dev/null; then
      echo "FAIL: drift: scripts/$(basename "$tmpl") differs from sdd-kit/templates/scripts/$(basename "$tmpl")" >&2
      ((DRIFT++)) || true
    fi
  done
  if [[ "$DRIFT" -eq 0 ]]; then
    echo "OK: hub parity"
  else
    ((FAILURES+=DRIFT)) || true
  fi
fi

echo ""
if [[ "$FAILURES" -eq 0 ]]; then
  echo "Summary: release readiness checks passed ✅"
  exit 0
else
  echo "Summary: $FAILURES check(s) failed ❌"
  exit 1
fi
