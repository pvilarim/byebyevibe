# Design — Script de métricas SDD (G4: sdd-metrics.sh)

## Context

- Research tipo E `explore-oss-coverage-gaps` (2026-07-25), gap **G4**: sem dados de eficácia do framework (retrabalho, tempo propose→archive, correcções pós-archive).
- Candidato Apache DevLake: C1 🔴, C4 🔴 — mede DORA organizacional, **não** métricas SDD por change-id. Decisão: **Adiado**; preferir correcção manual.
- `metodologia-insercao.md` §4.1: `sdd-metrics.sh` = modo **C** (sob demanda); §Fase 5 liga métricas de adopção a este script.
- `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G4 **Adiado** (DevLake); nota "correcção manual (`sdd-metrics.sh`) preferida".
- Precedente estrutural: `add-sdd-ci-gates-workflow` (G1) — excepção de piloto, registro 6 pontos, distribuição via kit sem binário/hook externo.
- Dados já no repo: `openspec/changes/archive/YYYY-MM-DD-<id>/`, commits Conventional Commits com change-id (R9), changes activos em `openspec/changes/<id>/`.

### Verificações Fase 0 (resumo)

| # | Verificação | Resultado |
|---|-------------|-----------|
| V1 | Já avaliado? | Sim — avaliação G4 Adiado (DevLake); este change adopta a correcção manual recomendada |
| V2 | Superfície | Scripts (modo C) — sem hook, MCP, CI step ou PreToolUse |
| V3 | Colisão | Nenhum `sdd-metrics.sh` existe; nome alinhado a `sdd-session-*` / `sdd-upgrade-diff.sh` |
| V4 | Perfil | APP, DOCS_SPECS, HYBRID — útil em todos (archive + git locais) |
| V5 | Hooks | N/A — sem PreToolUse |
| F1 | Segurança | Só bash + `git`; sem rede, sem tokens, sem eval de MANIFEST `gate:` |
| F2 | Licença | Script próprio do kit (mesmo licenciamento do hub) |
| F3 | Governança | N/A — artefacto local; DevLake permanece adiado com condição de reavaliação |
| F4 | Reversibilidade | Remover script + entry MANIFEST desactiva; sem estado residual |
| F5 | Operabilidade | Invocação manual; `--help`; saída markdown legível (2/3) |

## Goals / Non-Goals

**Goals:**

- Script `scripts/sdd-metrics.sh` que imprime relatório markdown com as três famílias de métricas do research G4.
- Distribuição via `sdd-kit/templates/scripts/` + MANIFEST bump **1.5.0 → 1.6.0**.
- Registro completo nos 6 pontos (R3 = N/A).
- Piloto dispensável (excepção Fase 2 — sem binário/hook/serviço/LLM externo).
- Proxies determinísticos ancorados em git + filesystem (sem LLM, sem API GitHub obrigatória).

**Non-Goals:**

- Adoptar Apache DevLake, Grafana, MySQL ou qualquer stack DORA.
- Tornar o script gate de CI (modo A) — permanece sob demanda (modo C).
- Skill ou rule always-on (R3 N/A).
- Contadores por ferramenta (Probity, OSV, reviews) — extensão futura quando Fase 5 da metodologia o exigir.
- Precisão de calendário de "sessão propose" vs "primeiro commit" — aceitar proxy documentado.
- Dashboard web ou persistência de históricos além do stdout/ficheiro opcional.

## Knowledge sources consulted (R8)

- `openspec/changes/explore-oss-coverage-gaps/research.md` §G4 — DevLake adiado; script `sdd-metrics.sh`
- `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` — Fases 0–3, modo C, contrato 6 pontos, Fase 5 métricas
- `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` — G4 Adiado; condição reavaliação DevLake
- `openspec/changes/archive/2026-07-26-add-sdd-ci-gates-workflow/{proposal,design,tasks}.md` — precedente G1 / excepção piloto
- `scripts/sdd-session-status.sh`, `scripts/sdd-upgrade-diff.sh` — estilo bash do kit
- `sdd-kit/MANIFEST.yaml` v1.5.0 — padrão de entry `scripts/*` + `gate:` documental
- `AGENTS.md` R9 — change-id em commits (base do proxy de rework)
- `openspec/infra.md` — R10; não reinstalar infra

## Decisions

### D1: Modo C — sob demanda (não CI)

| Critério | Modo C (escolhido) | Modo A (CI scheduled) |
|----------|--------------------|------------------------|
| Alinhamento research | ✅ matriz §4.1 | ❌ "fora da pipeline" mas CI adiciona ruído |
| Custo CI | ✅ zero | minutos + artefacto a manter |
| Audiência | Humano em retrospectiva | Bot |

**Rationale:** metodologia e avaliação colocam métricas como comando do utilizador (periódico/retrospectiva), não etapa da pipeline.

### D2: Fontes de dados — só git + filesystem local

**Escolha:** ler `openspec/changes/` (activos), `openspec/changes/archive/` (arquivados), e `git log` / `git log --grep`.

**Alternativa descartada:** GitHub API / `gh` para lead time de PRs — útil mas fora do mínimo; falharia em repos sem GitHub ou cloud agents sem auth.

### D3: Definição das métricas (proxies)

| Métrica | Definição operativa | Output |
|---------|---------------------|--------|
| **M1 — Volume** | Contagem de dirs em `openspec/changes/<id>/` (excl. `archive/`, `_template`) e em `openspec/changes/archive/YYYY-MM-DD-<id>/`; filtro opcional `--since YYYY-MM-DD` na data do archive (ou mtime/`git log` do activo) | Tabela: activos / arquivados no período |
| **M2 — Lead time propose→archive** | Para cada archive `YYYY-MM-DD-<change-id>`: `t_end` = data do prefixo do dir; `t_start` = data do **primeiro** commit cujo subject/body contém o `change-id` (fallback: data do primeiro commit que adicionou `openspec/changes/<id>/proposal.md` se rastreável no histórico); lead = `t_end - t_start` em dias | Lista por change + mediana/p50 e média |
| **M3 — Rework pós-archive** | Commits **após** `t_end` cujo subject casa `^fix(\|:)` **e** menciona o `change-id` arquivado (R9) | Contagem por change-id + total |
| **M4 — Actividade pós-archive** | Subconjunto de M3 **ou** commits pós-`t_end` que tocam paths sob o dir arquivado (se ainda referenciados); reportar M3 como proxy primário de "changes corrigidos pós-archive" | Secção dedicada no relatório |

**Notas de honestidade (documentar no relatório e no guia §2.17):**

- M2 é proxy: o "propose" real pode ser anterior ao primeiro commit (chat-only); ou o change-id só entrar no commit de archive.
- M3 depende de disciplina R9; commits sem change-id não contam (subcontagem).
- Archive date no nome do dir é a fonte canónica de `t_end` (convenção OpenSpec deste hub).

### D4: Interface CLI

```bash
bash scripts/sdd-metrics.sh [--since YYYY-MM-DD] [--output PATH] [--help]
```

| Flag | Comportamento |
|------|----------------|
| (default) | Relatório markdown em stdout; considera todo o archive |
| `--since` | Filtra archives com data de pasta ≥ data; commits de rework também limitados ao período quando aplicável |
| `--output PATH` | Além de stdout, escreve o mesmo markdown em `PATH` |
| `--help` | Uso e definição das métricas (1 ecrã) |

Exit codes: `0` = relatório gerado (incl. archive vazio); `2` = uso inválido; sem dependência de rede.

### D5: Implementação — bash puro + git

**Escolha:** bash (`set -euo pipefail`) + `git` apenas — paridade com `sdd-session-*` / `verify-*.sh`. Sem Python/jq obrigatório.

**Alternativa descartada:** Python para parsing — aceitável no stack, mas aumenta superfície; bash basta para grep/awk de nomes de dirs e `git log --format`.

Esboço de estrutura (apply preenche):

```bash
#!/usr/bin/env bash
# sdd-metrics.sh — relatório de eficácia SDD (G4), modo C
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# parse flags → list archives → compute M1–M4 → emit markdown
```

### D6: Distribuição kit + bump MANIFEST

| Item | Valor |
|------|-------|
| Path | `scripts/sdd-metrics.sh` |
| Source | `templates/scripts/sdd-metrics.sh` |
| merge | `COPY` |
| profiles | `[APP, DOCS_SPECS, HYBRID]` |
| gate (documental) | `test -x scripts/sdd-metrics.sh` |
| version | **1.5.0 → 1.6.0** (nova capability) |
| guide_version | alinhar **1.6.0** se o changelog do guia subir na mesma apply |

Correr `bash sdd-kit/gen-manifest-checksums.sh` após criar o template.

### D7: R3 N/A — descoberta via AGENTS.md

Igual a G1/G8: ≤10 linhas em Commands + Integrações; sem skill. Anti-padrão: rule always-on para ferramenta sob demanda.

### D8: Piloto dispensável

Critérios da excepção Fase 2: sem binário novo, sem hook, sem serviço, sem LLM. Script bash local = mesma classe que `sdd-session-status.sh`. Validação no apply: correr o script no hub e confirmar exit 0 + markdown com secções M1–M4.

### D9: Avaliação G4 — split Adoptado / Adiado

| Candidato | Decisão após este change |
|-----------|---------------------------|
| `sdd-metrics.sh` (correcção manual) | **Adoptado** — change `add-sdd-metrics-script` |
| Apache DevLake | **Adiado** (inalterado) — reavaliar se equipe/DORA justificar |

## Matriz A–E

| Tipo tarefa | sdd-metrics.sh |
|-------------|----------------|
| A–E (durante sessão) | Não acionar — fora da pipeline |
| Retrospectiva / calibração | Utilizador corre periodicamente |

Nenhuma etapa interactiva em explore/propose/apply/archive.

## Registro — contrato de 6 pontos (Fase 3)

| # | Onde | Conteúdo |
|---|------|----------|
| R1 | `openspec/infra.md` + template | Linha Metrics: script + `bash scripts/sdd-metrics.sh` |
| R2 | `AGENTS.md` + `AGENTS.core.md` | Commands + ≤10 linhas Integrações / Contexto sob demanda |
| R3 | — | **N/A** |
| R4 | `doc/sistema-sdd-pedro.md` **§2.17** | Quando correr, ler output, proxies, troubleshooting, rollback |
| R5 | `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` | G4 script → Adoptado; DevLake Adiado |
| R6 | `sdd-kit/` | Template script + MANIFEST 1.6.0 + checksums + verify se necessário |

Pós-registro: `graphify update .` + `npx gitnexus analyze --force` (best-effort; graphify pode estar ❌).

## Rollback

| Componente | Rollback |
|------------|----------|
| Script | Remover `scripts/sdd-metrics.sh` + template kit |
| MANIFEST | Remover entry; reverter bump 1.6.0 → 1.5.0; regenerar checksums |
| Docs | Reverter R1/R2/R4/R5 |

Sem estado em `.sdd/`; sem hooks; sem serviços.

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| Proxy M2 impreciso (propose sem commit precoce) | Documentar no relatório e §2.17; aceitar como ordem de grandeza |
| R9 inconsistente → M3 subconta | Mencionar dependência de R9 no `--help` e no guia |
| Nomes de archive sem prefixo data | Skip com WARN; convenção hub é `YYYY-MM-DD-<id>` |
| Performance em monorepos enormes | `git log --grep` por change-id; aceitável para N típico de archives SDD |
| Tentação de adoptar DevLake cedo | Avaliação mantém Adiado; condição explícita de reavaliação |

## Migration Plan

1. Apply cria script + template + MANIFEST + docs + specs.
2. Consumidores C2: `upgrade.sh --dry-run` → `--apply` recebe o script.
3. Operador: correr `bash scripts/sdd-metrics.sh` numa retrospectiva.
4. Sem migração de dados.

## Open Questions

| Pergunta | Resolução proposta |
|----------|-------------------|
| Secção do guia? | **§2.17** (§2.14–2.16 ocupadas) |
| Bump minor vs patch? | **Minor** 1.5.0 → 1.6.0 (nova capability) |
| Incluir changes activos no lead time? | Não — M2 só arquivados (lead completo); activos só em M1 |
| `gh` opcional para PR lead time? | Fora de escopo neste change |
