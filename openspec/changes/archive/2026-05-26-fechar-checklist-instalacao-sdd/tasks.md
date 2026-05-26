# Tasks — fechar-checklist-instalacao-sdd

## 1. Verificação §2.8 (piloto spec-pedro)

- [x] 1.1 Confirmar `openspec/project.md` (Purpose, Stack, cross-ref guia v1.1)
- [x] 1.2 Confirmar `AGENTS.md` ≤150 linhas, sem `gitnexus:start`
- [x] 1.3 Confirmar `.gitignore` inclui `AGENTS.tools-generated.md` e `CLAUDE.tools-generated.md`
- [x] 1.4 Confirmar `CLAUDE.md` ≤25 linhas, aponta para `AGENTS.md`
- [x] 1.5 Confirmar `.cursor/rules/000-base.mdc` e `050-security.mdc`
- [x] 1.6 Correr `npx openspec list` (exit 0)
- [x] 1.7 Correr `npx gitnexus status` (up-to-date)
- [x] 1.8 Correr `graphify update .` e confirmar `graphify-out/GRAPH_REPORT.md`
- [x] 1.9 Confirmar `/opsx:propose` operacional (change `fechar-checklist-instalacao-sdd` criado)
- [x] 1.10 Confirmar perfil DOCS_SPECS na tabela Commands de `AGENTS.md`

## 2. Evidência e change anterior

- [x] 2.1 Criar `VERIFICATION.md` com resultados dos comandos §2.8
- [x] 2.2 Marcar item 2.31 em `update-sdd-install-guide-agents-format/tasks.md` como concluído
- [x] 2.3 Arquivar change `update-sdd-install-guide-agents-format` (`/opsx:archive`)

## 3. Fecho deste change

- [x] 3.1 Commit de `VERIFICATION.md` e tasks actualizados (se houver diff)
- [x] 3.2 Arquivar `fechar-checklist-instalacao-sdd` após apply completo
