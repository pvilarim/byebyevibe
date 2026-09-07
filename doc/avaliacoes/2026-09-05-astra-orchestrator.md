# Evaluation: Astra orchestrator — principal agent over the existing control plane

| Field | Value |
|-------|--------|
| **Date** | 2026-09-05 |
| **Evaluator** | Apply session `/opsx:apply` for `explore-astra-orchestrator` (Type E source in `research.md`) |
| **Candidate** | Operator upload `BYEBYEVIBE_ASTRA_ORCHESTRATION_PLAN` — a principal-agent loop (UNDERSTAND → EXPLORE → PROPOSE → PLAN → APPLY → VALIDATE → REVIEW → ARCHIVE) over ByeByeVibe. **Not** an official OpenAI / Cursor product evaluation. |
| **Decision** | **Discarded** as a new hub runtime · orchestrator role **already shipping** as the current-phase `/opsx:*` agent · official GPT-6 / Astra product facts **Deferred** / `[NEEDS VERIFICATION]` |
| **Scope** | Evaluation index + guide §3.4 naming pointer (docs only; no kit version bump) |

## Executive summary

ByeByeVibe **already is** the control plane the Astra plan describes. An "orchestrator commanding ByeByeVibe" is a **possibility**, not a runtime to build: the current-phase agent (`/opsx:explore` \| `/opsx:propose` \| `/opsx:apply` \| `/opsx:archive`) already plays that role. A new TypeScript/YAML machine that owns phase state (ChangeState, PolicyEngine, events, one-process explore→archive) is the same class of failure as Deer Workflow and is **Discarded**. Official GPT-6 / Astra product name, API, GA, and capabilities stay `[NEEDS VERIFICATION]` until official docs; this change does not wait for a launch.

Full mapping, conflicts, and model-readiness argument: [`openspec/changes/explore-astra-orchestrator/research.md`](../../openspec/changes/explore-astra-orchestrator/research.md). This note does **not** copy research §1–§8.

## Problem it tried to solve

Name who "runs" the SDD loop when a strong Cursor model sits in the chair, without inventing a second program counter or waiting for a future model.

## What was analyzed

- [`openspec/changes/explore-astra-orchestrator/research.md`](../../openspec/changes/explore-astra-orchestrator/research.md) (Type E, 2026-09-05) — source of the verdict
- `openspec/project.md` Non-goals (code-first SDD orchestration runtime)
- Specs `sdd-session-handoff`, `sdd-session-coordination`, `sdd-ci-gates`
- Prior evaluations: [Deer Workflow](./2026-08-13-deer-workflow.md), [LifeOS](./2026-08-11-lifeos.md), G6 in [OSS coverage gaps](./2026-07-25-oss-coverage-gaps-tooling.md)
- Neighbors (out of this change): issue [#349](https://github.com/pvilarim/byebyevibe/issues/349); draft [PR #383](https://github.com/pvilarim/byebyevibe/pull/383)

## Fit with the SDD stack

| Tool | Relation |
|------|----------|
| OpenSpec | Artifacts remain session memory; no new capability beyond a naming delta on `sdd-session-handoff` |
| GitNexus | Impact tool for apply; cold-VM "not indexed" is environment, not missing IQ |
| Graphify | Concept map for explore/propose; absent `GRAPH_REPORT.md` on a cold VM is environment |
| AGENTS.md / sdd-kit | Role is already the `/opsx:*` agent; no new slash command, no version bump |

## Risks by workflow phase

| Phase | Risk | Notes |
|-------|------|-------|
| Explore | Re-opening Deer / G6 / LifeOS under the "Astra" brand | This index row exists to stop that |
| Propose | Treating S1 as permission to build a runtime | Discarded line is the first decision row; Non-goals bind |
| Apply | Collapsing explore→archive in one chat | Forbidden by `sdd-session-handoff`; agent must refuse |
| Archive | Claiming "done" without gate evidence | VALIDATE stays `openspec validate` + `sdd-gates`, not a chat assertion |

## Expected vs observed gains

| Advertised gain | Assessment |
|-----------------|------------|
| Principal agent runs a disciplined loop over ByeByeVibe | **Already shipping** as one phase per chat, with Session Handoff |
| Stronger future model (GPT-6 / Astra) makes orchestration possible | **Not required.** Current Cursor models already run the role one phase at a time. Product claims remain `[NEEDS VERIFICATION]` |
| ChangeState / PolicyEngine / event bus as executable SoT | **Discarded** — competes with `tasks.md`; same class as Deer Workflow |

## Alternatives already in the stack

The `/opsx:*` skills, `tasks.md` as apply program counter, Session Handoff as cross-session memory, R7 human gate, R11 worktree locks, and CI `sdd-gates` already implement the plan's architecture diagram. Cursor Automations (`doc/i18n/CURSOR-AUTOMATIONS.md`) already practice one Cloud Agent run = one phase. Guide §11.3 `orchestrator.service.ts` is an **APP** sample — not the hub control plane.

## Cabe / não cabe (today)

| Fits today | Does not fit |
|------------|--------------|
| Model = tech lead of **this** phase | TypeScript runtime owning phase state |
| Versioned artifact = memory | `workflow.ts` / chat as source of truth |
| Human or Cursor Automation = scheduler | One chat = all phases |
| Gates = VALIDATE with evidence | "Done" without evidence |

## Decision and re-evaluation conditions

| Slice | State |
|-------|--------|
| New hub runtime (ChangeState / PolicyEngine / events / single-process explore→archive) | **Discarded** (same class as Deer Workflow) |
| Orchestrator role = current-phase `/opsx:*` agent | **Already shipping** (named in guide §3.4) |
| Official GPT-6 / Astra product facts | **Deferred** / `[NEEDS VERIFICATION]` until official docs |

**Conditions to reopen** the discarded runtime slice:

- A new OpenSpec change that **explicitly amends** `sdd-session-handoff` (one session = one phase) **and** `openspec/project.md` Non-goals — not a rename of Deer/G6
- Official vendor docs (not marketing pages) for any named Astra / GPT-6 product, if someone wants a **product** evaluation rather than this protocol note

**Out of this evaluation:** S3 VALIDATE checklist skill; S4 executor report / event bus; `/opsx:orchestrate`; waiting for a model launch.

## References

- [`openspec/changes/explore-astra-orchestrator/research.md`](../../openspec/changes/explore-astra-orchestrator/research.md)
- [`openspec/changes/explore-astra-orchestrator/proposal.md`](../../openspec/changes/explore-astra-orchestrator/proposal.md)
- `doc/byebyevibe-guide.md` §3.4
- `openspec/project.md` Non-goals
- [`2026-08-13-deer-workflow.md`](./2026-08-13-deer-workflow.md) · [`2026-08-11-lifeos.md`](./2026-08-11-lifeos.md) · [`2026-07-25-oss-coverage-gaps-tooling.md`](./2026-07-25-oss-coverage-gaps-tooling.md) (G6)
