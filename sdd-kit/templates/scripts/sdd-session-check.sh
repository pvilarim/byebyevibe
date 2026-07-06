#!/usr/bin/env bash
# Validate SDD session conflicts before writes — see design.md conflict rules
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/sdd-session-lib.sh
source "$SCRIPT_DIR/sdd-session-lib.sh"

PHASE=""
CHANGE_ID=""
CLEAN_STALE=false
HEARTBEAT_TTL=300

usage() {
  echo "Usage: $0 --phase <explore|propose|apply> [--change-id <id>] [--clean-stale]" >&2
  exit 2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --phase) PHASE="${2:-}"; shift 2 ;;
    --change-id) CHANGE_ID="${2:-}"; shift 2 ;;
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

# Conflict detection is done via the session-file scan below. Mutual exclusion
# is owned by sdd-session-register.sh's exclusive background lock holder; a
# non-blocking flock probe here would always collide with the current session's
# own holder (register runs before check — see rule 016-session-coordination).

shopt -s nullglob
for session_file in "$SESSIONS_DIR"/*.json; do
  [[ -f "$session_file" ]] || continue

  other_phase="$(sdd_session_read_json_field "$session_file" phase)"
  [[ "$other_phase" == "apply" ]] || continue

  other_worktree="$(sdd_session_read_json_field "$session_file" worktree_path)"
  [[ "$other_worktree" == "$REPO_ROOT" ]] || continue

  other_id="$(sdd_session_read_json_field "$session_file" session_id)"
  other_change="$(sdd_session_read_json_field "$session_file" change_id)"
  other_pid="$(sdd_session_read_json_field "$session_file" pid)"
  other_hb="$(sdd_session_read_json_field "$session_file" heartbeat_at)"
  age="$(sdd_session_heartbeat_age_seconds "$other_hb")"

  current_id="$(sdd_session_current_id)"
  if [[ -n "$current_id" && "$other_id" == "$current_id" ]]; then
    continue
  fi

  if [[ "$age" -gt "$HEARTBEAT_TTL" ]] && ! sdd_session_is_pid_alive "$other_pid"; then
    echo "WARN: stale session $other_id (change=$other_change) — heartbeat ${age}s ago, PID $other_pid dead" >&2
    if $CLEAN_STALE; then
      rm -f "$session_file"
    fi
    continue
  fi

  if [[ "$age" -le "$HEARTBEAT_TTL" ]]; then
    echo "ERROR: apply session $other_id active (change=$other_change) on same worktree — wait or use a separate git worktree (see doc/sistema-sdd-pedro.md §3.3)" >&2
    exit 1
  fi
done

exit 0
