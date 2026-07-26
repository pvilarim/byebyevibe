## MODIFIED Requirements

### Requirement: Deterministic SDD upgrade

`sdd-kit/upgrade.sh` MUST support `--from`, `--to`, `--profile APP|DOCS_SPECS|HYBRID`, `--dry-run`, and `--force`. The `--profile` flag SHALL be required when `--apply` is used: an `--apply` without `--profile` MUST exit 2 with an explanatory error. A dry-run without `--profile` SHALL list all MANIFEST entries without profile filtering, labelled `[all-profiles]`. The script MUST NOT apply any file whose MANIFEST `profiles:` list does not include the supplied `--profile`. The script MUST generate or update the scaffold for `UPGRADE_REPORT.md` per guide §12.8. It MUST NOT apply merges to curated files without `--apply` after human approval. Before applying any file, the script MUST check the current git branch: if the branch is `main` or `master` and `--force` is not supplied, the script MUST exit 1 with a warning instructing the operator to create an isolation branch.

#### Scenario: Upgrade dry-run

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from 1.3.x --to 1.4.0 --dry-run`
- **THEN** a file-level diff report is produced classifying each manifest entry as KEEP_LOCAL, MERGE, APPLY_TEMPLATE, NEW, or SKIP, covering all profiles

#### Scenario: Upgrade blocked without apply flag

- **WHEN** the operator runs `upgrade.sh` without `--apply` after dry-run
- **THEN** curated files `AGENTS.md` and `openspec/project.md` Purpose/Stack sections are not modified

#### Scenario: Apply blocked without profile

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from 1.3.x --to 1.4.0 --apply` without `--profile`
- **THEN** the script exits 2 with an error message instructing the operator to supply `--profile APP|DOCS_SPECS|HYBRID`

#### Scenario: DOCS_SPECS profile filters TypeScript rule

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from 1.3.x --to 1.4.0 --profile DOCS_SPECS --dry-run`
- **THEN** `.cursor/rules/010-typescript.mdc` does NOT appear in the output (MANIFEST declares `profiles: [APP, HYBRID]`)

#### Scenario: Apply blocked on main without force

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from 1.3.x --to 1.4.0 --profile DOCS_SPECS --apply` while on branch `main`
- **THEN** the script exits 1 with a message instructing the operator to create an isolation branch or re-run with `--force`

#### Scenario: Apply proceeds on feature branch

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from 1.3.x --to 1.4.0 --profile DOCS_SPECS --apply` while on branch `chore/upgrade-sdd-1.4.0`
- **THEN** COPY files matching the profile are applied and the script exits 0

### Requirement: Non-GitHub CI warning on install

When `sdd-kit/install.sh` copies a file whose destination path starts with `.github/workflows/`, and when the environment contains a non-GitHub CI indicator (`GITLAB_CI`, `GITEA_ACTIONS`, or `TF_BUILD`), the script SHALL emit a WARN line to stderr before the copy. The copy SHALL still proceed.

#### Scenario: GitLab CI warning

- **WHEN** the operator runs `bash sdd-kit/install.sh --profile APP` in an environment where `GITLAB_CI=true`
- **THEN** stderr contains a WARN line mentioning `.github/workflows/sdd-gates.yml` and GitLab adaptation

#### Scenario: Standard install no warning

- **WHEN** the operator runs `bash sdd-kit/install.sh --profile APP` without CI environment variables set
- **THEN** no WARN line is emitted to stderr for the workflows directory

## ADDED Requirements

### Requirement: MANIFEST gate field is non-executable metadata

The `gate:` field in `sdd-kit/MANIFEST.yaml` SHALL be documented as metadata only. `sdd-kit/install.sh` and `sdd-kit/upgrade.sh` MUST NOT execute the value of `gate:` fields via `eval` or equivalent. `sdd-kit/MANIFEST.yaml` MUST include a comment stating that `gate:` values are non-executable documentation.

#### Scenario: gate comment present in MANIFEST

- **WHEN** an operator reads `sdd-kit/MANIFEST.yaml`
- **THEN** a comment near the top (or inline with gate fields) documents that `gate:` is metadata and must not be eval'd

#### Scenario: install.sh does not eval gate

- **WHEN** `sdd-kit/install.sh` processes MANIFEST entries containing `gate:` fields
- **THEN** the gate values are ignored — no subprocess is spawned from gate field content
