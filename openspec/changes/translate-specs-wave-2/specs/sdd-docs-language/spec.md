## ADDED Requirements

### Requirement: Specs wave-2 residual-PT install-kit capability spec is English

After `translate-specs-wave-2` apply, the capability specification file `openspec/specs/sdd-install-kit/spec.md` MUST be written in canonical English prose (glossary forms from `doc/i18n/GLOSSARY.md`). Dual-file siblings (`*.en.md`, `*-pt.md`, or parallel language trees under `openspec/specs/sdd-install-kit/`) are FORBIDDEN. Freeze-list tokens (paths such as `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `scripts/sdd-metrics.sh`, and `doc/sistema-sdd-pedro.md`; MANIFEST keys `sha256:`, `merge:`, `gate:`, `source:`, `path:`; slash commands such as `/opsx:*`; package pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; and brand/tool names including ByeByeVibe) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of kit install integrity (sha256 abort), path-traversal blocking, upgrade dry-run vs apply mutual exclusion, MERGE vs COPY preservation, backup-before-overwrite, bootstrap HYBRID coexistence WARN (non-fatal), and ByeByeVibe public naming vs on-disk `sdd-kit/` MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Specs wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the install-kit substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs wave-2 substitution apply completes
- **THEN** English content is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** integrity fail-closed on sha256 mismatch, dry-run/apply exclusivity, MERGE preservation for upgrade tooling, non-fatal HYBRID bootstrap WARN, and ByeByeVibe vs `sdd-kit/` naming remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario text is English
