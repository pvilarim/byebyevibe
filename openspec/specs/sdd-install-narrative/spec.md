# sdd-install-narrative Specification

## Purpose

Normative requirements for the didactic C1 install narrative: dual S↔T tone in guide §2 and agent prompts, per-tool “Without it…” copy, optional-addons glance after the checklist, TTY banners / `--quiet` on bootstrap, post-install add-ons teaser (no auto-install), and a short README “how the three tools fit” paragraph — without rewriting §4 or changing C1 tool order.
## Requirements
### Requirement: Dual S-T install narrative tone

C1 installation documentation and agent install prompts MUST present a default **S** layer (simple language, “Without it…” consequence, and a short scenario) before or alongside each major tool step, and MUST defer deep technical comparison to layer **T** (commands, paths, versions) on demand or when the next action requires exact invocation. When a technical term is introduced, the prose MUST include a brief T→S analogy or scenario. Versioned artifacts MUST remain in English (`docs_language`); runtime operator-facing strings MAY follow `chat_language`.

#### Scenario: Guide step uses S then T

- **WHEN** an operator reads guide §2.2 (OpenSpec), §2.3 (GitNexus), or §2.4 (Graphify)
- **THEN** each step includes What / Why now / Without it / You’ll get in simple language before or with the existing command block, and does not replace the command block

#### Scenario: Agent prompt requires S before step

- **WHEN** an agent follows the §2.0 AI-assisted installation prompt
- **THEN** the prompt instructs the agent to explain the S layer before each install step and to expand T only when asked or when the next shell command needs exact paths/flags

### Requirement: Three-pillars diagram and install order rationale

Guide §2.1 MUST include a diagram of the three pillars (OpenSpec, GitNexus, Graphify) plus the sdd-kit payload bridge, a short S-layer rationale for the install order, and an explicit link to §4 for the full responsibilities matrix. The documented C1 tool order MUST remain OpenSpec → GitNexus → Graphify → `sdd-kit/install.sh` (then AGENTS curation / IDE steps).

#### Scenario: Operator reads why order matters

- **WHEN** an operator opens §2.1 before installing
- **THEN** they see a three-pillars (+ kit) diagram, a plain-language reason not to reverse the order, and a pointer to §4 for detailed comparison

### Requirement: Canonical S-layer copy for core tools

The guide and runtime banners/teasers MUST use the refined What / Why now / “Without it…” / You’ll get meanings locked in design D3 of the archived install-narrative change for OpenSpec, GitNexus, Graphify, and sdd-kit. Apply MUST NOT invent alternate slogans for these four tools. The sdd-kit row MUST appear in §2.1 (pillars + kit bridge) and/or the install-kit phase narrative/teaser — not only in scripts. Runtime banners MUST additionally carry a third **Scope** line per tool, as defined by change `clarify-install-scope-ux`, in both `en` and `pt-BR` string sets: for OpenSpec, GitNexus, and Graphify the Scope line states the tool installs once on the machine and future projects reuse it; for sdd-kit the Scope line states the payload is copied into the current repo and each project receives its own copy. Scope lines MUST match actual bootstrap behavior (machine-level package installs already present are skipped, per `sdd-install-kit`).

#### Scenario: OpenSpec without-it appears in guide

- **WHEN** the OpenSpec step narrative is rendered in the versioned guide
- **THEN** it states that without OpenSpec, chat turns into code and nobody remembers why (EN wording per design D3)

#### Scenario: Guide OpenSpec What line matches D3

- **WHEN** the OpenSpec step S-layer is rendered in the versioned guide
- **THEN** it presents OpenSpec as the playbook for a change (think → agree → do → keep a record) per design D3 EN What column

#### Scenario: Runtime pt-BR uses Sem ela drafts

- **WHEN** a TTY banner or install teaser runs with `chat_language` (or `--chat-lang` / `SDD_CHAT_LANG`) equal to `pt-BR`
- **THEN** the corresponding “Sem ela…” strings from design D3 are used for those four tools

