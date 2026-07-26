# Design — Enforcement dos gates SDD em CI (G1)

## Context

- Research tipo E `explore-oss-coverage-gaps` (2026-07-25), gap **G1**: gates SDD sem enforcement no servidor; `pre-commit`/`Lefthook` descartados (overlap com hooks graphify/gitnexus, C3 🔴). Conclusão ancorada: falta um **workflow de CI** que corra comandos já existentes.
- `metodologia-insercao.md` Fase 2: **excepção de piloto aprovada (2026-07-25)** para inserções que só orquestram comandos existentes, sem binário/hook/serviço → Fase 1 → Fase 3 directo.
- Este repo é perfil **DOCS_SPECS** (hub + distribuidor `sdd-kit/`). Os comandos-alvo já existem: `sdd-kit/verify.sh`, `scripts/verify-infra.sh`, `scripts/verify-task-patterns.sh` e `npx openspec validate`.
- Precedente estrutural: `add-sdd-ui-development-module` (add-on versionado + template no kit + registro em 6 pontos).
- Não há `.github/workflows/` no repo hoje — este change cria o primeiro.

## Goals / Non-Goals

**Goals:**

- Workflow GitHub Actions que corre os gates SDD em `push` e `pull_request`, **fail-closed** (bloqueia merge).
- Orquestrar **só comandos existentes** — zero dependência, binário ou hook novo.
- Distribuir o workflow via `sdd-kit/templates/.github/workflows/` para replicação C1.
- Registro completo nos 6 pontos do contrato (Fase 3), com R3 (skill/rule) explicitamente **N/A**.
- Reversibilidade: remover o ficheiro de workflow desactiva o gate (sem estado residual).

**Non-Goals:**

- Reescrever ou criar comandos de verificação (o workflow é orquestração).
- Configurar branch protection / auto-merge (acção manual do operador; documentada como `[AÇÃO MANUAL NECESSÁRIA]`).
- Integrar OSV-Scanner/Renovate (G8) neste change — entram *dentro* deste CI numa fase posterior.
- Instalar GitNexus/Graphify no CI (não são requisitos do gate DOCS_SPECS).

## Knowledge sources consulted (R8)

- `openspec/changes/explore-oss-coverage-gaps/research.md` §G1 — decisão "correcção manual: `.github/workflows/sdd-gates.yml`"
- `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` — Fases 0–3, contrato de 6 pontos, matriz de acionamento (modo A), fail-closed para gates de CI (§0.3)
- `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` — G1 "Adoptado (pendente change)"
- `sdd-kit/verify.sh`, `scripts/verify-infra.sh`, `scripts/verify-task-patterns.sh` — comandos a orquestrar
- `sdd-kit/MANIFEST.yaml`, `sdd-kit/install.sh` — modelo de entry + gate + profiles
- `openspec/changes/add-sdd-ui-development-module/{design,tasks}.md` — precedente de estrutura
- `openspec/project.md` — stack (Node 22.x, Python 3.13; OpenSpec 1.3.1) e perfil DOCS_SPECS

## Alternatives considered

### A — Gestor de git hooks (`pre-commit` / `Lefthook`)

**Rejeitado (research G1):** overlap com hooks existentes (graphify/gitnexus) — C3 🔴; hooks locais são contornáveis (`--no-verify`); enforcement pertence ao servidor.

### B — Workflow GitHub Actions chamando comandos existentes (ESCOLHIDO)

| Prós | Contras |
|------|---------|
| Zero dependência nova | Só cobre repos em GitHub |
| Fail-closed no servidor (não contornável por `--no-verify`) | CI consome minutos (orçado: gates são rápidos, sem LLM) |
| Reversível (apagar o ficheiro) | Requer branch protection manual para bloquear merge de facto |
| Replicável via `sdd-kit/templates/` | |

### C — Status quo (só disciplina local)

**Rejeitado:** deixa o gap G1 aberto — o problema que motivou o research.

## Decisions

