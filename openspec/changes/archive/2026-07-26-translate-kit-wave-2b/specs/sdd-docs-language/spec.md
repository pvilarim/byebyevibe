## ADDED Requirements

### Requirement: Kit CLAUDE and openspec/infra install templates (W2b slice) are English

The files `sdd-kit/templates/CLAUDE.md` and `sdd-kit/templates/openspec/infra.md` MUST be written in English as the canonical language of those surfaces. Residual Portuguese prose in these files is FORBIDDEN after the W2b substitution wave. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, brand/tool names, package pins, shell/CI command fences, and HTML markers used by `scripts/verify-infra.sh` such as `<!-- openspec-version -->` / `<!-- /openspec-version -->`, `<!-- mcp-list -->` / `<!-- /mcp-list -->`, `<!-- env-list -->` / `<!-- /env-list -->`, and kit version/status markers) MUST remain unaltered aside from intentional non-i18n fixes to marker **bodies** that remove Portuguese filler. When either template path under `sdd-kit/templates/` changes, MANIFEST checksums MUST be regenerated so `bash sdd-kit/verify.sh` passes (G-MANIFEST).

#### Scenario: W2b file list passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/CLAUDE.md,sdd-kit/templates/openspec/infra.md` after the W2b substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on that file list)

#### Scenario: No dual-file migration for W2b kit CLAUDE/infra

- **WHEN** W2b apply completes
- **THEN** English content is at the two paths listed above and no permanent `*.en.md` / `*-pt.md` sibling for those paths exists

#### Scenario: verify-infra HTML markers preserved

- **WHEN** an agent reads `sdd-kit/templates/openspec/infra.md` after W2b
- **THEN** the HTML comment marker tags used by `scripts/verify-infra.sh` (including openspec-version, mcp-list, env-list, and kit-version/status pairs) remain present so infra verification injection continues to work
