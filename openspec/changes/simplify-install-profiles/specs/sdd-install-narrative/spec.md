# Delta: sdd-install-narrative — simplify-install-profiles

## ADDED Requirements

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
