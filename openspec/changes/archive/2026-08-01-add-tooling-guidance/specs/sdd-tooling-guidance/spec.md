# sdd-tooling-guidance Specification (delta)

## ADDED Requirements

### Requirement: Resolution cascade for external-tool actions

When the agent needs to act on an external tool, it MUST resolve the action in this order: (1) honor a session operator override ("use MCP first") without debate; (2) use a configured CLI (default); (3) use a configured MCP (fallback); (4) if neither is configured, suggest configuring (offer-only, subject to the shared suggestion cap); (5) narrate manual instructions as last resort. Falling to manual narration for the same tool a second time in a session IS the detection event that arms the suggestion — no separate manual-action counter SHALL be introduced.

#### Scenario: Configured CLI wins over configured MCP

- **WHEN** the agent needs to act on an external tool that has both a working CLI and a configured MCP, and no operator override is active
- **THEN** the agent uses the CLI

#### Scenario: Second manual fall arms the suggestion

- **WHEN** the agent narrates manual dashboard steps for the same unconfigured tool a second time in one session and the shared suggestion cap is not yet spent
- **THEN** the agent offers the standard tooling suggestion message instead of silently narrating manual steps again

### Requirement: CLI-first default with per-tool MCP exceptions

Tooling guidance MUST state CLI-first as the default (zero permanent context cost, controllable output, scriptable, works in CI) and MUST allow per-tool exceptions where only MCP delivers the capability (e.g. structured design context). The hierarchy is decided per tool, not by dogma; the recorded pedagogy is "key → CLI → MCP, unless only MCP delivers the capability".

#### Scenario: MCP-only capability skips the CLI rung

- **WHEN** the needed capability for a tool is documented as deliverable only via its MCP
- **THEN** the agent treats MCP as the primary path for that tool without first attempting a CLI

### Requirement: Session-scoped operator override

A user-stated resolution override (e.g. "use MCP first") MUST be honored for the current session only. v1 MUST NOT persist per-tool preferences across sessions; a durable preference column in `openspec/infra.md` is deferred to v2.

#### Scenario: Override does not leak across sessions

- **WHEN** an operator states "use MCP first" in one session and a new session later acts on the same tool
- **THEN** the new session applies the default cascade (CLI first) unless the override is restated

### Requirement: Security-hardened offer-only suggestion message

The tooling suggestion message MUST have three fixed parts: what configuring the integration WILL do; what it will NOT do and what it costs — including that nothing is ever installed or configured unprompted, what data the MCP server would see, where keys live (`.env`, never committed), that servers MUST come only from trusted registries or official sources, and that active MCP schemas charge every session ("for occasional use, CLI + key is cheaper"); and an explicit user decision. The agent MUST NEVER install or configure an MCP, CLI, or key unprompted — no exceptions.

#### Scenario: Suggestion states security and context cost

- **WHEN** the agent offers a tooling suggestion for an unconfigured integration
- **THEN** the message includes the no-unprompted-install guarantee, the data-exposure and key-location notes, the trusted-source constraint, and the MCP per-session context-cost trade-off, and ends with the user deciding

### Requirement: Suggestion cap shared with skill guidance

Tooling suggestions MUST count against the shared cap defined by `sdd-skill-guidance`: at most one proactive suggestion per session across mechanisms (skill or tooling), strongest signal wins. A tooling suggestion MUST NOT be offered in a session where a proactive suggestion of either kind was already made.

#### Scenario: Skill suggestion spends the shared cap

- **WHEN** a skill suggestion was already offered in the session and a tooling gap signal later fires
- **THEN** no tooling suggestion is made in that session

### Requirement: Durable refusals honored

A declined tooling suggestion MUST stick across sessions: an integration marked `declined` in `openspec/infra.md` MUST NOT be re-suggested, and a commented-out key in `.env.example` MUST be treated as "considered and declined" by both the agent and the static gap-check. Re-suggesting a refused integration is treated as suggesting a policy violation, not as helpfulness.

