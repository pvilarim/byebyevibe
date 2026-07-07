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
  rm -f "$SESSION_FILE"

  # Only clear the shared pointer if it still points at the session we just
  # released — a second session may have overwritten it in the meantime, and
  # clobbering that value would orphan the other session's own release/
  # heartbeat calls that fall back to the pointer.
  if [[ "$(sdd_session_current_id)" == "$SESSION_ID" ]]; then
    rm -f "$CURRENT_SESSION_FILE"
  fi

  echo "Released session $SESSION_ID"
else
  echo "No current session to release."
fi

# Stop the worktree's lock holder iff no OTHER apply session file remains for
# this worktree. This covers both "we just released the apply session that
# owned it" and "no session could be resolved at all but a lock holder is
# still running orphaned" (e.g. the session file was already missing) —
# without ever stopping a lock that a still-active, different apply session
# on this worktree depends on. Our own file (if any) was already removed
# above, so it is never counted as "other" here.
if ! sdd_session_has_other_apply_session ""; then
  sdd_session_stop_lock_holder
fi
