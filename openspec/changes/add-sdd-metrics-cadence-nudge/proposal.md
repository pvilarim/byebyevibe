## Why

O script `sdd-metrics.sh` (G4, modo C) já materializa medição de eficácia SDD, mas **descoberta passiva ≠ hábito**: sem playbook de interpretação e sem cadência, o relatório não fecha o loop “números → melhorar o framework”. A exploração concluiu que o buraco principal é (1) como actuar sobre M1–M4 e (2) um lembrete periódico ancorado em ciclos SDD (archives), com stale de calendário só como rede de segurança — sem rule always-on nem etapa obrigatória na pipeline.

**Objectivo:** formalizar playbook + nudge de cadência (event-driven no archive + stamp 30d), mantendo modo C opt-in.

**Pré-requisito:** apply/archive de `add-sdd-metrics-script` (script + §2.17 + spec `sdd-metrics` no hub). Este change **estende** G4; não o substitui.

## What Changes

- **Playbook de interpretação** em `doc/sistema-sdd-pedro.md` §2.17: tabela “se M1/M2/M3/M4 então → 1 ajuste concreto no processo SDD”; ritual mínimo (1 insight → 1 mudança).
- **Stamp local** `.sdd/metrics-last-run` (gitignored): escrito quando o operador corre `sdd-metrics.sh` (ou flag explícita); usado só para calcular stale.
- **Nudge advisory no Session Handoff de `/opsx:archive`**: se ≥ N archives desde a última corrida **ou** ≥ 30 dias sem corrida → sugerir `bash scripts/sdd-metrics.sh` + ponteiro ao playbook; **nunca** auto-executar; **nunca** bloquear archive.
- **Limiares documentados** (defaults: N=5 archives, T=30 dias) — ajustáveis via constantes no helper/docs, sem CI gate.
- **Non-goals:** rule always-on; skill que sugere métricas em todo chat; cron/CI scheduled que spam; tornar métricas etapa obrigatória de apply/archive; Apache DevLake.

## Capabilities

### New Capabilities

- _(nenhuma — extensão de G4 / handoff existentes)_

### Modified Capabilities

- `sdd-metrics`: playbook normativo de interpretação; stamp de última corrida; limiares de cadência; relatório/comando permanece modo C opt-in.
- `sdd-session-handoff`: Session Handoff pós-archive MUST incluir nudge de métricas quando limiares de cadência forem atingidos (advisory, não bloqueante).

## Impact

- Modificado: `doc/sistema-sdd-pedro.md` §2.17 (playbook + cadência)
- Modificado: `scripts/sdd-metrics.sh` (+ template kit) — gravar stamp em `.sdd/metrics-last-run` após run bem-sucedido
- Novo (pequeno): helper ou lógica partilhada para “deve nudgar?” (archives desde stamp / age do stamp) — preferir bash mínimo reutilizado pela skill archive
- Modificado: skills `openspec-archive-change` (`.claude/` + `.cursor/`) — secção Session Handoff com nudge condicional
- Modificado (leve): `AGENTS.md` / template — 1–3 linhas sobre cadência + playbook (sem skill nova always-on; R3 continua N/A para métricas como ferramenta)
- Possível: `.gitignore` já cobre `.sdd/` — confirmar; sem secrets no stamp
- Specs: deltas em `openspec/specs/sdd-metrics/` e `sdd-session-handoff/`
- **Dependência de merge:** `add-sdd-metrics-script` aplicado no hub antes deste apply
- **Issue:** —
