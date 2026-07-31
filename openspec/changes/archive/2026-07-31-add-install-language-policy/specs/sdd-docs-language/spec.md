# sdd-docs-language Specification (delta)

## ADDED Requirements

### Requirement: Consumer repos follow configured docs_language

For repositories installed via `sdd-kit/install.sh` after `sdd-language-policy` is adopted, versioned documentation artifacts MUST be written in the configured `docs_language` from `openspec/project.md` (v1: `en` or `pt-BR`). The prior hub rule that all new artifacts MUST be English applies to the **distribution hub** and to any consumer where `docs_language=en`. When `docs_language=pt-BR`, new OpenSpec proposals, designs, specs, and tasks MAY be written in Portuguese; dual-file `*.en.md` / `*-pt.md` siblings remain FORBIDDEN.

#### Scenario: Consumer with docs_language pt-BR

- **WHEN** a consumer repo has `docs_language: pt-BR` in `openspec/project.md` and an agent creates a new change under `openspec/changes/<id>/`
- **THEN** proposal, design, specs, and tasks MAY be authored in Portuguese at the same file paths

#### Scenario: Consumer with docs_language en

- **WHEN** a consumer repo has `docs_language: en` and an agent creates a new change
- **THEN** artifacts MUST be written in English (same as current F7 artifact rule)

### Requirement: Hub EN migration waves remain hub-scoped

PT→EN substitution waves, `doc/i18n/` glossary/inventory, and `scripts/verify-i18n-wave.sh` gates G-PT and G-DoD MUST remain in effect for the **distribution hub** until hub residual Portuguese prose on in-scope surfaces is approximately zero. Consumer repositories with `docs_language=pt-BR` MUST NOT be required to run G-PT or G-DoD unless they voluntarily adopt EN docs and hub-style migration.

#### Scenario: Hub wave still valid after consumer policy

- **WHEN** the distribution hub archives `add-install-language-policy` and continues `translate-*` waves
- **THEN** hub in-scope surfaces remain subject to EN substitution and G-PT per existing `sdd-docs-language` requirements

#### Scenario: Consumer pt-BR docs skip hub G-DoD

- **WHEN** a consumer repo has `docs_language=pt-BR` and no EN migration program
- **THEN** failing `verify-i18n-wave.sh --dod` is not a defect for that consumer solely because Portuguese prose exists in their OpenSpec artifacts

### Requirement: F7 extends to three axes via sdd-language-policy

The F7 distinction (chat language decoupled from versioned repository language) is extended: chat uses `chat_language`; documentation artifacts use `docs_language`; code comments and user-facing strings use `code_language`. `AGENTS.md` Communication and `openspec/project.md` Language policy MUST state all three explicitly after install. Chat language MUST NOT authorize docs or code outside configured axes.

#### Scenario: Three-axis pointers after install

- **WHEN** an agent reads `AGENTS.md` Communication on a consumer repo installed with language policy
- **THEN** it finds explicit values or references for chat, docs, and code languages

## MODIFIED Requirements

### Requirement: Chat may remain Portuguese (F7)

Human↔agent conversation MAY use the configured `chat_language` (`en` or `pt-BR` in v1) for operator speed. Chat language MUST NOT authorize creating or editing versioned documentation in a language other than `docs_language`, or code prose in a language other than `code_language`, after policy adoption. `AGENTS.md` (Communication) and `openspec/project.md` (Language policy) MUST state all three axes explicitly.

#### Scenario: Operator chats in Portuguese

- **WHEN** the operator converses with the agent in pt-BR and `chat_language` is `pt-BR`
- **THEN** the agent may reply in pt-BR in chat while still writing documentation per `docs_language` and code prose per `code_language`

#### Scenario: Pointers document F7 and three axes

- **WHEN** an agent reads `AGENTS.md` Communication or `openspec/project.md` Language policy after install
- **THEN** it finds chat, docs, and code language settings and the rule that chat does not override docs/code policy
