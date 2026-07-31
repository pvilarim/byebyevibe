---
name: simplify-review
description: >
  Review focused exclusively on over-engineering and avoidable complexity.
  Finds what to delete or shrink: reinvented stdlib, unnecessary dependencies,
  speculative abstractions, dead flexibility. One finding per line: location,
  what to cut, substitute. Use when the user asks for "simplicity review",
  "is this over-engineered?", "what can we delete?", "simplify review", after
  /opsx:apply with a large diff, or before commit/PR on Type B/C/D tasks.
  Complements security-reviewer (security) and correctness review — this hunts
  only unnecessary complexity, respecting approved OpenSpec specs.
license: MIT
metadata:
  author: sdd-pedro
  version: "0.1.0"
  adaptedFrom: "ponytail-review (MIT) — SDD rules, not Ponytail project integration"
---

# simplify-review

Review diffs or changed files **for avoidable complexity only**. The best
outcome is a shorter diff, not a long report.

**Does not apply fixes.** Lists findings; the user or `/opsx:apply` implements them.

Chat responses MAY use pt-BR (F7); findings format and tags remain as specified below.

---

## When to invoke (SDD integration)

| Moment | Task type | Suggested trigger |
|--------|-----------|-------------------|
| **Post-implementation** | C, D | After `/opsx:apply` completes tasks, before commit |
| **Pre-PR** | B, C, D | Diff > ~80 lines or > 4 files touched |
| **Refactor complete** | C | `design.md` requires parity — verify simplification did not change behavior |
| **Ad-hoc audit** | E → implementation | User asks explicitly; or known tech debt |
| **Do not invoke** | A | Trivial — R4 is enough |
| **Do not invoke** | During propose | Before spec approved — scope still under debate |

### Pipeline position

```
/opsx:apply  →  [implementation]  →  simplify-review (optional)  →  security-reviewer (if auth/API)
                →  tests (R6)     →  commit (R9)               →  /opsx:archive
```

**On-demand** invocation (level 6 in the SDD guide §8.3 hierarchy). Never always-on.

### Recommended inputs

1. Diff (`git diff` or PR description)
2. `openspec/changes/<id>/design.md` — what was **approved** (do not simplify outside approved scope)
3. `openspec/project.md` — stack and non-goals
4. Optional: `gitnexus impact` if a finding involves a symbol with many dependents

---

## Output format

Suggested file: `simplify-review.md` at the change root or inline PR comment.

### Header

```markdown
# simplify-review

**Change:** <change-id or "uncommitted">
**Scope:** <N files, +X/-Y lines>
**Verdict:** LEAN | TRIMMABLE | CONFLICTING SCOPE
```

### Findings (one per line)

Format: `` `path/to/file.ts:L12-38` **tag:** description. Substitute: … ``

| Tag | Meaning |
|-----|---------|
| `delete:` | Dead code, speculative flexibility, feature not requested in spec. Substitute: nothing. |
| `stdlib:` | Reinventing the stdlib. Name the native function/API. |
| `native:` | Dependency or code the platform already covers (`<input type="date">`, CSS, DB constraint). |
| `yagni:` | Abstraction with one implementation, config never used, layer with one caller. |
| `shrink:` | Same logic, fewer lines. Show the shorter form. |

### Examples (expected style)

❌ "This EmailValidator class seems too complex; consider simplifying."

✅ `src/lib/email.ts:L12-38` **stdlib:** 27-line validator. `"@" in email` or minimal regex at Zod boundary; real validation = confirmation email.

✅ `src/utils/date.ts:L4` **native:** `moment` imported for one format. `Intl.DateTimeFormat`, 0 deps.

✅ `src/agents/retrieval/repo.ts:L88` **yagni:** `AbstractRepository` with one implementation. Inline until a second concrete implementation exists.

✅ `src/lib/retry.ts:L52-71` **delete:** retry wrapper on local idempotent call. Substitute: nothing.

✅ `src/core/map.ts:L30-44` **shrink:** manual loop builds dict. `Object.fromEntries(...)`, 1 line.

### Final metric

End with: **`net: -N lines possible`** (estimated sum of removable lines).

If nothing to cut: **`Lean already. Ship.`** and stop.

### Verdicts

| Verdict | Criterion |
|---------|-----------|
| **LEAN** | `net: 0` or findings are cosmetic only |
| **TRIMMABLE** | `net: > 0` with actionable findings without violating spec |
| **CONFLICTING SCOPE** | Desired simplification contradicts `design.md`, mandatory shadcn, or multi-agent contracts |

---

## Boundaries — never flag for removal

Respect **precedence**: approved `design.md` > simplify-review.

| Protected | Reason (SDD / project.md) |
|-----------|---------------------------|
| Zod/Pydantic schemas at I/O boundaries | §11.1 item 7, RLS-adjacent |
| RLS policies and Supabase migrations | Security non-negotiable |
| shadcn/ui components when spec or `project.md` requires design system | Ponytail-style native vs shadcn conflict |
| Tests required by R6 (bug) or `tasks.md` | Coverage > minimal assert |
| `TraceContext`, correlation IDs, structured logging | Multi-agent bot §11.3–11.4 |
| Capability structure (`agents/`, `infra/`) | Approved modularization in design |
| `sdd-shortcut:` comments with upgrade path | Conscious shortcut already documented |
| Code referenced in `openspec/specs/` as requirement | Current spec |

**Out of scope for this review:** correctness bugs, security (→ `security-reviewer`), performance, detailed accessibility.

A smoke test or minimal co-located test is **not** bloat.

---

## Conscious shortcuts (`sdd-shortcut:`)

If the diff **introduces** simplification with a known ceiling, verify presence of:

```typescript
// sdd-shortcut: global lock — per-account locks if throughput > X req/s
```

Missing comment on non-trivial shortcut → optional **`shrink:`** finding or "debt" note (non-blocking).

---

## SDD integration (active)

| Level | Status | Where |
|-------|--------|-------|
| **AGENTS.md** | ✅ | "Post-implementation reviews" section — when to invoke / not invoke |
| **openspec-apply-change** | ✅ | Step 8 — *suggests* review if diff > ~80 lines or > 4 files (non-blocking) |
| **Manual** | ✅ | User asks explicitly |
| **Subagent** | ⏳ | `.claude/agents/simplify-reviewer.md` — only after validation in APP repo |
| **Pre-commit / hooks** | ❌ | Not recommended |

**Not recommended:** always-on hook, alwaysApply `.mdc` rule, or automatic commit blocking.

---

## Useful commands

```bash
# Diff of current change
git diff --stat
git diff

# Diff vs main (PR)
git diff origin/master...HEAD --stat
```

---

## Complete output example

```markdown
# simplify-review

**Change:** add-rate-limit-helper
**Scope:** 6 files, +142/-8 lines
**Verdict:** TRIMMABLE

## Findings

- `src/lib/rate-limit.ts:L1-89` **yagni:** `RateLimiter` class with pluggable strategies; spec asks for fixed per-IP limit. Substitute: in-memory Map + timestamp, ~15 lines.
- `src/lib/rate-limit.ts:L4` **delete:** `RateLimitStrategy` interface — one implementation. Substitute: nothing.
- `package.json` **native:** `rate-limiter-flexible` dependency added; spec does not require Redis. Substitute: in-process implementation until scale requires it.

**net: -78 lines possible**

## Notes

- Do not cut: Zod schema in `src/infra/supabase/schemas.ts` (approved boundary in design.md).
- Next step: apply findings or mark `sdd-shortcut:` on shortcuts kept on purpose.
```
