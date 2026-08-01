## Context

Post-C1, operators can install the three pillars and run `/opsx:propose` as a sanity check, but they lack an in-IDE **day-1 operate** tutorial: plain-language phases, where files live, how to craft an explore prompt, and how to ask confidence questions before Session Handoff. Explore `explore-sdd-operator-onboarding` (merged 2026-08-01) chose **Option A**: ByeByeVibe-owned `/opsx:help` + short EN day-1 doc + install tip, complementary to upstream `/opsx:onboard`.

Constraints: F7 (artifacts EN; chat may follow `chat_language`); compose OpenSpec, do not replace it; kit-owned files must survive `openspec update` (never patch `openspec-onboard` or core `openspec-*`); mode C / on-demand (no always-on rule); DOCS_SPECS hub — no APP feature code.

Sources: `openspec/changes/explore-sdd-operator-onboarding/research.md` (D1–D10); `proposal.md`; guide §2.7–2.8, §3, §12.3, §12.10; `openspec/specs/sdd-discovery-positioning`, `sdd-install-narrative`, `sdd-install-kit`, `sdd-session-handoff`; `metodologia-insercao.md`; OpenSpec 1.3.1 package behavior for `ALL_WORKFLOWS` / `openspec update`.

## Goals / Non-Goals

**Goals:**

- Ship `/opsx:help` as a kit-owned skill + Cursor/Claude command mirrors that narrate the canonical day-1 doc.
- Publish a short EN day-1 doc covering Onboard vs Help, memory-over-chat, clickable map, four phases (+ explore prompt craft + confidence), and a next-step handoff example.
- Add install/bootstrap tip naming **both** `/opsx:help` and `/opsx:onboard` (help map → onboard practice).
- Register `/opsx:help` in AGENTS Commands (hub + kit templates).
- Optional soft §2.8 checklist pointer (non-blocking).
- Evaluation stub + MANIFEST/checksums for new templates.
- Six-point insertion contract (infra / AGENTS / skill / guide pointer / avaliação / kit) at appropriate lightness for a docs+skill surface.

**Non-Goals:**

- Always-on tutorial rule or forced end-of-C1 menu.
- Patching or forking `openspec-onboard` / core `openspec-*` skills.
- Single CTA that omits `/opsx:onboard`.
- Help subcommands (`map`, `prompts`) in v1.
- GIF/asciinema; inventing `roadmap.md` as an SDD runtime artifact.
- Wholesale rewrite of guide §3/§4.
- Enabling OpenSpec `onboard` in a forced default consumer profile (document + tip only; operator chooses at C1).

## Decisions

### D1 — Command identity and delivery (explore D1)

| Choice | Detail |
|--------|--------|
| Slash | `/opsx:help` (colon family, same as explore/propose) |
| Skill id | `openspec-help` (ByeByeVibe-authored; **not** in OpenSpec `ALL_WORKFLOWS`) |
| Delivery | `sdd-kit/templates/` → MANIFEST COPY for all profiles: skill (`.cursor/skills/openspec-help/SKILL.md` + `.claude/skills/openspec-help/SKILL.md`), commands (`.cursor/commands/opsx-help.md` + `.claude/commands/opsx/help.md`), day-1 doc |
| Hub | Mirror the same paths in the hub repo so operators of this repo get help without reinstall |
| Mode | On-demand (C) — skill description states when to invoke; no alwaysApply rule |

### D2 — Onboard vs Help framing (explore D2)

| Command | Origin | Role |
|---------|--------|------|
| `/opsx:onboard` | Upstream OpenSpec | Learn-by-doing a full change cycle |
| `/opsx:help` | ByeByeVibe / sdd-kit | How that cycle runs **inside our control plane** (files, Graphify, GitNexus, confidence, Session Handoff) |

Day-1 doc §0 and install tip MUST name both as first-class. Suggested order: **help first** (map), then **onboard** (practice). MUST NOT hide, replace, or fork onboard.

### D3 — Canonical day-1 doc path and outline (explore D4–D9)

Path: **`doc/sdd-operator-day1.md`** (short, EN, F7). Skill narrates this file; does not duplicate a second essay in the skill body beyond a thin orchestration layer (stance + “read and walk the outline”).

Outline v1 (locked from explore D9):

0. Layers: OpenSpec ⊂ ByeByeVibe · **Onboard vs Help**  
1. Memory over chat  
2. Clickable map (openspec + Graphify + GitNexus)  
3. explore (+ prompt craft + confidence)  
4. propose (+ artifact glossary / design.md + templates + confidence)  
5. apply (+ gates / handoff + confidence)  
6. archive (+ specs/archive + future notes + confidence)  
7. Next step (handoff example / small change)

