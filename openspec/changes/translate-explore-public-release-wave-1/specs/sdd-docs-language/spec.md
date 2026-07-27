## ADDED Requirements

### Requirement: Explore-public-release research wave-1 surface is English

The path `openspec/changes/explore-public-release-surface/research.md` MUST be written in English after the explore-public-release substitution wave. Residual Portuguese prose in this file is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, package pins, URLs, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Explore decision outcomes F1–F7 (do not implement / ready for propose / Adopted / Deferred / Discarded) MUST keep the same meaning after label language is normalized to glossary-canonical English.

#### Scenario: Explore-public-release research passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-public-release-surface/research.md` after the explore-public-release substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for explore-public-release research

- **WHEN** the explore-public-release substitution wave apply completes
- **THEN** English content is at `openspec/changes/explore-public-release-surface/research.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Public-release decision outcomes remain stable

- **WHEN** an agent reads the explore-public-release decision matrix after substitution
- **THEN** F2 remains ready-for-propose (EN-default + substitution waves linked to `add-english-docs-policy`), F7 remains Adopted (chat MAY pt-BR; versioned artifacts MUST be English), and F6 remains Discarded as a privacy strategy via `.gitignore` of specs/docs, while prose and labels are English
