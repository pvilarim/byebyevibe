# Design — Redesenho da coordenação de sessões SDD

## Contexto

Ver `proposal.md` para o diagnóstico completo. Este documento explora as opções para os três pontos de decisão que a proposta deixa em aberto.

## Decisão 1 — Sinal de liveness para sessões apply

**Problema:** o `pid` gravado em `.sdd/runtime/sessions/<id>.json` é o do processo `register.sh`, que sai imediatamente após escrever o ficheiro. Nunca representa um processo vivo relevante.

### Opção A — PID do lock holder (recomendada)

`sdd_session_start_lock_holder()` já cria um subshell em background que detém o `flock` exclusivo durante toda a sessão apply, com o seu PID em `LOCK_HOLDER_PID_FILE`. Gravar esse PID (não o de `register.sh`) no JSON da sessão como `lock_holder_pid`.

- **Prós:** processo genuinamente vivo durante toda a janela de risco; já existe, não requer novo mecanismo.
- **Contras:** só existe para fase `apply`; `explore`/`propose` continuam sem sinal de processo (aceitável — são advisory).

### Opção B — Heartbeat como único sinal (sem PID)

Abandonar verificação de PID; confiar inteiramente em `heartbeat_at` + TTL, assumindo que um agente activo chama `sdd-session-heartbeat.sh` periodicamente.

- **Prós:** simples, sem depender de semântica de processos.
- **Contras:** uma sessão morta sem `release` fica "viva" durante todo o TTL após o último heartbeat, mesmo que o lock já esteja livre (o inverso do bug actual: falsos negativos em vez de falsos positivos). Pior para o caso comum de crash.

### Opção C — O próprio `flock` como fonte de verdade

Para conflitos de apply na mesma worktree, não há ambiguidade possível: só pode existir um `apply.lock` detido de cada vez. Se outro ficheiro de sessão diz `phase: apply` para esta worktree e não é a sessão corrente, a única pergunta relevante é "o lock holder dessa sessão ainda está vivo?" — que é exactamente a Opção A aplicada como critério único (sem heartbeat/TTL a interferir).

**Recomendação:** combinar A + C — gravar `lock_holder_pid`; para conflitos de fase `apply`, `check.sh` decide por liveness do `lock_holder_pid` directamente (sem depender de heartbeat/TTL). Heartbeat/TTL mantêm-se para `explore`/`propose` (sem lock holder) e como rede de segurança para limpeza de `.sdd/runtime/sessions/*.json` órfãos independentemente da fase.

## Decisão 2 — Identificação de sessão sem ponteiro global partilhado

**Problema:** `current-session.id` é um único ficheiro por worktree; a segunda sessão registada sobrescreve o ponteiro da primeira. `heartbeat.sh`/`release.sh` sem argumento usam esse ponteiro — atingem a sessão errada quando há mais de uma sessão activa na mesma worktree (ex.: apply + explore em paralelo, ou um `release` em falta de uma sessão anterior).

### Opção A — `--session-id` explícito (recomendada)

`register.sh` já imprime `Registered session $SESSION_ID ...` — mudar para imprimir **apenas** o `session_id` em stdout (ou um formato parseável, ex. `SESSION_ID=<uuid>`), e exigir que quem invoca (a skill/regra do agente) capture esse valor e o passe explicitamente a `heartbeat.sh --session-id <id>` e `release.sh --session-id <id>`.

- **Prós:** elimina a ambiguidade estruturalmente; múltiplas sessões na mesma worktree deixam de colidir entre si nesses dois scripts.
- **Contras:** requer actualizar `016-session-coordination.mdc` e a skill `openspec-apply-change` para capturar e propagar o id; é uma mudança de contrato (aditiva, ver Impact na proposal).

### Opção B — Manter `current-session.id`, mas por-sessão

Nomear o ficheiro por PID do processo chamador (`current-session.<ppid>.id`) em vez de um único ficheiro.

- **Contras:** PID do agente/shell nem sempre é estável ou previsível entre chamadas (register → heartbeat → release podem correr em invocações de processo distintas dependendo de como o agente orquestra shell calls); frágil na prática.

**Recomendação:** Opção A, com `current-session.id` mantido apenas como fallback de conveniência (single-session, uso manual/humano) e aviso explícito quando `heartbeat.sh`/`release.sh` correm sem `--session-id`.

## Decisão 3 — `verify-infra.sh` e `openspec/infra.md`

Simples: replicar o padrão já usado para OpenSpec/GitNexus/Graphify — `set_marker` (ou equivalente) para os marcadores `<!-- session-status -->` na secção "Session Coordination" de `infra.md`, chamado a partir do bloco que já calcula `SESSION_STATUS`. Sem alternativas de design relevantes; é lacuna de implementação, não decisão de arquitetura.

## Não-decisões (fora de escopo deste change)

- Findings do Bugbot em artefactos gerados pelo `openspec init` (archive "Cancel", `/opsx:continue`) — pertencem ao OpenSpec upstream, não ao `sdd-kit`.
- Coordenação entre máquinas/CI (fora do propósito declarado de `sdd-session-coordination`: "na mesma máquina").
