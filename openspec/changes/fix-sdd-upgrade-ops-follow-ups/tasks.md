# Tasks — fix-sdd-upgrade-ops-follow-ups

> Fonte: proposal.md + design.md + specs/
> Achados: F-C2-5, F-C2-8, F-OPS-3, F-OPS-4, F-SEC-5, F-SEC-3
> Perfil repo: DOCS_SPECS — tasks de código limitadas a este repo

## 1. upgrade.sh — filtro por profile (F-C2-5)

- [x] 1.1 Adicionar argumento `--profile APP|DOCS_SPECS|HYBRID` ao `upgrade.sh` e ao bloco de help
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `grep -q -- '--profile' sdd-kit/upgrade.sh`

- [x] 1.2 No bloco Python de classificação dry-run, extrair campo `profiles` do MANIFEST e filtrar entradas; sem `--profile` em dry-run: mostrar todas com etiqueta `[all-profiles]`
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `bash sdd-kit/upgrade.sh --from 1.4.0 --to 1.4.0 --dry-run 2>&1 | grep -q 'File classification'`

- [x] 1.3 No bloco de `--apply`, rejeitar com exit 2 se `--profile` não foi fornecido
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `bash sdd-kit/upgrade.sh --from 1.4.0 --to 1.4.0 --apply --repo /tmp 2>&1; [[ $? -eq 2 ]]`

- [x] 1.4 No bloco Python de apply, passar `PROFILE` e filtrar por `profiles` antes de emitir linhas
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `bash sdd-kit/upgrade.sh --from 1.4.0 --to 1.4.0 --profile DOCS_SPECS --dry-run 2>&1 | grep -v '010-typescript\|030-supabase'`

## 2. upgrade.sh — verificação de branch antes de --apply (F-C2-8)

- [x] 2.1 Adicionar argumento `--force` ao `upgrade.sh` (bypass da verificação de branch)
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `grep -q -- '--force' sdd-kit/upgrade.sh`

- [x] 2.2 No início do bloco `if $APPLY`, verificar `git rev-parse --abbrev-ref HEAD` e bloquear com exit 1 se branch for `main` ou `master` e `--force` não foi passado
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `grep -q 'main\|master' sdd-kit/upgrade.sh && grep -q 'force' sdd-kit/upgrade.sh`

## 3. verify.sh — suprimir check de sessão em CI (F-OPS-3)

- [x] 3.1 Envolver o bloco de check `sdd-session-status.sh` em `verify.sh` com guarda `[[ -z "${CI:-}" ]]`; em CI, emitir mensagem informativa sem incrementar `FAILURES`
  - **Pattern:** `sdd-kit/verify.sh`
  - **Gate:** `CI=true bash sdd-kit/verify.sh 2>&1 | grep -v 'FAIL.*sdd-session'`

## 4. install.sh — aviso para CI não-GitHub (F-OPS-4)

- [x] 4.1 Em `apply_file()` do `install.sh`, antes de copiar qualquer ficheiro cujo `dest` comece com `.github/workflows/`, detectar variáveis de ambiente `GITLAB_CI`, `GITEA_ACTIONS`, `TF_BUILD` e emitir WARN para stderr
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `GITLAB_CI=true bash sdd-kit/install.sh --profile APP --dry-run 2>&1 | grep -q 'WARN'`

## 5. MANIFEST.yaml — comentário gate não executável (F-SEC-5)

- [x] 5.1 Adicionar comentário de topo ao `sdd-kit/MANIFEST.yaml` documentando que `gate:` é metadata documental e NUNCA deve ser avaliado via `eval`
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -q 'gate:.*metadata\|metadata.*gate\|NÃO executar\|non-executable' sdd-kit/MANIFEST.yaml`

## 6. 050-security.mdc — documentação de risco eval e supply chain (F-SEC-5 + F-SEC-3)

- [x] 6.1 Adicionar à secção `## CI/CD` do hub `.cursor/rules/050-security.mdc` uma nota sobre o risco de eval futuro do campo `gate:` do MANIFEST e a limitação de supply chain do `npx --yes` sem lockfile
  - **Pattern:** `.cursor/rules/050-security.mdc`
  - **Gate:** `grep -q 'gate\|supply chain\|lockfile\|transitiv' .cursor/rules/050-security.mdc`

- [x] 6.2 Replicar a mesma adição no template distribuído `sdd-kit/templates/.cursor/rules/050-security.mdc`
  - **Pattern:** `sdd-kit/templates/.cursor/rules/050-security.mdc`
  - **Gate:** `grep -q 'gate\|supply chain\|lockfile\|transitiv' sdd-kit/templates/.cursor/rules/050-security.mdc`

## 7. Validação final

- [x] 7.1 Correr `bash scripts/verify-task-patterns.sh` e confirmar que todos os `Pattern:` existem neste repo
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [x] 7.2 Correr `npx openspec validate fix-sdd-upgrade-ops-follow-ups --strict` e confirmar exit 0
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx @fission-ai/openspec validate fix-sdd-upgrade-ops-follow-ups --strict`
