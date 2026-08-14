#!/usr/bin/env bash
# Shared helpers for SDD session coordination — see openspec/changes/add-sdd-session-coordination/
set -euo pipefail

# Python resolution (fix-consumer-install D11/9f): these helpers invoked the literal name
# `python3`, which does not exist on Windows consumers and often not on macOS either —
# already a violation of the live "resolve an interpreter by capability" requirement.
# SDD_PYTHON from the environment is trusted as-is. Unquoted expansions are deliberate:
# "py -3" is two words.
if [[ -z "${SDD_PYTHON:-}" ]]; then
  for _cand in "python3" "python3.14" "python3.13" "python" "py -3" "/usr/bin/python3"; do
    if $_cand -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 8) else 1)' 2>/dev/null; then SDD_PYTHON="$_cand"; break; fi
  done
fi
if [[ -z "${SDD_PYTHON:-}" ]]; then
  echo "ERROR: no usable Python interpreter (tried: python3, python3.14, python3.13, python, py -3, /usr/bin/python3; kit minimum 3.8)." >&2
  exit 1
fi
export SDD_PYTHON

sdd_session_repo_root() {
  cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}

sdd_session_init_paths() {
  REPO_ROOT="$(sdd_session_repo_root)"
  RUNTIME_DIR="$REPO_ROOT/.sdd/runtime"
  SESSIONS_DIR="$RUNTIME_DIR/sessions"
  LOCK_FILE="$RUNTIME_DIR/apply.lock"
  LOCK_HOLDER_PID_FILE="$RUNTIME_DIR/lock-holder.pid"
  CURRENT_SESSION_FILE="$RUNTIME_DIR/current-session.id"
  mkdir -p "$SESSIONS_DIR"
}

sdd_session_now_iso() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

sdd_session_branch() {
  git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown"
}

sdd_session_uuid() {
  if command -v uuidgen &>/dev/null; then
    uuidgen | tr '[:upper:]' '[:lower:]'
  else
    $SDD_PYTHON - <<'PY'
import uuid
print(uuid.uuid4())
PY
  fi
}

sdd_session_is_pid_alive() {
  local pid="$1"
  [[ -n "$pid" && "$pid" =~ ^[0-9]+$ ]] || return 1
  kill -0 "$pid" 2>/dev/null
}

sdd_session_heartbeat_age_seconds() {
  local heartbeat="$1"
  $SDD_PYTHON - <<'PY' "$heartbeat"
import sys
from datetime import datetime, timezone

hb = sys.argv[1].replace("Z", "+00:00")
try:
    ts = datetime.fromisoformat(hb)
    if ts.tzinfo is None:
        ts = ts.replace(tzinfo=timezone.utc)
    now = datetime.now(timezone.utc)
    print(int((now - ts).total_seconds()))
except Exception:
    print(999999)
PY
}

sdd_session_read_json_field() {
  local file="$1" field="$2"
  $SDD_PYTHON - <<'PY' "$file" "$field"
import json, sys
path, field = sys.argv[1], sys.argv[2]
try:
    with open(path) as f:
        data = json.load(f)
    val = data.get(field, "")
    if isinstance(val, list):
        print(",".join(val))
    else:
        print(val)
except Exception:
    print("")
PY
}

sdd_session_write_json() {
  local file="$1"
  $SDD_PYTHON - <<'PY' "$file"
import json, os, sys
path = sys.argv[1]
payload = {
    "session_id": os.environ["SDD_SESSION_ID"],
    "phase": os.environ["SDD_PHASE"],
    "change_id": os.environ["SDD_CHANGE_ID"],
    "worktree_path": os.environ["SDD_WORKTREE_PATH"],
    "branch": os.environ["SDD_BRANCH"],
    "paths_scope": os.environ.get("SDD_PATHS_SCOPE", "").split(",") if os.environ.get("SDD_PATHS_SCOPE") else [],
    "pid": int(os.environ["SDD_PID"]),
    "started_at": os.environ["SDD_STARTED_AT"],
    "heartbeat_at": os.environ["SDD_HEARTBEAT_AT"],
}
with open(path, "w") as f:
    json.dump(payload, f, indent=2)
    f.write("\n")
PY
}

sdd_session_start_lock_holder() {
  if [[ -f "$LOCK_HOLDER_PID_FILE" ]]; then
    local existing
    existing="$(cat "$LOCK_HOLDER_PID_FILE" 2>/dev/null || true)"
    if sdd_session_is_pid_alive "$existing"; then
      return 1
    fi
  fi

  # flock is best-effort (D11/9e): it does not exist on macOS, and Git Bash on Windows
  # ships without it. Letting the subshell fail invisibly made the advisory lock look
  # held when it never was. The PID-file mechanism below is the guaranteed layer and is
  # unchanged — it is what actually blocks a second apply on the same worktree.
  if command -v flock &>/dev/null; then
    (
      flock -x 200
      while true; do sleep 3600; done
    ) 200>"$LOCK_FILE" &
  else
    echo "INFO: flock is not available on this platform — the advisory lock was not taken; the PID-file check is the active guard." >&2
    (
      while true; do sleep 3600; done
    ) &
  fi
  echo $! > "$LOCK_HOLDER_PID_FILE"
}

sdd_session_stop_lock_holder() {
  if [[ -f "$LOCK_HOLDER_PID_FILE" ]]; then
    local pid
    pid="$(cat "$LOCK_HOLDER_PID_FILE" 2>/dev/null || true)"
    if sdd_session_is_pid_alive "$pid"; then
      kill "$pid" 2>/dev/null || true
      wait "$pid" 2>/dev/null || true
    fi
    rm -f "$LOCK_HOLDER_PID_FILE"
  fi
}

sdd_session_current_id() {
  if [[ -f "$CURRENT_SESSION_FILE" ]]; then
    cat "$CURRENT_SESSION_FILE"
  fi
}
