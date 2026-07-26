---
name: correctness-review
description: >
  Review focado exclusivamente em correctness: bugs lógicos, edge cases não tratados,
  violações de contrato/invariante e erros silenciosos em código gerado por IA.
  Um achado por linha: localização, tag, descrição, sugestão de fix ou vector de teste.
  Use após /opsx:apply em tarefas Tipo B (sempre), C/D (diff > ~80 linhas ou > 4 ficheiros),
  ou quando o utilizador pedir "correctness review", "tem bugs?", "valida os edge cases".
  Posicionada antes de simplify-review e security-reviewer na pipeline pós-apply.
  Complementa simplify-review (complexidade) e security-reviewer (vulnerabilidades) —
  este caça apenas bugs de correctness, respeitando specs OpenSpec aprovadas.
license: MIT
metadata:
  author: sdd-pedro
  version: "0.1.0"
---

# correctness-review

Review de diffs ou ficheiros alterados **só para bugs de correctness** — lógica errada,
edge cases não tratados, violações de contrato e erros silenciosos.

**Não aplica fixes.** Lista achados; o utilizador ou `/opsx:apply` implementa.

Responder sempre em **pt-BR**.

---

## Quando invocar (integração SDD)

| Momento | Tipo de tarefa | Gatilho sugerido |
|---------|----------------|------------------|
| **Pós-implementação** | B | Sempre — diff > 0 linhas de lógica |
| **Pós-implementação** | C, D | Diff > ~80 linhas ou > 4 ficheiros tocados |
| **Pré-PR** | B, C, D | Qualquer diff com lógica nova |
| **Não invocar** | A | Trivial — sem lógica para avaliar |
| **Não invocar** | E | Exploração — sem código gerado |

### Posição no pipeline

```
/opsx:apply  →  [implementação]  →  testes (R6/Probity enforceTdd)
  →  correctness-review (B/C/D)
  →  simplify-review (opcional, C/D)
  →  security-reviewer (se auth/API/pagamentos)
  →  commit (R9)  →  gates CI  →  /opsx:archive
```

Invocação **on-demand** (modo C — nível 6 na hierarquia §8.3 do guia SDD). Nunca always-on.

### Inputs recomendados

1. Diff (`git diff` ou descrição de PR)
2. `openspec/changes/<id>/design.md` — o que foi **aprovado** (não avaliar fora do escopo aprovado)
3. `openspec/project.md` — stack e non-goals
4. Opcional: ficheiros de spec relevantes para contratos de API/função

---

## Formato de saída

Ficheiro sugerido: `correctness-review.md` na raiz do change ou comentário inline no PR.

### Cabeçalho

```markdown
# correctness-review

**Change:** <change-id ou "uncommitted">
**Escopo:** <N ficheiros, +X/-Y linhas>
**Veredito:** CORRECT | RISKY | ESCOPO INSUFICIENTE
```

### Achados (um por linha)

Formato: `` `path/to/file.ts:L12-38` **tag:** descrição. Fix/teste: … ``

| Tag | Significado |
|-----|-------------|
| `logic:` | Condição ou ramo lógico errado; resultado incorreto para input válido |
| `edge:` | Input extremo não tratado (null, vazio, overflow, unicode, concurrent) |
| `contract:` | Violação de pré/pós-condição ou invariante de API/função |
| `race:` | Condição de corrida potencial (shared mutable state, async sem lock) |
| `silent:` | Erro silencioso — excepção engolida, valor errado sem alerta |

### Exemplos (estilo esperado)

❌ "Esta função parece ter um bug de edge case; considere tratar o caso null."

✅ `src/lib/parser.ts:L45` **edge:** `parseDate(undefined)` não tratado — retorna `NaN` silenciosamente. Fix: `if (!input) return null` na linha 44.

