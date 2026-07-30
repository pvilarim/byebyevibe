#!/usr/bin/env bash
# Archive one completed OpenSpec change, push branch, and print PR instructions.
# Merge is operator-only on GitHub — see doc/i18n/CURSOR-AUTOMATIONS.md §3.
set -euo pipefail

CHANGE="${1:?usage: archive-and-merge.sh <change-id>}"
DATE="${2:-$(date +%Y-%m-%d)}"
SUFFIX="e452"
BRANCH="cursor/archive-${CHANGE}-${SUFFIX}"
ARCHIVE_DIR="openspec/changes/archive/${DATE}-${CHANGE}"

if [[ ! -d "openspec/changes/${CHANGE}" ]]; then
  echo "SKIP: ${CHANGE} not in openspec/changes/"
  exit 0
fi

if [[ -d "${ARCHIVE_DIR}" ]]; then
  echo "SKIP: ${ARCHIVE_DIR} already exists"
  exit 0
fi

git checkout master
git pull origin master --quiet

git checkout -B "$BRANCH" master
mv "openspec/changes/${CHANGE}" "${ARCHIVE_DIR}"

OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict

git add -A
git commit -m "chore(openspec): archive ${CHANGE}"

git push -u origin "$BRANCH" --force

EXISTING=$(gh pr list --head "$BRANCH" --state open --json number -q '.[0].number' 2>/dev/null || true)
if [[ -z "$EXISTING" || "$EXISTING" == "null" ]]; then
  echo "NEEDS_PR: branch=$BRANCH change=$CHANGE"
  exit 0
fi

PR_NUM="$EXISTING"
gh pr ready "$PR_NUM" 2>/dev/null || true
git checkout master

echo "READY: archive PR #${PR_NUM} for ${CHANGE} — merge on GitHub when CI is green"
echo "URL: $(gh pr view "$PR_NUM" --json url -q .url 2>/dev/null || echo "https://github.com/pvilarim/byebyevibe/pull/${PR_NUM}")"
