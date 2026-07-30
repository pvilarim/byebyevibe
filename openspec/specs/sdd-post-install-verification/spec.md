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

