# sdd-install-kit Specification (delta)

## ADDED Requirements

### Requirement: install.sh captures language policy before template apply

`sdd-kit/install.sh` MUST resolve `chat_language`, `docs_language`, and `code_language` (per `sdd-language-policy`) before copying `AGENTS.core.md` and other templates. Resolution order: (1) CLI flags `--chat-lang`, `--docs-lang`, `--code-lang` if provided; (2) interactive prompts when stdin is a TTY and flags are absent; (3) defaults `en` for each missing value. Invalid values MUST abort before any COPY merge writes language-bearing files.

#### Scenario: Install aborts on invalid language before copy

- **WHEN** `install.sh --profile APP --docs-lang fr` is run
- **THEN** the script exits non-zero before copying templates and prints an error identifying the invalid locale

#### Scenario: Install proceeds after valid resolution

- **WHEN** `install.sh --profile DOCS_SPECS --chat-lang en --docs-lang en --code-lang en` is run
- **THEN** template copy proceeds and `AGENTS.md` is generated with substituted Communication text

### Requirement: install.sh writes Language policy into project.md

When `openspec/project.md` exists in the target repository, `install.sh` MUST insert or update a `## Language policy` section (using anchored markers `<!-- SDD_LANGUAGE_POLICY_START -->` and `<!-- SDD_LANGUAGE_POLICY_END -->` when merging) recording the three BCP-47-style tags (`en` or `pt-BR`). If `project.md` does not exist yet, the script MUST emit a WARN and document that the operator must add Language policy manually after `openspec init`.

#### Scenario: project.md exists after openspec init

- **WHEN** install runs after `openspec init` and language flags are `pt-BR` / `en` / `en`
- **THEN** `openspec/project.md` contains a Language policy section with those three values between the SDD anchor markers

#### Scenario: project.md missing

- **WHEN** install runs before `openspec init`
- **THEN** install logs a WARN to add Language policy after init and still writes `AGENTS.md` Communication from the resolved languages

### Requirement: verify.sh checks language policy on consumer installs

`sdd-kit/verify.sh` MUST include a check (report or blocking per existing verify conventions) that installed `AGENTS.md` has no unreplaced `{{CHAT_LANG}}` placeholders and that `openspec/project.md` contains `## Language policy` when that file exists.

#### Scenario: Verify passes on complete install

- **WHEN** `bash sdd-kit/verify.sh` runs after a successful language-aware install with existing `project.md`
- **THEN** the language policy check reports OK

#### Scenario: Verify fails on leaked placeholder

- **WHEN** `AGENTS.md` still contains `{{DOCS_LANG}}`
- **THEN** verify reports failure for the language policy check
