# Tasks — fix-sdd-remaining-fixes

> Fonte: `explore-adversarial-sdd-review/research.md` (2026-07-25)  
> Classificação: Tipo A/B · Sem novo comportamento · Sem nova dependência

## 1. upgrade.sh — correcções de output (F-C2-2, F-C2-10)

- [x] 1.1 Tornar header condicional ao modo de execução (F-C2-2)
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `grep -qE '\$DRY_RUN && echo.*dry-run' sdd-kit/upgrade.sh`

- [x] 1.2 Substituir rótulo `APPLY_TEMPLATE` por `COPY` na função `classify()` (F-C2-10)
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `! grep -qF 'APPLY_TEMPLATE' sdd-kit/upgrade.sh`

## 2. MANIFEST.yaml — correcção de merge strategy (F-C2-7)

- [x] 2.1 Alterar `merge: COPY` para `merge: MERGE` na entrada de `scripts/sdd-upgrade-diff.sh`
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -A5 'sdd-upgrade-diff.sh' sdd-kit/MANIFEST.yaml | grep -q 'merge: MERGE'`

## 3. install.sh — remoção de dead code de chmod (F-C1-10)

- [x] 3.1 Remover bloco `chmod` redundante (condição `scripts/*.sh || */*.sh` é subconjunto de `*.sh`)
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `! grep -qF '"$dest" == scripts/*.sh || "$dest" == */*.sh' sdd-kit/install.sh`

## 4. bootstrap-sdd.sh — aviso para perfil HYBRID ambíguo (F-C1-8)

- [x] 4.1 Adicionar detecção de coexistência `package.json` + `openspec/` com aviso de HYBRID
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Gate:** `grep -q 'HYBRID' sdd-kit/templates/scripts/bootstrap-sdd.sh`

## 5. doc/sistema-sdd-pedro.md — documentação (F-C1-7, F-C2-9)

- [x] 5.1 §2.1 — inserir `sdd-kit/install.sh` no diagrama "Ordem importa" entre Graphify e "Curar AGENTS.md" (F-C1-7)
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `awk '/### 2\.1 Ordem importa/,/### 2\.0/' doc/sistema-sdd-pedro.md | grep -q 'install.sh'`

- [x] 5.2 §2.9.7 — substituir item vago de rollback por rollback explícito com `git restore` (F-C2-9)
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q 'git restore' doc/sistema-sdd-pedro.md`

## 6. sdd-gates.yml — comentário no restore de infra.md (F-OPS-7)

- [x] 6.1 Adicionar comentário explicativo ao `git checkout -- openspec/infra.md ... || true` no workflow live
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -qF 'No-op if' .github/workflows/sdd-gates.yml`

- [x] 6.2 Replicar o mesmo comentário no template do kit
  - **Pattern:** `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -qF 'No-op if' sdd-kit/templates/.github/workflows/sdd-gates.yml`

## 7. design.md — distinção git hooks vs Claude Code hooks (F-OPS-8)

- [x] 7.1 Expandir nota de rejeição da alternativa A para distinguir git hooks de `.claude/hooks/` (PreToolUse)
  - **Pattern:** `openspec/changes/add-sdd-ci-gates-workflow/design.md`
  - **Gate:** `grep -qiF 'PreToolUse' openspec/changes/add-sdd-ci-gates-workflow/design.md`
