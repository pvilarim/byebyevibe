#!/usr/bin/env bash
# ByeByeVibe (sdd-kit) — guarded release cut (add-github-release-flow, issue #350)
# Creates and pushes the single release tag `v<version>` (design D1 — one tag
# axis, taken from sdd-kit/MANIFEST.yaml `version:`), after front-loading every
# precondition for the operator's benefit.
#
# This script is convenience, NOT security (design D8): any collaborator with
# write access can push a tag with plain `git tag && git push`, so
# .github/workflows/release.yml re-derives every fact server-side from the
# tagged commit and trusts nothing about the tag's provenance.
#
# `--dry-run` runs every precondition and reports each outcome without creating
# or pushing anything, even when all of them pass (design D8a). It is both the
# operator's preflight and the mechanism that lets the guards be exercised in
# tests with no possibility of a real push.
#
# Usage: bash scripts/cut-release.sh <version> [--dry-run]
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

DEFAULT_BRANCH="master"

usage() {
  cat <<'EOF'
Usage: bash scripts/cut-release.sh <version> [--dry-run]

  <version>   MAJOR.MINOR.PATCH — must equal sdd-kit/MANIFEST.yaml version:
              and guide_version: at the current commit.
  --dry-run   Report every precondition and exit without tagging or pushing.
EOF
}

VERSION=""
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    -*)
      echo "FAIL: cut-release: unknown flag: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      if [[ -n "$VERSION" ]]; then
        echo "FAIL: cut-release: unexpected argument: $1" >&2
        exit 2
      fi
      VERSION="$1"
      ;;
  esac
  shift
done

if [[ -z "$VERSION" ]]; then
  usage >&2
  exit 2
fi

if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "FAIL: cut-release: version must be MAJOR.MINOR.PATCH, got '$VERSION'" >&2
  exit 2
fi

TAG="v$VERSION"
FAILURES=0

pass() { echo "OK: $1"; }

# In a real cut the first failed precondition aborts immediately, leaving the
# repository untouched. In --dry-run every precondition is evaluated so the
# report is complete.
fail() {
  echo "FAIL: $1" >&2
  ((FAILURES++)) || true
  if [[ "$DRY_RUN" -eq 0 ]]; then
    echo "cut-release: aborted — no tag created, repository unmodified." >&2
    exit 1
  fi
}

echo "=== scripts/cut-release.sh $TAG ==="
echo "Repo: $REPO_ROOT"
if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "Mode: --dry-run (nothing will be created or pushed)"
fi
echo ""

# --- Precondition 1: the remote is reachable ---------------------------------
# First action, so every later comparison runs against fresh refs (D8a).
if git fetch origin "$DEFAULT_BRANCH" --tags >/dev/null 2>&1; then
  pass "remote reachable (git fetch origin $DEFAULT_BRANCH --tags)"
else
  fail "remote fetch: cannot reach 'origin' — refusing to proceed on stale refs"
fi

# --- Precondition 2: clean working tree --------------------------------------
if [[ -z "$(git status --porcelain)" ]]; then
  pass "clean working tree"
else
  fail "working tree: uncommitted or untracked changes present"
fi

# --- Precondition 3: on the default branch -----------------------------------
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$CURRENT_BRANCH" == "$DEFAULT_BRANCH" ]]; then
  pass "on branch $DEFAULT_BRANCH"
else
  fail "branch: HEAD is on '$CURRENT_BRANCH'; releases are cut from '$DEFAULT_BRANCH' only"
fi

# --- Precondition 4: HEAD equals the fetched remote head exactly -------------
# "Not behind" alone would let an operator tag a commit the remote has never
# seen; the workflow's ancestry guard then fails, stranding a remote tag that
# must be hand-deleted before retry (D8a).
LOCAL_SHA="$(git rev-parse HEAD)"
REMOTE_SHA="$(git rev-parse --verify --quiet "refs/remotes/origin/$DEFAULT_BRANCH" || true)"
if [[ -z "$REMOTE_SHA" ]]; then
  fail "remote sync: origin/$DEFAULT_BRANCH could not be resolved after fetch"
elif [[ "$LOCAL_SHA" == "$REMOTE_SHA" ]]; then
  pass "HEAD equals origin/$DEFAULT_BRANCH ($LOCAL_SHA)"
else
  fail "remote sync: HEAD $LOCAL_SHA differs from origin/$DEFAULT_BRANCH $REMOTE_SHA (behind, ahead or diverged)"
fi

# --- Precondition 5: version:/guide_version: lockstep ------------------------
MANIFEST="$REPO_ROOT/sdd-kit/MANIFEST.yaml"
KIT_VER=""
GUIDE_VER=""
if [[ -f "$MANIFEST" ]]; then
  KIT_VER="$(grep -E '^version:' "$MANIFEST" | head -1 | sed 's/.*"\(.*\)".*/\1/' || true)"
  GUIDE_VER="$(grep -E '^guide_version:' "$MANIFEST" | head -1 | sed 's/.*"\(.*\)".*/\1/' || true)"
