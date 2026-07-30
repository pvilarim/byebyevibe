# Tasks — add-supply-chain-gates

> Apply scope after human approval (R7/R11). G8 OSV qualifies for pilot exception (CI step + template only). Renovate: manual checklist in guide §2.13. **Prerequisite:** G1 (`sdd-gates.yml`) implemented.

## 1. OSV-Scanner in workflow (R6 — hub + template)

- [x] 1.1 Add `OSV-Scanner (blocking)` step in `.github/workflows/sdd-gates.yml`: `if` with `hashFiles` for supported lockfiles; `uses: google/osv-scanner-action/osv-scanner-action@8dc09193bb540e09b23da07ad7e30bd33bf87018 # v2.3.8`; `scan-args: --recursive ./`; position after task patterns and before `sdd-kit verify` report-only
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Invariants:** `sdd-ci-gates` — OSV step in workflow; `sdd-supply-chain` — OSV blocks merge when lockfile vulnerabilities exist
  - **Gate:** `grep -q 'OSV-Scanner (blocking)' .github/workflows/sdd-gates.yml && grep -q '8dc09193bb540e09b23da07ad7e30bd33bf87018' .github/workflows/sdd-gates.yml`

- [x] 1.2 Mirror the same step in `sdd-kit/templates/.github/workflows/sdd-gates.yml` (hub/template parity)
  - **Pattern:** `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Invariants:** `sdd-ci-gates` — Kit template parity
  - **Gate:** `diff -q .github/workflows/sdd-gates.yml sdd-kit/templates/.github/workflows/sdd-gates.yml`

## 2. Renovate template (R6)

- [x] 2.1 Create `sdd-kit/templates/renovate.json` with conservative preset (design D6): `extends` recommended + semanticCommits + separateMajorReleases; `schedule` Monday; `prConcurrentLimit` 5; `prHourlyLimit` 2; `packageRules` — group non-major, automerge only patch with `requiredStatusChecks: ["SDD Gates"]`, majors/minors without automerge; `lockFileMaintenance` monthly; `vulnerabilityAlerts` without automerge
  - **Pattern:** `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Invariants:** `sdd-supply-chain` — Renovate config distributed for APP and HYBRID profiles
  - **Gate:** `test -f sdd-kit/templates/renovate.json && grep -q 'separateMajorReleases' sdd-kit/templates/renovate.json`

## 3. install.sh and MANIFEST (R6)

- [x] 3.1 Update `sdd-kit/install.sh`: copy `renovate.json` only for APP and HYBRID profiles; log `SKIP Renovate: profile DOCS_SPECS` for DOCS_SPECS
  - **Pattern:** `sdd-kit/install.sh`
  - **Invariants:** `sdd-supply-chain` — Profile-aware MANIFEST; DOCS_SPECS skips Renovate
  - **Gate:** `grep -q 'renovate.json' sdd-kit/install.sh && grep -q 'DOCS_SPECS' sdd-kit/install.sh`

- [x] 3.2 Add `renovate.json` entry in `sdd-kit/MANIFEST.yaml` (`profiles: [APP, HYBRID]`, `merge: COPY`); bump `version` 1.4.0 → **1.5.0**; run `bash sdd-kit/gen-manifest-checksums.sh`
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Invariants:** `sdd-supply-chain` — Profile-aware MANIFEST
  - **Gate:** `grep -q 'renovate.json' sdd-kit/MANIFEST.yaml && grep -q 'version: "1.5.0"' sdd-kit/MANIFEST.yaml`

## 4. openspec/infra.md (R1)

- [x] 4.1 Add Supply Chain section in `openspec/infra.md`: OSV-Scanner (action SHA, verify with grep in workflow) + Renovate (renovate.json, manual GitHub app)
  - **Pattern:** `openspec/infra.md`
  - **Invariants:** `sdd-supply-chain` — Agent classification documented
  - **Gate:** `grep -q 'OSV-Scanner' openspec/infra.md && grep -q 'Renovate' openspec/infra.md`

- [x] 4.2 Mirror in `sdd-kit/templates/openspec/infra.md`
  - **Pattern:** `sdd-kit/templates/openspec/infra.md`
  - **Gate:** `grep -q 'OSV-Scanner' sdd-kit/templates/openspec/infra.md`

## 5. AGENTS.md (R2)

- [x] 5.1 Update `AGENTS.md`: ≤10 lines in Integrations — Renovate PR (patch=type A, major/minor=type B/C); red OSV=type B fix deps; independent of A–E task; line in On-demand context
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-supply-chain` — Agent classification of supply-chain PRs
  - **Gate:** `grep -q 'Renovate' AGENTS.md && grep -q 'OSV' AGENTS.md`

- [x] 5.2 Mirror in `sdd-kit/templates/AGENTS.core.md`
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Gate:** `grep -q 'Renovate' sdd-kit/templates/AGENTS.core.md`

## 6. Canonical guide §2.13 (R4)

- [x] 6.1 Add **§2.13 Supply chain (Renovate + OSV-Scanner)** in `doc/sistema-sdd-pedro.md`: when OSV runs; how to read failure in Actions; `[MANUAL ACTION REQUIRED]` install Renovate app; conservative preset; automerge patches (opt-in branch protection); troubleshooting; rollback; Renovate PR volume checklist on pilot APP repo
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Invariants:** `sdd-supply-chain` — Manual Renovate activation documented
  - **Gate:** `grep -q '2.13' doc/sistema-sdd-pedro.md && grep -q 'OSV-Scanner' doc/sistema-sdd-pedro.md`

- [x] 6.2 Update index and install routes (§2.1 checklist) with pointer to §2.13
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q '2.13' doc/sistema-sdd-pedro.md`

## 7. Evaluation (R5)

- [x] 7.1 Update `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G8 → **Adopted** — change `add-supply-chain-gates`; Renovate AGPL note; re-evaluation condition (workflow composition when PR-Agent G7 phase 2)
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Gate:** `grep -q 'add-supply-chain-gates' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md && grep -q 'Adopted' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`

## 8. Specs — promotion

- [x] 8.1 Promote `openspec/changes/add-supply-chain-gates/specs/sdd-supply-chain/spec.md` to `openspec/specs/sdd-supply-chain/spec.md`
  - **Pattern:** `openspec/specs/sdd-ci-gates/spec.md`
  - **Gate:** `test -f openspec/specs/sdd-supply-chain/spec.md`

- [x] 8.2 Apply delta `openspec/changes/add-supply-chain-gates/specs/sdd-ci-gates/spec.md` to `openspec/specs/sdd-ci-gates/spec.md` (merge ADDED/MODIFIED)
  - **Pattern:** `openspec/specs/sdd-ci-gates/spec.md`
  - **Gate:** `grep -q 'OSV-Scanner' openspec/specs/sdd-ci-gates/spec.md`

## 9. Validation

- [x] 9.1 Run `bash scripts/verify-task-patterns.sh` on this `tasks.md`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [x] 9.2 Validate change with openspec CLI
  - **Pattern:** `openspec/changes/add-supply-chain-gates/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-supply-chain-gates --strict`

## 10. Post-register (best-effort)

- [x] 10.1 `graphify update .` + `npx gitnexus analyze --force` if available
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify ❌ in infra.md)'`
