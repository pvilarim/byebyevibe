# sdd-skill-guidance Specification (delta)

## ADDED Requirements

### Requirement: Day-1 skill guidance section

`doc/sdd-operator-day1.md` MUST include a plain-language section on skills covering: when a skill helps and when it is pure cost (litmus test: would a competent generalist with internet access still get this wrong or do it differently than wanted?), the boundary between skill (how-to, procedural) vs spec (required behavior) vs `project.md` (constitution), agent-routed creation for novices (ask the agent to create the skill in the correct format rather than hand-writing SKILL.md), and the create → measure → prune lifecycle framing. The section MUST NOT instruct operators to write skills before starting development.

#### Scenario: Operator learns when a skill helps

- **WHEN** an operator reads the skill section of `doc/sdd-operator-day1.md`
- **THEN** they see the litmus test, the skill/spec/project.md boundary, and agent-routed creation guidance in plain language, with no requirement to author skills before development begins

### Requirement: Conversational detection signals

Kit explore and propose surfaces MUST instruct the agent to recognize domain-density signals during conversation: the user cites a local law, norm, or technical table; states company-specific numbers or thresholds; corrects the agent about a domain fact (strongest signal); re-explains or re-pastes previously provided material; or narrates a proprietary step-by-step method. On recognition, the agent MUST respond with the standard suggestion message rather than silently continuing or creating a skill unprompted.

#### Scenario: User corrects the agent on a domain fact

- **WHEN** during an explore session the user corrects the agent's assumption about a domain-specific fact
- **THEN** the agent offers the standard skill suggestion message instead of creating a skill automatically or ignoring the signal

### Requirement: Standard suggestion message with anti-noise cap

The skill suggestion message MUST have three fixed parts: what the skill WILL do (future sessions recall this automatically when the topic triggers), what it will NOT do (it does not self-update; stale data must be corrected by the user), and an explicit user decision. Suggestions MUST be offers, never impositions, and MUST be capped at one per session.

#### Scenario: Suggestion carries expectations and respects the cap

- **WHEN** the agent detects a second skill-worthy signal in the same session after already suggesting once
- **THEN** no second suggestion is made in that session, and the earlier suggestion included the will/won't/decide parts

### Requirement: Archive-time repetition question

The archive workflow MUST include a confidence question asking whether anything in the closed change repeated a procedure or explanation from a previous change, framed with the rule of three (first time normal, second time note it, third time extract a skill).

#### Scenario: Archive prompts for repetition

- **WHEN** an operator runs the archive phase for a change
- **THEN** the workflow surfaces the repetition confidence question before the change is archived

### Requirement: Creation hygiene rules

Skill creation guidance MUST enforce: search-before-create (extend an existing skill by default; new sibling skills are the exception), description diet (frontmatter description is 1–2 sentences stating when to trigger, never the content; knowledge goes in the body; dense data in `references/`), task-based naming (not persona-based), and a "verified on YYYY-MM" marker for volatile domain data.

#### Scenario: Overlapping skill is extended instead of duplicated

- **WHEN** a skill suggestion is accepted and an existing skill already covers the topic
- **THEN** the guidance directs extending the existing skill rather than creating a new one

#### Scenario: Volatile domain data is dated

- **WHEN** a skill is created containing local regulation values or market figures
- **THEN** the skill carries a "verified on YYYY-MM" marker

### Requirement: Dual-surface delivery

All skill-guidance text MUST ship for both Claude Code (`.claude/`) and Cursor (`.cursor/`) mirrors via `sdd-kit/templates/`, following the kit's existing dual-surface pattern.

#### Scenario: Both IDE surfaces receive guidance

- **WHEN** the kit installs or upgrades skill-guidance templates
- **THEN** equivalent guidance is present under both `.claude/` and `.cursor/` template trees

### Requirement: Deferred v2 monitoring recorded as non-goals

v1 MUST NOT implement skill-load metrics, usage telemetry, or harvest/prune tooling. These MUST be recorded as deferred v2 scope: M5 skill-load metric in `sdd-metrics.sh`, usage logging (Claude Code `PostToolUse` hook; Cursor requires a per-surface design with a documented degradation path since no equivalent hook exists), and a bidirectional harvest ceremony riding the existing metrics cadence.

#### Scenario: v1 ships without monitoring tooling

- **WHEN** this capability's v1 is implemented
- **THEN** no new scripts, hooks, or metrics are added, and the v2 monitoring scope is documented as deferred, including the Cursor telemetry asymmetry
