## Context

The SDD system has two post-apply review skills:
- `simplify-review` — hunts avoidable complexity (over-engineering, YAGNI, reinvented stdlib)
- `security-reviewer` — security audit on auth/payments/API routes

Neither covers **correctness**: logical bugs, unhandled edge cases, invariant violations, race conditions, unexpected behavior on extreme inputs, or contract errors. AI-generated code has a characteristic failure pattern in this dimension: correct syntax and structure, wrong semantics at boundary cases.

Insertion follows the methodology in `metodologia-insercao.md` (Phase 1 → Phase 3 direct):
- **Pilot exception approved:** skill without binary, hook, or autonomous LLM consumption — only instructs the agent to review code with the model already active in the session. The user explicitly confirmed ("pilot waived").
- **Precedent:** `simplify-review` (`.claude/skills/simplify-review/SKILL.md` + mirror `.cursor/skills/`), adopted without pilot, integrated via AGENTS.md + infra.md.

### Phase 0 checks completed

| # | Check | Result |
|---|-------|--------|
| V1 | Already installed? | No — `openspec/infra.md` does not list `correctness-review` |
| V2 | Contact surface | Mode C (on demand) — no hook, no PreToolUse; same slot as `simplify-review` |
| V3 | Artifact collision | None — `.claude/skills/correctness-review/` and `.cursor/skills/correctness-review/` are free |
| V4 | Repo profile | Applies to APP and DOCS_SPECS (any generated code) |
| V5 | Hook stacking | N/A — mode C does not use hooks |
| F1 | Security | No external binary; no token; no production data |
| F2 | License | MIT (same pattern as `simplify-review`) |
| F3 | Living governance | The skill is internal — self-maintained |
| F4 | Reversibility | Removal = `rm` the two skill files + revert AGENTS.md/infra.md |
| F5 | Operability | Toggle on/off via invocation (mode C) |

---

## Goals / Non-Goals

**Goals:**

- Create `correctness-review` skill that detects logical bugs, unhandled edge cases, contract and invariant violations in AI-generated code
- Position it in the post-apply pipeline before `simplify-review` (update AGENTS.md)
- Register at the 6 insertion-contract points (metodologia-insercao.md Phase 3)
- Provide normative spec (`sdd-correctness-review`) so future implementations know what the skill MUST and MUST NOT do
- Ensure documented and testable rollback

**Non-Goals:**

- Replace `simplify-review` or `security-reviewer` — they are orthogonal
- Integrate PR-Agent (G7 Phase 2 — optional, per repo, separate change)
- Create automatic hook or autonomous LLM consumption (out-of-band)
- Implement the skill as an autonomous subagent in this iteration (analogous to `⏳ Subagent` of simplify-review)
- Touch production code — this repo is DOCS_SPECS; the skill instructs agents in APP repos

---

## Decisions

### D1: Trigger mode — C (on demand), not B (automatic hook)

**Choice:** mode C — user or agent invokes via skill description ("post-apply, before commit/PR, tasks B/C/D").

**Discarded alternative:** automatic PreToolUse hook (mode B). Reason: (a) consumes LLM on every write, unacceptable latency for trivial edits (type A, docs); (b) `metodologia-insercao.md` reserves mode B for TDD Guard with mandatory toggle; (c) `simplify-review` proved mode C is sufficient for quality reviews.

**Rationale:** selectivity > automatic coverage. The A–E matrix (below) defines when to invoke without creating a new rule.

---

### D2: Skill structure — mirror `.claude/` + `.cursor/`

**Choice:** `.claude/skills/correctness-review/SKILL.md` (Claude Code) with identical mirror in `.cursor/skills/correctness-review/SKILL.md` (Cursor IDE), following the `simplify-review` precedent.

**Discarded alternative:** single shared file via symlink. Reason: symlinks are not cross-platform portable and the precedent is literal copy.

---

### D3: 6-point registration contract (Phase 3)

Required by `metodologia-insercao.md`. The 6 points:

| # | Artifact | Content |
|---|----------|---------|
| R1 | `openspec/infra.md` | Line in Skills section: `correctness-review` · review phase · ✅ |
| R2 | `AGENTS.md` | ≤10 lines in Integrations + line in "Post-implementation reviews" table with pipeline order position |
| R3 | `.claude/skills/` + `.cursor/skills/` | Complete skill with `description:` auto-invoke, output format, boundaries |
| R4 | `doc/sistema-sdd-pedro.md` | New subsection: when to trigger, how to read output, how to disable, troubleshooting |
| R5 | `doc/avaliacoes/` | "Adopted" entry with re-evaluation conditions |
| R6 | `sdd-kit/` | Manual install instruction (no automatic script in this phase — identical to `simplify-review`) |

---

### D4: Skill output format

**Choice:** mirror `simplify-review` format — header with change/scope/verdict, findings one per line with tag + location + description + suggestion, final metric.

**Correctness-specific tags** (distinct from simplicity tags):

| Tag | Meaning |
|-----|---------|
| `logic:` | Wrong condition or branch; incorrect result for valid input |
| `edge:` | Unhandled extreme input (null, empty, overflow, unicode, concurrent) |
| `contract:` | Pre/post-condition or API/function invariant violation |
| `race:` | Potential race condition (shared mutable state, async without lock) |
| `silent:` | Silent error — swallowed exception, wrong value without alert |