fi

if [[ ! -f "$MANIFEST" ]]; then
  fail "MANIFEST: sdd-kit/MANIFEST.yaml not found"
elif [[ -z "$KIT_VER" || -z "$GUIDE_VER" ]]; then
  fail "MANIFEST: could not parse version:/guide_version: from sdd-kit/MANIFEST.yaml"
elif [[ "$KIT_VER" != "$GUIDE_VER" ]]; then
  fail "MANIFEST lockstep: version: \"$KIT_VER\" != guide_version: \"$GUIDE_VER\" — one tag axis (design D1) cannot name two versions; align both fields, or open a change that splits the axis and says how the single guide changelog becomes two release bodies"
else
  pass "MANIFEST lockstep: version: = guide_version: = \"$KIT_VER\""
fi

# --- Precondition 6: the requested version is the one the MANIFEST declares ---
if [[ "$KIT_VER" == "$VERSION" && "$GUIDE_VER" == "$VERSION" ]]; then
  pass "requested version $VERSION matches MANIFEST version: and guide_version:"
else
  fail "requested version: $VERSION does not match MANIFEST version: \"${KIT_VER:-<unparsed>}\" / guide_version: \"${GUIDE_VER:-<unparsed>}\""
fi

# --- Precondition 7: the changelog section resolves to non-empty notes -------
NOTES_OUT=""
if NOTES_OUT="$(bash "$REPO_ROOT/scripts/release-notes.sh" "$VERSION" 2>&1)" && [[ -n "$NOTES_OUT" ]]; then
  pass "release notes: changelog section for $VERSION resolves to non-empty text"
else
  fail "release notes: scripts/release-notes.sh $VERSION failed or produced no output — ${NOTES_OUT:-<no output>}"
fi

# --- Precondition 8: repo-state readiness ------------------------------------
READINESS_OUT=""
if READINESS_OUT="$(bash "$REPO_ROOT/scripts/verify-release-readiness.sh" 2>&1)"; then
  pass "release readiness: scripts/verify-release-readiness.sh exits 0"
else
  echo "$READINESS_OUT" >&2
  fail "release readiness: scripts/verify-release-readiness.sh exited non-zero (its output is above)"
fi

# --- Precondition 9: the tag does not already exist --------------------------
# Published versions are immutable (design D10): a bad release is withdrawn by
# publishing a new patch version, never by re-cutting the same number.
if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null 2>&1; then
  fail "tag exists: local tag $TAG already exists — a published version is never re-cut (design D10)"
else
  pass "no local tag $TAG"
fi

REMOTE_TAG_LINE=""
if REMOTE_TAG_LINE="$(git ls-remote --tags origin "refs/tags/$TAG" 2>/dev/null)"; then
  if [[ -n "$REMOTE_TAG_LINE" ]]; then
    fail "tag exists: $TAG is already present on origin — a published version is never re-cut (design D10)"
  else
    pass "no remote tag $TAG on origin"
  fi
else
  fail "remote tag check: could not reach 'origin' to list tags"
fi

# --- Report / cut ------------------------------------------------------------
echo ""
if [[ "$DRY_RUN" -eq 1 ]]; then
  if [[ "$FAILURES" -eq 0 ]]; then
    echo "Dry run: all preconditions passed for $TAG — nothing created, nothing pushed ✅"
    exit 0
  fi
  echo "Dry run: $FAILURES precondition(s) failed for $TAG — nothing created, nothing pushed ❌" >&2
  exit 1
fi

# The tag message is the title only (design D8b): `git tag -a` defaults to
# --cleanup=strip, which would silently delete Markdown sub-headings from a
# changelog body, and an immutable tag message would drift from any later
# changelog edit. Notes live in the Release body alone.
git tag -a "$TAG" -m "$TAG"

# A failed push must not leave the local tag behind: precondition 9 would then
# refuse the retry with "local tag exists", pointing at the orphan rather than
# at the real cause (observed on the 1.12.0 cut — a credential without tag-push
# permission). Removing it restores the pre-cut state, so a retry is a clean
# rerun once the cause is fixed. Nothing was published: the Release is created
# by the workflow, which only fires on a tag that actually reached the remote.
if ! git push origin "$TAG"; then
  git tag -d "$TAG" >/dev/null 2>&1 || true
  echo "" >&2
  echo "FAIL: push: could not push $TAG to origin — the local tag was removed, so this cut can be retried unchanged once the cause is fixed." >&2
  echo "  Usual causes: no permission to create tags with this credential; a v* tag ruleset that does not list you as a bypass actor; or a network failure." >&2
  exit 1
fi

echo ""
echo "Pushed tag: $TAG"
echo "The release workflow (.github/workflows/release.yml) re-checks every guard"
echo "server-side and publishes the GitHub Release draft-first."
