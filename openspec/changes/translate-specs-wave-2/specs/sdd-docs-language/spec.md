## ADDED Requirements

### Requirement: Specs wave-2 sdd-install-kit capability spec is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs wave-2 substitution. Residual Portuguese prose in that file is FORBIDDEN after apply, including requirement titles, requirement bodies, and scenario WHEN/THEN prose that previously mixed Portuguese with English. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths under `sdd-kit/` and `scripts/`; MANIFEST keys and `merge:` values; flags `--from` / `--to` / `--dry-run` / `--apply`; profile names APP / DOCS_SPECS / HYBRID; OpenSpec keywords `MUST` / `WHEN` / `THEN`; package pins; fenced shell commands; brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Normative install/upgrade/bootstrap semantics (profile detection, dry-run vs apply, mutual exclusion, backup-before-overwrite, MANIFEST `gate:` non-eval, COPY/MERGE classification) MUST keep the same meaning after prose is normalized to glossary-canonical English.

Because `sdd-kit/upgrade.sh` historically matched the deny-listed Portuguese approval marker `[x] Actualização aprovada` in `UPGRADE_REPORT.md`, apply for this wave MUST migrate that executable contract to a single glossary-canonical English marker (prefer `[x] Update approved`) in **lockstep** across (1) quotes/requirements in `openspec/specs/sdd-install-kit/spec.md` and (2) the scaffold checkbox, `grep` needle, and operator hint in `sdd-kit/upgrade.sh`. Spec and script MUST NOT disagree on the marker string after apply.

#### Scenario: Specs wave-2 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/upgrade.sh` after the specs wave-2 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs wave-2 substitution apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: UPGRADE_REPORT approval marker stays synchronized

- **WHEN** an operator generates `UPGRADE_REPORT.md` via `sdd-kit/upgrade.sh --dry-run` and later runs `--apply` after checking the English approval checkbox
- **THEN** the script accepts the English approval marker documented in `openspec/specs/sdd-install-kit/spec.md`, and the same marker string appears in both the capability spec and `sdd-kit/upgrade.sh` (`grep` / scaffold / hint)

#### Scenario: Install-kit contracts remain stable aside from marker language

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** dry-run vs apply, mutual exclusion of flags, backup-before-overwrite, MANIFEST merge classification, and bootstrap HYBRID coexistence warning behavior remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario text is English
