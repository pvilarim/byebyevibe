# ByeByeVibe — sdd-kit v1.6.1

**ByeByeVibe** is the public name of this project. This folder (`sdd-kit/`) is the versioned **install payload** — commands and paths stay `sdd-kit/*`.

Payload versionado para instalação reproduzível do stack SDD (scripts, rules, skeletons), separado do guia de procedimento `doc/sistema-sdd-pedro.md`.

## What this is (first contact)

**For newcomers from vibe coding / AI-assisted workflows:** this folder is the **install kit** for ByeByeVibe — a versioned control plane (OpenSpec + GitNexus + Graphify, gates, optional modules), **not** an app boilerplate or Next.js starter.

| Human name | Code | When to use |
|------------|------|-------------|
| **Greenfield install** (primeira vez) | **C1** | New repo — bootstrap CLIs, then `install.sh` |
| **Upgrade SDD** (já tens o kit) | **C2** | New guide/kit version — `upgrade.sh --dry-run` → `--apply` |
| **CLI-only refresh** | **C2b** | Update OpenSpec/GitNexus/Graphify without touching curated files |
| **Propagate domain specs** | **C3** | Share `openspec/specs/` via git — **do not** run install/upgrade |
| **UI module** (optional) | **C1-UI** | Design system / Impeccable + shadcn after C1 |
| **Probity / TDD enforce** (optional) | **G2** | APP/HYBRID — `@nizos/probity` after C1 |
| **SDD metrics** (on demand) | **G4** | Retrospectives: lead time, rework — calibrate as you go |

Discovery / hero: hub root [`README.md`](../README.md) (EN). Full procedure (pt-BR): [`doc/sistema-sdd-pedro.md`](../doc/sistema-sdd-pedro.md) §2.0b.

## Cenários

| Código | Situação | Comando de entrada |
|--------|----------|-------------------|
| **C1** | Instalação verde (primeira vez) | `bash scripts/bootstrap-sdd.sh` → `bash sdd-kit/install.sh --profile <PERFIL>` |
| **C2** | Actualização SDD (guia/kit nova versão) | `bash sdd-kit/upgrade.sh --from X --to Y --dry-run` → aprovação → `--apply` |
| **C2b** | Só CLIs desactualizadas | `doc/sistema-sdd-pedro.md` §2.9.4 — **sem** tocar no kit |
| **C3** | Propagação de specs de domínio | git/referência em `openspec/specs/` — **não** correr `install.sh` nem `upgrade.sh` |
| **C1-UI** | Módulo UI opcional (pós-C1) | `bash sdd-kit/install-ui-module.sh --detect` → `--apply [--yes]` — ver guia §2.11 |
| **G2** | Módulo Probity (TDD enforce, pós-C1) | `bash sdd-kit/install-probity-module.sh --detect` → `--apply [--yes]` — pin `@nizos/probity@1.10.0`; guia §2.16 |
| **G4** | Métricas SDD sob demanda (modo C) | `bash scripts/sdd-metrics.sh` — guia §2.17; **não** Apache DevLake |

## Perfis

| Perfil | `--profile` | O que muda |
|--------|-------------|------------|
| APP | `APP` | Commands 12.2a; rules TS/Supabase |
| DOCS_SPECS | `DOCS_SPECS` | Commands 12.2b; `verify-task-patterns.sh` |
| HYBRID | `HYBRID` | APP commands + rules opcionais |

## Comandos rápidos

```bash
# Dry-run (sem escrever ficheiros)
bash sdd-kit/install.sh --profile DOCS_SPECS --dry-run

# Instalar payloads após openspec init
bash sdd-kit/install.sh --profile DOCS_SPECS

# Upgrade com relatório
bash sdd-kit/upgrade.sh --from 1.2.0 --to 1.3.0 --dry-run

# Verificação pós-instalação
bash sdd-kit/verify.sh
```

## Estrutura

```
sdd-kit/
├── MANIFEST.yaml      # Versão, ficheiros, merge strategy, gates
├── install.sh         # C1 — copia templates para paths canónicos
├── install-ui-module.sh      # C1-UI — módulo UI opcional pós-C1
├── install-probity-module.sh # G2 — Probity (enforceTdd) opcional pós-C1; APP/HYBRID
├── upgrade.sh         # C2 — diff + UPGRADE_REPORT + --apply
├── verify.sh          # Orquestra verify-infra + task-patterns + session-status
└── templates/         # Espelha paths no repo alvo (scripts/, .cursor/rules/, doc/design/, …)
```

## Gate de CI (sdd-gates)

O kit distribui `.github/workflows/sdd-gates.yml` (template em `templates/.github/workflows/`) — workflow GitHub Actions que corre os gates SDD em `push`/`pull_request`, fail-closed no `openspec validate` (versão pinada = `min_openspec`). Só orquestra comandos já existentes; sem dependência nova.

> `[AÇÃO MANUAL NECESSÁRIA]` Para o gate **bloquear merge de facto**, o operador deve activar branch protection no repositório (Settings → Branches → require status check "SDD Gates"). Ver `doc/sistema-sdd-pedro.md` §2.12.

## Skills de review pós-apply (instalação manual)

O kit não inclui script automático para skills de review on-demand (modo C). Para instalar em repositórios consumidores, copiar manualmente os ficheiros de skill:

### correctness-review

```bash
# No repo consumidor (APP ou DOCS_SPECS)
mkdir -p .claude/skills/correctness-review .cursor/skills/correctness-review
cp <caminho-deste-hub>/.claude/skills/correctness-review/SKILL.md .claude/skills/correctness-review/SKILL.md
cp .claude/skills/correctness-review/SKILL.md .cursor/skills/correctness-review/SKILL.md
```

Registar em `openspec/infra.md` do repo consumidor (secção Skills):

```
| `.claude/skills/correctness-review/` + `.cursor/skills/correctness-review/` | review | ✅ |
```

> **Nota:** este padrão é idêntico ao usado para `simplify-review`. Não há script `install.sh` automático nesta fase (Fase 1 — skill local sem binário/hook). Script automático planeado para v1.5.0 se validação em repo APP confirmar adopção.

### simplify-review

Mesmo procedimento acima substituindo `correctness-review` por `simplify-review`.

## Hub vs consumidor

- **Hub (DOCS_SPECS):** commitar `sdd-kit/` completo para distribuir upgrades C2.
- **APP:** pode receber só ficheiros expandidos (`scripts/`, `.cursor/rules/`); manter `sdd-kit/` opcional para upgrades.

## Versão

`MANIFEST.yaml` `version` MUST igualar o changelog §14 de `doc/sistema-sdd-pedro.md` e `openspec/project.md` Cross-references.

Ver guia **§1.6** para o modelo de quatro camadas (procedimento / payload / specs / estado).
