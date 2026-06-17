## ADDED Requirements

### Requirement: Install kit present after SDD bootstrap

After SDD installation (scenario C1), the target repository MUST have all files listed in `sdd-kit/MANIFEST.yaml` expanded to their canonical paths OR MUST retain `sdd-kit/` at the version recorded in `openspec/project.md` Cross-references.

#### Scenario: Greenfield install checklist

- **WHEN** the operator completes checklist §2.8 after `sdd-kit/install.sh`
- **THEN** `bash sdd-kit/verify.sh` exits 0

#### Scenario: Manifest version recorded

- **WHEN** post-install verification runs
- **THEN** `openspec/project.md` or `openspec/infra.md` references installed kit version matching the guide version

### Requirement: Task pattern verification script present

The repository MUST have `scripts/verify-task-patterns.sh` after SDD install, executable, validating `Pattern:` paths in active change `tasks.md` files.

#### Scenario: Verify task patterns on checklist

- **WHEN** the operator runs `bash scripts/verify-task-patterns.sh` after install
- **THEN** the script exits 0 when no broken in-repo Pattern paths exist

## MODIFIED Requirements

### Requirement: Project constitution exists

O repositório MUST ter `openspec/project.md` editado com Purpose, Stack e Cross-references ao guia de instalação SDD **e** referência ao kit SDD (`sdd-kit/` ou versão instalada conforme §1.6 do guia).

#### Scenario: Agent reads project context

- **WHEN** um agente inicia trabalho no repositório
- **THEN** `openspec/project.md` descreve o perfil do repo (APP, DOCS_SPECS ou HYBRID), aponta para `doc/sistema-sdd-pedro.md` com versão, e indica cenário de instalação aplicável (C1/C2)

### Requirement: Session handoff rules present after install

Após instalação SDD, `.cursor/rules/015-session-phases.mdc` MUST existir e as skills `/opsx:*` MUST conter secção Session Handoff. Additionally, the apply skill MUST reference session coordination scripts (`sdd-session-check`, `sdd-session-release`). **Installation MUST obtain these artifacts from `sdd-kit/templates/` rather than markdown extraction.**

#### Scenario: Handoff and coordination rules active

- **WHEN** o Cursor abre o workspace após instalação SDD via kit
- **THEN** as regras `015-session-phases.mdc` e `016-session-coordination.mdc` estão activas (alwaysApply: true)
