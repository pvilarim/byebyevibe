# sdd-task-patterns — delta

## MODIFIED Requirements

### Requirement: Post-archive pattern promotion checklist

The `openspec-archive-change` skill MUST evaluate, as an agent-assessed item inside the same consolidated closing assessment defined by `sdd-skill-guidance`, whether a stable pattern from the archived change should be promoted to a reusable skill or noted in `openspec/project.md` Cross-references for future tasks. The skill MUST always print the per-item verdict in the archive summary (this printed line is the operator reminder), MUST prompt the operator at most once via the single consolidated prompt covering only positively-signaled items, and MUST NOT block the archive.

#### Scenario: Archive prompts pattern promotion

- **WHEN** all tasks are complete and the agent's assessment finds a reusable pattern in the archived change
- **THEN** the pattern-promotion item appears in the single consolidated closing prompt (promotion targets: reusable skill or `openspec/project.md` Cross-references) before archiving completes

#### Scenario: Clean archive prints reminder without prompting

- **WHEN** all tasks are complete and the agent's assessment finds no reusable pattern
- **THEN** the archive summary shows the pattern-promotion verdict as a printed line and no promotion prompt is presented
