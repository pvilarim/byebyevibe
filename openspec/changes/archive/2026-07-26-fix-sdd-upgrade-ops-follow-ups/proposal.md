## Why

A revisão adversarial do sistema SDD (`explore-adversarial-sdd-review`) identificou 6 achados na categoria FOLLOW-UP que ficaram por resolver após o archive de `fix-sdd-upgrade-security` e `fix-sdd-pre-archive`. Estes achados introduzem falsa segurança (check de sessão em CI), ruído operacional (DOCS_SPECS a receber regras TypeScript no upgrade), riscos de operação sem branch de isolamento, e lacunas de documentação de supply chain e de risco arquitectural no MANIFEST.

## What Changes

- **`sdd-kit/upgrade.sh`** — Adicionar flag `--profile APP|DOCS_SPECS|HYBRID` obrigatória; filtrar entradas do MANIFEST por `profiles:` antes de classificar e aplicar (F-C2-5). Bloquear `--apply` se branch actual for `main`/`master` sem `--force` (F-C2-8).
- **`sdd-kit/verify.sh`** — Envolver o check `sdd-session-status.sh` com guarda `[[ -z "${CI:-}" ]]`; em CI o check é semanticamente nulo e incrementa `FAILURES` por ausência de scripts de sessão (F-OPS-3).
- **`sdd-kit/install.sh`** — Emitir `WARN` ao copiar `.github/workflows/sdd-gates.yml` quando variáveis de ambiente de CI não-GitHub forem detectadas (`GITLAB_CI`, `GITEA_ACTIONS`, `TF_BUILD`) (F-OPS-4).
- **`sdd-kit/MANIFEST.yaml`** — Adicionar comentário inline documentando que `gate:` é metadata não executável — nunca deve ser avaliado via `eval` (F-SEC-5).
- **`.cursor/rules/050-security.mdc`** (hub + template) — Adicionar nota sobre risco de eval futuro dos campos `gate:` do MANIFEST (F-SEC-5) e documentar a limitação de supply chain do `npx --yes` sem lockfile (F-SEC-3).

## Capabilities

### New Capabilities
*(nenhuma — todas as mudanças são melhorias operacionais e de documentação de segurança em capabilities existentes)*

### Modified Capabilities
- `sdd-install-kit`: Comportamento do `upgrade.sh` muda — passa a exigir `--profile` e a verificar branch antes de `--apply`.
- `sdd-post-install-verification`: Comportamento do `verify.sh` muda — check de sessão passa a ser suprimido em CI.

## Impact

- **`sdd-kit/upgrade.sh`** — Breaking para operadores que não passavam `--profile` (novo parâmetro obrigatório). Documentado e justificado.
- **`sdd-kit/verify.sh`** — Não breaking; remove falsos positivos em CI.
- **`sdd-kit/install.sh`** — Não breaking; adiciona apenas WARN ao stdout.
- **`sdd-kit/MANIFEST.yaml`** — Não breaking; comentário documental.
- **`.cursor/rules/050-security.mdc`** (hub + template `sdd-kit/templates/.cursor/rules/050-security.mdc`) — Não breaking; adição de texto normativo.
- **`sdd-kit/templates/.github/workflows/sdd-gates.yml`** — Não afectado directamente neste change.
