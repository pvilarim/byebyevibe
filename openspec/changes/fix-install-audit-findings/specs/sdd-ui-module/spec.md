## MODIFIED Requirements

### Requirement: Infrastructure manifest UI module section

`openspec/infra.md` MUST include a section **UI Development Module** listing:

- Impeccable install status (✅ / SKIP / pending)
- Detected UI stack
- Optional tools: Open Design, Pencil, Figma MCP (manual / not installed)

The Impeccable status MUST be derived from the actual install outcome (presence of the installed skill, e.g. `.cursor/skills/impeccable`), not from the invocation path: an interactive apply where the operator accepted and the install succeeded SHALL be marked ✅, and a `--yes` apply where the install did not complete SHALL NOT be marked ✅.

#### Scenario: Agent reads infra before UI work

- **WHEN** an agent follows R10 before proposing Impeccable install
- **THEN** `openspec/infra.md` states whether the UI module was applied

#### Scenario: Interactive successful install is marked installed

- **WHEN** the operator runs `--apply` without `--yes`, answers yes to the Impeccable prompt, and `npx impeccable install` succeeds
- **THEN** the UI Development Module section marks Impeccable ✅

#### Scenario: Auto-yes without completed install is not marked installed

- **WHEN** the operator runs `--apply --yes` and the Impeccable install is skipped (e.g. Node below the required major) or the installed skill directory is absent
- **THEN** the UI Development Module section marks Impeccable `pending` (or SKIP), not ✅
