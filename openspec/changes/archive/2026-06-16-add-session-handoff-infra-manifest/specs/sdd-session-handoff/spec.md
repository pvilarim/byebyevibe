## ADDED Requirements

### Requirement: Session handoff at phase completion

Each OpenSpec phase skill (`openspec-explore`, `openspec-propose`, `openspec-apply-change`, `openspec-archive-change`) MUST include a mandatory `## Session Handoff` section at the end of the skill body. When the agent concludes a phase, it MUST stop and suggest opening a **new chat** with a copy-paste handoff prompt — not continue into the next phase in the same thread.

#### Scenario: Explore phase concludes

- **WHEN** an explore session reaches a conclusion (decision crystallized, research complete, or user ready to proceed)
- **THEN** the agent outputs the Session Handoff block with a prompt for `/opsx:propose <change-id>` in a new chat, referencing any research artifacts produced

#### Scenario: Propose phase completes artifacts

- **WHEN** all apply-required artifacts are created for a change
- **THEN** the agent outputs the Session Handoff block with a prompt for `/opsx:apply <change-id>` in a new chat, listing artifact paths under `openspec/changes/<id>/`

#### Scenario: Apply phase completes or pauses

- **WHEN** all tasks are complete or the agent pauses due to a blocker
- **THEN** the agent outputs the Session Handoff block suggesting `/opsx:archive <change-id>` in a new chat (if complete) or resuming `/opsx:apply` in a fresh chat (if paused)

### Requirement: One session equals one phase

The repository MUST have a Cursor always-on rule (`.cursor/rules/015-session-phases.mdc`) stating that a single chat session MUST NOT span more than one SDD phase (explore | propose | apply | archive). The agent MUST refuse to start `/opsx:apply` in a chat that began with `/opsx:explore`.

#### Scenario: User requests apply after explore in same chat

- **WHEN** the user asks to implement code in a chat that started with `/opsx:explore`
- **THEN** the agent refuses direct implementation and provides the Session Handoff prompt for a new chat with `/opsx:propose` or `/opsx:apply`

#### Scenario: Phase transition detected

- **WHEN** the agent detects a transition from one phase to another (e.g., propose → apply)
- **THEN** the agent stops current work and suggests a new chat with the appropriate handoff prompt before proceeding

### Requirement: Handoff prompt template

Each Session Handoff block MUST include a minimal copy-paste template containing: target slash command, change-id (if known), paths to read, and reference to `openspec/infra.md`. The template MUST NOT exceed ~15 lines.

#### Scenario: Handoff from propose to apply

- **WHEN** the agent completes a propose phase for change `add-user-auth`
- **THEN** the handoff prompt includes `/opsx:apply add-user-auth`, paths to `proposal.md`, `design.md`, `tasks.md`, and `openspec/infra.md`

### Requirement: OpenSpec artifacts are session memory

OpenSpec change artifacts (`openspec/changes/<id>/`) MUST be treated as the persistent memory between sessions. The agent MUST NOT rely on chat history to carry decisions across phase boundaries.

#### Scenario: New apply session starts

- **WHEN** a user opens a new chat with `/opsx:apply <change-id>`
- **THEN** the agent reads change artifacts from disk and does not ask the user to re-explain decisions already captured in proposal/design/specs

### Requirement: Pipeline documentation reflects handoffs

`doc/sistema-sdd-pedro.md` §3.4 pipeline diagram MUST include explicit human-gate markers (`⊕ novo chat + handoff prompt`) between explore→propose, propose→apply, and apply→archive transitions.

#### Scenario: Agent reads SDD guide for workflow

- **WHEN** an agent consults the pipeline visual in the SDD guide
- **THEN** phase boundaries show session handoff as a required step between phases