#### Scenario: Kit without-it visible in guide narrative

- **WHEN** an operator reads §2.1 or the sdd-kit phase description in the install path
- **THEN** they see that without sdd-kit, every repo invents the process from scratch (EN wording per design D3)

#### Scenario: Machine-scope tools show install-once Scope line

- **WHEN** the OpenSpec, GitNexus, or Graphify banner renders on a TTY (either language)
- **THEN** it includes a Scope line stating the tool installs once on the machine and is reused by future projects

#### Scenario: Kit banner shows per-repo Scope line

- **WHEN** the sdd-kit banner renders on a TTY (either language)
- **THEN** it includes a Scope line stating the payload is copied into this repo and each project gets its own

### Requirement: Optional add-ons glance after checklist

Immediately after post-install checklist §2.8, the guide MUST include an **Optional add-ons at a glance** block covering UI (C1-UI / §2.11), Probity (G2 / §2.16), CI gates (§2.12), and SDD metrics (G4 / §2.17). The block MUST only point to existing sections/commands. It MUST NOT present an interactive menu, and it MUST NOT instruct automatic installation of those add-ons as part of C1.

#### Scenario: Add-ons appear only after checklist

- **WHEN** an operator completes reading the §2.8 checklist
- **THEN** the next narrative block lists the four optional add-ons with pointers and does not appear before the checklist

#### Scenario: No end-of-C1 menu

- **WHEN** C1 documentation describes finishing the core install
- **THEN** there is no interactive menu requiring the operator to choose add-ons before finishing C1

### Requirement: README explains how the three tools fit

The hub root `README.md` MUST include exactly one short paragraph (or equivalent tight block) titled or clearly about how OpenSpec, GitNexus, and Graphify fit together with `sdd-kit/`, linking to guide §2.1 for the full didactic path.

#### Scenario: Discovery reader sees three-tools fit

- **WHEN** a newcomer reads the hub `README.md` Get started / What’s included area
- **THEN** they find one paragraph explaining intent vs code graph vs knowledge graph plus the kit, without a full duplicate of guide §2

### Requirement: Bootstrap TTY banners and quiet mode

`scripts/bootstrap-sdd.sh` (and the kit template `sdd-kit/templates/scripts/bootstrap-sdd.sh`) MUST emit didactic S-layer banners before major phases (OpenSpec, GitNexus, Graphify, sdd-kit) when stdout is a TTY and `--quiet` is not set. The script MUST accept `--quiet` (and `-q`) to suppress didactic banners. When stdout is not a TTY, didactic banners MUST be suppressed even without `--quiet`. WARN/ERROR messages MUST still be emitted. Banner content MUST follow the archived install-narrative design D3 copy plus the Scope line defined by change `clarify-install-scope-ux`, and MUST NOT change the C1 tool invocation order.

#### Scenario: Interactive TTY shows banners

- **WHEN** an operator runs `bash scripts/bootstrap-sdd.sh` on a TTY without `--quiet`
- **THEN** S-layer banners appear before the major phases and the script still runs OpenSpec then GitNexus then Graphify then install kit

#### Scenario: Quiet suppresses banners

- **WHEN** an operator or agent runs `bash scripts/bootstrap-sdd.sh --quiet`
- **THEN** didactic S-layer banners are not printed and WARN/ERROR lines still appear on failure conditions

#### Scenario: Non-TTY CI has no didactic banners

- **WHEN** bootstrap runs with stdout not connected to a TTY
- **THEN** didactic S-layer banners are omitted without requiring the caller to pass `--quiet`

### Requirement: Post-install optional add-ons teaser

After `sdd-kit/install.sh` finishes its next-steps output (including dry-run “PLAN” completions), it MUST print a short optional add-ons teaser pointing to UI, Probity, CI gates, and metrics guide sections/commands. The teaser MUST NOT invoke optional installers or enable modules. Teaser language MUST follow the resolved `chat_language` when available.

#### Scenario: Install prints teaser without installing optionals

