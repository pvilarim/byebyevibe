**Issue:** —

## Why

Curso wave-1 (open DRAFT PR #99) owns workshop lesson 04; curso wave-2 (open DRAFT PR #100) owns workshop lesson 03; curso wave-3 (open DRAFT PR #101) owns workshop lesson 02. The next completable whole-file residual on the WCu (`doc/curso/`) track is workshop lesson 01 (`doc/curso/aula-01-workshop-ia-5-2026.md`, ~212 LOC / 1 file): within budgets, path-disjoint from active `translate-*` ownership and open translate PRs (including #99–#101), and avoidable of mid-file guide G-PT. Dense aula-05 (~503, over budget alone) and `doc/curso/scripts/AGENTS.md` stay deferred to later curso waves.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `doc/curso/aula-01-workshop-ia-5-2026.md`
- Preserve freeze-list tokens (paths, URLs, brand/tool names including Cursor / AGENTS.md / CLAUDE.md / MCP / Linear / Confluence / Anthropic / Tech Leads Club / DORA / METR / Excalidraw / Uncle Bob / Chip Huyen / Matt Pocock / Waldemar Neto, transcript IDs, relative link to `aula-01-shared-files.md`, fenced/backticked paths) byte-stable
- Translate structured chrome (title, summary, topics, link-table category labels, spoken-reference blurbs, “how to use” blurb) **and** the spoken transcript body to English so G-PT passes on the whole file (workshop talk content rendered in EN; not dual-file)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files doc/curso/aula-01-workshop-ia-5-2026.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed course lesson surface MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved.

## Impact

- Files modified: `doc/curso/aula-01-workshop-ia-5-2026.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path not owned by active `translate-*` changes or open translate PRs #78 / #84 / #93–#101)
- Risks: G-PT false positives on allowlisted proper nouns; G-INV if URLs/paths rewritten; semantic drift of adoption / Context Engineering / RPI talk facts (language only); over-aggressive rewriting of speaker proper names
- **Non-goals:** other `doc/curso/aula-0*.md` lessons (including aula-02 owned by `translate-curso-wave-3`, aula-03 owned by `translate-curso-wave-2`, and aula-04 owned by `translate-curso-wave-1`); `doc/curso/aula-*-shared-files.md`; `doc/curso/scripts/AGENTS.md`; canonical guide; skills/commands; kit templates; hub `openspec/infra.md`; evaluations; design docs; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing workshop facts or tooling recommendations — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files doc/curso/aula-01-workshop-ia-5-2026.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. open shared-files link table; use summary/topics for quick context; cross-reference spoken content with `aula-01-shared-files.md`).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, URLs, brand/tool names, speaker/org names (Waldemar Neto / Valdemar, Cursor, AGENTS.md, CLAUDE.md, MCP, Linear, Confluence, Anthropic, Tech Leads Club, DORA, METR, Excalidraw, Uncle Bob, Chip Huyen, Matt Pocock, Pragmatic Engineer), transcript/lesson IDs, relative link to `aula-01-shared-files.md` untouched as path/URL strings
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — Session Handoff / wave / evaluation / Definition of Done already seeded; course-local terms map via ordinary EN)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links to `./aula-01-shared-files.md` still resolve (G-LINK)
- [ ] Allowlist: proper nouns, URLs, emoji category markers in the link table may remain; do **not** leave raw Portuguese transcript prose after apply (whole-file G-PT)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-curso-wave-4

Change: openspec/changes/translate-curso-wave-4/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files doc/curso/aula-01-workshop-ia-5-2026.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
