# sdd-tooling-guidance — delta

## MODIFIED Requirements

### Requirement: Archive-time manual-work question

The archive workflow MUST evaluate, as an agent-assessed item inside the same consolidated closing assessment defined by `sdd-skill-guidance`, whether anything in the closed change was done manually that a configured integration would have done. The agent MUST assess from its own session evidence (manual narration for an unconfigured tool during the change) and MUST suppress the item for integrations marked `declined` in `openspec/infra.md`. The workflow MUST always print the per-item verdict in the archive summary, MUST prompt the operator at most once via the single consolidated prompt covering only positively-signaled items, and MUST NOT block the archive.

#### Scenario: Clean archive prints verdict without prompting

- **WHEN** an operator runs the archive phase and the agent finds no manual-work signal in the closed change
- **THEN** the archive summary shows the tooling-gap verdict as a printed line and no manual-work prompt is presented

#### Scenario: Positive manual-work signal joins the consolidated prompt

- **WHEN** the agent's assessment finds manual work in the closed change that a configured integration would have done, for an integration not marked `declined`
- **THEN** the manual-work item appears in the single consolidated closing prompt (pointing to the tooling cascade, `openspec/infra.md`, and `doc/tooling-install.md`) and the archive proceeds regardless of the operator's answer
