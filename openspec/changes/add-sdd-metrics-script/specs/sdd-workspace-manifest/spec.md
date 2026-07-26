# sdd-workspace-manifest Specification (delta)

## ADDED Requirements

### Requirement: SDD metrics script registered in infrastructure manifest

`openspec/infra.md` MUST include a tabular entry for the SDD metrics script (`scripts/sdd-metrics.sh`) with status and a "verificar com" command (at minimum `test -x scripts/sdd-metrics.sh` or `bash scripts/sdd-metrics.sh --help`). The entry MUST NOT contain secrets. Agents following R10 MUST treat a ✅ metrics entry as available for direct use without reinstalling tooling.

#### Scenario: Agent reads infra before suggesting DevLake

- **WHEN** an agent considers measuring SDD framework effectiveness
- **THEN** it finds `sdd-metrics.sh` documented in `openspec/infra.md` and uses the local script instead of proposing Apache DevLake installation

#### Scenario: Template parity

- **WHEN** `sdd-kit/templates/openspec/infra.md` is compared for metrics registration
- **THEN** it also documents the metrics script entry for consumer installs
