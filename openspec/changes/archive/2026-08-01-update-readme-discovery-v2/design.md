# Design: update-readme-discovery-v2

## Context

Discovery v1 (`add-sdd-discovery-positioning`, `rename-byebyevibe-public-name`) shipped a root EN README, evaluation doc, guide §2.0b quickstart, and ByeByeVibe public name. Follow-ups `improve-install-narrative` and `add-sdd-operator-onboarding` added install What/Why/Without it banners and `/opsx:help` (`doc/sdd-operator-day1.md`). Exploration v2 concluded the README should hybridize **conversion** (value above the fold) with **pedagogy** (didactic tool table, day-1 map, optional modules, G4 retrospectives).

**AS-IS note (pre-apply audit):** Current `README.md` on `master` already implements most v2 sections (Why install this, Core tools What/Without it, `/opsx:help`, Optional modules, Calibrate as you go). Apply should treat this as **verify-and-close-gaps** rather than a greenfield rewrite — gates confirm invariants; evaluation doc and spec delta formalize the decision.

Sources: `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`, `openspec/specs/sdd-discovery-positioning/spec.md`, guide §2.0b / §2.1–2.4, `doc/sdd-operator-day1.md`, `.claude/skills/openspec-help/SKILL.md`.

## Goals / Non-Goals

**Goals:**

- Mandatory 17-section README order (see proposal) with approved EN terms unchanged.
- Above-fold: H1 + tagline + OS phrase + toolkit sentence + Why install (4–5 bullets) + anti-boilerplate + Get started CTA.
- Proof block: problem → didactic core-tools table → User-friendly OpenSpec (`/opsx:help`) → demo loop.
- Differentiation: optional modules, G4 calibrate-as-you-go, disambiguation table, compare, docs links, manual checklist, maintainer.
- Spec delta capturing v2 requirements for future regressions.
- Evaluation doc records v2 layout decision without altering P5/P11 deferred backlog.

**Non-Goals:**

- P5 GIF/asciinema; P6–P8 fame/landing/Discord; P9 app scaffold; P11/P12 i18n/CHANGELOG; GitHub slug rename (manual); ML/self-learning G4 claims; `sdd-kit/` MANIFEST bump.

## Decisions

### D1 — Section order is normative, not suggestive

**Choice:** Lock the 17-section outline from exploration as the README skeleton; apply reorders only when gates fail or a section is missing.

**Alternatives:** Keep current organic order (rejected — value bullets were historically below the fold).

**Rationale:** GitHub first viewport drives conversion; pedagogy follows proof.

### D2 — Approved copy is frozen; structure moves

**Choice:** Reuse exact approved strings:

| Element | Copy |
|---------|------|
| Tagline | *From vibe coding to shippable AI engineering.* |
| Market line | *Vibe coding until the first PR. After that, agentic engineering.* |
| OS phrase | *missing operating system between your coding agent and a maintainable repo* |
| Toolkit | *installable toolkit for AI-assisted development* |
| Anti-boilerplate | *Not another Next.js starter — the SDD control plane* |

**Alternatives:** New marketing copy (rejected — F7 / evaluation already ratified).

### D3 — Core tools table uses What / Without it (guide §2.1–2.4)

**Choice:** Table columns: Tool | What it is | Without it — for OpenSpec, GitNexus, Graphify, `sdd-kit/`, CI `sdd-gates`, session locks (AGENTS.md row optional if space tight).

**Alternatives:** Bullet list only (rejected — exploration flagged weak pedagogy).

### D4 — `/opsx:help` is first-class in README, not only in guide

**Choice:** Dedicated "User-friendly OpenSpec" section with table: `/opsx:help`, `/opsx:onboard`, `/opsx:explore`, propose→apply→archive; link `doc/sdd-operator-day1.md`.

**Alternatives:** Single line in demo (rejected — day-1 map is a differentiator post `add-sdd-operator-onboarding`).

### D5 — Optional modules get a named section

**Choice:** `## Optional modules` table: C1-UI, G2 Probity, post-apply review skills, G4 pointer — each with guide § link.

**Alternatives:** Only in compare/capability table (rejected — buried).

### D6 — G4 framing: process retrospectives, explicit anti-ML

**Choice:** Section "Calibrate as you go" references `sdd-metrics.sh`, cadence nudge, guide §2.17; parenthetical forbids ML/self-learning claims.

**Alternatives:** Omit metrics from README (rejected — D11 in archived design).

### D7 — Cross-surface updates are minimal

| File | Action |
|------|--------|
| `README.md` | Primary edit / verify |
| `doc/avaliacoes/…-positioning.md` | Add "v2 layout" subsection under roadmap; note what changed |
| `doc/sistema-sdd-pedro.md` §2.0b | Skip if `/opsx:help` already present (current master: present) |
| `openspec/specs/` | Updated only via archive of this change |

### D8 — Verification via grep gates (tasks.md)

**Choice:** Deterministic shell greps per §12.10; plus `openspec validate --strict`; negative gate for ML claims.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| README already matches v2 → redundant apply | Gates + evaluation note; apply marks tasks done when greps pass |
| Section reorder breaks deep links | No external anchors assumed; internal doc links unchanged |
| `/opsx:help` vs `/opsx:onboard` confusion | Table + "help first, onboard second" in design and README |
| Accidental ML claim in G4 copy | Negative grep gate; design D6 |
| Evaluation roadmap item ④ pre-marked "done" without change | Apply updates evaluation to reference `update-readme-discovery-v2` change-id |

## Migration Plan

1. Apply README restructure (or verify AS-IS passes gates).
2. Patch evaluation doc v2 decision paragraph.
3. Verify §2.0b cross-link (no-op if present).
4. Run all gates in `tasks.md`.
5. Archive → promotes spec delta to `openspec/specs/sdd-discovery-positioning/spec.md`.

Rollback: revert README/evaluation commits; no kit or CI impact.

## Open Questions

_None — exploration closed; approved terms and outline provided in user brief._
