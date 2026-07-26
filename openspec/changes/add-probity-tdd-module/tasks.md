# Tasks — add-probity-tdd-module

> Escopo apply após aprovação humana (R7/R11). **Piloto obrigatório** (Fase 2) num worktree APP antes de promover MANIFEST — ver `design.md` critérios quantificados.

## 0. Piloto (Fase 2 — repo APP worktree, antes MANIFEST)

- [ ] 0.1 Executar piloto em worktree APP com Vitest ou pytest: C1 + GitNexus + Graphify + Probity; medir latência PreToolUse p95 (< 8s), falsos positivos tipo C (< 15%), R6 tipo B (100%), Cursor hooks
  - **Pattern:** `openspec/changes/add-probity-tdd-module/design.md`
  - **Gate:** `test -f openspec/changes/add-probity-tdd-module/design.md && grep -q 'p95' openspec/changes/add-probity-tdd-module/design.md`

- [ ] 0.2 Registar resultado do piloto em nota no change ou issue; se falhou → status "Adiado" em avaliação G2 e não prosseguir §6 MANIFEST bump
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Gate:** `grep -q 'Probity' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md || echo 'PENDING apply'`

## 1. sdd-kit — script e templates (R6)

- [ ] 1.1 Criar `sdd-kit/templates/install-probity-module.sh` com `--detect`, `--dry-run`, `--apply`, `--yes`, `--uninstall`, `--repo`; detectar vitest/jest/pytest; SKIP DOCS_SPECS sem test runner
  - **Pattern:** `sdd-kit/install-ui-module.sh`
  - **Gate:** `test -f sdd-kit/templates/install-probity-module.sh`

- [ ] 1.2 Copiar/symlink para `sdd-kit/install-probity-module.sh` executável
  - **Pattern:** `sdd-kit/install-ui-module.sh`
  - **Gate:** `test -x sdd-kit/install-probity-module.sh`

- [ ] 1.3 Criar `sdd-kit/templates/probity.config.ts` com `enforceTdd()` (addendum SDD R6), globs prod+test, exclusões doc/openspec/sdd-kit, `forbidCommandPattern(/rm\s+-rf/)`
  - **Pattern:** `openspec/changes/add-probity-tdd-module/design.md`
  - **Gate:** `test -f sdd-kit/templates/probity.config.ts && grep -q 'enforceTdd' sdd-kit/templates/probity.config.ts`

- [ ] 1.4 Criar `sdd-kit/templates/doc/design/004-probity-module-install.md` (install, plugin, piloto, Cursor, rollback, lint opt-in)
  - **Pattern:** `sdd-kit/templates/doc/design/002-ui-module-install.md`
  - **Gate:** `test -f sdd-kit/templates/doc/design/004-probity-module-install.md`

- [ ] 1.5 Actualizar `sdd-kit/README.md`: cenário Probity (G2), comando install, pin `@nizos/probity@1.10.0`
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `grep -qi 'install-probity-module' sdd-kit/README.md`

- [ ] 1.6 Adicionar entradas em `sdd-kit/MANIFEST.yaml` (`install-probity-module.sh`, `probity.config.ts` template, `004-probity-module-install.md`) com `profiles: [APP, HYBRID]`; correr `bash sdd-kit/gen-manifest-checksums.sh`
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -q 'install-probity-module' sdd-kit/MANIFEST.yaml && bash sdd-kit/gen-manifest-checksums.sh`

- [ ] 1.7 Adicionar check Probity em `sdd-kit/verify.sh` (report-only se módulo não instalado)
  - **Pattern:** `sdd-kit/verify.sh`
  - **Gate:** `grep -q 'probity' sdd-kit/verify.sh`

## 2. openspec/infra.md (R1)

- [ ] 2.1 Adicionar secção "Probity Module" em `openspec/infra.md` e template: `@nizos/probity@1.10.0`, estado SKIP (hub) ou ✅, `test -f probity.config.ts`
  - **Pattern:** `openspec/infra.md`
  - **Gate:** `grep -q 'probity' openspec/infra.md`

- [ ] 2.2 Espelhar secção em `sdd-kit/templates/openspec/infra.md` (se template existir) ou documentar merge em install script
  - **Pattern:** `sdd-kit/templates/openspec/infra.md`
  - **Gate:** `test -f sdd-kit/templates/openspec/infra.md && grep -q 'probity' sdd-kit/templates/openspec/infra.md || test -f sdd-kit/templates/install-probity-module.sh`

## 3. AGENTS.md (R2)

- [ ] 3.1 Adicionar ≤10 linhas em Integrações Probity (quando activo, matriz A–E, comando install); actualizar pipeline reviews: `testes (R6/Probity enforceTdd)` → correctness-review → …
  - **Pattern:** `AGENTS.md`
  - **Gate:** `grep -q 'Probity' AGENTS.md && grep -q 'enforceTdd' AGENTS.md`

- [ ] 3.2 Actualizar `sdd-kit/templates/AGENTS.core.md` com mesmas linhas
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Gate:** `grep -q 'Probity' sdd-kit/templates/AGENTS.core.md`

## 4. Skill opcional (R3 — só se AGENTS.md Integrações >10 linhas após 3.1)

- [ ] 4.1 Se necessário: criar `.claude/skills/probity-guard/SKILL.md` + espelho `.cursor/skills/probity-guard/SKILL.md` (troubleshooting enforceTdd, override, desinstalar)
  - **Pattern:** `.claude/skills/correctness-review/SKILL.md`
  - **Gate:** `test -f .claude/skills/probity-guard/SKILL.md || ! grep -c 'Probity' AGENTS.md | awk '{exit ($1>10)?1:0}'`

## 5. Guia canónico — operação humana (R4)

- [ ] 5.1 Adicionar §2.16 "Módulo Probity (G2)" em `doc/sistema-sdd-pedro.md`: install plugin, piloto, Cursor third-party hooks, desligar (globs/uninstall), troubleshooting, rollback; renumerar §2.14 github-mcp se necessário
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q 'Probity' doc/sistema-sdd-pedro.md && grep -q '2.16' doc/sistema-sdd-pedro.md`