#### Scenario: Declined integration is not re-suggested

- **WHEN** an integration row in `openspec/infra.md` carries the `declined` status and its gap signal fires in a later session
- **THEN** the agent does not offer a suggestion for that integration and proceeds down the cascade to manual instructions

### Requirement: Conversational signal catalog as secondary layer

Tooling guidance MUST document the conversational detection signals as a secondary layer behind the static gap-check: repeated manual narration for the same tool (gold signal — self-observed); user pasting external-tool output (missing read integration); user repeatedly asking for content "to paste elsewhere" (missing write integration); credential/401 errors on commands the agent ran (missing `.env` key); user re-describing external system state (missing read access). The catalog MUST carry the caveat that manual paste can be a policy choice rather than a gap.

#### Scenario: Paste caveat tempers detection

- **WHEN** a user pastes external-tool output and no other signal corroborates a gap
- **THEN** the guidance directs the agent to weigh the policy-choice caveat rather than treating the paste alone as sufficient grounds to suggest

### Requirement: Static gap-check reports absence, not need

The v1 static gap-check MUST report what is present or absent (MCP config files, manifest-listed CLIs, `.env.example` key names) and MUST NOT infer which integrations the project should have from `project.md` or dependency manifests. Stack-inference gap analysis is deferred to v2.

#### Scenario: No inference from the stack

- **WHEN** the gap-check runs on a repo whose `project.md` names a service with no configured tooling
- **THEN** the report notes only concrete presence/absence and does not recommend integrations derived from the stack

### Requirement: Archive-time manual-work question

The archive workflow MUST include a confidence question asking whether anything in the closed change was done manually that a configured integration would have done — same register as the existing confidence questions, non-blocking.

#### Scenario: Archive prompts for manual work

- **WHEN** an operator runs the archive phase for a change
- **THEN** the workflow surfaces the manual-work confidence question before the change is archived

### Requirement: Per-tool install documentation pattern

Per-tool install how-to MUST live in `doc/tooling-install.md` (not in skills or command bodies), with each entry preferring an official-doc link plus a verification command over transcribed step-by-step walkthroughs, and carrying a "verified on YYYY-MM" marker. `openspec/infra.md` rows MUST reference this doc for install guidance, mirroring the UI-module precedent (`doc/design/002-ui-module-install.md`).

#### Scenario: Entry survives upstream drift

- **WHEN** an agent helps configure a tool from `doc/tooling-install.md`
- **THEN** it finds an official-source link and a command that proves the install worked, each entry dated with its verification month

### Requirement: Dual-surface delivery with documented asymmetry

All tooling-guidance text MUST ship for both Claude Code (`.claude/`) and Cursor (`.cursor/`) mirrors via `sdd-kit/templates/`. Claude Code surfaces MAY instruct the agent to use native harness tools (e.g. `SearchMcpRegistry`, `ListConnectors`) where available; Cursor surfaces MUST degrade to "suggest + point to `doc/tooling-install.md`". The asymmetry MUST be recorded per-surface with no parity assumed.

#### Scenario: Cursor degradation path is explicit

- **WHEN** the Cursor mirror of the tooling guidance is read
- **THEN** it directs suggestion plus `doc/tooling-install.md` and does not reference Claude Code harness tools as if available

### Requirement: Deferred v2 scope recorded as non-goals

v1 MUST NOT implement stack-inference gap analysis, durable per-tool preferences, per-tool usage telemetry, or preflight-time gap WARNs. These MUST be recorded as deferred v2 scope, including the Cursor telemetry asymmetry inherited from `sdd-skill-guidance` v2.

#### Scenario: v1 ships without inference or telemetry

- **WHEN** this capability's v1 is implemented
- **THEN** no stack-inference, preference persistence, or telemetry is added, and the v2 scope is documented as deferred
