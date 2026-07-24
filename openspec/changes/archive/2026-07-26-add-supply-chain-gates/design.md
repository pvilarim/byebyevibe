# Design — Supply chain gates (G8: Renovate + OSV-Scanner)

## Context

- Research tipo E `explore-oss-coverage-gaps` (2026-07-25), gap **G8**: regra "verificar advisories" sem tooling; sem updates automatizados nem scanning em CI.
- `metodologia-insercao.md` Fases 0–3: contrato de 6 pontos, modo **A** (automático out-of-band) para OSV e Renovate; G1 MUST preceder G8; OSV/Renovate independentes da classificação A–E.
- `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G8 **Adoptado (pendente change)**.
- G1 implementado: `.github/workflows/sdd-gates.yml` + template espelho; decisões D1–D11 em `openspec/changes/archive/2026-07-26-add-sdd-ci-gates-workflow/design.md`.
- Este repo (hub DOCS_SPECS): OSV só se lockfile na raiz; Renovate **SKIP**.
- Regra 050: actions pinadas por SHA; `permissions: contents: read`; sem secrets no workflow.

### Verificações Fase 0 (resumo)

| # | Verificação | Resultado |
|---|-------------|-----------|
| V1 | Já avaliado? | Sim — `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` G8 Adoptado (pendente) |
| V2 | Superfície | Modo A — CI + scheduled bot; sem hook novo (evita overlap C3 com pre-commit/Lefthook) |
| V3 | Colisão | Nenhuma com graphify/gitnexus hooks |
| V4 | Perfil | Matriz APP / DOCS_SPECS / HYBRID (install.sh) |
| F1 | Segurança | OSV action SHA-pinned; Renovate app = activação manual, sem tokens no repo |
| F2 | Licença | OSV Apache 2.0; Renovate AGPL-3.0 — uso como ferramenta OK, sem redistribuir fork modificado |
| F3 | Governança | OSV Google v2.3.8+; Renovate Mend, releases diários |
| F4 | Reversibilidade | Remover step OSV / template `renovate.json` desactiva gates |
| F5 | Operabilidade | OSV on/off via workflow; Renovate via app GitHub + `renovate.json` |

## Goals / Non-Goals

**Goals:**

- Integrar **OSV-Scanner** como gate fail-closed em `sdd-gates.yml` quando lockfile presente.
- Distribuir **Renovate** (`renovate.json` conservador) via `sdd-kit` para APP/HYBRID.
- Matriz de perfil no `install.sh` (V4); MANIFEST bump 1.4.0 → **1.5.0**.
- Registro completo nos 6 pontos do contrato (R1–R6); delta specs `sdd-supply-chain` + `sdd-ci-gates`.
- Compatibilidade com D1–D11 do G1; plano de rollback documentado.
- Piloto dispensável para OSV (excepção metodologia Fase 2 — só CI step + template).

**Non-Goals:**

- Substituir review humano em updates major do Renovate.
- Automerge em majors por defeito.
- Instalar app GitHub Renovate via script (tokens) — só documentação `[AÇÃO MANUAL NECESSÁRIA]`.
- Renovate em perfil DOCS_SPECS (sem app, sem `renovate.json` por defeito).
- Terceiro gestor de git hooks para scanning (pre-commit/Lefthook).
- Workflow dedicado OSV se integração em `sdd-gates` for suficiente (ver D1).
- Integrar PR-Agent (G7 fase 2) neste change — reavaliar composição do workflow depois.

## Knowledge sources consulted (R8)

- `openspec/changes/explore-oss-coverage-gaps/research.md` §G8 — Renovate + OSV-Scanner, templates por perfil
- `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` — Fases 0–3, contrato 6 pontos, modo A, dependência G1→G8, matriz A–E
- `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` — G8 Adoptado (pendente)
- `.github/workflows/sdd-gates.yml`, `sdd-kit/templates/.github/workflows/sdd-gates.yml` — workflow G1 actual
- `openspec/changes/archive/2026-07-26-add-sdd-ci-gates-workflow/design.md` — D1–D11
- `openspec/specs/sdd-ci-gates/spec.md` — requisitos a estender sem quebrar D4 (report-only verify)
- `.cursor/rules/050-security.mdc` — pin SHA, advisories, F-SEC-5 (`gate:` não eval)
- `sdd-kit/MANIFEST.yaml`, `sdd-kit/install.sh` — perfis e distribuição
- [google/osv-scanner-action](https://github.com/google/osv-scanner-action) — action v2.3.8, SHA `8dc09193bb540e09b23da07ad7e30bd33bf87018`
- [renovatebot/renovate](https://github.com/renovatebot/renovate) — preset e `renovate.json` schema

## Decisions

### D1: OSV dentro de `sdd-gates.yml` (não workflow separado)

**Escolha:** adicionar step `OSV-Scanner (blocking)` no job `sdd-gates` existente, após checkout e antes ou depois dos gates OpenSpec (recomendado: **após** `openspec validate` e `task patterns`, **antes** de `sdd-kit verify` report-only).

**Alternativa descartada:** `.github/workflows/osv-scanner.yml` dedicado com os mesmos triggers.

| Critério | Dentro de sdd-gates | Workflow separado |
|----------|---------------------|-------------------|
| Um check no PR | ✅ "SDD Gates" único | ❌ dois checks |
| Paridade hub/template | ✅ um ficheiro a manter | ❌ dois ficheiros |
| Triggers D1 | ✅ reutiliza | duplicado |
| Reavaliação G7 PR-Agent | um workflow a compor | mais fragmentação |

**Rationale:** research G8 e avaliação G1 antecipam OSV *dentro* do CI existente; menor superfície operacional; D11 (`permissions: contents: read`) mantém-se.

**Compatibilidade D1–D11:**

| ID G1 | Impacto G8 |
|-------|------------|
| D1 triggers | Inalterado |
| D2 openspec blocking | Inalterado |
| D3 task patterns blocking | Inalterado |
| D4 verify report-only | Inalterado — OSV é step separado bloqueante |
| D5 Node/Python setup | Inalterado — OSV action traz binário |
| D6 openspec pin | Inalterado |
| D7 template COPY | Template `sdd-gates.yml` actualizado |
| D8 R3 N/A | Mantém — OSV/Renovate out-of-band |
| D9 MANIFEST bump | 1.4.0 → **1.5.0** |
| D10 branch protection manual | Documentar OSV na §2.13 |
| D11 permissions read | Mantém — OSV não precisa write |

**Excepção à regra G1 "só comandos existentes":** OSV usa GitHub Action pinada (`google/osv-scanner-action/osv-scanner-action@<sha>`). Documentada em delta `sdd-ci-gates` como única dependência externa autorizada para supply chain.

### D2: Pin SHA da action OSV

**Escolha:**

```yaml
uses: google/osv-scanner-action/osv-scanner-action@8dc09193bb540e09b23da07ad7e30bd33bf87018 # v2.3.8
```

**Alternativa descartada:** reusable workflow `osv-scanner-reusable.yml@v2.3.8` — pode arrastar `actions/download-artifact@v8` por tag em releases antigas (política require-SHA transitiva). Preferir action directa com `scan-args` explícitos.

**Apply:** confirmar SHA no tag v2.3.8 no momento do apply; actualizar comentário `# vX.Y.Z`.

