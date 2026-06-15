---
name: simplify-review
description: >
  Review focado exclusivamente em over-engineering e complexidade evitável.
  Encontra o que apagar ou encolher: stdlib reinventada, dependências desnecessárias,
  abstrações especulativas, flexibilidade morta. Um achado por linha: localização,
  o que cortar, substituto. Use quando o utilizador pedir "review de simplicidade",
  "está over-engineered?", "o que podemos apagar?", "simplify review", após
  /opsx:apply com diff grande, ou antes de commit/PR em tarefas Tipo B/C/D.
  Complementa security-reviewer (segurança) e review de correctness — este caça
  apenas complexidade desnecessária, respeitando specs OpenSpec aprovadas.
license: MIT
metadata:
  author: sdd-pedro
  version: "0.1.0"
  adaptedFrom: "ponytail-review (MIT) — regras SDD, não integração do projeto Ponytail"
---

# simplify-review

Review de diffs ou ficheiros alterados **só para complexidade evitável**. O melhor
resultado é um diff mais curto, não um relatório longo.

**Não aplica fixes.** Lista achados; o utilizador ou `/opsx:apply` implementa.

Responder sempre em **pt-BR**.

---

## Quando invocar (integração SDD)

| Momento | Tipo de tarefa | Gatilho sugerido |
|---------|----------------|------------------|
| **Pós-implementação** | C, D | Após `/opsx:apply` concluir tasks, antes de commit |
| **Pré-PR** | B, C, D | Diff > ~80 linhas ou > 4 ficheiros tocados |
| **Refactor concluído** | C | `design.md` exige parity — validar que simplificação não mudou comportamento |
| **Audit pontual** | E → implementação | Utilizador pede explicitamente; ou dívida técnica conhecida |
| **Não invocar** | A | Trivial — R4 basta |
| **Não invocar** | Durante propose | Antes de spec aprovada — escopo ainda em debate |

### Posição no pipeline

```
/opsx:apply  →  [implementação]  →  simplify-review (opcional)  →  security-reviewer (se auth/API)
                →  testes (R6)     →  commit (R9)               →  /opsx:archive
```

Invocação **on-demand** (nível 6 na hierarquia §8.3 do guia SDD). Nunca always-on.

### Inputs recomendados

1. Diff (`git diff` ou descrição de PR)
2. `openspec/changes/<id>/design.md` — o que foi **aprovado** (não simplificar fora do escopo aprovado)
3. `openspec/project.md` — stack e non-goals
4. Opcional: `gitnexus impact` se achado envolve símbolo com muitos dependentes

---

## Formato de saída

Ficheiro sugerido: `simplify-review.md` na raiz do change ou comentário inline no PR.

### Cabeçalho

```markdown
# simplify-review

**Change:** <change-id ou "uncommitted">
**Escopo:** <N ficheiros, +X/-Y linhas>
**Veredito:** LEAN | TRIMMABLE | ESCOPO CONFLITANTE
```

### Achados (um por linha)

Formato: `` `path/to/file.ts:L12-38` **tag:** descrição. Substituto: … ``

| Tag | Significado |
|-----|-------------|
| `delete:` | Código morto, flexibilidade especulativa, feature não pedida na spec. Substituto: nada. |
| `stdlib:` | Reinvenção da stdlib. Nomear função/API nativa. |
| `native:` | Dependência ou código que a plataforma já cobre (`<input type="date">`, CSS, constraint DB). |
| `yagni:` | Abstração com uma implementação, config nunca usada, camada com um caller. |
| `shrink:` | Mesma lógica, menos linhas. Mostrar forma mais curta. |

### Exemplos (estilo esperado)

❌ "Esta classe EmailValidator parece complexa demais; considere simplificar."

✅ `src/lib/email.ts:L12-38` **stdlib:** validador de 27 linhas. `"@" in email` ou regex mínima na fronteira Zod; validação real = email de confirmação.

✅ `src/utils/date.ts:L4` **native:** `moment` importado para um format. `Intl.DateTimeFormat`, 0 deps.

✅ `src/agents/retrieval/repo.ts:L88` **yagni:** `AbstractRepository` com uma implementação. Inline até existir segunda implementação concreta.

