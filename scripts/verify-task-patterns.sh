#!/usr/bin/env bash
# Validate Pattern: paths in active OpenSpec tasks.md — see doc/sistema-sdd-pedro.md §12.10
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

FAILURES=0
WARNINGS=0
PROFILE="UNKNOWN"

if grep -q 'DOCS_SPECS' "$REPO_ROOT/openspec/project.md" 2>/dev/null \
  || grep -q 'DOCS_SPECS' "$REPO_ROOT/AGENTS.md" 2>/dev/null; then
  PROFILE="DOCS_SPECS"
elif grep -q 'perfil APP\|12\.2a' "$REPO_ROOT/AGENTS.md" 2>/dev/null; then
  PROFILE="APP"
fi

echo "==> verify-task-patterns.sh (profile: ${PROFILE})"

extract_pattern_paths() {
  local file="$1"
  awk '/\*\*Pattern:\*\*/ {
    line = $0
    while (match(line, /`[^`]+`/)) {
      print substr(line, RSTART + 1, RLENGTH - 2)
      line = substr(line, RSTART + RLENGTH)
    }
  }' "$file"
}

while IFS= read -r -d '' tasks_file; do
  echo ""
  echo "Checking: ${tasks_file#"$REPO_ROOT"/}"
  while IFS= read -r pattern || [[ -n "$pattern" ]]; do
    [[ -z "$pattern" ]] && continue
    # Skip descriptive patterns (section refs without file extension path)
    if [[ "$pattern" =~ ^doc/sistema-sdd-pedro\.md ]]; then
      continue
    fi

    # Cross-repo: repo:path
    if [[ "$pattern" =~ ^[A-Za-z0-9_.-]+: ]]; then
      if [[ "$PROFILE" == "DOCS_SPECS" ]]; then
        echo "  FAIL cross-repo Pattern in DOCS_SPECS: $pattern"
        echo "       → use Skill (§12.10) or move APP implementation to APP repo"
        ((FAILURES++)) || true
      else
        echo "  SKIP cross-repo (not verifiable here): $pattern"
        ((WARNINGS++)) || true
      fi
      continue
    fi

    # Strip optional line suffix file:line
    local_path="${pattern%%:*}"
  local_path="${local_path#"${local_path%%[![:space:]]*}"}"

    if [[ -e "$REPO_ROOT/$local_path" ]]; then
      echo "  OK   $local_path"
    else
      echo "  FAIL missing: $local_path (from Pattern: $pattern)"
      ((FAILURES++)) || true
    fi
  done < <(extract_pattern_paths "$tasks_file")
done < <(find "$REPO_ROOT/openspec/changes" -mindepth 2 -maxdepth 2 -name 'tasks.md' \
  ! -path '*/archive/*' -print0 2>/dev/null)

echo ""
if [[ "$FAILURES" -eq 0 ]]; then
  echo "Summary: all verifiable Pattern paths OK ✅ (${WARNINGS} skipped/warnings)"
  exit 0
else
  echo "Summary: ${FAILURES} Pattern check(s) failed ❌"
  exit 1
fi