- [ ] 5.2 Actualizar referências "TDD Guard" → "Probity" na pipeline §2.14 correctness-review
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `! grep -q 'TDD Guard' doc/sistema-sdd-pedro.md || grep -q 'Probity' doc/sistema-sdd-pedro.md`

## 6. Doc migration TDD Guard → Probity (lista canónica)

- [ ] 6.1 `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G2 → Probity; nota supersessão TDD Guard; piloto; link change `add-probity-tdd-module`
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Gate:** `grep -q 'Probity' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md && grep -q 'superseded' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`

- [ ] 6.2 `doc/avaliacoes/README.md`: índice linha 2026-07-25 → "Probity (G2)" em vez de TDD Guard
  - **Pattern:** `doc/avaliacoes/README.md`
  - **Gate:** `grep -q 'Probity' doc/avaliacoes/README.md`

- [ ] 6.3 `openspec/changes/explore-oss-coverage-gaps/research.md`: G2 candidato Probity; matriz; ordem impl. #5; riscos; links; nota histórica TDD Guard
  - **Pattern:** `openspec/changes/explore-oss-coverage-gaps/research.md`
  - **Gate:** `grep -q 'Probity' openspec/changes/explore-oss-coverage-gaps/research.md`

- [ ] 6.4 `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`: todas refs "TDD Guard" → "Probity (G2)"; toggle → globs/desligar módulo
  - **Pattern:** `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`
  - **Gate:** `grep -q 'Probity' openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md && ! grep -q 'TDD Guard' openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`

- [ ] 6.5 `openspec/project.md`: cross-reference G2/Probity se aplicável (só se mencionar TDD — verificar; adicionar linha testes+Probity opcional)
  - **Pattern:** `openspec/project.md`
  - **Gate:** `grep -q 'Probity' openspec/project.md || ! grep -q 'TDD' openspec/project.md`

- [ ] 6.6 Actualizar skills correctness-review: `.claude/skills/correctness-review/SKILL.md` e `.cursor/skills/correctness-review/SKILL.md` — pipeline "R6/Probity" em vez de "R6/TDD Guard"
  - **Pattern:** `.claude/skills/correctness-review/SKILL.md`
  - **Gate:** `grep -q 'Probity' .claude/skills/correctness-review/SKILL.md`

## 7. Specs (promover após apply)

- [ ] 7.1 Promover `openspec/changes/add-probity-tdd-module/specs/sdd-probity-module/spec.md` → `openspec/specs/sdd-probity-module/spec.md`
  - **Pattern:** `openspec/specs/sdd-ui-module/spec.md`
  - **Gate:** `test -f openspec/specs/sdd-probity-module/spec.md`

- [ ] 7.2 Aplicar delta `sdd-correctness-review` em `openspec/specs/sdd-correctness-review/spec.md` (pipeline R6/Probity)
  - **Pattern:** `openspec/specs/sdd-correctness-review/spec.md`
  - **Gate:** `grep -q 'Probity' openspec/specs/sdd-correctness-review/spec.md`

## 8. Avaliação (R5)

- [ ] 8.1 Actualizar G2 em `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` para "Adoptado" após piloto + archive (pendente até lá: "Adoptado — change add-probity-tdd-module, piloto pendente")
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Gate:** `grep -q 'add-probity-tdd-module' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`

## 9. Validação

- [ ] 9.1 Correr `scripts/verify-task-patterns.sh` sobre este `tasks.md`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [ ] 9.2 Validar change com openspec CLI
  - **Pattern:** `openspec/changes/add-probity-tdd-module/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-probity-tdd-module --strict`

## 10. Pós-registro (best-effort)

- [ ] 10.1 `graphify update .` + `npx gitnexus analyze --force` se disponíveis
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify ❌ em infra.md)'`
