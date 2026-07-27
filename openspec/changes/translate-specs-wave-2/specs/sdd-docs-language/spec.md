## ADDED Requirements

### Requirement: Specs wave-2 sdd-install-kit residual PT is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs substitution wave-2. Residual Portuguese prose in that file is FORBIDDEN after apply, including requirement titles/bodies and scenario WHEN/THEN prose that previously mixed Portuguese with English. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `UPGRADE_REPORT.md`, and MANIFEST keys such as `merge: COPY` / `merge: MERGE`; slash commands such as `/opsx:*`; package pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; brand/tool names; and the runtime approval marker `[x] Actualização aprovada` checked by `sdd-kit/upgrade.sh`) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of install/upgrade integrity verification, dry-run classification labels, HYBRID bootstrap warnings, flag mutual exclusion, and the UPGRADE_REPORT approval gate MUST keep the same meaning after prose is normalized to glossary-canonical English. If the freeze approval marker alone would fail G-PT, a narrow documented exemption for that exact marker in `scripts/verify-i18n-wave.sh` is ALLOWED; broad Portuguese exemptions are FORBIDDEN.

#### Scenario: Specs wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the specs substitution is applied (and includes `scripts/verify-i18n-wave.sh` in `--files` if that script was edited for the freeze-marker exemption)
- **THEN** the script exits 0 (including G-PT and G-LINK on the listed files)

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs substitution wave-2 apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts and approval marker remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** integrity fail-closed behavior, dry-run `COPY` labeling, HYBRID bootstrap warning semantics, and the UPGRADE_REPORT gate that requires `[x] Actualização aprovada` remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario text is English
