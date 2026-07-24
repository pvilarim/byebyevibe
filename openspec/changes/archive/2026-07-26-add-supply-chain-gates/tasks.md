# Tasks — add-supply-chain-gates

> Escopo apply após aprovação humana (R7/R11). G8 OSV qualifica para excepção de piloto (só CI step + template). Renovate: checklist manual no guia §2.13. **Pré-requisito:** G1 (`sdd-gates.yml`) implementado.

## 1. OSV-Scanner no workflow (R6 — hub + template)

- [x] 1.1 Adicionar step `OSV-Scanner (blocking)` em `.github/workflows/sdd-gates.yml`: `if` com `hashFiles` para lockfiles suportados; `uses: google/osv-scanner-action/osv-scanner-action@8dc09193bb540e09b23da07ad7e30bd33bf87018 # v2.3.8`; `scan-args: --recursive ./`; posição após task patterns e antes de `sdd-kit verify` report-only
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Invariants:** `sdd-ci-gates` — OSV step in workflow; `sdd-supply-chain` — OSV blocks merge when lockfile vulnerabilities exist
  - **Gate:** `grep -q 'OSV-Scanner (blocking)' .github/workflows/sdd-gates.yml && grep -q '8dc09193bb540e09b23da07ad7e30bd33bf87018' .github/workflows/sdd-gates.yml`

- [x] 1.2 Espelhar o mesmo step em `sdd-kit/templates/.github/workflows/sdd-gates.yml` (paridade hub/template)
  - **Pattern:** `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Invariants:** `sdd-ci-gates` — Kit template parity
  - **Gate:** `diff -q .github/workflows/sdd-gates.yml sdd-kit/templates/.github/workflows/sdd-gates.yml`

## 2. Template Renovate (R6)

- [x] 2.1 Criar `sdd-kit/templates/renovate.json` com preset conservador (design D6): `extends` recommended + semanticCommits + separateMajorReleases; `schedule` segunda-feira; `prConcurrentLimit` 5; `prHourlyLimit` 2; `packageRules` — group non-major, automerge só patch com `requiredStatusChecks: ["SDD Gates"]`, majors/minors sem automerge; `lockFileMaintenance` monthly; `vulnerabilityAlerts` sem automerge
  - **Pattern:** `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Invariants:** `sdd-supply-chain` — Renovate config distributed for APP and HYBRID profiles
  - **Gate:** `test -f sdd-kit/templates/renovate.json && grep -q 'separateMajorReleases' sdd-kit/templates/renovate.json`

## 3. install.sh e MANIFEST (R6)

- [x] 3.1 Actualizar `sdd-kit/install.sh`: copiar `renovate.json` apenas para perfis APP e HYBRID; log `SKIP Renovate: profile DOCS_SPECS` para DOCS_SPECS
  - **Pattern:** `sdd-kit/install.sh`
  - **Invariants:** `sdd-supply-chain` — Profile-aware MANIFEST; DOCS_SPECS skips Renovate
  - **Gate:** `grep -q 'renovate.json' sdd-kit/install.sh && grep -q 'DOCS_SPECS' sdd-kit/install.sh`

- [x] 3.2 Adicionar entry `renovate.json` em `sdd-kit/MANIFEST.yaml` (`profiles: [APP, HYBRID]`, `merge: COPY`); bump `version` 1.4.0 → **1.5.0**; correr `bash sdd-kit/gen-manifest-checksums.sh`
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Invariants:** `sdd-supply-chain` — Profile-aware MANIFEST
  - **Gate:** `grep -q 'renovate.json' sdd-kit/MANIFEST.yaml && grep -q 'version: "1.5.0"' sdd-kit/MANIFEST.yaml`

## 4. openspec/infra.md (R1)

- [x] 4.1 Adicionar secção Supply Chain em `openspec/infra.md`: OSV-Scanner (action SHA, verificar com grep no workflow) + Renovate (renovate.json, app GitHub manual)
  - **Pattern:** `openspec/infra.md`
  - **Invariants:** `sdd-supply-chain` — Agent classification documented
  - **Gate:** `grep -q 'OSV-Scanner' openspec/infra.md && grep -q 'Renovate' openspec/infra.md`

- [x] 4.2 Espelhar em `sdd-kit/templates/openspec/infra.md`
  - **Pattern:** `sdd-kit/templates/openspec/infra.md`
  - **Gate:** `grep -q 'OSV-Scanner' sdd-kit/templates/openspec/infra.md`

## 5. AGENTS.md (R2)

- [x] 5.1 Actualizar `AGENTS.md`: ≤10 linhas em Integrações — PR Renovate (patch=tipo A, major/minor=tipo B/C); OSV vermelho=tipo B fix deps; independente da tarefa A–E; linha em Contexto sob demanda
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-supply-chain` — Agent classification of supply-chain PRs
  - **Gate:** `grep -q 'Renovate' AGENTS.md && grep -q 'OSV' AGENTS.md`

- [x] 5.2 Espelhar em `sdd-kit/templates/AGENTS.core.md`
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Gate:** `grep -q 'Renovate' sdd-kit/templates/AGENTS.core.md`

## 6. Guia canónico §2.13 (R4)

- [x] 6.1 Adicionar **§2.13 Supply chain (Renovate + OSV-Scanner)** em `doc/sistema-sdd-pedro.md`: quando corre OSV; como ler falha no Actions; `[AÇÃO MANUAL NECESSÁRIA]` instalar app Renovate; preset conservador; automerge patches (opt-in branch protection); troubleshooting; rollback; checklist volume PRs Renovate em repo APP piloto
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Invariants:** `sdd-supply-chain` — Manual Renovate activation documented
  - **Gate:** `grep -q '2.13' doc/sistema-sdd-pedro.md && grep -q 'OSV-Scanner' doc/sistema-sdd-pedro.md`

- [x] 6.2 Actualizar índice e rotas de instalação (§2.1 checklist) com ponteiro para §2.13
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q '2.13' doc/sistema-sdd-pedro.md`

## 7. Avaliação (R5)

- [x] 7.1 Actualizar `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G8 → **Adoptado** — change `add-supply-chain-gates`; nota AGPL Renovate; condição de reavaliação (composição workflow quando PR-Agent G7 fase 2)
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Gate:** `grep -q 'add-supply-chain-gates' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md && grep -q 'Adoptado' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`

## 8. Specs — promoção

- [x] 8.1 Promover `openspec/changes/add-supply-chain-gates/specs/sdd-supply-chain/spec.md` para `openspec/specs/sdd-supply-chain/spec.md`
  - **Pattern:** `openspec/specs/sdd-ci-gates/spec.md`
  - **Gate:** `test -f openspec/specs/sdd-supply-chain/spec.md`

- [x] 8.2 Aplicar delta `openspec/changes/add-supply-chain-gates/specs/sdd-ci-gates/spec.md` em `openspec/specs/sdd-ci-gates/spec.md` (merge ADDED/MODIFIED)
  - **Pattern:** `openspec/specs/sdd-ci-gates/spec.md`
  - **Gate:** `grep -q 'OSV-Scanner' openspec/specs/sdd-ci-gates/spec.md`

## 9. Validação

- [x] 9.1 Correr `bash scripts/verify-task-patterns.sh` sobre este `tasks.md`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [x] 9.2 Validar change com openspec CLI
  - **Pattern:** `openspec/changes/add-supply-chain-gates/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-supply-chain-gates --strict`

## 10. Pós-registro (best-effort)

- [x] 10.1 `graphify update .` + `npx gitnexus analyze --force` se disponíveis
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify ❌ em infra.md)'`
