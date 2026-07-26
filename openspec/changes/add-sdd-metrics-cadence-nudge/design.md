## Context

- `add-sdd-metrics-script` (G4) introduz `scripts/sdd-metrics.sh` modo **C**: relatório M1–M4 sob demanda; R3 N/A; DevLake fora de escopo; §2.17 cobre *quando correr* e *como ler*, mas **não** *como actuar* nem *quando lembrar*.
- Exploração (chat explore 2026-07-26): recomendação = playbook de interpretação + cadência event-driven no `/opsx:archive` + stamp stale 30d; adiar skill always-on e CI cron.
- Metodologia (`metodologia-insercao.md`): out-of-band por defeito; anti-padrão = rule always-on para ferramenta sob demanda; Fase 5 = operação/reavaliação contínua ligada a G4.
- `sdd-session-handoff`: skills de fase já emitem Session Handoff; archive é o momento natural (ciclo SDD completo).
- Runtime local já usa `.sdd/runtime/` (gitignored) — precedente para stamp em `.sdd/`. **Nota:** `.gitignore` actual cobre só `.sdd/runtime/`; este change MUST adicionar ignore para `.sdd/metrics-last-run` (ou `.sdd/` mais amplo).

**Pré-requisito de apply:** `scripts/sdd-metrics.sh` e §2.17 base presentes no hub (apply de `add-sdd-metrics-script`).

## Goals / Non-Goals

**Goals:**

- Playbook normativo: mapear M1–M4 → acções concretas de melhoria do processo SDD (1 insight → 1 ajuste).
- Cadência: nudge advisory quando ≥ **5** archives desde a última corrida **ou** ≥ **30** dias sem corrida.
- Stamp `.sdd/metrics-last-run` actualizado em cada run bem-sucedido do script (exit 0).
- Nudge apenas no Session Handoff de **archive** (e docs); modo C preservado — sugere, não executa, não bloqueia.

**Non-Goals:**

- Rule `.mdc` always-on ou skill dedicada que sugere métricas em todo chat.
- Job CI/cron que auto-corre o script ou abre issues (fase futura só se nudge falhar).
- Tornar métricas gate de `sdd-gates` ou etapa obrigatória de apply/archive.
- Contadores por ferramenta (Probity, OSV) — ainda Fase 5 futura.
- Apache DevLake.

## Knowledge sources consulted (R8)

- Explore session + recomendação: playbook + nudge archive + stale 30d
- `openspec/changes/add-sdd-metrics-script/{proposal,design}.md` — G4 modo C, §2.17, R3 N/A
- `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` §4.1 modo C, anti-padrão always-on, Fase 5
- `openspec/specs/sdd-session-handoff/spec.md` — Session Handoff obrigatório
- `.claude/skills/openspec-archive-change/SKILL.md` — ponto de inserção do nudge
- `doc/sistema-sdd-pedro.md` §2.17 (base G4) · §3.3 session coordination
- `.gitignore` / `.sdd/runtime/` — precedente stamp local

## Decisions

### D1: Playbook antes de qualquer mechanismo de lembrete

**Escolha:** alargar §2.17 com secção “Interpretar → actuar” (tabela M* → acção).

**Rationale:** sem playbook, nudge só gera relatórios mortos. Docs-first; zero runtime risk.

### D2: Cadência event-driven (archives) + stale calendário

| Sinal | Default | Comportamento |
|-------|---------|---------------|
| Archives desde last-run | ≥ 5 | Nudge no handoff de archive |
| Idade do stamp | ≥ 30 dias | Mesmo nudge |
| Sem stamp (nunca correu) | — | Nudge após ≥ 5 archives **ou** na primeira oportunidade de archive se o operador nunca correu (tratar “sem ficheiro” como stale infinito) |

**Alternativa descartada:** só cron mensal — desligado dos ciclos SDD; mais fricção operacional (CI/issue).

### D3: Stamp `.sdd/metrics-last-run` (não git)

**Formato (proposta):** ficheiro texto com ISO date `YYYY-MM-DD` na primeira linha (opcional: segunda linha = ISO datetime). Escrito pelo próprio `sdd-metrics.sh` no exit 0 path.

