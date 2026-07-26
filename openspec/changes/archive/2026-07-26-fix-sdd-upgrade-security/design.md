## Context

Revisão adversarial de `add-sdd-ci-gates-workflow` (PR #23) produziu 11 findings críticos. O `fix-sdd-pre-archive` (PR #25) resolveu F-C1-1, F-C1-2, F-NORM-1, F-NORM-2, F-NORM-3 e F-NORM-6. Ficaram em aberto os 6 findings deste change, todos 🔴 Crítico:

- **F-C2-1** — `--dry-run --apply` combinados anulam silenciosamente o `--dry-run`
- **F-C2-3** — `sdd-upgrade-diff.sh` omite silenciosamente o diff de `AGENTS.md`
- **F-C2-4** — `--apply` sobrescreve `.github/workflows/` sem backup nem confirmação
- **F-C2-6** — `--apply` sem verificação do `UPGRADE_REPORT` aprovado
- **F-SEC-1** — path traversal via `path:` do MANIFEST em `install.sh` / `upgrade.sh`
- **F-SEC-2** — telemetria PostHog activa por defeito sem documentação no kit

Research de referência: `openspec/changes/explore-adversarial-sdd-review/research.md`

## Goals / Non-Goals

**Goals:**
- Rejeitar explicitamente a combinação `--dry-run --apply` com mensagem de erro clara
- Corrigir o lookup de `source` no `sdd-upgrade-diff.sh` para que `AGENTS.md` apareça sempre no diff
- Criar backup automático antes de sobrescrever ficheiros com diferenças em `--apply`
- Verificar existência e aprovação do `UPGRADE_REPORT.md` antes de qualquer `--apply`
- Bloquear path traversal em `install.sh` e `upgrade.sh` via `realpath --no-symlinks`
- Documentar telemetria PostHog do `openspec` CLI em `050-security.mdc` e adicionar comentário inline nos workflows

**Non-Goals:**
- Implementar `--profile` em `upgrade.sh` (F-C2-5 — follow-up separado)
- Adicionar verificação de branch em `--apply` (F-C2-8 — follow-up)
- Pinar actions do workflow por SHA (F-SEC-4 — follow-up)
- Adicionar `timeout-minutes` ao workflow (F-SEC-8 — follow-up)
- Resolver F-C1-3, F-C1-5, F-C1-6 e demais findings de follow-up

## Decisions

**D1 — Rejeição mútua `--dry-run --apply` (F-C2-1):**
Adicionar verificação imediatamente após o parsing de argumentos (antes de `$APPLY || DRY_RUN=true`):
```bash
if $DRY_RUN && $APPLY; then
  echo "ERROR: --dry-run e --apply são mutuamente exclusivos" >&2
  exit 2
fi
```
A ordem importa: a verificação deve vir antes da linha 45 (`$APPLY || DRY_RUN=true`) para que a intenção explícita do operador seja preservada.

**D2 — Backup automático em `--apply` (F-C2-4):**
Opção escolhida: backup automático `$dest.bak.$(date +%s)` em vez de `--force`. Racional: o operador que corre `--apply` já aprovou via UPGRADE_REPORT; um prompt interactivo quebraria uso em CI (não-interactivo). O backup garante recuperabilidade sem bloquear o fluxo. Implementado como guarda inline no loop de apply:
```bash
if [[ -f "$REPO_ROOT/$dest" ]] && ! diff -q "$KIT_DIR/$src" "$REPO_ROOT/$dest" &>/dev/null; then
  cp "$REPO_ROOT/$dest" "$REPO_ROOT/$dest.bak.$(date +%s)"
  echo "  BACKUP $dest"
fi
```

**D3 — Verificação de UPGRADE_REPORT (F-C2-6):**
Adicionar no início do bloco `if $APPLY` (antes do loop de apply), antes de qualquer escrita:
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

**D4 — Path traversal (F-SEC-1):**
Guarda aplicada em dois pontos: `apply_file()` em `install.sh` e o loop de apply em `upgrade.sh`. Usar `realpath --no-symlinks` em vez de `realpath` para não resolver symlinks (que poderiam ser usados como vector alternativo). A verificação de prefixo `[[ "$dest_path" == "$REPO_ROOT"/* ]]` cobre todos os casos de `..` no path:
```bash
dest_path="$(realpath --no-symlinks "$REPO_ROOT/$dest")"
[[ "$dest_path" == "$REPO_ROOT"/* ]] || {
  echo "ERROR: path traversal blocked: $dest" >&2
  exit 1
}
```

**D5 — Lookup `source` em `sdd-upgrade-diff.sh` (F-C2-3):**
O bug está no parser Python que extrai apenas `path:` do MANIFEST para construir `CURATED_FILES`. Para `AGENTS.md`, o `source` é `templates/AGENTS.core.md` — não `AGENTS.md`. O fix: extrair pares `(dest, source)` do MANIFEST e, quando um STAGING_DIR for fornecido, usar `source` para construir o path de staging em vez de `dest`. O inventário de ficheiros no repo-alvo continua usando `dest`. A estrutura de dados passa de lista de strings para lista de pares `(dest, source)`.

**D6 — Telemetria PostHog (F-SEC-2):**
Abordagem minimalista alinhada ao scope do change: (a) adicionar comentário inline `# Disable CLI telemetry — PostHog` nos dois workflows (hub e template); (b) adicionar nota em `050-security.mdc` do hub e do template explicando que `OPENSPEC_TELEMETRY=0` desactiva envio de dados via PostHog. Não se documenta o que é colectado (sem fonte verificada) — apenas a existência da variável e o efeito de desactivação.

## Risks / Trade-offs

- **Risco de regressão no `sdd-upgrade-diff.sh`:** a mudança de estrutura de dados (string → tuple) afecta o bloco de diff mas não o bloco de inventário. O gate verifica ambos os caminhos.
- **`realpath --no-symlinks` disponibilidade:** disponível em GNU coreutils ≥8.15 (Linux). macOS usa `realpath` do Homebrew (compatível). Sem risco prático em runners Ubuntu.
- **Backup `bak.TIMESTAMP` pode acumular:** em environments de teste com muitos `--apply`, podem acumular ficheiros `.bak.*`. Aceitável para um upgrade workflow de baixa frequência; sem cleanup automático por ora (R4 — menor mudança razoável).
- **UPGRADE_REPORT path:** `openspec/changes/upgrade-sdd-v${TO_VER}/UPGRADE_REPORT.md` — o utilizador que passar `--to` com versão diferente da usada no dry-run não encontrará o relatório. Mensagem de erro inclui comando correcto de dry-run para remediar.
