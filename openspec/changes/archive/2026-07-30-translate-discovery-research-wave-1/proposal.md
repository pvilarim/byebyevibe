**Issue:** —

## Why

`translate-discovery-wave-1` (merged PR #113) owns the `add-sdd-discovery-positioning` artifact trio (`proposal.md`, `design.md`, `tasks.md`) and explicitly deferred sibling `research.md` (~404 LOC alone — over the ≤350–400 whole-file budget). Canonical guide slices are fully proposed (`translate-guide-wave-1`..`14` on base); kit/hub install-critical paths are covered by kit-scripts waves 1–6 and related proposes. The next disjoint, install-adjacent completable slice is **lines 1–261** of `openspec/changes/add-sdd-discovery-positioning/research.md` (§1–§10 AS-IS diagnosis through references, ~261 LOC) — within the mid-file slice budget. Apply is sequential per slice on the same file; proposes for disjoint slices may merge in parallel.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** in `openspec/changes/add-sdd-discovery-positioning/research.md` for lines **1–261** only (§1–§10 AS-IS diagnosis, positioning, SEO terms, semantic network, competition, dual bias, recommended README structure, risks, pre-apply decisions, references)
- Do **not** edit lines outside this slice in the same apply session
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, URLs, brand/tool names, decision ids P0–P10 / D1–D11 references in §9, GitHub topic links, fenced shell) byte-stable aside from intentional non-i18n fixes
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md` before marking tasks done (whole-file gate; slice must leave zero PT in touched lines)

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — discovery research slice lines 1–261 of `openspec/changes/add-sdd-discovery-positioning/research.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; §9 pre-apply decision defaults and §10 reference links MUST keep the same meaning after label language is normalized.

## Impact

- Files modified: `openspec/changes/add-sdd-discovery-positioning/research.md` (lines 1–261 only; optional `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: **soft** — apply SHOULD wait until `translate-discovery-wave-1` apply has landed the artifact trio EN (otherwise whole-file G-PT may still fail on sibling paths in the same change directory). Propose is disjoint and may proceed in parallel with other translate proposes.
- Risks: G-PT scans whole file — out-of-slice PT in §11–§12 causes false FAIL until `translate-discovery-research-wave-2` apply; accidental edits outside slice; broken anchor links after heading translation (G-LINK); semantic drift of §9 decision defaults (language only)
- **Non-goals:** lines outside 1–261 (§11–§12 roadmap + G4 README hook — deferred to `translate-discovery-research-wave-2`); `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (owned by `translate-avaliacoes-wave-2`); discovery artifact trio (owned by `translate-discovery-wave-1`); `explore-adversarial-sdd-review/research.md` (over budget — separate split track); `openspec/changes/archive/`; canonical guide; `doc/curso/**`; dual-file `*.en.md` / `*-pt.md`; global G-DoD; re-opening discovery product decisions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. §9 P6–P8 / BMAD / Landing / Discord non-goals; §9 full EN translation deferred until stable name (§11 step ④ cross-ref preserved as reference); §10 reference links still resolve).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Edits confined to lines 1–261
- [ ] Paths, change-ids (`add-sdd-discovery-positioning`, `explore-oss-coverage-gaps`, …), `/opsx:*`, decision ids (P0–P10, D1–D11 where cited), URLs, brand/tool names untouched
- [ ] §9 pre-apply decision table semantics unchanged (only label language)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — evaluation/discovery/wave/glossary already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative / absolute links and change-id references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-discovery-research-wave-1

Change: openspec/changes/translate-discovery-research-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
Prerequisite (soft): prefer apply after translate-discovery-wave-1 artifact trio is EN
```
