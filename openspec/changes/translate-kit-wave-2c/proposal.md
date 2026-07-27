**Issue:** —

## Why

W2b (`translate-kit-wave-2b`) finished kit `CLAUDE.md` + `openspec/infra.md` PT→EN (apply-complete, merged PR #75, archived). Consumer installs still receive Portuguese from kit Cursor rules under `sdd-kit/templates/.cursor/rules/` (~7 residual PT `.mdc` files / ≤151 LOC; `graphify.mdc` already English). This change starts that deferred slice within the ≤4-file wave budget; remaining kit rules + `_template/proposal.md` go to W2d.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `sdd-kit/templates/.cursor/rules/000-base.mdc`
  - `sdd-kit/templates/.cursor/rules/015-session-phases.mdc`
  - `sdd-kit/templates/.cursor/rules/016-session-coordination.mdc`
  - `sdd-kit/templates/.cursor/rules/010-typescript.mdc`
- Align kit rule wording with hub `.cursor/rules/` English (W1 / W1b / W1c already EN on the matching filenames)
- Preserve freeze-list tokens (paths, globs, YAML keys `alwaysApply`/`globs`, `/opsx:*`, script paths, brand/tool names, code identifiers such as `cn`, `Zod`) byte-stable
- Preserve YAML frontmatter structure; translate human-readable `description` string values to English; keep `alwaysApply` / `globs` patterns unchanged
- After template edits: `bash sdd-kit/gen-manifest-checksums.sh` so `MANIFEST.yaml` `sha256:` fields match (G-MANIFEST)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/.cursor/rules/000-base.mdc,sdd-kit/templates/.cursor/rules/015-session-phases.mdc,sdd-kit/templates/.cursor/rules/016-session-coordination.mdc,sdd-kit/templates/.cursor/rules/010-typescript.mdc` before marking tasks done
- **Budget split:** ≤4 files this wave. Deferred to `translate-kit-wave-2d`: `020-python.mdc`, `030-supabase.mdc`, `050-security.mdc`, and `sdd-kit/templates/openspec/changes/_template/proposal.md` (proposal considered for fold-in; does not fit without dropping a rule from the 4-file cap). `graphify.mdc` already EN — out of scope.

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — kit Cursor rules W2c slice (`000-base`, `015-session-phases`, `016-session-coordination`, `010-typescript` under `sdd-kit/templates/.cursor/rules/`) MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; G-MANIFEST satisfied when templates change.

## Impact

- Files modified: the four `.mdc` paths above; `sdd-kit/MANIFEST.yaml` checksums only (mechanical); optional `doc/i18n/GLOSSARY.md` if new terms
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh`, `gen-manifest-checksums.sh`, `sdd-kit/verify.sh` already registered; W2b apply-complete / merged / archived)
- Risks: G-PT false positives; G-INV if globs/paths/`/opsx:*` rewritten; stale checksums if G-MANIFEST skipped; accidental semantic drift vs hub rules
- **Non-goals:** kit `020-python` / `030-supabase` / `050-security` / `_template/proposal.md` (→ W2d); hub live `.cursor/rules/` (already EN); hub `openspec/infra.md` residual PT; guide; skills; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; creating `.claude/rules/` mirrors; semantic changes to conventions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/.cursor/rules/000-base.mdc,sdd-kit/templates/.cursor/rules/015-session-phases.mdc,sdd-kit/templates/.cursor/rules/016-session-coordination.mdc,sdd-kit/templates/.cursor/rules/010-typescript.mdc
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (no `.claude/rules/` mirror; Cursor-only `.mdc` kit copies), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. `/opsx:propose` before C/D/E code; Session Handoff on explore→apply; `sdd-session-register`/`check`/`release` before/after apply).

## Freeze / allowlist checklist

- [x] Shell/CI fences byte-stable (except intentional non-i18n fixes)
- [x] Paths, change-ids, `/opsx:*`, pins, brand names untouched
- [x] YAML keys `description`/`globs`/`alwaysApply` and glob pattern strings unchanged (translate `description` values only)
- [x] Glossary forms used; new terms added to `GLOSSARY.md`
- [x] No dual-file EN/PT siblings introduced
- [x] `bash sdd-kit/gen-manifest-checksums.sh` run after template edits; `bash sdd-kit/verify.sh` green

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-wave-2c

Change: openspec/changes/translate-kit-wave-2c/
Ler: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md
Gate: bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/.cursor/rules/000-base.mdc,sdd-kit/templates/.cursor/rules/015-session-phases.mdc,sdd-kit/templates/.cursor/rules/016-session-coordination.mdc,sdd-kit/templates/.cursor/rules/010-typescript.mdc
Infra: openspec/infra.md (assumir ✅ — não reinstalar)
```
