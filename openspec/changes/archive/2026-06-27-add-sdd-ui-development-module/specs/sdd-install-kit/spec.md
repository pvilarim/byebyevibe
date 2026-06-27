# sdd-install-kit Specification (delta)

## MODIFIED Requirements

### Requirement: Versioned install kit directory

The distribution repository MUST include `sdd-kit/` at repository root with at minimum: `MANIFEST.yaml`, `README.md`, `install.sh`, `upgrade.sh`, `verify.sh`, `install-ui-module.sh`, and `templates/` mirroring target repository paths.

#### Scenario: Manifest lists UI module files

- **WHEN** `MANIFEST.yaml` is read after UI module release
- **THEN** entries exist for `sdd-kit/install-ui-module.sh` and `doc/design/002-ui-module-install.md` with `gate` commands

### Requirement: Guide documents project organization and scenarios

`doc/sistema-sdd-pedro.md` MUST document scenario **C1-UI** (optional UI development module after C1) in §1.6 alongside C1, C2, C2b, and C3.

#### Scenario: Human reads C1-UI scenario

- **WHEN** an operator opens §1.6 before UI module install
- **THEN** C1-UI is listed as optional post-C1 with entry command `sdd-kit/install-ui-module.sh`
