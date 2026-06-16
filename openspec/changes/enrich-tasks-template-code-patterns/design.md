# Design — Template de tasks com pattern pointers e gates

## Context

- Exploração `/opsx:explore` (Jun 2026): `tasks.md` actual é checklist; `design.md` §12.3 já cita GitNexus mas snippets vivem sobretudo em `Implementation Notes` do design, não nas tasks.
- Workshop Aula 02 (TLC spec-driven): tasks atómicas com gates (`lint`, `test`), skills a usar, definition of done — alinhado com a proposta mas não formalizado no SDD v1.2.
- Riscos identificados na exploração: staleness, duplicação, inflação de tokens, falsa segurança (copy-paste), custo de curadoria.
- Constraint: `AGENTS.md` ≤150 linhas; detalhe em guia §12.x e skills.
- Repo piloto é perfil **DOCS_SPECS** — patterns de código app referenciam paths em outros repos ou em `doc/curso/scripts/`.

## Goals / Non-Goals

**Goals:**

- Template §12.10 reutilizável para `tasks.md` com campos estruturados.
- Modelo híbrido de ancoragem (3 níveis) documentado e normativo.
- Fail-fast: paths inválidos e comportamento errado detectados por gates, não por revisão humana silenciosa.
- Skills propose/apply/archive actualizadas para gerar, validar e promover patterns.
- Script `verify-task-patterns.sh` para validação mecânica de pointers.

**Non-Goals:**

- Alterar schema OpenSpec CLI (continuamos com `spec-driven` + convenções no guia).
- Substituir GitNexus — pointers complementam, não substituem, `impact`/`context` no apply.
- Obrigar snippets completos em todas as tasks — só excepções (Nível 3).
- Automatizar promoção para skills sem revisão humana.
- CI obrigatório em todos os repos consumidores do guia (script é opt-in via checklist §2.8).

## Decisions

| ID | Decisão | Rationale | Alternativa rejeitada |
|----|---------|-----------|----------------------|
| D1 | **Ponteiros `file:line` preferidos** a snippets em `tasks.md` | Reduz staleness textual; código canónico vive no repo | Snippets completos por task — drift garantido |
| D2 | **3 níveis de ancoragem** (pointer / esqueleto ≤15 linhas / snippet boilerplate) | Balanceia orientação vs tokens | Um único formato — ou magro demais ou pesado demais |
| D3 | **`Gate:` obrigatório** em tasks que alteram comportamento ou ficheiros | Transforma “agente julgou pronto” em comando verificável (workshop Branas) | Confiança na auto-avaliação do LLM |
| D4 | **`Proibido:` opcional** para anti-patterns conhecidos | Limita reinvenção de abstrações (R4) | Só positivo — agente ainda cria `BaseRepository` duplicado |
| D5 | **Divisão design vs tasks** | Decisões em `design.md`; passos + pointers + gates em `tasks.md` | Código em ambos — drift triplo |
| D6 | **`gitnexus impact` na 1ª task de código** no apply | Detecção estrutural antes de editar | Só no propose — apply em chat novo perde contexto |
| D7 | **`verify-task-patterns.sh`** parseia `Pattern:` em tasks.md activos | Fail-fast barato sem LLM | Validação só humana |
| D8 | **Promoção pós-archive** manual na skill archive | ROI na 2ª feature do mesmo domínio; evita curadoria prematura | Auto-promote tudo — ruído em skills |
| D9 | **Snippets >15 linhas** → skill ou archive, não task | Token budget + single source of truth | Snippets longos em tasks — inflação e drift |
| D10 | **Perfil DOCS_SPECS**: `Pattern:` aceita `doc/` e paths de archive | Repo sem app na raiz ainda beneficia para scripts/docs | Exigir `src/` — inaplicável aqui |

## Knowledge sources consulted

- Guia: `doc/sistema-sdd-pedro.md` §5.2, §7.2, §12.3 (design template), §12 — gap: sem §12.10 tasks
- Workshop: `doc/curso/aula-02-workshop-ia-5-2026.md` — gates, tasks atómicas, TLC spec-driven
- Archive: `openspec/changes/archive/2026-06-16-add-session-handoff-infra-manifest/design.md` — `Implementation Notes` com snippets (precedente no design, não tasks)
- AGENTS.md: R2 (fontes), R4 (smallest change), R6 (test before fix), R8 (source anchoring)

