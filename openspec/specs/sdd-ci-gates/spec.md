# sdd-ci-gates Specification

## Purpose

Normative requirements for server-side enforcement of SDD quality gates via GitHub Actions CI. Ensures that `openspec validate`, structural checks, vulnerability scanning (when lockfiles present), and infra verification run on every `push` and `pull_request` — fail-closed for normative steps, report-only for infra presence checks.
## Requirements
### Requirement: CI workflow enforces SDD gates

The repository MUST include a GitHub Actions workflow at `.github/workflows/sdd-gates.yml` that runs the SDD gates on `push` (to base branches) and on `pull_request`. The workflow MUST orchestrate commands that already exist in the repository — at minimum `openspec validate`, `bash sdd-kit/verify.sh`, and `bash scripts/verify-task-patterns.sh` — and MUST NOT introduce a git-hook manager. **ADDED (G8):** the workflow MAY include the pinned `google/osv-scanner-action/osv-scanner-action` GitHub Action as the sole authorized external Action dependency for supply-chain scanning; this exception does not permit other third-party Actions without a dedicated OpenSpec change.

#### Scenario: Pull request opened

- **WHEN** a pull request is opened or updated
- **THEN** the `SDD Gates` workflow runs and reports success or failure as a check on the PR

#### Scenario: Push to base branch

- **WHEN** a commit is pushed to a base branch (`main`/`master`)
- **THEN** the `SDD Gates` workflow runs the configured gate commands

#### Scenario: OSV exception is scoped

- **WHEN** `.github/workflows/sdd-gates.yml` is reviewed after G8 integration
- **THEN** the only non-checkout/setup third-party Action is `google/osv-scanner-action/osv-scanner-action` pinned by SHA

### Requirement: OpenSpec validation is blocking and fail-closed

The workflow's `openspec validate` step MUST be blocking: if validation fails, the workflow MUST exit non-zero (fail-closed). The OpenSpec CLI version used MUST be pinned to at least the `min_openspec` declared in `sdd-kit/MANIFEST.yaml`.

#### Scenario: Invalid change present

- **WHEN** an active change fails `openspec validate`
- **THEN** the workflow fails and the PR check is red

#### Scenario: All changes valid

- **WHEN** all active changes pass validation and structural checks pass
- **THEN** the workflow succeeds

### Requirement: Least-privilege and no secrets

The workflow MUST declare least-privilege permissions (`contents: read` unless a broader scope is justified) and MUST NOT contain secret values. Any token used MUST rely on the ambient `GITHUB_TOKEN` with the minimum scope required.

#### Scenario: Workflow is inspected for secrets

- **WHEN** `.github/workflows/sdd-gates.yml` is reviewed
- **THEN** it contains no API keys, tokens, or passwords, and declares explicit `permissions`

### Requirement: Distributable workflow template

`sdd-kit/templates/.github/workflows/sdd-gates.yml` MUST exist as a versioned copy of the workflow so the gate can be replicated into other repositories via `sdd-kit/install.sh`.

#### Scenario: Kit install into a consumer repo

- **WHEN** `bash sdd-kit/install.sh --profile APP` runs in a consumer repository
- **THEN** `.github/workflows/sdd-gates.yml` is created from the kit template

### Requirement: verify-infra.sh runs report-only in CI

The step that runs `sdd-kit/verify.sh` in the CI workflow MUST be configured with `continue-on-error: true`. `sdd-kit/verify.sh` internally invokes `scripts/verify-infra.sh`, which reports FAIL for knowledge CLIs (GitNexus, Graphify) absent on ephemeral runners; making this step blocking would produce false negatives that would block legitimate merges. The fail-closed policy MUST apply to the `openspec validate`, `verify-task-patterns.sh`, **and OSV-Scanner when a lockfile is present** steps — the `sdd-kit verify` step MUST NOT block merge.

#### Scenario: Runner without GitNexus/Graphify installed

- **WHEN** the `sdd-kit verify (report-only)` step runs on a runner where GitNexus and Graphify are not installed
- **THEN** the step reports WARN/FAIL internally but the workflow continues and the overall job result is not affected by this step alone

#### Scenario: openspec validate fails in the same run

- **WHEN** `openspec validate --all --strict` fails with non-zero exit
- **THEN** the workflow ends in failure (fail-closed) regardless of the report-only step result

#### Scenario: OSV-Scanner fails with vulnerable lockfile

- **WHEN** OSV-Scanner runs (lockfile present) and reports a vulnerability
- **THEN** the workflow ends in failure (fail-closed) regardless of the report-only `sdd-kit verify` step result

### Requirement: OSV-Scanner step in sdd-gates workflow

The `sdd-gates` job in `.github/workflows/sdd-gates.yml` MUST include a blocking step named `OSV-Scanner (blocking)` that runs only when at least one supported lockfile exists at the repository root. The step MUST use `google/osv-scanner-action/osv-scanner-action` pinned to a full commit SHA. The template at `sdd-kit/templates/.github/workflows/sdd-gates.yml` MUST mirror the hub workflow.

#### Scenario: Lockfile present on pull request

- **WHEN** `package-lock.json` exists at the repository root and a pull request is opened
- **THEN** the `OSV-Scanner (blocking)` step runs and blocks merge on vulnerability findings

#### Scenario: No lockfile at repository root

- **WHEN** no supported lockfile exists at the repository root
- **THEN** the `OSV-Scanner (blocking)` step is skipped without failing the job

#### Scenario: Kit template parity

- **WHEN** `bash sdd-kit/install.sh --profile APP` copies the workflow template
- **THEN** the installed `.github/workflows/sdd-gates.yml` includes the OSV-Scanner step identical to the hub template

### Requirement: Workflow uses immutable action references for OSV

Every `uses:` reference in `sdd-gates.yml` (hub and template), including the OSV-Scanner action added by G8, MUST be pinned to a full 40-character commit SHA with a trailing `# vX.Y.Z` comment. Mutable tag references (`@v4`, `@v5`, `@v2`, etc.) MUST NOT appear.

#### Scenario: Post-G8 workflow inspection

- **WHEN** `.github/workflows/sdd-gates.yml` is reviewed after supply-chain integration
- **THEN** all `uses:` lines end with a 40-char SHA and a human-readable version comment, including OSV-Scanner

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

### Requirement: CI exercises a greenfield install

The `sdd-gates` workflow MUST perform a C1 greenfield install into a repository created empty within the run, and MUST fail when that install does not succeed. The target MUST NOT be the hub checkout and MUST NOT be seeded with directories the install is expected to create.

The check MUST assert more than the installer's exit code. It MUST assert that a non-trivial number of files was written, and MUST assert the presence of at least one installed file whose parent directory did not exist in the empty target — because a path guard that requires pre-existing parents fails precisely there, and an exit code alone did not catch that defect.

This gate is required because every other gate in the workflow runs against the hub, which already carries the directory layout a greenfield target lacks. A defect fatal to every genuine first install therefore remained invisible to CI.

#### Scenario: Greenfield install succeeds

- **WHEN** the workflow creates an empty repository, places the documented install footprint in it, and runs the installer
- **THEN** the installer exits zero, files are written, and the job passes

#### Scenario: Zero-file install fails the job

- **WHEN** the installer exits zero but writes no files into the empty target
- **THEN** the job fails, because the file-count assertion is not satisfied by the exit code alone

#### Scenario: A newly created parent directory is exercised

- **WHEN** the greenfield assertion runs
- **THEN** it verifies at least one installed file that lives under a directory absent from the empty target before the install
