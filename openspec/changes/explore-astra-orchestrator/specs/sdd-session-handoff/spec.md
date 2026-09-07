## ADDED Requirements

### Requirement: Orchestrator role is the current-phase agent

The SDD guide (`doc/byebyevibe-guide.md`) MUST name the **orchestrator** as the agent sitting in the chair for the **current** OpenSpec phase (`/opsx:explore`, `/opsx:propose`, `/opsx:apply`, or `/opsx:archive`). The guide MUST state that this role is not a second runtime, not a process that spans phases in one chat, and not a replacement for versioned artifacts (`openspec/changes/<id>/`) as session memory. The repository MUST NOT add a slash command or skill whose job is to run explore→propose→apply→archive in one session.

#### Scenario: Guide names the role next to the pipeline

- **WHEN** an operator or agent reads the full visual pipeline section of the SDD guide (§3.4)
- **THEN** they see a short statement that the orchestrator is the agent of **this** phase, with artifacts as memory and a human or Cursor Automation as the scheduler between phases

#### Scenario: Agent refuses a same-session full pipeline

- **WHEN** a user asks the current-phase agent to run explore through archive in the same chat or to own phase state in a TypeScript/YAML machine
- **THEN** the agent refuses, points at Session Handoff plus `tasks.md`, and does not create a competing program counter

#### Scenario: No orchestrate mega-skill

- **WHEN** a later change proposes `/opsx:orchestrate` or an equivalent skill that collapses phase boundaries
- **THEN** that proposal is out of scope for this capability and MUST be rejected unless a new OpenSpec change explicitly amends this requirement
