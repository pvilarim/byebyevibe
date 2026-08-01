# sdd-skill-guidance — delta

## MODIFIED Requirements

### Requirement: Archive-time repetition question

The archive workflow MUST evaluate, as an agent-assessed item inside a single consolidated closing assessment, whether anything in the closed change repeated a procedure or explanation from a previous change, framed with the rule of three (first time normal, second time note it, third time extract a skill). The agent MUST gather evidence itself (at minimum, scanning `openspec/changes/archive/` for prior changes covering similar ground) instead of asking the operator an unconditional question. The workflow MUST always print the per-item verdict in the archive summary, MUST prompt the operator at most once — a single consolidated prompt covering only positively-signaled items — and MUST NOT block the archive.

#### Scenario: Clean archive prints verdict without prompting

- **WHEN** an operator runs the archive phase and the agent finds no repetition signal in the closed change
- **THEN** the archive summary shows the repetition verdict as a printed line and no repetition prompt is presented

#### Scenario: Positive repetition signal joins the consolidated prompt

- **WHEN** the agent's assessment finds the closed change repeated a procedure from a previous change
- **THEN** the repetition item appears in the single consolidated closing prompt (rule-of-three framing included) and the archive proceeds regardless of the operator's answer
