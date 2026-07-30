---
name: correctness-review
description: >
  Review focused exclusively on correctness: logical bugs, unhandled edge cases,
  contract/invariant violations, and silent errors in AI-generated code.
  One finding per line: location, tag, description, fix suggestion or test vector.
  Use after /opsx:apply on Type B tasks (always), C/D (diff > ~80 lines or > 4 files),
  or when the user asks for "correctness review", "any bugs?", "validate edge cases".
  Positioned before simplify-review and security-reviewer in the post-apply pipeline.
  Complements simplify-review (complexity) and security-reviewer (vulnerabilities) —
  this skill hunts correctness bugs only, respecting approved OpenSpec specs.
license: MIT
metadata:
  author: sdd-pedro
  version: "0.1.0"
---

# correctness-review

Review diffs or changed files **for correctness bugs only** — wrong logic,
unhandled edge cases, contract violations, and silent errors.

**Does not apply fixes.** Lists findings; the user or `/opsx:apply` implements them.

Chat responses MAY use pt-BR (F7); findings format and tags remain as specified below.

---

## When to invoke (SDD integration)

| Moment | Task type | Suggested trigger |
|--------|-----------|-------------------|
| **Post-implementation** | B | Always — diff > 0 lines of logic |
| **Post-implementation** | C, D | Diff > ~80 lines or > 4 files touched |
| **Pre-PR** | B, C, D | Any diff with new logic |
| **Do not invoke** | A | Trivial — no logic to evaluate |
| **Do not invoke** | E | Exploration — no generated code |

### Pipeline position

```
/opsx:apply  →  [implementation]  →  tests (R6/Probity enforceTdd)
  →  correctness-review (B/C/D)
  →  simplify-review (optional, C/D)
  →  security-reviewer (if auth/API/payments)
  →  commit (R9)  →  CI gates  →  /opsx:archive
```

**On-demand** invocation (mode C — level 6 in the SDD guide §8.3 hierarchy). Never always-on.

### Recommended inputs

1. Diff (`git diff` or PR description)
2. `openspec/changes/<id>/design.md` — what was **approved** (do not evaluate outside approved scope)
3. `openspec/project.md` — stack and non-goals
4. Optional: relevant spec files for API/function contracts

---

## Output format

Suggested file: `correctness-review.md` at the change root or inline PR comment.

### Header

```markdown
# correctness-review

**Change:** <change-id or "uncommitted">
**Scope:** <N files, +X/-Y lines>
**Verdict:** CORRECT | RISKY | INSUFFICIENT SCOPE
```

### Findings (one per line)

Format: `` `path/to/file.ts:L12-38` **tag:** description. Fix/test: … ``

| Tag | Meaning |
|-----|---------|
| `logic:` | Wrong condition or branch; incorrect result for valid input |
| `edge:` | Unhandled extreme input (null, empty, overflow, unicode, concurrent) |
| `contract:` | Pre/post-condition or API/function invariant violation |
| `race:` | Potential race condition (shared mutable state, async without lock) |
| `silent:` | Silent error — swallowed exception, wrong value without alert |

### Examples (expected style)

❌ "This function seems to have an edge-case bug; consider handling null."

✅ `src/lib/parser.ts:L45` **edge:** `parseDate(undefined)` not handled — returns `NaN` silently. Fix: `if (!input) return null` on line 44.

✅ `src/api/orders.ts:L78-82` **logic:** condition `status === 'pending' || status === 'paid'` never evaluates `status === 'processing'` — orders in processing fall into unknown-state branch. Fix: add `'processing'` to guard or use exhaustive switch with `never` check.

✅ `src/workers/sync.ts:L120` **race:** `sharedCache.set(key, value)` called from two coroutines without lock. Fix: serialize with mutex or use thread-safe structure.

✅ `src/services/email.ts:L33` **silent:** `catch (err) {}` swallows send errors without log or retry. Fix: `logger.error(err)` + re-throw or dead-letter.

✅ `src/hooks/useUser.ts:L18` **contract:** function documents return type `User` but may return `undefined` when `session` is null. Fix: update signature to `User | undefined` and handle in caller.

### Final metric

End with: **`findings: N (logic: X, edge: Y, contract: Z, race: W, silent: V)`**

If nothing found: **`CORRECT — No correctness issues found. Ship.`** and stop.

### Verdicts

| Verdict | Criterion |
|---------|-----------|
| **CORRECT** | No correctness findings in scope |
| **RISKY** | ≥1 actionable correctness finding |
| **INSUFFICIENT SCOPE** | Diff too small, docs/config only, or no logic to evaluate |

---

## Boundaries — never flag

Respect **precedence**: approved `design.md` > correctness-review.

| Protected | Reason |
|-----------|--------|
| Unnecessary complexity | → `simplify-review` |
| Security vulnerabilities | → `security-reviewer` |
| Performance and optimization | Out of scope for this review |
| Accessibility and style | Out of scope for this review |
| Code referenced in `openspec/specs/` as a requirement | Current spec — do not suggest removal |
| Zod/Pydantic schemas at I/O boundaries | Security non-negotiable |

**Out of scope for this review:** complexity, security, performance, accessibility.
This skill hunts **only** logic bugs, edge cases, contract violations, and silent errors.

---

## SDD integration (active)

| Level | Status | Where |
|-------|--------|-------|
| **AGENTS.md** | ✅ | "Post-implementation reviews" section — when to invoke / not invoke |
| **openspec-apply-change** | ✅ | Skill suggests correctness-review before simplify-review (diff > ~80 lines or > 4 files) |
| **Manual** | ✅ | User requests explicitly |
| **Subagent** | ⏳ | `.claude/agents/correctness-reviewer.md` — only after validation in APP repo |
| **Pre-commit / hooks** | ❌ | Not recommended — mode C exclusively |

**Not recommended:** always-on hook, `.mdc` rule with alwaysApply, or automatic commit blocking.

---

## Useful commands

```bash
# Diff for current change
git diff --stat
git diff

# Diff vs main (PR)
git diff origin/master...HEAD --stat
```

---

## Complete output example

```markdown
# correctness-review

**Change:** add-payment-webhook-handler
**Scope:** 5 files, +187/-12 lines
**Verdict:** RISKY

## Findings

- `src/webhooks/stripe.ts:L44` **logic:** `event.type === 'payment_intent.succeeded'` does not include `payment_intent.payment_failed` — failures silently ignored. Fix: add failure case with log + notification.
- `src/webhooks/stripe.ts:L78-81` **silent:** `catch (err) { res.status(200) }` — processing error returns 200 to Stripe, which will not retry. Fix: re-throw to return 500 on processing failures.
- `src/lib/idempotency.ts:L23` **edge:** `idempotencyMap.get(key)` returns `undefined` when key does not exist, but caller treats as `false` — semantic mismatch. Fix: `idempotencyMap.has(key)` or explicit guard.

**findings: 3 (logic: 1, edge: 1, contract: 0, race: 0, silent: 1)**

## Notes

- Do not review: Zod schema in `src/infra/stripe/schemas.ts` (boundary approved in design.md).
- Next step: apply fixes or add regression tests for the 3 findings.
```
