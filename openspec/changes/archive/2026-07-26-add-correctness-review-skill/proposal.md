## Why

O sistema SDD dispõe de `simplify-review` (complexidade evitável) e `security-reviewer` (vulnerabilidades), mas não tem nenhuma skill que cave **bugs lógicos, edge cases e violações de contrato** em código gerado por IA — exactamente a categoria de defeito mais frequente e mais custosa de encontrar em review humano tardio. Isso foi identificado como gap G7 em `openspec/changes/explore-oss-coverage-gaps/research.md` e priorizou como segundo item da ordem de implementação recomendada.

## What Changes

- Nova skill `correctness-review` em `.claude/skills/correctness-review/SKILL.md` com espelho em `.cursor/skills/correctness-review/SKILL.md`
- Registro nos 6 pontos do contrato de inserção (metodologia-insercao.md Fase 3): `infra.md`, `AGENTS.md`, skill files, guia `doc/sistema-sdd-pedro.md`, `doc/avaliacoes/`, e instrução de integração no `sdd-kit` para repos de produção
- Actualização da secção "Reviews pós-implementação" em `AGENTS.md` com a posição da skill na ordem de pipeline (pós-apply, antes de `simplify-review`)
- Nova spec `sdd-correctness-review` que normaliza: quando invocar, formato de saída, boundaries (o que nunca flaggar), e integração com o fluxo SDD

## Capabilities

### New Capabilities

- `sdd-correctness-review`: Skill de review on-demand focada em correctness — bugs lógicos, edge cases, violações de contrato e invariantes, comportamento inesperado em código gerado por IA — posicionada na pipeline pós-apply antes do `simplify-review`

### Modified Capabilities

- `sdd-workspace-manifest`: Adicionar linha de `correctness-review` na secção Skills de `openspec/infra.md`

## Impact

- Novos ficheiros: `.claude/skills/correctness-review/SKILL.md`, `.cursor/skills/correctness-review/SKILL.md`, `openspec/specs/sdd-correctness-review/spec.md`
- Modificados: `AGENTS.md` (secção Reviews pós-implementação + tabela Commands), `openspec/infra.md` (Skills), `doc/sistema-sdd-pedro.md` (nova subsecção de operação), `doc/avaliacoes/` (entrada de adopção)
- Sem novas dependências de runtime; sem binário, hook ou consumo de LLM out-of-band — a skill opera via chamada directa do agente (modo C — sob demanda), idêntico ao `simplify-review`
- Piloto dispensável: inserção não instala binário nem hook (excepção aprovada em `metodologia-insercao.md` Fase 2); design.md MUST incluir matriz A–E e plano de rollback (exigência do utilizador)
