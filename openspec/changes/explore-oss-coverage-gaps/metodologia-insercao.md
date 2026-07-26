# Metodologia de inserção de ferramentas no sistema SDD

| Campo | Valor |
|-------|-------|
| **Data** | 2026-07-25 |
| **Change** | `explore-oss-coverage-gaps` (tipo E — artefacto de exploração) |
| **Objectivo** | Definir critérios e etapas padronizadas para inserir cada ferramenta recomendada em `research.md` no sistema SDD, sem criar incompatibilidades, overlap ou fricção no fluxo explore→propose→apply |
| **Base** | Estende o rito já existente: `doc/avaliacoes/TEMPLATE.md` + precedente do módulo UI (`add-sdd-ui-development-module`) + R7/R10/R11 de `AGENTS.md` |

## Princípios

1. **Uma ferramenta = um change OpenSpec** (R7). Nada entra no kit sem propose → apply → archive próprios.
2. **Out-of-band por defeito.** Automação nova vai para CI/PR/scheduled sempre que possível — a pipeline interactiva explore→propose→apply **não ganha etapas novas** para o utilizador. Só entra "in-band" (dentro da sessão) o que precisa de interceptar edições (caso único: Probity (G2)), e sempre desligável via globs/uninstall.
3. **Reutilizar mecanismos de descoberta existentes** (guia SDD §4.2): AGENTS.md declara, hooks interceptam, skill descriptions auto-invocam. Nenhum mecanismo novo de descoberta.
4. **Reversibilidade obrigatória.** Sem plano de desinstalação documentado, a ferramenta não entra no MANIFEST.

---

## Fase 0 — Pré-verificação (antes do propose)

Responde à questão: *o que verificar antes de implementar para evitar incompatibilidades, bugs e overlap?*

### 0.1 Verificações no sistema existente

| # | Verificação | Como | Bloqueia se |
|---|-------------|------|-------------|
| V1 | Já instalado ou avaliado? | `openspec/infra.md` (R10) + índice `doc/avaliacoes/` | Descartado sem nova condição de reavaliação |
| V2 | Matriz de superfícies de contacto | Mapear qual superfície a ferramenta ocupa: git hooks · PreToolUse hooks · MCP servers · skills · scripts · CI workflows · templates de artefactos | Superfície já ocupada por componente equivalente (ex.: 3.º gestor de git hooks) |
| V3 | Colisão de artefactos/nomes | Ficheiros que a ferramenta cria/lê vs existentes (precedente: `design.md` vs `DESIGN.md` no módulo UI) | Colisão sem mitigação de disambiguação |
| V4 | Perfil de repo | Aplica-se a APP, DOCS_SPECS ou ambos? | — (define flag no install.sh) |
| V5 | Empilhamento de hooks | Se usa PreToolUse: medir latência acumulada com GitNexus + Graphify activos | Latência tornar o apply impraticável |

### 0.2 Verificações na ferramenta

| # | Verificação | Critério de aceitação |
|---|-------------|----------------------|
| F1 | Segurança | Advisories consultados (regra 050); versão **pinada** no install; tokens com menor escopo possível (ex.: github-mcp com `--toolsets issues` e read-only onde couber) |
| F2 | Licença | Compatível com uso interno; registar se AGPL (só afecta redistribuição modificada) |
| F3 | Governança viva | Release nos últimos 6 meses + mantenedores identificáveis (critério 5 do research) |
| F4 | Reversibilidade | Config declarativa versionável + caminho de desinstalação limpo |
| F5 | Operabilidade | Toggle on/off · dry-run · logs legíveis — pelo menos 2 dos 3 |

### 0.3 Pesquisa prévia para facilidade de uso

- Config mínima funcional documentada (copiar da doc oficial, não inventar)
- Relatos de integração com Claude Code/Cursor (hooks, MCP) — como outros resolveram
- Custo por operação: tokens LLM (Probity (G2), reviews) e minutos de CI (scanners) — orçar antes de ligar por defeito
- Modos de falha conhecidos (issues abertas recorrentes) e como o sistema se comporta se a ferramenta cair (fail-open vs fail-closed — gates de CI devem ser fail-closed; conveniências in-band, fail-open)

**Output da Fase 0:** avaliação preenchida em `doc/avaliacoes/<data>-<nome>.md` (TEMPLATE.md), com decisão "Em avaliação" → "Adoptado" só após Fase 2.

---

## Fase 1 — Propose

- `/opsx:propose add-<ferramenta>` — proposal, design e tasks.
- `design.md` obrigatoriamente contém: decisão de modo de acionamento (ver Fase 3), matriz tipo-de-tarefa (ver Fase 4), plano de rollback, e citação das fontes (R8) — incluindo `research.md` e a avaliação da Fase 0.
- Delta spec apenas se a ferramenta cria requisito normativo novo (ex.: "todo PR MUST passar OSV-Scanner").

## Fase 2 — Piloto (apply controlado)

