## ADDED Requirements

### Requirement: Explore-oss research wave-1 surface is English

The path `openspec/changes/explore-oss-coverage-gaps/research.md` MUST be written in English after the explore-oss substitution wave. Residual Portuguese prose in this file is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, package pins, URLs, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Gap recommendation outcomes (add to kit / manual fix / do not add / hybrid / do not adopt now for G1–G8) MUST keep the same meaning after label language is normalized to glossary-canonical English.

#### Scenario: Explore-oss research passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/research.md` after the explore-oss substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for explore-oss research

- **WHEN** the explore-oss substitution wave apply completes
- **THEN** English content is at `openspec/changes/explore-oss-coverage-gaps/research.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Gap recommendation outcomes remain stable

- **WHEN** an agent reads the explore-oss decision matrix after substitution
- **THEN** G2 Probity remains an add-to-kit recommendation (linked to `add-probity-tdd-module`), G3 error-tracking remains do-not-add to kit core, and G6 multi-agent orchestration remains do-not-adopt-now, while prose and labels are English
