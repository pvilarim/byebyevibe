# Tasks — fix-sdd-pre-archive

> 6 findings bloqueantes do archive `add-sdd-ci-gates-workflow`. Todos Tipo A/B.
> Research: `openspec/changes/explore-adversarial-sdd-review/research.md`

## 1. F-C1-1 — Remover dead code sdd-kit/install.sh

- [x] 1.1 Remover o primeiro bloco `python3 - <<'PY'` (linhas 130–160) que imprime TSV bruto para stdout sem consumidor; manter apenas o segundo bloco (dentro do `while IFS=$'\t'` process substitution)
  - **Pattern:** `sdd-kit/install.sh`
  - **Invariants:** `sdd-install-kit` — install.sh sem dead code
  - **Gate:** `bash -n sdd-kit/install.sh && python3 -c "import re,sys; t=open('sdd-kit/install.sh').read(); m=re.findall(r\"python3 - <<'PY'\", t); sys.exit(0 if len(m)==1 else 1)"`

## 2. F-C1-2 — Actualizar versão do guia para v1.4.0

- [x] 2.1 Linha 5 de `doc/sistema-sdd-pedro.md`: `v1.3.2` → `v1.4.0`
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q 'v1.4.0' doc/sistema-sdd-pedro.md`

- [x] 2.2 Linha 149 (prompt §2.0) de `doc/sistema-sdd-pedro.md`: `v1.3.0` → `v1.4.0`
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -c 'v1.4.0' doc/sistema-sdd-pedro.md | grep -qv '^0$'`

## 3. F-NORM-1 — Promover spec sdd-ci-gates + corrigir gate task 6.2

- [x] 3.1 Criar `openspec/specs/sdd-ci-gates/spec.md` (cópia de `openspec/changes/add-sdd-ci-gates-workflow/specs/sdd-ci-gates/spec.md`)
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Gate:** `test -f openspec/specs/sdd-ci-gates/spec.md`

- [x] 3.2 Corrigir gate da task 6.2 em `openspec/changes/add-sdd-ci-gates-workflow/tasks.md`: `test -f openspec/changes/add-sdd-ci-gates-workflow/specs/sdd-ci-gates/spec.md` → `test -f openspec/specs/sdd-ci-gates/spec.md`
  - **Pattern:** `openspec/changes/add-sdd-ci-gates-workflow/tasks.md`
  - **Gate:** `grep -q 'test -f openspec/specs/sdd-ci-gates/spec.md' openspec/changes/add-sdd-ci-gates-workflow/tasks.md`

## 4. F-NORM-2 — Adicionar entradas CI Gates em sdd-kit/templates/AGENTS.core.md

- [x] 4.1 Tabela "Contexto sob demanda": adicionar linha `| Gates de CI (sdd-gates, operação) | \`doc/sistema-sdd-pedro.md\` §2.12 · \`.github/workflows/sdd-gates.yml\` |`
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Gate:** `grep -q 'Gates de CI' sdd-kit/templates/AGENTS.core.md`

- [x] 4.2 Secção "Integrações": adicionar bloco `**CI Gates (sdd-gates)**` com referência ao workflow e §2.12
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Gate:** `grep -q 'CI Gates' sdd-kit/templates/AGENTS.core.md`

- [x] 4.3 Tabela "Commands" (bloco `SDD_KIT_COMMANDS`): não aplicável neste template (placeholder) — adicionar nota no bloco de Integrações
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Gate:** `grep -q 'sdd-gates' sdd-kit/templates/AGENTS.core.md`

## 5. F-NORM-3 — Actualizar referências de versão em AGENTS.md

- [x] 5.1 `AGENTS.md` linha com `(v1.3)`: `(v1.3)` → `(v1.4.0)`
  - **Pattern:** `AGENTS.md`
  - **Gate:** `! grep -q '(v1.3)' AGENTS.md`

- [x] 5.2 `AGENTS.md` linha com `(v1.3.1)`: `(v1.3.1)` → `(v1.4.0)`
  - **Pattern:** `AGENTS.md`
  - **Gate:** `! grep -q '(v1.3.1)' AGENTS.md`

## 6. F-NORM-6 — Actualizar timestamp openspec/infra.md

- [x] 6.1 Linha 2 de `openspec/infra.md`: `2026-06-17` → `2026-07-25`
  - **Pattern:** `openspec/infra.md`
  - **Gate:** `grep -q '2026-07-25' openspec/infra.md`
