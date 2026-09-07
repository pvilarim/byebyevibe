## ADDED Requirements

### Requirement: Coordinated attempts bind durable ownership to transient locks
Before a coordinated writing attempt starts, its durable admission packet MUST identify the intended worktree, writer, session and paths scope. Apply MUST still acquire and validate the existing per-worktree lock before writes and release it when the phase completes or pauses. The run receipt MUST record observed acquisition, ownership conflict and release evidence, but MUST NOT act as a lock or prove that a writer stopped. Replacement attempts MUST reconcile both durable ownership history and current local lock/effect evidence; stale heartbeat alone MUST NOT authorize takeover.

#### Scenario: Durable receipt and live lock disagree
- **WHEN** a prior receipt appears interrupted but the target worktree still has a verified active apply owner
- **THEN** the replacement attempt remains blocked and the receipt cannot override or release the live owner

#### Scenario: Apply ends for a coordinated attempt
- **WHEN** a coordinated apply completes or pauses
- **THEN** the session release protocol runs and the durable receipt records the release outcome without retaining the ephemeral lock as historical state

