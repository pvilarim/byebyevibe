#!/usr/bin/env bash
# Validate SDD session conflicts before writes — see design.md conflict rules
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/sdd-session-lib.sh
source "$SCRIPT_DIR/sdd-session-lib.sh"

PHASE=""
CHANGE_ID=""
SESSION_ID_ARG=""
CLEAN_STALE=false

usage() {
  echo "Usage: $0 --phase <explore|propose|apply> [--change-id <id>] [--session-id <id>] [--clean-stale]" >&2
  exit 2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --phase) PHASE="${2:-}"; shift 2 ;;
    --change-id) CHANGE_ID="${2:-}"; shift 2 ;;
    --session-id) SESSION_ID_ARG="${2:-}"; shift 2 ;;
    --clean-stale) CLEAN_STALE=true; shift ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $1" >&2; usage ;;
  esac
done

[[ -n "$PHASE" ]] || usage

sdd_session_init_paths

if [[ "$PHASE" != "apply" ]]; then
  exit 0
fi

# Self-identification: prefer the explicit --session-id captured from
# register.sh's stdout. Falling back to the shared current-session pointer is
# ambiguous whenever more than one session is registered on this worktree
# (e.g. explore + apply running concurrently) — it may point at a *different*
# session, which would make this apply session see its own always-alive
# lock_holder_pid as an external conflict and block on itself.
CURRENT_ID="$SESSION_ID_ARG"
if [[ -z "$CURRENT_ID" ]]; then
  CURRENT_ID="$(sdd_session_current_id)"
  [[ -n "$CURRENT_ID" ]] && sdd_session_warn_if_shared_pointer_ambiguous
fi

# Conflict detection for apply sessions is authoritative: a session is a real
# conflict iff its lock_holder_pid (the background flock holder started by
# sdd-session-register.sh) is alive. Heartbeat freshness is not used to decide
# apply conflicts — a crashed session's lock holder is dead regardless of how
# recently it last sent a heartbeat, and a long-running apply without a
# heartbeat must still block correctly.
shopt -s nullglob
for session_file in "$SESSIONS_DIR"/*.json; do
  [[ -f "$session_file" ]] || continue

  other_phase="$(sdd_session_read_json_field "$session_file" phase)"
  [[ "$other_phase" == "apply" ]] || continue

  other_worktree="$(sdd_session_read_json_field "$session_file" worktree_path)"
  [[ "$other_worktree" == "$REPO_ROOT" ]] || continue

  other_id="$(sdd_session_read_json_field "$session_file" session_id)"
  if [[ -n "$CURRENT_ID" && "$other_id" == "$CURRENT_ID" ]]; then
    continue
  fi

  other_change="$(sdd_session_read_json_field "$session_file" change_id)"
  other_lock_holder_pid="$(sdd_session_read_json_field "$session_file" lock_holder_pid)"

  if sdd_session_is_pid_alive "$other_lock_holder_pid"; then
    echo "ERROR: apply session $other_id active (change=$other_change) on same worktree — wait or use a separate git worktree (see doc/sistema-sdd-pedro.md §3.3)" >&2
    exit 1
  fi

  other_hb="$(sdd_session_read_json_field "$session_file" heartbeat_at)"
  age="$(sdd_session_heartbeat_age_seconds "$other_hb")"
  echo "WARN: stale session $other_id (change=$other_change) — lock holder PID $other_lock_holder_pid dead, heartbeat ${age}s ago" >&2
  if $CLEAN_STALE; then
    rm -f "$session_file"
  fi
done

exit 0
