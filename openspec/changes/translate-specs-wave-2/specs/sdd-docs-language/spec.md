## ADDED Requirements

### Requirement: Specs wave-2 sdd-install-kit capability spec is English

The following capability specification path MUST be written in English after the specs substitution wave: `openspec/specs/sdd-install-kit/spec.md`. Residual Portuguese prose in this file is FORBIDDEN after apply, including requirement titles/bodies and scenario WHEN/THEN prose that previously mixed Portuguese with English. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/`, `MANIFEST.yaml`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `UPGRADE_REPORT.md`, and `doc/sistema-sdd-pedro.md`; MANIFEST keys such as `sha256:`, `merge:`, and `gate:`; slash commands such as `/opsx:*`; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; profile labels APP / DOCS_SPECS / HYBRID; and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of versioned install/upgrade/verify, MERGE vs COPY classification, HYBRID bootstrap WARN-continue behavior, and dry-run vs APPLY header labels MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Specs wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the specs substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs substitution wave apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** versioned kit layout, MANIFEST checksum/MERGE rules, upgrade dry-run approval gate, HYBRID bootstrap WARN-continue, and COPY vs APPLY_TEMPLATE label alignment remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario text is English
