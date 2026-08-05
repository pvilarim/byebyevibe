# sdd-install-kit Specification

## Purpose

Normative requirements for versioned, reproducible distribution of SDD stack artifacts (scripts, rules, skeletons) via `sdd-kit/`, separate from the procedural guide `doc/sistema-sdd-pedro.md`. Enables safe greenfield install (C1), SDD upgrade (C2), and distinguishes infra install from spec propagation (C3).
## Requirements
### Requirement: Versioned install kit directory

The distribution repository MUST include `sdd-kit/` at repository root with at minimum: `MANIFEST.yaml`, `README.md`, `install.sh`, `upgrade.sh`, `verify.sh`, and `templates/` mirroring target repository paths.

#### Scenario: Hub repository layout

- **WHEN** an operator clones the SDD distribution hub (e.g. spec-pedro)
- **THEN** `sdd-kit/MANIFEST.yaml` exists with `version` and `guide_version` fields matching `doc/byebyevibe-guide.md` header changelog entry

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

`doc/byebyevibe-guide.md` MUST include section **§1.6** (or equivalent numbered section) documenting: four-layer model (procedure / payload / specs / workspace state), scenarios C1 (greenfield), C2 (SDD upgrade), C2b (CLI-only), C3 (spec propagation without SDD reinstall), and profile differences APP / DOCS_SPECS / HYBRID. §1.6 MUST also include a canonical **install-scope table** distinguishing: machine scope (CLIs and MCP config, installed once per machine), repo-copied scope (payload applied by `install.sh` per project), and repo-generated scope (`openspec/`, `graphify-out/`, `.gitnexus/` — born inside each project, never shared between projects). §1.6 MUST document the **hub→destination flow** as the canonical multi-project UX: one hub clone per machine, and installation into any target project via `bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>`. §1.6 MUST state that per-project reinstallation covers only the repo-copied payload — machine-level CLIs are never reinstalled per project. Other surfaces (kit README, day-1 doc, banners) MUST NOT duplicate the scope table; a short summary of at most three sentences plus a link to §1.6 is permitted.

#### Scenario: Human reads installation scenarios

- **WHEN** an operator opens the canonical guide before first install
- **THEN** §1.6 lists entry commands for each scenario and states that payloads come from `sdd-kit/`, not markdown extraction

#### Scenario: Agent reads installation scenarios

- **WHEN** an agent is prompted to install SDD in a foreign repository
- **THEN** the guide directs it to `sdd-kit/install.sh` with profile flag rather than extracting §12 code blocks for scripts

#### Scenario: Operator learns install scopes before second project

- **WHEN** an operator reads §1.6 asking whether a second project requires full reinstallation
- **THEN** the install-scope table shows machine-once vs repo-copied vs repo-generated scope, and the hub→destination command shows how to install into a new target folder with one command

#### Scenario: Scope table is single-sourced

- **WHEN** any other canonical surface (kit README, day-1 doc) mentions install scope
- **THEN** it links to guide §1.6 with at most a three-sentence summary, without duplicating the full table

### Requirement: Version alignment on release

On each kit release, `MANIFEST.yaml` `version`, guide header version, guide changelog §14 entry, and `openspec/project.md` Cross-references MUST reference the same semantic version. The canonical guide path is `doc/byebyevibe-guide.md` (renamed 2026-08 from `doc/sistema-sdd-pedro.md`; pre-rename artifacts cite the old name for the same document).

#### Scenario: Version consistency check

- **WHEN** `grep guide_version sdd-kit/MANIFEST.yaml` returns `1.7.0`
- **THEN** `doc/byebyevibe-guide.md` changelog includes `1.7.0` and `openspec/project.md` references guide **v1.7.0**

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

`bootstrap-sdd.sh` MUST capture the profile hint (presence of `package.json` and `openspec/`) **before** running `openspec init`, so that the directory created by `openspec init` itself cannot trigger the ambiguity warning. When `package.json` and `openspec/` coexisted before `openspec init`, the script MUST emit a warning (stderr) requesting explicit profile confirmation before continuing with the default profile (APP). It MUST NOT exit with an error — the warning is informational. The warning's recovery instruction MUST reference a real, supported invocation (the `--profile` flag), not a positional argument.

