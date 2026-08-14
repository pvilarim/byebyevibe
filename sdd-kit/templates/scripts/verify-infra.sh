#!/usr/bin/env bash
# Idempotent SDD infrastructure verification — see openspec/infra.md
#
# Usage: verify-infra.sh [--write]
#
# Ownership: this script updates SDD Stack / kit / mcp-list markers only.
# MUST NOT write or clear preflight-* markers or the "## Preflight (last run)"
# section — those are owned exclusively by scripts/preflight-sdd.sh.
#
# Write gating: openspec/infra.md is committed and describes the operator's
# canonical workspace. Markers are updated only when stdout is a TTY
# (operator at a terminal) or --write is passed (operator cron/scripted run,
# bootstrap post-install). Any other run — CI, remote agent sandbox — is
# report-only: findings printed, file left byte-identical, exit 0 (advisory).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"
INFRA_FILE="$REPO_ROOT/openspec/infra.md"
TODAY="$(date +%Y-%m-%d)"
FAILURES=0

# SDD_PYTHON: env value trusted as-is; else resolve by capability (kit floor
# 3.8). Soft here — this script degrades gracefully without Python.
# Unquoted expansions are deliberate — "py -3" is two words (fix-install-python-boundary D1/D3).
if [[ -z "${SDD_PYTHON:-}" ]]; then
  for _cand in "python3" "python3.14" "python3.13" "python" "py -3" "/usr/bin/python3"; do
    if $_cand -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 8) else 1)' 2>/dev/null; then SDD_PYTHON="$_cand"; break; fi
  done
fi

WRITE_MODE=0
for arg in "$@"; do
  case "$arg" in
    --write) WRITE_MODE=1 ;;
    *)
      echo "Unknown argument: $arg" >&2
      echo "Usage: verify-infra.sh [--write]" >&2
      exit 2
      ;;
  esac
done
[[ -t 1 ]] && WRITE_MODE=1

mark_ok() { echo "ok"; }
mark_fail() { echo "fail"; ((FAILURES++)) || true; }

to_emoji() {
  if [[ "$1" == "ok" ]]; then echo "✅"; else echo "❌"; fi
}

replace_between() {
  local file="$1" marker="$2" value="$3"
  [[ -f "$file" ]] || return
  # Temp file + mv, never in-place editing: GNU sed takes an optional suffix where
  # BSD/macOS requires one, so no single in-place form is correct on both. No probe needed.
  local _tmp
  _tmp="$(mktemp)"
  sed "s|<!-- ${marker} -->.*<!-- /${marker} -->|<!-- ${marker} -->${value}<!-- /${marker} -->|" "$file" > "$_tmp" && mv "$_tmp" "$file"
}

echo "==> verify-infra.sh ($TODAY)"

# --- OpenSpec ---
# Presence is a PATH question (command -v) — never resolved through the npm
# registry. Detail (version) is collected only when the binary is present.
OPENSPEC_STATUS="fail"
OPENSPEC_VERSION="—"
if command -v openspec &>/dev/null; then
  OPENSPEC_STATUS="ok"
  OPENSPEC_VERSION="$(openspec --version 2>/dev/null || echo "—")"
fi
echo "OpenSpec: $(to_emoji "$OPENSPEC_STATUS") ${OPENSPEC_VERSION}"
[[ "$OPENSPEC_STATUS" == "fail" ]] && ((FAILURES++)) || true

# --- GitNexus ---
GITNEXUS_STATUS="fail"
GITNEXUS_VERSION="—"
if command -v gitnexus &>/dev/null; then
  if GN_OUT="$(gitnexus status 2>&1)" && echo "$GN_OUT" | grep -qi "up-to-date"; then
    GITNEXUS_STATUS="ok"
  fi
  GITNEXUS_VERSION="$(gitnexus --version 2>/dev/null | head -1 || echo "—")"
fi
echo "GitNexus: $(to_emoji "$GITNEXUS_STATUS") ${GITNEXUS_VERSION}"
[[ "$GITNEXUS_STATUS" == "fail" ]] && ((FAILURES++)) || true

# --- Graphify ---
GRAPHIFY_STATUS="fail"
GRAPHIFY_VERSION="—"
if [[ -f "$REPO_ROOT/graphify-out/GRAPH_REPORT.md" ]]; then
  GRAPHIFY_STATUS="ok"
fi
if command -v graphify &>/dev/null; then
  GRAPHIFY_VERSION="$(graphify --version 2>/dev/null | head -1 || echo "—")"
fi
echo "Graphify report: $(to_emoji "$GRAPHIFY_STATUS") ${GRAPHIFY_VERSION}"
[[ "$GRAPHIFY_STATUS" == "fail" ]] && ((FAILURES++)) || true

