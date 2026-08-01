---
name: sdd-tooling-guidance
description: Guidance for reaching external tools (CLI vs MCP vs manual) and suggesting missing integrations — load when the agent falls to manual narration for the same tool twice in a session, a tooling gap signal fires (pasted tool output, credential/401 errors, re-described external state), or the user asks how the agent should reach an external tool. On-demand (mode C); offer-only, never install or configure anything unprompted.
license: MIT
compatibility: ByeByeVibe control plane; applies to Claude Code and Cursor skill surfaces.
metadata:
  author: byebyevibe
  version: "1.0"
---

# Tooling guidance — how to reach external tools, when to suggest integrations (ByeByeVibe)

External-tool actions (GitHub, Figma, dashboards, SaaS APIs) have a fixed resolution order. This skill teaches **the cascade, how to detect a tooling gap, and how to suggest — never install — an integration**. It is mode C — load on demand, never inject always-on.

**Surface note (asymmetry):** this is the Cursor mirror. It has no MCP-registry or connector-listing harness tools; when a suggestion is accepted, degrade to "suggest + point to `doc/tooling-install.md`". The Claude Code mirror may additionally reference native harness tools — no parity assumed.

---

## Resolution cascade (normative)

When you need to act on an external tool, resolve in this order:

1. **Session operator override** — "use MCP first" (or similar) is honored without debate, for the current session only. Never persist it; a new session returns to the default cascade unless the override is restated.
2. **Configured CLI** (default) — zero permanent context cost, controllable output, scriptable, works in CI.
3. **Configured MCP** (fallback) — use when no CLI is configured, or for tools where **only MCP delivers the capability** (e.g. structured design context via Figma MCP). The hierarchy is decided per tool, not by dogma: **key → CLI → MCP, unless only MCP delivers the capability.**
4. **Suggest configuring** (offer-only, capped) — use the standard suggestion message below, subject to the shared cap and the durable-refusal check.
5. **Manual instructions** (last resort) — narrate the dashboard steps for the operator.

**Second-manual-fall trigger:** falling to rung 5 for the *same tool* a *second time in one session* IS the detection event that arms the suggestion. No separate counter — the cascade closes its own loop.

## Detection signals (conversation, secondary layer)

The static gap-check in `scripts/verify-infra.sh` is the primary detector (it reports presence/absence of `.mcp.json` / `.cursor/mcp.json`, manifest-listed CLIs, `.env.example` keys). These conversational signals are the secondary layer:

1. **Repeated manual narration** for the same tool — the **gold signal**, self-observed via the cascade.
2. User **pastes external-tool output** (missing read integration).
3. User repeatedly asks for content **"to paste elsewhere"** (missing write integration).
4. **Credential/401 errors** on commands you ran (missing `.env` key).
5. User **re-describes external system state** ("the board now shows…") (missing read access).

**Paste caveat:** manual paste can be a policy choice, not a gap. A paste alone, uncorroborated by another signal, is not sufficient grounds to suggest.

## Before suggesting: durable-refusal check

Read `openspec/infra.md` first (rule R10). An integration whose row carries the **`declined`** status was considered and refused: **do not re-suggest it** — re-suggesting a refused integration is suggesting a policy violation, not helpfulness. Use the cascade's remaining rungs (manual instructions) instead. A **commented-out key in `.env.example`** means the same thing: considered and declined.

## Standard suggestion message (verbatim shape)

Three fixed parts — reference this text, do not re-author it elsewhere:

1. **Will:** "If we configure \<tool\> (CLI/MCP), I can do \<action\> directly in future sessions instead of narrating manual steps."
2. **Won't / costs:** "I never install or configure anything myself — you run the steps. An MCP server would see \<data scope\>; keys live in `.env` (never committed); only official sources/trusted registries. An active MCP charges its schemas to every session — for occasional use, CLI + key is cheaper."
3. **Decide:** "Want to set it up? (yes / no / later)" — a "no" is recorded as `declined` in `openspec/infra.md` and never re-suggested.

**Shared anti-noise cap:** at most **one proactive suggestion per session across mechanisms** (skill *or* tooling, per `sdd-skill-guidance`), strongest signal wins. If either kind of suggestion was already offered this session, note the new signal silently and move on.

## When a suggestion is accepted

- Point the operator at **`doc/tooling-install.md`** — per-tool entries with official-doc link, verification command, and "verified on YYYY-MM" marker. Never transcribe walkthroughs into chat when the doc has the entry.
- Keys go in `.env` (never committed); MCP servers only from trusted registries or official sources.
- After setup, the operator runs `bash scripts/verify-infra.sh` to record the new status in `openspec/infra.md`.

---

## Guardrails

- **Never install or configure** an MCP, CLI, or key unprompted — no exceptions. Suggestion is an offer; the user decides and runs the steps.
- **Never re-suggest** a `declined` integration or a commented-out `.env.example` key.
- **No always-on injection** of this guidance; mode C only.
- Shared cap: max one proactive suggestion per session across skill + tooling mechanisms.
- Report absence, never infer need — stack-inference gap analysis, durable per-tool preferences, usage telemetry, and preflight gap WARNs are **v2 — do not build them ad hoc**.
