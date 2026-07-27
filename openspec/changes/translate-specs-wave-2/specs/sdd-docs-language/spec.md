## ADDED Requirements

### Requirement: Specs wave-2 sdd-install-kit capability spec is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs substitution wave-2. Residual Portuguese prose in that file is FORBIDDEN after apply, including requirement titles, requirement bodies, and scenario WHEN/THEN prose that previously mixed Portuguese with English. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `MANIFEST.yaml`, and `UPGRADE_REPORT.md`; flags `--from` / `--to` / `--dry-run` / `--apply`; MANIFEST keys such as `merge: COPY`, `merge: MERGE`, `sha256:`, and documentary `gate:`; package pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; profile names APP / DOCS_SPECS / HYBRID; dry-run label tokens `COPY` and `APPLY_TEMPLATE`; and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of deterministic install/upgrade, non-fatal HYBRID ambiguous-repo bootstrap warning, COPY dry-run labeling, mutual exclusion of `--dry-run` and `--apply`, backup-before-overwrite, and the UPGRADE_REPORT approval gate MUST keep the same meaning after prose is normalized to glossary-canonical English. When documenting runtime strings that still contain Portuguese inside kit scripts (notably the UPGRADE_REPORT approval checkbox grepped by `sdd-kit/upgrade.sh`), the English spec MUST reference the script implementation rather than pasting G-PT deny-list tokens into the migrated document; renaming those script literals is OUT OF SCOPE for this language wave.

#### Scenario: Specs wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the specs substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs substitution wave-2 apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** install/upgrade dry-run vs apply gates, HYBRID warning behavior, COPY labeling, backup-before-overwrite, and UPGRADE_REPORT approval checking (as implemented in `sdd-kit/upgrade.sh`) remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario text is English
