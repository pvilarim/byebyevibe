#!/usr/bin/env bash
# Update heartbeat for current SDD session
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/sdd-session-lib.sh
source "$SCRIPT_DIR/sdd-session-lib.sh"

sdd_session_init_paths

SESSION_ID="$(sdd_session_current_id)"
if [[ -z "$SESSION_ID" ]]; then
  echo "WARN: no current session registered (missing $CURRENT_SESSION_FILE)" >&2
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
data["pid"] = __import__("os").getpid()
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY

echo "Heartbeat updated for session $SESSION_ID"
