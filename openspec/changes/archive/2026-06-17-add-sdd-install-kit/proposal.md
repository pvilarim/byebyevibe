# Proposal — SDD Install Kit (distribuição reproduzível)

## Why

O guia `doc/sistema-sdd-pedro.md` é o artefacto canónico de **procedimento**, mas hoje também tenta ser a **fonte de payloads** via templates embutidos em §12. Essa abordagem falha na prática:

1. Scripts (`sdd-session-*`, `verify-*`), rules (`015`, `016`) e `openspec/infra.md` são **exigidos** pelas specs `sdd-*` e pelo checklist §2.8, mas **não existem como ficheiros copiáveis** no guia.
2. O fluxo §2.9 pede ao agente **extrair** templates do markdown para `sdd-staging/` — frágil, não determinístico, difícil de auditar.
3. `sdd-upgrade-diff.sh` inventaria apenas 9 ficheiros; as specs exigem 15+.
4. Versão do guia desalinhada (cabeçalho v1.2.0 vs changelog 1.2.1+ vs conteúdo session-coordination sem entrada no changelog).

Instalações noutros repos (APP, DOCS_SPECS, HYBRID) ficam **incompletas** ou dependem de copiar manualmente o estado do repo piloto — violando D1 do design `update-sdd-install-guide-agents-format` (*guia como fonte, não piloto acidental*).

## What Changes

### Nova capability: `sdd-install-kit`

Pasta versionada `sdd-kit/` no repo distribuidor (este hub `spec-pedro`):

| Artefacto | Função |
|-----------|--------|
| `MANIFEST.yaml` | Versão do kit, perfis, lista de ficheiros, gates de verificação |
| `README.md` | Entrada rápida (1 página) |
| `install.sh` | Instalação verde (C1): copia templates, merge por perfil, `--dry-run` |
| `upgrade.sh` | Actualização SDD (C2): diff contra kit, scaffold `UPGRADE_REPORT.md` |
| `verify.sh` | Orquestra `verify-infra` + `verify-task-patterns` + session-status |
| `templates/` | Espelha paths do repo alvo (scripts, rules, skeletons) |

### Guia canónico — nova organização explícita

`doc/sistema-sdd-pedro.md` passa a documentar **três camadas** e **quatro cenários** de instalação (ver design § "Modelo de organização"). Secção nova **§1.6** (ou renumeração equivalente): *Organização do projecto e tipos de instalação*.

| Cenário | Código | Fluxo |
|---------|--------|-------|
| Instalação verde | **C1** | `bootstrap-sdd.sh` (CLIs) + `sdd-kit/install.sh --profile X` |
| Actualização SDD | **C2** | `sdd-kit/upgrade.sh` → `UPGRADE_REPORT` → aprovação → merge |
| Só CLIs | **C2b** | §2.9.4 (sem tocar kit curado) |
| Propagação de specs | **C3** | git/referência em `openspec/specs/` — **sem** reinstall SDD |

Bump guia para **v1.3.0** com changelog alinhado.

### Deltas em specs existentes

- **`sdd-post-install-verification`**: exigir kit instalado, `verify-task-patterns.sh`, referência a `sdd-kit/MANIFEST.yaml`.
- **`sdd-workspace-manifest`**: secção Install Kit em `openspec/infra.md`.

### Ferramentas actualizadas

- `scripts/sdd-upgrade-diff.sh` — inventariar todos os ficheiros do `MANIFEST.yaml`.
- `scripts/bootstrap-sdd.sh` — delegar payloads a `sdd-kit/install.sh` após CLIs.
- `openspec/project.md` — Cross-references: guia v1.3.0 + `sdd-kit/`.

## Onde vive a verdade (modelo em 4 camadas)

| Camada | Artefacto | Papel | Quem lê |
|--------|-----------|-------|---------|
| **Procedimento** | `doc/sistema-sdd-pedro.md` | Como instalar/actualizar; cenários C1–C3 | Humano + agente |
| **Payload versionado** | `sdd-kit/templates/` + `MANIFEST.yaml` | Ficheiros copiáveis, gates | `install.sh` / `upgrade.sh` |
| **Requisitos normativos** | `openspec/specs/sdd-*` | O que MUST existir após instalação | Agente (R2), validação |
| **Estado do repo alvo** | `openspec/infra.md`, `project.md` | O que está ✅ neste workspace | Agente (R10), operador |

**Não** duplicar scripts inteiros no guia — o guia **aponta** para `sdd-kit/`.

## Aplicação por perfil de repositório

| Perfil | C1 install | C2 upgrade | C3 specs |
|--------|------------|------------|----------|
| **APP** | kit + merge AGENTS 12.2a + `project.md` local | upgrade.sh + MERGE Commands locais | consome specs do hub via referência |
| **DOCS_SPECS** | kit + merge 12.2b (este repo) | idem | publica specs aqui |
| **HYBRID** | kit + merge 12.2a+b | idem | specs domínio no hub; código no app |

## Capabilities

### New Capabilities

- **`sdd-install-kit`**: distribuição versionada, install/upgrade/verify scripts, MANIFEST, templates completos.

### Modified Capabilities

- **`sdd-post-install-verification`**: gates do kit, lista completa de ficheiros.
- **`sdd-workspace-manifest`**: registo do kit em `infra.md`.

## Impact

- Novo: `sdd-kit/**`
- Modificado: `doc/sistema-sdd-pedro.md` (§1.6, §2, §2.9, §12, changelog v1.3.0)
- Modificado: `scripts/sdd-upgrade-diff.sh`, `scripts/bootstrap-sdd.sh`
- Modificado: `openspec/project.md`, `openspec/infra.md`
- Modificado: `AGENTS.md` (entrada contexto `sdd-kit/` se couber em ≤150 linhas)

## Non-Goals

- Pacote npm publicado (`@pedro/sdd-kit`) — fase 2; pasta no repo primeiro.
- Reinstalar SDD ao publicar specs de domínio (C3 ≠ C2).
- Substituir `openspec init` / harness gerado pelas ferramentas.
- Copiar specs de domínio do hub para APP automaticamente.

## Avaliação da direcção (resumo)

| Opção | Veredicto |
|-------|-----------|
| A — Só guia `.md` (actual) | ❌ Insuficiente para instalação segura reproduzível |
| B — Guia + `sdd-kit/` pasta versionada | ✅ **Escolhida** — procedimento + payload separados |
| C — Pacote npm semver | ⏳ Fase 2 após estabilizar MANIFEST |
| D — Copiar sempre do piloto | ❌ Acoplamento; viola D1 |

Ver `design.md` para trade-offs completos.
