**Issue:** —

## Why

Layer-1 policy (`add-english-docs-policy`) is archived; agent entry points still mix Portuguese prose with English F7 pointers. W1 starts controlled in-place PT→EN substitution on the highest-leverage surfaces agents read first (`AGENTS.md`, `openspec/project.md`, `CLAUDE.md`), within wave budgets, so later waves and new work inherit an English-canonical agent constitution.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `AGENTS.md`
  - `openspec/project.md`
  - `CLAUDE.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, shell fences, pins, brand names) byte-stable
- Keep F7 explicit: chat MAY be pt-BR; versioned artifacts MUST be English
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files AGENTS.md,openspec/project.md,CLAUDE.md` before marking tasks done
- **Budget split:** `.cursor/rules/*.mdc` (8 files, ~151 LOC) exceeds the ≤4-file limit → deferred to follow-up `translate-agents-rules-wave-1b` (and further splits if needed)

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — agent entry-point documents (`AGENTS.md`, `CLAUDE.md`, `openspec/project.md`) MUST be English after W1; F7 chat-vs-artifacts MUST remain explicit in those files.

## Impact

- Files modified: `AGENTS.md`, `openspec/project.md`, `CLAUDE.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered)
- Risks: G-PT false positives on allowlisted tokens; G-INV if slash-commands/fences are rewritten; accidental semantic drift in R1–R11
- **Non-goals:** guide; skills; evaluations; course; `sdd-kit/templates/`; `openspec/changes/archive/`; path renames; dual-file `*.en.md` / `*-pt.md`; global G-DoD; `.cursor/rules/*.mdc` (wave-1b)

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files AGENTS.md,openspec/project.md,CLAUDE.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (no skills/commands), **G-MANIFEST** (no kit templates), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. `/opsx:propose`, `verify-i18n-wave.sh`, R10 infra read).

## Freeze / allowlist checklist

- [ ] Shell/CI fences byte-stable (except intentional non-i18n fixes)
- [ ] Paths, change-ids, `/opsx:*`, pins, brand names untouched
- [ ] Glossary forms used; new terms added to `GLOSSARY.md`
- [ ] No dual-file EN/PT siblings introduced
- [ ] F7 chat-vs-artifacts statement preserved in `AGENTS.md` and `openspec/project.md`

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-agents-rules-wave-1

Change: openspec/changes/translate-agents-rules-wave-1/
Ler: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md
Gate: bash scripts/verify-i18n-wave.sh --files AGENTS.md,openspec/project.md,CLAUDE.md
Infra: openspec/infra.md (assumir ✅ — não reinstalar)
```
