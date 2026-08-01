# Evaluation: Skill lifecycle guidance for novice operators (sdd-skill-guidance)

| Field | Value |
|-------|--------|
| **Date** | 2026-08-01 |
| **Evaluator** | explore session `explore-skill-guidance` → change `add-skill-guidance` |
| **Candidate** | Novice-facing skill guidance (pedagogy + agent-side detection + suggestion protocol) — internal, no external tool |
| **Decision** | Adopted |
| **Scope** | C1 install (kit guidance surfaces) + hub explore/propose/archive surfaces |

## Executive summary

Text-only guidance layer teaching operators when a user-created skill helps versus when it is pure token cost, with agent-side domain-density detection and an offer-only suggestion protocol. Adopted as v1 (canonical `sdd-skill-guidance` skill + day-1 §7 + detection clauses); all monitoring tooling deferred to v2. Based on explore research D1–D10 (`explore-skill-guidance`, 2026-08-01).

## Problem it tried to solve

The control plane's most token-efficient memory mechanism — skills — had no guidance surface: novices could not tell skill-worthy knowledge (local laws, company thresholds, proprietary methods — D1, D6) from pure cost (generic stack knowledge, naked personas), the system never detected repeated domain teaching (D4, D5), and unguided creation risks skill inflation with trigger-precision degradation (D7) — the failure mode that makes novices abandon the mechanism.

## What was analyzed

- `openspec/changes/explore-skill-guidance/research.md` — decisions D1–D10
- `sdd-kit/install.sh` `print_day1_operate_tip` + `openspec-help` dual-surface delivery pattern
- `scripts/sdd-metrics.sh` §2.17 cadence pattern (v2 candidate vehicle for harvest)
- Skill token model: description charged per session (~30–80 tokens lean), body on trigger, `references/` on consult (D3)

## Fit with the SDD stack

| Tool | Relation |
|------|----------|
| OpenSpec | Archive confidence question (rule of three) rides the existing checklist; specs stay behavioral, skills stay procedural |
| GitNexus | None (text-only change) |
| Graphify | None (text-only change) |
| AGENTS.md / sdd-kit | New kit-owned dual-surface skill `sdd-skill-guidance` (openspec-help pattern); detection clauses on hub explore/propose surfaces |

## Risks by workflow phase

| Phase | Risk | Notes |
|-------|------|-------|
| Explore | Suggestion fatigue | Cap ≤1/session, offer-only; gold signal (domain-fact correction) weighted highest (D5) |
| Propose | Same detection clause duplicated across surfaces | Canonical text lives in the skill; surfaces reference it (D-E) |
| Apply | None | Guidance is inert during apply |
| Archive | Question becomes ceremony | One line in the existing confidence list; never blocks archive |

Cross-phase: stale domain skills asserting outdated data → "verified on YYYY-MM" marker + won't-self-update warning in the standard message; automated monitoring is v2.

## Expected vs observed gains

| Advertised gain | Assessment |
|-----------------|------------|
| Novices learn the litmus test at the right moment | Suggestion-at-detection is the teaching mechanism; day-1 §7 is depth (D5) |
| Skill inflation prevented at creation time | Hygiene rules (search-before-create, description diet, task naming) are the cheapest lever (D8) |
| Repetition harvested at archive | Rule-of-three question; v2 cadence harvest deferred (D4, D9) |

## Alternatives already in the stack

`openspec/project.md` holds constitution-level facts; specs hold required behavior; neither recalls procedural domain knowledge automatically. Always-on rules were rejected (charge every session; violate onboarding non-goals). Doing nothing leaves the repeated-teaching cost invisible to novices.

## Decision and re-evaluation conditions

**Decision:** Adopted (v1, text-only)

**Deferred to v2** (re-open with a new OpenSpec change): M5 skill-load metric in `sdd-metrics.sh`; usage telemetry (Claude Code `PostToolUse` hook; Cursor needs a per-surface design with degradation path — D10); bidirectional `/opsx:harvest` on the N=5/T=30 cadence; stack seed skills from `project.md` (D9). v3: organizational domain-skill library.

## References

- [explore research (D1–D10)](../../openspec/changes/explore-skill-guidance/research.md)
- [change add-skill-guidance](../../openspec/changes/add-skill-guidance/proposal.md)
- `doc/sistema-sdd-pedro.md` §2.17 (cadence pattern)
