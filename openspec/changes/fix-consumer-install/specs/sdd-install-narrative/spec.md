# Delta — sdd-install-narrative

## MODIFIED Requirements

### Requirement: Profile choice is presented in lay language

Every install surface that presents the profile choice (guide §1.6 canonical copy, `install.sh` usage/help output, and agent-driven interactive dialogs) MUST frame it as the question "Will this repository hold application code?" — yes → APP; no, documentation/specs only → DOCS_SPECS — and MUST carry three statements: (1) every profile installs the complete framework (profiles only adjust the AGENTS.md command table and a few stack-specific rule files); (2) the hub's `openspec/` specs and development history are ByeByeVibe's own — the target project never receives them and creates its own `openspec/` state from day one — while the **operator guide (`doc/byebyevibe-guide.md`) is delivered to every install**; this wording reverts the 2026-08-05 "never receives it, never needs it" decision for the guide specifically and restores the kit's founding design (2026-06-17), and the copy MUST NOT claim the target never receives the guide; (3) the profile question is separate from the language question (three axes per `sdd-language-policy`). Runtime strings MUST be provided in `en` and `pt-BR`, following the existing S-layer banner language mechanism. Agent-driven interactive installs MUST derive dialog option labels and descriptions from this canonical copy rather than improvising from payload tables. The copy MUST NOT use implementation jargon (e.g. "pointer", "verifier", "MANIFEST entries") to describe profile differences.

#### Scenario: Interactive dialog uses canonical copy

- **WHEN** an agent-driven install presents a profile question dialog to the operator
- **THEN** the options are labeled by repository nature (application code vs docs/specs only) and state that the complete framework installs in every profile

#### Scenario: Hub-content statement appears at decision time

- **WHEN** the operator reaches the profile question during an install sourced from the hub
- **THEN** the copy states the hub's specs/development history are never copied to the target project, and states that the operator guide is delivered

#### Scenario: Profile and language questions stay separate

- **WHEN** the operator answers the profile question with `chat_language` set to pt-BR
- **THEN** the profile copy renders in pt-BR without altering or merging into the three language-axes prompts

#### Scenario: No jargon in profile descriptions

- **WHEN** a lay operator reads any profile option description
- **THEN** no option requires understanding internal terms such as pattern pointers, MANIFEST entries, or verification scripts to make the choice

### Requirement: Post-install optional add-ons teaser

After `sdd-kit/install.sh` finishes its next-steps output (including dry-run "PLAN" completions), it MUST print a short optional add-ons teaser. For each optional module (UI, Probity, Metrics) the teaser MUST follow the lay decision formula — "if you need X, install Y, and get Z" followed by an explicit "skip if…" condition — instead of module names, siglas, and bare guide-section pointers. CI gates MUST be presented as a manual GitHub step (branch protection), never as an installable module, and when the repository has no git remote the teaser MUST say the gates are inert until a GitHub remote exists. The teaser MUST NOT invoke optional installers or enable modules. Teaser language MUST follow the resolved `chat_language` when available. Guide pointers in the teaser MUST resolve to a file delivered by the install.

#### Scenario: Install prints teaser without installing optionals

- **WHEN** `bash sdd-kit/install.sh --profile DOCS_SPECS` completes successfully
- **THEN** stdout includes an optional add-ons teaser in the lay formula and the process does not run `install-ui-module.sh` or `install-probity-module.sh`

#### Scenario: Dry-run teaser is informational only

- **WHEN** `bash sdd-kit/install.sh --profile APP --dry-run` completes
- **THEN** any add-ons teaser is clearly informational/PLAN-style and no optional modules are installed

#### Scenario: Each module states its skip condition

- **WHEN** the teaser is printed after a successful install
- **THEN** every module line pairs what the operator gains with an explicit "skip if…" condition a lay reader can evaluate
