## ADDED Requirements

### Requirement: Specs wave-2 sdd-install-kit residual PT is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs wave-2 substitution. Residual Portuguese prose in that file is FORBIDDEN after apply, including requirement titles, requirement bodies, and scenario WHEN/THEN prose that previously mixed Portuguese with English. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `MANIFEST.yaml`, and `UPGRADE_REPORT.md`; MANIFEST `merge:` values `COPY` / `MERGE`; slash commands such as `/opsx:*`; package pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; upgrade header strings `SDD UPGRADE REPORT (dry-run)` and `SDD UPGRADE APPLY`; and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of install/upgrade/bootstrap (dry-run vs apply, MERGE preservation of local upgrade-diff tooling, advisory non-fatal HYBRID profile warning, COPY classify label rather than `APPLY_TEMPLATE`, and approval-gated `--apply`) MUST keep the same meaning after prose is normalized to glossary-canonical English.

Runtime contracts that this capability spec asserts in quoted form MUST use English literals after apply and MUST stay byte-aligned with the implementing scripts: the upgrade approval marker checked by `sdd-kit/upgrade.sh` (English form such as `[x] Upgrade approved`) and the HYBRID coexistence warning emitted by `scripts/bootstrap-sdd.sh` / `sdd-kit/templates/scripts/bootstrap-sdd.sh`. Changing only the spec while leaving Portuguese markers in those scripts is FORBIDDEN.

#### Scenario: Specs wave-2 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/templates/scripts/bootstrap-sdd.sh,scripts/bootstrap-sdd.sh` after the specs wave-2 substitution is applied
- **THEN** the script exits 0 (including G-PT, G-LINK, and G-MANIFEST for the touched bootstrap template)

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs wave-2 apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts remain stable with English literals

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution and inspects `sdd-kit/upgrade.sh` plus bootstrap scripts
- **THEN** MERGE/COPY upgrade behavior, advisory HYBRID bootstrap warning, dry-run vs apply headers, and approval-gated `--apply` remain equivalent to the pre-wave contracts while the capability-spec prose and the asserted marker/WARN literals are English and aligned across spec and scripts
