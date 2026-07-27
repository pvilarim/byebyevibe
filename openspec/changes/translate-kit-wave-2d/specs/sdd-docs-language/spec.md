## ADDED Requirements

### Requirement: Kit Cursor rules residual and proposal scaffold (W2d slice) are English

The files `sdd-kit/templates/.cursor/rules/020-python.mdc`, `sdd-kit/templates/.cursor/rules/030-supabase.mdc`, `sdd-kit/templates/.cursor/rules/050-security.mdc`, and `sdd-kit/templates/openspec/changes/_template/proposal.md` MUST be written in English as the canonical language of those surfaces. Residual Portuguese prose in these files is FORBIDDEN after the W2d substitution wave. Dual-file siblings such as `*.en.mdc`, `*-pt.mdc`, or `proposal.en.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, brand/tool names, YAML keys `alwaysApply`/`globs` and glob pattern strings, package pins such as `@fission-ai/openspec@1.3.1`, shell/env tokens such as `OPENSPEC_TELEMETRY`, MANIFEST key `gate:`, security identifiers such as `F-SEC-5`/`F-SEC-3`, and code identifiers such as `Zod`, `asyncio`, `Pydantic`, `structlog`, `pytest-asyncio`, and `ivfflat`) MUST remain unaltered aside from intentional non-i18n fixes. Human-readable YAML `description` values MUST be English. The proposal scaffold MUST use English placeholder prompts (FILL IN pattern) rather than Portuguese filler labels. When any of these template paths under `sdd-kit/templates/` change, MANIFEST checksums MUST be regenerated so `bash sdd-kit/verify.sh` passes (G-MANIFEST).

#### Scenario: W2d file list passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/.cursor/rules/020-python.mdc,sdd-kit/templates/.cursor/rules/030-supabase.mdc,sdd-kit/templates/.cursor/rules/050-security.mdc,sdd-kit/templates/openspec/changes/_template/proposal.md` after the W2d substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on that file list)

#### Scenario: No dual-file migration for W2d kit residual rules and proposal scaffold

- **WHEN** W2d apply completes
- **THEN** English content is at the four paths listed above and no permanent `*.en.mdc` / `*-pt.mdc` / `proposal.en.md` sibling for those paths exists

#### Scenario: YAML globs and alwaysApply preserved on W2d kit rules

- **WHEN** an agent reads the three W2d kit rule templates after substitution
- **THEN** each file retains its YAML frontmatter keys `alwaysApply` and (where present) `globs` with glob pattern strings unchanged so Cursor rule activation behavior is preserved

#### Scenario: Proposal scaffold uses English FILL IN placeholders

- **WHEN** an agent reads `sdd-kit/templates/openspec/changes/_template/proposal.md` after W2d substitution
- **THEN** placeholder prompts are English FILL IN forms (no Portuguese `PREENCHER` / `Ficheiros` labels) and section structure remains compatible with `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`
