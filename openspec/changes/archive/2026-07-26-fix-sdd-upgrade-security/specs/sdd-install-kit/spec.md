## MODIFIED Requirements

### Requirement: Deterministic greenfield install

`sdd-kit/install.sh` MUST validate every destination path against the repository root before writing any file. If a computed destination path escapes `$REPO_ROOT` (e.g. via `..` segments in a MANIFEST `path:` field), the script MUST abort with `ERROR: path traversal blocked` and exit non-zero.

#### Scenario: MANIFEST with path traversal attempt

- **WHEN** a MANIFEST entry contains `path: ../../etc/passwd` (or any path resolving outside `$REPO_ROOT`)
- **THEN** `install.sh` prints `ERROR: path traversal blocked` to stderr and exits non-zero without writing any file

## ADDED Requirements

### Requirement: Upgrade safety — mutual exclusion of --dry-run and --apply

`sdd-kit/upgrade.sh` MUST reject the combination of `--dry-run` and `--apply` flags with exit code 2 and an explicit error message. These flags are mutually exclusive; accepting both silently would discard the `--dry-run` intent.

#### Scenario: Operator passes both flags

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --dry-run --apply --from X --to Y`
- **THEN** the script prints an error stating the flags are mutually exclusive and exits with code 2 without modifying any file

### Requirement: Upgrade safety — automatic backup before overwrite

`sdd-kit/upgrade.sh --apply` MUST create a timestamped backup (`$dest.bak.TIMESTAMP`) of any destination file that differs from the kit template before overwriting it.

#### Scenario: Destination file differs from kit template

- **WHEN** `--apply` is about to overwrite a file that exists in the repository and differs from the template
- **THEN** the script creates `$dest.bak.<timestamp>` before copying, and prints `BACKUP $dest`

### Requirement: Upgrade safety — UPGRADE_REPORT approval gate

`sdd-kit/upgrade.sh --apply` MUST verify that the `UPGRADE_REPORT.md` file exists and contains `[x] Actualização aprovada` before performing any write operation. If the report is absent or unapproved, the script MUST abort with a descriptive error and exit non-zero.

#### Scenario: UPGRADE_REPORT absent

- **WHEN** `--apply` is run without a prior `--dry-run` (no `UPGRADE_REPORT.md`)
- **THEN** the script prints an error directing the operator to run `--dry-run` first and exits non-zero

#### Scenario: UPGRADE_REPORT present but not approved

- **WHEN** `UPGRADE_REPORT.md` exists but does not contain `[x] Actualização aprovada`
- **THEN** the script prints an error directing the operator to mark the approval checkbox and exits non-zero

### Requirement: Upgrade diff — source-aware AGENTS.md lookup

`sdd-kit/templates/scripts/sdd-upgrade-diff.sh` MUST use the `source` field from `MANIFEST.yaml` to locate each kit file in the staging directory. Files with a `source` that differs from `path` (e.g. `AGENTS.md` sourced from `templates/AGENTS.core.md`) MUST appear in the diff output.

#### Scenario: AGENTS.md has diverged from kit template

- **WHEN** the repository's `AGENTS.md` differs from `sdd-kit/templates/AGENTS.core.md`
- **THEN** `sdd-upgrade-diff.sh` includes `AGENTS.md` (or `AGENTS.core.md`) in its diff output
