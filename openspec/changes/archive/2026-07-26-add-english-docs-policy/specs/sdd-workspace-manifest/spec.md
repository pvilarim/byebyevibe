# sdd-workspace-manifest Specification (delta)

## ADDED Requirements

### Requirement: i18n verification script registered in infrastructure manifest

`openspec/infra.md` MUST include a tabular entry for the documentation-language / i18n verification script (`scripts/verify-i18n-wave.sh`) with status and a "verify with" command (at minimum `test -x scripts/verify-i18n-wave.sh` or `bash scripts/verify-i18n-wave.sh --help`). The entry MUST NOT contain secrets. Agents following R10 MUST treat a ✅ i18n-verify entry as available for direct use during translation waves without reinstalling tooling. The manifest MAY also point to `doc/i18n/` (glossary and wave inventory) as related documentation.

#### Scenario: Agent prepares a translation wave

- **WHEN** an agent begins a `translate-*-wave-N` apply and reads `openspec/infra.md`
- **THEN** it finds `verify-i18n-wave.sh` documented and runs that script rather than inventing ad-hoc language checks

#### Scenario: Help command works when registered as installed

- **WHEN** the infra entry is marked ✅ and the operator runs `bash scripts/verify-i18n-wave.sh --help`
- **THEN** the command exits 0
