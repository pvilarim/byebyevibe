**Issue:** —

## Why

W1b (`translate-agents-rules-wave-1b`) migrated the four always-apply Cursor rules to English and deferred the remaining stack-scoped rules because eight `.mdc` files exceed the ≤4-file wave budget. The leftover W1 surface (`010-typescript`, `020-python`, `030-supabase`, `graphify.mdc`, ~63 LOC) still mixes Portuguese conventions prose with English tokens — completing it closes the W1 agents/rules track before W2 kit waves.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `.cursor/rules/010-typescript.mdc`
  - `.cursor/rules/020-python.mdc`
  - `.cursor/rules/030-supabase.mdc`
  - `.cursor/rules/graphify.mdc` (already mostly English — close any residual PT + ensure `description` is English)
- Preserve freeze-list tokens (paths, globs, YAML keys `alwaysApply`/`globs`, code identifiers such as `cn`, `Zod`, `RLS`, `ivfflat`, `structlog`, `pytest-asyncio`, brand/tool names) byte-stable
- Preserve YAML frontmatter structure; translate human-readable `description` string values to English; keep `alwaysApply: false` / `true` and `globs` patterns unchanged
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files .cursor/rules/010-typescript.mdc,.cursor/rules/020-python.mdc,.cursor/rules/030-supabase.mdc,.cursor/rules/graphify.mdc` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — remaining W1c Cursor stack/rules files MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens (including stack identifiers) preserved.

## Impact

- Files modified: the four `.mdc` paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; W1b apply/archive or apply-ready prerequisite met — W1b tasks complete / merged)
- Risks: G-PT false positives on allowlisted/tech tokens; G-INV if globs/paths/identifiers are rewritten; accidental semantic drift in stack conventions (TypeScript/Python/Supabase)
- **Non-goals:** canonical guide; skills; kit templates; dual-file `*.en.mdc` / `*-pt.mdc`; global G-DoD; path renames; creating `.claude/rules/` mirrors; semantic changes to stack conventions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files .cursor/rules/010-typescript.mdc,.cursor/rules/020-python.mdc,.cursor/rules/030-supabase.mdc,.cursor/rules/graphify.mdc
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (no `.claude/rules/` mirror; Cursor-only `.mdc`), **G-MANIFEST** (no kit templates), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. Zod at I/O boundaries, RLS deny-by-default, `graphify update .` after code edits).

## Freeze / allowlist checklist

- [x] Shell/CI fences byte-stable (except intentional non-i18n fixes)
- [x] Paths, globs, change-ids, `/opsx:*`, pins, brand/tool names untouched
- [x] Code identifiers frozen: `cn`, `Zod`, `RLS`, `ivfflat`, `structlog`, `pytest-asyncio`, `Pydantic`, `asyncio`, etc.
- [x] YAML keys `description`/`globs`/`alwaysApply` and glob pattern strings unchanged (translate `description` values only)
- [x] Glossary forms used; new terms added to `GLOSSARY.md` (none expected)
- [x] No dual-file EN/PT siblings introduced

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-agents-rules-wave-1c

Change: openspec/changes/translate-agents-rules-wave-1c/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md
Gate: bash scripts/verify-i18n-wave.sh --files .cursor/rules/010-typescript.mdc,.cursor/rules/020-python.mdc,.cursor/rules/030-supabase.mdc,.cursor/rules/graphify.mdc
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
