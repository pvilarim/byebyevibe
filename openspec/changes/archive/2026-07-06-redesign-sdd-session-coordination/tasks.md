# Tasks — redesign-sdd-session-coordination

## 1. Liveness real para sessões apply (Decisão 1, design.md)

- [x] 1.1 `sdd-session-lib.sh`: expor `lock_holder_pid` após `sdd_session_start_lock_holder()` (variável global `LOCK_HOLDER_PID` lida pelo chamador)
  - **Pattern:** `sdd-kit/templates/scripts/sdd-session-lib.sh` (função sdd_session_start_lock_holder)
  - **Invariants:** spec `sdd-session-coordination` — Requirement: Session presence registry
  - **Gate:** `bash sdd-kit/templates/scripts/sdd-session-register.sh --phase apply --change-id test; grep -q lock_holder_pid .sdd/runtime/sessions/*.json`

- [x] 1.2 `sdd-session-register.sh`: gravar `lock_holder_pid` no JSON da sessão (via `SDD_LOCK_HOLDER_PID` exportado antes de `sdd_session_write_json`); lock adquirido **antes** de escrever o ficheiro de sessão (nada para limpar em caso de falha)
  - **Pattern:** `sdd-kit/templates/scripts/sdd-session-register.sh`
  - **Gate:** revisão manual — `lock_holder_pid` presente e distinto de `pid` no JSON gerado

- [x] 1.3 `sdd-session-check.sh`: para sessões `phase: apply` de outra sessão, decidir conflito por liveness de `lock_holder_pid` (não por heartbeat/TTL)
  - **Pattern:** `sdd-kit/templates/scripts/sdd-session-check.sh` (loop de conflito)
  - **Invariants:** spec — Requirement: Local apply lock per worktree, Scenario "Orphaned apply session does not block"
  - **Gate:** matar processo do lock holder, confirmar que `check.sh --phase apply` já não bloqueia mesmo com heartbeat fresco

- [x] 1.4 ~~`sdd-session-check.sh`: manter critério heartbeat+PID para explore/propose~~ — **revisto:** `check.sh` já retorna `exit 0` imediatamente para `phase != apply` (nunca escaneou outras sessões nesse caso); não havia comportamento a preservar. Staleness informativa de explore/propose continua só em `sdd-session-status.sh` (display, não bloqueio).

## 2. Identificação explícita de sessão (Decisão 2)

- [x] 2.1 `sdd-session-register.sh`: emitir `session_id` em formato parseável (`SESSION_ID=<uuid>` em stdout; log humano movido para stderr)
  - **Gate:** `bash .../sdd-session-register.sh --phase explore --change-id test | grep -q '^SESSION_ID='`

- [x] 2.2 `sdd-session-check.sh`, `sdd-session-heartbeat.sh` e `sdd-session-release.sh`: aceitar `--session-id <id>`; usar em preferência a `current-session.id` (estendido a `check.sh` além do previsto — sem isso, a auto-identificação de uma sessão apply continua vulnerável ao ponteiro partilhado ser sobrescrito por outra sessão registada depois)
  - **Invariants:** spec — Requirement: Explicit session identification
  - **Gate:** duas sessões na mesma worktree; `release.sh --session-id <A>` remove só o ficheiro de A e não mata o lock holder de B (se B for apply)

- [x] 2.3 Fallback: manter `current-session.id`, mas emitir `WARN` quando usado com mais de um ficheiro de sessão activo na worktree (`sdd_session_warn_if_shared_pointer_ambiguous`)
  - **Gate:** revisão manual

