## ADDED Requirements

### Requirement: Kit-owned /opsx:help slash surface

The repository MUST provide a ByeByeVibe-owned `/opsx:help` surface delivered as skill `openspec-help` plus Cursor and Claude command mirrors. The skill MUST be authored and shipped by the kit (not as a patch to upstream `openspec-onboard` or other OpenSpec-managed `openspec-*` workflows). Invocation MUST be on-demand (mode C): no always-on rule that injects the full tutorial into every session.

#### Scenario: Help skill present after kit install

- **WHEN** an operator completes C1 install (or C2 upgrade that includes help templates) and restarts the IDE
- **THEN** `/opsx:help` resolves to the kit skill/command that narrates day-1 operate guidance

#### Scenario: Help is not an OpenSpec-managed overwrite target

- **WHEN** an operator runs `openspec update` for selected OpenSpec workflows
- **THEN** the ByeByeVibe `/opsx:help` skill remains kit-owned and is not required to live inside patched `openspec-onboard` content

### Requirement: Canonical English day-1 operator document

The hub and kit MUST include a short canonical English document at `doc/sdd-operator-day1.md` that is the source of truth narrated by `/opsx:help`. The document MUST be written in English (F7 / `docs_language`). Chat replies MAY follow `chat_language`.

#### Scenario: Day-1 doc exists and is linked from help

- **WHEN** an operator or agent opens `/opsx:help`
- **THEN** the skill instructs reading or walking `doc/sdd-operator-day1.md` as the canonical outline

#### Scenario: Day-1 doc covers required outline sections

- **WHEN** `doc/sdd-operator-day1.md` is read
- **THEN** it includes sections covering: Onboard vs Help; memory over chat; clickable file map; explore (with prompt craft and confidence); propose (with artifact glossary including `design.md`); apply (gates/handoff and confidence); archive (specs/archive and confidence); and a next-step / Session Handoff example

### Requirement: Onboard and Help are both first-class

Documentation and install tips for day-1 operate MUST present upstream `/opsx:onboard` and ByeByeVibe `/opsx:help` as complementary, first-class surfaces. Help MUST explain the ByeByeVibe control plane (files, Graphify, GitNexus, confidence prompts, Session Handoff). Help MUST NOT hide, replace, or fork `openspec-onboard`. Suggested order MAY be help-then-onboard without burying onboard.

#### Scenario: Day-1 doc section 0 names both commands

- **WHEN** an operator reads the opening of `doc/sdd-operator-day1.md`
- **THEN** both `/opsx:help` and `/opsx:onboard` are named with distinct roles (map vs learn-by-doing)

#### Scenario: Install tip names both commands

- **WHEN** `sdd-kit/install.sh` finishes next-steps output after a successful install path
- **THEN** stdout includes a tip that names both `/opsx:help` and `/opsx:onboard`

### Requirement: Phase tutorial spine in plain language

The day-1 document MUST explain `explore → propose → apply → archive` in plain language as persistent memory for humans and agents (chat is ephemeral; `openspec/` plus graphs are durable). It MUST state that not every task needs explore (types A/B). It MUST NOT invent a product file named `roadmap.md` as an SDD runtime artifact; “roadmap” vocabulary MUST map to active `openspec/changes/` plus canonical `openspec/specs/`, and “milestones” to numbered sections in `tasks.md`.

#### Scenario: Operator learns phase meanings without jargon-only table

- **WHEN** an operator reads the phase sections of `doc/sdd-operator-day1.md`
- **THEN** each of explore, propose, apply, and archive has a plain-language meaning, what it produces, and what it does not do

#### Scenario: Roadmap vocabulary maps to real paths

- **WHEN** the file map section is read
- **THEN** it maps operator “roadmap” / “milestones” language to `openspec/changes/`, `openspec/specs/`, and `tasks.md` sections without introducing `roadmap.md`

### Requirement: Clickable control-plane file map