✅ `src/api/orders.ts:L78-82` **logic:** condição `status === 'pending' || status === 'paid'` nunca avalia `status === 'processing'` — pedidos em processamento caem no ramo de estado desconhecido. Fix: adicionar `'processing'` ao guard ou usar switch exhaustivo com verificação `never`.

✅ `src/workers/sync.ts:L120` **race:** `sharedCache.set(key, value)` chamado em dois coroutines sem lock. Fix: serializar com mutex ou usar estrutura thread-safe.

✅ `src/services/email.ts:L33` **silent:** `catch (err) {}` engole erros de envio sem log nem retry. Fix: `logger.error(err)` + re-throw ou dead-letter.

✅ `src/hooks/useUser.ts:L18` **contract:** função documenta retorno `User` mas pode retornar `undefined` quando `session` é null. Fix: actualizar assinatura para `User | undefined` e tratar no caller.

### Métrica final

Terminar com: **`achados: N (logic: X, edge: Y, contract: Z, race: W, silent: V)`**

Se não houver nada: **`CORRECT — Nenhum problema de correctness encontrado. Ship.`** e parar.

### Vereditos

| Veredito | Critério |
|----------|----------|
| **CORRECT** | Nenhum achado de correctness no escopo |
| **RISKY** | ≥1 achado acionável de correctness |
| **ESCOPO INSUFICIENTE** | Diff muito pequeno, só docs/config, ou sem lógica para avaliar |

---

## Boundaries — nunca flaggar

Respeitar **precedência**: `design.md` aprovado > correctness-review.

| Protegido | Motivo |
|-----------|--------|
| Complexidade desnecessária | → `simplify-review` |
| Vulnerabilidades de segurança | → `security-reviewer` |
| Performance e optimização | Fora de escopo desta review |
| Acessibilidade e estilo | Fora de escopo desta review |
| Código referenciado em `openspec/specs/` como requisito | Spec vigente — não sugerir remoção |
| Schemas Zod/Pydantic em fronteiras I/O | Segurança non-negotiable |

**Fora de scope deste review:** complexidade, segurança, performance, acessibilidade.
A skill caça **apenas** bugs de lógica, edge cases, violações de contrato e erros silenciosos.

---

## Integração no SDD (activa)

| Nível | Estado | Onde |
|-------|--------|------|
| **AGENTS.md** | ✅ | Secção "Reviews pós-implementação" — quando invocar / não invocar |
| **openspec-apply-change** | ✅ | Skill sugere correctness-review antes de simplify-review (diff > ~80 linhas ou > 4 ficheiros) |
| **Manual** | ✅ | Utilizador pede explicitamente |
| **Subagent** | ⏳ | `.claude/agents/correctness-reviewer.md` — só após validação em repo APP |
| **Pre-commit / hooks** | ❌ | Não recomendado — modo C exclusivamente |

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
# correctness-review

**Change:** add-payment-webhook-handler
**Escopo:** 5 ficheiros, +187/-12 linhas
**Veredito:** RISKY

## Achados

- `src/webhooks/stripe.ts:L44` **logic:** `event.type === 'payment_intent.succeeded'` não inclui `payment_intent.payment_failed` — falhas silenciosamente ignoradas. Fix: adicionar case para falha com log + notificação.
- `src/webhooks/stripe.ts:L78-81` **silent:** `catch (err) { res.status(200) }` — erro de processamento retorna 200 para o Stripe, que não fará retry. Fix: re-throw para retornar 500 em falhas de processamento.
- `src/lib/idempotency.ts:L23` **edge:** `idempotencyMap.get(key)` retorna `undefined` quando key não existe, mas caller trata como `false` — divergência semântica. Fix: `idempotencyMap.has(key)` ou guard explícito.

**achados: 3 (logic: 1, edge: 1, contract: 0, race: 0, silent: 1)**

## Notas

- Não rever: schema Zod em `src/infra/stripe/schemas.ts` (fronteira aprovada em design.md).
- Próximo passo: aplicar fixes ou adicionar testes de regressão para os 3 achados.
```
