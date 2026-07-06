# SDD Install Kit v1.3.3

Payload versionado para instalação reproduzível do stack SDD (scripts, rules, skeletons), separado do guia de procedimento `doc/sistema-sdd-pedro.md`.

## Cenários

| Código | Situação | Comando de entrada |
|--------|----------|-------------------|
| **C1** | Instalação verde (primeira vez) | `bash scripts/bootstrap-sdd.sh` → `bash sdd-kit/install.sh --profile <PERFIL>` |
| **C2** | Actualização SDD (guia/kit nova versão) | `bash sdd-kit/upgrade.sh --from X --to Y --dry-run` → aprovação → `--apply` |
| **C2b** | Só CLIs desactualizadas | `doc/sistema-sdd-pedro.md` §2.9.4 — **sem** tocar no kit |
| **C3** | Propagação de specs de domínio | git/referência em `openspec/specs/` — **não** correr `install.sh` nem `upgrade.sh` |
| **C1-UI** | Módulo UI opcional (pós-C1) | `bash sdd-kit/install-ui-module.sh --detect` → `--apply [--yes]` — ver guia §2.11 |

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
├── install-ui-module.sh  # C1-UI — módulo UI opcional pós-C1
├── upgrade.sh         # C2 — diff + UPGRADE_REPORT + --apply
├── verify.sh          # Orquestra verify-infra + task-patterns + session-status
└── templates/         # Espelha paths no repo alvo (scripts/, .cursor/rules/, doc/design/, …)
```

## Hub vs consumidor

- **Hub (DOCS_SPECS):** commitar `sdd-kit/` completo para distribuir upgrades C2.
- **APP:** pode receber só ficheiros expandidos (`scripts/`, `.cursor/rules/`); manter `sdd-kit/` opcional para upgrades.

## Versão

`MANIFEST.yaml` `version` MUST igualar o changelog §14 de `doc/sistema-sdd-pedro.md` e `openspec/project.md` Cross-references.

Ver guia **§1.6** para o modelo de quatro camadas (procedimento / payload / specs / estado).
