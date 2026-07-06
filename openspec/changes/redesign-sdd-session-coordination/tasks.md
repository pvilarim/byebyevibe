# Tasks — redesign-sdd-session-coordination

## 1. Liveness real para sessões apply (Decisão 1, design.md)

- [ ] 1.1 `sdd-session-lib.sh`: expor `lock_holder_pid` após `sdd_session_start_lock_holder()` (ler `LOCK_HOLDER_PID_FILE` logo após criar o holder)
  - **Pattern:** `sdd-kit/templates/scripts/sdd-session-lib.sh` (função `sdd_session_start_lock_holder`)
  - **Invariants:** spec `sdd-session-coordination` — Requirement: Session presence registry
  - **Gate:** `bash sdd-kit/templates/scripts/sdd-session-register.sh --phase apply --change-id test 2>&1; test -f .sdd/runtime/sessions/*.json && grep -q lock_holder_pid .sdd/runtime/sessions/*.json`

- [ ] 1.2 `sdd-session-register.sh`: gravar `lock_holder_pid` no JSON da sessão (via `SDD_LOCK_HOLDER_PID` exportado antes de `sdd_session_write_json`)
  - **Pattern:** `sdd-kit/templates/scripts/sdd-session-register.sh` (bloco `if [[ "$PHASE" == "apply" ]]`)
  - **Gate:** revisão manual — `lock_holder_pid` presente e distinto de `pid` no JSON gerado

- [ ] 1.3 `sdd-session-check.sh`: para sessões `phase: apply` de outra sessão, decidir conflito por liveness de `lock_holder_pid` (não por heartbeat/TTL)
  - **Pattern:** `sdd-kit/templates/scripts/sdd-session-check.sh` (loop de conflito, ~L43-77)
  - **Invariants:** spec — Requirement: Local apply lock per worktree, Scenario "Orphaned apply session does not block"
  - **Gate:** teste manual — matar processo do lock holder, confirmar que `check.sh --phase apply` já não bloqueia mesmo com heartbeat fresco

- [ ] 1.4 `sdd-session-check.sh`: manter critério heartbeat+PID (do `pid` de invocação, não lock holder) só para `explore`/`propose`
  - **Gate:** revisão manual do ramo correspondente

## 2. Identificação explícita de sessão (Decisão 2)

- [ ] 2.1 `sdd-session-register.sh`: emitir `session_id` em formato parseável (`SESSION_ID=<uuid>` em stdout)
  - **Gate:** `bash .../sdd-session-register.sh --phase explore --change-id test | grep -q '^SESSION_ID='`

- [ ] 2.2 `sdd-session-heartbeat.sh` e `sdd-session-release.sh`: aceitar `--session-id <id>`; usar em preferência a `current-session.id`
  - **Invariants:** spec — Requirement: Explicit session identification
  - **Gate:** duas sessões na mesma worktree; `release.sh --session-id <A>` remove só o ficheiro de A

- [ ] 2.3 Fallback: manter `current-session.id`, mas emitir `WARN` quando usado com mais de um ficheiro de sessão activo na worktree
  - **Gate:** revisão manual

- [ ] 2.4 Actualizar `.cursor/rules/016-session-coordination.mdc` e skill `openspec-apply-change` para capturar e propagar `--session-id`
  - **Pattern:** `sdd-kit/templates/.cursor/rules/016-session-coordination.mdc`
  - **Gate:** `grep -q 'session-id' .cursor/rules/016-session-coordination.mdc`

## 3. `verify-infra.sh` actualiza `infra.md` (Decisão 3)

- [ ] 3.1 Adicionar marcadores `<!-- session-status -->...<!-- /session-status -->` à secção "Session Coordination" de `sdd-kit/templates/openspec/infra.md`
  - **Gate:** `grep -q 'session-status' sdd-kit/templates/openspec/infra.md`

- [ ] 3.2 `verify-infra.sh`: chamar `set_marker`/equivalente para essa secção com `$SESSION_STATUS`
  - **Pattern:** `scripts/verify-infra.sh` (bloco `set_marker` para openspec/gitnexus/graphify)
  - **Invariants:** spec — Requirement: Infra manifest reflects session coordination status
  - **Gate:** `bash sdd-kit/verify.sh && grep -A2 'Session Coordination' openspec/infra.md | grep -q '✅\|❌'`

## 4. Fecho

- [ ] 4.1 Sincronizar cópias root `scripts/*.sh` com `sdd-kit/templates/scripts/*.sh`
  - **Gate:** `diff -q scripts/sdd-session-check.sh sdd-kit/templates/scripts/sdd-session-check.sh` (e demais scripts alterados)

- [ ] 4.2 Bump `sdd-kit/MANIFEST.yaml` + guia + `openspec/project.md`/`infra.md` (versão a definir conforme semver do kit — breaking na assinatura de `release.sh`/`heartbeat.sh` é aditivo, não breaking)

- [ ] 4.3 Entrada no changelog do guia (§14) documentando o redesenho

- [ ] 4.4 `bash sdd-kit/verify.sh` limpo (sem contar GitNexus, que é ambiente-dependente)

- [ ] 4.5 `/opsx:sync` para promover este delta spec a `openspec/specs/sdd-session-coordination/spec.md`, depois `/opsx:archive`