**Verdicts** (analogous to simplify-review):

| Verdict | Criterion |
|---------|-----------|
| `CORRECT` | No correctness findings in scope |
| `RISKY` | ≥1 actionable correctness finding |
| `INSUFFICIENT SCOPE` | Diff too small or no logic to evaluate |

---

### D5: Pilot waived — documented justification

`metodologia-insercao.md` Phase 2 waives pilot when "insertion does not install a new binary or hook". This skill:
- Does not install a binary
- Does not add a hook (PreToolUse, pre-commit, etc.)
- Does not create an external service
- Does not consume LLM autonomously (operates within the already-active session)
- The user explicitly confirmed ("pilot waived")

Re-evaluation condition: if the skill is converted to an autonomous subagent or hook, a pilot with quantified criteria MUST be conducted before promotion.

---

## A–E trigger matrix

Required by user instruction ("design.md MUST include A–E matrix").

| Task type | Use `correctness-review`? | Trigger | Pipeline position |
|-----------|---------------------------|---------|-------------------|
| **A — Trivial** | ❌ No | — | — |
| **B — Bug fix** | ✅ Yes (always) | Diff > 0 logic lines | Before commit; after tests pass |
| **C — Refactor** | ✅ Yes | Diff > ~80 lines or > 4 files | Post-apply, before `simplify-review` |
| **D — Feature** | ✅ Yes (always) | Diff with new logic | Post-apply, before `simplify-review` |
| **E — Exploration** | ❌ No | — | — (no generated code) |

**Unified trigger rule** (reuses existing `simplify-review` heuristic):
- Diff > ~80 code lines **or** > 4 files **or** any type B/D task
- Invocation always on-demand (never automatic blocking)

**Updated post-implementation review order:**
```
/opsx:apply → [implementation] → tests (R6/TDD Guard)
  → correctness-review (B/C/D)
  → simplify-review (optional, C/D)
  → security-reviewer (if auth/API/payments)
  → commit (R9) → CI gates → /opsx:archive
```

---

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| **False positive** — skill flags correct code, psychologically blocks flow | Skill is on-demand and does not block commit; verdict `CORRECT` or `INSUFFICIENT SCOPE` closes without action; user may disagree |
| **Overlap with `security-reviewer`** | Explicit boundaries: `correctness-review` does not report security vulnerabilities (→ `security-reviewer`); `security-reviewer` does not hunt general logical bugs |
| **Overlap with `simplify-review`** | `simplify-review` never hunts correctness (declared in its SKILL.md: "Out of scope: correctness bugs"); `correctness-review` never hunts unnecessary complexity |
| **LLM cost per review** | The skill operates in the already-active session — no additional model call beyond what the agent already executes. Marginal cost ≈ 0 vs a session without the skill |
| **Quality depends on model** | Findings are suggestions, not truths; user validates. The skill instructs the model to be conservative: only report findings with evidence in code, never speculate |
| **SKILL.md drift** | `correctness-review` and `simplify-review` must evolve in parallel — spec `sdd-correctness-review` is the source of truth; any normative behavior change goes through an OpenSpec change |

---

## Rollback plan

Required by user instruction ("design.md MUST include rollback plan").

### When to trigger rollback

- The skill consistently produces findings without value (actionability rate < 20% in 10 reviews)
- Conflict with a future tool that covers the same scope with better quality
- Decision to adopt PR-Agent phase 2 in automatic mode, making the skill redundant

### Rollback procedure (reversible in < 5 minutes)

```bash
# 1. Remove skill files
rm .claude/skills/correctness-review/SKILL.md
rmdir .claude/skills/correctness-review/
rm .cursor/skills/correctness-review/SKILL.md
rmdir .cursor/skills/correctness-review/

# 2. Revert AGENTS.md (Post-implementation reviews section and Commands table)
#    — remove correctness-review line from both tables

# 3. Revert openspec/infra.md (Skills section)
#    — remove correctness-review line

# 4. Create OpenSpec removal change (type C) and archive

# 5. Update doc/avaliacoes/ with "Discarded" decision + reopening conditions
```

Rollback does not require touching `sdd-kit/` (no automatic script for this phase) or specs in other repos.

### Re-evaluation criteria

- **Semiannual re-evaluation** automatic (same G7 methodology rule)
- If converted to autonomous subagent: conduct pilot with quantified criteria (≥1 valid finding per 10 reviews; false positive < 30%)
- If PR-Agent phase 2 is adopted: evaluate whether the local skill remains complementary (real-time session review) or redundant

---

## Open Questions

| # | Question | Impact | When to resolve |
|---|----------|--------|-----------------|
| Q1 | Include the skill in `sdd-kit/install.sh` as an installable item for APP repos, or keep manual instruction only? | Defines R6 of the contract | On next kit upgrade (v1.5.0) |
| Q2 | Autonomous subagent `.claude/agents/correctness-reviewer.md` (analogous to `⏳ Subagent` of simplify-review)? | Requires pilot with quantified criteria before promotion | After validation in a real APP repo |
| Q3 | PR-Agent phase 2 (CI workflow) enters sdd-kit? | Separate OpenSpec change; PR-Agent governance still in transition | Semiannual re-evaluation (Jan/2027) |
