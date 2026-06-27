# sdd-workspace-manifest Specification

## Purpose
TBD - created by archiving change add-session-handoff-infra-manifest. Update Purpose after archive.
## Requirements
### Requirement: Workspace infrastructure manifest exists

The repository MUST have `openspec/infra.md` — a versioned, human-readable manifest of installed infrastructure. The file MUST NOT contain secret values (API keys, tokens, passwords). It MAY contain env var **names** and presence indicators (✅/❌), MCP server **names**, CLI **versions**, and skill **paths**.

#### Scenario: Agent starts propose or apply phase

- **WHEN** an agent begins `/opsx:propose` or `/opsx:apply` work
- **THEN** the agent reads `openspec/infra.md` before proposing to install, configure, or web-search setup instructions for any listed tool

#### Scenario: Manifest is committed

- **WHEN** the repository is cloned or a new agent session starts
- **THEN** `openspec/infra.md` is available in git without requiring IDE-global configuration discovery

### Requirement: Assume installed until proven otherwise

`AGENTS.md` MUST include rule R10 stating: before proposing installation of MCP servers, CLIs, plugins, or skills, the agent MUST read `openspec/infra.md`. If an item is marked ✅, the agent MUST use it directly and MUST NOT reinstall or web-search setup instructions.

#### Scenario: Tool marked installed in manifest

- **WHEN** `openspec/infra.md` shows GitNexus MCP as ✅
- **THEN** the agent uses GitNexus MCP tools directly without running `gitnexus setup` or searching installation guides

#### Scenario: Tool marked missing in manifest

- **WHEN** `openspec/infra.md` shows an item as ❌ or `[NEEDS VERIFICATION]`
- **THEN** the agent runs `scripts/verify-infra.sh` or asks the user before proposing installation

### Requirement: Infrastructure verification script

The repository MUST have `scripts/verify-infra.sh` — an idempotent script that checks SDD stack (OpenSpec, GitNexus, Graphify), MCP registration (names only), and env var presence (from `.env.example`, without reading `.env` values). The script MUST update verification timestamps in `openspec/infra.md` or print instructions to update them.

#### Scenario: Operator runs verification

- **WHEN** the operator runs `bash scripts/verify-infra.sh`
- **THEN** the script exits 0 when core SDD tools are operational and reports ✅/❌ for each checked item

#### Scenario: Post-install bootstrap

- **WHEN** SDD bootstrap completes (`scripts/bootstrap-sdd.sh` or manual §2.8 checklist)
- **THEN** `openspec/infra.md` is created or updated with initial ✅ states for installed components

### Requirement: Manifest sections

`openspec/infra.md` MUST include at minimum these sections: SDD Stack (repo), MCP Servers, Skills (repo), **Install Kit**, **UI Development Module**, Session Coordination (when applicable), Env vars present (names only), and Agent rules summary. Each section MUST include a "verify with" column or command reference.

#### Scenario: Agent reads manifest structure

- **WHEN** an agent opens `openspec/infra.md`
- **THEN** it finds tabular entries for OpenSpec, GitNexus, Graphify, and Install Kit with version and status columns

### Requirement: UI Development Module section in infrastructure manifest

`openspec/infra.md` template in `sdd-kit/templates/` MUST include a **UI Development Module** section documenting Impeccable status, detected UI stack, and optional design tools (Open Design, Pencil, Figma MCP).

#### Scenario: Fresh APP install includes UI infra skeleton

- **WHEN** `sdd-kit/install.sh --profile APP` copies `openspec/infra.md`
- **THEN** the UI Development Module section exists with default values `pending` or `SKIP`

### Requirement: Install kit section in infrastructure manifest

`openspec/infra.md` MUST include an **Install Kit** section listing: kit version, path (`sdd-kit/` or "expanded only"), `install.sh` / `upgrade.sh` / `verify.sh` status, and last verification timestamp.

#### Scenario: Agent reads kit version from infra

- **WHEN** an agent reads `openspec/infra.md` before proposing SDD reinstall
- **THEN** the Install Kit section shows version and ✅ when kit matches guide version in `project.md`

#### Scenario: Verify infra updates kit section

- **WHEN** `bash scripts/verify-infra.sh` completes successfully on a hub repo
- **THEN** `openspec/infra.md` Install Kit section reflects current `MANIFEST.yaml` version

### Requirement: Infra manifest in AGENTS context table

`AGENTS.md` "Contexto sob demanda" table MUST include an entry pointing to `openspec/infra.md` for infrastructure already installed in the workspace.

#### Scenario: Agent loads context on demand

- **WHEN** an agent needs to know if a tool is available
- **THEN** the AGENTS.md context table directs it to `openspec/infra.md` before external search

### Requirement: Security constraints on manifest

The manifest MUST NEVER contain values from `.env`. Env var verification MUST use presence checks only (`test -n "${VAR:-}"` or equivalent). The agent MUST NOT read `.env` per existing security rules.

#### Scenario: Script checks env vars

- **WHEN** `verify-infra.sh` checks environment variables
- **THEN** it reads names from `.env.example` and reports only whether each var is set, never its value