# --- MCP (names only) ---
MCP_LIST="[NEEDS VERIFICATION]"
MCP_JSON="${HOME}/.cursor/mcp.json"
if [[ -r "$MCP_JSON" && -n "${SDD_PYTHON:-}" ]]; then
  MCP_LIST="$($SDD_PYTHON - <<'PY' "$MCP_JSON"
import json, sys
try:
    with open(sys.argv[1]) as f:
        data = json.load(f)
    servers = data.get("mcpServers") or data.get("servers") or {}
    names = sorted(servers.keys()) if isinstance(servers, dict) else []
    print(", ".join(names) if names else "[none registered]")
except Exception:
    print("[NEEDS VERIFICATION]")
PY
)"
  echo "MCP servers: $MCP_LIST"
else
  echo "MCP servers: [NEEDS VERIFICATION] (~/.cursor/mcp.json not readable)"
fi

# --- Env vars (names from .env.example, presence only) ---
ENV_LINES=""
ENV_EXAMPLE="$REPO_ROOT/.env.example"
if [[ -f "$ENV_EXAMPLE" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// }" ]] && continue
    if [[ "$line" =~ ^([A-Za-z_][A-Za-z0-9_]*)= ]]; then
      var="${BASH_REMATCH[1]}"
      if [[ -n "${!var:-}" ]]; then
        ENV_LINES+="| \`${var}\` | ✅ | env present |\n"
      else
        ENV_LINES+="| \`${var}\` | ❌ | env absent |\n"
      fi
    fi
  done < "$ENV_EXAMPLE"
else
  ENV_LINES="| _(no .env.example in repo)_ | — | — |"
fi
echo "Env vars: checked from .env.example (values not read)"

# --- Session coordination scripts ---
SESSION_STATUS="ok"
for script in sdd-session-register.sh sdd-session-check.sh sdd-session-status.sh sdd-session-heartbeat.sh sdd-session-release.sh; do
  if [[ ! -x "$REPO_ROOT/scripts/$script" ]]; then
    SESSION_STATUS="fail"
    echo "Session script missing or not executable: scripts/$script"
  fi
done
if ! grep -q '.sdd/runtime' "$REPO_ROOT/.gitignore" 2>/dev/null; then
  SESSION_STATUS="fail"
  echo "Missing .sdd/runtime in .gitignore"
fi
if [[ ! -f "$REPO_ROOT/.cursor/rules/016-session-coordination.mdc" ]]; then
  SESSION_STATUS="fail"
  echo "Missing .cursor/rules/016-session-coordination.mdc"
fi
echo "Session coordination: $(to_emoji "$SESSION_STATUS")"
[[ "$SESSION_STATUS" == "fail" ]] && ((FAILURES++)) || true

# --- Install Kit ---
KIT_STATUS="fail"
KIT_VERSION="—"
if [[ -f "$REPO_ROOT/sdd-kit/MANIFEST.yaml" ]]; then
  KIT_VERSION="$(grep -E '^version:' "$REPO_ROOT/sdd-kit/MANIFEST.yaml" | head -1 | sed 's/.*"\(.*\)".*/\1/' || echo "—")"
  if [[ -x "$REPO_ROOT/sdd-kit/install.sh" && -x "$REPO_ROOT/sdd-kit/verify.sh" ]]; then
    KIT_STATUS="ok"
  fi
  echo "Install Kit: $(to_emoji "$KIT_STATUS") v${KIT_VERSION}"
else
  echo "Install Kit: ❌ (sdd-kit/MANIFEST.yaml missing)"
fi
[[ "$KIT_STATUS" == "fail" ]] && ((FAILURES++)) || true

# --- Tooling gap-check (advisory) ---
# Reports presence/absence only — never infers which integrations the project
# should have (stack-inference is v2), and gaps NEVER cause a non-zero exit.
# Rows marked `declined` in openspec/infra.md are suppressed (durable refusal).
is_declined() {
  [[ -f "$INFRA_FILE" ]] || return 1
  grep -E "^\|.*${1}" "$INFRA_FILE" 2>/dev/null | grep -qi 'declined'
}

echo ""
echo "==> Tooling gap-check (advisory — absence, not need)"

for cfg in ".mcp.json" ".cursor/mcp.json"; do
  if [[ -f "$REPO_ROOT/$cfg" ]]; then
    echo "  MCP config: ${cfg} present"
  else
    echo "  MCP config: ${cfg} absent"
  fi
done

if [[ -f "$INFRA_FILE" ]]; then
  MANIFEST_CLIS="$(grep -oE '`npx (-y )?[A-Za-z0-9@/_.-]+' "$INFRA_FILE" | awk '{print $NF}' | sed 's|^@[^/]*/||' | sort -u || true)"
  if command -v graphify &>/dev/null || grep -q 'graphify' "$INFRA_FILE"; then
    MANIFEST_CLIS="$(printf '%s\ngraphify' "$MANIFEST_CLIS" | sort -u)"
  fi
  for cli in $MANIFEST_CLIS; do
    if is_declined "$cli"; then
      continue
    fi
    if command -v "$cli" &>/dev/null; then
      echo "  CLI: ${cli} on PATH"
    else
      echo "  CLI: ${cli} not on PATH (npx fallback may apply)"
    fi
  done
else
  echo "  CLI check skipped: openspec/infra.md absent"
fi

if [[ -f "$ENV_EXAMPLE" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^[[:space:]]*#[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)= ]]; then
      echo "  Env key: ${BASH_REMATCH[1]} commented out in .env.example — considered and declined"
    elif [[ "$line" =~ ^([A-Za-z_][A-Za-z0-9_]*)= ]]; then
      key="${BASH_REMATCH[1]}"
      if is_declined "$key"; then continue; fi
      echo "  Env key: ${key} declared in .env.example"
    fi
  done < "$ENV_EXAMPLE"
else
  echo "  Env keys: .env.example absent — no keys declared"
fi
echo "  (gap-check is report-only; see doc/tooling-install.md for per-tool setup)"

# --- Update infra.md timestamps and status markers ---
if [[ "$WRITE_MODE" -eq 0 ]]; then
  echo ""
  echo "Report-only run (stdout is not a TTY and --write was not passed):"
  echo "openspec/infra.md left unchanged. Pass --write to update the manifest."
  echo ""
  if [[ "$FAILURES" -eq 0 ]]; then
    echo "Summary: all core SDD checks passed ✅"
  else
    echo "Summary: ${FAILURES} check(s) failed ❌ (advisory — manifest not updated)"
  fi
  exit 0
fi

if [[ -f "$INFRA_FILE" ]]; then
  # Temp file + mv, never in-place editing (portable on GNU and BSD alike, no probe).
  INFRA_TMP="$(mktemp)"
  sed "s|> Last verified: .* · Script:|> Last verified: ${TODAY} · Script:|" "$INFRA_FILE" > "$INFRA_TMP" && mv "$INFRA_TMP" "$INFRA_FILE"
  replace_between "$INFRA_FILE" "openspec-version" "$OPENSPEC_VERSION"
  replace_between "$INFRA_FILE" "openspec-status" "$(to_emoji "$OPENSPEC_STATUS")"
  replace_between "$INFRA_FILE" "gitnexus-version" "$GITNEXUS_VERSION"
  replace_between "$INFRA_FILE" "gitnexus-status" "$(to_emoji "$GITNEXUS_STATUS")"
  replace_between "$INFRA_FILE" "graphify-version" "$GRAPHIFY_VERSION"
  replace_between "$INFRA_FILE" "graphify-status" "$(to_emoji "$GRAPHIFY_STATUS")"
  replace_between "$INFRA_FILE" "mcp-list" "$MCP_LIST"
  if grep -q 'kit-version' "$INFRA_FILE" 2>/dev/null; then
    replace_between "$INFRA_FILE" "kit-version" "$KIT_VERSION"
    replace_between "$INFRA_FILE" "kit-status" "$(to_emoji "$KIT_STATUS")"
    replace_between "$INFRA_FILE" "kit-install-status" "$(to_emoji "$KIT_STATUS")"
    replace_between "$INFRA_FILE" "kit-verify-status" "$(to_emoji "$KIT_STATUS")"
  fi
  if [[ -n "$ENV_LINES" && "$ENV_LINES" != *"no .env.example"* && -n "${SDD_PYTHON:-}" ]]; then
    $SDD_PYTHON - <<PY "$INFRA_FILE" "$ENV_LINES"
import re, sys
path, rows = sys.argv[1], sys.argv[2].strip()
# newline="" on read AND write: default text mode would rewrite every line
# ending in the file just to swap one table (design D4 — the observed
# 153-line diff for a 4-line change came from exactly this block)
text = open(path, newline="").read()
block = "| Variable | Present | Verify with |\n|----------|----------|---------------|\n" + rows.replace("\\n", "\n")
text = re.sub(
    r"(\| Variable \| Present \| Verify with \|\n\|[-| ]+\|\n)(.*?)(\n## Agent rule)",
    block + r"\3",
    text,
    count=1,
    flags=re.DOTALL,
)
open(path, "w", newline="").write(text)
PY
  fi
  echo ""
  echo "Updated: openspec/infra.md (timestamp ${TODAY})"
else
  echo "WARN: $INFRA_FILE not found — create it first"
  ((FAILURES++)) || true
fi

echo ""
if [[ "$FAILURES" -eq 0 ]]; then
  echo "Summary: all core SDD checks passed ✅"
  exit 0
else
  echo "Summary: ${FAILURES} check(s) failed ❌ — review openspec/infra.md"
  exit 1
fi
