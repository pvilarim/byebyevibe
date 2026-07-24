## Why

A regra de segurança em `.cursor/rules/050-security.mdc` exige verificar advisories antes de adicionar dependências, mas o sistema SDD não dispõe de scanner objectivo em CI nem de updates automatizados — dependências velhas ou vulneráveis entram no merge sem gate, e agentes não têm sinal vermelho determinístico para supply chain. O gap **G8** em `openspec/changes/explore-oss-coverage-gaps/research.md` recomenda a dupla **Renovate + OSV-Scanner** como templates no `sdd-kit`, activados por perfil; G1 (`sdd-gates.yml`) já está implementado e é pré-requisito para integrar OSV no mesmo pipeline.

## What Changes

- **OSV-Scanner (Google):** step bloqueante (fail-closed) no workflow `sdd-gates.yml` (hub + template `sdd-kit/templates/`), com action pinada por SHA imutável; scan de lockfiles presentes (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `poetry.lock`, etc.); SKIP quando nenhum lockfile na raiz (perfil DOCS_SPECS sem deps).
- **Renovate (Mend):** template `renovate.json` conservador no `sdd-kit` (agrupamento, schedule, automerge só de patches com CI verde documentado, sem automerge em majors); activado em perfis APP e HYBRID; **SKIP** em DOCS_SPECS.
- **Registro contrato 6 pontos** (metodologia-insercao.md Fase 3): `infra.md`, `AGENTS.md`, guia §2.13, avaliação G8 → Adoptado, `sdd-kit/` (templates + `install.sh` flags + MANIFEST bump).
- **Delta specs:** nova capability `sdd-supply-chain` (requisitos normativos de supply chain) + extensão de `sdd-ci-gates` (OSV no workflow, política fail-closed alargada).
- **Integração SDD:** PR Renovate → tipo A (patch) ou B/C (major/breaking); OSV vermelho → tipo B (corrigir deps antes de merge/archive); independente da tarefa A–E em curso.

## Capabilities

### New Capabilities

- `sdd-supply-chain`: Templates Renovate + OSV por perfil APP/DOCS_SPECS/HYBRID; requisito normativo de que PRs MUST passar OSV-Scanner quando lockfile presente; registro operacional e rollback documentados.

### Modified Capabilities

- `sdd-ci-gates`: O workflow `sdd-gates.yml` passa a incluir step OSV-Scanner bloqueante (quando aplicável); a lista de passos fail-closed inclui OSV além de `openspec validate` e `verify-task-patterns.sh`; excepção documentada à regra "só comandos existentes" para a action OSV pinada por SHA.

## Impact

- **Workflows:** `.github/workflows/sdd-gates.yml`, `sdd-kit/templates/.github/workflows/sdd-gates.yml` (apply — não nesta fase propose).
- **Kit:** `sdd-kit/templates/renovate.json`, `sdd-kit/install.sh` (flags por perfil), `sdd-kit/MANIFEST.yaml` (1.4.0 → 1.5.0 + checksums).
- **Docs:** `openspec/infra.md`, `AGENTS.md`, `sdd-kit/templates/AGENTS.core.md`, `doc/sistema-sdd-pedro.md` (nova §2.13), `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`.
- **Specs:** `openspec/specs/sdd-supply-chain/spec.md` (novo), delta em `openspec/specs/sdd-ci-gates/spec.md`.
- **Dependência:** G1 MUST estar implementado; sem pre-commit/Lefthook para OSV (overlap C3).
- **Non-goals neste change:** Renovate não substitui review humano em majors; app GitHub Renovate é activação manual (`[AÇÃO MANUAL NECESSÁRIA]`); piloto formal dispensável para OSV (só CI step); checklist manual no guia para volume de PRs Renovate.
