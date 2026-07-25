# Research — Ferramentas OSS para gaps do sistema SDD

| Campo | Valor |
|-------|-------|
| **Data** | 2026-07-25 |
| **Change** | `explore-oss-coverage-gaps` (tipo E — exploração) |
| **Objectivo** | Para cada gap identificado na cobertura do sistema SDD (OpenSpec + GitNexus + Graphify), identificar projectos open-source no GitHub que preencham a função e decidir: **adicionar ao sdd-kit** vs **correcção manual/pontual** vs **não adoptar agora** |
| **Critérios** | 1. Complexidade de instalação · 2. Compatibilidade com o sistema existente · 3. Overlap de funções · 4. Adequação ao fluxo explore/propose/apply · 5. Confiabilidade e reconhecimento pela comunidade |
| **Fontes** | Web search 2026-07 (repos GitHub, npm registry, LFX Insights, ASF); specs e docs deste repo (`AGENTS.md`, `openspec/infra.md`, `doc/sistema-sdd-pedro.md`) |

## Resumo executivo — matriz de decisão

| # | Gap | Ferramenta candidata | Decisão recomendada |
|---|-----|----------------------|---------------------|
| G1 | Enforcement dos gates em CI | GitHub Actions (nativo) | **Correcção manual** — workflow chamando comandos já existentes |
| G2 | Loop de verificação por testes | TDD Guard | **Adicionar ao kit** como módulo opcional (perfis APP) |
| G3 | Feedback de runtime/produção | GlitchTip / Sentry + MCP | **Não adicionar ao kit core** — documentar como módulo sob demanda |
| G4 | Métricas de eficácia do framework | Apache DevLake | **Correcção manual** — script `sdd-metrics.sh`; DevLake só em escala de equipe |
| G5 | Rastreabilidade a issues | github-mcp-server (oficial) | **Híbrido** — MCP ao `infra.md` + campo Issue no template de proposal |
| G6 | Coordenação multi-agente distribuída | Vibe Kanban / Claude Squad | **Não adoptar agora** — overlap alto + risco de manutenção |
| G7 | Review de correctness | PR-Agent | **Híbrido** — skill local primeiro; PR-Agent como opcional de CI |
| G8 | Supply chain / dependências | Renovate + OSV-Scanner | **Adicionar ao kit** — templates de config por perfil |

**Princípio aplicado:** o sdd-kit é um payload minimalista e versionado (MANIFEST 1.3.2). Só entra no kit o que (a) é instalável por script sem infra externa, (b) não duplica componente existente, (c) tem manutenção confiável. Infra pesada (DevLake, Sentry) e projectos órfãos (Vibe Kanban) ficam fora.

---

## Escala de avaliação

- **C1 — Complexidade de instalação:** 🟢 baixa (config/binário) · 🟡 média (serviço/hooks) · 🔴 alta (plataforma/infra)
- **C2 — Compatibilidade:** 🟢 encaixa nos mecanismos existentes (MCP, hooks, scripts) · 🟡 requer adaptação · 🔴 conflita
- **C3 — Overlap:** 🟢 zero overlap · 🟡 overlap parcial · 🔴 duplica componente do sistema
- **C4 — Adequação ao fluxo explore/propose/apply:** 🟢 encaixa sem fricção · 🟡 requer convenção nova · 🔴 fluxo próprio concorrente
- **C5 — Comunidade:** 🟢 projecto consolidado, mantenedores estáveis, adopção ampla · 🟡 activo mas nicho ou governança em transição · 🔴 órfão/estagnado

---

## G1 — Enforcement automatizado dos gates (CI)

**Problema:** todos os gates (openspec validate, classificação A–E, R1–R11) dependem de disciplina local; nada impede merge sem pipeline.

**Candidatos avaliados:**

| Ferramenta | C1 | C2 | C3 | C4 | C5 |
|------------|----|----|----|----|-----|
| GitHub Actions (workflow próprio) | 🟢 | 🟢 | 🟢 | 🟢 | 🟢 nativo GitHub |
| pre-commit (framework Python) | 🟢 | 🟡 | 🔴 | 🟡 | 🟢 12.3k ★, ecossistema maduro |
| Lefthook (Go, paralelo) | 🟢 | 🟡 | 🔴 | 🟡 | 🟡 4.3k ★, MIT, activo |

