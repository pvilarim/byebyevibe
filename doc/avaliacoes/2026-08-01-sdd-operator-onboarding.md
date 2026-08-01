# Evaluation: SDD operator day-1 onboarding (`/opsx:help`)

| Field | Value |
|-------|--------|
| **Date** | 2026-08-01 |
| **Evaluator** | Explore `explore-sdd-operator-onboarding` → propose/apply `add-sdd-operator-onboarding` |
| **Candidate** | ByeByeVibe day-1 operate surface — kit-owned `/opsx:help` + `doc/sdd-operator-day1.md` + install tip |
| **Decision** | **Adopted** (Option A) |
| **Scope** | C1 install / C2 upgrade payload (docs + skill/command templates); DOCS_SPECS hub |
| **Change** | [`add-sdd-operator-onboarding`](../../openspec/changes/add-sdd-operator-onboarding/proposal.md) |
| **Source research** | [`openspec/changes/explore-sdd-operator-onboarding/research.md`](../../openspec/changes/explore-sdd-operator-onboarding/research.md) |

## Executive summary

After C1, operators could install the three pillars but lacked an in-IDE **day-1 operate** tutorial. Explore merged **Option A**: ByeByeVibe-owned `/opsx:help` narrating a short EN day-1 doc, plus an install tip naming **both** `/opsx:help` and upstream `/opsx:onboard`. Complementary to OpenSpec onboard — never a replacement or fork.

## Problem it tried to solve

Missing day-1 operate layer: plain-language `explore → propose → apply → archive`, clickable file map, explore prompt craft, and per-phase confidence questions — after discovery and install narrative were already adopted.

## What was analyzed

- Explore research D1–D10 (`explore-sdd-operator-onboarding`)
- Guide §2.0b, §2.7–2.8, §3, §4.3, §12.3, §12.10
- Specs: `sdd-discovery-positioning`, `sdd-install-narrative`, `sdd-install-kit`, `sdd-session-handoff`
- OpenSpec 1.3.1 `ALL_WORKFLOWS` / `openspec update` overwrite behavior
- Insertion methodology (R1–R6) from `explore-oss-coverage-gaps`

## Fit with the SDD stack

| Tool | Relation |
|------|----------|
| OpenSpec | Composed; `/opsx:onboard` remains first-class learn-by-doing; help is kit-owned outside `ALL_WORKFLOWS` |
| GitNexus | Documented in day-1 map (do not hand-edit `.gitnexus/`) |
| Graphify | Documented in day-1 map (`GRAPH_REPORT.md`, `graphify update .`) |
| AGENTS.md / sdd-kit | Commands row + MANIFEST COPY templates for skill/commands/doc |

## Risks by workflow phase

| Phase | Risk | Notes |
|-------|------|-------|
| Explore | Overload explore with tutorial | Rejected Option B; help is separate skill |
| Propose | Spec drift vs onboard | Complementary framing in §0 + tip |
| Apply | Skill body becomes second guide | Thin orchestration; day-1 doc is SoT |
| Archive | Soft checklist becomes blocking | Explicit non-blocking; verify.sh must not fail solely for skipping help |

## Expected vs observed gains

| Advertised gain | Assessment |
|-----------------|------------|
| In-IDE day-1 map without replacing onboard | **Adopted** — `/opsx:help` + tip names both |
| Survive `openspec update` | **Adopted** — kit-owned paths only |
| Mode C / on-demand | **Adopted** — no always-on tutorial rule |

## Alternatives already in the stack

- Upstream `/opsx:onboard` (practice cycle) — kept complementary
- Guide §3/§4 depth — pointer only; no wholesale rewrite
- Discovery README / §2.0b — why install; not how to operate day 1

## Decision and re-evaluation conditions

**Decision:** **Adopted** (Option A — `/opsx:help` + day-1 doc + tip)

**Non-goals (v1):** always-on tutorial rule; forced C1 menu; patching `openspec-onboard`; single CTA that omits `/opsx:onboard`; GIF/asciinema; inventing `roadmap.md`; help subcommands.

**Ownership collision note:** If upstream OpenSpec later ships a `help` workflow in `ALL_WORKFLOWS`, revisit kit ownership of `openspec-help` / `/opsx:help` (rename or namespace). Until then, kit-owned help is authoritative for ByeByeVibe day-1 operate.

**Conditions to reopen:**

- Upstream OpenSpec adds `help` to `ALL_WORKFLOWS`
- Operators consistently confuse help vs onboard despite §0 framing
- Demand for help subcommands (`map`, `prompts`) after field use

## References

- [`doc/sdd-operator-day1.md`](../sdd-operator-day1.md)
- [`openspec/changes/add-sdd-operator-onboarding/`](../../openspec/changes/add-sdd-operator-onboarding/)
- [`openspec/changes/explore-sdd-operator-onboarding/research.md`](../../openspec/changes/explore-sdd-operator-onboarding/research.md)
- Guide [`doc/sistema-sdd-pedro.md`](../sistema-sdd-pedro.md) §2.7–2.8
