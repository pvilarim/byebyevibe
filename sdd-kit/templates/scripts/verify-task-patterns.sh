#!/usr/bin/env bash
# Validate Pattern: paths in active OpenSpec tasks.md — see doc/byebyevibe-guide.md §12.10
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

FAILURES=0
WARNINGS=0
PROFILE="UNKNOWN"

# Profile detection order (D2): project.md marker -> AGENTS.md structural
# markers -> legacy string greps (pre-1.9.0 installs) -> UNKNOWN (report-only).
if grep -q 'DOCS_SPECS' "$REPO_ROOT/openspec/project.md" 2>/dev/null; then
  PROFILE="DOCS_SPECS"
elif grep -qi 'APP profile' "$REPO_ROOT/openspec/project.md" 2>/dev/null; then
  PROFILE="APP"
elif grep -q '12.2b' "$REPO_ROOT/AGENTS.md" 2>/dev/null; then
  PROFILE="DOCS_SPECS"
elif grep -q '12.2a' "$REPO_ROOT/AGENTS.md" 2>/dev/null; then
  PROFILE="APP"
elif grep -q 'DOCS_SPECS' "$REPO_ROOT/AGENTS.md" 2>/dev/null; then
  PROFILE="DOCS_SPECS"
elif grep -q 'perfil APP' "$REPO_ROOT/AGENTS.md" 2>/dev/null; then
  PROFILE="APP"
fi

if [[ "$PROFILE" == "DOCS_SPECS" ]]; then
  echo "==> verify-task-patterns.sh (profile: ${PROFILE} — fail-closed)"
else
  echo "==> verify-task-patterns.sh (profile: ${PROFILE} — report-only, enforcement is a future change)"
fi

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
    if [[ "$pattern" =~ ^doc/byebyevibe-guide\.md ]]; then
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

    resolved_path="$local_path"
    if [[ ! -e "$REPO_ROOT/$local_path" ]] \
      && [[ "$local_path" =~ ^openspec/changes/([^/]+)/(.+)$ ]] \
      && [[ "${BASH_REMATCH[1]}" != "archive" ]]; then
      change_id="${BASH_REMATCH[1]}"
      rest="${BASH_REMATCH[2]}"
      archived_dir="$(find "$REPO_ROOT/openspec/changes/archive" -maxdepth 1 -type d -name "*-${change_id}" 2>/dev/null | head -1)"
      if [[ -n "$archived_dir" && -e "$archived_dir/$rest" ]]; then
        resolved_path="${archived_dir#"$REPO_ROOT/"}/$rest"
      fi
    fi

    if [[ -e "$REPO_ROOT/$resolved_path" ]]; then
      if [[ "$resolved_path" != "$local_path" ]]; then
        echo "  OK   $resolved_path (archived; Pattern: $local_path)"
      else
        echo "  OK   $local_path"
      fi
    elif [[ "$PROFILE" == "DOCS_SPECS" ]]; then
      echo "  FAIL missing: $local_path (from Pattern: $pattern)"
      ((FAILURES++)) || true
    else
      echo "  WARN missing: $local_path (from Pattern: $pattern) — report-only (${PROFILE} profile)"
      ((WARNINGS++)) || true
    fi
  done < <(extract_pattern_paths "$tasks_file")
done < <(find "$REPO_ROOT/openspec/changes" -mindepth 2 -maxdepth 2 -name 'tasks.md' \
  ! -path '*/archive/*' -print0 2>/dev/null)

echo ""
if [[ "$PROFILE" == "DOCS_SPECS" ]]; then
  if [[ "$FAILURES" -eq 0 ]]; then
    echo "Summary: all verifiable Pattern paths OK ✅ (${WARNINGS} skipped/warnings)"
    exit 0
  else
    echo "Summary: ${FAILURES} Pattern check(s) failed ❌ (DOCS_SPECS profile — fail-closed)"
    exit 1
  fi
else
  echo "Summary: report-only (${PROFILE} profile) — enforcement is a future change (${WARNINGS} WARN/SKIP)"
  exit 0
fi
