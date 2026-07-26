**Issue:** —

## Why

W1 (`translate-agents-rules-wave-1`) migrated agent entry points (`AGENTS.md`, `CLAUDE.md`, `openspec/project.md`) to English and deferred `.cursor/rules/*.mdc` because eight rule files exceed the ≤4-file wave budget. Always-apply rules (`000-base`, `015-session-phases`, `016-session-coordination`, `050-security`) still load Portuguese prose on every Cursor session — highest-leverage remaining W1 slice.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `.cursor/rules/000-base.mdc`
  - `.cursor/rules/015-session-phases.mdc`
  - `.cursor/rules/016-session-coordination.mdc`
  - `.cursor/rules/050-security.mdc`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, shell fences, pins, brand names, script paths) byte-stable
- Preserve YAML frontmatter keys (`description`, `alwaysApply`, `globs`) and structure; translate `description` string values to English
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files .cursor/rules/000-base.mdc,.cursor/rules/015-session-phases.mdc,.cursor/rules/016-session-coordination.mdc,.cursor/rules/050-security.mdc` before marking tasks done
- **Budget split:** remaining rules (`010-typescript`, `020-python`, `030-supabase`, `graphify.mdc`) → deferred to `translate-agents-rules-wave-1c`

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — always-apply Cursor rules in this W1b slice MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved.

## Impact

- Files modified: the four `.mdc` paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; W1 precedent applied/archived or apply-ready)
- Risks: G-PT false positives on allowlisted tokens; G-INV if script paths/`/opsx:*`/fences are rewritten; accidental semantic drift in session-phase or security guardrails
- **Non-goals:** guide; skills; kit templates; dual-file `*.en.md` / `*-pt.md`; global G-DoD; stack-scoped rules `010`/`020`/`030` and `graphify.mdc` (wave-1c); path renames; semantic changes to R10/R11/security rules — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files .cursor/rules/000-base.mdc,.cursor/rules/015-session-phases.mdc,.cursor/rules/016-session-coordination.mdc,.cursor/rules/050-security.mdc
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (no `.claude/rules/` mirror; Cursor-only `.mdc`), **G-MANIFEST** (no kit templates), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. session phase handoff, `sdd-session-register`/`check`/`release`, security freeze for secrets/`--force`).

## Freeze / allowlist checklist

- [ ] Shell/CI fences byte-stable (except intentional non-i18n fixes)
- [ ] Paths, change-ids, `/opsx:*`, pins, brand names, script paths untouched
- [ ] Glossary forms used; new terms added to `GLOSSARY.md`
- [ ] No dual-file EN/PT siblings introduced
- [ ] YAML frontmatter structure preserved (`alwaysApply: true` unchanged)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-agents-rules-wave-1b

Change: openspec/changes/translate-agents-rules-wave-1b/
Ler: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md
Gate: bash scripts/verify-i18n-wave.sh --files .cursor/rules/000-base.mdc,.cursor/rules/015-session-phases.mdc,.cursor/rules/016-session-coordination.mdc,.cursor/rules/050-security.mdc
Infra: openspec/infra.md (assumir ✅ — não reinstalar)
```
