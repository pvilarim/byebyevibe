## Why

Sem dados sobre retrabalho, tempo propose→archive e changes corrigidos pós-archive, é impossível calibrar o overhead do pipeline SDD. O research tipo E (`explore-oss-coverage-gaps`, gap **G4**) avaliou **Apache DevLake** e **adiou** a adopção: plataforma DORA pesada (MySQL + Grafana + workers) que não mede as métricas específicas do SDD. A decisão ancorada foi **correcção manual** — script local `scripts/sdd-metrics.sh` derivado de git + `openspec/changes/archive/`.

**Objectivo:** materializar o gap G4 como script sob demanda (modo **C**), sem adoptar DevLake, sem binário/hook/serviço novo, e distribuí-lo via `sdd-kit` com registro no contrato de 6 pontos.

Esta inserção qualifica para a **excepção de piloto** (`metodologia-insercao.md` Fase 2): script bash local (git + filesystem), sem binário externo, hook ou consumo LLM → **Fase 1 → Fase 3 directo** (precedente G1 `add-sdd-ci-gates-workflow`).

## What Changes

- **Script `scripts/sdd-metrics.sh`:** relatório markdown sob demanda com (1) contagem de changes activos/arquivados por período, (2) lead time propose→archive (proxy: primeiro commit com change-id → data do archive), (3) proxy de rework (`fix:` pós-archive referenciando change-id, R9), (4) changes/commits pós-archive que tocam work arquivado.
- **Template kit:** `sdd-kit/templates/scripts/sdd-metrics.sh` + entry no `MANIFEST.yaml` (bump 1.5.0 → **1.6.0**) + check em `verify.sh` se aplicável.
- **Registro contrato 6 pontos:** `infra.md`, `AGENTS.md`, guia §2.17, avaliação G4 (script Adoptado; DevLake permanece Adiado), kit.
- **Delta specs:** nova capability `sdd-metrics`; extensão de `sdd-install-kit` (distribuição do script) e `sdd-workspace-manifest` (linha em `infra.md`).
- **R3 skill/rule:** **N/A** — comando sob demanda documentado em AGENTS.md (≤10 linhas), sem skill dedicada.

## Capabilities

### New Capabilities

- `sdd-metrics`: Script local sob demanda (modo C) que gera relatório markdown de eficácia do framework SDD a partir de git + archive OpenSpec; métricas propose→archive, rework e actividade pós-archive; sem DevLake.

### Modified Capabilities

- `sdd-install-kit`: `MANIFEST.yaml` passa a listar `scripts/sdd-metrics.sh` (template + gate documental); bump de versão do kit.
- `sdd-workspace-manifest`: `openspec/infra.md` ganha registo do script de métricas (estado + "verificar com").

## Impact

- Novo: `scripts/sdd-metrics.sh`, `sdd-kit/templates/scripts/sdd-metrics.sh`
- Modificado: `sdd-kit/MANIFEST.yaml` (entry + bump 1.5.0 → 1.6.0 + checksums), eventualmente `sdd-kit/verify.sh` / `sdd-kit/README.md`
- Modificado: `openspec/infra.md`, `sdd-kit/templates/openspec/infra.md`
- Modificado: `AGENTS.md`, `sdd-kit/templates/AGENTS.core.md`
- Modificado: `doc/sistema-sdd-pedro.md` (nova §2.17 + índice/changelog)
- Modificado: `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` (G4: script Adoptado; DevLake Adiado)
- Modificado: `openspec/project.md` (versão kit / cross-ref se necessário)
- Nova spec: `openspec/specs/sdd-metrics/spec.md` (promovida no archive)
- **Non-goals:** Apache DevLake; dashboards Grafana/DORA; métricas em CI obrigatórias; skill always-on; contadores por ferramenta (extensão futura Fase 5 da metodologia).
- **Issue:** —