**Alternativa descartada:** commit de artefacto no repo — polui git; métricas são locais/operador.

**Confirmar:** `.sdd/` já gitignored no hub/kit.

### D4: Onde vive a lógica “should nudge?”

**Escolha:** função/helper bash pequeno — preferência:

1. Estender `sdd-metrics.sh` com subcomando ou flag `--check-cadence` (exit 0 = quiet; exit 1 = nudge recommended; stdout = mensagem curta), **ou**
2. Script irmão `scripts/sdd-metrics-cadence.sh` (só check).

**Preferência de apply:** **(1)** flag `--check-cadence` no mesmo script — menos superfície MANIFEST; R3 continua N/A.

Defaults N=5 e T=30 como constantes no topo do script (documentadas no guia).

### D5: Nudge só na skill archive (não propose/apply/explore)

**Escolha:** actualizar `## Session Handoff` em `openspec-archive-change` (`.claude/` + `.cursor/`): após archive bem-sucedido, correr `bash scripts/sdd-metrics.sh --check-cadence`; se exit ≠ 0, incluir bloco advisory no handoff (comando + link §2.17 playbook).

**Não** alterar explore/propose/apply handoffs (evita ruído).

### D6: R3 permanece N/A

Sem skill nova `sdd-metrics-review`. Descoberta continua AGENTS.md + guia; cadência = extensão da skill archive existente (já always-loaded só quando se faz archive).

### D7: Piloto

Mesma classe que G4 (bash local, sem binário/hook/LLM novo) → **excepção de piloto** aplicável; validação = correr `--check-cadence` + confirmar texto no handoff em dry-run mental / gate grep.

### D8: Dependência de apply

Se `add-sdd-metrics-script` ainda não estiver merged/aplicado no hub, **pausar** apply deste change até o script e §2.17 base existirem.

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| Nudge ignorado → métricas ainda mortas | Playbook torna o “porquê” claro; reavaliar issue mensal CI só se evidência de abandono |
| Contar “archives desde last-run” impreciso | Contar dirs em `openspec/changes/archive/` com data de pasta > data do stamp (determinístico) |
| Falso nudge em repos com muitos archives históricos e sem stamp | Sem stamp: só nudge se houver ≥ N archives **com data ≥ (hoje − T dias)** *ou* mensagem única “nunca correu — baseline?” no primeiro archive pós-install (documentar escolha no apply: preferir “nunca correu ⇒ nudge se archives_in_last_T_days ≥ 1” para onboarding suave) |
| Poluir Session Handoff (>15 linhas) | Nudge ≤ 5 linhas; handoff core intacto |
| Operador corre métricas noutro clone sem stamp partilhado | Aceitável — stamp é por worktree/máquina (como `.sdd/runtime/`) |

**Decisão de onboarding (sem stamp):** se ficheiro ausente **e** existe ≥ 1 archive com prefixo de data nos últimos T dias → nudge “baseline recomendada”; caso contrário silêncio (repo fresco / inactivo).

## Migration Plan

1. Merge/apply `add-sdd-metrics-script` no hub (pré-requisito).
2. Apply deste change: playbook §2.17 → flag `--check-cadence` + stamp → skill archive → AGENTS 1–3 linhas → deltas specs → checksums kit se template script mudar.
3. Consumidores C2: `upgrade.sh` recebe script actualizado.
4. Rollback: reverter skill archive + remover flag/stamp write; playbook docs pode ficar (inofensivo).

## Open Questions

| Pergunta | Resolução proposta |
|----------|-------------------|
| N e T configuráveis por env? | Não neste change — constantes no script; env opcional futuro |
| Espelhar skill só Claude ou também Cursor? | Ambos (paridade kit/skills) |
| Bump kit 1.6.0 → 1.6.1 ou 1.7.0? | **Patch 1.6.1** se G4 já lançou 1.6.0; senão incluir no mesmo minor se apply conjunto |
| Contar só archives no período T ou todos desde stamp? | **Desde stamp** (event-driven); T só para idade do stamp / onboarding |
