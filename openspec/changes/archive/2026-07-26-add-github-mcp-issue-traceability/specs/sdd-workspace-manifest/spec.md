## ADDED Requirements

### Requirement: github-mcp-server in MCP Servers section

`openspec/infra.md` MUST include an entry for `github-mcp-server` in the MCP Servers section with: pinned version reference (v1.7.0 for local binary), status indicator (✅/❌/`[NEEDS VERIFICATION]`), and a "verify with" command (e.g. `mcp_get_tools` or `~/.cursor/mcp.json`).

#### Scenario: Agent reads MCP inventory

- **WHEN** an agent opens `openspec/infra.md` MCP Servers section
- **THEN** it finds a row for `github-mcp-server` with version, status, and verification command

#### Scenario: Infra template in sdd-kit mirrors hub

- **WHEN** a consumer repo installs or upgrades from sdd-kit
- **THEN** `sdd-kit/templates/openspec/infra.md` contains the same github-mcp-server entry as the hub `openspec/infra.md`