#### Scenario: Repo with package.json and openspec/ coexisting

- **WHEN** the operator runs `bash scripts/bootstrap-sdd.sh` in a repo that already has both `package.json` and `openspec/` before bootstrap starts
- **THEN** the script prints a stderr warning that the profile may be HYBRID, instructs the operator to rerun with `--profile HYBRID|DOCS_SPECS` if APP is wrong, and continues installation with APP profile

#### Scenario: APP repo without openspec/ receives no warning

- **WHEN** the operator runs `bash scripts/bootstrap-sdd.sh` in a repo that has `package.json` but not `openspec/` at bootstrap start
- **THEN** the script continues with APP profile without any HYBRID warning, even though `openspec init` creates `openspec/` during the same run

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

### Requirement: bootstrap-sdd.sh supports quiet didactic banners

`scripts/bootstrap-sdd.sh` as distributed by the kit (`sdd-kit/templates/scripts/bootstrap-sdd.sh`, and the hub copy when present) MUST support a `--quiet` / `-q` flag that suppresses didactic S-layer install banners. Didactic banners MUST appear only when stdout is a TTY and quiet mode is off. The script MUST preserve existing C1 phase order (OpenSpec → GitNexus → Graphify → `sdd-kit/install.sh`) and MUST continue to emit WARN/ERROR diagnostics regardless of quiet mode.

#### Scenario: Quiet flag documented in help or usage

- **WHEN** an operator inspects bootstrap usage (`-h`/`--help` if present, or guide §2 / kit README mention)
- **THEN** `--quiet` is documented as suppressing didactic banners for CI/agents

#### Scenario: Quiet run keeps phase order

- **WHEN** `bash scripts/bootstrap-sdd.sh --quiet` runs in a target repo
- **THEN** OpenSpec, GitNexus, Graphify, and kit install still execute in that order (subject to existing optional-continue WARN behavior for GitNexus)

### Requirement: install.sh emits optional add-ons teaser without installing them

`sdd-kit/install.sh` MUST append an optional add-ons teaser after its standard next-steps output. The teaser MUST reference optional UI, Probity, CI gates, and metrics entry points (guide sections and/or commands) and MUST NOT call `install-ui-module.sh`, `install-probity-module.sh`, or otherwise auto-install optional modules.

#### Scenario: Successful install shows add-ons teaser

- **WHEN** `bash sdd-kit/install.sh --profile HYBRID` completes file copy (or dry-run planning) and prints next steps
- **THEN** stdout also includes an optional add-ons teaser and exit code remains success when install itself succeeded

#### Scenario: Teaser does not invoke UI installer

- **WHEN** the optional add-ons teaser is printed
- **THEN** `install-ui-module.sh` is not executed as part of that `install.sh` run

### Requirement: Kit ships /opsx:help skill and command templates

`sdd-kit/MANIFEST.yaml` MUST register COPY-strategy entries (all profiles APP, DOCS_SPECS, HYBRID unless a future change narrows scope) for the ByeByeVibe `/opsx:help` skill and command mirrors, including at least: `.cursor/skills/openspec-help/SKILL.md`, `.claude/skills/openspec-help/SKILL.md`, `.cursor/commands/opsx-help.md`, `.claude/commands/opsx/help.md`, and `doc/sdd-operator-day1.md` (with matching `sdd-kit/templates/` sources and `sha256` fields).

#### Scenario: MANIFEST lists help skill template

- **WHEN** `sdd-kit/MANIFEST.yaml` is read after this capability is applied
- **THEN** an entry exists whose path is `.cursor/skills/openspec-help/SKILL.md` (or the documented kit path) with a `sha256` field

#### Scenario: install copies help surfaces

- **WHEN** `bash sdd-kit/install.sh --profile DOCS_SPECS` runs successfully against a greenfield target
- **THEN** the target receives the help skill, command mirrors, and `doc/sdd-operator-day1.md` from kit templates

### Requirement: install.sh emits day-1 operate tip naming help and onboard

