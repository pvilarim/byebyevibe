**Issue:** —

## Why

W2 (`translate-kit-wave-2`) finished the kit README + AGENTS.* PT→EN slice (apply-complete, merged PR #73, archived). Consumer installs still receive Portuguese from `sdd-kit/templates/CLAUDE.md` and `sdd-kit/templates/openspec/infra.md` — the deferred D1 follow-up. This change completes that two-file slice (+ MANIFEST checksums) within wave budgets; kit `.cursor/rules/` copies remain deferred.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `sdd-kit/templates/CLAUDE.md`
  - `sdd-kit/templates/openspec/infra.md`
- Align kit `CLAUDE.md` with hub `CLAUDE.md` English wording (W1 pattern)
- Align kit `openspec/infra.md` structure with hub `openspec/infra.md` (HTML `verify-infra.sh` markers, section layout); substitute residual Portuguese table/prose to glossary EN even where hub live infra still has PT leftovers (hub infra residual is out of this wave)
- Preserve freeze-list tokens (paths, HTML comment markers for `verify-infra.sh`, package pins, shell/CI fences, brand/tool names, `/opsx:*`, SHA pins) byte-stable
- Translate Portuguese filler inside marker bodies (e.g. `outros MCPs`, `_(sem .env.example no repo)_`, `[AÇÃO MANUAL]`) to English equivalents without moving marker tags
- After template edits: `bash sdd-kit/gen-manifest-checksums.sh` so `MANIFEST.yaml` `sha256:` fields match (G-MANIFEST)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/CLAUDE.md,sdd-kit/templates/openspec/infra.md` before marking tasks done
- **Budget:** kit `.cursor/rules/*.mdc` copies (~8 files / ~151 LOC) exceed the remaining ≤4-file budget if batched with CLAUDE+infra → deferred to a later kit-rules / WRu wave

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — kit `CLAUDE.md` and `openspec/infra.md` install templates MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens and `verify-infra.sh` HTML markers preserved; G-MANIFEST satisfied when templates change.

## Impact

- Files modified: the two paths above; `sdd-kit/MANIFEST.yaml` checksums only (mechanical); optional `doc/i18n/GLOSSARY.md` if new terms
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh`, `gen-manifest-checksums.sh`, `sdd-kit/verify.sh` already registered; W2 apply-complete / merged / archived)
- Risks: G-PT false positives; G-INV if HTML markers/fences/pins rewritten; stale checksums if G-MANIFEST skipped; hub live `openspec/infra.md` still has residual PT (operators must not copy hub residual into the kit template)
- **Non-goals:** kit `.cursor/rules/*.mdc` copies; `_template/proposal.md`; kit `doc/design/*`; live hub `CLAUDE.md` / `openspec/infra.md` (hub CLAUDE already EN; hub infra residual → separate change); guide; skills; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; semantic changes to `verify-infra.sh` / install behavior — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/CLAUDE.md,sdd-kit/templates/openspec/infra.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (no `.cursor`/`.claude` skill pair in scope), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. R10 infra read, `bash scripts/verify-infra.sh`, Claude Code lookup via `CLAUDE.md` → `AGENTS.md`).

## Freeze / allowlist checklist

- [x] Shell/CI fences byte-stable (except intentional non-i18n fixes)
- [x] Paths, change-ids, `/opsx:*`, pins, brand names untouched
- [x] HTML markers (`<!-- openspec-version -->` … `<!-- /env-list -->` and siblings) tags byte-stable; only inner Portuguese filler translated
- [x] Glossary forms used; new terms added to `GLOSSARY.md`
- [x] No dual-file EN/PT siblings introduced
- [x] `bash sdd-kit/gen-manifest-checksums.sh` run after template edits; `bash sdd-kit/verify.sh` green

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-wave-2b

Change: openspec/changes/translate-kit-wave-2b/
Ler: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md
Gate: bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/CLAUDE.md,sdd-kit/templates/openspec/infra.md
Infra: openspec/infra.md (assumir ✅ — não reinstalar)
```
