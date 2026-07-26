# Tasks — add-correctness-review-skill

> Escopo apply após aprovação humana (R7/R11). G7 qualifica para excepção de piloto: Fase 1 → Fase 3 directo (sem binário/hook novo; utilizador confirmou piloto dispensável).

## 1. Skill files (R3)

- [ ] 1.1 Criar `.claude/skills/correctness-review/SKILL.md` com: frontmatter (name/description/license/metadata), secções Quando invocar (matriz A–E), Formato de saída (tags logic/edge/contract/race/silent, vereditos CORRECT/RISKY/ESCOPO INSUFICIENTE), Boundaries (nunca flaggar), Integração SDD e Comandos úteis
  - **Pattern:** `.claude/skills/simplify-review/SKILL.md`
  - **Invariants:** `sdd-correctness-review` — Skill file exists in canonical locations; Skill targets correctness exclusively; Skill uses standardised output format
  - **Gate:** `test -f .claude/skills/correctness-review/SKILL.md`

- [ ] 1.2 Criar `.cursor/skills/correctness-review/SKILL.md` como cópia idêntica do item 1.1
  - **Pattern:** `.cursor/skills/simplify-review/SKILL.md`
  - **Invariants:** `sdd-correctness-review` — Skill file exists in canonical locations
  - **Gate:** `diff .claude/skills/correctness-review/SKILL.md .cursor/skills/correctness-review/SKILL.md`

## 2. AGENTS.md (R2)

- [ ] 2.1 Actualizar secção "Reviews pós-implementação" em `AGENTS.md`: adicionar linha `correctness-review` com posição na pipeline (antes de `simplify-review`) e quando invocar/não invocar segundo a matriz A–E; actualizar a linha de ordem do pipeline
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-correctness-review` — Pipeline position is documented; Skill is invoked on-demand only
  - **Gate:** `grep -q 'correctness-review' AGENTS.md`

## 3. openspec/infra.md (R1)

- [ ] 3.1 Adicionar linha de `correctness-review` na secção Skills de `openspec/infra.md` (path, fase review, estado ✅)
  - **Pattern:** `openspec/infra.md`
  - **Invariants:** `sdd-workspace-manifest` — Skills section lists all active review skills; `sdd-correctness-review` — Skill is registered in all 6 contract points
  - **Gate:** `grep -q 'correctness-review' openspec/infra.md`

## 4. Guia canónico — operação humana (R4)

- [ ] 4.1 Adicionar subsecção `correctness-review` em `doc/sistema-sdd-pedro.md` (posição lógica após `simplify-review`): quando acionar, como ler output (tags, vereditos), como não acionar, troubleshooting
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Invariants:** `sdd-correctness-review` — Skill is registered in all 6 contract points
  - **Gate:** `grep -q 'correctness-review' doc/sistema-sdd-pedro.md`

## 5. Avaliação (R5)

- [ ] 5.1 Actualizar `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G7 → "Adoptado — skill local criada, change `add-correctness-review-skill`" + referência a este change + condições de reavaliação (conversão para subagente, PR-Agent fase 2)
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Invariants:** `sdd-correctness-review` — Skill is registered in all 6 contract points
  - **Gate:** `grep -q 'add-correctness-review-skill' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`

## 6. sdd-kit (R6) e spec

- [ ] 6.1 Adicionar nota de instalação manual em `sdd-kit/README.md` (análogo ao `simplify-review`): path dos ficheiros de skill, que não há script automático nesta fase, e que o apply promove a spec para `openspec/specs/`
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `grep -qi 'correctness-review' sdd-kit/README.md`

- [ ] 6.2 Promover `openspec/changes/add-correctness-review-skill/specs/sdd-correctness-review/spec.md` para `openspec/specs/sdd-correctness-review/spec.md`
  - **Pattern:** `openspec/specs/sdd-ci-gates/spec.md`
  - **Invariants:** `sdd-correctness-review` — Skill is registered in all 6 contract points
  - **Gate:** `test -f openspec/specs/sdd-correctness-review/spec.md`

## 7. Validação

- [ ] 7.1 Correr `scripts/verify-task-patterns.sh` sobre este `tasks.md`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [ ] 7.2 Validar change com openspec CLI
  - **Pattern:** `openspec/changes/add-correctness-review-skill/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-correctness-review-skill 2>/dev/null || test -f openspec/changes/add-correctness-review-skill/tasks.md`

## 8. Pós-registro (best-effort)

- [ ] 8.1 `graphify update .` + `npx gitnexus analyze --force` se disponíveis
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify ❌ em infra.md)'`
