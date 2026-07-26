# Tasks — add-sdd-metrics-script

> Escopo apply após aprovação humana (R7). G4 qualifica para **excepção de piloto** (sem binário/hook/serviço/LLM externo — script bash local). **Non-goal:** Apache DevLake. **Issue:** —

## 1. Script de métricas (hub)

- [ ] 1.1 Criar `scripts/sdd-metrics.sh` executável: bash + git; flags `--since YYYY-MM-DD`, `--output PATH`, `--help`; exit 0 com relatório, exit 2 em uso inválido; secções M1 volume, M2 lead time propose→archive, M3 rework `fix` pós-archive + change-id, M4 actividade pós-archive; nota de proxies no relatório (design D3–D5)
  - **Pattern:** `scripts/sdd-session-status.sh`
  - **Invariants:** `sdd-metrics` — Local metrics script exists and is executable; Report covers volume, lead time, and post-archive rework; CLI flags for since-filter, output file, and help
  - **Gate:** `test -x scripts/sdd-metrics.sh && bash scripts/sdd-metrics.sh --help >/dev/null && bash scripts/sdd-metrics.sh | grep -qE 'M1|Volume|Lead|Rework|propose'`

- [ ] 1.2 Validar dry-run no hub: relatório markdown com pelo menos um archive existente ou mensagem explícita de zero archives; `--since` filtra; `--output` escreve ficheiro
  - **Pattern:** `scripts/sdd-session-status.sh`
  - **Gate:** `bash scripts/sdd-metrics.sh --since 2020-01-01 >/tmp/sdd-metrics-out.md && test -s /tmp/sdd-metrics-out.md && bash scripts/sdd-metrics.sh --output /tmp/sdd-metrics-file.md >/dev/null && diff -q /tmp/sdd-metrics-out.md /tmp/sdd-metrics-file.md`

## 2. Distribuição sdd-kit (R6)

- [ ] 2.1 Copiar script para `sdd-kit/templates/scripts/sdd-metrics.sh` (paridade hub/template)
  - **Pattern:** `sdd-kit/templates/scripts/sdd-session-status.sh`
  - **Invariants:** `sdd-install-kit` — Metrics script distributed via install kit
  - **Gate:** `diff -q scripts/sdd-metrics.sh sdd-kit/templates/scripts/sdd-metrics.sh`

- [ ] 2.2 Adicionar entry `scripts/sdd-metrics.sh` em `sdd-kit/MANIFEST.yaml` (`merge: COPY`, `profiles: [APP, DOCS_SPECS, HYBRID]`, `gate:` documental); bump `version` e `guide_version` 1.5.0 → **1.6.0**; correr `bash sdd-kit/gen-manifest-checksums.sh`
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Invariants:** `sdd-install-kit` — Metrics script distributed via install kit
  - **Gate:** `grep -q 'sdd-metrics.sh' sdd-kit/MANIFEST.yaml && grep -q 'version: "1.6.0"' sdd-kit/MANIFEST.yaml && grep -A6 'sdd-metrics.sh' sdd-kit/MANIFEST.yaml | grep -q 'sha256:'`

- [ ] 2.3 Actualizar `sdd-kit/verify.sh` e/ou `sdd-kit/README.md` se o padrão do kit exigir check/documentação do novo script (mínimo: README menciona `sdd-metrics.sh`)
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `grep -q 'sdd-metrics' sdd-kit/README.md || grep -q 'sdd-metrics' sdd-kit/verify.sh`

## 3. openspec/infra.md (R1)

- [ ] 3.1 Adicionar entrada Metrics / `sdd-metrics.sh` em `openspec/infra.md` (estado + verificar com)
  - **Pattern:** `openspec/infra.md`
  - **Invariants:** `sdd-workspace-manifest` — SDD metrics script registered in infrastructure manifest
  - **Gate:** `grep -q 'sdd-metrics' openspec/infra.md`

- [ ] 3.2 Espelhar em `sdd-kit/templates/openspec/infra.md`
  - **Pattern:** `sdd-kit/templates/openspec/infra.md`
  - **Gate:** `grep -q 'sdd-metrics' sdd-kit/templates/openspec/infra.md`

## 4. AGENTS.md (R2)

- [ ] 4.1 Actualizar `AGENTS.md`: linha na tabela Commands (`bash scripts/sdd-metrics.sh`); ≤10 linhas em Integrações / Contexto sob demanda (modo C, proxies, sem DevLake); **sem** skill/rule nova (R3 N/A)
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-metrics` — On-demand mode C — not a CI gate
  - **Gate:** `grep -q 'sdd-metrics.sh' AGENTS.md`

- [ ] 4.2 Espelhar em `sdd-kit/templates/AGENTS.core.md`
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Gate:** `grep -q 'sdd-metrics.sh' sdd-kit/templates/AGENTS.core.md`

## 5. Guia canónico §2.17 (R4)

- [ ] 5.1 Adicionar **§2.17 Métricas SDD (sdd-metrics.sh)** em `doc/sistema-sdd-pedro.md`: quando correr; como ler M1–M4; proxies e limites; troubleshooting; rollback; nota explícita de que DevLake permanece fora de escopo
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q '2.17' doc/sistema-sdd-pedro.md && grep -q 'sdd-metrics' doc/sistema-sdd-pedro.md`

- [ ] 5.2 Actualizar índice, "Como usar este documento" e Changelog do guia (v1.6.0) com ponteiro para §2.17; alinhar `openspec/project.md` se referenciar versão do kit/guia
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q '1.6.0' doc/sistema-sdd-pedro.md && grep -q 'sdd-metrics' openspec/project.md`

## 6. Avaliação (R5)

- [ ] 6.1 Actualizar `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G4 — correcção manual `sdd-metrics.sh` → **Adoptado** (change `add-sdd-metrics-script`); Apache DevLake permanece **Adiado** com condição de reavaliação inalterada
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Invariants:** `sdd-metrics` — DevLake remains out of scope
  - **Gate:** `grep -q 'add-sdd-metrics-script' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md && grep -q 'sdd-metrics' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`

## 7. Specs — promoção

- [ ] 7.1 Promover `openspec/changes/add-sdd-metrics-script/specs/sdd-metrics/spec.md` para `openspec/specs/sdd-metrics/spec.md`
  - **Pattern:** `openspec/specs/sdd-ci-gates/spec.md`
  - **Gate:** `test -f openspec/specs/sdd-metrics/spec.md`

- [ ] 7.2 Aplicar deltas `sdd-install-kit` e `sdd-workspace-manifest` em `openspec/specs/` (merge ADDED)
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Gate:** `grep -q 'sdd-metrics' openspec/specs/sdd-install-kit/spec.md && grep -q 'sdd-metrics' openspec/specs/sdd-workspace-manifest/spec.md`

## 8. Validação

- [ ] 8.1 Correr `bash scripts/verify-task-patterns.sh` sobre este `tasks.md`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [ ] 8.2 Validar change com openspec CLI
  - **Pattern:** `openspec/changes/add-sdd-metrics-script/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-sdd-metrics-script --strict`

## 9. Pós-registro (best-effort)

- [ ] 9.1 `graphify update .` + `npx gitnexus analyze --force` se disponíveis
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify ❌ em infra.md)'`
