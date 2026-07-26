# sdd-install-kit Specification (delta)

## ADDED Requirements

### Requirement: Metrics script distributed via install kit

`sdd-kit/MANIFEST.yaml` MUST include an entry for `scripts/sdd-metrics.sh` with `source: templates/scripts/sdd-metrics.sh`, `merge: COPY`, and `profiles: [APP, DOCS_SPECS, HYBRID]`. The `gate:` field MUST remain documentary metadata only (MUST NOT be evaluated via `eval`). Kit `version` MUST be bumped to at least **1.6.0** when this entry is added. `sdd-kit/templates/scripts/sdd-metrics.sh` MUST exist and match the hub script content distributed to consumers.

#### Scenario: Kit install copies metrics script

- **WHEN** `bash sdd-kit/install.sh --profile DOCS_SPECS` (or APP/HYBRID) runs in a consumer repository
- **THEN** `scripts/sdd-metrics.sh` is created from the kit template and is executable

#### Scenario: MANIFEST lists metrics script at 1.6.0+

- **WHEN** `sdd-kit/MANIFEST.yaml` is read after this change is applied
- **THEN** it contains `scripts/sdd-metrics.sh` and `version` is `1.6.0` or higher

#### Scenario: Integrity checksum present

- **WHEN** `bash sdd-kit/gen-manifest-checksums.sh` has been run after adding the template
- **THEN** the MANIFEST entry for `sdd-metrics.sh` includes a `sha256:` field matching the template file digest
