## ADDED Requirements

### Requirement: opsx-explore command mirrors are English

The logical command `opsx-explore` MUST be written in English at both mirror paths `.cursor/commands/opsx-explore.md` and `.claude/commands/opsx/explore.md`. Residual Portuguese prose in either path is FORBIDDEN after the commands substitution wave. Dual-file siblings such as `opsx-explore.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:explore`, `/opsx:propose`, `/opsx:apply`, and `/opsx:archive`, fenced shell commands, explore workflow semantics including research.md conventions and Session Handoff to `/opsx:propose`, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Platform-specific YAML frontmatter structure MAY differ between Cursor and Claude (keys such as `name`, `id`, `tags`); human-readable `description` values MUST be English. Chat-language and Session Handoff guidance in the command MUST align with F7 (chat MAY be Portuguese; the versioned command artifact MUST be English) and MUST NOT hard-require Portuguese-only responses. This requirement covers the **command** mirrors only and MUST NOT be read as superseding or replacing the separate `openspec-explore` **skill** mirror requirement.

#### Scenario: opsx-explore mirrors pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-explore.md,.claude/commands/opsx/explore.md` after the commands substitution is applied on a base that includes the asymmetric opsx G-MIRROR peer map
- **THEN** the script exits 0 (including G-PT on those files and G-MIRROR peer listing for the asymmetric opsx command paths)

#### Scenario: No dual-file migration for opsx-explore

- **WHEN** the commands substitution wave apply completes
- **THEN** English content is at both `.cursor/commands/opsx-explore.md` and `.claude/commands/opsx/explore.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for either path

#### Scenario: Platform frontmatter may differ

- **WHEN** an agent compares Cursor and Claude `opsx-explore` command files after substitution
- **THEN** YAML frontmatter MAY differ by IDE while both prose bodies are English and free of residual Portuguese deny-list hits
