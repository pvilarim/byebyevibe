## MODIFIED Requirements

### Requirement: bootstrap-sdd.sh emits warning in ambiguous HYBRID repo

`bootstrap-sdd.sh` MUST capture the profile hint (presence of `package.json` and `openspec/`) **before** running `openspec init`, so that the directory created by `openspec init` itself cannot trigger the ambiguity warning. When `package.json` and `openspec/` coexisted before `openspec init`, the script MUST emit a warning (stderr) requesting explicit profile confirmation before continuing with the default profile (APP). It MUST NOT exit with an error — the warning is informational. The warning's recovery instruction MUST reference a real, supported invocation (the `--profile` flag), not a positional argument.

#### Scenario: Repo with package.json and openspec/ coexisting

- **WHEN** the operator runs `bash scripts/bootstrap-sdd.sh` in a repo that already has both `package.json` and `openspec/` before bootstrap starts
- **THEN** the script prints a stderr warning that the profile may be HYBRID, instructs the operator to rerun with `--profile HYBRID|DOCS_SPECS` if APP is wrong, and continues installation with APP profile

#### Scenario: APP repo without openspec/ receives no warning

- **WHEN** the operator runs `bash scripts/bootstrap-sdd.sh` in a repo that has `package.json` but not `openspec/` at bootstrap start
- **THEN** the script continues with APP profile without any HYBRID warning, even though `openspec init` creates `openspec/` during the same run

## ADDED Requirements

### Requirement: bootstrap-sdd.sh accepts an explicit profile flag

`bootstrap-sdd.sh` MUST accept `--profile APP|DOCS_SPECS|HYBRID`. When supplied, the flag value MUST override profile auto-detection and be passed through to `sdd-kit/install.sh`. An invalid value MUST abort with a non-zero exit before any install phase runs.

#### Scenario: Explicit profile overrides detection

- **WHEN** the operator runs `bash scripts/bootstrap-sdd.sh --profile HYBRID` in a repo with `package.json`
- **THEN** `sdd-kit/install.sh` is invoked with `--profile HYBRID` and no ambiguity warning is emitted

#### Scenario: Invalid profile aborts early

- **WHEN** the operator runs `bash scripts/bootstrap-sdd.sh --profile FOO`
- **THEN** the script exits non-zero with an error naming the allowed values, before phase 0 begins

### Requirement: bootstrap-sdd.sh treats Graphify failures as non-fatal

The Graphify phase of `bootstrap-sdd.sh` (uv install, `uv tool install`, `graphify install`, `graphify hook install`, `graphify update`) MUST NOT abort the bootstrap on failure. Failures MUST emit a WARN and the script MUST continue to the sdd-kit install phase, mirroring the existing GitNexus tolerance. After installing `uv` via its installer, the script MUST ensure the installer's bin directory (e.g. `~/.local/bin`) is on `PATH` for the remainder of the run before invoking `uv`.

#### Scenario: Graphify install failure does not block kit install

- **WHEN** `uv tool install graphifyy` fails (e.g. network blocked) during bootstrap
- **THEN** the script prints a WARN for the Graphify phase and still executes `sdd-kit/install.sh`

#### Scenario: Freshly installed uv is found on PATH

- **WHEN** `uv` was absent and the bootstrap installed it via the curl installer
- **THEN** the subsequent `uv tool install` invocation resolves the freshly installed binary without requiring a new shell

### Requirement: install.sh and upgrade.sh reject invalid profile values

`sdd-kit/install.sh` MUST validate `--profile` against `APP|DOCS_SPECS|HYBRID` at argument parsing time and abort with a non-zero exit and an error naming the allowed values when the value is invalid — including when `--skip-preflight` is passed. `sdd-kit/upgrade.sh` MUST apply the same validation whenever `--profile` is supplied. A run that would select zero MANIFEST entries due to an unrecognized profile MUST NOT report success.

#### Scenario: install.sh rejects invalid profile with preflight skipped

- **WHEN** the operator runs `bash sdd-kit/install.sh --profile FOO --skip-preflight`
- **THEN** the script exits non-zero with an error naming the allowed profiles, and copies no files

#### Scenario: upgrade.sh apply rejects invalid profile

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from 1.0.0 --to 1.6.1 --apply --profile FOO`
- **THEN** the script exits non-zero with an error naming the allowed profiles, and applies no files

### Requirement: install.sh dry-run performs no filesystem writes

With `--dry-run`, `sdd-kit/install.sh` MUST NOT modify the target repository in any way — including file copies, content edits, and permission changes (`chmod`).

#### Scenario: Dry-run leaves permissions untouched

- **WHEN** the operator runs `bash sdd-kit/install.sh --profile APP --dry-run` in a repo where a manifest-listed `.sh` destination exists without the executable bit
- **THEN** after the run the file's permissions are unchanged

### Requirement: gen-manifest-checksums.sh rejects unknown arguments

`sdd-kit/gen-manifest-checksums.sh` MUST reject unknown arguments with a non-zero exit and usage text, and MUST support `--help`. It MUST NOT rewrite `MANIFEST.yaml` when invoked with an unrecognized argument.

#### Scenario: Unknown flag aborts without writing

- **WHEN** the maintainer runs `bash sdd-kit/gen-manifest-checksums.sh --hlep`
- **THEN** the script exits non-zero, prints usage, and `MANIFEST.yaml` is unmodified

#### Scenario: Help flag prints usage

- **WHEN** the maintainer runs `bash sdd-kit/gen-manifest-checksums.sh --help`
- **THEN** the script prints usage and exits 0 without touching `MANIFEST.yaml`

### Requirement: verify.sh gates hub live-scripts parity with kit templates

In hub context (repo containing `sdd-kit/templates/`), `sdd-kit/verify.sh` MUST compare each live `scripts/<name>.sh` that has a counterpart at `sdd-kit/templates/scripts/<name>.sh` and report a failure when the two differ, so hub↔template drift cannot pass verification silently. Scripts without a template counterpart are exempt.

#### Scenario: Drifted script fails hub verification

- **WHEN** `scripts/verify-task-patterns.sh` differs from `sdd-kit/templates/scripts/verify-task-patterns.sh` and `bash sdd-kit/verify.sh` runs in the hub
- **THEN** verify reports the drifted pair as a failure and exits non-zero

#### Scenario: Consumer repos are unaffected

- **WHEN** `bash sdd-kit/verify.sh` runs in a consumer repo without `sdd-kit/templates/`
- **THEN** no parity check is attempted and no failure is reported for it
