## Why

The security rule in `.cursor/rules/050-security.mdc` requires checking advisories before adding dependencies, but the SDD system has no objective CI scanner or automated updates — stale or vulnerable dependencies can merge without a gate, and agents lack a deterministic red signal for supply chain. Gap **G8** in `openspec/changes/explore-oss-coverage-gaps/research.md` recommends the **Renovate + OSV-Scanner** pair as templates in `sdd-kit`, activated by profile; G1 (`sdd-gates.yml`) is already implemented and is a prerequisite for integrating OSV in the same pipeline.

## What Changes

- **OSV-Scanner (Google):** blocking step (fail-closed) in the `sdd-gates.yml` workflow (hub + template `sdd-kit/templates/`), with action pinned by immutable SHA; scan present lockfiles (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `poetry.lock`, etc.); SKIP when no lockfile at repo root (DOCS_SPECS profile without deps).
- **Renovate (Mend):** conservative `renovate.json` template in `sdd-kit` (grouping, schedule, automerge only for patches with documented green CI, no automerge on majors); activated on APP and HYBRID profiles; **SKIP** on DOCS_SPECS.
- **6-point contract registry** (metodologia-insercao.md Phase 3): `infra.md`, `AGENTS.md`, guide §2.13, evaluation G8 → Adopted, `sdd-kit/` (templates + `install.sh` flags + MANIFEST bump).
- **Delta specs:** new capability `sdd-supply-chain` (normative supply-chain requirements) + extension of `sdd-ci-gates` (OSV in workflow, expanded fail-closed policy).
- **SDD integration:** Renovate PR → type A (patch) or B/C (major/breaking); red OSV → type B (fix deps before merge/archive); independent of the in-progress A–E task.

## Capabilities

### New Capabilities

- `sdd-supply-chain`: Renovate + OSV templates by APP/DOCS_SPECS/HYBRID profile; normative requirement that PRs MUST pass OSV-Scanner when a lockfile is present; operational registry and rollback documented.

### Modified Capabilities

- `sdd-ci-gates`: The `sdd-gates.yml` workflow includes a blocking OSV-Scanner step (when applicable); the fail-closed step list includes OSV in addition to `openspec validate` and `verify-task-patterns.sh`; documented exception to the "existing commands only" rule for the OSV action pinned by SHA.

## Impact

- **Workflows:** `.github/workflows/sdd-gates.yml`, `sdd-kit/templates/.github/workflows/sdd-gates.yml` (apply — not in this propose phase).
- **Kit:** `sdd-kit/templates/renovate.json`, `sdd-kit/install.sh` (flags by profile), `sdd-kit/MANIFEST.yaml` (1.4.0 → 1.5.0 + checksums).
- **Docs:** `openspec/infra.md`, `AGENTS.md`, `sdd-kit/templates/AGENTS.core.md`, `doc/sistema-sdd-pedro.md` (new §2.13), `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`.
- **Specs:** `openspec/specs/sdd-supply-chain/spec.md` (new), delta in `openspec/specs/sdd-ci-gates/spec.md`.
- **Dependency:** G1 MUST be implemented; no pre-commit/Lefthook for OSV (overlap C3).
- **Non-goals in this change:** Renovate does not replace human review on majors; GitHub Renovate app is manual activation (`[MANUAL ACTION REQUIRED]`); formal pilot dispensable for OSV (CI step only); manual checklist in the guide for Renovate PR volume.
