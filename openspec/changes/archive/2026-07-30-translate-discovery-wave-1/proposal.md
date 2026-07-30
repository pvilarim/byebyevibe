**Issue:** —

## Why

Metrics-script wave-1 (open PR #112) owns the `add-sdd-metrics-script` artifact trio. The next high-value completable whole-file residual on the WAr/active-changes track is the completed-change package `add-sdd-discovery-positioning` — `proposal.md` + `design.md` + `tasks.md` (~246 LOC, 3 files, residual Portuguese) — within ≤4 files / ≤350–400 LOC and disjoint from every open `translate-*` propose PR and active base ownership. Sibling `research.md` (~404 LOC alone) exceeds budget and stays deferred; promoted evaluation under `doc/avaliacoes/` is owned by avaliacoes-wave-2 (PR #84).

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `openspec/changes/add-sdd-discovery-positioning/proposal.md`
  - `openspec/changes/add-sdd-discovery-positioning/design.md`
  - `openspec/changes/add-sdd-discovery-positioning/tasks.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, URLs, brand/tool names, fenced shell, checklist completion markers `[x]`, research section anchors such as `§11` / `§12`, decision ids D1–D11) byte-stable aside from intentional non-i18n fixes
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/proposal.md,openspec/changes/add-sdd-discovery-positioning/design.md,openspec/changes/add-sdd-discovery-positioning/tasks.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed active-change artifacts for `add-sdd-discovery-positioning` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; historical apply outcomes (EN root README / discovery positioning, evaluation promotion, kit README framing, guide quickstart, D9 non-goals, D10 README→name→EN→GIF roadmap, D11 metrics blurb without ML claims, manual About/topics checklist) MUST keep the same meaning after prose is normalized.

## Impact

- Files modified: the three `add-sdd-discovery-positioning` artifact paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; paths not owned by active `translate-*` on base or open translate PRs #78 / #84 / #93–#112)
- Risks: G-PT false positives on quoted historical PT / proper nouns; G-INV if change-ids/paths rewritten; accidental semantic drift of D9/D10/D11 product decisions (language only)
- **Non-goals:** sibling `research.md` (over LOC — later split); `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (owned by avaliacoes-wave-2 / PR #84); other completed-change design/proposal/tasks still in PT (`add-probity-tdd-module`, `add-supply-chain-gates`); metrics-script / metrics-cadence / correctness packages (owned by #110–#112); sibling explore research (owned by #108/#109; `explore-adversarial` over budget); `openspec/changes/archive/`; canonical guide; curso `aula-05` / design `001` (over budget); kit templates; dual-file `*.en.md` / `*-pt.md`; global G-DoD; re-opening discovery product decisions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/proposal.md,openspec/changes/add-sdd-discovery-positioning/design.md,openspec/changes/add-sdd-discovery-positioning/tasks.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. D9 permanent non-goals; D10 README→name→EN→GIF sequence; D11 metrics framing without ML claims).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids (`add-sdd-discovery-positioning`, `sdd-discovery-positioning`, …), `/opsx:*`, research section anchors (`§11`, `§12`), decision ids (D1–D11 / P0–P10), URLs, brand/tool names untouched
- [ ] Historical task completion markers `[x]` and Gate/Pattern lines remain structurally intact (prose language only)
- [ ] D9 non-goals, D10 roadmap order, and D11 metrics-blurb semantics unchanged
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — Session Handoff / gate / change / wave / discovery already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links and change-id references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-discovery-wave-1

Change: openspec/changes/translate-discovery-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/proposal.md,openspec/changes/add-sdd-discovery-positioning/design.md,openspec/changes/add-sdd-discovery-positioning/tasks.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
