# sdd-install-kit Specification (delta)

## MODIFIED Requirements

### Requirement: Deterministic greenfield install

**UPDATED:** `sdd-kit/install.sh` MUST copy `scripts/bootstrap-sdd.sh` into the target repository as part of every greenfield install (all profiles: APP, DOCS_SPECS, HYBRID). The entry point `scripts/bootstrap-sdd.sh` MUST appear in `sdd-kit/MANIFEST.yaml` with `merge: COPY` and `profiles: [APP, DOCS_SPECS, HYBRID]`.

#### Scenario: Greenfield install includes bootstrap script
- **WHEN** the operator runs `bash sdd-kit/install.sh --profile APP` in a new repository
- **THEN** `scripts/bootstrap-sdd.sh` is created and executable in the target repository

#### Scenario: Manifest lists bootstrap script
- **WHEN** `sdd-kit/MANIFEST.yaml` is read
- **THEN** an entry with `path: scripts/bootstrap-sdd.sh` and `merge: COPY` exists with `profiles: [APP, DOCS_SPECS, HYBRID]`