After `sdd-kit/install.sh` prints its standard next-steps (and before or clearly alongside the optional add-ons teaser), it MUST print a short day-1 operate tip that names both `/opsx:help` and `/opsx:onboard`. The tip MUST NOT install modules, MUST NOT hide `/opsx:onboard`, and MUST follow resolved `chat_language` when available. `bootstrap-sdd.sh` manual next-steps MUST include an equivalent one-line reminder when didactic next-steps are shown.

#### Scenario: Successful install names both slash commands

- **WHEN** `bash sdd-kit/install.sh --profile APP` completes and prints next steps
- **THEN** stdout includes `/opsx:help` and `/opsx:onboard` in a day-1 operate tip

#### Scenario: Tip does not replace add-ons teaser

- **WHEN** install completes next-steps output
- **THEN** the day-1 operate tip and the optional add-ons teaser are both present as distinct reminders (tip does not remove add-ons teaser requirements)

### Requirement: AGENTS command templates include /opsx:help

Kit templates `sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md` and `sdd-kit/templates/AGENTS.commands.APP.md` MUST include a Commands table row for `/opsx:help`.

#### Scenario: Both profile command templates list help

- **WHEN** either AGENTS commands template is read after apply
- **THEN** `/opsx:help` appears in the Commands table

### Requirement: Kit ships preflight-sdd.sh

`sdd-kit/MANIFEST.yaml` MUST register a COPY entry for `scripts/preflight-sdd.sh` sourced from `templates/scripts/preflight-sdd.sh` with a `sha256` field. The `gate:` value is documentation metadata only and MUST NOT be executed via `eval` or equivalent (F-SEC-5).

#### Scenario: MANIFEST lists preflight script

- **WHEN** `sdd-kit/MANIFEST.yaml` is read after this capability is applied
- **THEN** an entry exists with `path: scripts/preflight-sdd.sh` and a non-empty `sha256` field

#### Scenario: install copies preflight script

- **WHEN** `bash sdd-kit/install.sh --profile DOCS_SPECS` completes successfully on a greenfield target
- **THEN** the target has an executable `scripts/preflight-sdd.sh` copied from the kit template

### Requirement: bootstrap-sdd.sh runs full preflight unless skipped

`sdd-kit/templates/scripts/bootstrap-sdd.sh` (and the hub mirror) MUST invoke full preflight (`--all`) at the start of bootstrap, after resolving the repo path and before OpenSpec install, unless `--skip-preflight` is passed. On preflight FAIL, bootstrap MUST abort with non-zero exit before installing CLIs.

#### Scenario: Bootstrap aborts when preflight fails

- **WHEN** `bootstrap-sdd.sh` runs without `--skip-preflight` and preflight reports FAIL
- **THEN** bootstrap exits non-zero before `npm install -g` OpenSpec/GitNexus steps

#### Scenario: skip-preflight bypasses the gate

- **WHEN** `bootstrap-sdd.sh --skip-preflight` is invoked
- **THEN** bootstrap does not require a successful preflight run to continue

### Requirement: install.sh applies repo-only preflight gate

`sdd-kit/install.sh` MUST run repo-only preflight (`scripts/preflight-sdd.sh --repo` or equivalent inline checks matching that mode) before copying templates, unless `--skip-preflight` is passed. It MUST NOT repeat the full host prerequisite scan as part of that gate.

#### Scenario: Standalone install fails without sdd-kit readability

- **WHEN** `install.sh` is invoked in a broken layout where repo preflight would FAIL and `--skip-preflight` is not set
- **THEN** install aborts before template copy

#### Scenario: install does not require host build tools

- **WHEN** `install.sh` runs with repo preflight PASS and host build tools absent
- **THEN** install does not FAIL solely due to missing GitNexus build tools

### Requirement: infra.md template includes Preflight section

`sdd-kit/templates/openspec/infra.md` MUST include a `## Preflight (last run)` section with markers reserved for `preflight-sdd.sh` (timestamp, IDEs, WARN summary, MCP names).

#### Scenario: Template contains Preflight heading

- **WHEN** the infra.md kit template is read after apply
- **THEN** it contains `## Preflight (last run)` and `preflight-timestamp` markers

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

### Requirement: Kit ships skill-guidance templates dual-surface

