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

`sdd-kit/install.sh` MUST validate every destination path against the repository root before writing any file. If a computed destination path escapes `$REPO_ROOT` (e.g. via `..` segments in a MANIFEST `path:` field), the script MUST abort with `ERROR: path traversal blocked` and exit non-zero.

#### Scenario: MANIFEST with path traversal attempt

- **WHEN** a MANIFEST entry contains `path: ../../etc/passwd` (or any path resolving outside `$REPO_ROOT`)
- **THEN** `install.sh` prints `ERROR: path traversal blocked` to stderr and exits non-zero without writing any file

### Requirement: Deterministic SDD upgrade

`sdd-kit/upgrade.sh` MUST support `--from`, `--to`, `--dry-run`, and MUST generate or update scaffold for `UPGRADE_REPORT.md` per guide §12.8. It MUST NOT apply merges to curated files without `--apply` after human approval. The MANIFEST MUST classify upgrade tool files (e.g. `scripts/sdd-upgrade-diff.sh`) with `merge: MERGE` to preserve local customizations.

#### Scenario: Dry-run produces UPGRADE_REPORT scaffold

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from 1.3.2 --to 1.4.0 --dry-run`
- **THEN** `openspec/changes/upgrade-sdd-v1.4.0/UPGRADE_REPORT.md` is created with unchecked approval checkbox and no files are modified in the repo

#### Scenario: Apply blocked without prior approval

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from 1.3.2 --to 1.4.0 --apply --profile DOCS_SPECS` without first approving the UPGRADE_REPORT.md
- **THEN** the script exits non-zero with an error message explaining that the UPGRADE_REPORT must be approved

#### Scenario: sdd-upgrade-diff.sh preserved on apply

- **WHEN** the operator runs `--apply` and has a locally customised `scripts/sdd-upgrade-diff.sh`
- **THEN** the script is classified as `MERGE` and NOT overwritten — the local version is preserved

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

### Requirement: bootstrap-sdd.sh emits warning in ambiguous HYBRID repo

When `package.json` and `openspec/` coexist, `bootstrap-sdd.sh` MUST emit a warning (stderr) requesting explicit profile confirmation before continuing with the default profile (APP). It MUST NOT exit with an error — the warning is informational.

#### Scenario: Repo with package.json and openspec/ coexisting

- **WHEN** the operator runs `bash scripts/bootstrap-sdd.sh` in a repo that has both `package.json` and `openspec/`
- **THEN** the script prints to stderr `WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID.` and continues installation with APP profile

#### Scenario: APP repo without openspec/ receives no warning

- **WHEN** the operator runs `bash scripts/bootstrap-sdd.sh` in a repo that has `package.json` but not `openspec/`
- **THEN** the script continues with APP profile without any warning

### Requirement: upgrade.sh classify label aligned with MANIFEST merge strategy

The output of `upgrade.sh --dry-run` for files with `merge: COPY` MUST use the label `COPY` (not `APPLY_TEMPLATE`), maintaining visual alignment with the values declared in the MANIFEST.

#### Scenario: Dry-run shows COPY label for merge COPY files

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from X --to Y --dry-run`
- **THEN** files classified with `merge: COPY` in the MANIFEST appear in the output with the `COPY` prefix (not `APPLY_TEMPLATE`)

### Requirement: upgrade.sh header distinguishes dry-run mode from apply mode

The header printed by `upgrade.sh` at the start of the output MUST reflect the execution mode: `dry-run` in `--dry-run` mode, `APPLY` in `--apply` mode.

#### Scenario: Header dry-run

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from X --to Y --dry-run`
- **THEN** the output contains `SDD UPGRADE REPORT (dry-run)`

