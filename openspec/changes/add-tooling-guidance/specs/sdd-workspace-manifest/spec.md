# sdd-workspace-manifest Specification (delta)

## MODIFIED Requirements

### Requirement: Assume installed until proven otherwise

`AGENTS.md` MUST include rule R10 stating: before proposing installation of MCP servers, CLIs, plugins, or skills, the agent MUST read `openspec/infra.md`. If an item is marked ✅, the agent MUST use it directly and MUST NOT reinstall or web-search setup instructions. R10 MUST additionally state the resolution order for acting on external tools: session operator override → configured CLI (default) → configured MCP (fallback) → suggest configuring (offer-only, capped) → manual instructions (last resort), per `sdd-tooling-guidance`.

#### Scenario: Tool marked installed in manifest

- **WHEN** `openspec/infra.md` shows GitNexus MCP as ✅
- **THEN** the agent uses GitNexus MCP tools directly without running `gitnexus setup` or searching installation guides

#### Scenario: Tool marked missing in manifest

- **WHEN** `openspec/infra.md` shows an item as ❌ or `[NEEDS VERIFICATION]`
- **THEN** the agent runs `scripts/verify-infra.sh` or asks the user before proposing installation

#### Scenario: R10 carries the cascade

- **WHEN** an agent reads R10 before acting on an external tool
- **THEN** it finds the override → CLI → MCP → suggest → manual resolution order stated alongside the read-the-manifest obligation

### Requirement: Infrastructure verification script

The repository MUST have `scripts/verify-infra.sh` — an idempotent script that checks SDD stack (OpenSpec, GitNexus, Graphify), MCP registration (names only), and env var presence (from `.env.example`, without reading `.env` values). The script MUST update verification timestamps in `openspec/infra.md` or print instructions to update them. The script MUST additionally report a tooling gap-check: presence/absence of MCP configuration files (`.mcp.json`, `.cursor/mcp.json`), availability on `PATH` of CLIs listed in the manifest, and key names present in `.env.example` — reporting absence only, never inferring which integrations the project should have. A commented-out key in `.env.example` MUST be reported as "considered and declined", not as a gap.

#### Scenario: Operator runs verification

- **WHEN** the operator runs `bash scripts/verify-infra.sh`
- **THEN** the script exits 0 when core SDD tools are operational and reports ✅/❌ for each checked item

#### Scenario: Post-install bootstrap

- **WHEN** SDD bootstrap completes (`scripts/bootstrap-sdd.sh` or manual §2.8 checklist)
- **THEN** `openspec/infra.md` is created or updated with initial ✅ states for installed components

#### Scenario: Gap-check reports absence without inference

- **WHEN** `bash scripts/verify-infra.sh` runs in a repo with no `.mcp.json` and no `.env.example`
- **THEN** the output states exactly that (config files absent) without recommending specific integrations

#### Scenario: Commented key is not a gap

- **WHEN** `.env.example` contains a commented-out key name
- **THEN** the gap-check reports it as considered-and-declined rather than missing

## ADDED Requirements

### Requirement: Declined status value in manifest tables

`openspec/infra.md` status columns MUST accept a `declined` value marking an integration the operator considered and refused. Agents following R10 MUST treat `declined` as a durable refusal: use the cascade's remaining rungs without re-suggesting the integration. `declined` entries MUST NOT be flagged as gaps by `verify-infra.sh`.

#### Scenario: Declined row suppresses the gap report

- **WHEN** an integration row carries `declined` and `bash scripts/verify-infra.sh` runs
- **THEN** the gap-check does not list that integration as missing
