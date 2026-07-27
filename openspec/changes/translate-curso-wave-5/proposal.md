**Issue:** —

## Why

Curso waves 1–4 (open DRAFT PRs #99–#102) own workshop lessons 04, 03, 02, and 01 respectively. The next completable whole-file residual on the WCu (`doc/curso/`) track is the course-scripts local agents file (`doc/curso/scripts/AGENTS.md`, ~28 LOC / 1 file): within budgets, path-disjoint from active `translate-*` ownership and open translate PRs (including #99–#102), and avoidable of mid-file guide G-PT. Dense aula-05 (~503, over budget alone) stays deferred to a later split wave.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `doc/curso/scripts/AGENTS.md`
- Preserve freeze-list tokens (paths including `../../../AGENTS.md` and `doc/curso/scripts/`, script names `extract-lessons-batch.py` / `enrich-transcripts.py` / `_debug-lessons345.py`, CDP flag `--remote-debugging-port=9222`, VTT path `techleads.club/media_transcripts/`, brand/org **Tech Leads Club**, fenced/backticked commands, A–E protocol reference) byte-stable
- Translate structured chrome (title blurb, Commands table header/usage blurbs, Prerequisites / Local rules / Flow headings and prose) so G-PT passes on the whole file
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files doc/curso/scripts/AGENTS.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed course-scripts AGENTS surface MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved.

## Impact

- Files modified: `doc/curso/scripts/AGENTS.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path not owned by active `translate-*` changes or open translate PRs #78 / #84 / #93–#102 — prior curso waves list this path as an explicit non-goal)
- Risks: G-PT false positives on allowlisted proper nouns / path segments; G-INV if script names, CDP flags, or root `AGENTS.md` path rewritten; accidental semantic drift of extract/enrich workflow (language only)
- **Non-goals:** workshop lessons `doc/curso/aula-0*-workshop-*.md` (owned by `translate-curso-wave-1`..`4` / PRs #99–#102); `doc/curso/aula-*-shared-files.md`; aula-05 (over LOC — split later); root `AGENTS.md` / `CLAUDE.md`; canonical guide; skills/commands; kit templates; hub `openspec/infra.md`; evaluations; design docs; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing script CLI behavior or CDP workflow semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files doc/curso/scripts/AGENTS.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. run `extract-lessons-batch.py` with Chrome CDP on port 9222; prefer VTT from `techleads.club/media_transcripts/`; inherit A–E + security from root `AGENTS.md` without committing session tokens).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`../../../AGENTS.md`, `doc/curso/scripts/`), script filenames, CDP flag `--remote-debugging-port=9222`, VTT host path `techleads.club/media_transcripts/`, brand/org **Tech Leads Club**, output filename patterns `aula-XX-workshop-*.md` / `aula-XX-shared-files.md` untouched as path/command strings
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — Session Handoff / wave / canonical already seeded; course-script terms map via ordinary EN)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative path to root `AGENTS.md` still resolves as documented (G-LINK N/A for non-markdown-link prose path; keep string intact)
- [ ] Allowlist: proper nouns, URLs/hosts, script identifiers may remain; do **not** leave residual Portuguese prose after apply (whole-file G-PT)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-curso-wave-5

Change: openspec/changes/translate-curso-wave-5/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files doc/curso/scripts/AGENTS.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