## Modelo híbrido (referência §12.10)

```
Nível 1 — Pointer (default)
  Pattern: src/infra/stripe/customer.repo.ts
  Gate: npm test -- customer.repo

Nível 2 — Esqueleto (padrão não óbvio)
  ≤15 linhas: interface + assinatura + 1 teste exemplo
  + nota "ler ficheiro Pattern antes de implementar"

Nível 3 — Snippet boilerplate (excepção)
  Migrations SQL, Zod base, hook template
  Tag: boilerplate-only · Fonte: archived change ou file:line
```

## Camadas de defesa contra desvantagens

| Camada | Mecanismo | Previne ou limita |
|--------|-----------|-------------------|
| 1 | Pointer em vez de snippet | **Limita** staleness textual |
| 2 | `verify-task-patterns.sh` | **Detecta** paths quebrados |
| 3 | `gitnexus impact` no apply | **Limita** edits cegos |
| 4 | `Gate:` com test/lint | **Previne** merge de comportamento errado |
| 5 | Archive checklist promoção | **Limita** perda de patterns reutilizáveis |
| 6 | Humano em changes >5 ficheiros | **Limita** erros semânticos (já §7.1 guia) |

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| Pointer aponta para ficheiro que mudou semanticamente mas path existe | Gate com teste específico; impact no apply |
| Agentes ignoram campos `Pattern`/`Gate` | Skills propose geram formato; apply valida gate antes de marcar `[x]` |
| `verify-task-patterns.sh` falso negativo (regex frágil) | Formato normativo em §12.10; testes do script com fixtures |
| Overhead na propose para changes só-docs | Campos `Pattern`/`Gate` obrigatórios só para tasks que tocam código ou scripts |
| Cross-repo patterns sem GitNexus | Convenção `repo:path` documentada em §12.10; `[NEEDS VERIFICATION]` se path não resolvível |

## Migration Plan

1. Apply deste change: spec, guia §12.10, skills, script, AGENTS.md.
2. Changes activos futuros adoptam template na próxima propose.
3. Changes activos existentes (se houver): opcional actualizar tasks na próxima edição.
4. Rollback: reverter guia/skills/script; spec removida no archive inverso.

## Open Questions

- Integrar `verify-task-patterns.sh` em `verify-infra.sh` ou manter separado? **Proposta:** separado; chamada opcional no checklist archive.
- OpenSpec CLI 1.4+ poderá um dia incluir schema de tasks — até lá, convenção no guia §12.10.

## Implementation Notes

### Formato de task enriquecida (§12.10)

```markdown
- [ ] 2.3 Criar `SubscriptionRepository`
  - **Pattern:** `src/infra/stripe/customer.repo.ts`
  - **Invariants:** R-BILL-003 (`openspec/specs/billing/spec.md`)
  - **Gate:** `npm test -- subscription.repo`
  - **Proibido:** criar `BaseRepository` (já existe em `src/core/`)
```

### Campos obrigatórios por tipo de task

| Tipo de task | Pattern | Gate | Invariants | Proibido |
|--------------|---------|------|------------|----------|
| Altera código/scripts | recomendado | **obrigatório** | se spec aplicável | opcional |
| Só documentação | opcional (template existente) | comando verificável (ex: `wc -l`, `openspec validate`) | — | — |

### Ficheiros a tocar no apply

| Ficheiro | Acção |
|----------|-------|
| `doc/sistema-sdd-pedro.md` | + §12.10; refs em §5.2, §7.2 |
| `.cursor/skills/openspec-propose/SKILL.md` | + regras geração tasks |
| `.cursor/skills/openspec-apply-change/SKILL.md` | + impact + gate antes de `[x]` |
| `.cursor/skills/openspec-archive-change/SKILL.md` | + checklist promoção pattern |
| Espelhos `.claude/` e `opsx-*.md` | espelho |
| `scripts/verify-task-patterns.sh` | criar |
| `AGENTS.md` | + contexto sob demanda (~5 linhas) |
