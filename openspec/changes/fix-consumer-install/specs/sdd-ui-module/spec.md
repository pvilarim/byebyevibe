# Delta — sdd-ui-module

## MODIFIED Requirements

### Requirement: MANIFEST entries for UI module

`sdd-kit/MANIFEST.yaml` MUST list all four `doc/design/*` files with appropriate `profiles` and `gate` commands. The MANIFEST MUST NOT contain an entry copying `install-ui-module.sh` (or any other file) to a destination inside `sdd-kit/`: with the canonical whole-kit acquisition, such entries are src==dest self-copies that abort the install loop in APP profile, and the module script is already present inside the acquired `sdd-kit/`. The module runs from the kit that performed the install (`sdd-kit/install-ui-module.sh` on the tarball path, or the source hub's kit in hub-mode).

#### Scenario: Upgrade diff includes UI module files

- **WHEN** `scripts/sdd-upgrade-diff.sh` reads MANIFEST
- **THEN** `doc/design/002-ui-module-install.md` appears in the diff inventory

#### Scenario: No MANIFEST destination inside sdd-kit/

- **WHEN** the MANIFEST entries are enumerated
- **THEN** no entry has a `path:` beginning with `sdd-kit/`, and the APP-profile install loop performs no copy whose source and destination are the same file
