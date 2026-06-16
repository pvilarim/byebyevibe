# sdd-post-install-verification Specification

## Purpose
TBD - created by archiving change fechar-checklist-instalacao-sdd. Update Purpose after archive.
## Requirements
### Requirement: Project constitution exists

O repositório MUST ter `openspec/project.md` editado com Purpose, Stack e Cross-references ao guia de instalação SDD.

#### Scenario: Agent reads project context

- **WHEN** um agente inicia trabalho no repositório
- **THEN** `openspec/project.md` descreve o perfil do repo (APP ou DOCS_SPECS) e aponta para `doc/sistema-sdd-pedro.md`

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

### Requirement: Session handoff rules present after install

Após instalação SDD, `.cursor/rules/015-session-phases.mdc` MUST existir e as skills `/opsx:*` MUST conter secção Session Handoff.

#### Scenario: Handoff rule active

- **WHEN** o Cursor abre o workspace após instalação SDD actualizada
- **THEN** a regra `015-session-phases.mdc` está activa (alwaysApply: true)

