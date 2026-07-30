## ADDED Requirements

### Requirement: Always-apply Cursor rules (W1b slice) are English

The always-apply Cursor rule files `.cursor/rules/000-base.mdc`, `.cursor/rules/015-session-phases.mdc`, `.cursor/rules/016-session-coordination.mdc`, and `.cursor/rules/050-security.mdc` MUST be written in English as the canonical language of those surfaces. Residual Portuguese prose in these files is FORBIDDEN after the W1b substitution wave. Dual-file siblings such as `*.en.mdc` or `*-pt.mdc` MUST NOT be introduced for these paths. Freeze-list tokens (paths, script names, `/opsx:*`, package pins, MANIFEST keys, brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. YAML frontmatter keys and `alwaysApply` values MUST be preserved; human-readable `description` values MUST be English.

#### Scenario: W1b file list passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files .cursor/rules/000-base.mdc,.cursor/rules/015-session-phases.mdc,.cursor/rules/016-session-coordination.mdc,.cursor/rules/050-security.mdc` after the W1b substitution is applied
- **THEN** the script exits 0 (including G-PT on those four files)

#### Scenario: No dual-file migration for W1b rules

- **WHEN** W1b apply completes
- **THEN** English content is at the four `.mdc` paths listed above and no permanent `*.en.mdc` / `*-pt.mdc` sibling for those paths exists

#### Scenario: Freeze-list tokens preserved in security and session rules

- **WHEN** an agent reads `.cursor/rules/050-security.mdc` and `.cursor/rules/016-session-coordination.mdc` after W1b
- **THEN** script paths under `scripts/sdd-session-*.sh`, `OPENSPEC_TELEMETRY=0`, `@fission-ai/openspec@1.3.1`, and `sdd-kit/MANIFEST.yaml` / `gate:` references remain present and unaltered as freeze-list tokens
