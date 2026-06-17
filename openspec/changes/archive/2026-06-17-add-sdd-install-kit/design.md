# Design — SDD Install Kit

## Context

- Exploração (sessão anterior): specs `sdd-*` são coerentes mas assumem artefactos que o guia não distribui.
- Design D1 (`update-sdd-install-guide-agents-format`): guia actualiza-se antes do piloto; instalações copiam o **guia**, não acidentes do repo.
- §2.9 já define upgrade com diff + `UPGRADE_REPORT` + aprovação humana — excelente para C2; falta fonte determinística de templates.
- Este repo (`spec-pedro`) é perfil **DOCS_SPECS** + **hub distribuidor** do stack SDD.

## Goals / Non-Goals

**Goals:**

- Instalação **reproduzível** em qualquer repo (APP, DOCS_SPECS, HYBRID) sem depender de LLM a extrair markdown.
- Documentar no guia canónico **organização do projecto** e **matriz de cenários** C1 / C2 / C2b / C3.
- Unificar versão: `MANIFEST.yaml` version = guia §14 changelog = `project.md` Cross-references.
- `upgrade.sh` alimenta `sdd-upgrade-diff.sh` com lista completa de ficheiros curados.
- Manter separação: **upgrade SDD** (infra) vs **propagação de specs** (conteúdo normativo).

**Non-Goals:**

- npm publish na v1.3.0.
- Instalador gráfico ou extensão IDE.
- Vendor automático de specs de domínio para repos APP.

## Alternatives considered

### A — Expandir §12 até conter todos os scripts (monólito markdown)

| Prós | Contras |
|------|---------|
| Um só ficheiro | ~3000+ linhas; difícil diff e review |
| Sem nova pasta | Agente ainda pode errar na extração |
| | Scripts não executáveis in-place |

**Rejeitado:** mantém fragilidade de parsing; não melhora auditoria.

### B — Guia + `sdd-kit/` pasta versionada (ESCOLHIDO)

| Prós | Contras |
|------|---------|
| `cp`/`rsync` determinístico | Dois artefactos para manter |
| MANIFEST com gates shell | Requer disciplina de release |
| Reutiliza §2.9 (UPGRADE_REPORT) | Migração one-time do piloto |
| Funciona offline | |

**Escolhido:** melhor equilíbrio segurança / simplicidade / alinhamento com §2.9 existente.

### C — Pacote npm `@fission-ai/sdd-kit` ou similar

| Prós | Contras |
|------|---------|
| Semver claro | Overhead publish, auth, CI |
| `npx sdd-kit install` | Terceira dependência além OpenSpec/GitNexus/Graphify |

**Adiado (fase 2):** conteúdo idêntico ao de B; distribuição via npm quando MANIFEST estabilizar.

### D — Git submodule `sdd-kit` em cada repo consumidor

| Prós | Contras |
|------|---------|
| Actualização explícita por commit | Fricção submodule; operadores evitam |
| | Duplica path `sdd-kit/` em cada repo |

**Rejeitado para default:** opcional para equipas avançadas; install.sh copia **uma vez** para paths canónicos do repo (`scripts/`, `.cursor/rules/`).

### E — Copiar manualmente do repo piloto `spec-pedro`

| Prós | Contras |
|------|---------|
| Rápido hoje | Sem versão; drift garantido |
| | Viola D1 |

**Rejeitado:** só aceitável como bootstrap até v1.3.0 estar aplicado.

## Decisions

| ID | Decisão | Rationale |
|----|---------|-----------|
| D1 | `sdd-kit/` na raiz do hub distribuidor | Visível; versionado em git; path estável |
| D2 | Guia = procedimento; kit = payload | Separação clara; guia legível |
| D3 | `MANIFEST.yaml` como fonte para `sdd-upgrade-diff.sh` | Uma lista; sem drift script vs spec |
| D4 | `install.sh` copia para paths **canónicos** do repo (`scripts/`, não `sdd-kit/scripts/` no alvo) | Repo alvo não precisa manter `sdd-kit/` após install — opcional manter como referência |
| D5 | Repo alvo MAY manter `sdd-kit/` (hub) ou só ficheiros expandidos (APP) | DOCS_SPECS mantém kit; APP pode só receber templates expandidos |
| D6 | C3 (specs) nunca dispara `install.sh` | Evita confundir conteúdo com infra |
| D7 | Bump guia v1.3.0 com §1.6 organização + tabela cenários | Responde ao pedido de direcionamento claro |
| D8 | `upgrade.sh --dry-run` obrigatório antes de merge | Segurança §2.9 preservada |
| D9 | Templates em `sdd-kit/templates/` espelham paths finais | `templates/scripts/foo.sh` → `scripts/foo.sh` |

