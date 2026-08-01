#!/usr/bin/env bash
# Report the next translate-guide-wave-N pending /opsx:apply on the current branch.
# Used by Cursor Automation B-guide (doc/i18n/CURSOR-AUTOMATIONS.md §5.2.1).
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

emit_json() {
  local change_id="$1" wave="$2" slice_start="$3" slice_end="$4" incomplete="$5"
  printf '{"change_id":"%s","wave":%s,"slice_start":%s,"slice_end":%s,"incomplete_tasks":%s,"gate":"bash scripts/verify-i18n-wave.sh --files doc/byebyevibe-guide.md --slice %s-%s"}\n' \
    "$(json_escape "$change_id")" "$wave" "$slice_start" "$slice_end" "$incomplete" "$slice_start" "$slice_end"
}

for n in $(seq 2 99); do
  change_id="translate-guide-wave-${n}"
  change_dir="openspec/changes/${change_id}"
  tasks_file="${change_dir}/tasks.md"

  if [[ ! -f "$tasks_file" ]]; then
    continue
  fi

  incomplete="$(grep -c '^- \[ \]' "$tasks_file" || true)"
  if [[ "${incomplete}" -eq 0 ]]; then
    continue
  fi

  slice_line="$(grep -m1 -E 'lines \*\*[0-9]+[–-][0-9]+\*\*' "$tasks_file" || true)"
  if [[ -z "$slice_line" ]]; then
    echo "error: could not parse slice from ${tasks_file}" >&2
    exit 2
  fi

  slice_range="$(printf '%s' "$slice_line" | sed -E 's/.*\*\*([0-9]+)[–-]([0-9]+)\*\*.*/\1-\2/')"
  slice_start="${slice_range%-*}"
  slice_end="${slice_range#*-}"

  if [[ "${1:-}" == "--json" ]]; then
    emit_json "$change_id" "$n" "$slice_start" "$slice_end" "$incomplete"
  else
    echo "CHANGE_ID=${change_id}"
    echo "WAVE=${n}"
    echo "SLICE=${slice_start}-${slice_end}"
    echo "INCOMPLETE_TASKS=${incomplete}"
    echo "GATE=bash scripts/verify-i18n-wave.sh --files doc/byebyevibe-guide.md --slice ${slice_start}-${slice_end}"
  fi
  exit 0
done

echo "IDLE: no pending translate-guide-wave-* apply waves" >&2
exit 1