| ID | Decisão | Rationale |
|----|---------|-----------|
| D1 | Triggers: `push` (branches base) + `pull_request` | Cobre PR (pré-merge) e commits directos |
| D2 | `npx openspec validate` é o passo **bloqueante** (fail-closed) | É o gate normativo central; determinístico e sem rede externa |
| D3 | `sdd-kit/verify.sh` + `scripts/verify-task-patterns.sh` correm como gates estruturais | Já retornam exit 0/1; encaixam directo |
| D4 | `scripts/verify-infra.sh` corre em **modo tolerante** no CI | Ele muta `infra.md` (sed) e verifica CLIs (GitNexus/Graphify) ausentes no runner — ver "Tratamento do verify-infra" |
| D5 | Node 22.x + Python 3.13 no runner (stack `project.md`) | Paridade com o ambiente declarado |
| D6 | OpenSpec CLI instalado **pinado** (`min_openspec` 1.3.1) antes do validate | F1 (segurança) — versão pinada |
| D7 | Template em `sdd-kit/templates/.github/workflows/sdd-gates.yml`, `merge: COPY`, profiles `[APP, DOCS_SPECS, HYBRID]` | Replicação C1 idêntica ao padrão do kit |
| D8 | R3 (skill/rule) **N/A** — CI é automático out-of-band | Metodologia: só o que precisa interceptar edições é in-band |
| D9 | Bump `MANIFEST.yaml` 1.3.2 → **1.4.0** | Adição de capability à distribuição (minor) |
| D10 | Branch protection / required check = **acção manual** documentada | Fora do escopo de um ficheiro versionável; operador decide |
| D11 | `permissions: contents: read` no workflow | Regra 050 — menor escopo de token |
| D12 | `OPENSPEC_TELEMETRY: "0"` no env do job | `@fission-ai/openspec` envia dados anónimos via PostHog por defeito. Em CI desactivar elimina exfiltração implícita de metadados do repo (nomes de changes, paths). Operadores que adaptem o workflow DEVEM incluir esta variável. Em local: definir no shell ou `.env` (regra 050). |

## Esboço do workflow (`.github/workflows/sdd-gates.yml`)

> Esboço para revisão — implementação final em `/opsx:apply`.

```yaml
name: SDD Gates

on:
  push:
    branches: [main, master]
  pull_request:

permissions:
  contents: read

jobs:
  sdd-gates:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
      - uses: actions/setup-python@v5
        with:
          python-version: '3.13'

      - name: OpenSpec validate (blocking)
        run: npx --yes openspec@1.3.1 validate --all --strict

      - name: sdd-kit verify (structure)
        run: bash sdd-kit/verify.sh

      - name: Task patterns
        run: bash scripts/verify-task-patterns.sh
```

Notas do esboço:
- Nomes de flags (`--all`, `--strict`) e o nome do pacote npm do OpenSpec são **confirmados no apply** contra a versão instalada; se `--all` não existir, iterar os changes activos.
- `sdd-kit/verify.sh` já chama `scripts/verify-infra.sh` internamente — evitar duplicar o passo (ver D4).

## Tratamento do `verify-infra.sh` no CI (D4)

`scripts/verify-infra.sh` tem dois comportamentos incómodos num runner efémero:

1. **Muta `openspec/infra.md`** (`sed -i` de timestamps/markers). No CI é inofensivo (runner descartável, sem commit), mas pode sujar o working tree — mitigar com `git checkout -- openspec/infra.md` no fim, ou correr numa cópia.
2. **Marca FAIL para GitNexus/Graphify ausentes** (não instalados no runner DOCS_SPECS). Isto tornaria o gate falso-negativo.

