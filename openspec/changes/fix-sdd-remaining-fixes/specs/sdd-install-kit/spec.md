## ADDED Requirements

### Requirement: bootstrap-sdd.sh emite aviso em repo HYBRID ambíguo

Quando `package.json` e `openspec/` coexistem, `bootstrap-sdd.sh` MUST emitir um aviso (stderr) pedindo confirmação explícita do perfil antes de continuar com o perfil por defeito (APP). Não deve terminar com erro — o aviso é informativo.

#### Scenario: Repo com package.json e openspec/ coexistindo

- **WHEN** o operador executa `bash scripts/bootstrap-sdd.sh` num repo que tem `package.json` e `openspec/`
- **THEN** o script imprime para stderr `WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID.` e continua a instalação com perfil APP

#### Scenario: Repo APP sem openspec/ não recebe aviso

- **WHEN** o operador executa `bash scripts/bootstrap-sdd.sh` num repo que tem `package.json` mas não tem `openspec/`
- **THEN** o script continua com perfil APP sem nenhum aviso

### Requirement: upgrade.sh classify label alinhado com MANIFEST merge strategy

A saída de `upgrade.sh --dry-run` para ficheiros com `merge: COPY` MUST usar o rótulo `COPY` (não `APPLY_TEMPLATE`), mantendo alinhamento visual com os valores declarados no MANIFEST.

#### Scenario: Dry-run mostra rótulo COPY para ficheiros merge COPY

- **WHEN** o operador corre `bash sdd-kit/upgrade.sh --from X --to Y --dry-run`
- **THEN** ficheiros classificados com `merge: COPY` no MANIFEST aparecem no output com o prefixo `COPY` (não `APPLY_TEMPLATE`)

### Requirement: upgrade.sh header distingue modo dry-run de modo apply

O header impresso por `upgrade.sh` no início do output MUST reflectir o modo de execução: `dry-run` em modo `--dry-run`, `APPLY` em modo `--apply`.

#### Scenario: Header dry-run

- **WHEN** o operador corre `bash sdd-kit/upgrade.sh --from X --to Y --dry-run`
- **THEN** o output contém `SDD UPGRADE REPORT (dry-run)`

#### Scenario: Header apply

- **WHEN** o operador corre `bash sdd-kit/upgrade.sh --from X --to Y --apply --profile DOCS_SPECS` após aprovar o relatório
- **THEN** o output contém `SDD UPGRADE APPLY` (sem `dry-run`)

## MODIFIED Requirements

### Requirement: Deterministic SDD upgrade

`sdd-kit/upgrade.sh` MUST support `--from`, `--to`, `--dry-run`, and MUST generate or update scaffold for `UPGRADE_REPORT.md` per guide §12.8. It MUST NOT apply merges to curated files without `--apply` after human approval. O MANIFEST MUST classificar ficheiros de ferramentas de upgrade (ex.: `scripts/sdd-upgrade-diff.sh`) com `merge: MERGE` para preservar customizações locais.

#### Scenario: Dry-run produces UPGRADE_REPORT scaffold

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from 1.3.2 --to 1.4.0 --dry-run`
- **THEN** `openspec/changes/upgrade-sdd-v1.4.0/UPGRADE_REPORT.md` is created with unchecked approval checkbox and no files are modified in the repo

#### Scenario: Apply blocked without prior approval

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from 1.3.2 --to 1.4.0 --apply --profile DOCS_SPECS` without first approving the UPGRADE_REPORT.md
- **THEN** the script exits non-zero with an error message explaining that the UPGRADE_REPORT must be approved

#### Scenario: sdd-upgrade-diff.sh preserved on apply

- **WHEN** the operator runs `--apply` and has a locally customised `scripts/sdd-upgrade-diff.sh`
- **THEN** the script is classified as `MERGE` and NOT overwritten — the local version is preserved
