#!/usr/bin/env bash
# Release SDD session lock and presence JSON
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/sdd-session-lib.sh
source "$SCRIPT_DIR/sdd-session-lib.sh"

sdd_session_init_paths

SESSION_ID="$(sdd_session_current_id)"
if [[ -n "$SESSION_ID" ]]; then
  rm -f "$SESSIONS_DIR/${SESSION_ID}.json"
  rm -f "$CURRENT_SESSION_FILE"
  echo "Released session $SESSION_ID"
else
  echo "No current session to release."
fi

sdd_session_stop_lock_holder
