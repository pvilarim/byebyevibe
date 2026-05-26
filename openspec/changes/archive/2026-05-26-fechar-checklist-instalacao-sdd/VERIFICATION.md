# Verificação pós-instalação SDD — spec-pedro

**Data:** 2026-05-26  
**Guia:** `doc/sistema-sdd-pedro.md` §2.8  
**Perfil:** DOCS_SPECS  
**Commit piloto:** `65b025e`

## Checklist §2.8

| # | Item | Resultado |
|---|------|-----------|
| 1 | `openspec/project.md` com Purpose, Stack, cross-ref guia v1.1.0 | ✅ |
| 2 | `AGENTS.md` ≤150 linhas, sem `gitnexus:start` | ✅ 124 linhas (após remoção pós-`gitnexus analyze`) |
| 3 | `.gitignore` com `AGENTS.tools-generated.md`, `CLAUDE.tools-generated.md` | ✅ |
| 4 | `CLAUDE.md` aponta para `AGENTS.md`, ≤25 linhas úteis | ✅ 22 linhas |
| 5 | `.cursor/rules/000-base.mdc` e `050-security.mdc` | ✅ |
| 6 | `npx openspec list` | ✅ exit 0 |
| 7 | `npx gitnexus status` | ✅ up-to-date (após `gitnexus analyze` em 65b025e) |
| 8 | `graphify-out/GRAPH_REPORT.md` após `graphify update .` | ✅ 679 nodes, 716 edges |
| 9 | `/opsx:propose` operacional | ✅ change `fechar-checklist-instalacao-sdd` criado |
| 10 | Perfil DOCS_SPECS em Commands (`AGENTS.md`) | ✅ nota linha 24 |
| 11 | IDE reiniciada (slash commands) | ✅ confirmado pelo utilizador |

## Comandos executados

```text
npx openspec list
# Changes: update-sdd-install-guide-agents-format ✓ Complete, fechar-checklist-instalacao-sdd 0/15

npx gitnexus analyze
# 709 nodes | 843 edges | indexed commit 65b025e

npx gitnexus status
# Status: up-to-date

graphify update .
# 679 nodes, 716 edges, GRAPH_REPORT.md updated
```

## Nota operacional

`gitnexus analyze` re-injectou blocos `<!-- gitnexus:start -->` em `AGENTS.md` e `CLAUDE.md`. Removidos manualmente conforme §2.5.1 do guia; detalhe permanece em `.claude/skills/gitnexus/` e secção Integrações do `AGENTS.md`.

## Changes relacionados

- `update-sdd-install-guide-agents-format` — arquivado neste apply
- `fechar-checklist-instalacao-sdd` — arquivado após sync de spec
