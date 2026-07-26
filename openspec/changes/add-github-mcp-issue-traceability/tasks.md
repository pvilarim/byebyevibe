# Tasks — add-github-mcp-issue-traceability

> Escopo apply após aprovação humana (R7/R11). G5 qualifica para excepção de piloto: Fase 1 → Fase 3 directo (sem binário/hook novo; apenas MCP config + documentação + template inerte).

## 1. openspec/infra.md (R1)

- [x] 1.1 Adicionar entrada `github-mcp-server` na secção MCP Servers de `openspec/infra.md`: versão pinada (v1.7.0 local), estado, verificar com `mcp_get_tools` ou `~/.cursor/mcp.json`
  - **Pattern:** `openspec/infra.md`
  - **Invariants:** `sdd-workspace-manifest` — github-mcp-server in MCP Servers section; `sdd-issue-traceability` — MCP configuration with minimum scope
  - **Gate:** `grep -q 'github-mcp-server' openspec/infra.md`

- [x] 1.2 Espelhar entrada `github-mcp-server` em `sdd-kit/templates/openspec/infra.md`
  - **Pattern:** `sdd-kit/templates/openspec/infra.md`
  - **Invariants:** `sdd-workspace-manifest` — Infra template in sdd-kit mirrors hub
  - **Gate:** `grep -q 'github-mcp-server' sdd-kit/templates/openspec/infra.md`

## 2. AGENTS.md (R2)

- [x] 2.1 Adicionar ≤10 linhas em Integrações de `AGENTS.md` sobre github-mcp-server (modo D — MCP passivo): quando consultar por tipo A–E; nota de overlap com `gh` CLI em cloud agents
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-issue-traceability` — Six-point contract registration
  - **Gate:** `grep -q 'github-mcp' AGENTS.md`

- [x] 2.2 Adicionar linha em "Contexto sob demanda" apontando a `doc/sistema-sdd-pedro.md` §2.14 para operação humana do MCP
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-issue-traceability` — Six-point contract registration
  - **Gate:** `grep -q '2\.14' AGENTS.md`

- [x] 2.3 Espelhar instruções github-mcp em `sdd-kit/templates/AGENTS.core.md` (Integrações + contexto sob demanda)
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Invariants:** `sdd-issue-traceability` — Six-point contract registration
  - **Gate:** `grep -q 'github-mcp' sdd-kit/templates/AGENTS.core.md`

## 3. Skill opcional (R3) — dispensada nesta fase

- [x] 3.1 Confirmar que instrução em AGENTS.md (≤10 linhas) é suficiente — **não** criar skill `.claude/skills/github-issues-mcp/` nesta fase (design D3)
  - **Pattern:** `openspec/changes/add-github-mcp-issue-traceability/design.md`
  - **Gate:** `grep -q 'Sem skill dedicada' openspec/changes/add-github-mcp-issue-traceability/design.md`

## 4. Guia canónico — operação humana (R4)

- [x] 4.1 Adicionar secção `### 2.14 GitHub Issues MCP (github-mcp-server) — operação` em `doc/sistema-sdd-pedro.md`: instalar MCP (endpoint remoto OAuth + alternativa binário local), escopo mínimo `--toolsets issues`, verificar, quando o agente deve ler issues (matriz A–E), troubleshooting, rollback/desligar
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Invariants:** `sdd-issue-traceability` — Operator finds human operation guide
  - **Gate:** `grep -q 'github-mcp' doc/sistema-sdd-pedro.md`

- [x] 4.2 Actualizar changelog do guia (v1.5.0) com entrada §2.14 + referência ao change
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q 'add-github-mcp-issue-traceability' doc/sistema-sdd-pedro.md`

## 5. Avaliação (R5)

- [x] 5.1 Actualizar `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G5 → "Adoptado — change `add-github-mcp-issue-traceability`" + referência a este change + condições de reavaliação
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Invariants:** `sdd-issue-traceability` — Six-point contract registration
  - **Gate:** `grep -q 'add-github-mcp-issue-traceability' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`

## 6. sdd-kit templates (R6)

- [x] 6.1 Criar `sdd-kit/templates/openspec/changes/_template/proposal.md` com scaffold incluindo campo `**Issue:**` (valores: URL, `#123`, ou `—`)
  - **Pattern:** `openspec/changes/add-correctness-review-skill/proposal.md`
  - **Invariants:** `sdd-issue-traceability` — Issue field in proposal template
  - **Gate:** `test -f sdd-kit/templates/openspec/changes/_template/proposal.md && grep -q '**Issue:**' sdd-kit/templates/openspec/changes/_template/proposal.md`

- [x] 6.2 Bump `sdd-kit/MANIFEST.yaml` de 1.4.0 → 1.5.0; adicionar entradas para novos/alterados templates (`openspec/changes/_template/proposal.md`, `openspec/infra.md`, `AGENTS.core.md` se checksum mudou)
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -q 'version: "1.5.0"' sdd-kit/MANIFEST.yaml`

- [x] 6.3 Recalcular checksums: `bash sdd-kit/gen-manifest-checksums.sh`
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`

## 7. Spec promotion

- [x] 7.1 Promover `openspec/changes/add-github-mcp-issue-traceability/specs/sdd-issue-traceability/spec.md` para `openspec/specs/sdd-issue-traceability/spec.md`
  - **Pattern:** `openspec/specs/sdd-correctness-review/spec.md`
  - **Invariants:** `sdd-issue-traceability` — Six-point contract registration
  - **Gate:** `test -f openspec/specs/sdd-issue-traceability/spec.md`

- [x] 7.2 Aplicar delta `sdd-workspace-manifest` ao spec existente `openspec/specs/sdd-workspace-manifest/spec.md`
  - **Pattern:** `openspec/specs/sdd-workspace-manifest/spec.md`
  - **Invariants:** `sdd-workspace-manifest` — github-mcp-server in MCP Servers section
  - **Gate:** `grep -q 'github-mcp-server' openspec/specs/sdd-workspace-manifest/spec.md`

## 8. Validação

- [x] 8.1 Correr `scripts/verify-task-patterns.sh` sobre este `tasks.md`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [x] 8.2 Validar change com openspec CLI
  - **Pattern:** `openspec/changes/add-github-mcp-issue-traceability/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-github-mcp-issue-traceability --strict`

## 9. Pós-registro (best-effort)

- [x] 9.1 `graphify update .` + `npx gitnexus analyze --force` se disponíveis
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify ❌ em infra.md)'`
