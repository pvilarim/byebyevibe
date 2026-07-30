**Issue:** —

## Why

After Probity and other active-change translate proposes, the only remaining **completable ≤budget** residual-Portuguese slices are tiny Session Handoff stubs: `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` and `openspec/changes/add-i18n-cursor-automations-guide/proposal.md` (1 G-PT deny hit each; ~111 LOC combined). Leaving Portuguese `Ler:` / `assumir` / `não reinstalar` in the wave proposal template causes future `/opsx:propose` artifacts to copy non-canonical stubs (F7). This wave substitutes those stubs in-place within ≤4 files / ≤350–400 LOC and is disjoint from every owned path on base and open translate propose PRs.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`
  - `openspec/changes/add-i18n-cursor-automations-guide/proposal.md`
- Align Session Handoff stubs with the English form already documented in `doc/i18n/CURSOR-AUTOMATIONS.md` §6 (`Read:` / `assume ✅ — do not reinstall`)
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, URLs, brand/tool names, fenced shell) byte-stable aside from intentional non-i18n fixes
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files doc/i18n/WAVE-PROPOSAL-TEMPLATE.md,openspec/changes/add-i18n-cursor-automations-guide/proposal.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the wave proposal template Session Handoff stub and the `add-i18n-cursor-automations-guide` proposal Session Handoff stub MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; stub meaning (apply/archive handoff, gate command, infra assume-ready) MUST stay equivalent to the pre-wave Portuguese labels.

## Impact

- Files modified: the two paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none for propose; apply is independent of other open translate merges (disjoint files). Infra ✅ — `verify-i18n-wave.sh` already registered. Paths not owned by active `translate-*` on base or open translate PRs #84 / #93–#118
- Risks: G-PT false positives on path segments; accidental drift of Session Handoff semantics (language only)
- **Non-goals:** over-budget surfaces (`doc/sistema-sdd-pedro.md`, `doc/curso/aula-05-*`, `doc/design/001-*`, kit `001` mirror, `explore-adversarial` research, discovery `research.md`); other owned translate slices; `openspec/changes/archive/`; dual-file `*.en.md` / `*-pt.md`; global G-DoD; rewriting `CURSOR-AUTOMATIONS.md` (already EN)

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files doc/i18n/WAVE-PROPOSAL-TEMPLATE.md,openspec/changes/add-i18n-cursor-automations-guide/proposal.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms Session Handoff stubs remain copy-pasteable for `/opsx:apply` / `/opsx:archive`.

## Freeze / allowlist checklist

- [ ] Shell/CI fences byte-stable (except intentional non-i18n fixes)
- [ ] Paths, change-ids, `/opsx:*`, brand names untouched
- [ ] Glossary forms used; new terms added to `GLOSSARY.md`
- [ ] No dual-file EN/PT siblings introduced
- [ ] Session Handoff stub structure preserved (phase command, Change path, Read/Gate/Infra lines)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-i18n-stubs-wave-1

Change: openspec/changes/translate-i18n-stubs-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files doc/i18n/WAVE-PROPOSAL-TEMPLATE.md,openspec/changes/add-i18n-cursor-automations-guide/proposal.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
