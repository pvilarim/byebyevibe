**Issue:** —

## Why

Completed-change packages for metrics, supply-chain, discovery, correctness-review, and explore-oss already have open translate propose PRs. The next high-value completable whole-file residual on the WAr/active-changes track is `add-probity-tdd-module` — `proposal.md` + `tasks.md` + `piloto-nota.md` (~214 LOC, 3 files, residual Portuguese) — within ≤4 files / ≤350–400 LOC and disjoint from every owned path on base and open translate propose PRs. Sibling `design.md` (~292 LOC) is deferred to `translate-probity-wave-2`; delta specs under that change are already English (0 G-PT deny hits).

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `openspec/changes/add-probity-tdd-module/proposal.md`
  - `openspec/changes/add-probity-tdd-module/tasks.md`
  - `openspec/changes/add-probity-tdd-module/piloto-nota.md`
- Preserve freeze-list tokens (paths, change-ids, package pin `@nizos/probity@1.10.0`, `enforceTdd`, `/opsx:*`, URLs, brand/tool names, fenced shell, checklist completion markers `[x]`) byte-stable aside from intentional non-i18n fixes
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-probity-tdd-module/proposal.md,openspec/changes/add-probity-tdd-module/tasks.md,openspec/changes/add-probity-tdd-module/piloto-nota.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed active-change artifacts for `add-probity-tdd-module` (proposal, tasks, pilot note) MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; historical apply outcomes (pilot pending status, kit scaffolding, 6-point registry, TDD Guard → Probity migration) MUST keep the same meaning after prose is normalized.

## Impact

- Files modified: the three `add-probity-tdd-module` artifact paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none for propose; apply is independent of other open translate merges (disjoint files). Infra ✅ — `verify-i18n-wave.sh` already registered. Paths not owned by active `translate-*` on base or open translate PRs #84 / #93–#116
- Risks: G-PT false positives on quoted historical PT / proper nouns; G-INV if change-ids, pins, or `enforceTdd` rewritten; accidental semantic drift of pilot-pending status or registry contract (language only)
- **Non-goals:** `design.md` (deferred to `translate-probity-wave-2`); delta specs under `openspec/changes/add-probity-tdd-module/specs/` (already EN); other completed-change packages already owned by open PRs; `openspec/changes/archive/`; canonical guide; curso `aula-05` / design `001` / `explore-adversarial` / discovery `research.md` (over budget); kit templates; dual-file `*.en.md` / `*-pt.md`; global G-DoD; re-opening Probity product decisions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/add-probity-tdd-module/proposal.md,openspec/changes/add-probity-tdd-module/tasks.md,openspec/changes/add-probity-tdd-module/piloto-nota.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (pilot pending note, install script pointers, task gates).

## Freeze / allowlist checklist

- [ ] Shell/CI fences byte-stable (except intentional non-i18n fixes)
- [ ] Paths, change-ids, `/opsx:*`, pins (`@nizos/probity@1.10.0`), `enforceTdd`, brand names untouched
- [ ] Glossary forms used; new terms added to `GLOSSARY.md`
- [ ] No dual-file EN/PT siblings introduced
- [ ] Historical `[x]` completion markers and pilot **PENDING** status meaning preserved

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-probity-wave-1

Change: openspec/changes/translate-probity-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/add-probity-tdd-module/proposal.md,openspec/changes/add-probity-tdd-module/tasks.md,openspec/changes/add-probity-tdd-module/piloto-nota.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
