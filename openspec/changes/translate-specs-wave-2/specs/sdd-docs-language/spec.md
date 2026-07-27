## ADDED Requirements

### Requirement: Specs wave-2 sdd-install-kit capability spec is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs substitution wave. Residual Portuguese prose in that file is FORBIDDEN after apply, including requirement bodies and scenario WHEN/THEN prose that previously mixed Portuguese with English. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/`, `scripts/bootstrap-sdd.sh`, `UPGRADE_REPORT.md`, and MANIFEST keys such as `merge: COPY` / `merge: MERGE`; slash commands such as `/opsx:*`; package pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. The runtime approval checkbox substring hardcoded in `sdd-kit/upgrade.sh` MUST remain unchanged by this language wave; the migrated capability spec MUST describe that `--apply` guard by reference to the script rather than by pasting deny-listed Portuguese tokens into the English prose. Normative semantics of HYBRID ambiguous-repo bootstrap warning, dry-run `COPY` labeling (not `APPLY_TEMPLATE`), and `--apply` rejection of unapproved `UPGRADE_REPORT.md` MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Specs wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the specs substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs substitution wave apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit upgrade/bootstrap contracts remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** HYBRID bootstrap warning vs no-warning behavior, dry-run `COPY` label semantics, and `--apply` approval-guard behavior (matching the unchanged `sdd-kit/upgrade.sh` checkbox substring) remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario text is English
