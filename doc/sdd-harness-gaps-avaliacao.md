# SDD Harness — Gaps, Soluções e Roadmap de Avaliação

**Status:** rascunho para decisão · **Data:** 2026-06-22 · **Versão:** 1.0.0

> Documento de referência para avaliar extensões ao stack **OpenSpec + GitNexus + Graphify** (`doc/sistema-sdd-pedro.md` v1.3.0). Nenhuma ferramenta listada aqui está instalada ou adoptada — apenas opções mapeadas.

## Propósito

Consolidar a análise comparativa com as melhores práticas de **Harness Engineering** e **Spec-Driven Development (SDD)** em 2026, identificando gaps do stack actual e alternativas (DIY, open source, comercial) para decisão futura.

## Stack de referência (AS-IS)

| Camada | Artefacto | Papel |
|--------|-----------|-------|
| Intenção | OpenSpec (`/opsx:*`) | propose → apply → archive, delta specs |
| Constituição | `openspec/project.md` | Stack, non-goals, convenções |
| Contexto agente | `AGENTS.md` + `.cursor/rules/` | Entry point, on-demand loading |
| Código (AS-IS) | GitNexus MCP | impact, context, call chains |
| Conhecimento | Graphify | teoria, docs, relações |
| Verificação local | `tasks.md` §12.10 (`Gate:`, `Pattern:`) | Sensors determinísticos por task |
| Sessões | `scripts/sdd-session-*` + rules 015/016 | fases, locks, handoff |
| Payload | `sdd-kit/` + `MANIFEST.yaml` | install/upgrade reprodutível |

