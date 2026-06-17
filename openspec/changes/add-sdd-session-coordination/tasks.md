# Tasks — add-sdd-session-coordination

## 1. Scripts de coordenação

- [x] 1.1 Criar `scripts/sdd-session-register.sh` (JSON + flock apply)
  - **Pattern:** `scripts/verify-infra.sh`
  - **Gate:** `test -x scripts/sdd-session-register.sh`

- [x] 1.2 Criar `scripts/sdd-session-check.sh`
  - **Pattern:** `scripts/sdd-session-register.sh`
  - **Gate:** `bash scripts/sdd-session-check.sh --phase explore; test $? -eq 0`

- [x] 1.3 Criar `scripts/sdd-session-status.sh`
  - **Pattern:** `scripts/sdd-session-check.sh`
  - **Gate:** `bash scripts/sdd-session-status.sh >/dev/null`

- [x] 1.4 Criar `scripts/sdd-session-heartbeat.sh` e `scripts/sdd-session-release.sh`
  - **Pattern:** `scripts/sdd-session-register.sh`
  - **Gate:** `test -x scripts/sdd-session-release.sh && test -x scripts/sdd-session-heartbeat.sh`

- [x] 1.5 Adicionar `.sdd/runtime/` ao `.gitignore`
  - **Pattern:** `.gitignore`
  - **Gate:** `grep -q '.sdd/runtime' .gitignore`

## 2. Regras e AGENTS.md

- [x] 2.1 Criar `.cursor/rules/016-session-coordination.mdc` (alwaysApply, ~20 linhas)
  - **Pattern:** `.cursor/rules/015-session-phases.mdc`
  - **Gate:** `test -f .cursor/rules/016-session-coordination.mdc && grep -q 'alwaysApply' .cursor/rules/016-session-coordination.mdc`

- [x] 2.2 Adicionar R11 e comando `sdd-session-status` em `AGENTS.md`
  - **Pattern:** `AGENTS.md` (R10)
  - **Gate:** `grep -q 'R11' AGENTS.md && grep -q 'sdd-session-status' AGENTS.md`

- [x] 2.3 Confirmar `AGENTS.md` ≤150 linhas
  - **Gate:** `test $(wc -l < AGENTS.md) -le 150`

## 3. Skills apply/propose (Cursor)

- [x] 3.1 Secção Session coordination em `.cursor/skills/openspec-apply-change/SKILL.md`
  - **Pattern:** `.cursor/skills/openspec-apply-change/SKILL.md` (Session Handoff)
  - **Gate:** `grep -q 'sdd-session-check' .cursor/skills/openspec-apply-change/SKILL.md`

- [x] 3.2 Espelhar em `.cursor/commands/opsx-apply.md`
  - **Pattern:** `.cursor/commands/opsx-apply.md`
  - **Gate:** `grep -q 'sdd-session-check' .cursor/commands/opsx-apply.md`

- [x] 3.3 Espelhar apply skill em `.claude/skills/openspec-apply-change/SKILL.md` e `.claude/commands/opsx/apply.md`
  - **Gate:** `grep -q 'sdd-session-check' .claude/skills/openspec-apply-change/SKILL.md`

## 4. Infra e verificação

- [x] 4.1 Secção Session Coordination em `openspec/infra.md`
  - **Pattern:** `openspec/infra.md`
  - **Gate:** `grep -q 'Session Coordination' openspec/infra.md`

- [x] 4.2 Validar scripts session em `scripts/verify-infra.sh`
  - **Pattern:** `scripts/verify-infra.sh`
  - **Gate:** `grep -q 'sdd-session-check' scripts/verify-infra.sh`

## 5. Documentação SDD (guia canónico operacional)

- [x] 5.1 Actualizar `doc/sistema-sdd-pedro.md` §3.3 — worktree + flock + fluxo paralelo/sequencial
  - **Pattern:** `doc/sistema-sdd-pedro.md` §3.3
  - **Gate:** `grep -q 'sdd-session-check' doc/sistema-sdd-pedro.md`

- [x] 5.2 Actualizar §2.8 checklist — scripts session, rule 016, gitignore
  - **Pattern:** `doc/sistema-sdd-pedro.md` §2.8
  - **Gate:** `grep -q '016-session-coordination' doc/sistema-sdd-pedro.md`

- [x] 5.3 Actualizar template §12.2 (AGENTS) com R11
  - **Pattern:** `doc/sistema-sdd-pedro.md` §12.2
  - **Gate:** `grep -q 'R11' doc/sistema-sdd-pedro.md`

- [x] 5.4 Mencionar session coordination em `scripts/bootstrap-sdd.sh`
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Gate:** `grep -q 'sdd-session' scripts/bootstrap-sdd.sh`

## 6. Specs e validação

- [x] 6.1 Promover spec `openspec/changes/add-sdd-session-coordination/specs/` → validar conteúdo
  - **Gate:** `test -f openspec/changes/add-sdd-session-coordination/specs/sdd-session-coordination/spec.md`

- [x] 6.2 `npx openspec validate add-sdd-session-coordination` (se CLI disponível)
  - **Gate:** `npx openspec validate add-sdd-session-coordination 2>/dev/null || test -f openspec/changes/add-sdd-session-coordination/proposal.md`

- [x] 6.3 Commit: `docs(sdd): session coordination local (add-sdd-session-coordination)`
  - **Gate:** `git log -1 --oneline | grep -q 'session coordination'`
