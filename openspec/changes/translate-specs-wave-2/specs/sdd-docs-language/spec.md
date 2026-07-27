## ADDED Requirements

### Requirement: Specs wave-2 sdd-install-kit residual PT is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs substitution wave-2 apply. Residual Portuguese prose in Purpose text, requirement bodies, requirement titles, and scenario WHEN/THEN prose is FORBIDDEN after apply, except for documented freeze-list / script-contract tokens that `sdd-kit/upgrade.sh` (or related kit scaffolds) match literally — in particular the approval checkbox marker `[x] Actualização aprovada`. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/install.sh`, `sdd-kit/upgrade.sh`, `sdd-kit/MANIFEST.yaml`, `sdd-kit/verify.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, and `doc/sistema-sdd-pedro.md`; MANIFEST keys such as `merge: COPY`, `merge: MERGE`, `sha256:`, and `gate:`; profile names APP / DOCS_SPECS / HYBRID; slash commands such as `/opsx:*`; package pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of install, upgrade dry-run vs apply, MANIFEST merge classification, path-traversal blocking, and bootstrap HYBRID warnings MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Specs wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the specs wave-2 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file), or G-PT fails only on the documented frozen approval marker substring and the apply PR records that allowlist exception without changing `sdd-kit/upgrade.sh`

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs wave-2 substitution apply completes
- **THEN** English content (aside from freeze-list tokens) is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts and approval marker remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** install/upgrade/bootstrap/MANIFEST contracts remain equivalent to the pre-wave Portuguese/mixed prose, surrounding requirement and scenario text is English, and the literal substring `[x] Actualização aprovada` remains present so `sdd-kit/upgrade.sh --apply` approval gating stays intact
