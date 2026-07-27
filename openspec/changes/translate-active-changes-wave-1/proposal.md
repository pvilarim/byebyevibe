**Issue:** —

## Why

Explore-research waves (open PRs #108/#109) already own the explore `research.md` slices. The next high-value completable whole-file residual on the WAr/active-changes track is the completed-change package `add-correctness-review-skill` — `proposal.md` + `design.md` + `tasks.md` (~305 LOC, 3 files, dense residual Portuguese) — within ≤4 files / ≤350–400 LOC and disjoint from every open `translate-*` propose PR and active base ownership. Sibling delta specs under that change are already English (0 G-PT deny hits) and stay out of scope.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `openspec/changes/add-correctness-review-skill/proposal.md`
  - `openspec/changes/add-correctness-review-skill/design.md`
  - `openspec/changes/add-correctness-review-skill/tasks.md`
- Preserve freeze-list tokens (paths, change-ids, skill names, `/opsx:*`, URLs, brand/tool names, fenced shell, A–E matrix labels, checklist completion markers `[x]`) byte-stable aside from intentional non-i18n fixes
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-correctness-review-skill/proposal.md,openspec/changes/add-correctness-review-skill/design.md,openspec/changes/add-correctness-review-skill/tasks.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed active-change artifacts for `add-correctness-review-skill` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; historical apply outcomes (skill paths, A–E matrix, pilot exception, rollback plan) MUST keep the same meaning after prose is normalized.

## Impact

- Files modified: the three `add-correctness-review-skill` artifact paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; paths not owned by active `translate-*` on base or open translate PRs #78 / #84 / #93–#109)
- Risks: G-PT false positives on quoted historical PT / proper nouns; G-INV if change-ids/skill paths rewritten; accidental semantic drift of A–E invocation matrix or pilot-exception rationale (language only)
- **Non-goals:** delta specs under `openspec/changes/add-correctness-review-skill/specs/` (already EN); other completed-change design/proposal/tasks still in PT (`add-probity-tdd-module`, metrics, supply-chain, discovery); sibling explore research (owned by #108/#109; `explore-adversarial` over budget); `openspec/changes/archive/`; canonical guide; curso `aula-05` / design `001` (over budget); kit templates; dual-file `*.en.md` / `*-pt.md`; global G-DoD; re-opening correctness-review product decisions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/add-correctness-review-skill/proposal.md,openspec/changes/add-correctness-review-skill/design.md,openspec/changes/add-correctness-review-skill/tasks.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. when to invoke correctness-review vs simplify/security; A–E matrix boundaries; rollback = remove both skill mirrors + revert AGENTS/infra).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids (`add-correctness-review-skill`, `explore-oss-coverage-gaps`, …), skill names (`correctness-review`, `simplify-review`), `/opsx:*`, URLs, brand/tool names untouched
- [ ] Historical task completion markers `[x]` and Gate/Pattern lines remain structurally intact (prose language only)
- [ ] A–E matrix outcomes and pilot-exception / rollback decisions unchanged
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — skill / Session Handoff / evaluation / gate already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links and change-id references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-active-changes-wave-1

Change: openspec/changes/translate-active-changes-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/add-correctness-review-skill/proposal.md,openspec/changes/add-correctness-review-skill/design.md,openspec/changes/add-correctness-review-skill/tasks.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
