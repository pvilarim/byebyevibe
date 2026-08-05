# sdd-post-install-verification Specification

## Purpose

Post-install verification requirements for SDD bootstrap. Ensures constitution, entry points, tooling, and coordination artifacts are present and operational after installation.
## Requirements
### Requirement: Project constitution exists

The repository MUST have `openspec/project.md` edited with Purpose, Stack, and Cross-references to the SDD installation guide **and** a reference to the SDD kit (`sdd-kit/` or the installed version per guide §1.6).

#### Scenario: Agent reads project context

- **WHEN** an agent starts work in the repository
- **THEN** `openspec/project.md` describes the repo profile (APP, DOCS_SPECS, or HYBRID), points to `doc/sistema-sdd-pedro.md` with version, and indicates the applicable installation scenario (C1/C2)

### Requirement: AGENTS entry point is lean

The repository MUST have `AGENTS.md` at the root with ≤150 lines and MUST NOT contain the auto-generated block `<!-- gitnexus:start -->` … `<!-- gitnexus:end -->`.

#### Scenario: AGENTS size check

- **WHEN** post-install verification runs
- **THEN** `AGENTS.md` has at most 150 lines and does not include `gitnexus:start`

### Requirement: Tool-generated files are gitignored

`AGENTS.tools-generated.md` and `CLAUDE.tools-generated.md` MUST be listed in `.gitignore`.

#### Scenario: Ignore generated agent files

- **WHEN** GitNexus or other tools generate auxiliary files
- **THEN** those files are not committed accidentally

### Requirement: CLAUDE entry delegates to AGENTS

`CLAUDE.md` MUST point to `./AGENTS.md` and MUST have at most ~25 useful lines without duplicating long rules.

#### Scenario: Claude Code lookup

- **WHEN** Claude Code loads the repository
- **THEN** `CLAUDE.md` redirects behavior to `AGENTS.md` without a duplicated GitNexus block

### Requirement: Cursor base rules exist

`.cursor/rules/000-base.mdc` and `050-security.mdc` MUST exist after installation.

#### Scenario: Cursor always-on rules

- **WHEN** Cursor opens the workspace
- **THEN** base and security rules are active via `.mdc`

### Requirement: OpenSpec CLI is operational

`npx openspec list` MUST run without error and list changes under `openspec/changes/`.

#### Scenario: List changes

- **WHEN** the operator runs `npx openspec list`
- **THEN** the command exits with code 0

### Requirement: GitNexus index is current

`npx gitnexus status` MUST report the index up-to-date relative to the current HEAD.

#### Scenario: Index freshness

- **WHEN** the operator runs `npx gitnexus status`
- **THEN** the status indicates the index is up to date

### Requirement: Graphify report exists

After `graphify update .`, the file `graphify-out/GRAPH_REPORT.md` MUST exist (the `graphify-out/` directory may be gitignored).

#### Scenario: Knowledge graph built

- **WHEN** installation runs `graphify update .`
- **THEN** `graphify-out/GRAPH_REPORT.md` is present on the local filesystem

### Requirement: OpenSpec propose workflow works

The operator MUST be able to create a change via `/opsx:propose` or `npx openspec new change <name>`.

#### Scenario: Propose new change

- **WHEN** the user runs `/opsx:propose <description>` after restarting the IDE
- **THEN** a directory `openspec/changes/<name>/` is created with `.openspec.yaml`

### Requirement: Profile reflected in AGENTS commands

The Commands table in `AGENTS.md` MUST reflect the installed profile (APP, DOCS_SPECS, or HYBRID).

#### Scenario: DOCS_SPECS pilot

- **WHEN** the repository is DOCS_SPECS profile without an app at the root
- **THEN** `AGENTS.md` documents `/opsx:*` workflows and Graphify/OpenSpec priority over app stack

### Requirement: Infrastructure manifest present after install

After SDD installation, `openspec/infra.md` MUST exist and be up to date with ✅ status for core components (OpenSpec, GitNexus, Graphify).

#### Scenario: Post-install checklist item

- **WHEN** the operator runs checklist §2.8
- **THEN** `openspec/infra.md` exists, contains SDD Stack and MCP Servers sections, and a recent verification timestamp

#### Scenario: Verify infra script available

- **WHEN** the operator runs `bash scripts/verify-infra.sh` after installation
- **THEN** the script completes without error and confirms the status of components listed in `openspec/infra.md`

### Requirement: Session coordination present after install

After SDD installation, the scripts `scripts/sdd-session-check.sh` and `scripts/sdd-session-status.sh` MUST exist and be executable; `.cursor/rules/016-session-coordination.mdc` MUST exist (alwaysApply); `.sdd/runtime/` MUST be in `.gitignore`.

#### Scenario: Session scripts on checklist

- **WHEN** the operator runs checklist §2.8
- **THEN** `bash scripts/sdd-session-status.sh` completes without error
- **AND** `016-session-coordination.mdc` is present

#### Scenario: Infra manifest lists session coordination

