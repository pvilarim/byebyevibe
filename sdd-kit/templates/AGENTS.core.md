# AGENTS.md — Instruções Universais para Agentes de IA

> Ficheiro canónico para Cursor, Claude Code, Codex, etc. `CLAUDE.md` e `.cursor/rules/` apenas apontam aqui.
> Padrão: https://agents.md/

## Contexto do projecto

Ver `./openspec/project.md` (stack, convenções, constraints). **Não duplicar** stack aqui.

## Commands

<!-- SDD_KIT_COMMANDS_START -->
[PREENCHER: tabela do perfil — ver sdd-kit/templates/AGENTS.commands.APP.md ou AGENTS.commands.DOCS_SPECS.md]
<!-- SDD_KIT_COMMANDS_END -->

## Fontes de conhecimento (por prioridade)

1. `./openspec/specs/` — requisitos actuais por capability
2. `./openspec/changes/` — propostas activas e arquivo
3. `./graphify-out/GRAPH_REPORT.md` — resumo do knowledge graph
4. GitNexus via MCP — estrutura de código, call chains, blast radius
5. Graphify via MCP ou `graphify query` — conceitos e relações
6. Docs externos (apenas se citados em `./openspec/project.md`)
7. Web search (último recurso, com escrutínio crítico)

**NUNCA** afirmar um facto que não possa ser ancorado a uma das fontes 1–6.
Para trabalho tipo D/E, **SEMPRE** consultar Graphify e GitNexus antes de escrever código.

## Contexto sob demanda

| Situação | Carregar |
|----------|----------|
| Constituição (stack, non-goals) | `openspec/project.md` |
| Specs por capability | `openspec/specs/` |
| Change em curso | `openspec/changes/<id>/` |
| Teoria / relações entre conceitos | `graphify-out/GRAPH_REPORT.md` |
| Guia de instalação SDD | `doc/sistema-sdd-pedro.md` |
| Módulo UI (C1-UI) | `doc/sistema-sdd-pedro.md` §2.11 · `doc/design/002-ui-module-install.md` |
| Pipeline design / shadcn | `doc/design/001-pipeline-open-design-shadcn-impeccable.md` |
| Actualização SDD (repo já instalado) | `doc/sistema-sdd-pedro.md` §2.9 |
| Install kit (payload versionado) | `sdd-kit/` |
| Infra instalada (MCP, CLIs, skills) | `openspec/infra.md` |
| TypeScript (se aplicável) | `.cursor/rules/010-typescript.mdc` |
| Python | `.cursor/rules/020-python.mdc` |
| Supabase | `.cursor/rules/030-supabase.mdc` |

## Protocolo de Classificação de Tarefas

Antes de **qualquer** trabalho, classificar (A–E):

| Tipo | Sinal | Pipeline |
|------|-------|----------|
| A — Trivial | Uma linha, sem risco semântico | Edição directa |
| B — Bug fix | Erro reproduzível, causa conhecida | GitNexus impact → patch → teste |
| C — Refactor | Reestruturar sem novo comportamento | GitNexus AS-IS → `/opsx:propose` → implementar |
| D — Feature | Novo comportamento com base no knowledge base | Graphify ∥ GitNexus → propose → implementar |
| E — Exploração | Investigar, comparar, decidir | Graphify → `research.md` |

Se ambíguo entre dois tipos, **PERGUNTAR**. **NUNCA** assumir Tipo A por defeito.

## Regras Universais (R1–R11)

- **R1** — Classificar tarefa (A–E) antes de agir
- **R2** — Prioridade: specs > arquivo > Graphify > GitNexus > docs > web
- **R3** — Sem alucinações: marcar `[NEEDS VERIFICATION]` se sem fonte
- **R4** — Menor mudança razoável; sem abstracções especulativas
- **R5** — Refactors sem novo comportamento
- **R6** — Bug: teste que falha primeiro, depois fix
- **R7** — Tarefas C/D/E: proposta OpenSpec revista antes de código
- **R8** — Citar fontes em design.md, research.md, commits
- **R9** — Commits com scope ou change-id OpenSpec
- **R10** — Infra conhecida: ler `openspec/infra.md` antes de instalar MCP/CLIs/skills; ✅ = usar directamente
- **R11** — Coordenação local: antes de apply, `sdd-session-register` + `sdd-session-check`; ao fim/pause, `sdd-session-release` (§3.3 guia SDD)

## Workflow

- `/opsx:propose <description>` — nova mudança
- `/opsx:apply` — implementar tasks do change actual
- `/opsx:archive` — finalizar e arquivar
- `/opsx:explore <topic>` — tarefas tipo E
- `graphify update .` — actualizar grafo após mudanças em código/docs
- `npx gitnexus analyze --force` — actualizar code graph

## Integrações

**GitNexus** — Antes de editar símbolos: `gitnexus_impact`. Antes de commit: `gitnexus_detect_changes`. Skills: `.claude/skills/gitnexus/`.

**Graphify** — Ler `graphify-out/GRAPH_REPORT.md` antes de grep em perguntas de arquitectura. Após editar código: `graphify update .`.

## Testing

[PREENCHER: npm test / pytest / openspec validate / N/A para docs-only]

## PR e commits

Conventional Commits; referenciar change-id OpenSpec quando aplicável.
**Não commitar:** `graphify-out/`, `.gitnexus/`, `AGENTS.tools-generated.md`

## Segurança

**NUNCA:** segredos em ficheiros git; `rm -rf` fora do repo; `--no-verify` sem explicar; ler `.env`.

**SEMPRE:** validar inputs (Zod/Pydantic); queries parametrizadas; sanitizar prompts LLM.

## Comunicação

[Adaptar: pt-BR, directo, sem preâmbulo]
