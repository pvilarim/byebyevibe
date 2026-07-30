## ADDED Requirements

### Requirement: Agent entry-point documents are English

`AGENTS.md`, `CLAUDE.md`, and `openspec/project.md` MUST be written in English as the canonical language of those surfaces. Residual Portuguese prose in these files is FORBIDDEN after the W1 substitution wave. Dual-file siblings such as `AGENTS.en.md` or `*-pt.md` MUST NOT be introduced for these paths. The F7 distinction (human↔agent chat MAY use pt-BR; versioned artifacts MUST be English) MUST remain stated explicitly in `AGENTS.md` (Communication section) and `openspec/project.md` (Conventions).

#### Scenario: W1 file list passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files AGENTS.md,openspec/project.md,CLAUDE.md` after the W1 substitution is applied
- **THEN** the script exits 0 (including G-PT on those three files)

#### Scenario: F7 remains explicit after substitution

- **WHEN** an agent reads `AGENTS.md` Communication and `openspec/project.md` Conventions after W1
- **THEN** both files state that chat MAY be pt-BR and versioned artifacts MUST be English

#### Scenario: No dual-file migration for entry points

- **WHEN** W1 apply completes
- **THEN** English content is at `AGENTS.md`, `CLAUDE.md`, and `openspec/project.md` and no permanent `*.en.md` / `*-pt.md` sibling for those paths exists
