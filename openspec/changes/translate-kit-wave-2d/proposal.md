**Issue:** —

## Why

W2c (`translate-kit-wave-2c`) propose is merged (PR #76) and deferred the residual kit Cursor rules plus the OpenSpec proposal scaffold to this change-id (design D1). Consumer installs still receive Portuguese from `020-python.mdc`, `030-supabase.mdc`, `050-security.mdc`, and `openspec/changes/_template/proposal.md` (~4 files / ~107 LOC). This wave finishes that deferred kit slice within the ≤4-file budget.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `sdd-kit/templates/.cursor/rules/020-python.mdc`
  - `sdd-kit/templates/.cursor/rules/030-supabase.mdc`
  - `sdd-kit/templates/.cursor/rules/050-security.mdc`
  - `sdd-kit/templates/openspec/changes/_template/proposal.md`
- Align kit rule wording with hub `.cursor/rules/{020,030,050}*.mdc` English (W1 / W1b / W1c already EN on the matching filenames)
- Translate `_template/proposal.md` placeholders to English **FILL IN** forms (WAVE-PROPOSAL-TEMPLATE pattern); keep section headings and structure aligned with that template
- Preserve freeze-list tokens (paths, globs, YAML keys `alwaysApply`/`globs`, `/opsx:*`, script paths, package pins, brand/tool names, code identifiers such as `Zod`, `asyncio`, `Pydantic`, `gate:`, `F-SEC-5`, `F-SEC-3`) byte-stable
- Preserve YAML frontmatter structure; translate human-readable `description` string values to English; keep `alwaysApply` / `globs` patterns unchanged
- After template edits: `bash sdd-kit/gen-manifest-checksums.sh` so `MANIFEST.yaml` `sha256:` fields match (G-MANIFEST)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/.cursor/rules/020-python.mdc,sdd-kit/templates/.cursor/rules/030-supabase.mdc,sdd-kit/templates/.cursor/rules/050-security.mdc,sdd-kit/templates/openspec/changes/_template/proposal.md` before marking tasks done
- **Apply prerequisite:** run `/opsx:apply` + `/opsx:archive` for `translate-kit-wave-2c` before applying this wave (W2c propose-ready / merged; apply+archive may still be pending)

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — kit Cursor rules W2d residual slice (`020-python`, `030-supabase`, `050-security` under `sdd-kit/templates/.cursor/rules/`) and kit OpenSpec proposal scaffold (`sdd-kit/templates/openspec/changes/_template/proposal.md`) MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; G-MANIFEST satisfied when templates change.

## Impact

- Files modified: the four paths above; `sdd-kit/MANIFEST.yaml` checksums only (mechanical); optional `doc/i18n/GLOSSARY.md` if new terms
- Dependencies: W2c apply+archive before this wave’s apply (infra ✅ — `verify-i18n-wave.sh`, `gen-manifest-checksums.sh`, `sdd-kit/verify.sh` already registered; W2c propose merged PR #76)
- Risks: G-PT false positives; G-INV if globs/paths/pins/`gate:` rewritten; stale checksums if G-MANIFEST skipped; accidental semantic drift vs hub rules; applying before W2c archive leaves overlapping kit-rules waves in flight
- **Non-goals:** hub live `.cursor/rules/` (already EN); hub `openspec/infra.md` residual PT; guide; skills; dual-file `*.en.md` / `*-pt.md`; kit `graphify.mdc` (already EN); W2c slice files (`000`/`015`/`016`/`010` — owned by W2c); global G-DoD; path renames; creating `.claude/rules/` mirrors; semantic changes to conventions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/.cursor/rules/020-python.mdc,sdd-kit/templates/.cursor/rules/030-supabase.mdc,sdd-kit/templates/.cursor/rules/050-security.mdc,sdd-kit/templates/openspec/changes/_template/proposal.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (no `.claude/rules/` mirror; Cursor-only `.mdc` kit copies + proposal scaffold), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. Python/Pydantic conventions from `020`; RLS + parameterized queries from `030`; `OPENSPEC_TELEMETRY=0` + MANIFEST `gate:` never-eval from `050`; filling a new proposal from `_template/proposal.md`).

## Freeze / allowlist checklist

- [ ] Shell/CI fences byte-stable (except intentional non-i18n fixes)
- [ ] Paths, change-ids, `/opsx:*`, pins, brand names untouched
- [ ] YAML keys `description`/`globs`/`alwaysApply` and glob pattern strings unchanged (translate `description` values only)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md`
- [ ] No dual-file EN/PT siblings introduced
- [ ] `bash sdd-kit/gen-manifest-checksums.sh` run after template edits; `bash sdd-kit/verify.sh` green

## Session Handoff stub

```
## Session Handoff

# Prerequisite if W2c not yet apply+archive:
/opsx:apply translate-kit-wave-2c
# then /opsx:archive translate-kit-wave-2c

/opsx:apply translate-kit-wave-2d

Change: openspec/changes/translate-kit-wave-2d/
Ler: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md
Gate: bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/.cursor/rules/020-python.mdc,sdd-kit/templates/.cursor/rules/030-supabase.mdc,sdd-kit/templates/.cursor/rules/050-security.mdc,sdd-kit/templates/openspec/changes/_template/proposal.md
Infra: openspec/infra.md (assumir ✅ — não reinstalar)
```
