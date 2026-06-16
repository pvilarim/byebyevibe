# Proposal — Template de tasks com pattern pointers e gates

## Why

`tasks.md` no SDD v1.2 é tratado como checklist magra, sem orientação formal para reutilizar código já implementado. Agentes em `/opsx:apply` tendem a reinventar padrões que existem no repo — especialmente em sessões novas após handoff, quando o histórico do chat não carrega contexto de implementação. O workshop TLC spec-driven já usa tasks com gates, skills e “estender código existente”, mas isso não está codificado no guia SDD nem nas skills OpenSpec deste repo. Formalizar um template §12.10 com ponteiros, gates e regras anti-staleness reduz divergência entre agentes sem duplicar o codebase em markdown.

## What Changes

- Adicionar **§12.10** em `doc/sistema-sdd-pedro.md` — template normativo de `tasks.md` com campos `Pattern`, `Gate`, `Invariants`, `Proibido` e limites de snippet.
- Criar capability **`sdd-task-patterns`** — requisitos normativos para tasks de implementação (ponteiros vs snippets, gates determinísticos, validação na propose/apply).
- Actualizar skills **`openspec-propose`** e **`openspec-apply-change`** (Cursor + Claude) — regras para gerar e executar tasks com pattern pointers; `gitnexus impact` antes da primeira task de código.
- Adicionar **`scripts/verify-task-patterns.sh`** — valida que paths em `Pattern:` existem no repo (fail-fast em CI ou pré-archive).
- Actualizar **`AGENTS.md`** — entrada na tabela Contexto sob demanda e regra breve (≤3 linhas) sobre tasks com gates.
- Adicionar checklist **pós-archive** na skill `openspec-archive-change` — “promover pattern estável?” para skill ou referência em `openspec/project.md`.
- Documentar **modelo híbrido de 3 níveis** (pointer → esqueleto → snippet) em `design.md` e §12.10.

## Capabilities

### New Capabilities

- `sdd-task-patterns`: Requisitos para tasks atómicas com pattern pointers, gates verificáveis, limites de snippet, validação de paths, impact check no apply, e promoção pós-archive de padrões estáveis.

### Modified Capabilities

_(nenhuma — alterações são documentação, skills e harness; specs existentes não mudam comportamento normativo)_

## Impact

- `doc/sistema-sdd-pedro.md` — novo §12.10; referência cruzada em §5.2 e §7.2 (Tipo C/D)
- `.cursor/skills/openspec-propose/SKILL.md` + espelhos `.claude/skills/`, `.cursor/commands/opsx-propose.md`, `.claude/commands/opsx/propose.md`
- `.cursor/skills/openspec-apply-change/SKILL.md` + espelhos apply
- `.cursor/skills/openspec-archive-change/SKILL.md` + espelho archive (checklist promoção)
- `scripts/verify-task-patterns.sh` — novo
- `AGENTS.md` — ~5 linhas adicionais (manter ≤150)
- `openspec/specs/sdd-task-patterns/` — nova spec (após archive)
- Sem alteração de código de aplicação; perfil DOCS_SPECS mantido
