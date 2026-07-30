## ADDED Requirements

### Requirement: Hub workspace infrastructure manifest is English

The file `openspec/infra.md` MUST be written in English as the canonical language of the hub workspace infrastructure manifest (R10). Residual Portuguese prose in this file is FORBIDDEN after the infra substitution wave. Dual-file siblings such as `openspec/infra.en.md` or `openspec/infra-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, brand/tool names, package pins such as `@nizos/probity@1.10.0`, Action SHAs, slash commands, shell/script paths, and HTML comment markers used by `scripts/verify-infra.sh`) MUST remain unaltered aside from intentional non-i18n fixes. Portuguese filler inside marker bodies MAY be translated to English without moving marker tags. Manual-action labels MUST use the English form `[MANUAL ACTION]` (not `[AÇÃO MANUAL]`).

#### Scenario: Hub infra file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/infra.md` after the infra substitution is applied
- **THEN** the script exits 0 (including G-PT on that file)

#### Scenario: No dual-file migration for hub infra

- **WHEN** the infra substitution wave apply completes
- **THEN** English content is at `openspec/infra.md` and no permanent `infra.en.md` / `infra-pt.md` sibling exists

#### Scenario: verify-infra HTML markers preserved

- **WHEN** an agent reads `openspec/infra.md` after substitution
- **THEN** HTML comment marker tags used by `scripts/verify-infra.sh` (including openspec/gitnexus/graphify/kit/mcp/env markers) remain at the same tag names so verification scripts continue to parse the file
