# Avaliações de integração e aperfeiçoamento do SDD

Registo histórico de ferramentas, padrões e ideias **avaliadas** para o stack **OpenSpec + GitNexus + Graphify** — independentemente de terem sido adoptadas ou descartadas.

## Propósito

- Documentar **o que foi pesquisado**, **porquê** e **qual a decisão**
- Evitar reavaliar o mesmo candidato sem contexto
- Dar aos agentes uma fonte ancorada (prioridade 6 em `AGENTS.md` — docs do repo) para não propor reinstalação de itens descartados

## Como usar

| Papel | Acção |
|-------|--------|
| Humano | Antes de adoptar uma ferramenta nova ao `sdd-kit`, verificar se já existe avaliação aqui |
| Agente | Ler este índice antes de propor integração de CLIs/MCP/plugins ao stack SDD |
| Nova avaliação | Copiar `TEMPLATE.md`, preencher, adicionar linha na tabela abaixo |

## Estados de decisão

| Estado | Significado |
|--------|-------------|
| **Adoptado** | Integrado no kit, guia ou `openspec/specs/` |
| **Descartado** | Avaliado; não integrar sem nova proposta OpenSpec |
| **Adiado** | Potencial futuro; condições de reavaliação documentadas |
| **Em avaliação** | Trabalho em curso |

## Índice de avaliações

| Data | Candidato | Decisão | Documento |
|------|-----------|---------|-----------|
| 2026-03-26 | [Headroom](https://github.com/chopratejas/headroom) — compressão de contexto para agentes | **Descartado** | [2026-03-26-headroom-context-compression.md](./2026-03-26-headroom-context-compression.md) |
| 2026-06-27 | Módulo UI SDD (Impeccable + Open Design + Pencil + shadcn) — `add-sdd-ui-development-module` | **Adopted** | [2026-06-27-sdd-ui-development-module.md](./2026-06-27-sdd-ui-development-module.md) |

## Relação com o stack

Estas avaliações **não substituem** `openspec/specs/` (requisitos normativos). Adoptar um candidato exige change OpenSpec próprio; descartar fica registado aqui e em `openspec/project.md` (Non-goals), quando aplicável.

Ver também: `doc/sistema-sdd-pedro.md` §5.5 · `openspec/project.md` (Cross-references / Non-goals)
