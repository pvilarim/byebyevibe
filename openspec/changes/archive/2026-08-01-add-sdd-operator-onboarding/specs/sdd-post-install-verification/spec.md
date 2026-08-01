## ADDED Requirements

### Requirement: Soft checklist pointer for day-1 help

Guide checklist §2.8 MUST include an optional soft item that `/opsx:help` is available (or that `doc/sdd-operator-day1.md` exists) for day-1 operate mapping. The item MUST be non-blocking: `bash sdd-kit/verify.sh` MUST NOT fail solely because the operator skipped reading help.

#### Scenario: Checklist mentions help or day-1 doc

- **WHEN** an operator reads guide §2.8 after this capability is applied
- **THEN** an optional checklist line references `/opsx:help` and/or `doc/sdd-operator-day1.md`

#### Scenario: verify.sh does not hard-require help read

- **WHEN** `bash sdd-kit/verify.sh` runs in a repo that has help artifacts installed but the operator has not invoked `/opsx:help`
- **THEN** verification does not fail solely for that reason
