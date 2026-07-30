**Issue:** —

## Why

Metrics-cadence wave-1 (open PR #111) owns the `add-sdd-metrics-cadence-nudge` artifact trio. The next high-value completable whole-file residual on the WAr/active-changes track is the completed-change package `add-sdd-metrics-script` — `proposal.md` + `design.md` + `tasks.md` (~340 LOC, 3 files, residual Portuguese) — within ≤4 files / ≤350–400 LOC and disjoint from every open `translate-*` propose PR and active base ownership. Sibling delta specs under that change are already English (0 deny-list hits) and stay out of scope.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `openspec/changes/add-sdd-metrics-script/proposal.md`
  - `openspec/changes/add-sdd-metrics-script/design.md`
  - `openspec/changes/add-sdd-metrics-script/tasks.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, script flags such as `--since` / `--output` / `--help`, URLs, brand/tool names, fenced shell, MANIFEST keys, checklist completion markers `[x]`) byte-stable aside from intentional non-i18n fixes
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-metrics-script/proposal.md,openspec/changes/add-sdd-metrics-script/design.md,openspec/changes/add-sdd-metrics-script/tasks.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed active-change artifacts for `add-sdd-metrics-script` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; historical apply outcomes (mode C script, M1–M4 proxies, kit MANIFEST 1.5.0→1.6.0, 6-point registry, pilot exception, DevLake remains deferred, rollback plan) MUST keep the same meaning after prose is normalized.

## Impact

- Files modified: the three `add-sdd-metrics-script` artifact paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; paths not owned by active `translate-*` on base or open translate PRs #78 / #84 / #93–#111)
- Risks: G-PT false positives on quoted historical PT / proper nouns; G-INV if change-ids/script flags/MANIFEST keys rewritten; accidental semantic drift of M1–M4 proxy definitions or mode-C / no-DevLake contract (language only)
- **Non-goals:** sibling specs under `add-sdd-metrics-script/specs/` (already EN); other completed-change design/proposal/tasks still in PT (`add-probity-tdd-module`, `add-supply-chain-gates`, `add-sdd-discovery-positioning`); metrics-cadence package (owned by #111); correctness package (owned by #110); sibling explore research (owned by #108/#109; `explore-adversarial` over budget); `openspec/changes/archive/`; canonical guide; curso `aula-05` / design `001` (over budget); kit templates; dual-file `*.en.md` / `*-pt.md`; global G-DoD; re-opening metrics-script product decisions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-metrics-script/proposal.md,openspec/changes/add-sdd-metrics-script/design.md,openspec/changes/add-sdd-metrics-script/tasks.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. mode C `bash scripts/sdd-metrics.sh` on demand; M1–M4 proxy definitions; DevLake remains out of scope / deferred).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids (`add-sdd-metrics-script`, `explore-oss-coverage-gaps`, …), `/opsx:*`, script flags (`--since`, `--output`, `--help`), MANIFEST keys (`merge:`, `gate:`, `sha256:`), URLs, brand/tool names untouched
- [ ] Historical task completion markers `[x]` and Gate/Pattern lines remain structurally intact (prose language only)
- [ ] M1–M4 metric definitions, mode C, kit bump 1.5.0→1.6.0, and DevLake-deferred semantics unchanged
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — Session Handoff / gate / change / wave / metrics already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links and change-id references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-metrics-script-wave-1

Change: openspec/changes/translate-metrics-script-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-metrics-script/proposal.md,openspec/changes/add-sdd-metrics-script/design.md,openspec/changes/add-sdd-metrics-script/tasks.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
