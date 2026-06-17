# sdd-session-handoff — Delta

## ADDED Requirements

### Requirement: Apply handoff releases session lock

When the apply phase completes or pauses for Session Handoff, the agent MUST run `bash scripts/sdd-session-release.sh` before emitting the handoff block.

#### Scenario: Apply pauses mid-change

- **WHEN** apply pauses and outputs Session Handoff for a fresh chat
- **THEN** the apply lock is released so another session may apply later (sequential workflow)

#### Scenario: Apply completes all tasks

- **WHEN** all apply tasks are marked complete
- **THEN** session lock and presence JSON are removed before archive handoff
