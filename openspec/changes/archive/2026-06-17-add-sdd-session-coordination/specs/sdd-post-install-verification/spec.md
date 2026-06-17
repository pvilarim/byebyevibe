# sdd-post-install-verification — Delta

## ADDED Requirements

### Requirement: Session coordination present after install

Após instalação SDD, os scripts `scripts/sdd-session-check.sh` e `scripts/sdd-session-status.sh` MUST existir e ser executáveis; `.cursor/rules/016-session-coordination.mdc` MUST existir (alwaysApply); `.sdd/runtime/` MUST estar no `.gitignore`.

#### Scenario: Session scripts on checklist

- **WHEN** o operador executa o checklist §2.8
- **THEN** `bash scripts/sdd-session-status.sh` completa sem erro
- **AND** `016-session-coordination.mdc` está presente

#### Scenario: Infra manifest lists session coordination

- **WHEN** o operador lê `openspec/infra.md` após instalação
- **THEN** existe secção Session Coordination com os scripts listados

## MODIFIED Requirements

### Requirement: Session handoff rules present after install

Após instalação SDD, `.cursor/rules/015-session-phases.mdc` MUST existir e as skills `/opsx:*` MUST conter secção Session Handoff. Additionally, the apply skill MUST reference session coordination scripts (`sdd-session-check`, `sdd-session-release`).

#### Scenario: Handoff and coordination rules active

- **WHEN** o Cursor abre o workspace após instalação SDD actualizada
- **THEN** as regras `015-session-phases.mdc` e `016-session-coordination.mdc` estão activas (alwaysApply: true)
