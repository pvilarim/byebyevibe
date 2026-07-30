## ADDED Requirements

### Requirement: Specs wave-2 sdd-install-kit residual-PT capability spec is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs substitution wave. Residual Portuguese prose in this file is FORBIDDEN after apply, including requirement titles/bodies and scenario WHEN/THEN prose that previously mixed Portuguese with English. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `scripts/sdd-metrics.sh`, and `UPGRADE_REPORT.md`; merge strategy labels `COPY` / `MERGE`; profile names APP / DOCS_SPECS / HYBRID; slash commands such as `/opsx:*`; package pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; and brand/tool names including ByeByeVibe) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of install/upgrade/verify, MERGE vs COPY, bootstrap HYBRID warning behavior, dry-run vs apply headers, flag mutual exclusion, backup-before-overwrite, and the UPGRADE_REPORT approval gate (as implemented by `sdd-kit/upgrade.sh`) MUST keep the same meaning after prose is normalized to glossary-canonical English. The exact UPGRADE_REPORT approval checkbox string grepped by `sdd-kit/upgrade.sh` remains defined by that script; the English capability spec MUST cross-reference that contract without requiring a concurrent rename of the runtime string in this language-only wave.

#### Scenario: Specs wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the specs substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs substitution wave apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** install/upgrade/verify entry points, MERGE preservation of local upgrade tools, COPY dry-run labeling, bootstrap HYBRID warning when `package.json` and `openspec/` coexist, dry-run vs apply header strings, and the UPGRADE_REPORT approval gate enforced by `sdd-kit/upgrade.sh` remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario text is English
