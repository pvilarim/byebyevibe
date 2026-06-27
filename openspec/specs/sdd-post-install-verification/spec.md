# sdd-post-install-verification Specification

## Purpose
TBD - created by archiving change fechar-checklist-instalacao-sdd. Update Purpose after archive.
## Requirements
### Requirement: Project constitution exists

O repositório MUST ter `openspec/project.md` editado com Purpose, Stack e Cross-references ao guia de instalação SDD **e** referência ao kit SDD (`sdd-kit/` ou versão instalada conforme §1.6 do guia).

#### Scenario: Agent reads project context

- **WHEN** um agente inicia trabalho no repositório
- **THEN** `openspec/project.md` descreve o perfil do repo (APP, DOCS_SPECS ou HYBRID), aponta para `doc/sistema-sdd-pedro.md` com versão, e indica cenário de instalação aplicável (C1/C2)

### Requirement: AGENTS entry point is lean

O repositório MUST ter `AGENTS.md` na raiz com ≤150 linhas e MUST NOT conter o bloco auto-gerado `<!-- gitnexus:start -->` … `<!-- gitnexus:end -->`.

#### Scenario: AGENTS size check

- **WHEN** a verificação pós-instalação é executada
- **THEN** `AGENTS.md` tem no máximo 150 linhas e não inclui `gitnexus:start`

### Requirement: Tool-generated files are gitignored

`AGENTS.tools-generated.md` e `CLAUDE.tools-generated.md` MUST estar listados em `.gitignore`.

#### Scenario: Ignore generated agent files

- **WHEN** GitNexus ou ferramentas geram ficheiros auxiliares
- **THEN** esses ficheiros não são commitados acidentalmente

### Requirement: CLAUDE entry delegates to AGENTS

`CLAUDE.md` MUST apontar para `./AGENTS.md` e MUST ter no máximo ~25 linhas úteis sem duplicar regras longas.

#### Scenario: Claude Code lookup

- **WHEN** Claude Code carrega o repositório
- **THEN** `CLAUDE.md` redireciona comportamento para `AGENTS.md` sem bloco GitNexus duplicado

### Requirement: Cursor base rules exist

`.cursor/rules/000-base.mdc` e `050-security.mdc` MUST existir após instalação.

#### Scenario: Cursor always-on rules

- **WHEN** o Cursor abre o workspace
- **THEN** regras base e segurança estão activas via `.mdc`

### Requirement: OpenSpec CLI is operational

`npx openspec list` MUST executar sem erro e listar changes em `openspec/changes/`.

#### Scenario: List changes

- **WHEN** o operador corre `npx openspec list`
- **THEN** o comando termina com exit code 0

### Requirement: GitNexus index is current

`npx gitnexus status` MUST reportar index up-to-date em relação ao HEAD actual.

#### Scenario: Index freshness

- **WHEN** o operador corre `npx gitnexus status`
- **THEN** o status indica que o índice está actualizado

### Requirement: Graphify report exists

Após `graphify update .`, o ficheiro `graphify-out/GRAPH_REPORT.md` MUST existir (directório `graphify-out/` pode estar gitignored).

#### Scenario: Knowledge graph built

- **WHEN** a instalação corre `graphify update .`
- **THEN** `graphify-out/GRAPH_REPORT.md` está presente no filesystem local

### Requirement: OpenSpec propose workflow works

O operador MUST conseguir criar um change via `/opsx:propose` ou `npx openspec new change <name>`.

#### Scenario: Propose new change

- **WHEN** o utilizador executa `/opsx:propose <descrição>` após reiniciar a IDE
- **THEN** um directorio `openspec/changes/<name>/` é criado com `.openspec.yaml`

### Requirement: Profile reflected in AGENTS commands

A tabela Commands em `AGENTS.md` MUST reflectir o perfil instalado (APP, DOCS_SPECS ou HYBRID).

#### Scenario: DOCS_SPECS pilot

- **WHEN** o repositório é perfil DOCS_SPECS sem app na raiz
- **THEN** `AGENTS.md` documenta workflows `/opsx:*` e prioridade Graphify/OpenSpec sobre stack de app

### Requirement: Infrastructure manifest present after install

Após instalação SDD, `openspec/infra.md` MUST existir e estar actualizado com estado ✅ para componentes core (OpenSpec, GitNexus, Graphify).

#### Scenario: Post-install checklist item

- **WHEN** o operador executa o checklist §2.8
- **THEN** `openspec/infra.md` existe, contém secções SDD Stack e MCP Servers, e timestamp de verificação recente

#### Scenario: Verify infra script available

- **WHEN** o operador corre `bash scripts/verify-infra.sh` após instalação
- **THEN** o script completa sem erro e confirma estado dos componentes listados em `openspec/infra.md`

### Requirement: Session coordination present after install

Após instalação SDD, os scripts `scripts/sdd-session-check.sh` e `scripts/sdd-session-status.sh` MUST existir e ser executáveis; `.cursor/rules/016-session-coordination.mdc` MUST existir (alwaysApply); `.sdd/runtime/` MUST estar no `.gitignore`.

#### Scenario: Session scripts on checklist

- **WHEN** o operador executa o checklist §2.8
- **THEN** `bash scripts/sdd-session-status.sh` completa sem erro
- **AND** `016-session-coordination.mdc` está presente

#### Scenario: Infra manifest lists session coordination

- **WHEN** o operador lê `openspec/infra.md` após instalação
- **THEN** existe secção Session Coordination com os scripts listados

### Requirement: Session handoff rules present after install

Após instalação SDD, `.cursor/rules/015-session-phases.mdc` MUST existir e as skills `/opsx:*` MUST conter secção Session Handoff. Additionally, the apply skill MUST reference session coordination scripts (`sdd-session-check`, `sdd-session-release`). **Installation MUST obtain these artifacts from `sdd-kit/templates/` rather than markdown extraction.**

#### Scenario: Handoff and coordination rules active

- **WHEN** o Cursor abre o workspace após instalação SDD via kit
- **THEN** as regras `015-session-phases.mdc` e `016-session-coordination.mdc` estão activas (alwaysApply: true)

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

### Requirement: UI module verification checklist

The canonical guide MUST include checklist **§2.11.1** for optional UI module verification, referenced from §2.8 as an extension (not replacement) for repositories that applied C1-UI.

#### Scenario: UI module checklist after apply

- **WHEN** the operator completes `install-ui-module.sh --apply`
- **THEN** §2.11.1 items include: `--detect` output archived, `UI stack` in project.md or infra.md, `doc/design/002` present, Impeccable status in infra.md

