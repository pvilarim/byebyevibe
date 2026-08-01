---
name: sdd-skill-guidance
description: Guidance for suggesting and creating user skills — load when the user repeatedly teaches the same domain facts (local laws, company thresholds, proprietary methods), corrects the agent on a domain fact, or asks whether/how to create a skill. On-demand (mode C); offer-only, never create skills unprompted.
license: MIT
compatibility: ByeByeVibe control plane; applies to Claude Code and Cursor skill surfaces.
metadata:
  author: byebyevibe
  version: "1.0"
---

# Skill guidance — when to suggest, how to create (ByeByeVibe)

Skills are the control plane's cheapest durable memory: the frontmatter description charges every session (~30–80 tokens when lean), the body loads only on trigger. This skill teaches **when a user-created skill helps, how to suggest one, and how to keep creation hygienic**. It is mode C — load on demand, never inject always-on.

**Litmus test:** *would a competent generalist with internet access still get this wrong or do it differently than wanted?* If yes → skill-worthy (local/volatile knowledge, proprietary methodology, required output format). If no → pure token cost (generic stack knowledge, naked personas).

**Boundary:** skill = how-to / procedural memory · spec (`openspec/specs/`) = required behavior · `openspec/project.md` = constitution. Do not put required behavior in a skill or procedures in a spec.

---

## Detection signals (conversation)

Watch for domain density while exploring or proposing:

1. User cites a **local law, norm, or technical table** (e.g., municipal zoning code, ABNT norm).
2. User states **company-specific numbers or thresholds** (margins, limits, internal SLAs).
3. **User corrects the agent about a domain fact** — the **gold signal**: a witnessed knowledge gap with the highest trigger precision.
4. User **re-explains or re-pastes** previously provided material ("as I already explained…").
5. User narrates a **proprietary step-by-step method** of their own.

On recognition, respond with the standard suggestion message below. Never silently continue past a gold signal; never create a skill unprompted.

## Standard suggestion message (verbatim shape)

Three fixed parts — reference this text, do not re-author it elsewhere:

1. **Will:** "If we save this as a skill, future sessions recall it automatically whenever \<topic\> comes up."
2. **Won't:** "It does not update itself — if the law/number/method changes, you must ask to update it, or it will keep asserting stale data."
3. **Decide:** "Want me to create it? (yes / no / later)"

**Anti-noise cap:** offer only, never impose; at most **one suggestion per session**. If a second skill-worthy signal appears after you already suggested once, note it silently and move on — no second suggestion in that session.

## Creation hygiene

When a suggestion is accepted (or the user asks for a skill directly):

- **Search before create:** check existing skills first; **extend an existing skill by default** — a new sibling skill is the exception, because overlapping descriptions degrade trigger precision for every skill.
- **Description diet:** frontmatter description is 1–2 sentences stating *when to trigger*, never the content. Knowledge goes in the body; dense data (tables, regulation values, long checklists) goes in `references/` files that load only when consulted.
- **Task-based naming:** name the skill after the task (`viabilidade-residencial-recife`), never the persona ("urban-planner"). Persona alone adds ≈ zero value.
- **Staleness marker:** volatile domain data (regulation values, market figures, rates) MUST carry a "verified on YYYY-MM" marker in the body. Stale data delivered with confidence is worse than no skill.
- **Agent-routed creation:** novices ask the agent to create the skill in the correct format — never hand-write SKILL.md.

## Lifecycle: create → measure → prune

Skills need the same lifecycle as code. The rule of three governs extraction: **1st time normal, 2nd time note it, 3rd time extract a skill.** At archive time, the workflow asks: *"Did anything in this change repeat a procedure or explanation from a previous change?"* Answer honestly — that question is the cheapest harvest mechanism v1 has.

Pruning: if a skill never fires or its description overlaps a sibling, merge or delete it. (Automated load metrics, usage telemetry, and `/opsx:harvest` are **v2 — do not build them ad hoc**.)

---

## Guardrails

- **Never** create a skill unprompted — suggestion is an offer; the user decides.
- **Never** instruct operators to write skills before development starts — good skills crystallize from repetition, not speculation.
- **No always-on injection** of this guidance; mode C only.
- Max one suggestion per session, no exceptions.
