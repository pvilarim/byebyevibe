## Why

Without data on rework, propose→archive lead time, and changes fixed post-archive, it is impossible to calibrate SDD pipeline overhead. Type E research (`explore-oss-coverage-gaps`, gap **G4**) evaluated **Apache DevLake** and **deferred** adoption: a heavy DORA platform (MySQL + Grafana + workers) that does not measure SDD-specific metrics. The anchored decision was a **manual fix** — local script `scripts/sdd-metrics.sh` derived from git + `openspec/changes/archive/`.

**Objective:** materialize gap G4 as an on-demand script (mode **C**), without adopting DevLake, without a new binary/hook/service, and distribute it via `sdd-kit` with registration in the 6-point contract.

This insertion qualifies for the **pilot exception** (`metodologia-insercao.md` Phase 2): local bash script (git + filesystem), no external binary, hook, or LLM consumption → **Phase 1 → Phase 3 direct** (G1 precedent `add-sdd-ci-gates-workflow`).

## What Changes

- **Script `scripts/sdd-metrics.sh`:** on-demand markdown report with (1) count of active/archived changes by period, (2) propose→archive lead time (proxy: first commit containing change-id → archive date), (3) rework proxy (`fix:` post-archive referencing change-id, R9), (4) changes/commits post-archive touching archived work.
- **Kit template:** `sdd-kit/templates/scripts/sdd-metrics.sh` + entry in `MANIFEST.yaml` (bump 1.5.0 → **1.6.0**) + check in `verify.sh` if applicable.
- **6-point contract registration:** `infra.md`, `AGENTS.md`, guide §2.17, G4 evaluation (script Adopted; DevLake remains Deferred), kit.
- **Delta specs:** new capability `sdd-metrics`; extension of `sdd-install-kit` (script distribution) and `sdd-workspace-manifest` (line in `infra.md`).
- **R3 skill/rule:** **N/A** — on-demand command documented in AGENTS.md (≤10 lines), no dedicated skill.

## Capabilities

### New Capabilities

- `sdd-metrics`: Local on-demand script (mode C) that generates a markdown report on SDD framework effectiveness from git + OpenSpec archive; propose→archive, rework, and post-archive activity metrics; no DevLake.

### Modified Capabilities

- `sdd-install-kit`: `MANIFEST.yaml` lists `scripts/sdd-metrics.sh` (template + documentary gate); kit version bump.
- `sdd-workspace-manifest`: `openspec/infra.md` gains registration of the metrics script (status + "verify with").

## Impact

- New: `scripts/sdd-metrics.sh`, `sdd-kit/templates/scripts/sdd-metrics.sh`
- Modified: `sdd-kit/MANIFEST.yaml` (entry + bump 1.5.0 → 1.6.0 + checksums), possibly `sdd-kit/verify.sh` / `sdd-kit/README.md`
- Modified: `openspec/infra.md`, `sdd-kit/templates/openspec/infra.md`
- Modified: `AGENTS.md`, `sdd-kit/templates/AGENTS.core.md`
- Modified: `doc/sistema-sdd-pedro.md` (new §2.17 + index/changelog)
- Modified: `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` (G4: script Adopted; DevLake Deferred)
- Modified: `openspec/project.md` (kit version / cross-ref if needed)
- New spec: `openspec/specs/sdd-metrics/spec.md` (promoted on archive)
- **Non-goals:** Apache DevLake; Grafana/DORA dashboards; mandatory CI metrics; always-on skill; per-tool counters (future Phase 5 methodology extension).
- **Issue:** —
