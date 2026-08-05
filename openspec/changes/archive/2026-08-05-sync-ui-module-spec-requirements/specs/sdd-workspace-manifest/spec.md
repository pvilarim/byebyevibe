## MODIFIED Requirements

### Requirement: Manifest sections

`openspec/infra.md` MUST include at minimum these sections: SDD Stack (repo), MCP Servers, Skills (repo), **Install Kit**, **UI Development Module**, Session Coordination (when applicable), Env vars present (names only), and Agent rules summary. Each section MUST include a "verify with" column or command reference.

The **UI Development Module** section MUST be present regardless of whether the repository has a frontend: on a repository without one it carries `SKIP` or `none` values rather than being omitted, so that a reader can distinguish "no UI stack" from "never evaluated".

#### Scenario: Agent reads manifest structure

- **WHEN** an agent opens `openspec/infra.md`
- **THEN** it finds tabular entries for OpenSpec, GitNexus, Graphify, and Install Kit with version and status columns

#### Scenario: UI Development Module section present on a repository without a frontend

- **WHEN** an agent opens `openspec/infra.md` in a DOCS_SPECS repository with no frontend
- **THEN** the **UI Development Module** section exists, with `SKIP` or `none` values rather than being absent
