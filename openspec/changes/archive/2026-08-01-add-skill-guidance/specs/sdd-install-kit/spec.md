# sdd-install-kit Specification (delta)

## ADDED Requirements

### Requirement: Kit ships skill-guidance templates dual-surface

The kit MUST ship the skill-guidance text (detection clauses, suggestion message format, archive confidence question, creation hygiene rules) as templates under `sdd-kit/templates/` for both `.claude/` and `.cursor/` surfaces, registered in `sdd-kit/MANIFEST.yaml` with checksums regenerated via `bash sdd-kit/gen-manifest-checksums.sh`.

#### Scenario: Templates registered with checksums

- **WHEN** the skill-guidance templates are added or changed
- **THEN** `sdd-kit/MANIFEST.yaml` lists them for both IDE surfaces and checksums pass verification
