## ADDED Requirements

### Requirement: Kit-scripts wave-1 sdd-upgrade-diff residual-PT scripts are English

The upgrade-diff script paths `scripts/sdd-upgrade-diff.sh` and `sdd-kit/templates/scripts/sdd-upgrade-diff.sh` MUST be written in English after the kit-scripts substitution wave. Residual Portuguese prose in these files is FORBIDDEN after apply, including file-header comments and operator-facing `echo` / stderr messages that previously used Portuguese vocabulary matching the wave deny-list. Dual-file siblings such as `*.en.sh`, `*-pt.sh`, `*.en.md`, or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths including `scripts/sdd-upgrade-diff.sh`, `sdd-kit/templates/scripts/sdd-upgrade-diff.sh`, `sdd-kit/MANIFEST.yaml`, `openspec/project.md`, and `doc/sistema-sdd-pedro.md`; shell identifiers such as `CURATED_FILES`, `CURATED_DESTS`, `CURATED_SOURCES`, `STAGING_DIR`, and `GUIDE_VERSION`; merge strategy label `MERGE`; profile names APP / DOCS_SPECS / HYBRID; slash commands such as `/opsx:*`; fenced shell commands; and brand/tool names including ByeByeVibe) MUST remain unaltered aside from intentional non-i18n fixes. Per-file control flow and the existing hub↔template logic divergence (hub path-only inventory vs template MANIFEST `source:`-aware inventory) MUST keep the same meaning after prose is normalized to glossary-canonical English. When the kit template file is edited, `sdd-kit/MANIFEST.yaml` checksums for that template MUST be regenerated via `bash sdd-kit/gen-manifest-checksums.sh` so kit integrity remains honest.

#### Scenario: Kit-scripts wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files scripts/sdd-upgrade-diff.sh,sdd-kit/templates/scripts/sdd-upgrade-diff.sh` after the kit-scripts substitution is applied (including MANIFEST checksum regeneration)
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on those paths)

#### Scenario: No dual-file migration for kit-scripts wave-1

- **WHEN** the kit-scripts substitution wave apply completes
- **THEN** English content is at `scripts/sdd-upgrade-diff.sh` and `sdd-kit/templates/scripts/sdd-upgrade-diff.sh` and no permanent language-suffixed sibling exists for those paths

#### Scenario: Upgrade-diff contracts remain stable

- **WHEN** an operator runs the hub or template upgrade-diff script after substitution
- **THEN** inventory-without-staging, MANIFEST-present vs built-in fallback listing, staged template comparison behavior, and the hub↔template parser divergence remain equivalent to the pre-wave Portuguese-message scripts while comments and operator-facing messages are English
