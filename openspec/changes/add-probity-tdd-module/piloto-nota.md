# Nota de piloto — Probity (G2)

| Campo | Valor |
|-------|-------|
| **Data** | 2026-07-26 |
| **Change** | `add-probity-tdd-module` |
| **Ambiente apply** | Cloud Agent — hub DOCS_SPECS (`gitnexus-graphify-openspec`) |
| **Estado** | **PILOTO PENDENTE** (não falhou — bloqueado por ausência de worktree APP) |

## Contexto

Fase 2 (`metodologia-insercao.md`) exige piloto num **worktree APP** com Vitest ou pytest, C1 + GitNexus + Graphify activos, **antes** de promover Probity como default-ready em repos consumidores.

Este hub é perfil **DOCS_SPECS** (sem test runner de produção). O ambiente cloud deste apply **não** tem worktree APP disponível (`git worktree list` = só master).

## Critérios (design.md — inalterados)

| Critério | Threshold |
|----------|-----------|
| Latência PreToolUse extra p95 | < 8s (N≥30 edits, 3 hooks) |
| Falsos positivos tipo C | < 15% (N≥5 sessões) |
| Tipo B R6 compliance | 100% (N≥3 sessões) |
| Cursor IDE hooks | Write/Edit disparam **OU** documentar "só Claude Code" |

## O que este apply faz / não faz

| Faz | Não faz |
|-----|---------|
| Scaffolding sdd-kit (script, template `probity.config.ts`, doc 004) | Activar Probity neste hub |
| Registro contrato 6 pontos + migração TDD Guard → Probity | Medir p95 / falsos positivos em sessão real |
| Entradas MANIFEST `profiles: [APP, HYBRID]` com nota piloto pendente | Declarar piloto verde / "Adoptado" sem restrição |

## Próximo passo (operador APP)

```bash
# Num worktree APP com Vitest ou pytest:
bash sdd-kit/install-probity-module.sh --detect
bash sdd-kit/install-probity-module.sh --apply --yes
/plugin marketplace add nizos/probity
/plugin install probity@probity
# Medir critérios acima; actualizar esta nota + avaliação G2 → Adoptado
```

Se critérios falharem → status G2 **"Adiado"**; rollback com `--uninstall`; não promover activação default em consumidores.
