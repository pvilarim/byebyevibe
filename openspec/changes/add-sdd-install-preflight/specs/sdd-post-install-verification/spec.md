## ADDED Requirements

### Requirement: verify-infra preserves Preflight section

`scripts/verify-infra.sh` MUST continue updating post-install SDD Stack / kit status markers in `openspec/infra.md` and MUST NOT overwrite or clear `preflight-*` markers or the `## Preflight (last run)` section owned by `scripts/preflight-sdd.sh`.

#### Scenario: Post-install verify keeps preflight stamp

- **WHEN** `openspec/infra.md` has a non-placeholder `preflight-timestamp` and the operator runs `bash scripts/verify-infra.sh`
- **THEN** the Preflight timestamp marker remains unchanged by verify-infra

### Requirement: Soft checklist pointer for phase-0 preflight

Guide checklist §2.8 MUST include an optional soft item that phase-0 preflight has been run (or that `## Preflight (last run)` is stamped). The item MUST be non-blocking: `bash sdd-kit/verify.sh` MUST NOT fail solely because preflight was skipped with `--skip-preflight`.

#### Scenario: Checklist mentions preflight

- **WHEN** an operator reads guide §2.8 after this capability is applied
- **THEN** an optional checklist line references preflight or the Preflight section in `openspec/infra.md`

#### Scenario: verify.sh soft-warns without failing

- **WHEN** `bash sdd-kit/verify.sh` runs in a repo whose Preflight timestamp is still a placeholder
- **THEN** verification MAY print a WARN that preflight never ran and MUST NOT fail solely for that reason
