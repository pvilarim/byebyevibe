**Issue:** —

## Why

`translate-discovery-research-wave-1` (merged PR #131) owns `openspec/changes/add-sdd-discovery-positioning/research.md` lines **1–261** (§1–§10) and explicitly deferred sibling lines **262–404** (§11–§12 roadmap + G4 README hook, ~143 LOC). Canonical guide slices are fully proposed (`translate-guide-wave-1`..`14` on base); kit/hub install-critical paths are covered by kit-scripts waves 1–6 and related proposes. The next disjoint, install-adjacent completable slice is **lines 262–404** only — within the ≤350–400 LOC mid-file slice budget. Apply is sequential per slice on the same file; proposes for disjoint slices may merge in parallel.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** in `openspec/changes/add-sdd-discovery-positioning/research.md` for lines **262–404** only (§11–§12 dissemination roadmap + SDD Metrics G4 README hook)
- Do **not** edit lines outside this slice in the same apply session
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, URLs, brand/tool names, step ids ①–⑥, decision ids P5–P10 / D9 where cited, fenced shell, quoted EN copy blocks in §12.4) byte-stable aside from intentional non-i18n fixes
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md` before marking tasks done (whole-file gate; slice must leave zero PT in touched lines)

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — discovery research slice lines 262–404 of `openspec/changes/add-sdd-discovery-positioning/research.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; §11 canonical sequence (steps ①–⑥), §12.4 permitted vs forbidden README copy, and §12.5 apply-① decision MUST keep the same meaning after label language is normalized.

## Impact

- Files modified: `openspec/changes/add-sdd-discovery-positioning/research.md` (lines 262–404 only; optional `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: **soft** — apply SHOULD wait until `translate-discovery-research-wave-1` apply has landed lines 1–261 EN (otherwise whole-file G-PT may still fail on sibling paths in the same file). Propose is disjoint and may proceed in parallel with other translate proposes.
- Risks: G-PT scans whole file — out-of-slice PT in lines 1–261 causes false FAIL until wave-1 apply completes; accidental edits outside slice; broken anchor links after heading translation (G-LINK); semantic drift of §11 step order or §12 honest-metrics claims (language only)
- **Non-goals:** lines outside 262–404; `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (owned by `translate-avaliacoes-wave-2`); discovery artifact trio (owned by `translate-discovery-wave-1`); `explore-adversarial-sdd-review/research.md` (over budget — separate split track); `openspec/changes/archive/`; canonical guide; `doc/curso/**`; dual-file `*.en.md` / `*-pt.md`; global G-DoD; re-opening discovery product decisions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. §11 steps ①–⑥ order and non-goals; §12.4 permitted vs forbidden README claims; §12.5 apply-① decision to include honest G4 hook without auto-learning claims).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Edits confined to lines 262–404
- [ ] Paths, change-ids (`add-sdd-discovery-positioning`, `add-english-docs-policy`, `explore-sdd-kit-public-name`, …), `/opsx:*`, step ids (①–⑥), decision ids (P5, D9, …), URLs, brand/tool names untouched
- [ ] §11 canonical sequence and §12.5 apply-① decision semantics unchanged (only label language)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — wave/glossary/evaluation/metrics already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative / absolute links and change-id references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-discovery-research-wave-2

Change: openspec/changes/translate-discovery-research-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
Prerequisite (soft): prefer apply after translate-discovery-research-wave-1 lines 1–261 are EN
```