✅ `src/lib/retry.ts:L52-71` **delete:** wrapper de retry em chamada idempotente local. Substituto: nada.

✅ `src/core/map.ts:L30-44` **shrink:** loop manual constrói dict. `Object.fromEntries(...)`, 1 linha.

### Métrica final

Terminar com: **`net: -N linhas possíveis`** (soma estimada de linhas removíveis).

Se não houver nada a cortar: **`Lean already. Ship.`** e parar.

### Vereditos

| Veredito | Critério |
|----------|----------|
| **LEAN** | `net: 0` ou achados só cosméticos |
| **TRIMMABLE** | `net: > 0` com achados acionáveis sem violar spec |
| **ESCOPO CONFLITANTE** | Simplificação desejada contradiz `design.md`, shadcn obrigatório, ou contratos multi-agent |

---

## Boundaries — nunca flaggar para remoção

Respeitar **precedência**: `design.md` aprovado > simplify-review.

| Protegido | Motivo (SDD / project.md) |
|-----------|---------------------------|
| Schemas Zod/Pydantic em fronteiras I/O | §11.1 item 7, RLS-adjacent |
| Políticas RLS e migrations Supabase | Segurança non-negotiable |
| Componentes shadcn/ui quando spec ou `project.md` exige design system | Conflito Ponytail-style nativo vs shadcn |
| Testes exigidos por R6 (bug) ou `tasks.md` | Cobertura > minimal assert |
| `TraceContext`, correlation IDs, logging estruturado | Multi-agent bot §11.3–11.4 |
| Estrutura por capability (`agents/`, `infra/`) | Modularização aprovada em design |
| Comentários `sdd-shortcut:` com upgrade path | Atalho consciente já documentado |
| Código referenciado em `openspec/specs/` como requisito | Spec vigente |

**Fora de scope deste review:** bugs de correctness, segurança (→ `security-reviewer`), performance, acessibilidade detalhada.

Um smoke test ou teste co-located mínimo **não** é bloat.

---

## Atalhos conscientes (`sdd-shortcut:`)

Se o diff **introduz** simplificação com tecto conhecido, verificar presença de:

```typescript
// sdd-shortcut: global lock — per-account locks se throughput > X req/s
```

Ausência de comentário em atalho não-trivial → achado opcional **`shrink:`** ou nota em "dívida" (não bloqueante).

---

## Integração futura (avaliação — não automático ainda)

Para adoptar no sistema, escolher **um** gatilho:

1. **Manual:** utilizador invoca após apply ("roda simplify-review neste diff")
2. **Checklist em `openspec-apply-change`:** se diff > 80 linhas, *sugerir* invocar (não forçar)
3. **Subagent:** `.claude/agents/simplify-reviewer.md` (paralelo a `security-reviewer`)
4. **Pre-commit opcional:** script que conta linhas e avisa (humano decide)

**Não recomendado:** hook always-on, rule `.mdc` alwaysApply, ou bloqueio automático de commit.

---

## Comandos úteis

```bash
# Diff do change actual
git diff --stat
git diff

# Diff vs main (PR)
git diff origin/master...HEAD --stat
```

---

## Saída de exemplo completa

```markdown
# simplify-review

**Change:** add-rate-limit-helper
**Escopo:** 6 ficheiros, +142/-8 linhas
**Veredito:** TRIMMABLE

## Achados

- `src/lib/rate-limit.ts:L1-89` **yagni:** classe `RateLimiter` com estratégias pluggáveis; spec pede limite fixo por IP. Substituto: Map in-memory + timestamp, ~15 linhas.
- `src/lib/rate-limit.ts:L4` **delete:** interface `RateLimitStrategy` — uma implementação. Substituto: nada.
- `package.json` **native:** dependência `rate-limiter-flexible` adicionada; spec não exige Redis. Substituto: implementação in-process até escala exigir.

**net: -78 linhas possíveis**

## Notas

- Não cortar: schema Zod em `src/infra/supabase/schemas.ts` (fronteira aprovada em design.md).
- Próximo passo: aplicar achados ou marcar `sdd-shortcut:` nos atalhos mantidos de propósito.
```
