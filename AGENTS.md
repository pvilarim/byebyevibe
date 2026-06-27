# AGENTS.md — Instruções Universais para Agentes de IA

> Ficheiro canónico para Cursor, Claude Code, Codex, etc. `CLAUDE.md` e `.cursor/rules/` apenas apontam aqui.
> Padrão: https://agents.md/

## Contexto do projecto

Ver `./openspec/project.md` (stack, convenções, constraints). **Não duplicar** stack aqui.

## Commands

| Comando | Uso |
|---------|-----|
| `npx openspec list` | Changes OpenSpec activos |
| `npx openspec new change "<id>"` | Criar change (CLI) |
| `npx openspec validate <id>` | Validar change |
| `/opsx:propose` · `/opsx:apply` · `/opsx:archive` | Workflow Cursor/Claude |
| `npx gitnexus status` | Estado do index de código |
| `npx gitnexus analyze --force` | Reindexar após mudanças |
| `graphify update .` | Actualizar grafo (AST, sem LLM) |
| `graphify query "<pergunta>"` | Busca no knowledge graph |
| `python doc/curso/scripts/enrich-transcripts.py` | Re-enriquecer transcrições do curso |
| `bash scripts/sdd-session-status.sh` | Sessões SDD activas na worktree local |

Nota: não há `npm run dev` na raiz — repo de specs e documentação (perfil DOCS_SPECS).

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
| Workshop e transcrições | `doc/curso/aula-*.md` |
| Guia de instalação SDD (v1.3) | `doc/sistema-sdd-pedro.md` |
| Install kit (payload SDD) | `sdd-kit/` |
| Actualização SDD (repo já instalado) | `doc/sistema-sdd-pedro.md` §2.9 |
| Scripts CDP / transcrições | `doc/curso/scripts/AGENTS.md` |
| TypeScript (se aplicável) | `.cursor/rules/010-typescript.mdc` |
| Python | `.cursor/rules/020-python.mdc` |
| Supabase | `.cursor/rules/030-supabase.mdc` |
| Legado / AS-IS | Perguntar padrões **sem criar ficheiros**; depois documentar no `AGENTS.md` |
| Tasks atómicas (Pattern, Gate) | `doc/sistema-sdd-pedro.md` §12.10 |
| Infra instalada (MCP, CLIs, skills) | `openspec/infra.md` |
| Install kit (payload versionado) | `sdd-kit/` |
| Avaliações de integração / ferramentas descartadas | `doc/avaliacoes/` |
| Impeccable + shadcn — guia de adoção | `doc/design/000-impeccable-design-system-guia.md` |
| Pipeline OD / Pencil / Figma → shadcn → Impeccable | `doc/design/001-pipeline-open-design-shadcn-impeccable.md` |

## Documentação relacionada (design system)

| Documento | Tema |
|-----------|------|
| [`doc/design/000-impeccable-design-system-guia.md`](./doc/design/000-impeccable-design-system-guia.md) | Impeccable + shadcn — guia de adoção |
| [`doc/design/001-pipeline-open-design-shadcn-impeccable.md`](./doc/design/001-pipeline-open-design-shadcn-impeccable.md) | Pipeline OD / Pencil / Figma → shadcn → Impeccable |

> Importados de `topocnc-art` (jun/2026). Integração no guia canónico `doc/sistema-sdd-pedro.md` pendente.

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

**GitNexus** — Repo indexado como `gitnexus-graphify-openspec`. Antes de editar símbolos: `gitnexus_impact`. Antes de commit: `gitnexus_detect_changes`. Detalhe: `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md`.

**Graphify** — Ler `graphify-out/GRAPH_REPORT.md` antes de grep em perguntas de arquitectura. Após editar código: `graphify update .`. Detalhe: `.cursor/rules/graphify.mdc`.

## Testing

- Scripts Python: validar manualmente ou com testes ao alterar `doc/curso/scripts/*.py`
- OpenSpec: `npx openspec validate <change-id>` quando aplicável
- Não há suite `npm test` na raiz deste repo

## PR e commits

- Conventional Commits: `feat(scope): desc`, `docs(sdd): …`, `fix(scope): …`
- Referenciar change-id quando relevante: `docs(sdd): guia v1.1 (update-sdd-install-guide-agents-format)`
- **Não commitar:** `graphify-out/`, `.gitnexus/`, `AGENTS.tools-generated.md`

## Reviews pós-implementação (on-demand)

Skills invocáveis após código escrito — **nunca** always-on, **nunca** bloqueiam commit.

| Skill / agent | Quando invocar | Não invocar |
|---------------|----------------|-------------|
| `simplify-review` | Pós-apply ou pré-PR: diff > ~80 linhas ou > 4 ficheiros; Tipo B/C/D; pedido explícito de simplicidade | Tipo A; durante `/opsx:propose`; escopo ainda em debate |
| `security-reviewer` | Auth, API routes, pagamentos, dados sensíveis, webhooks | — |

Ordem sugerida: implementação → testes (R6) → `simplify-review` (opcional) → `security-reviewer` (se aplicável) → commit.

Detalhe da skill: `.claude/skills/simplify-review/SKILL.md` (espelho em `.cursor/skills/`).

## Subagentes (Claude Code)

- `graphify-researcher` — research teórico → `knowledge.md`
- `codebase-researcher` — AS-IS código → `codebase.md`
- `security-reviewer` — auditoria de segurança

Tipo D: disparar researchers **em paralelo**.

## Segurança

**NUNCA:** segredos em ficheiros git; `rm -rf` fora do repo; `--no-verify` sem explicar; ler `.env`.

**SEMPRE:** validar inputs (Zod/Pydantic); queries parametrizadas; sanitizar prompts LLM.

## Comunicação

Quando responder ao Pedro: pt-BR; começar pela resposta; avaliações directas; sem preâmbulo desnecessário.
