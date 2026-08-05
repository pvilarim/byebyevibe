#!/usr/bin/env bash
# SPENT 2026-08-05 — every PR below is already closed; this is now a no-op that
# prints "Skip ... (state=CLOSED)" for each. Kept for provenance only.
# Root cause of the duplicates (search-index lag vs a ~5-min trigger) and the
# verify-before-closing procedure: doc/i18n/CURSOR-AUTOMATIONS.md §5.3.1.
# Note this list never included #17 — that PR carries unlanded spec deltas.
#
# REMINDER 2026-08-01 — close stale duplicate archive PRs (already on master).
# See doc/i18n/CURSOR-AUTOMATIONS.md §5.3.1
set -euo pipefail

PRS=(
  202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219
  220 221 222 223 178 180 65
)

for pr in "${PRS[@]}"; do
  state="$(gh pr view "$pr" --json state -q .state 2>/dev/null || echo MISSING)"
  if [[ "$state" == "OPEN" ]]; then
    echo "Closing PR #$pr ..."
    gh pr close "$pr" || echo "  WARN: could not close #$pr (permissions?)"
  else
    echo "Skip PR #$pr (state=$state)"
  fi
done

echo "Done. Re-check: gh pr list --state open --search 'archive translate'"
