# Tasks — add-sdd-metrics-script

> Apply scope after human approval (R7). G4 qualifies for **pilot exception** (no external binary/hook/service/LLM — local bash script). **Non-goal:** Apache DevLake. **Issue:** —

## 1. Metrics script (hub)

- [x] 1.1 Create executable `scripts/sdd-metrics.sh`: bash + git; flags `--since YYYY-MM-DD`, `--output PATH`, `--help`; exit 0 with report, exit 2 on invalid usage; sections M1 volume, M2 lead time propose→archive, M3 post-archive rework `fix` + change-id, M4 post-archive activity; proxy notes in report (design D3–D5)
  - **Pattern:** `scripts/sdd-session-status.sh`
  - **Invariants:** `sdd-metrics` — Local metrics script exists and is executable; Report covers volume, lead time, and post-archive rework; CLI flags for since-filter, output file, and help
  - **Gate:** `test -x scripts/sdd-metrics.sh && bash scripts/sdd-metrics.sh --help >/dev/null && bash scripts/sdd-metrics.sh | grep -qE 'M1|Volume|Lead|Rework|propose'`

- [x] 1.2 Validate dry-run in hub: markdown report with at least one existing archive or explicit zero-archives message; `--since` filters; `--output` writes file
  - **Pattern:** `scripts/sdd-session-status.sh`
  - **Gate:** `bash scripts/sdd-metrics.sh --since 2020-01-01 --output /tmp/sdd-metrics-file.md >/tmp/sdd-metrics-out.md && test -s /tmp/sdd-metrics-out.md && diff -q /tmp/sdd-metrics-out.md /tmp/sdd-metrics-file.md && bash scripts/sdd-metrics.sh --since 2099-01-01 | grep -q '0'`

## 2. sdd-kit distribution (R6)

- [x] 2.1 Copy script to `sdd-kit/templates/scripts/sdd-metrics.sh` (hub/template parity)
  - **Pattern:** `sdd-kit/templates/scripts/sdd-session-status.sh`
  - **Invariants:** `sdd-install-kit` — Metrics script distributed via install kit
  - **Gate:** `diff -q scripts/sdd-metrics.sh sdd-kit/templates/scripts/sdd-metrics.sh`

- [x] 2.2 Add `scripts/sdd-metrics.sh` entry in `sdd-kit/MANIFEST.yaml` (`merge: COPY`, `profiles: [APP, DOCS_SPECS, HYBRID]`, documentary `gate:`); bump `version` and `guide_version` 1.5.0 → **1.6.0**; run `bash sdd-kit/gen-manifest-checksums.sh`
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Invariants:** `sdd-install-kit` — Metrics script distributed via install kit
  - **Gate:** `grep -q 'sdd-metrics.sh' sdd-kit/MANIFEST.yaml && grep -q 'version: "1.6.0"' sdd-kit/MANIFEST.yaml && grep -A6 'sdd-metrics.sh' sdd-kit/MANIFEST.yaml | grep -q 'sha256:'`

- [x] 2.3 Update `sdd-kit/verify.sh` and/or `sdd-kit/README.md` if kit pattern requires check/documentation for the new script (minimum: README mentions `sdd-metrics.sh`)
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `grep -q 'sdd-metrics' sdd-kit/README.md || grep -q 'sdd-metrics' sdd-kit/verify.sh`

## 3. openspec/infra.md (R1)

- [x] 3.1 Add Metrics / `sdd-metrics.sh` entry in `openspec/infra.md` (status + verify with)
  - **Pattern:** `openspec/infra.md`
  - **Invariants:** `sdd-workspace-manifest` — SDD metrics script registered in infrastructure manifest
  - **Gate:** `grep -q 'sdd-metrics' openspec/infra.md`

- [x] 3.2 Mirror in `sdd-kit/templates/openspec/infra.md`
  - **Pattern:** `sdd-kit/templates/openspec/infra.md`
  - **Gate:** `grep -q 'sdd-metrics' sdd-kit/templates/openspec/infra.md`

## 4. AGENTS.md (R2)

- [x] 4.1 Update `AGENTS.md`: line in Commands table (`bash scripts/sdd-metrics.sh`); ≤10 lines in Integrations / On-demand context (mode C, proxies, no DevLake); **no** new skill/rule (R3 N/A)
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-metrics` — On-demand mode C — not a CI gate
  - **Gate:** `grep -q 'sdd-metrics.sh' AGENTS.md`

- [x] 4.2 Mirror in `sdd-kit/templates/AGENTS.core.md`
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Gate:** `grep -q 'sdd-metrics.sh' sdd-kit/templates/AGENTS.core.md`

## 5. Canonical guide §2.17 (R4)

- [x] 5.1 Add **§2.17 SDD metrics (sdd-metrics.sh)** in `doc/sistema-sdd-pedro.md`: when to run; how to read M1–M4; proxies and limits; troubleshooting; rollback; explicit note that DevLake remains out of scope
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q '2.17' doc/sistema-sdd-pedro.md && grep -q 'sdd-metrics' doc/sistema-sdd-pedro.md`

- [x] 5.2 Update index, "How to use this document", and guide Changelog (v1.6.0) with pointer to §2.17; align `openspec/project.md` if it references kit/guide version
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q '1.6.0' doc/sistema-sdd-pedro.md && grep -q 'sdd-metrics' openspec/project.md`

## 6. Evaluation (R5)

- [x] 6.1 Update `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G4 — manual fix `sdd-metrics.sh` → **Adopted** (change `add-sdd-metrics-script`); Apache DevLake remains **Deferred** with unchanged re-evaluation condition
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Invariants:** `sdd-metrics` — DevLake remains out of scope
  - **Gate:** `grep -q 'add-sdd-metrics-script' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md && grep -q 'sdd-metrics' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`

## 7. Specs — promotion

- [x] 7.1 Promote `openspec/changes/add-sdd-metrics-script/specs/sdd-metrics/spec.md` to `openspec/specs/sdd-metrics/spec.md`
  - **Pattern:** `openspec/specs/sdd-ci-gates/spec.md`
  - **Gate:** `test -f openspec/specs/sdd-metrics/spec.md`

- [x] 7.2 Apply `sdd-install-kit` and `sdd-workspace-manifest` deltas in `openspec/specs/` (merge ADDED)
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Gate:** `grep -q 'sdd-metrics' openspec/specs/sdd-install-kit/spec.md && grep -q 'sdd-metrics' openspec/specs/sdd-workspace-manifest/spec.md`

## 8. Validation

- [x] 8.1 Run `bash scripts/verify-task-patterns.sh` on this `tasks.md`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [x] 8.2 Validate change with openspec CLI
  - **Pattern:** `openspec/changes/add-sdd-metrics-script/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-sdd-metrics-script --strict`

## 9. Post-register (best-effort)

- [x] 9.1 `graphify update .` + `npx gitnexus analyze --force` if available
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify ❌ in infra.md)'`
