#!/usr/bin/env bash
# Shared helpers for SDD session coordination — see openspec/changes/add-sdd-session-coordination/
set -euo pipefail

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
    python3 - <<'PY'
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
  python3 - <<'PY' "$heartbeat"
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
  python3 - <<'PY' "$file" "$field"
import json, sys
path, field = sys.argv[1], sys.argv[2]
try:
    with open(path) as f:
        data = json.load(f)
    val = data.get(field, "")
    if val is None:
        val = ""
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
  python3 - <<'PY' "$file"
import json, os, sys
path = sys.argv[1]
lock_holder_pid_raw = os.environ.get("SDD_LOCK_HOLDER_PID", "")
payload = {
    "session_id": os.environ["SDD_SESSION_ID"],
    "phase": os.environ["SDD_PHASE"],
    "change_id": os.environ["SDD_CHANGE_ID"],
    "worktree_path": os.environ["SDD_WORKTREE_PATH"],
    "branch": os.environ["SDD_BRANCH"],
    "paths_scope": os.environ.get("SDD_PATHS_SCOPE", "").split(",") if os.environ.get("SDD_PATHS_SCOPE") else [],
    # Informational only — this is register.sh's own PID, which exits right
    # after writing this file. NOT a liveness signal (see lock_holder_pid).
    "pid": int(os.environ["SDD_PID"]),
    # Authoritative liveness signal for phase=apply: the background flock
    # holder started by sdd_session_start_lock_holder, alive for the whole
    # session. Empty/null for explore/propose (no lock holder is started).
    "lock_holder_pid": int(lock_holder_pid_raw) if lock_holder_pid_raw else None,
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

  # Redirect the holder's own stdin/stdout/stderr away from the caller's fds:
  # without this, the infinite loop keeps the caller's stdout pipe open
  # forever, hanging any `$(...)` command substitution around register.sh
  # (e.g. capturing the SESSION_ID= line) even after register.sh itself exits.
  (
    flock -x 200
    while true; do sleep 3600; done
  ) 200>"$LOCK_FILE" </dev/null >/dev/null 2>&1 &
  # Global on purpose: the caller (register.sh) reads this right after the
  # call to persist it as lock_holder_pid in the session JSON.
  LOCK_HOLDER_PID=$!
  echo "$LOCK_HOLDER_PID" > "$LOCK_HOLDER_PID_FILE"
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

# Warn when a caller falls back to the shared current-session pointer while
# more than one session is registered on this worktree — the pointer only
# ever names the most recently registered session, so heartbeat/release/check
# calls relying on it can silently target the wrong session. Prefer an
# explicit --session-id in that case.
sdd_session_warn_if_shared_pointer_ambiguous() {
  local count
  count="$(find "$SESSIONS_DIR" -maxdepth 1 -name '*.json' 2>/dev/null | wc -l | tr -d ' ')"
  if [[ "${count:-0}" -gt 1 ]]; then
    echo "WARN: using shared current-session pointer with $count sessions registered on this worktree — pass --session-id explicitly to avoid targeting the wrong session" >&2
  fi
}
