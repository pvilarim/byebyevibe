## ADDED Requirements

### Requirement: Specs wave-2 install-kit capability spec is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs substitution wave. Residual Portuguese prose in this file is FORBIDDEN after apply, including requirement bodies and scenario titles/WHEN/THEN prose that previously mixed Portuguese with English. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths under `sdd-kit/` including `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, and `scripts/sdd-metrics.sh`; MANIFEST keys such as `sha256:`, `merge:`, and `gate:`; profile names APP / DOCS_SPECS / HYBRID; slash commands such as `/opsx:*`; package pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; and brand/tool names including **ByeByeVibe**) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of kit layout, template integrity verification, path-traversal abort, upgrade dry-run versus apply (including mutual exclusion and UPGRADE_REPORT approval), verify post-checks, bootstrap profile warning behavior, and non-eval `gate:` metadata MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Specs wave-2 install-kit file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the specs substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs substitution wave apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** sha256 integrity abort-on-mismatch, upgrade `--dry-run` / `--apply` mutual exclusion and approval gating, dry-run `COPY` labeling (not `APPLY_TEMPLATE`), bootstrap profile warning when `package.json` and `openspec/` coexist, and ByeByeVibe brand versus on-disk `sdd-kit/` path semantics remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario text is English