> **Excepção aprovada (2026-07-25):** o piloto é **dispensável** quando a inserção não instala binário novo nem hook — i.e., apenas orquestra comandos já existentes no repo (ex.: G1 `sdd-gates.yml`) ou adiciona documentação/template de config inerte. Nesses casos, Fase 1 → Fase 3 directo. Qualquer ferramenta com hook, binário, serviço ou consumo de LLM mantém piloto obrigatório.

- Apply com R11 (register/check/release) num **worktree ou repo piloto**, nunca directo em todos os repos.
- **Critérios de sucesso quantificados ANTES do piloto.** Exemplos: Probity (G2) — latência extra p95 < Xs por edit e < Y% de bloqueios falsos; correctness-review — pelo menos 1 achado válido a cada N reviews; Renovate — volume de PRs gerível com o preset conservador.
- Janela de validação definida (ex.: N changes ou N PRs processados pela ferramenta).
- Falhou os critérios → decisão volta a "Adiado" com condições de reavaliação; artefactos removidos (rollback testado de graça).

## Fase 3 — Registro (contrato de 6 pontos)

Responde à questão: *como registrar instruções para o utilizador saber usar a ferramenta no fluxo?*

Toda ferramenta aprovada regista-se em **6 pontos** — nem mais (context rot), nem menos (agente não descobre):

| # | Onde | O quê | Para quem |
|---|------|-------|-----------|
| R1 | `openspec/infra.md` | Linha: versão pinada + estado + "verificar com" | Agente (R10) |
| R2 | `AGENTS.md` | ≤10 linhas em Integrações + linha em "Contexto sob demanda" + comando na tabela Commands | Agente (sempre em contexto) |
| R3 | Skill (`.claude/skills/` + espelho `.cursor/skills/`) ou rule `.mdc` | Detalhe operacional; description diz **quando auto-invocar**; rule só se always-on | Agente (lazy load) |
| R4 | `doc/sistema-sdd-pedro.md` §nova | Operação humana: quando acionar, como ler o output, como desligar, troubleshooting | Humano |
| R5 | `doc/avaliacoes/<data>-<nome>.md` | Decisão "Adoptado" + condições de reavaliação | Histórico |
| R6 | `sdd-kit/` | Template de config + install/uninstall no script do módulo + MANIFEST bump + check no `verify.sh` | Reprodução |

Pós-registro obrigatório: `graphify update .` + `npx gitnexus analyze --force` — sem isto o knowledge graph não conhece a ferramenta e os agentes não a encontram nas fontes 3–5.

Anti-padrões (herdados de §2.5.1 do guia): não colar blocos gerados pela ferramenta no AGENTS.md canónico; não duplicar a skill no guia; não criar rule always-on para ferramenta sob demanda.

---

## Fase 4 — Acionamento e integração no fluxo

### 4.1 Modos de acionamento (questão 3)

Três modos, todos já existentes no sistema — nenhuma ferramenta cria um quarto:

| Modo | Descrição | Precedente existente |
|------|-----------|---------------------|
| **A — Automático out-of-band** | CI/PR/scheduled; corre fora da sessão do agente | (novo, mas padrão da indústria) |
| **B — Automático in-band** | Hook intercepta acções durante a sessão | PreToolUse GitNexus/Graphify |
| **C — Sob demanda** | Utilizador ou agente invoca skill/comando | `simplify-review`, `security-reviewer`, `/opsx:*` |
| **D — Passivo (MCP)** | Disponível; agente consulta quando relevante | GitNexus MCP, Graphify MCP |

Matriz por ferramenta do research:

| Ferramenta | Modo | Quem aciona | Em que etapa |
|------------|------|-------------|--------------|
| `sdd-gates.yml` (G1) | A | push/PR (automático) | Pós-apply, pré-merge |
| OSV-Scanner (G8) | A | PR (automático) | Pré-merge |
| Renovate (G8) | A | Scheduled (bot) | Fora da pipeline; PRs gerados entram como tarefas tipo A/B |
| Probity (G2) | B | Hook (automático) | Durante apply; **desligar** via globs/uninstall em tipo A e docs |
| `correctness-review` (G7) | C | Utilizador (ou agente, por gatilho de diff) | Pós-apply, antes do commit — mesma posição do `simplify-review` |
| `sdd-metrics.sh` (G4) | C | Utilizador (periódico/retrospectiva) | Fora da pipeline |
| github-mcp-server (G5) | D | Agente consulta | Explore (ler issues) e propose (ligar change ↔ issue) |

**Resposta directa:** só Probity (G2) é automático dentro da sessão. CI/bots são automáticos fora dela. Reviews e métricas são comandos do utilizador. MCP é passivo. O utilizador só "aciona" manualmente duas coisas: reviews pós-apply e métricas.

### 4.2 Impacto na pipeline e selectividade (questão 4)

