**Issue:** —

## Why

Active-changes wave-1 (open PR #110) owns the `add-correctness-review-skill` artifact trio. The next high-value completable whole-file residual on the WAr/active-changes track is the completed-change package `add-sdd-metrics-cadence-nudge` — `proposal.md` + `design.md` + `tasks.md` (~242 LOC, 3 files, residual Portuguese) — within ≤4 files / ≤350–400 LOC and disjoint from every open `translate-*` propose PR and active base ownership. Sibling delta specs under that change (if any) that are already English stay out of scope.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `openspec/changes/add-sdd-metrics-cadence-nudge/proposal.md`
  - `openspec/changes/add-sdd-metrics-cadence-nudge/design.md`
  - `openspec/changes/add-sdd-metrics-cadence-nudge/tasks.md`
- Preserve freeze-list tokens (paths, change-ids, skill names, `/opsx:*`, script flags such as `--check-cadence`, URLs, brand/tool names, fenced shell, checklist completion markers `[x]`) byte-stable aside from intentional non-i18n fixes
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-metrics-cadence-nudge/proposal.md,openspec/changes/add-sdd-metrics-cadence-nudge/design.md,openspec/changes/add-sdd-metrics-cadence-nudge/tasks.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed active-change artifacts for `add-sdd-metrics-cadence-nudge` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; historical apply outcomes (playbook, cadence nudge, stamp path, `--check-cadence`, N=5 / T=30 defaults, pilot exception, rollback plan) MUST keep the same meaning after prose is normalized.

## Impact

- Files modified: the three `add-sdd-metrics-cadence-nudge` artifact paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; paths not owned by active `translate-*` on base or open translate PRs #78 / #84 / #93–#110)
- Risks: G-PT false positives on quoted historical PT / proper nouns; G-INV if change-ids/script flags rewritten; accidental semantic drift of cadence thresholds or archive-handoff nudge contract (language only)
- **Non-goals:** other completed-change design/proposal/tasks still in PT (`add-sdd-metrics-script`, `add-probity-tdd-module`, `add-supply-chain-gates`, `add-sdd-discovery-positioning`); sibling explore research (owned by #108/#109; `explore-adversarial` over budget); correctness package (owned by #110); `openspec/changes/archive/`; canonical guide; curso `aula-05` / design `001` (over budget); kit templates; dual-file `*.en.md` / `*-pt.md`; global G-DoD; re-opening metrics-cadence product decisions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-metrics-cadence-nudge/proposal.md,openspec/changes/add-sdd-metrics-cadence-nudge/design.md,openspec/changes/add-sdd-metrics-cadence-nudge/tasks.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. playbook Interpret→act; `--check-cadence` advisory-only on archive handoff; stamp `.sdd/metrics-last-run` + N=5 / T=30 defaults).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids (`add-sdd-metrics-cadence-nudge`, `add-sdd-metrics-script`, …), skill names (`openspec-archive-change`), `/opsx:*`, script flags (`--check-cadence`), URLs, brand/tool names untouched
- [ ] Historical task completion markers `[x]` and Gate/Pattern lines remain structurally intact (prose language only)
- [ ] Cadence thresholds (N=5, T=30), stamp path, and advisory-only nudge semantics unchanged
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — Session Handoff / gate / change / wave / metrics already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links and change-id references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-metrics-cadence-wave-1

Change: openspec/changes/translate-metrics-cadence-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-metrics-cadence-nudge/proposal.md,openspec/changes/add-sdd-metrics-cadence-nudge/design.md,openspec/changes/add-sdd-metrics-cadence-nudge/tasks.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