**Decisão:** o passo bloqueante é `openspec validate`. `verify-infra.sh` corre via `sdd-kit/verify.sh`, cujo resultado é **reportado** mas a política fail-closed aplica-se aos checks estruturais que fazem sentido no CI (existência de scripts/rules/gitignore), não à presença de CLIs de conhecimento. Opções a decidir no apply (menor mudança primeiro):
- (a) `sdd-kit/verify.sh` já isola: `verify-infra` corre com `|| true` na orquestração interna (o `run_check` continua em falha sem abortar) — **confirmar** se o exit final reflecte só os checks relevantes;
- (b) se necessário, introduzir flag `--ci`/`--check` read-only em `verify-infra.sh` num change separado (não neste — mantém escopo mínimo, R4).

Este ponto fica registado como **risco a validar no apply**; não bloqueia a proposta.

## Registro — contrato de 6 pontos (Fase 3)

| # | Onde | Conteúdo | Estado |
|---|------|----------|--------|
| R1 | `openspec/infra.md` | Secção/linha "CI Gates": estado + "verificar com" (`test -f .github/workflows/sdd-gates.yml`) | tasks §5 |
| R2 | `AGENTS.md` | ≤10 linhas em Integrações (gate de CI, fail-closed, comandos que corre) + linha em "Contexto sob demanda" + entrada na tabela Commands | tasks §5 |
| R3 | Skill/rule | **N/A** — automático out-of-band; documentar a ausência intencional (anti-padrão evitado: não criar rule always-on para ferramenta out-of-band) | — |
| R4 | `doc/sistema-sdd-pedro.md` | Secção nova: quando corre, como ler o output, como desbloquear merge, troubleshooting, `[AÇÃO MANUAL]` branch protection | tasks §4 |
| R5 | `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` | G1 → "Adoptado" + referência a este change + condição de reavaliação (revisão ao adicionar OSV/Renovate) | tasks §6 |
| R6 | `sdd-kit/` | Template + entry `MANIFEST.yaml` + bump 1.4.0 + check em `verify.sh` + nota README | tasks §2/§3 |

Pós-registro (best-effort no apply): `graphify update .` + `npx gitnexus analyze --force` — ambos marcados ❌ em `infra.md` neste ambiente; correr se disponíveis, senão registar `[NEEDS VERIFICATION]`.

## Rollback

- Apagar `.github/workflows/sdd-gates.yml` desactiva o gate imediatamente (sem estado residual).
- Reverter o entry no `MANIFEST.yaml` e o bump de versão.
- Remover o template `sdd-kit/templates/.github/workflows/sdd-gates.yml`.
- Reverter linhas de registro (R1/R2/R4/R5). Nenhum binário ou hook instalado → rollback é puramente de ficheiros versionados.

## Riscos e mitigações

| Risco | Mitigação |
|-------|-----------|
| `verify-infra.sh` falso-negativo por CLIs ausentes | D4 — validar exit final no apply; passo bloqueante é `openspec validate` |
| `verify-infra.sh` suja working tree | `git checkout` do `infra.md` ou correr em cópia |
| Nome/flags do pacote OpenSpec no npm divergem | Confirmar no apply; pinar versão (D6) |
| Gate não bloqueia merge sem branch protection | D10 — documentar acção manual no guia (R4) |
| Custo de minutos de CI | Gates são rápidos (sem LLM); orçado como negligenciável |
| Fail-open acidental (workflow verde por erro de config) | `--strict` no validate; testar com um change inválido antes de fechar o change |

## Behavioral parity

- Nenhum comando existente muda de comportamento — o workflow apenas os invoca.
- `sdd-kit/install.sh` (C1) passa a copiar mais um ficheiro (template do workflow); contrato inalterado.
- Repos que não usam GitHub Actions ignoram o template (ficheiro inerte até activado pela plataforma).

## Open questions (resolvidas neste design)

| Pergunta | Resolução |
|----------|-----------|
| Git hooks ou CI? | CI (D1/B) — research G1 |
| `verify-infra.sh` bloqueia CI? | Não directamente; validar no apply (D4) |
| Skill/rule necessária? | N/A (D8) |
| Branch protection no change? | Não — acção manual documentada (D10) |
| Bump de versão do kit? | 1.3.2 → 1.4.0 (D9) |