- [x] 2.4 Actualizar `.cursor/rules/016-session-coordination.mdc` para capturar e propagar `--session-id`
  - **Pattern:** `sdd-kit/templates/.cursor/rules/016-session-coordination.mdc`
  - **Gate:** `grep -q 'session-id' .cursor/rules/016-session-coordination.mdc`
  - **Nota de escopo:** skill `openspec-apply-change` (`.cursor/skills/`, `.claude/skills/`) **não** foi tocada — é artefacto gerado/sobrescrito pelo `openspec init`/upgrade, fora do payload distribuído pelo `sdd-kit` (mesma fronteira já aplicada aos findings do Bugbot #3/#4 em `ai-comunication#1`).

## 3. `verify-infra.sh` actualiza `infra.md` (Decisão 3)

- [x] 3.1 Adicionar marcadores `<!-- session-status -->...<!-- /session-status -->` à secção "Session Coordination" de `sdd-kit/templates/openspec/infra.md` (e ao `openspec/infra.md` próprio do hub)
  - **Gate:** `grep -q 'session-status' sdd-kit/templates/openspec/infra.md`

- [x] 3.2 `verify-infra.sh`: chamar `replace_between` para o marcador `session-status` com `$SESSION_STATUS`
  - **Pattern:** `scripts/verify-infra.sh` (bloco replace_between para openspec/gitnexus/graphify)
  - **Invariants:** spec — Requirement: Infra manifest reflects session coordination status
  - **Gate:** `bash sdd-kit/verify.sh && grep -A2 'Session Coordination' openspec/infra.md | grep -q '✅\|❌'`

## 4. Fecho

- [x] 4.1 Sincronizar cópias root `scripts/*.sh` com `sdd-kit/templates/scripts/*.sh`
  - **Gate:** `diff -q scripts/sdd-session-check.sh sdd-kit/templates/scripts/sdd-session-check.sh` (e demais scripts alterados)

- [x] 4.2 Bump `sdd-kit/MANIFEST.yaml` + guia + `openspec/project.md`/`infra.md` para **1.3.3** (assinatura de `check.sh`/`heartbeat.sh`/`release.sh` ganha `--session-id` opcional — aditivo, não breaking)

- [x] 4.3 Entrada no changelog do guia (§14) documentando o redesenho

- [x] 4.4 `bash sdd-kit/verify.sh` limpo, exceto GitNexus (bloqueado pela rede do ambiente) e Graphify (este clone nunca correu `graphify update .` — não relacionado à mudança). `verify-task-patterns.sh` e `sdd-session-status.sh` ✅; "Session coordination" ✅.

- [x] 4.5 `/opsx:sync` para promover este delta spec a `openspec/specs/sdd-session-coordination/spec.md`, depois `/opsx:archive` (manual, equivalente ao workflow: spec principal fundido, change movido para `archive/2026-07-06-...`)

## 5. Fixes pós-review (Cursor Bugbot, PR #19, high effort)

- [x] 5.1 `sdd-session-register.sh`: `trap 'sdd_session_stop_lock_holder' EXIT` entre adquirir o lock e completar o registo (write_json + ponteiro) — se algo falhar nesse intervalo, o lock é libertado em vez de ficar órfão sem session file correspondente. Trap limpo (`trap - EXIT`) após sucesso.
  - **Gate:** injectar falha (python3 indisponível) após lock adquirido; confirmar que nenhum processo `flock`/`sleep 3600` sobrevive ao `register.sh` que falhou
- [x] 5.2 `sdd-session-lib.sh`: novo helper `sdd_session_has_other_apply_session` (scan de session-files com phase=apply na mesma worktree, excluindo um id opcional)
- [x] 5.3 `sdd-session-release.sh`: critério de `stop_lock_holder` trocado de "fase da sessão libertada" para "nenhuma OUTRA sessão apply resta registada" — cobre tanto o caso normal (libertar a própria apply) como o lock verdadeiramente órfão (sem session file, sem ponteiro), sem nunca afectar uma sessão apply diferente ainda activa
  - **Gate:** testado manualmente — release de explore B não mata lock de apply A; release de A mata o próprio lock; `release.sh` sem argumentos com lock genuinamente órfão (session file e ponteiro ausentes) liberta-o correctamente
