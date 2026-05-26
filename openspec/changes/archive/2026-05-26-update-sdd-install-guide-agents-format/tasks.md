# Tasks — update-sdd-install-guide-agents-format

## 1. Guia de instalação (v1.1.0)

- [x] 1.1 Front matter “Como usar este documento” + versão 1.1.0
- [x] 1.2 §2.0 prompt instalação assistida por IA
- [x] 1.3 §2.5 expandido (formato alvo, anti-padrões, perfis, on-demand, aninhados)
- [x] 1.4 §2.8 checklist pós-instalação
- [x] 1.5 Templates 12.2 núcleo, 12.2a APP, 12.2b DOCS_SPECS, 12.7 aninhado
- [x] 1.6 Corrigir `graphify update` e `openspec init --tools` em §2 e bootstrap
- [x] 1.7 §13 alinhamento workshop; Changelog do guia

## 2. Piloto spec-pedro

- [x] 2.1 Reescrever `AGENTS.md` (template 12.2b, sem bloco GitNexus duplicado)
- [x] 2.2 Criar `doc/curso/scripts/AGENTS.md`
- [x] 2.3 Actualizar `openspec/project.md` (cross-ref guia v1.1)
- [x] 2.4 Checklist §2.8 (openspec list, gitnexus status, graphify, linhas AGENTS)
- [x] 2.5 `scripts/bootstrap-sdd.sh` conforme guia §12.6
- [x] 2.6 `CLAUDE.md` mínimo (sem bloco `gitnexus:start`)

## 3. OpenSpec

- [x] 3.1 Change `update-sdd-install-guide-agents-format` com proposal, design, tasks

## Verificação

- [x] `npx openspec list` mostra o change (11/15 tasks no CLI)
- [x] `AGENTS.md` ~90 linhas, sem `<!-- gitnexus:start -->`
- [x] `graphify-out/GRAPH_REPORT.md` existe; GitNexus up-to-date
- [x] Reiniciar IDE e testar `/opsx:propose` (validado: change `fechar-checklist-instalacao-sdd`)