**A pipeline explore→propose→apply NÃO ganha etapas interactivas novas.** O que muda é o que acontece *depois do push* (gates de CI) e *em paralelo* (bots). A única fricção in-band (Probity (G2)) é desligável e restrita a código.

Nem todas as ferramentas em todos os casos — a matriz segue a classificação A–E já existente:

| Tipo de tarefa | Probity (G2) | correctness-review | sdd-gates (CI) | OSV/Renovate | github-mcp |
|----------------|-----------|-------------------|----------------|--------------|------------|
| A — Trivial | off | não | roda (passa rápido) | contínuo* | não |
| B — Bug fix | **on** (materializa R6) | se diff > ~80 linhas | roda | contínuo* | ler issue de origem |
| C — Refactor | on | **sim** | roda | contínuo* | opcional |
| D — Feature | on | **sim** | roda | contínuo* | issue → proposal |
| E — Exploração | n/a (sem código) | n/a | valida artefactos | contínuo* | ler issues no research |

\* Renovate/OSV são independentes da classificação — operam sobre o repo, não sobre a tarefa.

**Como decidir quando usar:** não se cria heurística nova. Reutilizam-se as que já existem:

- Classificação A–E (R1) decide Probity (G2) on/off (globs/desligar módulo) e profundidade de review — o mesmo gate que já decide se há proposta OpenSpec.
- O gatilho do `simplify-review` (diff > ~80 linhas ou > 4 ficheiros) estende-se ao `correctness-review` — mesma tabela em AGENTS.md "Reviews pós-implementação".
- Ordem de reviews actualizada: implementação → testes (R6/Probity enforceTdd) → `correctness-review` → `simplify-review` (opcional) → `security-reviewer` (se aplicável) → commit → gates de CI.

**Integração com fluxos por tipo:**

- **Bug (tipo B):** github-mcp lê o issue no framing; Probity (G2) força o teste-que-falha (R6 deixa de ser regra de papel); OSV cobre o caso de bug ser vulnerabilidade de dependência.
- **Feature (tipo D):** github-mcp liga issue → proposal no propose; Probity (G2) + correctness-review no apply; gates de CI validam o change antes do merge.
- **Exploração (tipo E):** só github-mcp (contexto de issues) — nenhuma ferramenta de código toca o fluxo.

---

## Fase 5 — Operação e reavaliação contínua

- **Métricas de adopção** (liga ao G4): a ferramenta está a ser usada? Taxa de falsos positivos? Custo real vs orçado? `sdd-metrics.sh` incorpora contadores por ferramenta quando existir.
- **Reavaliação semestral** ou no upgrade do kit — o que ocorrer primeiro. Especial atenção a ferramentas com governança em transição (PR-Agent) ou nicho (GlitchTip MCP beta).
- **Critérios de sunset:** 2 ciclos sem uso registado, ou custo > valor observado, ou projecto upstream órfão → change de remoção + avaliação actualizada para "Descartado" com condições de reabertura.

---

## Abordagens adicionais incluídas (questão 5 — o que faltava)

Itens não cobertos nas 4 questões originais, incorporados acima:

1. **Rollback/desinstalação** como pré-condição de entrada no MANIFEST (F4, R6 do contrato, Fase 2).
2. **Piloto com critérios de sucesso quantificados** antes da promoção ao kit — pesquisa → kit directo é proibido (Fase 2).
3. **Orçamento de custo** (tokens LLM + minutos CI) por ferramenta, antes de ligar por defeito (0.3).
4. **Vetting de segurança da própria ferramenta** — pin de versão, advisories, escopo mínimo de tokens (F1).
5. **Critérios de sunset/reavaliação** — inserção sem plano de saída é dívida (Fase 5).
6. **Ordem e dependências de instalação** — ex.: G1 (workflow CI) antes de G8 (OSV entra nesse CI); G5 antes de G7-fase-2 (PR-Agent usa contexto de issues).
7. **Actualização dos grafos pós-install** — `graphify update .` + `gitnexus analyze`; sem isto a ferramenta é invisível para os agentes (Fase 3).
8. **Separação agente vs humano no registro** — AGENTS.md/skills instruem o agente; guia SDD instrui o humano; são audiências distintas com documentos distintos (contrato de 6 pontos).
9. **Comportamento em falha** — fail-closed para gates de CI, fail-open para conveniências in-band (0.3).
10. **Matriz de perfil de repo** (APP vs DOCS_SPECS) como flag do install.sh, não como decisão ad-hoc por instalação (V4).

## Session Handoff

Fase explore concluída. Para aplicar a metodologia à primeira ferramenta:

---
/opsx:propose add-sdd-ci-gates-workflow

Ler: openspec/changes/explore-oss-coverage-gaps/research.md (G1)
     openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md (Fases 0–3)
     doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md (decisões registadas)
Infra: openspec/infra.md (assumir ✅ — não reinstalar)
Nota: G1 qualifica para a excepção de piloto (sem binário/hook novo) — Fase 1 → Fase 3 directo.
---