File map vocabulary (explore D5): “roadmap” → active `openspec/changes/` + canonical `openspec/specs/`; “milestones” → numbered `##` in `tasks.md`; do **not** invent `roadmap.md`.

### D4 — Explore prompt craft + confidence (explore D7–D8)

Coach in the day-1 doc (and help narration): situation · problem · **inputs** · **outputs** · unknowns · out of scope (no implement in explore). Distinguish feature I/O from control-plane I/O (§4.3). Per phase: 2–4 copy-paste confidence questions + one objective check where available (`openspec validate`, task Gates, archive path). Meta: *What must a new agent read, without this chat, to continue?*

Note in tutorial: not every task needs explore (types A/B).

### D5 — Install / bootstrap tip placement (explore D1, Q1)

After `install.sh` standard next-steps (and mirror a line in `bootstrap-sdd.sh` manual steps), print a short **day-1 operate** tip naming both commands. Honor `CHAT_LANG` like the add-ons teaser. Does **not** replace the optional-addons teaser; sits as a separate tip (before or after add-ons — prefer **before** add-ons so operate comes before optionals).

EN draft (apply may tighten wording, not meaning):

```
Day-1 operate: /opsx:help (map this control plane) then /opsx:onboard (practice a full cycle — upstream OpenSpec).
```

### D6 — AGENTS + soft checklist (explore D1, Q3)

- Commands table: one row `/opsx:help` → “Day-1 operator tutorial (ByeByeVibe control plane)” in hub `AGENTS.md` and `sdd-kit/templates/AGENTS.commands.{APP,DOCS_SPECS}.md` (and core if a Commands table lives there).
- §2.8: optional soft item `[ ] /opsx:help (or doc/sdd-operator-day1.md) — day-1 map` — non-blocking; verify.sh MUST NOT fail solely for skipping it.
- Guide: one pointer from §2.7 sanity / near §2.8 to the day-1 doc and `/opsx:help` — no §3/§4 rewrite.

### D7 — Insertion contract and pilot

| Point | Action |
|-------|--------|
| R1 infra | Row under Skills / On-demand: `/opsx:help` ✅ |
| R2 AGENTS | Commands one-liner + optional On-demand context row |
| R3 skill | `openspec-help` + command mirrors |
| R4 guide | Short pointer (§2.7/§2.8 area) |
| R5 avaliação | `doc/avaliacoes/2026-08-01-sdd-operator-onboarding.md` + index row |
| R6 kit | Templates + MANIFEST + checksums |

Pilot **waived** (no new binary/hook). Rollback: remove MANIFEST entries + templates + tip strings + docs; upstream onboard untouched.

### D8 — Naming collision with future upstream `help`

If upstream OpenSpec later ships a `help` workflow in `ALL_WORKFLOWS`, revisit ownership (document in avaliação). Until then, kit-owned `openspec-help` is authoritative for ByeByeVibe day-1 operate.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Product overlap with `/opsx:onboard` | Complementary framing (D2); both visible in tip and §0 |
| `openspec update` overwrites patched OpenSpec skills | Help is kit-owned only; never edit onboard/explore for help content |
| Future upstream name collision on `help` | Document ownership (D8); rename or namespace later if needed |
| Skill body grows into a second guide | Skill orchestrates; day-1 doc is SoT; keep skill thin |
| Checklist item becomes blocking by accident | Soft / optional; no verify.sh hard fail |
| Operators skip help and only run onboard | Tip + §0 state suggested order without burying onboard |

## Migration Plan

1. Apply creates day-1 doc, skill/commands (hub + kit templates), tip strings, AGENTS rows, guide pointer, avaliação, MANIFEST + checksums.
2. Consumer repos pick up via C1 install or C2 upgrade (COPY templates).
3. Rollback: delete new templates/entries and tip; no OpenSpec schema change.

## Open Questions

| # | Question | Lean (locked for apply) |
|---|----------|-------------------------|
| Q1 | Force enable OpenSpec `onboard` in default profile? | **No** — document + tip; operator choice at C1 |
| Q2 | Help subcommands in v1? | **No** — single narrated flow |
| Q3 | Soft §2.8 checklist item? | **Yes** — optional, non-blocking |
| Q4 | Exact tip position vs add-ons teaser? | **Before** optional-addons teaser |
