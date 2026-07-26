# Wave proposal template — `translate-<surface>-wave-N`

Copy into a new OpenSpec change (do **not** edit this file as the live proposal).  
Pattern: `sdd-kit/templates/openspec/changes/_template/proposal.md` · Policy: `sdd-docs-language`.

---

**Issue:** —

## Why

Substitute legacy Portuguese prose with canonical English **in-place** on the listed surface slice, within wave budgets (≤350–400 LOC, ≤4 files or 1 skill×2 mirrors). This is **not** an “add English layer” change — dual-file `*.en.md` / `*-pt.md` is **forbidden**.

## What Changes

- Replace Portuguese prose with glossary-canonical English in:
  - `[list exact paths]`
- Expand `doc/i18n/GLOSSARY.md` if new terms are introduced (same wave)
- Run `bash scripts/verify-i18n-wave.sh --files <comma-separated-paths>`

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- _(none unless a spec requirement changes)_

## Impact

- Files modified: `[paths]`
- Dependencies: none
- Risks: G-PT false positives (allowlist); G-INV if fences are rewritten; mirror drift (G-MIRROR); kit checksums (G-MANIFEST)
- Non-goals: path renames; rewriting `openspec/changes/archive/`; root CHANGELOG (F3); global DoD (WDoD separate)

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files path1,path2,...
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MIRROR** (if skills/commands), **G-MANIFEST** (if `sdd-kit/templates/`), **G-OPENSPEC**.

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text.

**G-DoD:** only for the final global wave — `bash scripts/verify-i18n-wave.sh --dod`.

## Freeze / allowlist checklist

- [ ] Shell/CI fences byte-stable (except intentional non-i18n fixes)
- [ ] Paths, change-ids, `/opsx:*`, pins, brand names untouched
- [ ] Glossary forms used; new terms added to `GLOSSARY.md`
- [ ] No dual-file EN/PT siblings introduced
- [ ] `.cursor` and `.claude` mirrors updated together when either is in scope

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-<surface>-wave-N
# or /opsx:archive translate-<surface>-wave-N

Change: openspec/changes/translate-<surface>-wave-N/
Ler: tasks.md (progress), doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md
Gate: bash scripts/verify-i18n-wave.sh --files <paths>
Infra: openspec/infra.md (assumir ✅ — não reinstalar)
```
