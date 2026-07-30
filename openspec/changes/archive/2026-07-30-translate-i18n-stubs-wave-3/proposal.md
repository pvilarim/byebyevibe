**Issue:** —

## Why

After `translate-i18n-stubs-wave-2` (open DRAFT PR #120) claimed the four W1/W1b/W1c/W2c proposal Session Handoff stubs, the deferred `translate-kit-wave-2d/proposal.md` stub still retains Portuguese labels (`Ler:` / `assumir ✅ — não reinstalar`). A sibling residual-PT note under the same active-changes surface — `translate-agents-rules-wave-1b/simplify-review.md` — still has Portuguese review chrome (`Escopo`, `ficheiros`, `Veredito`, `Achados`). Both paths are in-scope under `sdd-docs-language` and are **not** listed as owned translation targets by wave-1/wave-2 or other open translate PRs. This wave substitutes those residuals in-place within ≤4 files / ≤350–400 LOC.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `openspec/changes/translate-kit-wave-2d/proposal.md`
  - `openspec/changes/translate-agents-rules-wave-1b/simplify-review.md`
- Align the W2d Session Handoff stub with the English form already documented in `doc/i18n/CURSOR-AUTOMATIONS.md` §6 (`Read:` / `assume ✅ — do not reinstall`)
- Translate the simplify-review note chrome/body to English while preserving change-id, LEAN verdict semantics, and net-line conclusion
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, URLs, brand/tool names, fenced shell, W2d Gate `--files` path list) byte-stable aside from intentional non-i18n fixes
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/translate-kit-wave-2d/proposal.md,openspec/changes/translate-agents-rules-wave-1b/simplify-review.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the Session Handoff stub in `translate-kit-wave-2d/proposal.md` and the simplify-review note under `translate-agents-rules-wave-1b/` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; stub/review meaning MUST stay equivalent to the pre-wave Portuguese labels.

## Impact

- Files modified: the two paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none for propose; apply is independent of other open translate merges (disjoint files). Infra ✅ — `verify-i18n-wave.sh` already registered. Paths not owned by `translate-i18n-stubs-wave-1` (PR #119), `translate-i18n-stubs-wave-2` (PR #120), or other open translate PRs #84 / #93–#118
- Risks: G-PT false positives on path segments; accidental drift of Session Handoff or review semantics (language only); overlap if a later wave rewrites whole proposal/review bodies (this wave touches residual PT only)
- **Non-Goals:** Session Handoff stubs already owned by stubs-wave-1/wave-2; over-budget surfaces (`doc/sistema-sdd-pedro.md`, `doc/curso/aula-05-*`, `doc/design/001-*`, kit `001` mirror, `explore-adversarial` research, discovery `research.md`); other owned translate target slices; `openspec/changes/archive/`; dual-file `*.en.md` / `*-pt.md`; global G-DoD; kit templates / G-MANIFEST; skills/commands mirrors

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/translate-kit-wave-2d/proposal.md,openspec/changes/translate-agents-rules-wave-1b/simplify-review.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms the W2d Session Handoff stub remains copy-pasteable for `/opsx:apply translate-kit-wave-2d` and the simplify-review note still communicates LEAN / ship.

## Freeze / allowlist checklist

- [ ] Shell/CI fences byte-stable (except intentional non-i18n fixes)
- [ ] Paths, change-ids, `/opsx:*`, brand names untouched
- [ ] Glossary forms used; new terms added to `GLOSSARY.md`
- [ ] No dual-file EN/PT siblings introduced
- [ ] Session Handoff stub structure preserved (phase command, Change path, Read/Gate/Infra lines; W2c prerequisite lines kept)
- [ ] W2d Gate `--files` path list inside the stub remains byte-stable
- [ ] simplify-review change-id and LEAN verdict preserved

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-i18n-stubs-wave-3

Change: openspec/changes/translate-i18n-stubs-wave-3/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/translate-kit-wave-2d/proposal.md,openspec/changes/translate-agents-rules-wave-1b/simplify-review.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
