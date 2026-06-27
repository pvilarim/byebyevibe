# sdd-workspace-manifest Specification (delta)

## MODIFIED Requirements

### Requirement: Infrastructure manifest completeness

`openspec/infra.md` template in `sdd-kit/templates/` MUST include a **UI Development Module** section documenting Impeccable status, detected UI stack, and optional design tools (Open Design, Pencil, Figma MCP).

#### Scenario: Fresh APP install includes UI infra skeleton

- **WHEN** `sdd-kit/install.sh --profile APP` copies `openspec/infra.md`
- **THEN** the UI Development Module section exists with default values `pending` or `SKIP`
