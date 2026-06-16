# Tasks — enrich-tasks-template-code-patterns

## 1. Guia SDD (§12.10)

- [ ] 1.1 Adicionar §12.10 em `doc/sistema-sdd-pedro.md` com template `tasks.md`, modelo 3 níveis, exemplos APP e DOCS_SPECS
  - **Pattern:** `doc/sistema-sdd-pedro.md` §12.3 (estrutura de anexo template)
  - **Gate:** `grep -q '12.10' doc/sistema-sdd-pedro.md`
- [ ] 1.2 Actualizar §5.2 com referência cruzada: `tasks.md` segue §12.10; decisões permanecem em §12.3
  - **Gate:** `grep -q '12.10' doc/sistema-sdd-pedro.md`
- [ ] 1.3 Actualizar §7.2 (Tipo C/D) — mencionar `Pattern` + `Gate` obrigatórios em tasks de código
  - **Gate:** `grep -q 'Gate' doc/sistema-sdd-pedro.md`

## 2. Script de verificação

- [ ] 2.1 Criar `scripts/verify-task-patterns.sh` idempotente
  - **Pattern:** `scripts/verify-infra.sh` (estilo, shebang, exit codes)
  - **Gate:** `bash scripts/verify-task-patterns.sh; test $? -eq 0`
- [ ] 2.2 Script percorre `openspec/changes/*/tasks.md` (excl. archive) e valida paths em `Pattern:`
  - **Gate:** `bash -n scripts/verify-task-patterns.sh`

## 3. Skills OpenSpec (Cursor)

- [ ] 3.1 Actualizar `.cursor/skills/openspec-propose/SKILL.md` — regras §12.10, validação de paths, limite 15 linhas
  - **Pattern:** `.cursor/skills/openspec-propose/SKILL.md` secção Session Handoff (manter ≤ tamanho actual + bloco novo)
  - **Gate:** `grep -q '12.10' .cursor/skills/openspec-propose/SKILL.md`
- [ ] 3.2 Actualizar `.cursor/skills/openspec-apply-change/SKILL.md` — `gitnexus impact` + gate antes de `[x]`
  - **Pattern:** `.cursor/skills/openspec-apply-change/SKILL.md` guardrails existentes
  - **Gate:** `grep -q 'Gate' .cursor/skills/openspec-apply-change/SKILL.md`
- [ ] 3.3 Actualizar `.cursor/skills/openspec-archive-change/SKILL.md` — checklist promoção pattern
  - **Gate:** `grep -q 'promov' .cursor/skills/openspec-archive-change/SKILL.md`
- [ ] 3.4 Espelhar em `.cursor/commands/opsx-propose.md`, `opsx-apply.md`, `opsx-archive.md`
  - **Pattern:** paridade com change `add-session-handoff-infra-manifest` tasks §3
  - **Gate:** `diff -q .cursor/skills/openspec-propose/SKILL.md .cursor/commands/opsx-propose.md | grep -q Session || test -f .cursor/commands/opsx-propose.md`

## 4. Skills OpenSpec (Claude Code)

- [ ] 4.1 Espelhar secções tasks em `.claude/skills/openspec-{propose,apply-change,archive-change}/SKILL.md`
  - **Pattern:** `.claude/skills/openspec-propose/SKILL.md` (espelho existente)
  - **Gate:** `grep -q '12.10' .claude/skills/openspec-propose/SKILL.md`
- [ ] 4.2 Espelhar em `.claude/commands/opsx/{propose,apply,archive}.md`
  - **Gate:** `test -f .claude/commands/opsx/propose.md`

## 5. AGENTS.md

- [ ] 5.1 Adicionar entrada Contexto sob demanda → `doc/sistema-sdd-pedro.md` §12.10
  - **Pattern:** entrada `openspec/infra.md` na tabela Contexto (formato existente)
  - **Gate:** `wc -l AGENTS.md | awk '{print $1}' | xargs test 150 -ge`
- [ ] 5.2 Confirmar `AGENTS.md` ≤150 linhas após edição
  - **Gate:** `wc -l AGENTS.md | awk '{print $1 <= 150}' | grep -q 1`

## 6. Validação e fecho

- [ ] 6.1 `npx @fission-ai/openspec@latest validate enrich-tasks-template-code-patterns`
  - **Gate:** `npx @fission-ai/openspec@latest validate enrich-tasks-template-code-patterns`
- [ ] 6.2 Correr `bash scripts/verify-task-patterns.sh` em changes activos
  - **Gate:** `bash scripts/verify-task-patterns.sh`
- [ ] 6.3 Commit: `docs(sdd): template tasks com pattern pointers (enrich-tasks-template-code-patterns)`
  - **Gate:** `git diff --stat`
