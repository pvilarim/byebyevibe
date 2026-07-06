#!/usr/bin/env bash
# Update heartbeat for current SDD session
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/sdd-session-lib.sh
source "$SCRIPT_DIR/sdd-session-lib.sh"

SESSION_ID_ARG=""

usage() {
  echo "Usage: $0 [--session-id <id>]" >&2
  exit 2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --session-id) SESSION_ID_ARG="${2:-}"; shift 2 ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $1" >&2; usage ;;
  esac
done

sdd_session_init_paths

# Prefer the explicit --session-id captured from register.sh's stdout. The
# shared current-session pointer only ever names the most recently registered
# session on this worktree, so it can silently target the wrong session when
# more than one is active (see rule 016-session-coordination).
SESSION_ID="$SESSION_ID_ARG"
if [[ -z "$SESSION_ID" ]]; then
  SESSION_ID="$(sdd_session_current_id)"
  [[ -n "$SESSION_ID" ]] && sdd_session_warn_if_shared_pointer_ambiguous
fi

if [[ -z "$SESSION_ID" ]]; then
  echo "WARN: no session id provided and no current session registered (missing $CURRENT_SESSION_FILE) — pass --session-id" >&2
  exit 0
fi

SESSION_FILE="$SESSIONS_DIR/${SESSION_ID}.json"
if [[ ! -f "$SESSION_FILE" ]]; then
  echo "WARN: session file not found for $SESSION_ID" >&2
  exit 0
fi

NOW="$(sdd_session_now_iso)"
python3 - <<'PY' "$SESSION_FILE" "$NOW"
import json, sys
path, now = sys.argv[1], sys.argv[2]
with open(path) as f:
    data = json.load(f)
data["heartbeat_at"] = now
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY

echo "Heartbeat updated for session $SESSION_ID"
