# Research — SDD operator day-1 onboarding (`/opsx:help`)

| Field | Value |
|-------|--------|
| **Date** | 2026-08-01 |
| **Change** | `explore-sdd-operator-onboarding` (type E — exploration) |
| **Objective** | Evaluate and crystallize a user-friendly day-1 operator tutorial for ByeByeVibe: phase loop in plain language, file map, prompt craft, confidence questions, and relationship to upstream OpenSpec `/opsx:onboard` |
| **Sources** | Hub README; `doc/sistema-sdd-pedro.md` (§2.0b, §2.8–2.9, §3, §4.3, §12.3, §12.10); `openspec/specs/sdd-discovery-positioning`, `sdd-install-narrative`; `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`; OpenSpec 1.3.1 package (`ALL_WORKFLOWS`, `onboard.js`, `update.js`, `schema.yaml` spec-driven); `metodologia-insercao.md` (explore-oss-coverage-gaps); explore chat 2026-08-01 |
| **Issue** | — |

## Executive summary

**Gap:** Discovery (README / §2.0b) and install narrative (S↔T for the three tools) are adopted. After C1, operators still lack an **in-IDE day-1 operate** surface: what `explore → propose → apply → archive` means in plain language, where artifacts live, how to prompt explore well, and how to verify each phase with the agent.

**Decision (explore merge):** Implement **Option A** — ByeByeVibe-owned `/opsx:help` (kit skill + command + short EN day-1 doc + install tip), complementary to and **never hiding** upstream `/opsx:onboard`. Ready for `/opsx:propose add-sdd-operator-onboarding`.

---

## Problem

| Layer (user-friendly stack) | Status | Role |
|-----------------------------|--------|------|
| Discovery (why install) | ✅ P1–P4 | README, §2.0b, evaluation |
| Install teach (what the three tools are) | ✅ `sdd-install-narrative` | S↔T, banners, add-ons teaser |
| **Day-1 operate (how to run the loop)** | ❌ missing | Tutorial + re-entry via slash command |

Post-install stdout today: edit `project.md`, `verify.sh`, checklist §2.8, optional add-ons. Sanity check is `/opsx:propose`. No plain-language phase tutorial, no file map, no explore prompt craft, no confidence prompts.

---

## Approach comparison

| Option | Description | Verdict |
|--------|-------------|---------|
| **A — `/opsx:help` + short doc + install tip** | Kit-owned skill/command; on-demand (mode C) | **Adopt** |
| B — Overload `/opsx:explore` with scripted tutorial | Conflicts with explore “stance, not workflow” | Reject as primary |
| C — Always-on rule nudge | Context noise; conflicts “no end-of-C1 menu” spirit | Reject (tip line in install stdout only) |
| D — Guide-only prose | Insufficient for vibe-coder first contact (same lesson as discovery) | Reject alone |

---

## Crystallized decisions

### D1 — Command and delivery

- Slash command: **`/opsx:help`** (colon notation, same family as `/opsx:explore`).
- Delivery: **sdd-kit** templates (skill + Cursor/Claude command mirrors) + MANIFEST/checksums + one-line install/`bootstrap` tip + one line in `AGENTS.md` Commands.
- Short canonical EN doc (day-1) as source of truth the skill narrates; F7: artifacts EN, chat may follow `chat_language`.

### D2 — Onboard vs Help (product framing)

| Command | Origin | Role |
|---------|--------|------|
| `/opsx:onboard` | **Upstream OpenSpec** (Fission-AI; in `ALL_WORKFLOWS`) | Learn-by-doing a full change cycle |
| `/opsx:help` | **ByeByeVibe / sdd-kit** | How that cycle runs **inside our control plane** (files, Graphify, GitNexus, confidence prompts, Session Handoff) |

- Help is **not** an “update” or replacement of OpenSpec; it is the **framework layer** explanation.
- Both surfaces are **first-class and discoverable**. Post-install tip and help §0 MUST name both.
- Suggested order: **help first** (map), then **onboard** (practice) — without burying onboard.
- **MUST NOT** hide, replace, or fork `openspec-onboard`. Upstream releases / `openspec update` will refresh onboard; operators must keep receiving those improvements.

### D3 — Upstream composition risk (real; manageable)

Evidence (OpenSpec 1.3.1): `openspec update` regenerates managed skills/commands; `removeUnselected*` only removes deselected `ALL_WORKFLOWS` entries; custom kit skills outside that set are not deleted by that loop; editing `openspec-*` in place is overwritten on update.

| Risk | Reality | Mitigation |
|------|---------|------------|
| Product overlap with `/opsx:onboard` | True | Complementary framing (D2); both visible |
| Harness overwrite | True for OpenSpec-managed files | Help kit-owned only; never patch onboard/explore for help content |
| Schema / validate conflict | **False** — help does not change proposal→specs→design→tasks | — |
| Future name collision if upstream adds `help` | Possible | Document ownership; revisit if upstream ships `help` |

Aligns with README: *We compose OpenSpec; we don't replace it.* Same insertion class as Session Handoff, metrics, Probity (mode C / out-of-band relative to core schema).

### D4 — Tutorial spine

Narrative: **persistent memory for humans and AI agents** — chat is ephemeral; `openspec/` (plus graphs) is the durable record of what was thought, agreed, executed, and left open.

