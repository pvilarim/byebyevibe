#!/usr/bin/env bash
# Release SDD session lock and presence JSON
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
USING_SHARED_POINTER=false
if [[ -z "$SESSION_ID" ]]; then
  SESSION_ID="$(sdd_session_current_id)"
  USING_SHARED_POINTER=true
  [[ -n "$SESSION_ID" ]] && sdd_session_warn_if_shared_pointer_ambiguous
fi

if [[ -n "$SESSION_ID" ]]; then
  SESSION_FILE="$SESSIONS_DIR/${SESSION_ID}.json"
  RELEASED_PHASE="$(sdd_session_read_json_field "$SESSION_FILE" phase)"

  rm -f "$SESSION_FILE"

  # Only clear the shared pointer if it still points at the session we just
  # released — a second session may have overwritten it in the meantime, and
  # clobbering that value would orphan the other session's own release/
  # heartbeat calls that fall back to the pointer.
  if [[ "$(sdd_session_current_id)" == "$SESSION_ID" ]]; then
    rm -f "$CURRENT_SESSION_FILE"
  fi

  echo "Released session $SESSION_ID"

  # Only stop the worktree's lock holder if the session we released actually
  # started one (phase=apply). Releasing an explore/propose session running
  # alongside an active apply session on the same worktree MUST NOT kill the
  # apply session's lock.
  if [[ "$RELEASED_PHASE" == "apply" ]]; then
    sdd_session_stop_lock_holder
  fi
else
  echo "No current session to release."
fi
