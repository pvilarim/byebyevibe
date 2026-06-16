#!/usr/bin/env bash
# Idempotent SDD infrastructure verification — see openspec/infra.md
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"
INFRA_FILE="$REPO_ROOT/openspec/infra.md"
TODAY="$(date +%Y-%m-%d)"
FAILURES=0

mark_ok() { echo "ok"; }
mark_fail() { echo "fail"; ((FAILURES++)) || true; }

to_emoji() {
  if [[ "$1" == "ok" ]]; then echo "✅"; else echo "❌"; fi
}

replace_between() {
  local file="$1" marker="$2" value="$3"
  [[ -f "$file" ]] || return
  sed -i "s|<!-- ${marker} -->.*<!-- /${marker} -->|<!-- ${marker} -->${value}<!-- /${marker} -->|" "$file"
}

echo "==> verify-infra.sh ($TODAY)"

# --- OpenSpec ---
OPENSPEC_STATUS="fail"
OPENSPEC_VERSION="—"
if npx openspec list &>/dev/null; then
  OPENSPEC_STATUS="ok"
  OPENSPEC_VERSION="$(npx openspec --version 2>/dev/null || echo "—")"
fi
echo "OpenSpec: $(to_emoji "$OPENSPEC_STATUS") ${OPENSPEC_VERSION}"
[[ "$OPENSPEC_STATUS" == "fail" ]] && ((FAILURES++)) || true

# --- GitNexus ---
GITNEXUS_STATUS="fail"
GITNEXUS_VERSION="—"
if GN_OUT="$(npx gitnexus status 2>&1)"; then
  if echo "$GN_OUT" | grep -qi "up-to-date"; then
    GITNEXUS_STATUS="ok"
  fi
  GITNEXUS_VERSION="$(npx gitnexus --version 2>/dev/null | head -1 || echo "—")"
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
if [[ -r "$MCP_JSON" ]] && command -v python3 &>/dev/null; then
  MCP_LIST="$(python3 - <<'PY' "$MCP_JSON"
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
  ENV_LINES="| _(sem .env.example no repo)_ | — | — |"
fi
echo "Env vars: checked from .env.example (values not read)"

# --- Update infra.md timestamps and status markers ---
if [[ -f "$INFRA_FILE" ]]; then
  sed -i "s|> Última verificação: .* · Script:|> Última verificação: ${TODAY} · Script:|" "$INFRA_FILE"
  replace_between "$INFRA_FILE" "openspec-version" "$OPENSPEC_VERSION"
  replace_between "$INFRA_FILE" "openspec-status" "$(to_emoji "$OPENSPEC_STATUS")"
  replace_between "$INFRA_FILE" "gitnexus-version" "$GITNEXUS_VERSION"
  replace_between "$INFRA_FILE" "gitnexus-status" "$(to_emoji "$GITNEXUS_STATUS")"
  replace_between "$INFRA_FILE" "graphify-version" "$GRAPHIFY_VERSION"
  replace_between "$INFRA_FILE" "graphify-status" "$(to_emoji "$GRAPHIFY_STATUS")"
  replace_between "$INFRA_FILE" "mcp-list" "$MCP_LIST"
  if [[ -n "$ENV_LINES" && "$ENV_LINES" != *"sem .env.example"* ]]; then
    python3 - <<PY "$INFRA_FILE" "$ENV_LINES"
import re, sys
path, rows = sys.argv[1], sys.argv[2].strip()
text = open(path).read()
block = "| Variável | Presente | Verificar com |\n|----------|----------|---------------|\n" + rows.replace("\\n", "\n")
text = re.sub(
    r"(\| Variável \| Presente \| Verificar com \|\n\|[-| ]+\|\n)(.*?)(\n## Regra agentes)",
    block + r"\3",
    text,
    count=1,
    flags=re.DOTALL,
)
open(path, "w").write(text)
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