## Modelo de organização do projecto

### Repositório distribuidor (hub — ex.: spec-pedro)

```
repo-hub/
├── doc/sistema-sdd-pedro.md    # Procedimento canónico (C1, C2, C2b, C3)
├── sdd-kit/                    # Payload versionado
│   ├── MANIFEST.yaml
│   ├── install.sh | upgrade.sh | verify.sh
│   └── templates/              # Espelha paths no repo alvo
├── openspec/
│   ├── project.md              # Perfil DOCS_SPECS + ref guia vX.Y.Z
│   ├── infra.md                # Estado ✅ deste workspace
│   └── specs/
│       ├── sdd-*/              # Requisitos do stack SDD
│       └── <domínio>/          # Specs de produto (C3)
├── scripts/                    # Cópia expandida (pós-install ou symlink dev)
├── AGENTS.md
└── .cursor/rules/
```

### Repositório APP (consumidor)

```
repo-app/
├── doc/sistema-sdd-pedro.md    # Copiado ou submodule doc (mesma versão kit)
├── sdd-kit/                    # Opcional: manter para upgrades C2
├── openspec/
│   ├── project.md              # Perfil APP; ref guia + hub specs se aplicável
│   ├── infra.md
│   ├── specs/                  # Specs locais de domínio
│   └── changes/
├── src/                        # Código — tasks Pattern aqui, não no hub
├── scripts/                    # Expandido de sdd-kit/templates/
└── AGENTS.md                   # Merge 12.2a + contexto local
```

### Fluxo de dados entre camadas

```
                    ┌──────────────────────────────────────┐
                    │  doc/sistema-sdd-pedro.md (procedimento) │
                    └─────────────────┬────────────────────┘
                                      │ referencia
                    ┌─────────────────▼────────────────────┐
                    │  sdd-kit/ (payload MANIFEST vX.Y.Z)   │
                    └─────────────────┬────────────────────┘
          install.sh / upgrade.sh     │
                    ┌─────────────────▼────────────────────┐
                    │  Repo alvo: scripts/, rules/, infra    │
                    └─────────────────┬────────────────────┘
                                      │ validado por
                    ┌─────────────────▼────────────────────┐
                    │  openspec/specs/sdd-* + verify.sh      │
                    └──────────────────────────────────────┘
```

## Cenários de instalação (normativos)

### C1 — Instalação verde (primeira vez SDD)

**Pré-condição:** repo Git; sem `openspec/` ou instalação parcial abandonada.

**Ordem:**

1. Copiar ou referenciar `doc/sistema-sdd-pedro.md` + `sdd-kit/` (mesma versão MANIFEST).
2. `bash scripts/bootstrap-sdd.sh` **ou** CLIs manuais §2.2–2.4.
3. `openspec init --tools "cursor,claude"` (se passo 2 não fez).
4. `bash sdd-kit/install.sh --profile APP|DOCS_SPECS|HYBRID [--dry-run]`.
5. Editar `openspec/project.md` (Purpose, Stack — **não** substituir por template).
6. Merge `AGENTS.md` (template `AGENTS.core` + Commands perfil).
7. `bash sdd-kit/verify.sh` + checklist §2.8.
8. Reiniciar IDE.

**Gate final:** `bash sdd-kit/verify.sh && npx openspec list`

### C2 — Actualização SDD (guia/kit nova versão)

**Pré-condição:** SDD já instalado; `openspec/project.md` referencia guia v_anterior.

**Ordem:** §2.9 com kit como staging:

1. Branch `chore/upgrade-sdd-vX.Y.Z`.
2. Actualizar `sdd-kit/` + guia para vX.Y.Z.
3. `bash sdd-kit/upgrade.sh --from v_anterior --to vX.Y.Z --dry-run`.
4. Preencher `UPGRADE_REPORT.md` (§12.8).
5. **PARAR** — aprovação humana.
6. `bash sdd-kit/upgrade.sh --apply` (apenas ficheiros aprovados).
7. §2.9.4 CLIs + `openspec update` + restaurar AGENTS se sobrescrito.
8. Actualizar `project.md` Cross-references → vX.Y.Z.
9. `bash sdd-kit/verify.sh` + §2.9.7.