#### Scenario: Header apply

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from X --to Y --apply --profile DOCS_SPECS` after approving the report
- **THEN** the output contains `SDD UPGRADE APPLY` (without `dry-run`)

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

`sdd-kit/upgrade.sh --apply` MUST verify that the `UPGRADE_REPORT.md` file exists and contains the approval checkbox string that `sdd-kit/upgrade.sh` greps for in `UPGRADE_REPORT.md` before performing any write operation. If the report is absent or unapproved, the script MUST abort with a descriptive error and exit non-zero.

#### Scenario: UPGRADE_REPORT absent

- **WHEN** `--apply` is run without a prior `--dry-run` (no `UPGRADE_REPORT.md`)
- **THEN** the script prints an error directing the operator to run `--dry-run` first and exits non-zero

#### Scenario: UPGRADE_REPORT present but not approved

- **WHEN** `UPGRADE_REPORT.md` exists but does not contain the approval checkbox string expected by `sdd-kit/upgrade.sh`
- **THEN** the script prints an error directing the operator to mark the approval checkbox and exits non-zero

### Requirement: Upgrade diff — source-aware AGENTS.md lookup

`sdd-kit/templates/scripts/sdd-upgrade-diff.sh` MUST use the `source` field from `MANIFEST.yaml` to locate each kit file in the staging directory. Files with a `source` that differs from `path` (e.g. `AGENTS.md` sourced from `templates/AGENTS.core.md`) MUST appear in the diff output.

#### Scenario: AGENTS.md has diverged from kit template

- **WHEN** the repository's `AGENTS.md` differs from `sdd-kit/templates/AGENTS.core.md`
- **THEN** `sdd-upgrade-diff.sh` includes `AGENTS.md` (or `AGENTS.core.md`) in its diff output

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

### Requirement: Kit README includes discovery positioning for newcomers

`sdd-kit/README.md` MUST begin with (or include near the top, before operational scenario tables) a short positioning section that: (1) states what the kit is in plain language for newcomers arriving from vibe coding / AI-assisted workflows; (2) maps internal scenario codes (at least C1, C2, C3) to human-readable names; and (3) points to the hub root `README.md` and/or the canonical guide for first contact. Operational sections (profiles, commands, structure, CI gates) MUST remain present.

#### Scenario: Newcomer reads kit README first

- **WHEN** a newcomer opens `sdd-kit/README.md` without prior SDD jargon
- **THEN** they see a positioning/intro section and a human-readable mapping for C1/C2/C3 before or alongside the operational tables

#### Scenario: Operational content retained

- **WHEN** `sdd-kit/README.md` is updated for discovery framing
- **THEN** it still documents install/upgrade entry commands and profiles (APP, DOCS_SPECS, HYBRID)

### Requirement: Public display name vs install payload path

Public documentation for the install kit MUST treat **ByeByeVibe** as the human-facing project name and MUST keep the on-disk payload directory name `sdd-kit/` (including `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, and documented CLI invocations). Install and upgrade commands in docs MUST continue to reference `sdd-kit/` unless a future change explicitly migrates the directory (**BREAKING**, out of scope of the ByeByeVibe rename).

#### Scenario: Kit README states dual naming

- **WHEN** an operator opens `sdd-kit/README.md`
- **THEN** the title or first-contact intro identifies ByeByeVibe as the public name and still documents commands under `sdd-kit/`

#### Scenario: Install CTA path unchanged

- **WHEN** install instructions are copied from hub or kit README
- **THEN** they invoke `sdd-kit/install.sh` (or other `sdd-kit/` scripts), not a renamed payload folder

### Requirement: install.sh captures language policy before template apply

`sdd-kit/install.sh` MUST resolve `chat_language`, `docs_language`, and `code_language` (per `sdd-language-policy`) before copying `AGENTS.core.md` and other templates. Resolution order: (1) CLI flags `--chat-lang`, `--docs-lang`, `--code-lang` if provided; (2) interactive prompts when stdin is a TTY and flags are absent; (3) defaults `en` for each missing value. Invalid values MUST abort before any COPY merge writes language-bearing files.

#### Scenario: Install aborts on invalid language before copy

- **WHEN** `install.sh --profile APP --docs-lang fr` is run
- **THEN** the script exits non-zero before copying templates and prints an error identifying the invalid locale

#### Scenario: Install proceeds after valid resolution

- **WHEN** `install.sh --profile DOCS_SPECS --chat-lang en --docs-lang en --code-lang en` is run
- **THEN** template copy proceeds and `AGENTS.md` is generated with substituted Communication text

### Requirement: install.sh writes Language policy into project.md

When `openspec/project.md` exists in the target repository, `install.sh` MUST insert or update a `## Language policy` section (using anchored markers `<!-- SDD_LANGUAGE_POLICY_START -->` and `<!-- SDD_LANGUAGE_POLICY_END -->` when merging) recording the three BCP-47-style tags (`en` or `pt-BR`). If `project.md` does not exist yet, the script MUST emit a WARN and document that the operator must add Language policy manually after `openspec init`.

#### Scenario: project.md exists after openspec init

- **WHEN** install runs after `openspec init` and language flags are `pt-BR` / `en` / `en`
- **THEN** `openspec/project.md` contains a Language policy section with those three values between the SDD anchor markers

#### Scenario: project.md missing

- **WHEN** install runs before `openspec init`
- **THEN** install logs a WARN to add Language policy after init and still writes `AGENTS.md` Communication from the resolved languages

### Requirement: verify.sh checks language policy on consumer installs

`sdd-kit/verify.sh` MUST include a check (report or blocking per existing verify conventions) that installed `AGENTS.md` has no unreplaced `{{CHAT_LANG}}` placeholders and that `openspec/project.md` contains `## Language policy` when that file exists.

#### Scenario: Verify passes on complete install

- **WHEN** `bash sdd-kit/verify.sh` runs after a successful language-aware install with existing `project.md`
- **THEN** the language policy check reports OK

#### Scenario: Verify fails on leaked placeholder

- **WHEN** `AGENTS.md` still contains `{{DOCS_LANG}}`
- **THEN** verify reports failure for the language policy check
