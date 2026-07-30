**Issue:** —

## Why

After `translate-i18n-stubs-wave-1` (open DRAFT PR #119) claimed the wave proposal template and the `add-i18n-cursor-automations-guide` proposal stub, four active `translate-*` proposal Session Handoff stubs still retain Portuguese labels (`Ler:` / `assumir ✅ — não reinstalar`). Those proposal files are in-scope under `sdd-docs-language` and are **not** listed as owned translation targets by wave-1 or other open translate PRs. This wave substitutes those stubs in-place within ≤4 files / ≤350–400 LOC.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `openspec/changes/translate-agents-rules-wave-1/proposal.md`
  - `openspec/changes/translate-agents-rules-wave-1b/proposal.md`
  - `openspec/changes/translate-agents-rules-wave-1c/proposal.md`
  - `openspec/changes/translate-kit-wave-2c/proposal.md`
- Align Session Handoff stubs with the English form already documented in `doc/i18n/CURSOR-AUTOMATIONS.md` §6 (`Read:` / `assume ✅ — do not reinstall`)
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, URLs, brand/tool names, fenced shell, per-wave `--files` path lists) byte-stable aside from intentional non-i18n fixes
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/translate-agents-rules-wave-1/proposal.md,openspec/changes/translate-agents-rules-wave-1b/proposal.md,openspec/changes/translate-agents-rules-wave-1c/proposal.md,openspec/changes/translate-kit-wave-2c/proposal.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the Session Handoff stubs in the four listed active `translate-*` proposal files MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; stub meaning (apply handoff, gate command, infra assume-ready) MUST stay equivalent to the pre-wave Portuguese labels.

## Impact

- Files modified: the four paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none for propose; apply is independent of other open translate merges (disjoint files). Infra ✅ — `verify-i18n-wave.sh` already registered. Paths not owned by `translate-i18n-stubs-wave-1` (PR #119) or other open translate PRs #84 / #93–#118
- Risks: G-PT false positives on path segments; accidental drift of Session Handoff semantics (language only); overlap if a later wave rewrites whole proposal bodies (this wave touches stub labels only)
- **Non-goals:** `translate-kit-wave-2d/proposal.md` stub (next stubs wave); Session Handoff stubs in `translate-*/tasks.md` or `design.md`; over-budget surfaces (`doc/sistema-sdd-pedro.md`, `doc/curso/aula-05-*`, `doc/design/001-*`, kit `001` mirror, `explore-adversarial` research, discovery `research.md`); other owned translate target slices; `openspec/changes/archive/`; dual-file `*.en.md` / `*-pt.md`; global G-DoD; rewriting `WAVE-PROPOSAL-TEMPLATE.md` / `add-i18n-cursor-automations-guide/proposal.md` (owned by wave-1)

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/translate-agents-rules-wave-1/proposal.md,openspec/changes/translate-agents-rules-wave-1b/proposal.md,openspec/changes/translate-agents-rules-wave-1c/proposal.md,openspec/changes/translate-kit-wave-2c/proposal.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms Session Handoff stubs remain copy-pasteable for `/opsx:apply` of each parent wave.

## Freeze / allowlist checklist

- [ ] Shell/CI fences byte-stable (except intentional non-i18n fixes)
- [ ] Paths, change-ids, `/opsx:*`, brand names untouched
- [ ] Glossary forms used; new terms added to `GLOSSARY.md`
- [ ] No dual-file EN/PT siblings introduced
- [ ] Session Handoff stub structure preserved (phase command, Change path, Read/Gate/Infra lines)
- [ ] Per-wave Gate `--files` path lists inside each stub remain byte-stable

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-i18n-stubs-wave-2

Change: openspec/changes/translate-i18n-stubs-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/translate-agents-rules-wave-1/proposal.md,openspec/changes/translate-agents-rules-wave-1b/proposal.md,openspec/changes/translate-agents-rules-wave-1c/proposal.md,openspec/changes/translate-kit-wave-2c/proposal.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
