## ADDED Requirements

### Requirement: opsx-archive command mirrors are English

The logical command `opsx-archive` MUST be written in English at both mirror paths `.cursor/commands/opsx-archive.md` and `.claude/commands/opsx/archive.md`. Residual Portuguese prose in either path is FORBIDDEN after the commands substitution wave. Dual-file siblings such as `opsx-archive.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:archive`, `/opsx:explore`, `/opsx:propose`, and `/opsx:apply`, fenced shell commands, archive workflow semantics including sync assessment and `.openspec.yaml` preservation, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Platform-specific YAML frontmatter structure MAY differ between Cursor and Claude (keys such as `name`, `id`, `tags`); human-readable `description` values MUST be English. Chat-language and Session Handoff guidance in the command MUST align with F7 (chat MAY be Portuguese; the versioned command artifact MUST be English) and MUST NOT hard-require Portuguese-only responses.

#### Scenario: opsx-archive mirrors pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-archive.md,.claude/commands/opsx/archive.md` after the commands substitution is applied on a base that includes the asymmetric opsx G-MIRROR peer map
- **THEN** the script exits 0 (including G-PT on those files and G-MIRROR peer listing for the asymmetric opsx command paths)

#### Scenario: No dual-file migration for opsx-archive

- **WHEN** the commands substitution wave apply completes
- **THEN** English content is at both `.cursor/commands/opsx-archive.md` and `.claude/commands/opsx/archive.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for either path

#### Scenario: Platform frontmatter may differ

- **WHEN** an agent compares Cursor and Claude `opsx-archive` command files after substitution
- **THEN** YAML frontmatter MAY differ by IDE while both prose bodies are English and free of residual Portuguese deny-list hits
