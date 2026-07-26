## Why

A revisão adversarial `explore-adversarial-sdd-review` (2026-07-25) identificou 43 findings. Os primeiros 32 foram resolvidos em 5 changes anteriores. Restam 9 findings 🟡/🟢 sem change associado — todos Tipo A/B, sem novo comportamento externo, sem nova dependência.

## What Changes

- **`sdd-kit/upgrade.sh`** — header do relatório agora é condicional: mostra `(dry-run)` apenas em modo `--dry-run`; mostra `APPLY` em modo `--apply` (F-C2-2). Rótulo `APPLY_TEMPLATE` no classify substituído por `COPY` para alinhar com o campo `merge: COPY` do MANIFEST e evitar confusão semântica (F-C2-10).
- **`sdd-kit/MANIFEST.yaml`** — entrada `scripts/sdd-upgrade-diff.sh` passa de `merge: COPY` para `merge: MERGE`, evitando que o `--apply` sobrescreva customizações locais do script de diff (F-C2-7).
- **`sdd-kit/install.sh`** — bloco `chmod` duplicado removido: o segundo bloco (`*.sh`) cobre todos os casos do primeiro (`scripts/*.sh || */*.sh`) — dead code de superconjunto eliminado (F-C1-10).
- **`sdd-kit/templates/scripts/bootstrap-sdd.sh`** — detecção de perfil emite aviso explícito quando `package.json` e `openspec/` coexistem, pedindo confirmação manual de `--profile HYBRID` (F-C1-8).
- **`doc/sistema-sdd-pedro.md` §2.1** — diagrama "Ordem importa" inclui `sdd-kit/install.sh` como passo 3b, entre Graphify e "Curar AGENTS.md" (F-C1-7).
- **`doc/sistema-sdd-pedro.md` §2.9.7** — checklist pós-upgrade recebe rollback explícito com `git restore --source=HEAD~1 <file>` (F-C2-9).
- **`.github/workflows/sdd-gates.yml` + template** — step `Restore infra.md` recebe comentário explicando por que o `git checkout` silencia falha (`|| true`) em runners efêmeros (F-OPS-7).
- **`openspec/changes/add-sdd-ci-gates-workflow/design.md`** — alternativa A rejeitada clarifica distinção entre git hooks (contornáveis com `--no-verify`) e `.claude/hooks/` (PreToolUse Claude Code, ortogonais) (F-OPS-8).

## Capabilities

### New Capabilities

_(nenhuma — todas as mudanças são correcções e clarificações sem novo comportamento externo)_

### Modified Capabilities

_(nenhuma — as mudanças não alteram requisitos spec-level existentes; são correcções de implementação e documentação)_

## Impact

- **`sdd-kit/upgrade.sh`** — dois locais editados (linha de header e linha de classify); comportamento funcional inalterado, só output cosmético.
- **`sdd-kit/MANIFEST.yaml`** — `merge` de `sdd-upgrade-diff.sh` muda de `COPY` para `MERGE`; repos que já tenham customizações locais do script passam a preservá-las em `--apply`.
- **`sdd-kit/install.sh`** — duas linhas removidas; resultado idêntico (`chmod +x` já aplicado pelo segundo bloco).
- **`sdd-kit/templates/scripts/bootstrap-sdd.sh`** — novo ramo de detecção HYBRID; sem breaking change (perfis APP/DOCS_SPECS inalterados, aviso novo só quando ambíguo).
- **`doc/sistema-sdd-pedro.md`** — dois locais editados (§2.1 e §2.9.7); documentação only.
- **`sdd-gates.yml`** (live + template) — comentário inline adicionado; sem alteração de comportamento do workflow.
- **`add-sdd-ci-gates-workflow/design.md`** — nota explicativa adicionada na alternativa rejeitada; sem alteração de decisão ou implementação.
