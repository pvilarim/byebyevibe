# Proposal — Enforcement dos gates SDD em CI (G1)

## Why

Todos os gates do sistema SDD — `openspec validate`, classificação A–E, regras R1–R11, verificação de infra e de patterns — dependem hoje de **disciplina local**. Nada impede um `merge` sem que a pipeline tenha corrido: hooks locais (`graphify hook install`, PreToolUse do GitNexus) são contornáveis com `--no-verify` e não existem no lado do servidor.

O research tipo E (`explore-oss-coverage-gaps`, gap **G1**) avaliou `pre-commit` e `Lefthook` e **descartou ambos** — são gestores de git hooks e o sistema já tem hooks locais; um terceiro gestor cria overlap (C3 🔴). A conclusão ancorada foi: *o que falta não é ferramenta, é um workflow de CI que execute os comandos já existentes no repo*. A literatura de 2026 converge que enforcement pertence ao CI, não a hooks locais.

**Objectivo:** materializar o enforcement dos gates SDD como um workflow GitHub Actions que orquestra comandos **já existentes** (`npx openspec validate`, `bash sdd-kit/verify.sh`, `bash scripts/verify-infra.sh`), sem introduzir dependência, binário ou hook novo — e distribuí-lo via `sdd-kit/templates/` para replicação noutros projectos.

Esta inserção qualifica para a **excepção de piloto** aprovada em `metodologia-insercao.md` (Fase 2): orquestra apenas comandos existentes, sem binário/hook/serviço novo → **Fase 1 (propose) → Fase 3 (registro) directo**.

## What Changes

### Nova capability: `sdd-ci-gates`

| Artefacto | Função |
|-----------|--------|
| `.github/workflows/sdd-gates.yml` | Workflow que corre os gates SDD em `push` e `pull_request` (fail-closed) |
| `sdd-kit/templates/.github/workflows/sdd-gates.yml` | Cópia versionada para replicação (C1) noutros repos |
| `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` | Actualizar decisão G1: **Adoptado** (referência a este change) |

### Comandos orquestrados (todos já existentes)

| Passo | Comando | Papel no gate |
|-------|---------|---------------|
| Validação de specs | `npx openspec validate --all` (ou por change activo) | **Bloqueante** (fail-closed) |
| Verificação do kit | `bash sdd-kit/verify.sh` | Estrutura do kit + sessão |
| Verificação de infra | `bash scripts/verify-infra.sh` | Manifesto de infra (ver design: modo tolerante a CLIs ausentes) |
| Patterns de tasks | `bash scripts/verify-task-patterns.sh` | Paths de `Pattern:` em changes activos |

Nenhum comando novo é escrito — o workflow é orquestração.

### Registro conforme contrato de 6 pontos (Fase 3)

| # | Onde | O quê |
|---|------|-------|
| R1 | `openspec/infra.md` | Linha "CI Gates" — estado + "verificar com" |
| R2 | `AGENTS.md` | Linha em Integrações + Contexto sob demanda + entrada na tabela Commands |
| R3 | Skill/rule | **N/A** — gate de CI é automático (out-of-band); sem skill nem rule |
| R4 | `doc/sistema-sdd-pedro.md` | Secção nova (operação humana: ler output, desbloquear merge, troubleshooting) |
| R5 | `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` | G1 → "Adoptado" + condições de reavaliação |
| R6 | `sdd-kit/` | Template + entry no `MANIFEST.yaml` + bump de versão + check no `verify.sh` |

## Capabilities

### New Capabilities

- **`sdd-ci-gates`**: workflow de CI (modo A — automático out-of-band) que executa os gates SDD em `push`/`pull_request`, fail-closed, sem dependência nova.

### Modified Capabilities

- **`sdd-install-kit`**: `MANIFEST.yaml` passa a listar o template do workflow com `gate`; `verify.sh` valida a sua presença.
- **`sdd-workspace-manifest`**: `openspec/infra.md` ganha registo do estado dos CI Gates.

## Impact

- Novo: `.github/workflows/sdd-gates.yml`
- Novo: `sdd-kit/templates/.github/workflows/sdd-gates.yml`
- Modificado: `sdd-kit/MANIFEST.yaml` (entry + bump 1.3.2 → 1.4.0)
- Modificado: `sdd-kit/verify.sh` (check do template do workflow)
- Modificado: `sdd-kit/README.md` (nota do gate de CI)
- Modificado: `openspec/infra.md` (linha CI Gates)
- Modificado: `AGENTS.md` (Integrações + Contexto sob demanda + Commands)
- Modificado: `doc/sistema-sdd-pedro.md` (secção operação humana dos gates + changelog)
- Modificado: `openspec/project.md` (Cross-references + versão do kit)
- Modificado: `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` (G1 Adoptado)
- Nova spec: `openspec/specs/sdd-ci-gates/spec.md` (promovida no archive)

## Non-Goals

- Instalar `pre-commit`, `Lefthook` ou qualquer gestor de git hooks (descartados no research — overlap com hooks graphify/gitnexus).
- Escrever comandos de verificação novos — o workflow **só orquestra** os existentes.
- Adicionar OSV-Scanner, Renovate ou PR-Agent (gaps G7/G8 — changes próprios; G8 entra *dentro* deste CI numa fase posterior).
- Auto-merge, branch protection rules ou configuração de repositório fora do ficheiro de workflow (acção manual do operador — documentar em §guia).
- Publicar segredos ou tokens no workflow (regra 050 — usar `GITHUB_TOKEN` de menor escopo apenas se necessário).

## Avaliação da direcção (resumo)

| Opção | Veredicto |
|-------|-----------|
| A — `pre-commit` / `Lefthook` (git hooks) | ❌ Overlap com hooks graphify/gitnexus (C3); contornável por `--no-verify` |
| B — Workflow GitHub Actions chamando comandos existentes | ✅ **Escolhida** — zero dependência, fail-closed no servidor |
| C — Não fazer nada (status quo) | ❌ Gates permanecem sem enforcement |

Fontes e trade-offs completos em `design.md` (R8): `research.md` G1 + `metodologia-insercao.md` Fases 0–3.
