## ADDED Requirements

### Requirement: Specs wave-2 install-kit capability spec is English

The following capability specification path MUST be written in English after the specs substitution wave: `openspec/specs/sdd-install-kit/spec.md`. Residual Portuguese prose in this file is FORBIDDEN after apply, including requirement titles/bodies and scenario WHEN/THEN prose that previously mixed Portuguese with English. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/`, `scripts/bootstrap-sdd.sh`, `UPGRADE_REPORT.md`, and `MANIFEST.yaml` keys such as `merge:` / `sha256:` / `gate:`; slash commands such as `/opsx:*`; package pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; label tokens `COPY` and `APPLY_TEMPLATE`; and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of install/upgrade/bootstrap (including the UPGRADE_REPORT approval gate enforced by `sdd-kit/upgrade.sh`) MUST keep the same meaning after prose is normalized to glossary-canonical English. The English spec MUST describe that approval gate by reference to the script’s existing match contract and MUST NOT paste legacy Portuguese marker wording that would reintroduce G-PT deny-list tokens.

#### Scenario: Specs wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the install-kit substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs wave-2 substitution apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** upgrade dry-run vs apply, bootstrap hybrid profile warning, dry-run `COPY` labeling, and UPGRADE_REPORT approval-gate behavior remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario text is English
