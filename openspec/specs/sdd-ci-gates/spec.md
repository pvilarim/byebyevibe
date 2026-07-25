# sdd-ci-gates Specification (delta)

## ADDED Requirements

### Requirement: CI workflow enforces SDD gates

The repository MUST include a GitHub Actions workflow at `.github/workflows/sdd-gates.yml` that runs the SDD gates on `push` (to base branches) and on `pull_request`. The workflow MUST orchestrate **only commands that already exist in the repository** — at minimum `openspec validate`, `bash sdd-kit/verify.sh`, and `bash scripts/verify-task-patterns.sh` — and MUST NOT introduce a new dependency, binary, or git-hook manager.

#### Scenario: Pull request opened

- **WHEN** a pull request is opened or updated
- **THEN** the `SDD Gates` workflow runs and reports success or failure as a check on the PR

#### Scenario: Push to base branch

- **WHEN** a commit is pushed to a base branch (`main`/`master`)
- **THEN** the `SDD Gates` workflow runs the configured gate commands

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
