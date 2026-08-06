#!/usr/bin/env bash
# ByeByeVibe (sdd-kit) — release-note extraction from the guide changelog
# (add-github-release-flow, issue #350; design D3).
# `## Guide changelog` in doc/byebyevibe-guide.md stays the single authored
# changelog: this script prints one `### <version> (…)` section's body so the
# GitHub Release body is extracted, never hand-copied. Two consumers justify the
# separate file (D3): the operator's machine (preflight preview via
# cut-release.sh) and the release workflow — only the former may tag.
#
# The match is anchored on the literal `### <version> (` prefix, so `1.1.0` can
# never be satisfied by `1.11.0`; the date shape is NOT part of the anchor, so
# the legacy `### 1.0.0 (2026-05)` entry extracts normally. The section ends at
# the next line starting with `### ` or `## `, or at end of file. Interior lines
# are printed verbatim; only blank padding around the body is trimmed.
#
# Usage: bash scripts/release-notes.sh <version> [source-file]
# The optional second argument is the fixture hook the spec requires, so absent
# and empty-body behaviour can be tested without editing the live changelog.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERSION="${1:-}"
SOURCE_FILE="${2:-$REPO_ROOT/doc/byebyevibe-guide.md}"

if [[ -z "$VERSION" ]]; then
  echo "Usage: bash scripts/release-notes.sh <version> [source-file]" >&2
  exit 2
fi

if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "FAIL: release-notes: source file not found: $SOURCE_FILE" >&2
  exit 1
fi

HEADING="### ${VERSION} ("

# index($0, hdr) == 1 is a literal prefix test — no regex metacharacter in a
# version string can widen or narrow the match.
BODY="$(awk -v hdr="$HEADING" '
  index($0, hdr) == 1 && !seen { seen = 1; inside = 1; next }
  inside && (substr($0, 1, 4) == "### " || substr($0, 1, 3) == "## ") { inside = 0 }
  inside { print }
  END { exit (seen ? 0 : 1) }
' "$SOURCE_FILE")" || {
  echo "FAIL: release-notes: no '${HEADING}…)' section in $SOURCE_FILE" >&2
  exit 1
}

if ! printf '%s\n' "$BODY" | grep -q '[^[:space:]]'; then
  echo "FAIL: release-notes: section '### ${VERSION}' in $SOURCE_FILE has no body text" >&2
  exit 1
fi

# Command substitution already dropped trailing blank lines; drop leading ones.
printf '%s\n' "$BODY" | awk 'started || NF { started = 1; print }'
