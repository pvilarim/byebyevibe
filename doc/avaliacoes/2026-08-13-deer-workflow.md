# Evaluation: Deer Workflow — code-first agent orchestration runtime

| Field | Value |
|-------|--------|
| **Date** | 2026-08-13 |
| **Evaluator** | Explore session `/opsx:explore` (Cloud Agent, Claude Code) |
| **Candidate** | [deer-workflow](https://github.com/deerwork-ai/deer-workflow) (`@deerwork-ai/deer-workflow`, MIT, TypeScript + Bun) |
| **Decision** | **Discarded** as kit payload / SDD pipeline runtime · **Deferred** for two narrow scopes (i18n fan-out runner; optional downstream module for APP repos) |
| **Scope** | Headless batch orchestration layer — `sdd-kit` candidate, rejected; two bounded runner scopes kept in backlog |

## Executive summary

Deer Workflow is a TypeScript runtime for "Graph Engineering": control flow, phases, and failure handling live in reviewable TypeScript, while `agent()` nodes delegate semantic work to a replaceable coding agent (`codex exec` by default, `claude --print` and Pi built in). Execution is **headless batch** — no human-in-the-loop primitive, no documented checkpoint, no resume.

**Discarded** as kit payload: it and ByeByeVibe compete for the same job — *who holds the state of the phase machine*. In the SDD stack that state is durable, reviewable, and on disk (`tasks.md` is the program counter); in Deer Workflow it is a TypeScript call stack in memory. Encoding explore→propose→apply→archive as a `workflow.ts` deletes the R7 pre-code human gate, makes a failed apply non-resumable, and duplicates 151–318-line interactive skills as prompt strings. Same failure mode recorded for LifeOS: a rival, non-durable definition of "done".

**Deferred** in two bounded scopes where the mismatch does not apply: (a) mechanical fan-out with a deterministic gate — the i18n translation waves are the only concrete instance in this repo; (b) an optional downstream module teaching APP repos to author `workflow.ts` under SDD discipline, on the C1-UI precedent. Neither is actionable today.

Governance is the second blocker: the repository was created **2026-07-26** and is self-described as a pilot for DeerFlow 3.0. Eighteen days of history is not a stable API to pin a kit payload against.

## Problem it tried to solve

Two candidate gaps, only one of which the SDD stack actually has:

1. **A deterministic, reviewable orchestrator for multi-step agent work** — the SDD pipeline is already this, in markdown, with a human gate. Not a gap; a competing implementation.
2. **A headless runner for mechanical fan-out that today is ad-hoc glue** — real. `scripts/translate-guide-next-wave.sh`, `scripts/gen-missing-translate-proposes.py`, `scripts/close-stale-translate-archive-prs.sh` and a Cursor Automation (`doc/i18n/CURSOR-AUTOMATIONS.md` §5.2.1) currently coordinate the i18n waves by hand. This is the only reason the evaluation is not a flat discard.

## What was analyzed

- `README.md` (rendered landing page) — positioning, CLI surface, agent runtimes.
- `docs/api.md` — full public API, Agent interface, event schema, error semantics.
- `docs/index.md` — getting-started, generated module shape, CLI flags, `WorkflowRunner` embedding.
- `skills/workflow-creator/SKILL.md` — activation triggers and the rules imposed on the authoring agent.
- GitHub repository metadata via API (dates, stars, forks, license, activity).
- Normative constraints in this repo: `AGENTS.md` R1–R11 and the Task Classification Protocol, `openspec/project.md` (profile, non-goals), `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` (Phase 0 checks V1–V5 / F1–F5), `doc/i18n/WAVES.md` (wave budgets).
- Prior decisions: [`2026-08-11-lifeos.md`](./2026-08-11-lifeos.md) (two constitutional layers), [`2026-07-25-oss-coverage-gaps-tooling.md`](./2026-07-25-oss-coverage-gaps-tooling.md) (G6 multi-agent orchestration, discarded), [`2026-06-27-sdd-ui-development-module.md`](./2026-06-27-sdd-ui-development-module.md) (optional-module precedent).

### Verified facts

- **Public API** (`docs/api.md`): `agent`, `log`, `parallel`, `phase`, `pipeline`, `workflow`, `WorkflowEventEmitter`, `WorkflowRunner`. A workflow module exports `default` or `run`, plus an optional static `meta` (`name`, `description`, `phases`, `exampleArgs`) that must be readable as literals only.
- **Agent interface is one-shot:** `run<TOutput = string>(prompt: string, options?: AgentOptions): Promise<TOutput>`. Shipped implementations: `CodexAgent` (non-interactive `codex exec`), `ClaudeAgent` (non-interactive `claude --print`), `PiAgent` (Pi 0.84.1). Sandbox modes: `read-only`, `workspace-write`, `danger-full-access`.
- **No state, no checkpoint, no resume.** `docs/api.md` states explicitly: *"No built-in state persistence or checkpoint feature is documented. Workflow execution is stateless; durability and resumption depend on application implementation."*
- **Failure semantics are drop-and-continue.** In `parallel()` and `pipeline()`, a rejected or synchronously thrown task becomes `null` without cancelling siblings or remaining stages; callers filter and decide what completion level is acceptable. Agent failures throw typed errors (`CodexAgentError`, `ClaudeAgentError`, `PiAgentError`) carrying exit code and stderr.
- **Observability is a JSONL event stream:** `workflow:start`, `workflow:meta`, `workflow:end`, `workflow:error`, `workflow:phase:start`, `workflow:phase:end`, `log`, each with `workflowId`, `parentWorkflowId?`, `depth`, `scriptPath`, `sequence`, `timestamp`. Interactive TUI by default; `--print`/`-p` emits JSON Lines.
- **Nesting is limited:** `workflow(target, args?)` supports one nesting level.
- **CLI:** `deer-workflow create "<description>" [--agent codex|claude|pi] > workflow.ts` and `deer-workflow run ./workflow.ts --input '<json>'`. Install is `bun install --global @deerwork-ai/deer-workflow`.
- **`workflow-creator` is a bundled Skill** whose triggers are *"turn a repeatable multi-step task into a Workflow"* / *"generate a deer-workflow script"*. It imposes real authoring rules: `meta.phases[].title` must match every `phase()` call exactly (case-sensitive); `phase()` must never be called inside concurrent branches; untrusted data may be interpolated into Agent prompts but never into shell commands.
- **Governance:** MIT, default branch `main`, created **2026-07-26**, last push **2026-08-09**, 467 stars, 45 forks, 6 open issues, not archived. The README positions the project as a pilot for DeerFlow 3.0.
- **No human-in-the-loop primitive** exists in the documented API — no approval, pause, or resume node. Every gate is a code branch or an agent decision.

### Not verified

- `src/` implementation, `tests/`, and the `examples/` workflows (Deep Research, Blog Writer) were not read. `[NEEDS VERIFICATION]`
- Retry, backoff, rate-limit handling, and concurrency caps for `parallel()` fan-out — absent from the docs, unknown in code. `[NEEDS VERIFICATION]`
- Whether `ClaudeAgent` can carry session context across nodes (e.g. `--resume`) or is strictly cold-start per call. The docs describe one prompt per call; cold start is assumed. `[NEEDS VERIFICATION]`
- Token cost per node under a realistic fan-out — unmeasured, and the reason a pilot could not be waived.
- `docs/*.zh-CN.md` unread; assumed to be translations of the English pages.

## Phase 0 pre-verification (`metodologia-insercao.md`)

| # | Check | Result |
|---|-------|--------|
| V1 | Already installed or evaluated? | No. Adjacent category **G6 distributed multi-agent** was **Discarded** (Vibe Kanban / Claude Squad, re-evaluate 2027-01). Different shape — code-first single-machine runner, not a task board — so this is not a reopening of G6 |
| V2 | Contact-surface matrix | **Free surface.** Touches no git hook, no PreToolUse hook, no MCP server, no CI workflow, no artifact template. It would occupy "headless batch runner", vacant today. The one occupied surface is **skills**: `workflow-creator` triggers on *"repeatable multi-step task"*, adjacent to `/opsx:*` phrasing |
| V3 | Artifact / name collision | Semantic, not nominal: `workflow.ts` + `meta.phases` vs `tasks.md` + OpenSpec phases — two program counters for one process |
| V4 | Repo profile | This repo is **DOCS_SPECS** (no app at root, no `npm test`). Introducing a Bun/TS runtime and executable `.ts` modules is a stack expansion here; the natural home would be APP/HYBRID |
| V5 | Hook stacking | N/A — no hooks |
| F1 | Security | `danger-full-access` sandbox is available to generated code; version pinning mandatory; the authoring skill correctly bans untrusted interpolation into shell commands |
| F2 | License | MIT ✅ |
| F3 | Living governance | **Fails in spirit.** 18 days old at evaluation date, self-declared pilot for DeerFlow 3.0. Active and maintained, but the API will churn |
| F4 | Reversibility | ✅ Trivial — a global CLI plus one `.ts` file; uninstall is deletion |
| F5 | Operability | ✅ `--print` JSONL, TUI, per-node logging, inspectable input |

Phase 2 (pilot) is **mandatory** and cannot use the 2026-07-25 waiver: adoption would install a new binary and consume LLM tokens.

## Workflow comparison — explore → propose → apply → archive

| SDD phase | Deer Workflow equivalent | Relation |
|---|---|---|
| **explore** → `research.md`, dedicated chat | None. No investigation primitive; a workflow starts from a decided graph | **Absent** |
| **propose** → `proposal.md` + `design.md` + `specs/` + `tasks.md`, human review before code (**R7**) | `meta.phases` declared in the module; the module *is* the plan | Write-before-build in form; **no human approval gate at all** |
| **apply** → execute `tasks.md`, tick `[x]`, resumable across sessions | `phase()` transitions inside one process; failed nodes become `null` | **Structurally incompatible** — no checkpoint, no resume, partial failure is silent by design |
| **archive** → merge deltas into `specs/`, move to `changes/archive/` | None. The event stream is the record | **Absent** |

Three differences carry the verdict:

1. **Durable vs volatile program counter.** `tasks.md` survives process death, a new chat, and a different day. A TypeScript call stack does not. The SDD pipeline's core affordance is *pausing for human review*; the runtime has no primitive for it.
2. **Gate placement.** R7 blocks before code exists. Deer Workflow has no gate — the agent inside each node decides, and the graph continues.
3. **Instruction locus.** The `/opsx:*` skills are 151–318-line interactive procedures using `AskUserQuestion`, ambiguity checks, and `openspec status --json` reads. Flattening them into `agent()` prompt strings both destroys the interactive gates and duplicates instruction in a second place — the drift anti-pattern already banned in `metodologia-insercao.md` (*"do not duplicate the skill in the guide"*).

## Fit with the SDD stack

| Tool | Relation |
|------|----------|
| OpenSpec | **Adversarial at the process layer, neutral at the object layer.** A `workflow.ts` as *produced code* in a consumer repo is a normal artifact governed by specs. A `workflow.ts` as *the pipeline* competes head-on with change→archive and has no counterpart to R7 or to the `[x]` progress record |
| GitNexus | **No overlap.** No code-graph, symbol, or impact capability; a workflow node would call GitNexus, not replace it |
| Graphify | **No overlap.** No concept graph, no knowledge extraction |
| AGENTS.md / sdd-kit | **Constitutional collision if adopted as pipeline; none if adopted as downstream target.** The A–E protocol (R1) and R7/R11 assume an interactive session with an identity; headless parallel runs have neither. `sdd-session-register/check/release` (R11) would need its own locking story for concurrent nodes |
| `sdd-session-handoff` | **Opposed.** The spec mandates a clean chat per phase, with the artifact as the handoff. A workflow that spans phases in one process is the mechanism the spec exists to prevent |
| `sdd-docs-language` / i18n waves | **The one convergence.** `parallel()` over slices + `pipeline()` through translate → glossary → `verify-i18n-wave.sh` is exactly the shape currently hand-glued in bash and a Cursor Automation |

## Risks by workflow phase

| Phase | Risk | Severity | Notes |
|-------|------|----------|-------|
| Explore | None — no investigation primitive to interfere with | — | |
| Propose | `meta.phases` becomes a second source of phases, competing with `tasks.md`; no precedence rule | **High** | Same rival-"done" failure recorded for LifeOS |
| Apply | No checkpoint: a failure at node *n* of *N* leaves a dirty tree with no resume; `null`-on-failure makes partial completion silent | **High** | The SDD apply loop is resumable by construction; this is a regression |
| Apply | R11 session coordination has no meaning for headless concurrent nodes | **Medium** | Would require a locking design of its own |
| Archive | No concept to map onto; archive stays a human decision | — | |
| Transversal | 18-day-old API, self-declared pilot — kit payload would carry migration debt | **Medium** | F3 |
| Transversal | Unbudgeted LLM cost: each node is a cold-start agent process, no shared context, no resume, so a failed long run repays in full | **Medium** | 0.3 of the methodology requires a budget before default enablement |

## Expected vs observed gains

| Advertised gain | Assessment |
|-----------------|------------|
| "Code is the plan" — control flow in reviewable TypeScript rather than an opaque agent conversation | **Real, and already held in weaker form.** The SDD stack keeps control flow in reviewable markdown (`tasks.md`, skills) with deterministic gates in bash (`verify-*.sh`). The delta is executability, not reviewability |
| Deterministic fan-out (`parallel`, `pipeline`) with partial-failure tolerance | **Real and not present in the stack.** This is the sole capability with no local equivalent, and the basis of the deferred i18n scope |
| Observable execution via JSONL event stream | **Real, low marginal value here.** A DOCS_SPECS repo has no long-running automation to observe |
| Replaceable agent runtimes (Codex / Claude / Pi) | True, and a genuine architectural virtue — but vendor neutrality is not a gap this repo has |
| Natural language → runnable workflow (`create`, `workflow-creator`) | **Unassessed as output quality.** As a *skill*, it adds a trigger surface adjacent to `/opsx:*` phrasing; would need description hygiene per `sdd-skill-guidance` |
| Embeddable via `WorkflowRunner` | Real; relevant only to APP repos, which is where the deferred downstream scope lives |

## Alternatives already in the stack

1. **Deterministic gates in bash** — `verify-task-patterns.sh`, `verify-i18n-wave.sh`, `verify-release-readiness.sh` already implement "control flow as reviewable code" with zero new dependency.
2. **CI orchestration** — `.github/workflows/sdd-gates.yml` (G1), fail-closed, for anything that must run out-of-band.
3. **Durable, resumable task state** — `tasks.md` plus `openspec status --json`.
4. **Phase discipline** — `sdd-session-handoff`: one chat per phase, artifact as handoff.
5. **Wave batching** — `doc/i18n/WAVES.md` budgets (≤350–400 LOC, ≤4 files, one apply session) already bound fan-out to preserve quality, not just context.

## Decision and re-evaluation conditions

**Decision: Discarded** for `sdd-kit` payload, `openspec/infra.md`, and any role in the normative explore→propose→apply→archive pipeline. Ad-hoc personal use outside the SDD phases is not forbidden, but is neither documented nor supported by the kit.

**Decision: Deferred**, two bounded scopes:

- **(a) i18n wave fan-out runner.** Reopen only on measurable failure of the current glue — **≥2 waves reworked due to orchestration error** (not translation quality). Pilot mandatory, with success criteria fixed before the run: wall-clock reduction per wave, zero increase in human review rounds, and `verify-i18n-wave.sh` remaining the sole gate. Note the honest ceiling: the wave budget exists because *quality* degrades with volume, so parallelism buys wall-clock, not human effort.
- **(b) Optional downstream module for APP/HYBRID repos** (C1-UI precedent): the kit teaches agents to author `workflow.ts` under SDD discipline — spec → design → `workflow.ts` as implementation, with `meta.phases` traceable to `tasks.md`. Reopen when a real APP repo in scope needs multi-agent orchestration.

**Cross-cutting condition for either scope:** an upstream **v1.0 with documented checkpoint/resume**. Without execution resumption the runtime can never fit a process whose central value is pausing for human review. Secondary conditions: ≥6 months of release history (F3), documented retry/concurrency limits, and a measured per-node token cost.

**Sunset note:** if adopted under scope (a) and unused for two cycles, the Phase 5 sunset criteria apply — removal change plus update of this document.

## Final positioning

```
ByeByeVibe      →  phase state on disk (tasks.md); human gate BEFORE code; resumable across sessions
Deer Workflow   →  phase state in a TS call stack; no gate; no resume; drop-and-continue on failure
                →  pipeline runtime discarded (two program counters, one process)
                →  fan-out runner deferred (i18n waves) — needs checkpoint/resume upstream
                →  downstream authoring module deferred (C1-UI precedent) — needs a real APP consumer
```

## References

- Repository: https://github.com/deerwork-ai/deer-workflow
- API reference: https://github.com/deerwork-ai/deer-workflow/blob/main/docs/api.md
- Getting started: https://github.com/deerwork-ai/deer-workflow/blob/main/docs/index.md
- `workflow-creator` skill: https://github.com/deerwork-ai/deer-workflow/blob/main/skills/workflow-creator/SKILL.md
- Constitutional-collision precedent: [`2026-08-11-lifeos.md`](./2026-08-11-lifeos.md)
- Orchestration-category precedent (G6): [`2026-07-25-oss-coverage-gaps-tooling.md`](./2026-07-25-oss-coverage-gaps-tooling.md)
- Optional-module precedent: [`2026-06-27-sdd-ui-development-module.md`](./2026-06-27-sdd-ui-development-module.md)
- Insertion methodology (Phase 0 checks, activation modes): [`metodologia-insercao.md`](../../openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md)
- Index: [README.md](./README.md)
