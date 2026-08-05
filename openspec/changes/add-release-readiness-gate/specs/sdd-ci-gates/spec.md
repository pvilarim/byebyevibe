## ADDED Requirements

### Requirement: Release readiness gate is blocking

The `sdd-gates` workflow MUST include a step, distinct from the existing report-only `sdd-kit verify` step, that runs `scripts/verify-release-readiness.sh` directly and is NOT configured with `continue-on-error`. This step MUST cover version-sync (declared version strings vs. `sdd-kit/MANIFEST.yaml` authority fields) and kit-integrity (template checksum parity) and MUST NOT invoke `scripts/verify-infra.sh` or any GitNexus/Graphify presence check. `scripts/verify-release-readiness.sh` MUST also exist as a distributable template at `sdd-kit/templates/scripts/verify-release-readiness.sh` so the gate can be replicated into consumer repositories via `sdd-kit/install.sh`.

#### Scenario: Version mismatch blocks the PR

- **WHEN** `sdd-kit/MANIFEST.yaml` `version:` is bumped and `sdd-kit/README.md`'s heading still declares the previous version, on a pull request
- **THEN** the `Release readiness (blocking)` step fails and the workflow ends in failure, regardless of whether `verify-infra.sh` also fails in the separate report-only step

#### Scenario: Stale template checksum blocks the PR

- **WHEN** a file under `sdd-kit/templates/` is edited without running `gen-manifest-checksums.sh`, on a pull request
- **THEN** the `Release readiness (blocking)` step fails on the checksum mismatch and the workflow ends in failure

#### Scenario: Missing GitNexus/Graphify does not affect this step

- **WHEN** the runner has neither GitNexus nor Graphify installed
- **THEN** the `Release readiness (blocking)` step is unaffected by that absence — only the separate report-only `sdd-kit verify` step reflects it

#### Scenario: Consumer repo without the kit README or guide

- **WHEN** `scripts/verify-release-readiness.sh` runs in a repository that has `sdd-kit/MANIFEST.yaml` but neither `sdd-kit/README.md` nor `doc/byebyevibe-guide.md`
- **THEN** the version-sync portion prints informational skip lines and does not fail the step

#### Scenario: Requiring the check is a manual follow-up

- **WHEN** this change is merged
- **THEN** the `Release readiness (blocking)` step runs and reports correctly on subsequent pull requests, but merges are not yet blocked on it until an operator adds it as a required status check under branch protection
