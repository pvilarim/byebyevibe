#!/usr/bin/env bash
# Register SDD session presence and acquire apply lock — see design.md D1/D3
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/sdd-session-lib.sh
source "$SCRIPT_DIR/sdd-session-lib.sh"

PHASE=""
CHANGE_ID=""

usage() {
  echo "Usage: $0 --phase <explore|propose|apply> --change-id <id>" >&2
  exit 2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --phase) PHASE="${2:-}"; shift 2 ;;
    --change-id) CHANGE_ID="${2:-}"; shift 2 ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $1" >&2; usage ;;
  esac
done

[[ -n "$PHASE" && -n "$CHANGE_ID" ]] || usage

sdd_session_init_paths

SESSION_ID="$(sdd_session_uuid)"
NOW="$(sdd_session_now_iso)"
WORKTREE="$REPO_ROOT"
BRANCH="$(sdd_session_branch)"
PATHS_SCOPE="openspec/changes/${CHANGE_ID}/**"

export SDD_SESSION_ID="$SESSION_ID"
export SDD_PHASE="$PHASE"
export SDD_CHANGE_ID="$CHANGE_ID"
export SDD_WORKTREE_PATH="$WORKTREE"
export SDD_BRANCH="$BRANCH"
export SDD_PATHS_SCOPE="$PATHS_SCOPE"
export SDD_PID="$$"
export SDD_STARTED_AT="$NOW"
export SDD_HEARTBEAT_AT="$NOW"

SESSION_FILE="$SESSIONS_DIR/${SESSION_ID}.json"
sdd_session_write_json "$SESSION_FILE"
echo "$SESSION_ID" > "$CURRENT_SESSION_FILE"

if [[ "$PHASE" == "apply" ]]; then
  if ! sdd_session_start_lock_holder; then
    echo "ERROR: another apply session holds the lock on this worktree ($WORKTREE)" >&2
    rm -f "$SESSION_FILE" "$CURRENT_SESSION_FILE"
    exit 1
  fi
fi

echo "Registered session $SESSION_ID (phase=$PHASE, change=$CHANGE_ID)"
