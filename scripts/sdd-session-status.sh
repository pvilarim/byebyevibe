#!/usr/bin/env bash
# List active SDD sessions — human/agent readable
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/sdd-session-lib.sh
source "$SCRIPT_DIR/sdd-session-lib.sh"

HEARTBEAT_TTL=300

sdd_session_init_paths

if ! compgen -G "$SESSIONS_DIR/*.json" > /dev/null; then
  echo "No active SDD sessions registered."
  exit 0
fi

printf "%-36s %-8s %-28s %-40s %s\n" "SESSION_ID" "PHASE" "CHANGE_ID" "WORKTREE" "HEARTBEAT"
printf "%-36s %-8s %-28s %-40s %s\n" "----------" "-----" "---------" "--------" "---------"

shopt -s nullglob
for session_file in "$SESSIONS_DIR"/*.json; do
  sid="$(sdd_session_read_json_field "$session_file" session_id)"
  phase="$(sdd_session_read_json_field "$session_file" phase)"
  change="$(sdd_session_read_json_field "$session_file" change_id)"
  worktree="$(sdd_session_read_json_field "$session_file" worktree_path)"
  hb="$(sdd_session_read_json_field "$session_file" heartbeat_at)"
  pid="$(sdd_session_read_json_field "$session_file" pid)"
  age="$(sdd_session_heartbeat_age_seconds "$hb")"

  status="fresh"
  if [[ "$age" -gt "$HEARTBEAT_TTL" ]]; then
    status="stale"
  fi
  if ! sdd_session_is_pid_alive "$pid"; then
    status="${status},pid-dead"
  fi

  printf "%-36s %-8s %-28s %-40s %s (%s)\n" "$sid" "$phase" "$change" "$worktree" "$hb" "$status"
done
