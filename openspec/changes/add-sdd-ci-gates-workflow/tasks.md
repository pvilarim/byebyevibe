# Tasks — add-sdd-ci-gates-workflow

> Escopo apply após aprovação humana (R7/R11). G1 qualifica para excepção de piloto: Fase 1 → Fase 3 directo.

## 1. Workflow de CI

- [ ] 1.1 Criar `.github/workflows/sdd-gates.yml` (triggers `push`/`pull_request`, `permissions: contents: read`, Node 22 + Python 3.13)
  - **Pattern:** `sdd-kit/verify.sh`
  - **Invariants:** `sdd-ci-gates` — CI workflow enforces SDD gates; least-privilege, no secrets
  - **Gate:** `test -f .github/workflows/sdd-gates.yml && grep -q 'pull_request' .github/workflows/sdd-gates.yml && grep -q 'permissions' .github/workflows/sdd-gates.yml`

- [ ] 1.2 Passo bloqueante `openspec validate` (versão pinada ≥ `min_openspec`), fail-closed
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Invariants:** `sdd-ci-gates` — OpenSpec validation is blocking and fail-closed
  - **Gate:** `grep -q 'openspec' .github/workflows/sdd-gates.yml && grep -Eq 'validate' .github/workflows/sdd-gates.yml`

- [ ] 1.3 Passos estruturais `bash sdd-kit/verify.sh` e `bash scripts/verify-task-patterns.sh`; resolver tratamento do `verify-infra.sh` (design D4)
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `grep -q 'sdd-kit/verify.sh' .github/workflows/sdd-gates.yml && grep -q 'verify-task-patterns.sh' .github/workflows/sdd-gates.yml`

## 2. Template no sdd-kit (R6)

- [ ] 2.1 Copiar o workflow para `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Pattern:** `sdd-kit/templates/scripts/verify-infra.sh`
  - **Invariants:** `sdd-ci-gates` — Distributable workflow template
  - **Gate:** `test -f sdd-kit/templates/.github/workflows/sdd-gates.yml`

- [ ] 2.2 Adicionar entry no `sdd-kit/MANIFEST.yaml` (COPY, profiles `[APP, DOCS_SPECS, HYBRID]`, gate) e bump `version` 1.3.2 → 1.4.0
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Invariants:** `sdd-install-kit` — Manifest lists CI gate workflow
  - **Gate:** `grep -q 'sdd-gates.yml' sdd-kit/MANIFEST.yaml && grep -q '1.4.0' sdd-kit/MANIFEST.yaml`

## 3. Verify e README do kit (R6)

- [ ] 3.1 `sdd-kit/verify.sh`: check da presença do template/workflow do gate de CI
  - **Pattern:** `sdd-kit/verify.sh`
  - **Invariants:** `sdd-install-kit` — verify.sh checks the CI gate template
  - **Gate:** `grep -q 'sdd-gates' sdd-kit/verify.sh`

- [ ] 3.2 `sdd-kit/README.md`: nota sobre o gate de CI e a acção manual de branch protection
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `grep -qi 'CI\|sdd-gates' sdd-kit/README.md`

## 4. Guia canónico — operação humana (R4)

- [ ] 4.1 Secção nova em `doc/sistema-sdd-pedro.md`: quando corre, como ler output, desbloquear merge, troubleshooting, `[AÇÃO MANUAL]` branch protection
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -qi 'sdd-gates\|Gates de CI\|CI Gates' doc/sistema-sdd-pedro.md`

- [ ] 4.2 Bump do changelog do guia (entrada CI gates G1)
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -qi 'ci.gates\|G1\|sdd-gates' doc/sistema-sdd-pedro.md`

## 5. Infra e AGENTS (R1 + R2)

- [ ] 5.1 Secção/linha "CI Gates" em `openspec/infra.md` (estado + verificar com)
  - **Pattern:** `openspec/infra.md`
  - **Invariants:** `sdd-workspace-manifest` — CI Gates state is recorded
  - **Gate:** `grep -qi 'CI Gates\|sdd-gates' openspec/infra.md`

- [ ] 5.2 `AGENTS.md`: linha em Integrações + Contexto sob demanda + entrada na tabela Commands (R3 skill = N/A, documentar)
  - **Pattern:** `AGENTS.md`
  - **Gate:** `grep -qi 'sdd-gates\|Gates de CI\|CI Gates' AGENTS.md`

## 6. Avaliação e spec (R5 + validação)

- [ ] 6.1 Actualizar `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G1 → "Adoptado" + referência a este change + condição de reavaliação
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Gate:** `grep -q 'add-sdd-ci-gates-workflow' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`

- [ ] 6.2 Promover `specs/sdd-ci-gates/spec.md` para `openspec/specs/` (no archive)
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Gate:** `test -f openspec/changes/add-sdd-ci-gates-workflow/specs/sdd-ci-gates/spec.md`

- [ ] 6.3 Correr `scripts/verify-task-patterns.sh` sobre este `tasks.md`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [ ] 6.4 Validar change (`npx openspec validate add-sdd-ci-gates-workflow` se CLI disponível) e correr o próprio workflow contra um change inválido para confirmar fail-closed
  - **Pattern:** `openspec/changes/add-sdd-ci-gates-workflow/proposal.md`
  - **Gate:** `npx openspec validate add-sdd-ci-gates-workflow 2>/dev/null || test -f openspec/changes/add-sdd-ci-gates-workflow/proposal.md`

## 7. Pós-registro (best-effort)

- [ ] 7.1 `graphify update .` + `npx gitnexus analyze --force` se disponíveis (senão `[NEEDS VERIFICATION]`)
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify ❌ em infra.md)'`
