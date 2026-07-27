## ADDED Requirements

### Requirement: Specs wave-2 install-kit capability spec is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs substitution wave. Residual Portuguese prose in that file is FORBIDDEN after apply, including requirement titles, requirement bodies, and scenario WHEN/THEN prose that previously mixed Portuguese with English. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, and `UPGRADE_REPORT.md`; MANIFEST keys such as `sha256:`, `merge: COPY`, and `merge: MERGE`; slash commands such as `/opsx:*`; package pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; brand/tool names including ByeByeVibe; and the runtime approval checkbox substring `[x] Actualização aprovada` matched by `sdd-kit/upgrade.sh`) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of greenfield install integrity, upgrade dry-run versus apply gates, MANIFEST merge classification, and bootstrap profile warnings MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Specs wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the install-kit substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file), allowing the documented freeze/allowlist exception for the `Actualização aprovada` approval substring that `upgrade.sh` greps

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs wave-2 substitution apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** sha256 integrity fail-closed behavior, dry-run versus apply mutual exclusion and approval gating (including the frozen `[x] Actualização aprovada` checkbox substring), MERGE preservation of local upgrade-diff tooling, and bootstrap HYBRID coexistence warning semantics remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario text is English
