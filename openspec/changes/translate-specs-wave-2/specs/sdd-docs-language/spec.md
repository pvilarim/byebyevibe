## ADDED Requirements

### Requirement: Specs wave-2 sdd-install-kit capability spec is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs wave-2 substitution. Residual Portuguese prose in Purpose text, requirement titles/bodies, and scenario WHEN/THEN prose is FORBIDDEN after apply, except for freeze-list **contract literals** that scripts match or emit and that MUST remain byte-stable: the UPGRADE_REPORT approval checkbox string `[x] Actualização aprovada`, and the bootstrap stderr string `WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID.` Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `UPGRADE_REPORT.md`, and `doc/sistema-sdd-pedro.md`; MANIFEST keys `sha256:` / `merge:` / `gate:`; profile names APP / DOCS_SPECS / HYBRID; slash commands such as `/opsx:*`; package pins; fenced shell commands; documented English output labels such as `COPY`, `APPLY_TEMPLATE`, `SDD UPGRADE REPORT (dry-run)`, and `SDD UPGRADE APPLY`; OpenSpec keywords `MUST` / `WHEN` / `THEN`; and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of install/upgrade integrity checks, dry-run vs apply, UPGRADE_REPORT approval gating, MERGE preservation of local upgrade tools, mutual exclusion of `--dry-run`/`--apply`, and informational HYBRID bootstrap WARN behavior MUST keep the same meaning after surrounding prose is normalized to glossary-canonical English.

#### Scenario: Specs wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the specs wave-2 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file), treating frozen contract literals as allowlisted when documented by the wave

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs wave-2 substitution apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** integrity fail-closed vs warn-if-absent sha256 behavior, dry-run scaffold vs apply gating on `[x] Actualização aprovada`, MERGE preservation of `scripts/sdd-upgrade-diff.sh`, classify label `COPY` (not `APPLY_TEMPLATE`), and informational HYBRID coexistence WARN semantics remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario text is English
