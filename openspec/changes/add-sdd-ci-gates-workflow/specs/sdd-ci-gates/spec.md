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

### Requirement: verify-infra.sh runs report-only in CI

O passo que executa `sdd-kit/verify.sh` no workflow de CI MUST ser configurado com `continue-on-error: true`. O `sdd-kit/verify.sh` invoca internamente `scripts/verify-infra.sh`, que reporta FAIL para CLIs de conhecimento (GitNexus, Graphify) ausentes no runner efémero; tornar este step bloqueante produziria falso-negativo que impediria merge legítimo. A política fail-closed MUST aplicar-se exclusivamente aos steps de `openspec validate` e `verify-task-patterns.sh` — o step `sdd-kit verify` MUST NOT bloquear merge.

#### Scenario: Runner sem GitNexus/Graphify instalados

- **WHEN** o step `sdd-kit verify (report-only)` corre num runner onde GitNexus e Graphify não estão instalados
- **THEN** o step reporta WARN/FAIL internamente mas o workflow continua e o resultado global do job não é afectado por este step isoladamente

#### Scenario: openspec validate falha no mesmo run

- **WHEN** `openspec validate --all --strict` falha com saída não-zero
- **THEN** o workflow termina com falha (fail-closed) independentemente do resultado do step report-only
