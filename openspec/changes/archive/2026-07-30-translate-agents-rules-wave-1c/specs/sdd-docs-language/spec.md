## ADDED Requirements

### Requirement: Stack-scoped Cursor rules (W1c slice) are English

The Cursor rule files `.cursor/rules/010-typescript.mdc`, `.cursor/rules/020-python.mdc`, `.cursor/rules/030-supabase.mdc`, and `.cursor/rules/graphify.mdc` MUST be written in English as the canonical language of those surfaces. Residual Portuguese prose in these files is FORBIDDEN after the W1c substitution wave. Dual-file siblings such as `*.en.mdc` or `*-pt.mdc` MUST NOT be introduced for these paths. Freeze-list tokens (paths, globs, YAML keys `alwaysApply`/`globs`, code identifiers including `cn`, `Zod`, `RLS`, `ivfflat`, `structlog`, `pytest-asyncio`, brand/tool names, and shell command text such as `graphify update .`) MUST remain unaltered aside from intentional non-i18n fixes. YAML frontmatter keys, `alwaysApply` values, and glob pattern strings MUST be preserved; human-readable `description` values MUST be English.

#### Scenario: W1c file list passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files .cursor/rules/010-typescript.mdc,.cursor/rules/020-python.mdc,.cursor/rules/030-supabase.mdc,.cursor/rules/graphify.mdc` after the W1c substitution is applied
- **THEN** the script exits 0 (including G-PT on those four files)

#### Scenario: No dual-file migration for W1c rules

- **WHEN** W1c apply completes
- **THEN** English content is at the four `.mdc` paths listed above and no permanent `*.en.mdc` / `*-pt.mdc` sibling for those paths exists

#### Scenario: Freeze-list stack identifiers preserved in W1c rules

- **WHEN** an agent reads `.cursor/rules/010-typescript.mdc`, `.cursor/rules/020-python.mdc`, and `.cursor/rules/030-supabase.mdc` after W1c
- **THEN** identifiers `cn`, `Zod`, `RLS`, `ivfflat`, `structlog`, and `pytest-asyncio` remain present and unaltered as freeze-list tokens, and YAML `globs` / `alwaysApply` structure remains intact
