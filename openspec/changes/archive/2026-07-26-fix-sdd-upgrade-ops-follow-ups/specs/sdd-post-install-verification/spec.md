## MODIFIED Requirements

### Requirement: Kit verification orchestration

`sdd-kit/verify.sh` MUST run post-install checks by invoking `scripts/verify-infra.sh`, `scripts/verify-task-patterns.sh` (if present), and `bash scripts/sdd-session-status.sh`, exiting non-zero if any mandatory check fails. The check for `scripts/sdd-session-status.sh` MUST be skipped when the environment variable `CI` is set (non-empty), because session-coordination state is ephemeral and gitignored in CI runners and a missing or empty `.sdd/runtime/` is not a verification failure in that context.

#### Scenario: Post-install verification

- **WHEN** the operator runs `bash sdd-kit/verify.sh` after C1 install
- **THEN** exit code 0 confirms core SDD kit artifacts are present and operational

#### Scenario: Session check skipped in CI

- **WHEN** `sdd-kit/verify.sh` is invoked with `CI=true` in the environment (e.g. GitHub Actions)
- **THEN** the `sdd-session-status.sh` check is not executed and `FAILURES` is not incremented for it

#### Scenario: Session check runs locally

- **WHEN** `sdd-kit/verify.sh` is invoked on a local machine without `CI` set
- **THEN** the `sdd-session-status.sh` check is executed as before

## ADDED Requirements

### Requirement: Supply chain limitation documented

`.cursor/rules/050-security.mdc` (in both hub and distributed template) SHALL document that `npx --yes @fission-ai/openspec@VERSION` pins the top-level package version but does not pin transitive dependencies, which use `^` ranges. This limitation SHALL be noted as a known risk for operators adapting the workflow to security-sensitive environments.

#### Scenario: Security rule covers supply chain note

- **WHEN** an operator reads `.cursor/rules/050-security.mdc`
- **THEN** the CI/CD section includes a note about the `npx --yes` supply chain limitation and transitive dependency ranges
