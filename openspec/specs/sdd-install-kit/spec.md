# sdd-install-kit Specification

## Purpose

Normative requirements for versioned, reproducible distribution of SDD stack artifacts (scripts, rules, skeletons) via `sdd-kit/`, separate from the procedural guide `doc/sistema-sdd-pedro.md`. Enables safe greenfield install (C1), SDD upgrade (C2), and distinguishes infra install from spec propagation (C3).

## Requirements

### Requirement: Versioned install kit directory

The distribution repository MUST include `sdd-kit/` at repository root with at minimum: `MANIFEST.yaml`, `README.md`, `install.sh`, `upgrade.sh`, `verify.sh`, and `templates/` mirroring target repository paths.

#### Scenario: Hub repository layout

- **WHEN** an operator clones the SDD distribution hub (e.g. spec-pedro)
- **THEN** `sdd-kit/MANIFEST.yaml` exists with `version` and `guide_version` fields matching `doc/sistema-sdd-pedro.md` header changelog entry

#### Scenario: Manifest lists all curated SDD files

- **WHEN** `MANIFEST.yaml` is read
- **THEN** every file required by `sdd-post-install-verification` and `sdd-session-coordination` for a complete SDD install appears with `path`, `source`, `merge` strategy, and `gate` command

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

### Requirement: Deterministic greenfield install

`sdd-kit/install.sh` MUST support `--profile APP|DOCS_SPECS|HYBRID`, `--dry-run`, and MUST copy or merge files from `templates/` into the target repository root without requiring an LLM to extract content from markdown.

#### Scenario: Dry-run greenfield install

- **WHEN** the operator runs `bash sdd-kit/install.sh --profile APP --dry-run` on a repo without SDD scripts
- **THEN** the script prints planned file operations and exits 0 without writing files

#### Scenario: Apply greenfield install

- **WHEN** the operator runs `bash sdd-kit/install.sh --profile DOCS_SPECS` after `openspec init`
- **THEN** `scripts/sdd-session-check.sh`, `scripts/verify-infra.sh`, `.cursor/rules/015-session-phases.mdc`, and `.cursor/rules/016-session-coordination.mdc` exist and are executable where applicable

### Requirement: Deterministic SDD upgrade

`sdd-kit/upgrade.sh` MUST support `--from`, `--to`, `--dry-run`, and MUST generate or update scaffold for `UPGRADE_REPORT.md` per guide §12.8. It MUST NOT apply merges to curated files without `--apply` after human approval.

#### Scenario: Upgrade dry-run

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from 1.2.0 --to 1.3.0 --dry-run`
- **THEN** a file-level diff report is produced classifying each manifest entry as KEEP_LOCAL, MERGE, APPLY_TEMPLATE, NEW, or SKIP

#### Scenario: Upgrade blocked without apply flag

- **WHEN** the operator runs `upgrade.sh` without `--apply` after dry-run
- **THEN** curated files `AGENTS.md` and `openspec/project.md` Purpose/Stack sections are not modified

### Requirement: Kit verification orchestration

`sdd-kit/verify.sh` MUST run post-install checks by invoking `scripts/verify-infra.sh`, `scripts/verify-task-patterns.sh` (if present), and `bash scripts/sdd-session-status.sh`, exiting non-zero if any mandatory check fails.

#### Scenario: Post-install verification

- **WHEN** the operator runs `bash sdd-kit/verify.sh` after C1 install
- **THEN** exit code 0 confirms core SDD kit artifacts are present and operational

### Requirement: Guide documents project organization and scenarios

`doc/sistema-sdd-pedro.md` MUST include section **§1.6** (or equivalent numbered section) documenting: four-layer model (procedure / payload / specs / workspace state), scenarios C1 (greenfield), C2 (SDD upgrade), C2b (CLI-only), C3 (spec propagation without SDD reinstall), and profile differences APP / DOCS_SPECS / HYBRID.

#### Scenario: Human reads installation scenarios

- **WHEN** an operator opens the canonical guide before first install
- **THEN** §1.6 lists entry commands for each scenario and states that payloads come from `sdd-kit/`, not markdown extraction

#### Scenario: Agent reads installation scenarios

- **WHEN** an agent is prompted to install SDD in a foreign repository
- **THEN** the guide directs it to `sdd-kit/install.sh` with profile flag rather than extracting §12 code blocks for scripts

### Requirement: Version alignment on release

On each kit release, `MANIFEST.yaml` `version`, guide header version, guide changelog §14 entry, and `openspec/project.md` Cross-references MUST reference the same semantic version.

#### Scenario: Version consistency check

- **WHEN** `grep guide_version sdd-kit/MANIFEST.yaml` returns `1.3.0`
- **THEN** `doc/sistema-sdd-pedro.md` changelog includes `1.3.0` and `openspec/project.md` references guia **v1.3.0**

### Requirement: Spec propagation is not SDD reinstall

The guide and kit README MUST state that updating domain specs in `openspec/specs/<domain>/` (scenario C3) does NOT require running `install.sh` or `upgrade.sh` unless `sdd-*` infrastructure specs changed.

#### Scenario: Hub publishes billing spec

- **WHEN** the hub archives a change that only modifies `openspec/specs/billing/spec.md`
- **THEN** APP repositories consume the spec via git/reference without re-running `sdd-kit/install.sh`

### Requirement: Upgrade diff uses manifest file list

`scripts/sdd-upgrade-diff.sh` MUST read curated file paths from `sdd-kit/MANIFEST.yaml` when present, falling back to built-in list only if manifest is absent.

#### Scenario: Diff inventories session rules

- **WHEN** `sdd-upgrade-diff.sh` runs without staging on a repo with kit installed
- **THEN** output includes `.cursor/rules/015-session-phases.mdc` and `.cursor/rules/016-session-coordination.mdc`

### Requirement: DOCS_SPECS hub retains kit

Repositories with profile DOCS_SPECS that act as SDD distribution hubs MUST commit `sdd-kit/` in full. Application repositories MAY commit only expanded files under `scripts/` and `.cursor/rules/` if documented in §1.6.

#### Scenario: Hub keeps kit for future upgrades

- **WHEN** spec-pedro archives this change
- **THEN** `sdd-kit/` remains in git for C2 upgrades by other repos
