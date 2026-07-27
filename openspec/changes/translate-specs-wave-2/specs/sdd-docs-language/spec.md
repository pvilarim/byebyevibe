## ADDED Requirements

### Requirement: Specs wave-2 sdd-install-kit capability spec is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs wave-2 substitution. Residual Portuguese prose in this file is FORBIDDEN after apply, including requirement titles, requirement bodies, and scenario WHEN/THEN prose that previously mixed Portuguese with English — except for the documented freeze/allowlist runtime approval marker `[x] Actualização aprovada` (exact substring checked by `sdd-kit/upgrade.sh`), which MUST remain byte-stable. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `UPGRADE_REPORT.md`, and `doc/sistema-sdd-pedro.md`; MANIFEST keys `merge:`, `sha256:`, and `gate:`; slash commands such as `/opsx:*`; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of kit integrity verification, upgrade dry-run/`--apply` gates, bootstrap HYBRID warning (non-fatal), and COPY vs APPLY_TEMPLATE dry-run labels MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Specs wave-2 install-kit file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the specs wave-2 substitution is applied
- **THEN** the script exits 0 for G-INV, G-GLOSS, G-LINK, and G-OPENSPEC, and G-PT either passes or fails solely on the documented freeze/allowlist marker `[x] Actualização aprovada` (in which case apply documents the allowlist exception and MUST NOT rename the runtime marker in this wave)

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs wave-2 substitution apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts and approval marker remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** sha256 integrity abort semantics, bootstrap HYBRID warning non-fatal behavior, COPY dry-run labeling, and the exact approval marker substring `[x] Actualização aprovada` remain equivalent to the pre-wave contracts while surrounding requirement and scenario text is English