**Modelo de mercado (2026):** Agent = Modelo + Harness, com **Guides (feedforward)** antes da acção e **Sensors (feedback)** depois ([Martin Fowler / Birgitta Böckeler — Harness Engineering](https://martinfowler.com/articles/harness-engineering.html)).

---

## Resumo executivo — gaps vs. mercado

| Best practice 2026 | Mercado típico | Stack actual | Gap |
|--------------------|----------------|--------------|-----|
| SDD brownfield | OpenSpec, Spec Kit | OpenSpec | — |
| AGENTS.md curto | [agents.md](https://agents.md/) | `AGENTS.md` curado | — |
| Code graph + impact | GitNexus, code-graph-mcp | GitNexus | — |
| Knowledge graph | RAG, wikis | Graphify | — |
| Gates determinísticos | Stripe Minions, TLC spec-driven | §12.10 | — |
| Fases + handoff | Anthropic, agent-context-store | Session Handoff + SDD phases | — |
| Install reprodutível | (emergente) | `sdd-kit` | — |
| Eval harness CI | Promptfoo, Langfuse datasets | Parcial (`verify.sh`, validate) | **Médio** |
| Observabilidade OTEL | Langfuse, Braintrust | `.sdd/runtime/` básico | **Médio** |
| Blueprint executável | Stripe, Temporal | Convenção em `tasks.md` | **Médio** |
| Living spec auto-sync | Kiro, Intent | Archive manual OpenSpec | **Baixo** (opt-out consciente) |
| Skills lockfile + scan | skills-lock, Snyk Agent Scan | Git pin (skills no repo) | **Baixo** (se skills externas) |

---

## Visão rápida — o que escolher quando

| Gap | Começar por (baixo risco) | Se precisar de mais | Evitar cedo |
|-----|---------------------------|---------------------|-------------|
| 1. Evals | Gates existentes + CI | Promptfoo + golden tasks | LLM-as-judge bloqueando CI |
| 2. Observabilidade | Logs em `.sdd/runtime/` | Langfuse self-host | APM enterprise completo |
| 3. Blueprints | `tasks.md` + gates shell | GitHub Actions composto | Replicar Stripe Minions |
| 4. Spec sync | Archive OpenSpec disciplinado | Review multi-skill | Migrar para Kiro/Intent |
| 5. Skills lockfile | Pin manual + review PR | Snyk Agent Scan + skills-lock | Tank registry completo |

---

## Gap 1 — Eval harness formal (golden tasks + baseline CI)

### Problema

Existem `Gate:` por task (sensor local), mas não há **suite de regressão do harness** que responda: “esta change quebrou o comportamento esperado do agente ou a estrutura SDD?”.

### Opções

#### A — DIY no stack actual (recomendado para avaliar primeiro)

| Componente | Função |
|------------|--------|
| `scripts/verify-task-patterns.sh` | Valida paths em `Pattern:` |
| `sdd-kit/verify.sh` | Smoke pós-install |
| `openspec validate --strict` | Estrutura de specs/deltas |
| Golden changes em `evals/` (futuro) | 10–30 changes arquivados como referência estrutural |

**Custo:** zero licença · **Esforço estimado:** 1–2 dias para workflow CI.

**Nota:** `doc/sistema-sdd-pedro.md` referencia Langfuse como non-goal para “construir framework de eval do zero” — preferir integração ou DIY mínimo.

#### B — Open source especializado

| Ferramenta | URL | Prós | Contras |
|------------|-----|------|---------|
| Promptfoo | https://github.com/promptfoo/promptfoo | CI-friendly, rubrics | Focado em prompts, não em “agente editou repo” |
| agent-evals-template | https://github.com/numoru-ia/agent-evals-template | Template Promptfoo+DeepEval+Langfuse+gate | Orientado a RAG/support |
| DeepEval | https://github.com/confident-ai/deepeval | Métricas semânticas | Overkill se só gates shell |

#### C — Observabilidade + evals

| Ferramenta | URL | Uso |
|------------|-----|-----|
| Langfuse | https://langfuse.com/ | Traces, datasets, regressão (OSS self-host) |
| Braintrust | https://www.braintrust.dev/ | Eval UI, diff de golden sets |
| LangSmith | https://www.langchain.com/langsmith | Stack LangChain |

### Padrão de mercado (2026)

- **Piso:** lint, typecheck, test, `openspec validate` — gate de merge obrigatório.
- **Tecto:** LLM-as-judge — métrica reportada, **não** bloqueio de CI ([referência](https://startdebugging.net/2026/06/llm-as-judge-vs-rule-based-evals-for-a-coding-agent/)).

### Recomendação de avaliação

1. CI com `openspec validate` + `verify-task-patterns.sh` + `sdd-kit/verify.sh`
2. Langfuse **se** houver volume de sessões reais a medir
3. Promptfoo **se** houver evals isolados de prompts/skills

---

## Gap 2 — Observabilidade de handoff, fases e custo

### Problema

Falta visibilidade sobre consumo por fase (`explore` → `propose` → `apply`), falhas de handoff e eficácia dos locks SDD.

### Opções

#### A — DIY (parcialmente existente)

| Artefacto | Dado |
|-----------|------|
| `scripts/sdd-session-*.sh` | Sessões activas, conflitos worktree |
| `.sdd/runtime/sessions/*.json` | Heartbeat, fase, change-id |
| Session Handoff nos `/opsx:*` | Contrato entre chats |
| **Extensão proposta:** `.sdd/runtime/traces/*.jsonl` | `{phase, change_id, gate_pass, duration_ms, tokens?}` |

#### B — OpenTelemetry + backend

| Stack | Handoffs | Tokens/custo |
|-------|----------|--------------|
| Langfuse + OTEL | `session_id`, spans parent-child | Sim |
| Braintrust | Nested runs | Sim |
| OTEL → Grafana/Jaeger | Genérico | Requer instrumentação |

Referência: [Braintrust — Agent observability 2026](https://www.braintrust.dev/articles/agent-observability-complete-guide-2026).

#### C — Handoff como contrato versionado

| Projecto | URL | Ideia |
|----------|-----|-------|
| agent-context-store | https://github.com/max9159/agent-context-store | Handoffs schema-validados em Git (BA→Dev→QA) |

#### D — Métricas de harness sem APM

- Eval interno 30–100 tasks (Coding Agent Index mindset)
- Dashboards de billing Cursor/Claude como proxy grosso de custo

### Recomendação de avaliação

- **Curto prazo:** enriquecer `.sdd/runtime/` (zero vendor)
- **Médio prazo:** Langfuse self-host se volume justificar

---

## Gap 3 — Blueprints (nós determinísticos ↔ loops de agente)

### Problema

Stripe intercala nós de agente (“Implement task”) com nós determinísticos (“Run linters”). No stack actual isso é **convenção** em `tasks.md`, não máquina de estados executável.

Referência: [Stripe Minions — Blueprints Part 2](https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents-part-2).

### Opções

#### A — DIY no OpenSpec (~80% do valor)

| Mecanismo | Papel |
|-----------|-------|
| `tasks.md` com fases ordenadas | State machine declarativa |
| `Gate:` obrigatório | Nó determinístico |
| `/opsx:apply` task-a-task | Loop agente bounded |
| Sub-agentes por fase (workshop TLC) | Paralelismo isolado |
| CI pré-merge | Nó determinístico final |

#### B — Orquestradores

| Ferramenta | URL | Fit |
|------------|-----|-----|
| Temporal | https://temporal.io/ | Enterprise, durable workflows |
| Prefect / Dagster | — | Pipelines ML/data |
| amux | https://amux.io/ | Multi-agente, monitoring |
| GitHub Actions composto | — | propose → apply → verify jobs |

### Recomendação de avaliação

- **Não** replicar Minions cedo
- Formalizar blueprint como `tasks.md` + script `apply-next-task.sh` (futuro)
- Temporal só com orquestração 24/7 de muitos agentes

---

## Gap 4 — Spec auto-sync (living specs)

### Problema

Após implementação, `openspec/specs/` pode divergir do código. OpenSpec resolve com **archive manual**; Kiro/Intent prometem sync bidireccional.

### Opções

#### A — Disciplina OpenSpec (zero custo, design actual)

| Prática | Efeito |
|---------|--------|
| `/opsx:archive` obrigatório | Merge delta → `specs/` |
| PR checklist “spec archived?” | Anti-drift processual |
| `openspec validate` em CI | Specs malformadas não passam |
| Cleanup pós-merge (workshop TLC) | Remove specs obsoletas |

#### B — Ferramentas living spec

| Ferramenta | URL | Lock-in |
|------------|-----|---------|
| Intent | https://intent-driven.dev/ | Comercial |
| AWS Kiro | https://kiro.dev/ | IDE AWS/Bedrock |
| Tessl | — | Regulatório/comercial |

Comparação: [Spec Kit vs OpenSpec](https://intent-driven.dev/knowledge/spec-kit-vs-openspec/).

#### C — Híbrido pragmático

- GitNexus `detect_changes` pós-apply
- Code review skill vs spec (workshop TLC)
- **Evitar** auto-rewrite de specs pelo agente

### Recomendação de avaliação

- Manter OpenSpec + archive como fonte de verdade
- **Não** migrar para Kiro/Intent só por sync — implica trocar IDE/workflow
- Preferir **sensor** (review) > **auto-sync** (arriscado)

---

## Gap 5 — Registry de skills com lockfile e scanning

### Problema

Skills em `.cursor/skills/` e `.claude/skills/` sem pin de versão nem scan de supply chain quando vêm de fora do repo.

### Opções

#### A — DIY mínimo (suficiente se skills só no repo)

- Git = lockfile
- `openspec/infra.md` = manifesto ✅
- PR review de diffs de skills

#### B — Lockfile community

| Ferramenta | URL | Função |
|------------|-----|--------|
| tech-leads-club/agent-skills | https://github.com/tech-leads-club/agent-skills | Registry curado + Snyk scan no CI deles |
| skills-lock | https://github.com/pcomans/skills-lock | Pin commit SHA + sha256 |
| skilllock | https://github.com/lz1834career/skilllock | Lockfile v2, `check`/`reproduce` |
| Tank | https://www.tankpkg.dev/ | Registry + `tank.lock` |

#### C — Security scanning

| Ferramenta | URL | Detecta |
|------------|-----|---------|
| Snyk Agent Scan | https://github.com/snyk/agent-scan | Prompt injection, secrets, MCP/skills maliciosos |

### Recomendação de avaliação

- Skills curadas no repo → Git basta
- Skills externas (ex. TLC spec-driven) → Snyk Agent Scan + skills-lock
- Tank só para marketplace interno de skills

---

## Mapa visual — gap → solução → stack

```
                    ┌─────────────────────────────────────────┐
                    │     Stack actual                        │
                    │  OpenSpec + GitNexus + Graphify         │
                    │  AGENTS.md + sdd-kit + session scripts  │
                    └─────────────────────────────────────────┘
                                      │
        ┌─────────────┬───────────────┼───────────────┬─────────────┐
        ▼             ▼               ▼               ▼             ▼
   Gap 1 Evals   Gap 2 Obs      Gap 3 Blueprint  Gap 4 Sync   Gap 5 Skills
        │             │               │               │             │
   CI + validate  .sdd JSONL    tasks.md+Gates   archive+review  git pin
   Promptfoo?     Langfuse?     GHA workflow?   (manter OS)     Snyk scan?
   Langfuse?     acs?           Temporal?       Kiro/Intent ✗   skills-lock?
```

---

## Roadmap sugerido para avaliação

### Fase 0 — Baseline (sem instalar)

- [ ] Ler `doc/sistema-sdd-pedro.md` §3 (classificação A–E) e §12.10
- [ ] Executar `bash sdd-kit/verify.sh --dry-run` ou equivalente quando instalado
- [ ] Definir perfil alvo: **APP** vs **DOCS_SPECS** vs **HYBRID**

### Fase 1 — Quick wins (extendem o kit, sem novo vendor)

- [ ] CI: `openspec validate` + `verify-task-patterns.sh`
- [ ] Métricas leves em `.sdd/runtime/traces.jsonl` (proposta)
- [ ] Checklist de PR: archive + delta revisto

### Fase 2 — Se validarem valor com agentes reais

- [ ] Langfuse self-host (observabilidade)
- [ ] Snyk Agent Scan pontual (antes de skills externas)
- [ ] 10 golden changes arquivados como regressão estrutural

### Fase 3 — Só com escala ou dor clara

- [ ] Promptfoo ou agent-evals-template
- [ ] Temporal / amux (paralelismo > 3 agentes)
- [ ] **Não** Kiro/Intent salvo decisão de trocar ecossistema

---

## Decisões a tomar antes de instalar

| # | Pergunta | Impacto |
|---|----------|---------|
| 1 | Hub DOCS_SPECS vs repo APP? | Evals/golden tasks no APP; specs no hub |
| 2 | Quantos agentes em paralelo? | 1 → DIY; 3+ → Langfuse/amux |
| 3 | Skills só curadas ou marketplace? | Git vs Snyk+lockfile |
| 4 | Spec drift acceptable? | Processo (archive) vs produto (Kiro) |
| 5 | Orçamento LLM mensurável? | Observabilidade necessária para optimizar harness |

---

## Referências externas

| Tema | URL |
|------|-----|
| Harness Engineering (Fowler/Böckeler) | https://martinfowler.com/articles/harness-engineering.html |
| OpenSpec | https://openspec.dev/ |
| AGENTS.md standard | https://agents.md/ |
| SDD guide 2026 | https://thebcms.com/blog/spec-driven-development |
| Spec Kit vs OpenSpec | https://intent-driven.dev/knowledge/spec-kit-vs-openspec/ |
| LLM-as-judge vs rule-based evals | https://startdebugging.net/2026/06/llm-as-judge-vs-rule-based-evals-for-a-coding-agent/ |
| Stripe Minions blueprints | https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents-part-2 |
| Agent observability 2026 | https://www.braintrust.dev/articles/agent-observability-complete-guide-2026 |
| Coding Agent Index 2026 | https://medium.com/@wasowski.jarek/coding-agent-index-2026-benchmarking-full-agent-stacks-model-harness-4183305e4b90 |
| TLC agent-skills | https://github.com/tech-leads-club/agent-skills |
| Snyk Agent Scan | https://github.com/snyk/agent-scan |

## Referências internas

| Documento | Conteúdo |
|-----------|----------|
| `doc/sistema-sdd-pedro.md` | Guia canónico SDD v1.3.0 |
| `openspec/infra.md` | Manifesto do workspace (R10) |
| `AGENTS.md` | Entry point agentes, classificação A–E |
| `doc/curso/aula-02-workshop-ia-5-2026.md` | SDD, gates, evals, comparação ferramentas |
| `openspec/changes/archive/2026-06-16-enrich-tasks-template-code-patterns/` | Gates + Pattern §12.10 |

---

## Changelog deste documento

| Versão | Data | Notas |
|--------|------|-------|
| 1.0.0 | 2026-06-22 | Análise inicial de gaps e opções para avaliação posterior |