The kit MUST ship the skill-guidance text (detection clauses, suggestion message format, archive confidence question, creation hygiene rules) as templates under `sdd-kit/templates/` for both `.claude/` and `.cursor/` surfaces, registered in `sdd-kit/MANIFEST.yaml` with checksums regenerated via `bash sdd-kit/gen-manifest-checksums.sh`.

#### Scenario: Templates registered with checksums

- **WHEN** the skill-guidance templates are added or changed
- **THEN** `sdd-kit/MANIFEST.yaml` lists them for both IDE surfaces and checksums pass verification

### Requirement: Kit ships tooling-guidance templates dual-surface

The kit MUST ship the tooling-guidance text (cascade clause, suggestion message format, archive confidence question, signal catalog) as templates under `sdd-kit/templates/` for both `.claude/` and `.cursor/` surfaces, plus the single-copy `doc/tooling-install.md` and the extended `scripts/verify-infra.sh`, all registered in `sdd-kit/MANIFEST.yaml` with checksums regenerated via `bash sdd-kit/gen-manifest-checksums.sh`.

#### Scenario: Templates registered with checksums

- **WHEN** the tooling-guidance templates are added or changed
- **THEN** `sdd-kit/MANIFEST.yaml` lists them (both IDE surfaces where applicable) and checksums pass verification

### Requirement: bootstrap-sdd.sh skips already-installed machine-level package installs

`bootstrap-sdd.sh` MUST guard only its package-manager install commands behind a `command -v` presence check: `npm install -g @fission-ai/openspec@latest` (guard `openspec`), `npm install -g gitnexus` (guard `gitnexus`), and the uv installer plus `uv tool install graphifyy` (guards `uv` and `graphify`). When the guarded tool is present, the script MUST print a skip notice naming the tool (with detected version when `<tool> --version` succeeds) and MUST NOT re-run that install command. Skip notices are phase-level diagnostics: they MUST print regardless of TTY state and `--quiet` (same output class as phase markers). All other bootstrap steps MUST run unconditionally regardless of any skip, because they are idempotent and/or repo-scoped: `openspec init`, `gitnexus setup`, `gitnexus analyze`, `graphify install`, `graphify install --platform cursor`, `graphify hook install`, and `graphify update .`. When `openspec` is present, the script MUST compare its detected version against MANIFEST `min_openspec` and emit a WARN naming scenario C2b when the detected version is older (comparison failure degrades to a notice, never an abort). CLI refresh remains scenario C2b and MUST NOT be triggered implicitly by bootstrap.

#### Scenario: CLI already present is skipped

- **WHEN** `bootstrap-sdd.sh` runs (any TTY/quiet mode) on a machine where `openspec` is already on PATH
- **THEN** stdout contains a skip notice for OpenSpec, no `npm install -g` runs for it, and `openspec init` still executes for the target repo

#### Scenario: Repo-scoped Graphify steps survive the guard

- **WHEN** `bootstrap-sdd.sh` runs on a machine where `graphify` is already on PATH
- **THEN** `uv tool install` is skipped but `graphify install`, `graphify hook install`, and `graphify update .` still execute for the target repo

#### Scenario: Missing CLI is installed

- **WHEN** `bootstrap-sdd.sh` runs on a machine where `gitnexus` is not on PATH
- **THEN** the GitNexus install phase runs as in the pre-change behavior

#### Scenario: Stale OpenSpec triggers C2b warning

- **WHEN** the detected `openspec` version is older than MANIFEST `min_openspec`
- **THEN** the script emits a WARN pointing to scenario C2b and continues

### Requirement: bootstrap-sdd.sh resolves preflight and kit from its own source repo

