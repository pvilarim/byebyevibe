# Delta — sdd-probity-module

## MODIFIED Requirements

### Requirement: Module is optional — not core SDD

Probity MUST NOT be installed by default `sdd-kit/install.sh`. It MUST be an explicit post-C1 module for APP/HYBRID profiles only. DOCS_SPECS hubs without tests MUST skip the module without error. The kit MUST ship `install-probity-module.sh` and the `probity.config.ts` template **inside `sdd-kit/`** (present in the acquired kit and the release tarball); the MANIFEST MUST NOT copy them to destinations inside `sdd-kit/` — such entries were src==dest self-copies on the whole-kit acquisition path that aborted the APP install loop, and existed only to compensate hub-mode not delivering the kit.

#### Scenario: Core C1 install does not install Probity

- **WHEN** the operator runs `bash sdd-kit/install.sh --profile DOCS_SPECS`
- **THEN** `@nizos/probity` is not added to any `package.json` and `probity.config.ts` is not created

#### Scenario: Kit carries the module without MANIFEST self-copies

- **WHEN** the operator inspects an acquired `sdd-kit/` and its MANIFEST after this change is archived
- **THEN** `sdd-kit/install-probity-module.sh` and `sdd-kit/templates/probity.config.ts` exist in the kit, and no MANIFEST entry targets a `path:` inside `sdd-kit/`

#### Scenario: APP install loop survives entry enumeration

- **WHEN** `bash sdd-kit/install.sh --profile APP` runs with `KIT_DIR` equal to `<repo>/sdd-kit`
- **THEN** the template loop applies every profile-selected entry without a same-file copy aborting it
