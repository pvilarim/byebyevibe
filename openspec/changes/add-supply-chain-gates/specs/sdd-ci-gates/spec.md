# sdd-ci-gates Specification (delta)

## MODIFIED Requirements

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

### Requirement: verify-infra.sh runs report-only in CI

The step that runs `sdd-kit/verify.sh` in the CI workflow MUST be configured with `continue-on-error: true`. `sdd-kit/verify.sh` internally invokes `scripts/verify-infra.sh`, which reports FAIL for missing knowledge CLIs (GitNexus, Graphify) on ephemeral runners; making this step blocking would produce false negatives that block legitimate merges. The fail-closed policy MUST apply to `openspec validate`, `verify-task-patterns.sh`, **and OSV-Scanner when a lockfile is present** — the `sdd-kit verify` step MUST NOT block merge.

#### Scenario: Runner without GitNexus/Graphify installed

- **WHEN** the `sdd-kit verify (report-only)` step runs on a runner where GitNexus and Graphify are not installed
- **THEN** the step reports WARN/FAIL internally but the workflow continues and the overall job result is not affected by this step alone

#### Scenario: openspec validate fails in the same run

- **WHEN** `openspec validate --all --strict` fails with non-zero exit
- **THEN** the workflow ends in failure (fail-closed) regardless of the report-only step result

#### Scenario: OSV-Scanner fails with vulnerable lockfile

- **WHEN** OSV-Scanner runs (lockfile present) and reports a vulnerability
- **THEN** the workflow ends in failure (fail-closed) regardless of the `sdd-kit verify` report-only step result

## ADDED Requirements

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
