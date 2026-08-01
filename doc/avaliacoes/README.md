# SDD integration and improvement evaluations

Historical record of tools, patterns, and ideas **evaluated** for the **OpenSpec + GitNexus + Graphify** stack — regardless of whether they were adopted or discarded.

## Purpose

- Document **what was researched**, **why**, and **the decision**
- Avoid re-evaluating the same candidate without context
- Give agents an anchored source (priority 6 in `AGENTS.md` — repo docs) so they do not propose reinstalling discarded items

## How to use

| Role | Action |
|------|--------|
| Human | Before adopting a new tool into `sdd-kit`, check whether an evaluation already exists here |
| Agent | Read this index before proposing integration of CLIs/MCP/plugins into the SDD stack |
| New evaluation | Copy `TEMPLATE.md`, fill it in, add a row to the table below |

## Decision states

| State | Meaning |
|-------|---------|
| **Adopted** | Integrated into the kit, guide, or `openspec/specs/` |
| **Discarded** | Evaluated; do not integrate without a new OpenSpec proposal |
| **Deferred** | Future potential; re-evaluation conditions documented |
| **Under evaluation** | Work in progress |

## Evaluation index

| Date | Candidate | Decision | Document |
|------|-----------|----------|----------|
| 2026-08-01 | Tooling guidance — external-tool resolution cascade (CLI → MCP → manual), `sdd-tooling-guidance` skill + R10 + gap-check + day-1 §8 (v1) | **Adopted** — stack-inference, per-tool preferences, telemetry, preflight WARNs deferred to v2 | [2026-08-01-tooling-guidance.md](./2026-08-01-tooling-guidance.md) · [explore research](../../openspec/changes/explore-tooling-guidance/research.md) |
| 2026-08-01 | Skill lifecycle guidance for novices — `sdd-skill-guidance` skill + day-1 §7 + detection clauses (v1 text-only) | **Adopted** — monitoring tooling deferred to v2 | [2026-08-01-skill-guidance.md](./2026-08-01-skill-guidance.md) · [explore research](../../openspec/changes/explore-skill-guidance/research.md) |
| 2026-08-01 | SDD operator day-1 onboarding — `/opsx:help` + day-1 doc + tip (Option A) | **Adopted** — complementary to upstream `/opsx:onboard` | [2026-08-01-sdd-operator-onboarding.md](./2026-08-01-sdd-operator-onboarding.md) · [explore research](../../openspec/changes/explore-sdd-operator-onboarding/research.md) |
| 2026-07-26 | Positioning and discovery — ByeByeVibe (vibe → agentic); P10 adopted in docs | **Mixed** — P1–P4 + P10 Adopted; P11/P12 (i18n + root CHANGELOG) Deferred until public release; P5 / fame Deferred or Do not implement | [2026-07-26-sdd-discovery-positioning.md](./2026-07-26-sdd-discovery-positioning.md) · [explore research](../../openspec/changes/explore-public-release-surface/research.md) |
| 2026-03-26 | [Headroom](https://github.com/chopratejas/headroom) — context compression for agents | **Discarded** | [2026-03-26-headroom-context-compression.md](./2026-03-26-headroom-context-compression.md) |
| 2026-06-27 | SDD UI module (Impeccable + Open Design + Pencil + shadcn) — `add-sdd-ui-development-module` | **Adopted** | [2026-06-27-sdd-ui-development-module.md](./2026-06-27-sdd-ui-development-module.md) |
| 2026-07-25 | OSS tools for SDD gaps (Probity (G2), PR-Agent, Renovate+OSV, github-mcp, DevLake, Vibe Kanban, GlitchTip) — `explore-oss-coverage-gaps` | **Mixed** — see doc | [2026-07-25-oss-coverage-gaps-tooling.md](./2026-07-25-oss-coverage-gaps-tooling.md) |

## Relation to the stack

These evaluations **do not replace** `openspec/specs/` (normative requirements). Adopting a candidate requires its own OpenSpec change; discarding is recorded here and in `openspec/project.md` (Non-goals), when applicable.

See also: `doc/sistema-sdd-pedro.md` §5.5 · `openspec/project.md` (Cross-references / Non-goals)
