## Why

Revisão adversarial do change `add-sdd-ci-gates-workflow` (PR #23) identificou 11 findings críticos totais; 6 deles não foram incluídos no `fix-sdd-pre-archive` (PR #25) e permanecem abertos. Todos os 6 são 🔴 Crítico: dois constituem vulnerabilidades de segurança activa (path traversal e telemetria sem documentação), e quatro são falhas de comportamento silencioso ou de segurança operacional no fluxo de upgrade. Sem este change, o SDD kit distribui scripts com path traversal explorável (F-SEC-1), o `--dry-run` é anulado silenciosamente (F-C2-1), o diff de `AGENTS.md` é completamente omitido sem aviso (F-C2-3), e o `--apply` pode sobrescrever workflows customizados sem backup (F-C2-4) e sem verificar aprovação prévia (F-C2-6).

## What Changes

- **sdd-kit/upgrade.sh** — (F-C2-1) rejeitar combinação `--dry-run --apply` com `exit 2` e mensagem explícita; (F-C2-4) antes de `cp` em `--apply`, verificar se destino difere do template e criar backup automático `$dest.bak.TIMESTAMP`; (F-C2-6) no início do bloco `--apply`, verificar existência de `$REPORT_FILE` com `[x] Actualização aprovada` e abortar se ausente; (F-SEC-1) validar cada `dest_path` com `realpath --no-symlinks` e verificar que fica dentro de `$REPO_ROOT`.
- **sdd-kit/install.sh** — (F-SEC-1) aplicar mesma guarda de path traversal em `apply_file()`: `realpath --no-symlinks` + verificação de prefixo antes de qualquer `cp`.
- **sdd-kit/templates/scripts/sdd-upgrade-diff.sh** — (F-C2-3) o parser de `CURATED_FILES` deve extrair o campo `source` do MANIFEST e usá-lo como path de staging em vez de assumir que `basename(dest) == basename(template)`; corrige a omissão silenciosa do diff de `AGENTS.md` (que usa `source: templates/AGENTS.core.md`).
- **.github/workflows/sdd-gates.yml** e **sdd-kit/templates/.github/workflows/sdd-gates.yml** — (F-SEC-2) adicionar comentário inline `# Disable CLI telemetry — PostHog` na linha `OPENSPEC_TELEMETRY: "0"`.
- **.cursor/rules/050-security.mdc** e **sdd-kit/templates/.cursor/rules/050-security.mdc** — (F-SEC-2) adicionar nota sobre `OPENSPEC_TELEMETRY=0` e o que a telemetria PostHog do `openspec` CLI colecta.

## Capabilities

### New Capabilities

*(nenhuma — este change não introduz comportamento novo)*

### Modified Capabilities

- `sdd-upgrade-kit`: correcção de 4 falhas comportamentais e de segurança em `upgrade.sh` e `sdd-upgrade-diff.sh`
- `sdd-install-kit`: guarda de path traversal em `install.sh`
- `sdd-ci-gates`: documentação de telemetria em `050-security.mdc` e comentário no workflow

## Impact

Ficheiros afectados: `sdd-kit/upgrade.sh`, `sdd-kit/install.sh`, `sdd-kit/templates/scripts/sdd-upgrade-diff.sh`, `.github/workflows/sdd-gates.yml` (branch PR #23 e/ou master pós-merge), `sdd-kit/templates/.github/workflows/sdd-gates.yml` (idem), `.cursor/rules/050-security.mdc`, `sdd-kit/templates/.cursor/rules/050-security.mdc`. Os findings são todos Tipo A/B — sem novo comportamento, sem nova dependência. A guarda de path traversal é a única alteração que muda o comportamento de execução; os outros fixes adicionam verificações de pré-condição ou documentação.