When the target repo lacks `scripts/preflight-sdd.sh` and `sdd-kit/templates/scripts/preflight-sdd.sh`, `bootstrap-sdd.sh` MUST fall back to the corresponding script under its own source root (the repo containing the running script, resolved from the script's own path). When the target repo lacks `sdd-kit/install.sh`, the script MUST run the source root's `sdd-kit/install.sh` with `--repo <target>` instead of warning and skipping the payload phase. Target-local copies MUST take precedence when present. When neither the target nor the source root provides the needed file, the existing error/warning behavior applies.

#### Scenario: Greenfield target installs payload from hub

- **WHEN** `bash <hub>/scripts/bootstrap-sdd.sh <greenfield-target> --profile APP` runs and the target has no `sdd-kit/`
- **THEN** preflight and `install.sh` resolve from the hub clone, and the target receives the payload copy in one command

#### Scenario: Target-local kit wins

- **WHEN** the target repo carries its own `sdd-kit/install.sh`
- **THEN** bootstrap uses the target's copy, preserving consumer self-bootstrap behavior

### Requirement: Kit README scenarios table documents install scope

The scenarios table in `sdd-kit/README.md` MUST carry a scope column with these row values: C1 = `machine + repo`; C2b = `machine`; C2, C3, C1-UI, G2, and G4 = `repo`. The first-contact section MUST state in one line that CLIs install once per machine while each repo receives its own payload copy, linking to guide §1.6 for the full model.

#### Scenario: Newcomer sees scope at first contact

- **WHEN** a newcomer reads the `sdd-kit/README.md` scenarios table
- **THEN** each scenario row shows its enumerated scope value (C1 showing both scopes), and a link to guide §1.6 provides the full scope model

### Requirement: Guide documents minimal install-fetch footprint

`doc/byebyevibe-guide.md` MUST state, in §1.6 or an adjacent subsection, the exact minimal set of repository paths required and sufficient for a genuine C1 greenfield install: the whole `sdd-kit/` subtree plus the root-level `scripts/bootstrap-sdd.sh` and `scripts/preflight-sdd.sh`. The statement MUST note that no other repository path (including hub-only `doc/`, hub-only `openspec/`, or root `.cursor/`/`.claude/`) is read by `install.sh` or by the bootstrap/preflight scripts during C1.

#### Scenario: Operator or agent looks up the minimal footprint

- **WHEN** a reader opens guide §1.6 (or the adjacent subsection) before a greenfield install
- **THEN** they find the three required paths named explicitly, with a statement that no other hub path is required for C1

### Requirement: Guide documents a lightweight no-full-clone fetch recipe

`doc/byebyevibe-guide.md` MUST include at least one concrete, copy-pasteable command sequence that fetches only the minimal install-fetch footprint (per the previous requirement) into a target repository without cloning the full hub repository, and that results in the fetched paths landing at their real relative locations so the existing documented command `bash scripts/bootstrap-sdd.sh --profile <PROFILE>` runs unmodified afterward. The recipe MUST rely only on tooling already required by guide §1.1 (git) and MUST NOT introduce a new mandatory dependency.

#### Scenario: Recipe fetches only the required paths

- **WHEN** the documented lightweight-fetch recipe is followed against a target repository that has no `sdd-kit/` yet
- **THEN** the target repository ends up with `sdd-kit/`, `scripts/bootstrap-sdd.sh`, and `scripts/preflight-sdd.sh` populated, and no hub-only `doc/`, `openspec/`, `.cursor/`, or `.claude/` content is fetched

#### Scenario: Recipe is scoped to greenfield installs only

- **WHEN** the lightweight-fetch recipe is documented
- **THEN** the guide states it applies only when `sdd-kit/` is not already present in the target repository (C1), and does not apply to C2 (upgrade, which requires the existing `sdd-kit/upgrade.sh --dry-run`/`--apply` flow) or C3 (spec propagation, which must not run `install.sh`/`upgrade.sh`)

### Requirement: AI-assisted install prompt defaults to lightweight fetch

The §2.0 AI-assisted installation prompt in `doc/byebyevibe-guide.md` MUST instruct the agent to use the lightweight no-full-clone fetch recipe by default when installing into a genuine greenfield target repository, and MUST reserve a full hub clone for cases where the operator explicitly wants the persistent multi-project hub→destination workflow (per `clarify-install-scope-ux`, guide §1.6).

#### Scenario: Agent prompt names the lightweight fetch first

- **WHEN** an agent follows the §2.0 AI-assisted installation prompt for a target repository with no existing `sdd-kit/`
- **THEN** the prompt directs it to the lightweight-fetch recipe before mentioning a full hub clone, and names the full clone only as the alternative for persistent multi-project reuse

