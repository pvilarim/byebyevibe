## Why

Revisão adversarial do change `add-sdd-ci-gates-workflow` (PR #23) identificou 6 findings que bloqueiam o archive: 2 críticos no código/docs do kit (F-C1-1, F-C1-2) e 4 de normalização da documentação (F-NORM-1, F-NORM-2, F-NORM-3, F-NORM-6). Sem esta correcção, o archive produziria um snapshot com dead code, versões divergentes e spec não promovida.

## What Changes

- **sdd-kit/install.sh** — remover bloco Python dead code (linhas 130–160) que imprime TSV bruto no stdout sem ser consumido; o segundo bloco idêntico (dentro do `while IFS` process substitution) é o correcto e permanece.
- **doc/sistema-sdd-pedro.md** — bump versão `v1.3.2` → `v1.4.0` (linha 5 e prompt §2.0 linha 149).
- **openspec/specs/sdd-ci-gates/spec.md** — promover spec do change para `openspec/specs/` (directory permanente).
- **openspec/changes/add-sdd-ci-gates-workflow/tasks.md** — corrigir gate da task 6.2: o path verificado deve ser `openspec/specs/sdd-ci-gates/spec.md` (destino permanente), não o path dentro do change.
- **sdd-kit/templates/AGENTS.core.md** — adicionar entrada "Gates de CI" na tabela "Contexto sob demanda", bloco "CI Gates (sdd-gates)" na secção Integrações, e linha `openspec validate --all --strict` na tabela Commands.
- **AGENTS.md** — actualizar 2 referências de versão do guia: `(v1.3)` → `(v1.4.0)` e `(v1.3.1)` → `(v1.4.0)`.
- **openspec/infra.md** — actualizar timestamp "Última verificação" de `2026-06-17` para `2026-07-25`.

## Capabilities

### New Capabilities

*(nenhuma — este change não introduz comportamento novo)*

### Modified Capabilities

- `sdd-install-kit`: correcção de dead code em `install.sh` e bump de versão do MANIFEST/guia para 1.4.0
- `sdd-ci-gates`: promoção da spec de change para `openspec/specs/` permanente

## Impact

Ficheiros afectados: `sdd-kit/install.sh`, `doc/sistema-sdd-pedro.md`, `openspec/specs/sdd-ci-gates/spec.md` (novo), `openspec/changes/add-sdd-ci-gates-workflow/tasks.md`, `sdd-kit/templates/AGENTS.core.md`, `AGENTS.md`, `openspec/infra.md`. Todos os findings são Tipo A/B — sem novo comportamento, sem nova dependência.
