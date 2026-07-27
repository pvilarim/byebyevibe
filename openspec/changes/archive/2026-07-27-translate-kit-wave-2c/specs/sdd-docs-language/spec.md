## ADDED Requirements

### Requirement: Kit Cursor rules install templates (W2c slice) are English

The files `sdd-kit/templates/.cursor/rules/000-base.mdc`, `sdd-kit/templates/.cursor/rules/015-session-phases.mdc`, `sdd-kit/templates/.cursor/rules/016-session-coordination.mdc`, and `sdd-kit/templates/.cursor/rules/010-typescript.mdc` MUST be written in English as the canonical language of those surfaces. Residual Portuguese prose in these files is FORBIDDEN after the W2c substitution wave. Dual-file siblings such as `*.en.mdc` or `*-pt.mdc` MUST NOT be introduced for these paths. Freeze-list tokens (paths, brand/tool names, YAML keys `alwaysApply`/`globs` and glob pattern strings, slash commands such as `/opsx:propose`, shell/script paths, and code identifiers such as `cn` and `Zod`) MUST remain unaltered aside from intentional non-i18n fixes. Human-readable YAML `description` values MUST be English. When any of these template paths under `sdd-kit/templates/` change, MANIFEST checksums MUST be regenerated so `bash sdd-kit/verify.sh` passes (G-MANIFEST).

#### Scenario: W2c file list passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/.cursor/rules/000-base.mdc,sdd-kit/templates/.cursor/rules/015-session-phases.mdc,sdd-kit/templates/.cursor/rules/016-session-coordination.mdc,sdd-kit/templates/.cursor/rules/010-typescript.mdc` after the W2c substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on that file list)

#### Scenario: No dual-file migration for W2c kit Cursor rules

- **WHEN** W2c apply completes
- **THEN** English content is at the four paths listed above and no permanent `*.en.mdc` / `*-pt.mdc` sibling for those paths exists

#### Scenario: YAML globs and alwaysApply preserved

- **WHEN** an agent reads the four W2c kit rule templates after substitution
- **THEN** each file retains its YAML frontmatter keys `alwaysApply` and (where present) `globs` with glob pattern strings unchanged so Cursor rule activation behavior is preserved