**Análise:** pre-commit e Lefthook são gestores de git hooks — mas o sistema **já tem** hooks locais (`graphify hook install`, PreToolUse do GitNexus). Adicionar um terceiro gestor de hooks cria duplicação (C3 🔴). Além disso, hooks locais são contornáveis com `--no-verify`; a literatura converge que enforcement pertence ao CI. O que falta não é ferramenta — é um **workflow de CI** que execute comandos já existentes no repo: `npx openspec validate`, `bash sdd-kit/verify.sh`, `bash scripts/verify-infra.sh`.

**Recomendação: correcção manual.** Criar `.github/workflows/sdd-gates.yml` (~30 linhas) e adicionar o template ao `sdd-kit/templates/`. Sem dependência nova.

---

## G2 — Loop de verificação por testes

**Problema:** R6 (teste que falha primeiro) é regra sem enforcement; a conclusão de tasks é auto-declarada pelo agente.

**Candidato principal: [TDD Guard](https://github.com/nizos/tdd-guard)** (nizos/tdd-guard)

| Critério | Avaliação |
|----------|-----------|
| C1 instalação | 🟡 plugin Claude Code + hook PreToolUse + reporter por test runner (Vitest/Jest/pytest/Go/PHP/Rust) |
| C2 compatibilidade | 🟢 usa o mesmo mecanismo PreToolUse já usado por GitNexus/Graphify (hooks empilham); suporta Vitest e pytest — exactamente o stack de testes declarado em `openspec/project.md` |
| C3 overlap | 🟢 nenhum componente do sistema valida TDD hoje; **materializa o R6** em enforcement |
| C4 fluxo | 🟢 actua só na fase apply (bloqueia Write/Edit sem teste falhando); irrelevante em explore/propose |
| C5 comunidade | 🟢 2.2k ★, MIT, 20 contribuidores, 78 releases, ~18.5k downloads/semana no npm, v1.7.0 (jun/2026) — activo e em crescimento |

**Limitações:** funciona via hooks do **Claude Code**; no Cursor a cobertura depende do suporte a hooks equivalentes — verificar na instalação. Adiciona latência por validação (usa uma sessão LLM para validar cada edit); tem toggle on/off por sessão.

**Recomendação: adicionar ao kit** como módulo **opcional**, análogo ao C1-UI: `sdd-kit/install-tdd-module.sh`, activado apenas em perfis APP (não faz sentido no perfil DOCS_SPECS deste repo). Documentar toggle off para tarefas tipo A e docs.

---

## G3 — Feedback de runtime/produção

**Problema:** nenhum caminho para erros de produção alimentarem Graphify ou gerarem changes tipo B.

**Candidatos avaliados:**

| Ferramenta | C1 | C2 | C3 | C4 | C5 |
|------------|----|----|----|----|-----|
| [GlitchTip](https://glitchtip.com/) (self-hosted leve) | 🟡 4 containers, 512 MB RAM | 🟢 SDKs Sentry compatíveis; MCP built-in (beta) | 🟢 | 🟡 | 🟡 MIT, activo (v6 fev/2026), comunidade menor; MCP marcado beta |
| Sentry self-hosted | 🔴 40+ containers, 16 GB RAM | 🟢 | 🟢 | 🟡 | 🟢 referência do mercado, mas licença BSL 1.1 |
| Sentry SaaS + [MCP oficial](https://mcp.sentry.dev) | 🟢 só DSN + MCP | 🟢 MCP first-party maduro | 🟢 | 🟢 | 🟢 |

**Análise:** o encaixe no fluxo é bom — um MCP de erros permite ao agente consultar stack traces reais ao classificar tarefas tipo B, e alimentar `research.md` em tipo E. Mas error tracking é **infra por projecto de produção**, não payload de kit: exige servidor (ou conta SaaS), DSN por app, e não se aplica a repos DOCS_SPECS. Mesma categoria do Figma MCP no módulo UI: "manual / sob demanda".

**Recomendação: não adicionar ao kit core.** Documentar no guia SDD (§ integrações opcionais): Sentry SaaS + MCP oficial se o projecto já usa Sentry; GlitchTip para self-host com orçamento mínimo (SDKs idênticos, migração = trocar DSN). Convenção a registar: changes tipo B citam o issue do tracker de erros em `proposal.md`.

---

## G4 — Métricas de eficácia do framework

**Problema:** sem dados sobre retrabalho, tempo propose→archive, changes corrigidos pós-archive — impossível calibrar o overhead do pipeline.

**Candidato principal: [Apache DevLake](https://devlake.apache.org/)**

| Critério | Avaliação |
|----------|-----------|
| C1 instalação | 🔴 plataforma completa: MySQL + Grafana + workers; setup e manutenção contínua |
| C2 compatibilidade | 🟡 mede DORA (deployment frequency, lead time, CFR, MTTR) — não mede as métricas específicas do SDD (proposals rejeitadas, rework por change-id) |
| C3 overlap | 🟢 zero |
| C4 fluxo | 🔴 dashboards externos, fora do fluxo opsx |
| C5 comunidade | 🟢 Apache Top-Level Project (graduado out/2025), 3.1k ★, 200 contribuidores, Slack 1.6k membros, releases contínuos — governança ASF é o padrão-ouro de sustentabilidade |

**Análise:** DevLake é confiável e maduro, mas resolve um problema maior do que o nosso: DORA para equipes/organizações. As métricas que interessam ao SDD são deriváveis de dados que **já estão no git e em `openspec/changes/archive/`**: nº de changes por período, tempo entre primeiro commit do change e archive, commits `fix:` posteriores referenciando change-id arquivado (proxy de retrabalho — viável porque R9 exige change-id nos commits).

**Recomendação: correcção manual.** Script `scripts/sdd-metrics.sh` (git log + parsing do archive) gerando um relatório markdown. Reavaliar DevLake se/quando os repos de produção tiverem CI/CD e equipe suficientes para DORA fazer sentido.

---

## G5 — Rastreabilidade a issues/backlog

**Problema:** changes nascem de prompts; a cadeia pedido → issue → change → PR não existe.

**Candidato principal: [github-mcp-server](https://github.com/github/github-mcp-server)** (oficial GitHub)

| Critério | Avaliação |
|----------|-----------|
| C1 instalação | 🟢 endpoint remoto hospedado pelo GitHub (`api.githubcopilot.com/mcp/`) ou binário/Docker local; `--toolsets issues` limita superfície |
| C2 compatibilidade | 🟢 MCP é o mecanismo padrão do sistema (GitNexus e Graphify já operam via MCP); registar em `~/.cursor/mcp.json` e `openspec/infra.md` |
| C3 overlap | 🟡 leve — em cloud agents o `gh` CLI read-only já existe; localmente não há equivalente |
| C4 fluxo | 🟢 propose passa a ligar change ↔ issue; explore pode ler contexto de issues |
| C5 comunidade | 🟢 mantido pela própria GitHub, v1.7.0 (jul/2026), já suporta a spec MCP stateless de 28/jul/2026 — manutenção first-party garantida |

**Recomendação: híbrido.** (a) Adicionar github-mcp-server ao `infra.md` e à config MCP (instalação trivial, manutenção first-party); (b) correcção manual no processo: campo `**Issue:**` no template de `proposal.md` do sdd-kit, preenchido quando existir issue de origem. Para quem não usa GitHub Issues, o campo fica `—`.

---

## G6 — Coordenação multi-agente distribuída

**Problema:** locks de sessão (R11) são locais por worktree; agentes cloud e múltiplas máquinas ficam fora.

**Candidatos avaliados:**

| Ferramenta | C1 | C2 | C3 | C4 | C5 |
|------------|----|----|----|----|-----|
| [Vibe Kanban](https://github.com/BloopAI/vibe-kanban) | 🟢 `npx vibe-kanban` | 🟡 usa git worktrees (mesmo modelo do §3.3 do guia) | 🔴 duplica os scripts `sdd-session-*` e o board de tasks do OpenSpec | 🔴 kanban próprio concorrente do fluxo opsx | 🔴 **BloopAI encerrou em abr/2026**; Apache 2.0, fork comunitário sem governança consolidada |
| Claude Squad | 🟢 | 🟡 | 🔴 idem | 🟡 | 🟡 nicho, terminal-first |

**Análise:** o modelo técnico (worktree isolado por agente) é exactamente o que o guia SDD já prescreve para paralelismo seguro — a diferença é a UI de orquestração, que **concorre** com o fluxo opsx em vez de o servir. Com o líder da categoria órfão (C5 🔴), adoptar agora significa assumir manutenção de fork.

**Recomendação: não adoptar agora.** Correcção pontual quando a necessidade for real: estender `sdd-session-*` com backend remoto simples (ex.: registro de sessões via refs no repo remoto), mantendo o mecanismo actual como fallback. Reavaliar o ecossistema de orquestradores em ~6 meses (categoria em consolidação pós-Vibe Kanban).

---

## G7 — Review de correctness

**Problema:** existem `simplify-review` (complexidade) e `security-reviewer` (segurança), mas nenhum review caça bugs lógicos/edge cases — a categoria mais valiosa para código gerado por IA.

**Candidato principal: [PR-Agent](https://github.com/qodo-ai/pr-agent)** (The-PR-Agent, ex-Qodo)

| Critério | Avaliação |
|----------|-----------|
| C1 instalação | 🟢 GitHub Action + API key (Anthropic suportada); também CLI/Docker self-hosted |
| C2 compatibilidade | 🟢 actua no PR, fora do loop local; usa Claude como modelo (alinha com o stack LLM do projecto) |
| C3 overlap | 🟡 parcial com as skills de review existentes — mas essas são on-demand locais e não cobrem correctness; `/review` do PR-Agent cobre |
| C4 fluxo | 🟢 pós-apply, pré-merge; não toca explore/propose |
| C5 comunidade | 🟡 12.1k ★, 240 contribuidores, v0.39.0 (jul/2026), Apache 2.0 — mas transferido para org comunitária em abr/2026 e rotulado "legacy community project" pela Qodo; governança nova, issues de configuração abertas há meses |

**Recomendação: híbrido, em duas fases.** Fase 1 (imediata, sem dependência): criar skill local `correctness-review` no padrão das skills existentes (`.claude/skills/` + espelho `.cursor/skills/`), invocada pós-apply como o `simplify-review` — consistente com o sistema e zero risco. Fase 2 (opcional, por repo): template de workflow PR-Agent no sdd-kit para quem quiser review automático em todo PR; a transição de governança recomenda pin de versão e reavaliação semestral.

---

## G8 — Supply chain e dependências

**Problema:** "verificar advisories" é regra sem tooling; sem updates automatizados nem scanning em CI.

**Candidatos (complementares, não alternativos):**

| Ferramenta | C1 | C2 | C3 | C4 | C5 |
|------------|----|----|----|----|-----|
| [Renovate](https://github.com/renovatebot/renovate) (updates) | 🟢 `renovate.json` + app GitHub hospedado grátis (Mend) ou self-host | 🟢 ortogonal ao SDD | 🟢 | 🟢 PRs de update entram no fluxo como tarefas tipo A/B | 🟢 22k ★, 440+ contribuidores, mantido pela Mend, 62k installs do app, releases diários |
| [OSV-Scanner](https://github.com/google/osv-scanner) (scanning) | 🟢 step de GitHub Action | 🟢 | 🟢 | 🟢 gate de PR | 🟢 10.7k ★, Google, Apache 2.0, 1600+ repos usando a Action, SLSA 3, v2.4.0 (jun/2026) |

**Análise:** dupla consagrada na literatura de 2026: Renovate mantém dependências actuais via PRs; OSV-Scanner é o gate de vulnerabilidades com maior precisão em benchmarks (matching por versão nativa do ecossistema). Zero overlap com o sistema e entre si. Nota: Renovate é AGPL-3.0 — irrelevante para uso como ferramenta (só afectaria quem redistribui o Renovate modificado).

**Recomendação: adicionar ao kit.** Templates `renovate.json` (preset conservador: agrupamento, schedule, automerge só de patches com CI verde) e workflow `osv-scanner.yml` em `sdd-kit/templates/`, activados por perfil no `install.sh` (APP completo; DOCS_SPECS só OSV-Scanner se houver lockfile).

---

## Síntese — kit vs correcção manual

```
                          ADICIONAR AO KIT          CORRECÇÃO MANUAL           NÃO ADOPTAR AGORA
                          ┌──────────────────┐      ┌────────────────────┐     ┌─────────────────┐
                          │ G2 TDD Guard     │      │ G1 workflow CI     │     │ G6 Vibe Kanban  │
                          │    (módulo APP)  │      │    sdd-gates.yml   │     │    (órfão)      │
                          │ G8 Renovate +    │      │ G4 sdd-metrics.sh  │     │ G4 DevLake      │
                          │    OSV-Scanner   │      │ G5 campo Issue no  │     │    (overkill)   │
                          │ G5 github-mcp    │      │    proposal.md     │     │ G3 Sentry       │
                          │    (infra.md)    │      │ G7 skill           │     │    self-hosted  │
                          └──────────────────┘      │    correctness-    │     │    (pesado)     │
                                                    │    review          │     └─────────────────┘
                          G3 GlitchTip/Sentry MCP   └────────────────────┘
                          → documentar como módulo
                            sob demanda (como Figma MCP)
```

**Ordem de implementação sugerida** (menor esforço/maior retorno primeiro):

1. **G1** — workflow `sdd-gates.yml` (só orquestra comandos existentes)
2. **G7 fase 1** — skill `correctness-review` (padrão já estabelecido pelas skills existentes)
3. **G5** — github-mcp-server no `infra.md` + campo Issue no template de proposal
4. **G8** — templates Renovate + OSV-Scanner no sdd-kit
5. **G2** — módulo TDD Guard (requer teste de integração com hooks GitNexus/Graphify antes de entrar no MANIFEST)
6. **G4** — `scripts/sdd-metrics.sh`
7. **G3/G6** — apenas documentação (módulos sob demanda / reavaliação futura)

Cada item 1–6 é candidato a change OpenSpec próprio (tipo C/D conforme o caso).

## Riscos transversais

- **Empilhamento de hooks (G2):** TDD Guard, GitNexus e Graphify partilham PreToolUse; validar latência acumulada e ordem de execução antes de promover ao MANIFEST.
- **Governança em transição (G7):** PR-Agent mudou de dono em abr/2026; pin de versão obrigatório e reavaliação no próximo upgrade do kit.
- **Custo LLM (G2, G7):** TDD Guard e PR-Agent consomem chamadas de modelo por validação/review — orçar antes de activar por defeito.
- **Perfil do repo:** nada de G2/G8-Renovate se aplica a este repo (DOCS_SPECS); os módulos servem os repos de produção que consomem o sdd-kit.

## Fontes consultadas

- Gaps: análise da sessão anterior sobre `AGENTS.md`, `openspec/infra.md`, `doc/sistema-sdd-pedro.md` §3–§5, `doc/avaliacoes/`
- TDD Guard: [github.com/nizos/tdd-guard](https://github.com/nizos/tdd-guard) (2.2k ★, MIT, v1.7.0 jun/2026; npm ~18.5k downloads/semana)
- PR-Agent: [github.com/qodo-ai/pr-agent](https://github.com/qodo-ai/pr-agent) (12.1k ★, v0.39.0 jul/2026); anúncio de transferência comunitária Qodo (abr/2026)
- Apache DevLake: [devlake.apache.org](https://devlake.apache.org/) (Apache TLP out/2025, 3.1k ★, 200 contribuidores)
- Renovate: [github.com/renovatebot/renovate](https://github.com/renovatebot/renovate) (22k ★, Mend, 62k installs do app GitHub)
- OSV-Scanner: [github.com/google/osv-scanner](https://github.com/google/osv-scanner) (10.7k ★, Google, 1600+ repos na Action, v2.4.0 jun/2026)
- github-mcp-server: [github.com/github/github-mcp-server](https://github.com/github/github-mcp-server) (oficial, v1.7.0, spec MCP stateless jul/2026)
- GlitchTip vs Sentry: comparativos de self-hosting 2026 (glitchtip.com; ossalt.com; selfhosting.sh)
- Vibe Kanban: [vibe-kb.com](https://vibe-kb.com/) (Apache 2.0; BloopAI encerrada abr/2026, manutenção comunitária)
- Hooks/CI enforcement: comparativos pre-commit vs Lefthook 2026; consenso de que enforcement pertence ao CI (`--no-verify` bypassa hooks locais)

## Session Handoff

Esta fase (explore) terminou. Para implementar qualquer item, abrir novo chat com:

---
/opsx:propose <item da ordem de implementação — ex.: "add-sdd-ci-gates-workflow">

Change base: openspec/changes/explore-oss-coverage-gaps/ (ler research.md)
Infra: openspec/infra.md (assumir ✅ — não reinstalar)
---
