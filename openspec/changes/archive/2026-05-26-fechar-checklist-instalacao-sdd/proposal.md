# Proposal — Fechar checklist de instalação SDD (spec-pedro)

## Why

O change `update-sdd-install-guide-agents-format` entregou o guia v1.1.0 e o piloto DOCS_SPECS, mas o checklist §2.8 de `doc/sistema-sdd-pedro.md` ficou com um item manual pendente (reiniciar IDE e validar `/opsx:propose`). Sem fechar formalmente a verificação e arquivar o change anterior, a instalação SDD no `spec-pedro` permanece “quase completa” e não serve de referência auditável para futuras instalações.

## What Changes

- Executar e documentar todos os itens do checklist §2.8 no piloto `spec-pedro`.
- Marcar conclusão no `tasks.md` do change `update-sdd-install-guide-agents-format`.
- Arquivar `update-sdd-install-guide-agents-format` (specs fundidas se aplicável).
- Registar evidência mínima (comandos + resultados) num ficheiro `VERIFICATION.md` no change ou em `openspec/changes/archive/`.
- Validar que `/opsx:propose` e `/opsx:apply` estão operacionais (este comando confirma propose).

## Capabilities

### New Capabilities

- `sdd-post-install-verification`: Requisitos normativos para verificação pós-instalação SDD (checklist §2.8) em repositórios perfil DOCS_SPECS.

### Modified Capabilities

- _(nenhuma — `openspec/specs/` ainda vazio no repo)_

## Impact

- `openspec/changes/update-sdd-install-guide-agents-format/` — arquivo
- `openspec/changes/fechar-checklist-instalacao-sdd/` — novo change
- `openspec/specs/sdd-post-install-verification/` — primeira spec de capacidade SDD
- Sem alteração de código de aplicação; apenas documentação, tasks e arquivo OpenSpec