### D3: OSV — condição de execução e lockfiles

**Escolha:** step com `if:` baseado em detecção de lockfiles na raiz:

```yaml
if: >-
  hashFiles('package-lock.json', 'pnpm-lock.yaml', 'yarn.lock',
            'poetry.lock', 'Pipfile.lock', 'Cargo.lock', 'go.sum',
            'Gemfile.lock', 'composer.lock') != ''
```

`scan-args` recomendados:

```yaml
with:
  scan-args: |-
    --recursive
    ./
```

- **Política:** fail-closed se vulnerabilidade em lockfile (exit não-zero da action).
- **SKIP:** emitir log `SKIP: no lockfile at repo root — OSV-Scanner not applicable` quando `if` é falso (DOCS_SPECS hub sem deps).

### D4: Modo de acionamento — A para ambos

| Ferramenta | Modo | Quem aciona | Etapa |
|------------|------|-------------|-------|
| OSV-Scanner | A | push/PR (automático) | Pré-merge, no job SDD Gates |
| Renovate | A | Scheduled (bot Mend) | PRs gerados fora da sessão; entram como tipo A/B |

Nenhuma etapa interactiva em explore/propose/apply.

### D5: Matriz de perfil (install.sh / MANIFEST)

| Perfil | OSV-Scanner | Renovate (`renovate.json`) |
|--------|-------------|----------------------------|
| **APP** | Sim — step no `sdd-gates.yml` (se lockfile) | Sim — COPY `templates/renovate.json` + doc app GitHub |
| **DOCS_SPECS** | Sim — **somente se** lockfile na raiz no install | **SKIP** — não copiar `renovate.json` |
| **HYBRID** | Sim | Sim |

