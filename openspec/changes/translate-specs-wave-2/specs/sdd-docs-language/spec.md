## ADDED Requirements

### Requirement: Specs wave-2 sdd-install-kit surface is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs wave-2 substitution. Residual Portuguese prose in that file is FORBIDDEN after apply, including Purpose text (if any), requirement titles/bodies, and scenario WHEN/THEN prose that previously mixed Portuguese with English. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `scripts/bootstrap-sdd.sh`, and `UPGRADE_REPORT.md`; MANIFEST keys `sha256:`, `merge:`, `gate:`; profile labels APP / DOCS_SPECS / HYBRID; slash commands such as `/opsx:*`; package pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes.

When this wave updates operator-facing executable contract strings, the English forms MUST stay synchronized across the spec and the implementing scripts in the same apply:

- `sdd-kit/upgrade.sh` UPGRADE_REPORT approval checkbox / gate MUST use the English needle `Upgrade approved` (scaffold line MAY read `Upgrade approved by the user`; `grep` for `--apply` MUST match `\[x\] Upgrade approved`).
- `sdd-kit/templates/scripts/bootstrap-sdd.sh` HYBRID coexistence warning MUST use the English stderr marker `WARN: package.json and openspec/ coexist — profile may be HYBRID.` (follow-on confirmation lines MUST be English; default-to-APP behavior MUST remain).

Normative semantics of install/upgrade integrity (sha256 warn-if-absent / fail-if-mismatch), dry-run vs apply mutual exclusion, MERGE vs COPY classification, path-traversal blocking, and UPGRADE_REPORT approval gating MUST keep the same meaning after prose and those operator-facing strings are normalized to glossary-canonical English. Touching `sdd-kit/templates/scripts/bootstrap-sdd.sh` MUST be followed by regenerating `sdd-kit/MANIFEST.yaml` checksums via `bash sdd-kit/gen-manifest-checksums.sh` so G-MANIFEST / kit verify remain green.

#### Scenario: Specs wave-2 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/upgrade.sh,sdd-kit/templates/scripts/bootstrap-sdd.sh` after the wave-2 substitution is applied
- **THEN** the script exits 0 (including G-PT, G-LINK, and G-MANIFEST for the touched kit template)

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs wave-2 substitution apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts remain stable with EN operator strings

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` and the coordinated script strings after substitution
- **THEN** sha256 integrity policy, dry-run vs apply gating, MERGE/COPY labeling, path-traversal blocking, and UPGRADE_REPORT approval gating remain equivalent to the pre-wave contracts while surrounding requirement/scenario text is English and the approval / HYBRID WARN needles match the implementing scripts
