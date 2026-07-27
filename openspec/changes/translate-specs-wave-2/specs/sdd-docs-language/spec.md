## ADDED Requirements

### Requirement: Specs wave-2 sdd-install-kit capability spec is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs substitution wave-2. Residual Portuguese prose in that file is FORBIDDEN after apply, including requirement bodies and scenario WHEN/THEN prose that previously mixed Portuguese with English (upgrade MERGE classification, HYBRID `bootstrap-sdd.sh` WARN, dry-run `COPY` label alignment, dry-run vs APPLY headers, and related scenarios). Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `scripts/sdd-metrics.sh`; merge enum values `COPY` / `MERGE`; profile names APP / DOCS_SPECS / HYBRID; slash commands such as `/opsx:*`; package pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; and brand/tool names including ByeByeVibe) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of install integrity, upgrade dry-run/apply gates, MERGE preserve vs COPY replace, and bootstrap HYBRID WARN behavior MUST keep the same meaning after prose is normalized to glossary-canonical English. The UPGRADE_REPORT approval gate MUST continue to require the approved-checkbox marker that `sdd-kit/upgrade.sh` greps for; the English spec MUST describe that contract by reference to `upgrade.sh` as source of truth and MUST NOT embed legacy Portuguese checkbox substrings that would fail G-PT.

#### Scenario: Specs wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the specs substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs substitution wave-2 apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** sha256 integrity abort behavior, upgrade `--dry-run` / `--apply` mutual exclusion and approval gate (marker SSOT = `upgrade.sh`), MERGE preserve for upgrade tooling, COPY dry-run labeling, and HYBRID bootstrap WARN semantics remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario text is English
