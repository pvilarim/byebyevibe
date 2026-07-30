**Issue:** —

## Why

Hub design waves 1–2 own `doc/design/002|003|004` and `000`. The pipeline reference `doc/design/001-pipeline-open-design-shadcn-impeccable.md` (~592 LOC) was explicitly deferred (over single-wave budget). This change covers lines **1–325** (§1–§3.4 pipeline overview through DESIGN.md schema, ~325 LOC) — within ≤350–400 LOC. First half of the split; wave-4 covers the remainder.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** in:
  - `doc/design/001-pipeline-open-design-shadcn-impeccable.md` (lines **1–325** only)
- Preserve freeze-list tokens, relative links to `000`/`002`/`003`/canonical guide, shadcn/Impeccable/Open Design brand names, fenced shell
- Expand `doc/i18n/GLOSSARY.md` only if new SDD terms appear
- Run `bash scripts/verify-i18n-wave.sh --files doc/design/001-pipeline-open-design-shadcn-impeccable.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `doc/design/001-pipeline-open-design-shadcn-impeccable.md` slice lines 1–325 MUST be English after substitution.

## Impact

- Files modified: `doc/design/001-pipeline-open-design-shadcn-impeccable.md` (lines 1–325); optional `doc/i18n/GLOSSARY.md`
- **Apply prerequisite:** `translate-design-wave-2` apply+archive before this wave's apply
- **Non-goals:** lines outside slice; dual-file siblings; global G-DoD; changing pipeline recommendations — language only

## Required gates

```bash
bash scripts/verify-i18n-wave.sh --files doc/design/001-pipeline-open-design-shadcn-impeccable.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-design-wave-3

Change: openspec/changes/translate-design-wave-3/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md
Gate: bash scripts/verify-i18n-wave.sh --files doc/design/001-pipeline-open-design-shadcn-impeccable.md
```
