# Tasks — fix-sdd-upgrade-security

> 6 findings críticos da revisão adversarial de `add-sdd-ci-gates-workflow` (PR #23) não incluídos no `fix-sdd-pre-archive`.
> Research: `openspec/changes/explore-adversarial-sdd-review/research.md`
> Design: `openspec/changes/fix-sdd-upgrade-security/design.md`

## 1. F-C2-1 — Rejeitar combinação `--dry-run --apply`

- [ ] 1.1 Em `sdd-kit/upgrade.sh`, após o loop de parsing de argumentos (linha ~42) e antes de `$APPLY || DRY_RUN=true` (linha 45), adicionar verificação mútua de exclusão:
  ```bash
  if $DRY_RUN && $APPLY; then
    echo "ERROR: --dry-run e --apply são mutuamente exclusivos" >&2
    exit 2
  fi
  ```
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `grep -q 'mutuamente exclusivos' sdd-kit/upgrade.sh`

## 2. F-C2-3 — Corrigir lookup de AGENTS.md em `sdd-upgrade-diff.sh`

- [ ] 2.1 Substituir o parser Python que extrai apenas `path:` do MANIFEST por um que extrai pares `(dest, source)`. Usar `source` para construir o path de staging e `dest` para o inventário do repo-alvo. O ficheiro `AGENTS.md` tem `source: templates/AGENTS.core.md` — com o fix, o diff procura `$STAGING_DIR/templates/AGENTS.core.md` em vez de `$STAGING_DIR/AGENTS.md`.
  - **Pattern:** `sdd-kit/templates/scripts/sdd-upgrade-diff.sh`
  - **Gate:** `grep -q "source" sdd-kit/templates/scripts/sdd-upgrade-diff.sh`

- [ ] 2.2 Verificar que o diff de `AGENTS.md` aparece quando se corre o script com `sdd-kit/templates/` como STAGING_DIR:
  ```bash
  bash sdd-kit/templates/scripts/sdd-upgrade-diff.sh sdd-kit/templates/ . 2>&1 | grep -qE 'AGENTS\.md|AGENTS\.core'
  ```
  - **Pattern:** `sdd-kit/templates/scripts/sdd-upgrade-diff.sh`
  - **Gate:** `bash sdd-kit/templates/scripts/sdd-upgrade-diff.sh sdd-kit/templates/ . 2>&1 | grep -qE 'AGENTS\.md|AGENTS\.core\.md'`

## 3. F-C2-4 — Backup automático antes de sobrescrever em `--apply`

- [ ] 3.1 Em `sdd-kit/upgrade.sh`, no loop de apply (dentro de `if $APPLY`), antes do `cp` de cada ficheiro, verificar se o destino existe e difere do template; se sim, criar backup `$dest.bak.$(date +%s)`:
  ```bash
  if [[ -f "$REPO_ROOT/$dest" ]] && ! diff -q "$KIT_DIR/$src" "$REPO_ROOT/$dest" &>/dev/null; then
    cp "$REPO_ROOT/$dest" "$REPO_ROOT/$dest.bak.$(date +%s)"
    echo "  BACKUP $dest"
  fi
  ```
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `grep -q '\.bak\.' sdd-kit/upgrade.sh`

## 4. F-C2-6 — Verificar UPGRADE_REPORT aprovado antes de `--apply`

- [ ] 4.1 Em `sdd-kit/upgrade.sh`, no início do bloco `if $APPLY` (antes do loop de apply), adicionar verificação de existência e aprovação do relatório:
  ```bash
  if [[ ! -f "$REPORT_FILE" ]]; then
    echo "ERROR: UPGRADE_REPORT não encontrado: $REPORT_FILE" >&2
    echo "       Correr primeiro: bash sdd-kit/upgrade.sh --from $FROM_VER --to $TO_VER --dry-run" >&2
    exit 1
  fi
  if ! grep -q '\[x\] Actualização aprovada' "$REPORT_FILE"; then
    echo "ERROR: UPGRADE_REPORT existe mas não foi aprovado." >&2
    echo "       Marcar '- [x] Actualização aprovada' em $REPORT_FILE antes de --apply" >&2
    exit 1
  fi
  ```
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `grep -q 'UPGRADE_REPORT não encontrado' sdd-kit/upgrade.sh`

## 5. F-SEC-1 — Guarda de path traversal em `install.sh` e `upgrade.sh`

- [ ] 5.1 Em `sdd-kit/install.sh`, na função `apply_file()`, antes de qualquer escrita (após calcular `dest_path`), adicionar validação:
  ```bash
  dest_path="$(realpath --no-symlinks "$REPO_ROOT/$dest")"
  [[ "$dest_path" == "$REPO_ROOT"/* ]] || {
    echo "ERROR: path traversal blocked: $dest" >&2
    exit 1
  }
  ```
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `grep -q 'path traversal blocked' sdd-kit/install.sh`

- [ ] 5.2 Em `sdd-kit/upgrade.sh`, no loop de apply (dentro de `if $APPLY`), antes de `mkdir -p` e `cp`, adicionar a mesma validação de path traversal:
  ```bash
  dest_path="$(realpath --no-symlinks "$REPO_ROOT/$dest")"
  [[ "$dest_path" == "$REPO_ROOT"/* ]] || {
    echo "ERROR: path traversal blocked: $dest" >&2
    exit 1
  }
  ```
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `grep -q 'path traversal blocked' sdd-kit/upgrade.sh`

## 6. F-SEC-2 — Documentar telemetria PostHog do openspec CLI

- [ ] 6.1 Em `.cursor/rules/050-security.mdc`, adicionar nota sobre `OPENSPEC_TELEMETRY=0`:
  ```
  ## openspec CLI — telemetria
  - `@fission-ai/openspec` envia dados via PostHog por defeito; definir `OPENSPEC_TELEMETRY=0` para desactivar
  - Em CI: a variável está configurada no workflow `sdd-gates.yml` (`OPENSPEC_TELEMETRY: "0"`)
  - Em local: definir no shell ou no `.env` do repo consumidor (nunca commitar o valor)
  ```
  - **Pattern:** `.cursor/rules/050-security.mdc`
  - **Gate:** `grep -q 'OPENSPEC_TELEMETRY' .cursor/rules/050-security.mdc`

- [ ] 6.2 Em `sdd-kit/templates/.cursor/rules/050-security.mdc`, adicionar a mesma nota (idem 6.1):
  - **Pattern:** `sdd-kit/templates/.cursor/rules/050-security.mdc`
  - **Gate:** `grep -q 'OPENSPEC_TELEMETRY' sdd-kit/templates/.cursor/rules/050-security.mdc`

- [ ] 6.3 Nos workflows `sdd-gates.yml` (hub: `.github/workflows/sdd-gates.yml`; template: `sdd-kit/templates/.github/workflows/sdd-gates.yml`), adicionar comentário inline na linha `OPENSPEC_TELEMETRY: "0"`:
  ```yaml
  OPENSPEC_TELEMETRY: "0"  # Disable CLI telemetry — PostHog
  ```
  **Nota:** estes ficheiros existem apenas no branch `origin/cursor/add-sdd-ci-gates-workflow-dfec` (PR #23, ainda DRAFT). No APPLY, extrair os ficheiros desse branch via `git show origin/cursor/add-sdd-ci-gates-workflow-dfec:<path>` e aplicar o comentário antes de commitar.
  - **Gate (hub):** `test -f .github/workflows/sdd-gates.yml && grep -q 'PostHog' .github/workflows/sdd-gates.yml`
  - **Gate (template):** `test -f sdd-kit/templates/.github/workflows/sdd-gates.yml && grep -q 'PostHog' sdd-kit/templates/.github/workflows/sdd-gates.yml`