The day-1 document MUST include a clickable (repo-relative) map covering OpenSpec paths (`openspec/changes/`, `openspec/specs/`, `openspec/changes/archive/`, `openspec/project.md`), Graphify (`graphify-out/GRAPH_REPORT.md`, `graphify update .`), GitNexus (do not hand-edit `.gitnexus/`; use status/MCP), and task/design templates (guide §12.3 / §12.10 and/or kit `_template`).

#### Scenario: Map lists OpenSpec and graph surfaces

- **WHEN** an operator follows the map section
- **THEN** they can locate openspec change/spec paths and Graphify/GitNexus guidance without leaving the day-1 doc for a full §4 rewrite

### Requirement: Explore prompt craft coaching

The day-1 explore section MUST coach humans to structure explore prompts with situation/scenario, problem, inputs, outputs, unknowns (questions to ask), and out of scope (including no implementation in explore). It MUST distinguish feature I/O (prompt craft) from control-plane I/O (tool boxes in guide §4.3).

#### Scenario: Explore section lists prompt craft fields

- **WHEN** an operator reads the explore section of `doc/sdd-operator-day1.md`
- **THEN** they see explicit coaching for inputs, outputs, unknowns, and out-of-scope / no-implement-in-explore

### Requirement: Per-phase confidence prompts

The day-1 document MUST provide optional copy-paste confidence questions (approximately 2–4) per phase plus one objective check where available (e.g. `openspec validate`, task Gates, archive path). Each phase MUST include a meta question equivalent to: what must a new agent read, without this chat, to continue?

#### Scenario: Propose section includes confidence and validate check

- **WHEN** an operator finishes reading the propose section
- **THEN** they can copy confidence questions and see an objective check that references `openspec validate` or equivalent

#### Scenario: Meta handoff question present each phase

- **WHEN** any phase section with confidence prompts is read
- **THEN** a question about what a new agent must read without the chat is present

### Requirement: Propose artifact glossary includes design.md

Inside the help/day-1 propose section (not as an orphan separate essay), the document MUST explain standard OpenSpec artifacts in plain language: `proposal.md`, `specs/**`, `design.md` (when trade-offs / cross-cutting / ambiguity — may be light when obvious), `tasks.md`, and `research.md` (only if explore ran). It MUST link guide §12.3 and §12.10 for templates.

#### Scenario: design.md explained in propose section

- **WHEN** an operator reads the propose section of `doc/sdd-operator-day1.md`
- **THEN** `design.md` is explained in plain language with when-to-write guidance and a pointer to guide §12.3

### Requirement: AGENTS Commands lists /opsx:help

Hub `AGENTS.md` and kit AGENTS command templates MUST include a Commands table row for `/opsx:help` describing the day-1 operator tutorial / control-plane map.

#### Scenario: DOCS_SPECS commands template mentions help

- **WHEN** `sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md` is read after this capability is applied
- **THEN** it contains `/opsx:help`

#### Scenario: Hub AGENTS lists help

- **WHEN** hub `AGENTS.md` Commands table is read after apply
- **THEN** `/opsx:help` appears with a short day-1 / tutorial description

### Requirement: Evaluation stub for operator onboarding insertion

The repository MUST include an evaluation document under `doc/avaliacoes/` recording the Option A adoption (`/opsx:help` + day-1 doc + tip), complementary relationship to `/opsx:onboard`, non-goals, and ownership collision note for a future upstream `help`. The evaluation MUST be indexed in `doc/avaliacoes/README.md`.

#### Scenario: Evaluation discoverable from index

- **WHEN** an operator opens `doc/avaliacoes/README.md`
- **THEN** a row points to the 2026-08-01 (or successor) operator-onboarding evaluation

### Requirement: Non-goals for day-1 onboarding v1

The day-1 onboarding capability MUST NOT introduce an always-on tutorial rule, a forced interactive end-of-C1 menu, patches to `openspec-onboard`, a single CTA that omits `/opsx:onboard`, GIF/asciinema as a v1 deliverable, or help subcommands as a v1 requirement.

#### Scenario: Spec and design exclude always-on rule

- **WHEN** implementers follow this capability’s non-goals
- **THEN** no alwaysApply rule is added whose sole purpose is to inject the full day-1 tutorial into every chat
