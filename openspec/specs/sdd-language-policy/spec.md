# sdd-language-policy Specification

## Purpose

Normative requirements for three independent language axes (`chat_language`, `docs_language`, `code_language`) configured at SDD C1 install, persisted in `openspec/project.md` and `AGENTS.md`, with v1 locale allowlist and hub grandfather clause.

## Requirements

### Requirement: Three language axes are configured at install

The SDD install flow MUST capture three independent language settings before or during `sdd-kit/install.sh` template application:

1. **`chat_language`** — language for human↔agent conversation (ephemeral; instructs agent replies only).
2. **`docs_language`** — language for versioned documentation artifacts: OpenSpec proposals, designs, specs, tasks, skills prose, rules prose, and project `doc/` content created after install.
3. **`code_language`** — language for source comments, user-facing strings, and error messages in application code; code identifiers (variables, functions, types) MUST remain English/ASCII regardless of this setting.

Each axis MUST be persisted in `openspec/project.md` under a `## Language policy` section and reflected in `AGENTS.md` under `## Communication`. Chat language MUST NOT authorize writing docs or code in a language other than the configured `docs_language` or `code_language`.

#### Scenario: Fresh C1 install captures three languages

- **WHEN** an operator runs `bash sdd-kit/install.sh --profile APP` on a new repository and selects chat `pt-BR`, docs `en`, code `en`
- **THEN** `openspec/project.md` contains a Language policy table with those three values and `AGENTS.md` Communication instructs the agent accordingly

#### Scenario: Chat language does not override docs language

- **WHEN** `chat_language` is `pt-BR` and `docs_language` is `en`
- **THEN** the agent MAY reply in pt-BR in chat while MUST write new OpenSpec artifacts in English

### Requirement: v1 allowed values are en and pt-BR only

In v1 of this capability, each of `chat_language`, `docs_language`, and `code_language` MUST be exactly `en` or `pt-BR`. The install script MUST reject any other value with a non-zero exit and a human-readable error. Future locale expansion is out of scope for v1.

#### Scenario: Invalid locale rejected

- **WHEN** an operator passes `--docs-lang es` to `install.sh`
- **THEN** the script exits non-zero and does not write language policy files

#### Scenario: Valid locales accepted

- **WHEN** an operator passes `--chat-lang pt-BR --docs-lang en --code-lang en`
- **THEN** the script accepts all three and proceeds with template substitution

### Requirement: Defaults are en for all three axes

When the operator skips prompts (presses Enter at each default) or omits all language flags, `chat_language`, `docs_language`, and `code_language` MUST each default to `en`. The install output MUST log that defaults were applied.

#### Scenario: No flags and default answers

- **WHEN** `install.sh` runs non-interactively with no `--*-lang` flags
- **THEN** all three axes are set to `en` in `openspec/project.md` and `AGENTS.md`

#### Scenario: Dry-run shows planned defaults

- **WHEN** `install.sh --dry-run` runs without language flags
- **THEN** planned output includes `chat=en docs=en code=en` (or equivalent explicit defaults)

### Requirement: Non-interactive install via flags

`sdd-kit/install.sh` MUST accept optional flags `--chat-lang`, `--docs-lang`, and `--code-lang`, each taking `en` or `pt-BR`. When all three flags are provided, the script MUST NOT require a TTY prompt. Flags MUST be validated before any template file is copied.

#### Scenario: CI or agent install with flags

- **WHEN** `bash sdd-kit/install.sh --profile DOCS_SPECS --chat-lang pt-BR --docs-lang en --code-lang en` runs in a non-TTY environment
- **THEN** install completes without prompting and language policy is written

### Requirement: AGENTS.md Communication is generated from policy

`sdd-kit/templates/AGENTS.core.md` MUST use replaceable placeholders for the three language values and a normative Communication block stating chat vs docs vs code scopes. After install, installed `AGENTS.md` MUST NOT contain unreplaced placeholders such as `{{CHAT_LANG}}`.

#### Scenario: Placeholders substituted

- **WHEN** install completes with `chat_language=pt-BR`, `docs_language=en`, `code_language=en`
- **THEN** `AGENTS.md` contains `pt-BR` and `en` in the Communication section and contains no `{{CHAT_LANG}}`, `{{DOCS_LANG}}`, or `{{CODE_LANG}}` tokens

### Requirement: Hub distribution repo is grandfathered

The SDD distribution hub repository (source of `sdd-kit/` and `doc/sistema-sdd-pedro.md`) MAY retain its existing language setup without re-running install prompts. The hub's effective policy remains: chat per operator preference (currently pt-BR in practice), `docs_language=en`, `code_language=en`, with `sdd-docs-language` PT→EN migration waves continuing on hub surfaces. This change MUST NOT require modifying the hub's committed `AGENTS.md` or `openspec/project.md` as part of apply.

#### Scenario: Hub apply does not force re-prompt

- **WHEN** this change is applied and archived on the distribution hub
- **THEN** existing hub `AGENTS.md` Communication and `openspec/project.md` Conventions remain valid without mandatory regeneration from `install.sh`

### Requirement: Guide documents language setup

`doc/sistema-sdd-pedro.md` MUST include an install subsection (§2.1.1 or equivalent) explaining the three language axes, v1 allowlist, defaults, flags, and persistence locations. Post-install checklist §2.8 MUST include a verifiable item that Language policy exists in `openspec/project.md` and Communication in `AGENTS.md`.

#### Scenario: Operator reads install guide

- **WHEN** an operator opens the canonical guide before C1 install
- **THEN** they find explicit documentation of chat vs docs vs code language choices and default `en/en/en`
