## ADDED Requirements

### Requirement: opsx-apply command mirrors are English

The logical command `opsx-apply` MUST be written in English at both mirror paths `.cursor/commands/opsx-apply.md` and `.claude/commands/opsx/apply.md`. Residual Portuguese prose in either path is FORBIDDEN after the commands substitution wave. Dual-file siblings such as `opsx-apply.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:apply`, `/opsx:archive`, `/opsx:propose`, and `/opsx:explore`, R11 script names `sdd-session-register.sh` / `sdd-session-check.sh` / `sdd-session-release.sh`, fenced shell commands, apply workflow semantics including session coordination, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Platform-specific YAML frontmatter structure MAY differ between Cursor and Claude (keys such as `name`, `id`, `tags`); human-readable `description` values MUST be English. Chat-language and Session Handoff guidance in the command MUST align with F7 (chat MAY be Portuguese; the versioned command artifact MUST be English) and MUST NOT hard-require Portuguese-only responses.

#### Scenario: opsx-apply mirrors pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-apply.md,.claude/commands/opsx/apply.md` after the commands substitution and G-MIRROR peer-map fix are applied
- **THEN** the script exits 0 (including G-PT on those files and G-MIRROR peer listing for the asymmetric opsx command paths)

#### Scenario: No dual-file migration for opsx-apply

- **WHEN** the commands substitution wave apply completes
- **THEN** English content is at both `.cursor/commands/opsx-apply.md` and `.claude/commands/opsx/apply.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for either path

#### Scenario: Platform frontmatter may differ

- **WHEN** an agent compares Cursor and Claude `opsx-apply` command files after substitution
- **THEN** YAML frontmatter MAY differ by IDE while both prose bodies are English and free of residual Portuguese deny-list hits

### Requirement: G-MIRROR understands asymmetric opsx command paths

The per-wave verification script `scripts/verify-i18n-wave.sh` MUST map `.cursor/commands/opsx-<verb>.md` to `.claude/commands/opsx/<verb>.md` (and the reverse) when evaluating G-MIRROR. For those command pairs, G-MIRROR MUST require that both peers are listed in `--files` and that both files exist. G-MIRROR MUST NOT require byte-identical content between Cursor and Claude command files (platform-specific frontmatter is allowed). Skill mirror pairs under `.cursor/skills/` and `.claude/skills/` MUST continue to require content equivalence (`cmp` success).

#### Scenario: opsx-apply peers resolve under G-MIRROR

- **WHEN** `--files` lists `.cursor/commands/opsx-apply.md` and `.claude/commands/opsx/apply.md`
- **THEN** G-MIRROR treats them as peers and does not invent a missing `.claude/commands/opsx-apply.md` path

#### Scenario: Skill mirrors still require content equivalence

- **WHEN** `--files` lists a `.cursor/skills/<name>/SKILL.md` and `.claude/skills/<name>/SKILL.md` pair whose contents differ
- **THEN** G-MIRROR fails (skill `cmp` behavior unchanged)