- **WHEN** `bash sdd-kit/install.sh --profile DOCS_SPECS` completes successfully
- **THEN** stdout includes an optional add-ons teaser and the process does not run `install-ui-module.sh` or `install-probity-module.sh`

#### Scenario: Dry-run teaser is informational only

- **WHEN** `bash sdd-kit/install.sh --profile APP --dry-run` completes
- **THEN** any add-ons teaser is clearly informational/PLAN-style and no optional modules are installed

### Requirement: Profile choice is presented in lay language

Every install surface that presents the profile choice (guide §1.6 canonical copy, `install.sh` usage/help output, and agent-driven interactive dialogs) MUST frame it as the question "Will this repository hold application code?" — yes → APP; no, documentation/specs only → DOCS_SPECS — and MUST carry three statements: (1) every profile installs the complete framework (profiles only adjust the AGENTS.md command table and a few stack-specific rule files); (2) the hub's `doc/` and `openspec/` content is ByeByeVibe's own development history — the target project never receives it, never needs it, and creates its own `openspec/` state from day one; (3) the profile question is separate from the language question (three axes per `sdd-language-policy`). Runtime strings MUST be provided in `en` and `pt-BR`, following the existing S-layer banner language mechanism. Agent-driven interactive installs MUST derive dialog option labels and descriptions from this canonical copy rather than improvising from payload tables. The copy MUST NOT use implementation jargon (e.g. "pointer", "verifier", "MANIFEST entries") to describe profile differences.

#### Scenario: Interactive dialog uses canonical copy

- **WHEN** an agent-driven install presents a profile question dialog to the operator
- **THEN** the options are labeled by repository nature (application code vs docs/specs only) and state that the complete framework installs in every profile

#### Scenario: Hub-content statement appears at decision time

- **WHEN** the operator reaches the profile question during an install sourced from the hub
- **THEN** the copy states the hub's specs/docs are ByeByeVibe's own development history and are never copied to the target project

#### Scenario: Profile and language questions stay separate

- **WHEN** the operator answers the profile question with `chat_language` set to pt-BR
- **THEN** the profile copy renders in pt-BR without altering or merging into the three language-axes prompts

#### Scenario: No jargon in profile descriptions

- **WHEN** a lay operator reads any profile option description
- **THEN** no option requires understanding internal terms such as pattern pointers, MANIFEST entries, or verification scripts to make the choice

### Requirement: Bootstrap completion message states per-project state and next-project command

At the end of a successful run, `bootstrap-sdd.sh` MUST print a didactic completion message (TTY-only, suppressed by `--quiet`, like S-layer banners) placed **after** the existing "Done. Manual steps (required)" block — that manual-steps block MUST remain unconditional and unchanged. The completion message states: (a) that this project's durable state now lives in `openspec/`, `graphify-out/`, and `.gitnexus/` inside the project folder and is never shared between projects; and (b) that installing into the next project takes the same single command with a new target path, rendering the script's own resolved source root as the origin (`bash <resolved-source-root>/scripts/bootstrap-sdd.sh <new-target> --profile <PROFILE>`). When the resolved source root carries no `sdd-kit/`, the message MUST instead point to the hub-clone requirement (guide §1.6). Both `en` and `pt-BR` string sets MUST be provided.

#### Scenario: Completion message names per-project state

- **WHEN** `bootstrap-sdd.sh` completes successfully on a TTY without `--quiet`
- **THEN** stdout names `openspec/`, `graphify-out/`, and `.gitnexus/` as this project's own state, after the unconditional manual-steps block

#### Scenario: Completion message teaches the next-project command

- **WHEN** `bootstrap-sdd.sh` completes successfully on a TTY without `--quiet` from a source root containing `sdd-kit/`
- **THEN** stdout shows the next-project command with the resolved source root as origin

#### Scenario: Manual steps block survives quiet mode

- **WHEN** `bootstrap-sdd.sh` completes successfully with `--quiet` or non-TTY stdout
- **THEN** the "Done. Manual steps (required)" block still prints and the didactic completion message does not