**Nunca:** `openspec init` de novo; substituir AGENTS/project sem relatório.

### C2b — Só actualização de CLIs

Ferramentas desactualizadas; ficheiros curados OK. Apenas §2.9.4 + `verify-infra.sh`.

### C3 — Propagação de specs (sem reinstall SDD)

**Pré-condição:** consumidor já tem SDD (C1 feito).

**Acções:**

- Hub publica/atualiza `openspec/specs/<domínio>/`.
- Repo APP referencia em `design.md` / `Invariants` nas tasks.
- Implementação: change OpenSpec **no repo APP** com Pattern local GitNexus.
- **Não** correr `install.sh` nem `upgrade.sh` salvo delta em specs `sdd-*`.

## MANIFEST.yaml (esboço)

```yaml
version: "1.3.0"
guide_version: "1.3.0"
min_openspec: "1.3.1"
profiles: [APP, DOCS_SPECS, HYBRID]

files:
  - path: scripts/verify-infra.sh
    source: templates/scripts/verify-infra.sh
    merge: COPY
    gate: "test -x scripts/verify-infra.sh"
  - path: scripts/sdd-session-check.sh
    source: templates/scripts/sdd-session-check.sh
    merge: COPY
    gate: "bash scripts/sdd-session-check.sh --phase explore"
  - path: .cursor/rules/015-session-phases.mdc
    source: templates/.cursor/rules/015-session-phases.mdc
    merge: COPY
    gate: "test -f .cursor/rules/015-session-phases.mdc"
  - path: AGENTS.md
    source: templates/AGENTS.core.md
    merge: MERGE_PROFILE  # une com 12.2a ou 12.2b
    gate: "test $(wc -l < AGENTS.md) -le 150"
  # … lista completa em tasks.md
```

## Guia canónico — conteúdo §1.6 (outline)

Nova secção **§1.6 Organização do projecto e tipos de instalação**:

1. Diagrama 4 camadas (procedimento / payload / specs / estado).
2. Tabela C1 | C2 | C2b | C3 com comando de entrada.
3. Perfis APP / DOCS_SPECS / HYBRID — o que muda no `install.sh --profile`.
4. Hub vs consumidor — onde vive `sdd-kit/`.
5. Regra de ouro: **C3 ≠ C2** (specs de domínio vs infra SDD).
6. Ponteiro: `sdd-kit/README.md` para comandos exactos.

Actualizar tabela "Como usar este documento" no topo do guia.

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| Drift guia ↔ MANIFEST | Release checklist: bump ambos no mesmo commit |
| APP repo sem `sdd-kit/` para C2 | `upgrade.sh` aceita `--kit-path` ou doc com cópia pontual |
| Duplicação templates vs repo vivo | Apply deste change: templates = cópia dos ficheiros actuais do piloto |
| `install.sh` sobrescreve customizações | Default COPY só para ficheiros SDD; MERGE para AGENTS; `--dry-run` |

## Migration Plan

1. Apply `add-sdd-install-kit` no piloto.
2. Popular `sdd-kit/templates/` a partir do estado actual validado.
3. Actualizar guia v1.3.0.
4. Archive → promove `sdd-install-kit` spec.
5. Repos APP existentes: C2 com primeiro `upgrade.sh` v1.3.0.

## Open Questions

- [Q1] APP repos devem commitar `sdd-kit/` inteiro ou só ficheiros expandidos? **Default proposto:** só expandidos; kit via cópia pontual no upgrade.
- [Q2] `doc/sistema-sdd-pedro.md` em APP: copiar do hub ou URL raw? **Default:** copiar com mesma tag/versão MANIFEST.

## Knowledge sources consulted

- `doc/sistema-sdd-pedro.md` §2, §2.9, §12.8–12.10
- `openspec/specs/sdd-post-install-verification/spec.md`
- `openspec/specs/sdd-session-coordination/spec.md`
- `openspec/changes/archive/2026-06-17-add-sdd-session-coordination/proposal.md` (tabela camadas)
- `openspec/changes/archive/2026-05-26-update-sdd-install-guide-agents-format/design.md` (D1)
