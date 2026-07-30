**Issue:** —

## Why

`doc/sistema-sdd-pedro.md` (~2847 LOC) is the canonical install guide and the highest-priority uncovered in-scope surface (W3+ in `doc/i18n/WAVES.md`). Prior waves closed entry points, kit, skills, commands, design, and evaluations; no `translate-guide-*` propose exists yet. This change covers lines **1620–1973** (§9–§10 Cursor + VS Code / Claude Code setup, ~354 LOC) — within the ≤350–400 LOC mid-file slice budget. Apply is sequential per slice on the same file; proposes for disjoint slices may merge in parallel.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** in `doc/sistema-sdd-pedro.md` for lines **1620–1973** only (§9–§10 Cursor + VS Code / Claude Code setup)
- Do **not** edit lines outside this slice in the same apply session
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, URLs, `sdd-kit/` commands, profile codes C1–C3, fenced shell, brand **ByeByeVibe**) byte-stable
- Map operator cues: `Acção`/`Acção` → Action, `[AÇÃO MANUAL]` → `[MANUAL ACTION]`, section anchors updated only when heading text is translated (keep link targets consistent — G-LINK)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files doc/sistema-sdd-pedro.md` before marking tasks done (whole-file gate; slice must leave zero PT in touched lines)

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — guide slice lines 1620–1973 of `doc/sistema-sdd-pedro.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved.

## Impact

- Files modified: `doc/sistema-sdd-pedro.md` (lines 1620–1973 only; optional `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: `translate-guide-wave-9` apply+archive before this wave's apply (propose may merge in parallel with other disjoint waves). Infra ✅
- Risks: G-PT scans whole file — out-of-slice PT causes false FAIL until prior slices applied; accidental edits outside slice; broken anchor links after heading translation (G-LINK)
- **Non-goals:** lines outside 1620–1973; `doc/curso/`; `openspec/changes/archive/`; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files doc/sistema-sdd-pedro.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A: **G-MIRROR**, **G-MANIFEST**. **G-DoD** only after all guide slices + other waves.

**G-SMOKE (advisory):** human confirms 3 critical procedures in this slice remain executable from EN text.

## Freeze / allowlist checklist

- [ ] Shell/CI fences byte-stable
- [ ] Paths, change-ids, `/opsx:*`, pins, URLs, profile codes untouched
- [ ] Edits confined to lines 1620–1973
- [ ] Glossary forms used; no dual-file siblings
- [ ] Relative links and anchors still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-guide-wave-10

Change: openspec/changes/translate-guide-wave-10/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files doc/sistema-sdd-pedro.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
