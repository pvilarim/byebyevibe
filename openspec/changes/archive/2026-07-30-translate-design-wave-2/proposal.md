**Issue:** —

## Why

Design wave-1 owns hub `doc/design/002|003|004`. The next completable whole-file residual on the design track is the Impeccable reference guide (`doc/design/000-impeccable-design-system-guia.md`, ~311 LOC / 1 file): within budgets, disjoint from kit/infra/skills/avaliacoes ownership and open translate PRs, and avoidable of mid-file guide G-PT. Pipeline doc `001` (~592 LOC) stays deferred for a later split.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `doc/design/000-impeccable-design-system-guia.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, URLs, brand/tool names including Impeccable / shadcn / ByeByeVibe, fenced shell, status marker `[REFERÊNCIA — REQUER ADAPTAÇÃO]` → English equivalent label only if G-PT requires, profile label `DOCS_SPECS`, applicability marker `[se aplicável]` → `[if applicable]`) while keeping reference/adaptation semantics intact
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files doc/design/000-impeccable-design-system-guia.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed Impeccable design reference guide MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved.

## Impact

- Files modified: `doc/design/000-impeccable-design-system-guia.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path not owned by active `translate-*` changes or open translate PRs #78 / #84; disjoint from `translate-design-wave-1` paths)
- Risks: G-PT false positives on allowlisted tokens / path segments; G-INV if script paths/`/opsx:*`/pins are rewritten; accidental semantic drift of adoption checklist or DOCS_SPECS applicability notes (language only)
- **Non-goals:** `doc/design/001-pipeline-open-design-shadcn-impeccable.md` (over LOC — split later); `doc/design/002|003|004` (wave-1); `sdd-kit/templates/doc/design/` mirrors (checksum-aware later wave); canonical guide; skills/commands; kit rules templates; hub `openspec/infra.md`; evaluations; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing Impeccable adoption recommendations — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files doc/design/000-impeccable-design-system-guia.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. keep shadcn as default Fase 2 path; respect DOCS_SPECS hub vs APP-target applicability; follow adopt checklist without installing Impeccable on this DOCS_SPECS hub).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, package pins, URLs, brand/tool names, profile `DOCS_SPECS`, relative links to `002`/`003`/`001`/`doc/sistema-sdd-pedro.md` untouched as path strings
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — design system / install kit / canonical / Session Handoff already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links among `doc/design/*` and to the canonical guide still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-design-wave-2

Change: openspec/changes/translate-design-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files doc/design/000-impeccable-design-system-guia.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
