# sdd-workspace-manifest Specification (delta)

## MODIFIED Requirements

### Requirement: Manifest sections

`openspec/infra.md` MUST include at minimum these sections: SDD Stack (repo), MCP Servers, Skills (repo), **Install Kit**, **CI Gates**, Session Coordination (when applicable), Env vars present (names only), and Agent rules summary. Each section MUST include a "verify with" column or command reference.

#### Scenario: Agent reads manifest structure

- **WHEN** an agent opens `openspec/infra.md`
- **THEN** it finds tabular entries for OpenSpec, GitNexus, Graphify, Install Kit, and CI Gates with status and "verify with" columns

#### Scenario: CI Gates state is recorded

- **WHEN** an agent checks whether SDD gates are enforced in CI
- **THEN** the CI Gates entry in `openspec/infra.md` shows the state and the verify command `test -f .github/workflows/sdd-gates.yml`
