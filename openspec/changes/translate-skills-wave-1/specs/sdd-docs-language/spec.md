## ADDED Requirements

### Requirement: correctness-review skill mirrors are English

The logical skill `correctness-review` MUST be written in English at both mirror paths `.cursor/skills/correctness-review/SKILL.md` and `.claude/skills/correctness-review/SKILL.md`. Residual Portuguese prose in either mirror is FORBIDDEN after the skills substitution wave. The two mirrors MUST remain content-equivalent after substitution. Dual-file siblings such as `SKILL.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:apply`, sibling skill names `simplify-review` and `security-reviewer`, finding tags `logic:` / `edge:` / `contract:` / `race:` / `silent:`, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. YAML frontmatter keys MUST keep their structure; human-readable `description` values MUST be English. Chat-language guidance in the skill MUST align with F7 (chat MAY be Portuguese; the versioned skill artifact MUST be English) and MUST NOT hard-require Portuguese-only responses.

#### Scenario: correctness-review mirrors pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files .cursor/skills/correctness-review/SKILL.md,.claude/skills/correctness-review/SKILL.md` after the skills substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MIRROR on those files)

#### Scenario: No dual-file migration for correctness-review

- **WHEN** the skills substitution wave apply completes
- **THEN** English content is at both `.cursor/skills/correctness-review/SKILL.md` and `.claude/skills/correctness-review/SKILL.md` and no permanent `SKILL.en.md` / `*-pt.md` sibling exists for either path

#### Scenario: Mirrors stay content-equivalent

- **WHEN** an agent compares the two correctness-review skill mirrors after substitution
- **THEN** the file contents are identical (`cmp` succeeds) so Cursor and Claude load the same English instructions
