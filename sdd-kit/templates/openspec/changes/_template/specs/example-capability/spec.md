# Delta — example-capability

Placeholder delta. `openspec validate --all --strict` rejects a change whose `specs/`
directory holds no parseable requirement, so `_template/` ships one valid requirement to
keep a fresh install green. When you copy `_template/` into a real change, rename the
`example-capability/` directory to the capability you are changing and replace everything
below — or delete the directory if your change touches no capability.

Shape note: the SHALL (or MUST) must sit on the **first line** of the requirement body —
openspec 1.3.1 inspects only that line. Keep it there when you rewrite this.

## ADDED Requirements

### Requirement: Placeholder requirement

A change copied from `_template/` SHALL replace this placeholder requirement with a real, testable obligation before it is archived.

#### Scenario: Placeholder scenario

- **WHEN** an operator copies `openspec/changes/_template/` to start a real change
- **THEN** this delta is rewritten or deleted, so no archived change carries the placeholder
