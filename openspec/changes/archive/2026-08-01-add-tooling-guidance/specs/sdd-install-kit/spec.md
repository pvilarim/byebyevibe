# sdd-install-kit Specification (delta)

## ADDED Requirements

### Requirement: Kit ships tooling-guidance templates dual-surface

The kit MUST ship the tooling-guidance text (cascade clause, suggestion message format, archive confidence question, signal catalog) as templates under `sdd-kit/templates/` for both `.claude/` and `.cursor/` surfaces, plus the single-copy `doc/tooling-install.md` and the extended `scripts/verify-infra.sh`, all registered in `sdd-kit/MANIFEST.yaml` with checksums regenerated via `bash sdd-kit/gen-manifest-checksums.sh`.

#### Scenario: Templates registered with checksums

- **WHEN** the tooling-guidance templates are added or changed
- **THEN** `sdd-kit/MANIFEST.yaml` lists them (both IDE surfaces where applicable) and checksums pass verification
