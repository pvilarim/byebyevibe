## ADDED Requirements

### Requirement: MANIFEST entries include sha256 checksum per template file

`sdd-kit/MANIFEST.yaml` MUST include a `sha256:` field for each entry under `files:`. The value SHALL be the lowercase hex SHA-256 digest of the corresponding `source:` template file as it exists in `sdd-kit/`. Absence of the field is treated as a warning (backward compatibility); presence of an incorrect value MUST be treated as an error.

#### Scenario: MANIFEST contains sha256 field for every entry

- **WHEN** `sdd-kit/MANIFEST.yaml` is read
- **THEN** every entry under `files:` contains a `sha256:` field whose value is the sha256 hex digest of the file at `sdd-kit/<source>`

#### Scenario: gen-manifest-checksums.sh populates sha256 fields

- **WHEN** the maintainer runs `bash sdd-kit/gen-manifest-checksums.sh`
- **THEN** every `sha256:` field in `MANIFEST.yaml` is updated to match the current content of the corresponding template file, and the script exits 0

### Requirement: install.sh verifies template integrity before apply

`sdd-kit/install.sh` MUST verify the sha256 of each template file against the `sha256:` field in `MANIFEST.yaml` before copying it to the target repository. If the `sha256:` field is absent, the script SHALL emit a WARN and proceed. If the `sha256:` field is present and does not match the actual digest, the script MUST abort with a non-zero exit code and an error message identifying the affected file.

#### Scenario: install.sh aborts on integrity mismatch

- **WHEN** `sdd-kit/install.sh --profile APP` is run and a template file's sha256 does not match the MANIFEST field
- **THEN** the script prints `ERROR: integrity check failed: <source> (expected <hash>, got <actual>)` to stderr and exits non-zero without copying any files after the failure point

#### Scenario: install.sh warns and proceeds when sha256 field is absent

- **WHEN** `sdd-kit/install.sh --profile APP` is run and a MANIFEST entry lacks the `sha256:` field
- **THEN** the script prints `WARN: no sha256 for <source> — skipping integrity check` and proceeds to copy the file

#### Scenario: install.sh succeeds when all sha256 fields match

- **WHEN** `sdd-kit/install.sh --profile DOCS_SPECS` is run and all template files match their MANIFEST sha256 fields
- **THEN** no integrity error is emitted and the install proceeds normally

### Requirement: upgrade.sh --apply verifies template integrity before apply

`sdd-kit/upgrade.sh --apply` MUST apply the same sha256 verification as `install.sh` before copying each COPY-strategy file. The same warn-if-absent / error-if-mismatch policy applies.

#### Scenario: upgrade.sh --apply aborts on integrity mismatch

- **WHEN** `bash sdd-kit/upgrade.sh --from 1.3.0 --to 1.4.0 --apply --profile APP` is run and a template sha256 does not match
- **THEN** the script prints an error identifying the file and exits non-zero before copying that file

#### Scenario: upgrade.sh --apply succeeds on verified kit

- **WHEN** all template files in `sdd-kit/` match their MANIFEST `sha256:` fields
- **THEN** `upgrade.sh --apply` copies the files without integrity errors

### Requirement: verify.sh validates MANIFEST sha256 parity in hub context

When `sdd-kit/verify.sh` runs in a repository where `sdd-kit/templates/` is present (hub context), it MUST include an integrity parity check that computes the sha256 of each template file and compares it to the corresponding MANIFEST `sha256:` field. Entries without a `sha256:` field SHALL be reported as warnings. Mismatches SHALL be reported as failures and increment the failure counter.

#### Scenario: verify.sh detects stale sha256 in hub

- **WHEN** a template file was edited without regenerating checksums and `bash sdd-kit/verify.sh` is run
- **THEN** the parity check reports a FAIL for the affected entry and the script exits non-zero

#### Scenario: verify.sh skips parity check in consumer repos

- **WHEN** `bash sdd-kit/verify.sh` is run in a repository without `sdd-kit/templates/`
- **THEN** the parity check step is silently skipped and does not affect the exit code
