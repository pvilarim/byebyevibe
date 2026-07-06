# Proposal — Redesenho da coordenação de sessões SDD

## Why

A revisão do Cursor Bugbot no consumidor `pvilarim/ai-comunication#1` (3 rondas, incluindo uma passagem *high effort*) encontrou uma série de bugs interligados em `scripts/sdd-session-*.sh` que, corrigidos isoladamente, continuam a gerar novos findings a cada push. Investigação confirmou que não são bugs independentes: partilham uma causa raiz de design.

**Causa raiz:** `sdd-session-register.sh` grava `SDD_PID="$$"` — o PID do próprio processo `register.sh`, que termina milissegundos depois (a última linha do script é um `echo`). O `pid` persistido no ficheiro de sessão está morto quase instantaneamente. `sdd-session-check.sh` usa esse `pid` para decidir se uma sessão está "viva", o que é estruturalmente incorrecto.

Isto explica três findings já reportados:

1. **Sessões órfãs bloqueiam apply por até 5 minutos** mesmo com o lock livre — o heartbeat pode estar fresco (o agente ainda está a chamar `sdd-session-heartbeat.sh`), mas o `pid` gravado nunca corresponde a um processo vivo relevante, tornando o critério de liveness baseado em PID inútil na prática.
2. **`current-session.id` é um ponteiro global único** — uma segunda sessão registada na mesma worktree sobrescreve-o. `sdd-session-release.sh` e `sdd-session-heartbeat.sh` (invocados sem argumento) passam a apontar para a sessão errada. Se o `apply` lock falhar ao adquirir, o ponteiro é limpo mas a sessão activa original (e o seu lock) fica sem forma de gestão.
3. **`verify-infra.sh` não escreve o estado de "Session Coordination" em `openspec/infra.md`** — o script imprime o resultado na consola mas a secção do manifesto fica sempre desactualizada, criando divergência entre o que `verify.sh` diz e o que o documento reporta.

Já foi aplicado um fix defensivo em `sdd-session-check.sh` (v1.3.2) para o gap lógico mais óbvio (heartbeat expirado + PID vivo não bloqueava) — mas esse fix é paliativo: como o `pid` gravado é sempre o do `register.sh` (morto), o ramo "PID vivo" praticamente nunca dispara. O problema substantivo é a **semântica do PID rastreado**, não a lógica condicional em torno dele.

Corrigir isto direito exige decisões de arquitetura (que sinal de liveness usar, como identificar a sessão corrente sem ponteiro global partilhado, e se o próprio `flock` já é a fonte de verdade suficiente) — não mais patches pontuais em `check.sh`.

## What Changes

- **Sinal de liveness para sessões apply**: substituir o `pid` do `register.sh` (sempre morto) pelo PID do *lock holder* em background (`LOCK_HOLDER_PID_FILE`), que vive durante toda a duração da sessão apply. Ver `design.md` para alternativas consideradas.
- **Identificação de sessão sem ponteiro global partilhado**: `register.sh` passa a devolver o `session_id` de forma que o chamador (agente) o capture e reenvie explicitamente a `sdd-session-heartbeat.sh --session-id <id>` e `sdd-session-release.sh --session-id <id>`. `current-session.id` mantém-se como fallback de conveniência para o caso de sessão única, com aviso claro quando usado.
- **Detecção de conflito simplificada para apply**: aproveitar que só pode existir um `apply.lock` por worktree — a existência de um lock holder vivo é suficiente para reportar conflito, sem heurísticas de heartbeat/TTL para esse caso. Heartbeat/TTL mantêm-se como sinal para fases sem lock holder (explore/propose, uso advisory) e para limpeza de sessões verdadeiramente órfãs (crash sem `release`).
- **`verify-infra.sh` actualiza `openspec/infra.md`**: a secção "Session Coordination" passa a reflectir o resultado real do check, com o mesmo mecanismo de marcadores `<!-- ... -->` já usado para OpenSpec/GitNexus/Graphify.
- Actualizar spec `sdd-session-coordination` (delta neste change) para tornar estes comportamentos normativos, e bump de versão do kit após implementação.

## Impact

- **Affected specs:** `sdd-session-coordination` (requirements alterados/adicionados).
- **Affected code:** `sdd-kit/templates/scripts/sdd-session-register.sh`, `sdd-session-check.sh`, `sdd-session-heartbeat.sh`, `sdd-session-release.sh`, `sdd-session-lib.sh`, `verify-infra.sh` (+ cópias root em `scripts/`); `.cursor/rules/016-session-coordination.mdc`; skills `openspec-apply-change` (chamada dos scripts com `--session-id` explícito).
- **Compat:** mudança de assinatura (`--session-id` novo argumento opcional/recomendado) é aditiva; `current-session.id` continua a existir como fallback, então repos já instalados na v1.3.2 não quebram até fazerem upgrade — mas devem correr `sdd-kit/upgrade.sh` para obter o fix de liveness real.
- **Não incluído neste change:** os findings do Bugbot sobre `.cursor/skills/openspec-archive-change/SKILL.md` (ignora "Cancel") e `/opsx:continue` inexistente — são artefactos gerados pelo `openspec init` (ferramenta OpenSpec upstream), fora do escopo do `sdd-kit`.
