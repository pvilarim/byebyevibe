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

`openspec/infra.md` MUST include at minimum these sections: SDD Stack (repo), MCP Servers, Skills (repo), **Install Kit**, Session Coordination (when applicable), Env vars present (names only), and Agent rules summary. Each section MUST include a "verify with" column or command reference.

#### Scenario: Agent reads manifest structure

- **WHEN** an agent opens `openspec/infra.md`
- **THEN** it finds tabular entries for OpenSpec, GitNexus, Graphify, and Install Kit with version and status columns

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

### Requirement: github-mcp-server in MCP Servers section

`openspec/infra.md` MUST include an entry for `github-mcp-server` in the MCP Servers section with: pinned version reference (v1.7.0 for local binary), status indicator (✅/❌/`[NEEDS VERIFICATION]`), and a "verify with" command (e.g. `mcp_get_tools` or `~/.cursor/mcp.json`).

#### Scenario: Agent reads MCP inventory

- **WHEN** an agent opens `openspec/infra.md` MCP Servers section
- **THEN** it finds a row for `github-mcp-server` with version, status, and verification command

#### Scenario: Infra template in sdd-kit mirrors hub

- **WHEN** a consumer repo installs or upgrades from sdd-kit
- **THEN** `sdd-kit/templates/openspec/infra.md` contains the same github-mcp-server entry as the hub `openspec/infra.md`

### Requirement: Security constraints on manifest

The manifest MUST NEVER contain values from `.env`. Env var verification MUST use presence checks only (`test -n "${VAR:-}"` or equivalent). The agent MUST NOT read `.env` per existing security rules.

#### Scenario: Script checks env vars

- **WHEN** `verify-infra.sh` checks environment variables
- **THEN** it reads names from `.env.example` and reports only whether each var is set, never its value

### Requirement: SDD metrics script registered in infrastructure manifest

`openspec/infra.md` MUST include a tabular entry for the SDD metrics script (`scripts/sdd-metrics.sh`) with status and a "verificar com" command (at minimum `test -x scripts/sdd-metrics.sh` or `bash scripts/sdd-metrics.sh --help`). The entry MUST NOT contain secrets. Agents following R10 MUST treat a ✅ metrics entry as available for direct use without reinstalling tooling.

#### Scenario: Agent reads infra before suggesting DevLake

- **WHEN** an agent considers measuring SDD framework effectiveness
- **THEN** it finds `sdd-metrics.sh` documented in `openspec/infra.md` and uses the local script instead of proposing Apache DevLake installation

#### Scenario: Template parity

- **WHEN** `sdd-kit/templates/openspec/infra.md` is compared for metrics registration
- **THEN** it also documents the metrics script entry for consumer installs

### Requirement: i18n verification script registered in infrastructure manifest

`openspec/infra.md` MUST include a tabular entry for the documentation-language / i18n verification script (`scripts/verify-i18n-wave.sh`) with status and a "verify with" command (at minimum `test -x scripts/verify-i18n-wave.sh` or `bash scripts/verify-i18n-wave.sh --help`). The entry MUST NOT contain secrets. Agents following R10 MUST treat a ✅ i18n-verify entry as available for direct use during translation waves without reinstalling tooling. The manifest MAY also point to `doc/i18n/` (glossary and wave inventory) as related documentation.

#### Scenario: Agent prepares a translation wave

- **WHEN** an agent begins a `translate-*-wave-N` apply and reads `openspec/infra.md`
- **THEN** it finds `verify-i18n-wave.sh` documented and runs that script rather than inventing ad-hoc language checks

#### Scenario: Help command works when registered as installed

- **WHEN** the infra entry is marked ✅ and the operator runs `bash scripts/verify-i18n-wave.sh --help`
- **THEN** the command exits 0