Implementação `install.sh`:

- `sdd-gates.yml`: sempre COPY (todos os perfis).
- `renovate.json`: COPY apenas APP/HYBRID; log `SKIP Renovate: profile DOCS_SPECS`.
- Entry MANIFEST com `profiles: [APP, HYBRID]` para `renovate.json`.

### D6: Preset Renovate conservador (campos exactos)

Template `sdd-kit/templates/renovate.json`:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "config:recommended",
    ":dependencyDashboard",
    ":semanticCommits",
    ":separateMajorReleases",
    "group:monorepos"
  ],
  "timezone": "America/Sao_Paulo",
  "schedule": ["before 9am on monday"],
  "prConcurrentLimit": 5,
  "prHourlyLimit": 2,
  "rebaseWhen": "conflicted",
  "packageRules": [
    {
      "description": "Agrupar minor e patch não-major",
      "matchUpdateTypes": ["minor", "patch"],
      "groupName": "non-major dependencies",
      "groupSlug": "non-major"
    },
    {
      "description": "Automerge apenas patches com CI verde",
      "matchUpdateTypes": ["patch"],
      "automerge": true,
      "automergeType": "pr",
      "requiredStatusChecks": ["SDD Gates"]
    },
    {
      "description": "Nunca automerge em majors",
      "matchUpdateTypes": ["major"],
      "automerge": false
    },
    {
      "description": "Minor requer review humano",
      "matchUpdateTypes": ["minor"],
      "automerge": false
    }
  ],
  "lockFileMaintenance": {
    "enabled": true,
    "extends": ["schedule:monthly"]
  },
  "vulnerabilityAlerts": {
    "labels": ["security"],
    "automerge": false
  }
}
```

**Notas operacionais (R4):**

- `requiredStatusChecks: ["SDD Gates"]` e `automerge: true` só funcionam com branch protection + automerge activos no GitHub — documentar como opt-in `[AÇÃO MANUAL NECESSÁRIA]`.
- Sem tokens no repo; app em [github.com/apps/renovate](https://github.com/apps/renovate).

### D7: Integração SDD — classificação de PRs

| Origem | Classificação agente | Acção |
|--------|---------------------|-------|
| Renovate patch | **Tipo A** | Review rápido; merge se CI verde |
| Renovate minor | **Tipo B/C** | Review de breaking behaviour |
| Renovate major | **Tipo B/C** | Review humano obrigatório; sem automerge |
| OSV vermelho no PR | **Tipo B** | Corrigir/atualizar dependência antes de merge ou `/opsx:archive` |

Independente da tarefa A–E em curso na sessão — supply chain opera no repo.

### D8: R3 — skill opcional

**Escolha:** **não** criar skill dedicada; preferir ≤10 linhas em `AGENTS.md` (R2) para classificação Renovate/OSV. Skill só se apply revelar gap de descoberta.

### D9: Piloto Renovate

OSV: piloto dispensável (só CI step). Renovate: checklist manual no guia §2.13 — validar em repo APP piloto que volume de PRs do preset é gerível (ex.: ≤5 PRs/semana após estabilização); sem piloto formal obrigatório se preset documentado.

## Matriz A–E (supply chain vs tarefa em curso)

| Tipo tarefa | OSV (CI) | Renovate (bot) |
|-------------|----------|----------------|
| A — Trivial | Contínuo* | Contínuo* |
| B — Bug fix | Contínuo* | Contínuo* |
| C — Refactor | Contínuo* | Contínuo* |
| D — Feature | Contínuo* | Contínuo* |
| E — Exploração | Contínuo* | Contínuo* |

\* Independentes da classificação — operam sobre o repo (`metodologia-insercao.md` §4.2).

## Registro — contrato de 6 pontos (Fase 3)

| # | Onde | Conteúdo |
|---|------|----------|
| R1 | `openspec/infra.md` + `sdd-kit/templates/openspec/infra.md` | OSV-Scanner (action SHA, estado) + Renovate (config, app manual) |
| R2 | `AGENTS.md` + `sdd-kit/templates/AGENTS.core.md` | Classificar PRs Renovate; OSV vermelho = fix deps (tipo B) |
| R3 | — | N/A — preferir AGENTS.md |
| R4 | `doc/sistema-sdd-pedro.md` **§2.13** | Instalar app Renovate, ler OSV no Actions, preset, troubleshooting |
| R5 | `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` | G8 → Adoptado + referência a este change |
| R6 | `sdd-kit/` | `templates/renovate.json`; OSV em `templates/.../sdd-gates.yml`; `install.sh`; MANIFEST 1.5.0 + `gen-manifest-checksums.sh` |

## Rollback

| Componente | Rollback |
|------------|----------|
| OSV | Remover step OSV de `sdd-gates.yml` (hub + template) — gate desactivado imediatamente |
| Renovate | Remover `renovate.json` + desinstalar app GitHub no repo |
| MANIFEST | Reverter bump 1.5.0 → 1.4.0 e entries novas |
| Docs | Reverter linhas R1/R2/R4/R5 |

Sem binário instalado localmente; sem estado residual além de ficheiros versionados.

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| Falsos positivos OSV bloqueiam merge | Documentar override temporário (pin/advisory ignore) em §2.13; corrigir deps é o caminho preferido |
| Renovate spam de PRs | Preset conservador (schedule, limits, grouping); checklist piloto APP |
| Automerge patches quebram CI | `requiredStatusChecks: ["SDD Gates"]`; automerge opt-in manual |
| AGPL Renovate | Uso como ferramenta OK; registar em avaliação; não redistribuir fork modificado |
| Transitive unpinned actions no OSV upstream | Usar action directa pinada (D2), não reusable workflow |
| Conflito futuro com PR-Agent (G7) | Reavaliar composição do workflow no change G7 fase 2 |
| `npx --yes` transitivo (F-SEC-3) | Documentado em 050; OSV não agrava — não usa npx |

## Migration Plan

1. Apply actualiza template `sdd-gates.yml` e hub (mesmo conteúdo).
2. `install.sh` passa a copiar `renovate.json` por perfil.
3. Consumidores C2: `upgrade.sh --dry-run` → `--apply` para receber templates.
4. Operador: instalar app Renovate (APP/HYBRID); configurar branch protection incluindo SDD Gates.
5. Pós-registro: `graphify update .` + `gitnexus analyze --force` (best-effort).

## Open Questions

| Pergunta | Resolução proposta |
|----------|-------------------|
| OSV antes ou depois de openspec validate? | Depois de validate + task patterns — falhas normativas SDD primeiro |
| Nova capability vs só delta ci-gates? | **`sdd-supply-chain`** para Renovate + requisito PR; delta **`sdd-ci-gates`** para step OSV no workflow |
| Bump MANIFEST minor ou patch? | **Minor** 1.4.0 → 1.5.0 (nova capability distribuída) |
