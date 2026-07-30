#!/usr/bin/env bash
# Compare curated SDD files in the repo with staging copies or sdd-kit/templates/.
# Usage: ./scripts/sdd-upgrade-diff.sh [STAGING_DIR] [REPO_ROOT]
# See doc/sistema-sdd-pedro.md §2.9.5 and §12.9

set -euo pipefail

REPO_ROOT="${2:-.}"
STAGING_DIR="${1:-}"
cd "$REPO_ROOT"

GUIDE_VERSION=""
if [[ -f openspec/project.md ]]; then
  GUIDE_VERSION="$(grep -oE 'sistema-sdd-pedro\.md[^v]*v[0-9]+\.[0-9]+\.[0-9]+' openspec/project.md 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"
fi

echo "=== SDD upgrade diff ==="
echo "Repo: $(pwd)"
echo "Guide referenced in project.md: ${GUIDE_VERSION:-[not detected]}"
echo ""

# Build curated file list from MANIFEST.yaml when present, else fallback
CURATED_FILES=()
MANIFEST="sdd-kit/MANIFEST.yaml"
if [[ -f "$MANIFEST" ]]; then
  while IFS= read -r path; do
    [[ -n "$path" ]] && CURATED_FILES+=("$path")
  done < <(python3 - <<'PY' "$MANIFEST"
import sys, re
text = open(sys.argv[1]).read()
for line in text.splitlines():
    m = re.match(r"\s+-\s+path:\s+(.+)", line) or re.match(r"\s+path:\s+(.+)", line)
    if m:
        print(m.group(1).strip())
PY
)
  echo "Inventory source: sdd-kit/MANIFEST.yaml (${#CURATED_FILES[@]} files)"
else
  CURATED_FILES=(
    "AGENTS.md"
    "CLAUDE.md"
    "openspec/project.md"
    "openspec/infra.md"
    ".cursor/rules/000-base.mdc"
    ".cursor/rules/015-session-phases.mdc"
    ".cursor/rules/016-session-coordination.mdc"
    ".cursor/rules/050-security.mdc"
    ".cursor/rules/010-typescript.mdc"
    ".cursor/rules/020-python.mdc"
    ".cursor/rules/030-supabase.mdc"
    ".cursor/rules/graphify.mdc"
    "scripts/verify-infra.sh"
    "scripts/verify-task-patterns.sh"
    "scripts/sdd-session-check.sh"
    "scripts/sdd-session-status.sh"
  )
  echo "Inventory source: built-in list (MANIFEST missing)"
fi

GENERATED_OK=(
  "openspec/AGENTS.md"
  ".cursor/commands"
  ".claude/commands"
)

echo ""
echo "--- Inventory (curated files) ---"
for f in "${CURATED_FILES[@]}"; do
  if [[ -f "$f" ]]; then
    lines=$(wc -l < "$f" | tr -d ' ')
    sha=$(sha256sum "$f" | awk '{print $1}')
    printf "  OK  %-40s %4s lines  %s\n" "$f" "$lines" "${sha:0:12}…"
  else
    printf "  --  %-40s (missing)\n" "$f"
  fi
done

echo ""
echo "--- Generated harness (may be overwritten by openspec update) ---"
for f in "${GENERATED_OK[@]}"; do
  if [[ -e "$f" ]]; then
    echo "  OK  $f"
  else
    echo "  --  $f (missing)"
  fi
done

if [[ -z "$STAGING_DIR" ]]; then
  echo ""
  echo "No STAGING_DIR: inventory only."
  echo "For unified diff, use sdd-kit/templates/ or local staging:"
  echo "  $0 sdd-kit/templates"
  echo "  $0 openspec/changes/upgrade-sdd-vX.Y.Z/sdd-staging"
  exit 0
fi

if [[ ! -d "$STAGING_DIR" ]]; then
  echo "ERROR: STAGING_DIR does not exist: $STAGING_DIR" >&2
  exit 1
fi

echo ""
echo "--- Diff vs staging: $STAGING_DIR ---"
DIFF_FOUND=0
for f in "${CURATED_FILES[@]}"; do
  staging="$STAGING_DIR/$f"
  # templates/ uses templates/ prefix in manifest sources — try both paths
  if [[ ! -f "$staging" && -f "$STAGING_DIR/templates/$f" ]]; then
    staging="$STAGING_DIR/templates/$f"
  fi
  if [[ ! -f "$staging" ]]; then
    continue
  fi
  if [[ ! -f "$f" ]]; then
    echo ""
    echo ">>> NEW (staging only): $f"
    head -20 "$staging"
    DIFF_FOUND=1
    continue
  fi
  if ! diff -u "$f" "$staging" > /tmp/sdd-diff-"${f//\//_}.patch" 2>/dev/null; then
    echo ""
    echo ">>> DIFF: $f"
    diff -u "$f" "$staging" | head -80 || true
    echo "    (full diff: /tmp/sdd-diff-${f//\//_}.patch)"
    DIFF_FOUND=1
  else
    echo "  =   $f (same as staging)"
  fi
done

if [[ "$DIFF_FOUND" -eq 0 ]]; then
  echo ""
  echo "No differences in the curated files compared."
fi
