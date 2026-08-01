---
name: openspec-help
description: Day-1 operator tutorial for the ByeByeVibe control plane — narrate doc/sdd-operator-day1.md (phases, file map, explore prompt craft, confidence). Use when the user runs /opsx:help, asks how to operate after install, or needs Onboard vs Help framing. On-demand (mode C); complementary to upstream /opsx:onboard.
license: MIT
compatibility: Requires openspec CLI context; narrates ByeByeVibe day-1 doc.
metadata:
  author: byebyevibe
  version: "1.0"
---

# /opsx:help — Day-1 operator map (ByeByeVibe)

On-demand tutorial for the ByeByeVibe **control plane**. Thin orchestration only — the canonical outline lives in `doc/sdd-operator-day1.md`.

**Complementary to upstream `/opsx:onboard`:** Help maps files, phases, Graphify, GitNexus, confidence, and Session Handoff. Onboard is learn-by-doing a full OpenSpec cycle. Name **both**. Suggested order: help (map) → onboard (practice). Do **not** hide, replace, or fork `openspec-onboard`.

**Mode C:** Invoke only when asked (`/opsx:help`) or when the operator clearly needs day-1 operate guidance. No always-on injection of the full tutorial.

---

## Steps

1. **Read the canonical day-1 doc**

   Read `doc/sdd-operator-day1.md` in full (or walk §0–§7 in order if the operator asks for a section).

2. **Narrate the outline (do not invent a second essay)**

   Walk the locked sections:

   | § | Topic |
   |---|--------|
   | 0 | OpenSpec ⊂ ByeByeVibe · **Onboard vs Help** |
   | 1 | Memory over chat |
   | 2 | Clickable map (openspec + Graphify + GitNexus) |
   | 3 | explore (+ prompt craft + confidence) |
   | 4 | propose (+ artifact glossary / `design.md` + confidence) |
   | 5 | apply (+ gates / handoff + confidence) |
   | 6 | archive (+ specs/archive + confidence) |
   | 7 | Next step (handoff / small change) |

3. **Keep framing honest**

   - Chat is ephemeral; `openspec/` (+ graphs) is durable memory.
   - “Roadmap” → `openspec/changes/` + `openspec/specs/`; “milestones” → `tasks.md` sections — never invent `roadmap.md`.
   - Not every task needs explore (types A/B).
   - Point to guide `doc/sistema-sdd-pedro.md` for depth (§2.7–2.8, §4.3, §12.3, §12.10) — do not rewrite §3/§4 here.

4. **Infra**

   Read `openspec/infra.md` only if the operator asks to install tools. Items marked ✅ — use directly; do not reinstall.

5. **Optional Session Handoff**

   When narration finishes, you MAY offer a short handoff toward `/opsx:onboard` or `/opsx:propose` (see day-1 §7). Still name both help and onboard.

---

## Guardrails

- **Do not implement** product features in a help session.
- **Do not patch** `openspec-onboard` or other OpenSpec-managed `openspec-*` skills with ByeByeVibe help content.
- **Do not** omit `/opsx:onboard` when describing day-1 next steps.
- **Do not** invent help subcommands in v1 (`map`, `prompts`) — single narrated flow.
- Keep this skill thin; edit `doc/sdd-operator-day1.md` when tutorial content changes.

---

## Session Handoff (optional)

When the operator is ready to practice or start a change:

```text
/opsx:onboard
# or
/opsx:propose <short description>

Change: openspec/changes/<id>/
Read: proposal.md, design.md, tasks.md, specs/
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