Phases (S-layer):

| Phase | Plain meaning | Produces | Does not |
|-------|---------------|----------|----------|
| explore | Think together without committing code | Clarity / optional `research.md` | Implement |
| propose | Agree the playbook | proposal, specs delta, design, tasks | Ship feature code |
| apply | Execute the checklist | Code + `[x]` + gates | Redesign scope in silence |
| archive | Promote truth and close the change | `openspec/specs/` + `archive/` | Leave WIP active |

Note: not every task needs explore (types A/B). Tutorial MUST say so.

### D5 — File map (clickable repo-relative links)

Translate operator vocabulary:

| Operator phrase | Actual location |
|-----------------|-----------------|
| “roadmap” | Active `openspec/changes/` + canonical `openspec/specs/` |
| “milestones” | Numbered `##` sections in `tasks.md` |
| Do **not** invent `roadmap.md` | — |

Map layers:

- **OpenSpec:** [`openspec/changes/`](../../changes/) · [`openspec/specs/`](../../specs/) · [`openspec/changes/archive/`](../../changes/archive/) · [`openspec/project.md`](../../project.md)
- **Graphify:** [`graphify-out/GRAPH_REPORT.md`](../../../graphify-out/GRAPH_REPORT.md) (regenerable, often gitignored) · `graphify update .`
- **GitNexus:** `.gitnexus/` — do not hand-edit; use `gitnexus status` + MCP impact/context
- **Templates:** [`sdd-kit/templates/openspec/changes/_template/proposal.md`](../../../sdd-kit/templates/openspec/changes/_template/proposal.md) · guide §12.3 (design) · §12.10 (tasks Pattern/Gate)
- OpenSpec npm `schemas/spec-driven/` — cite as package-owned; link in-repo templates for clicks

### D6 — Standard OpenSpec artifacts (especially `design.md`)

Explain inside **`/opsx:help` propose section** (not a orphan doc):

| Artifact | Plain language | When |
|----------|----------------|------|
| `proposal.md` | Why / what (agreement) | Always in propose |
| `specs/**` | Required behavior (WHEN/THEN) | Always for listed capabilities |
| `design.md` | How and why this technical option | When trade-offs, cross-cutting, new deps, security/perf, ambiguity; may be light/minimal when change is obvious (OpenSpec schema: “create only if…”) |
| `tasks.md` | Executable checklist | Always before apply |
| `research.md` | Explore notes | Only if explore ran |

Link guide §12.3 for design template; §12.10 for tasks.

### D7 — Explore prompt craft

Coach humans (not only agent stance): situation/scenario · problem · **inputs** · **outputs** · unknowns (ask questions) · out of scope (no implement in explore). Distinguish **feature I/O** (prompt craft) from **control-plane I/O** (§4.3 tool boxes).

### D8 — Confidence prompts (per phase)

Optional 2–4 copy-paste questions + one objective check where available (e.g. `openspec validate`, task Gates, archive path). Meta question each phase: *What must a new agent read, without this chat, to continue?*

### D9 — Help outline (v1)

0. Layers: OpenSpec ⊂ ByeByeVibe · **Onboard vs Help** (both first-class)  
1. Memory over chat  
2. Clickable map (openspec + Graphify + GitNexus)  
3. explore (+ prompt craft + confidence)  
4. propose (+ artifact glossary / design.md + templates + confidence)  
5. apply (+ gates / handoff + confidence)  
6. archive (+ specs/archive + future notes + confidence)  
7. Next step (handoff example / small change)

Optional later: subcommands (`map`, `prompts`) — not required for v1.

### D10 — Non-goals

- Always-on tutorial rule / forced C1 interactive menu  
- Patching `openspec-onboard` or core `openspec-*` skills to carry ByeByeVibe help content  
- Single CTA that omits `/opsx:onboard`  
- GIF/asciinema (P5 remains deferred)  
- Rewriting guide §3/§4 wholesale  
- Inventing product `roadmap.md` as SDD runtime artifact  

---

## Suggested propose scope

Change-id: **`add-sdd-operator-onboarding`**

- New capability spec (e.g. `sdd-operator-onboarding`) encoding D1–D10  
- Kit skill + commands for `/opsx:help`  
- Short EN day-1 doc  
- Install/bootstrap tip naming **both** `/opsx:help` and `/opsx:onboard`  
- `AGENTS.md` Commands one-liner  
- Optional soft checklist pointer (non-blocking)  
- Evaluation stub under `doc/avaliacoes/` if required by insertion methodology  
- MANIFEST bump + checksums when templates change  

---

## Open questions for propose (non-blocking)

| # | Question | Lean |
|---|----------|------|
| Q1 | Enable OpenSpec `onboard` in default consumer profile, or document-only? | Document + tip; profile = operator choice at C1 |
| Q2 | Help subcommands in v1? | No — single narrated flow |
| Q3 | Soft §2.8 checklist item for help? | Optional, non-blocking |

---

## Explore merge status

**Merged 2026-08-01.** Decisions D1–D10 confirmed in explore chat. No implementation in this change folder beyond this `research.md`.

Next phase: `/opsx:propose add-sdd-operator-onboarding` in a **new chat** (Session Handoff).