- **WHEN** the operator reads `openspec/infra.md` after installation
- **THEN** a Session Coordination section lists the scripts

### Requirement: Session handoff rules present after install

After SDD installation, `.cursor/rules/015-session-phases.mdc` MUST exist and the `/opsx:*` skills MUST contain a Session Handoff section. Additionally, the apply skill MUST reference session coordination scripts (`sdd-session-check`, `sdd-session-release`). **Installation MUST obtain these artifacts from `sdd-kit/templates/` rather than markdown extraction.**

#### Scenario: Handoff and coordination rules active

- **WHEN** Cursor opens the workspace after SDD installation via kit
- **THEN** rules `015-session-phases.mdc` and `016-session-coordination.mdc` are active (alwaysApply: true)

### Requirement: Install kit present after SDD bootstrap

After SDD installation (scenario C1), the target repository MUST have all files listed in `sdd-kit/MANIFEST.yaml` expanded to their canonical paths OR MUST retain `sdd-kit/` at the version recorded in `openspec/project.md` Cross-references.

#### Scenario: Greenfield install checklist

- **WHEN** the operator completes checklist §2.8 after `sdd-kit/install.sh`
- **THEN** `bash sdd-kit/verify.sh` exits 0

#### Scenario: Manifest version recorded

- **WHEN** post-install verification runs
- **THEN** `openspec/project.md` or `openspec/infra.md` references installed kit version matching the guide version

### Requirement: Task pattern verification script present

The repository MUST have `scripts/verify-task-patterns.sh` after SDD install, executable, validating `Pattern:` paths in active change `tasks.md` files.

#### Scenario: Verify task patterns on checklist

- **WHEN** the operator runs `bash scripts/verify-task-patterns.sh` after install
- **THEN** the script exits 0 when no broken in-repo Pattern paths exist

### Requirement: Soft checklist pointer for day-1 help

Guide checklist §2.8 MUST include an optional soft item that `/opsx:help` is available (or that `doc/sdd-operator-day1.md` exists) for day-1 operate mapping. The item MUST be non-blocking: `bash sdd-kit/verify.sh` MUST NOT fail solely because the operator skipped reading help.

#### Scenario: Checklist mentions help or day-1 doc

- **WHEN** an operator reads guide §2.8 after this capability is applied
- **THEN** an optional checklist line references `/opsx:help` and/or `doc/sdd-operator-day1.md`

#### Scenario: verify.sh does not hard-require help read

- **WHEN** `bash sdd-kit/verify.sh` runs in a repo that has help artifacts installed but the operator has not invoked `/opsx:help`
- **THEN** verification does not fail solely for that reason

### Requirement: verify-infra preserves Preflight section

`scripts/verify-infra.sh` MUST continue updating post-install SDD Stack / kit status markers in `openspec/infra.md` and MUST NOT overwrite or clear `preflight-*` markers or the `## Preflight (last run)` section owned by `scripts/preflight-sdd.sh`.

#### Scenario: Post-install verify keeps preflight stamp

- **WHEN** `openspec/infra.md` has a non-placeholder `preflight-timestamp` and the operator runs `bash scripts/verify-infra.sh`
- **THEN** the Preflight timestamp marker remains unchanged by verify-infra

### Requirement: Soft checklist pointer for phase-0 preflight

Guide checklist §2.8 MUST include an optional soft item that phase-0 preflight has been run (or that `## Preflight (last run)` is stamped). The item MUST be non-blocking: `bash sdd-kit/verify.sh` MUST NOT fail solely because preflight was skipped with `--skip-preflight`.

#### Scenario: Checklist mentions preflight

- **WHEN** an operator reads guide §2.8 after this capability is applied
- **THEN** an optional checklist line references preflight or the Preflight section in `openspec/infra.md`

#### Scenario: verify.sh soft-warns without failing

- **WHEN** `bash sdd-kit/verify.sh` runs in a repo whose Preflight timestamp is still a placeholder
- **THEN** verification MAY print a WARN that preflight never ran and MUST NOT fail solely for that reason

### Requirement: UI module verification checklist

`doc/byebyevibe-guide.md` MUST include a **§2.11.1 UI module verification checklist** for the optional C1-UI module, referenced from the §2.11 UI module procedure. The checklist MUST be an **extension** of the §2.8 post-installation checklist, never a replacement for it: a repository that applied C1-UI runs both.

The checklist MUST cover at minimum: the `install-ui-module.sh --detect` outcome, the recorded `UI stack` value in `openspec/project.md` or `openspec/infra.md`, the presence of `doc/design/002-ui-module-install.md`, and the Impeccable status in `openspec/infra.md`.

#### Scenario: Operator verifies after applying the UI module

- **WHEN** the operator completes `bash sdd-kit/install-ui-module.sh --apply`
- **THEN** guide §2.11.1 lists the checks to run, and §2.11 points to it as the verification step

#### Scenario: UI checklist does not replace the core checklist

- **WHEN** an operator applied C1-UI on top of C1
- **THEN** §2.11.1 is presented as an addition to §2.8, and §2.8 remains required for the core install

