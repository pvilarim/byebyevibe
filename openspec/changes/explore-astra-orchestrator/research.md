# Research — Astra as orchestrator commanding ByeByeVibe

| Field | Value |
|-------|-------|
| **Date** | 2026-09-05 |
| **Change** | `explore-astra-orchestrator` (type E — exploration) |
| **Issue** | — (no duplicate open issue; adjacent: [#349](https://github.com/pvilarim/byebyevibe/issues/349) multi-agent PR review; draft [PR #383](https://github.com/pvilarim/byebyevibe/pull/383) Pi harness) |
| **Objective** | Register the uploaded Astra orchestration plan as a **possibility of implementation**, map it onto the existing control plane, and judge whether it can happen with today's Cursor models — without waiting for GPT-6 / Astra public launch |
| **Decision (this explore)** | **Possibility, not commitment.** Fit is high as *protocol + tools*. Fit is low as *new runtime / single-session phase machine*. Current models are already sufficient to run the loop **one phase at a time**. GPT-6 is not a blocker. Research-only folder (no `proposal.md`) so `openspec validate --all --strict` matches other Type E explores. |
| **Sources** | Uploaded plan (operator); `openspec/project.md`; `openspec/infra.md`; `openspec/specs/`; `AGENTS.md`; guide `doc/byebyevibe-guide.md` §3–§4; `doc/avaliacoes/` (Deer, LifeOS, TencentDB, Graft, G6); `doc/i18n/CURSOR-AUTOMATIONS.md`; this session's Graphify/GitNexus/GitHub probes |

## Executive verdict

ByeByeVibe **already is** the control plane the Astra plan describes. An "orchestrator commanding ByeByeVibe" is realistic **today** if Astra (or Composer / Grok / Claude / GPT-5.x / Gemini already in Cursor) plays **tech lead inside one SDD phase**, writes durable artifacts, and stops at Session Handoff.

It is **not** realistic — and is constitutionally forbidden — if the same process becomes a code-first runtime that spans `explore → propose → apply → archive` in one chat or one volatile state machine.

Waiting for GPT-6 / Astra general availability is **not required** for the protocol. A stronger future model may improve long-horizon apply quality; it does not invent the missing architecture. The missing pieces, if any, are scaffolding and policy — not intelligence.

```
  USER GOAL
      │
      ▼
 ┌─────────────┐     already exists          must NOT build
 │ Orchestrator│     ─────────────────       ─────────────────
 │ (any strong │     /opsx:* skills          mini-LangChain
 │  Cursor     │     artifacts as memory     workflow.ts as SoT
 │  model)     │     Graphify + GitNexus     implicit LLM memory
 └──────┬──────┘     R11 locks + gates       one chat = all phases
        │            A–E classification
        ▼
 ┌──────────────────────────────────────┐
 │           BYEBYEVIBE                 │
 │     control plane / protocol         │
 └──────────────┬───────────────────────┘
        ┌───────┼────────┐
        ▼       ▼        ▼
    GRAPHIFY  OPENSPEC  GITNEXUS
        │       │        │
        └───────┼────────┘
                ▼
         EXECUTOR (same or
         another agent, one
         phase, scoped tasks)
```

---

## 1. What the Astra plan asks for

Source: operator upload `BYEBYEVIBE_ASTRA_ORCHESTRATION_PLAN` (architecture-future / adaptation plan). Not a repo artifact until this change.

**North star:** user states a high-level goal ("implement X"); a principal agent runs a disciplined loop:

```
UNDERSTAND → EXPLORE → PROPOSE → PLAN → APPLY → VALIDATE → REVIEW → ARCHIVE
```

**Role split (plan, §1 / §3 / §7):**

| Role | Plan's assignment | Must not become |
|------|-------------------|-----------------|
| Astra | Brain: classify, explore, propose, supervise, authorize archive | The product / a second framework |
| ByeByeVibe | Protocol, policies, gates, persistent memory | A competing orchestrator or mini-LangChain |
| OpenSpec | Change artifacts as source of truth | Chat history |
| Graphify | "What is related?" — map → directed read | A substitute for reading code |
| GitNexus | "What will break?" — impact before/after edit | A substitute for tests |
| Codex / executor | File edits, commands, tests, authorized archive ops | Unilateral architecture or "done" |

**Extra machinery the plan invents (beyond today's loop):**

- Explicit `ChangeState` enum + guarded transitions (plan §8–§9)
- YAML/TS `autonomy` + `PolicyEngine` (plan §10, §21)
- Human-in-the-loop levels 0–4 (plan §22)
- Structured events (`CHANGE_CREATED`, `TASK_COMPLETED`, …) (plan §20.5)
- Vendor-neutral contracts: `Orchestrator`, `Executor`, `ContextProvider`, `ImpactAnalyzer`, `Validator` (plan §20.3 / Phase 2)
- VALIDATE as a named phase (today this is implicit: local gates + `sdd-gates` + on-demand reviews)

**Plan's own guardrails (aligned with this repo):** one principal brain + deterministic process + specialized tools + controlled executor; no random multi-agent chatter; Graphify orients, does not replace reading; archive only with evidence; gradual autonomy.

---

## 2. What already exists (AS-IS map)

The plan rediscovers the stack. Mapping is almost 1:1.

| Plan concept | Existing capability | Anchor |
|--------------|---------------------|--------|
| EXPLORE | `/opsx:explore` → `research.md` | `openspec-explore` skill; guide §3.1 Type E; spec `sdd-session-handoff` |
| PROPOSE | `/opsx:propose` → proposal / design / specs / tasks | `openspec-propose`; R7 |
| APPLY | `/opsx:apply` executes `tasks.md` | `openspec-apply-change`; R11 |
| VALIDATE | CI `sdd-gates` + local verify scripts + on-demand `correctness-review` / `simplify-review` / `security-reviewer` | spec `sdd-ci-gates`; guide §2.12 / §2.14; AGENTS.md reviews table |
| ARCHIVE | `/opsx:archive` promotes specs | `openspec-archive-change` |
| Complexity routing | Task types A–E | `AGENTS.md` protocol; guide §3.1–§3.2 |
| Persistent memory | Artifacts on disk, not chat | spec `sdd-session-handoff` ("OpenSpec artifacts are session memory"); project.md non-goal vs TencentDB |
| Session locks / worktrees | `scripts/sdd-session-*.sh` | spec `sdd-session-coordination`; guide §3.3; R11 |
| One chat = one phase | Always-on rule + handoff | spec `sdd-session-handoff`; `.cursor/rules/015-session-phases.mdc` |
| Graphify / GitNexus | Declared stack, skills, R2/R10 | `openspec/project.md`; `openspec/infra.md`; GitNexus skills under `.claude/skills/gitnexus/` |
| Thin orchestration | `/opsx:help` is explicitly thin | `openspec-help` skill; README "without a second orchestration framework" |
| Fan-out already practiced | Cursor Automations + Cloud Agents, one phase per run | `doc/i18n/CURSOR-AUTOMATIONS.md` §1 |
| Consumer-app orchestrator (unrelated) | Guide example tree `orchestrator.service.ts` | guide §11.3 — **APP bot pattern**, not hub control plane |

`openspec list --json` (pinned `@fission-ai/openspec@1.3.1`) on 2026-09-05: **no** existing `explore-astra*` change. Active explores are install/onboarding/OSS-gaps/tooling — different questions. Creating `explore-astra-orchestrator` does not duplicate them.

### What the plan names that is only implicit today

| Plan item | Today | Gap type |
|-----------|-------|----------|
| Named VALIDATE phase | Gates + reviews, no `/opsx:validate` | Naming / checklist, not missing enforcement |
| `ChangeState` machine | Phase = skill + artifacts + `openspec` status; apply counter = `tasks.md` checkboxes | Durable, reviewable — **intentionally not a process** (`project.md` non-goal) |
| PolicyEngine API | Rules + specs + CI fail-closed + human archive | Policy is markdown + bash, not a TS interface |
| Structured executor report JSON | Agent prose + git diff + gate logs | Convention gap (docs), not a runtime gap |
| Autonomy levels 0–4 | De facto L0–L1: agent explores/proposes; human opens next chat | Levels 2–4 would collide with handoff + R7 |
| Vendor-neutral Orchestrator interface | Any Cursor/Claude model that follows `/opsx:*` | Abstraction is premature (plan §18: do not multi-agent because we can) |

---

## 3. Lens A — Fit with ByeByeVibe as-is

### 3.1 Classification of "an orchestrator commanding ByeByeVibe"

Four implementation shapes. Only the first two fit the constitution.

| Shape | What it is | Fit | Why |
|-------|------------|-----|-----|
| **A. Protocol / meta-skill** | Instructions: "you are the orchestrator *for this phase*"; still `/opsx:*`, still handoff | **High** | Extends existing skills; no second program counter |
| **B. Cursor Cloud Agent / Automation pattern** | Operator (or Automation) launches one run per phase with a copy-paste stub | **Already shipping** | `CURSOR-AUTOMATIONS.md`; this explore session |
| **C. Docs / control-plane note** | Capture the role split in guide / day-1 / `AGENTS.md` pointer | **High** | F7 English artifacts; no runtime |
| **D. New orchestration runtime** | TS/YAML state machine, event bus, PolicyEngine code, headless explore→archive | **Forbidden as kit payload** | `openspec/project.md` Non-goals; Deer Workflow discard |

**Recommended reading of the plan:** treat Astra as **shape A+B** (a model sitting *on* the protocol), not shape D (ByeByeVibe becoming a harness).

The plan's §7 is the compatible sentence: *"ByeByeVibe must be a protocol, not a second orchestrator."* The plan's §8–§21 (executable state machine + policy engine + events) is the incompatible sentence if implemented as code that *owns* phase state.

### 3.2 Hard conflicts (do not paper over)

1. **One session = one phase** (`sdd-session-handoff`). Astra spanning EXPLORE→ARCHIVE in one thread is the exact transition the spec requires the agent to **refuse**. i18n automations restate: *"one chat / one Cloud Agent run = one phase."*
2. **R7 human gate before code.** Autonomy level 2+ ("Astra applies automatically") deletes the propose→apply handoff unless a human still opens `/opsx:apply` (or an Automation is explicitly a *new* apply run after review).
3. **R11 locks.** Parallel executors are already allowed — **only** on separate git worktrees. A single-tree multi-executor is the failure mode §3.3 exists to prevent.
4. **F7 language.** Orchestrator artifacts stay English; chat MAY be pt-BR. A future Astra skill must not author PT specs because the operator spoke Portuguese.
5. **DOCS_SPECS profile.** This hub has no app runtime, no `npm test`, Probity SKIP. A PolicyEngine / event store / Orchestrator interface has **no natural home** here. Consumer APP/HYBRID is where an executor + tests live.
6. **Human-in-the-loop is the product.** README and positioning: durable memory, gates, session discipline — *not* "prompt → full app." Archive-on-agent-assertion is already banned (Probity G2, CI fail-closed, archive skill evidence).

### 3.3 Adjacent discarded / deferred work (do not reopen casually)

| Prior decision | Relation to Astra plan | Status |
|----------------|------------------------|--------|
| Deer Workflow (`doc/avaliacoes/2026-08-13-deer-workflow.md`) | Code-first phase machine vs `tasks.md`; no human gate; no resume | **Discarded** as pipeline runtime; deferred only for i18n fan-out / APP `workflow.ts` authoring |
| LifeOS (`2026-08-11-lifeos.md`) | Second constitution; rival definition of "done" | **Discarded** as kit layer |
| TencentDB Agent Memory (`2026-08-07-…`) | Inferred cross-session memory vs reviewed artifacts | **Discarded** |
| NanoNets Graft (`2026-08-17-…`) | Third graph + always-on rules | **Discarded** as payload |
| G6 Vibe Kanban / Claude Squad (`explore-oss-coverage-gaps`) | Orchestration UI competing with `/opsx:*` | **Discarded**; re-eval ~2027-01 |
| `project.md` Non-goals | Explicitly: no code-first SDD orchestration runtime; no implicit agent memory; no second constitutional layer; no third graph | Normative |
| Pi harness (draft PR #383) | Another **host** (alternative to Cursor/Claude Code), not a smarter control plane | **Deferred** (not in this tree; do not duplicate) |
| Issue #349 | Automated **PR review** pipeline (LLM skills + one real static pass) | Open, **different job** — VALIDATE-adjacent, not phase orchestrator |

Insertion methodology (`explore-oss-coverage-gaps/metodologia-insercao.md`) V1: already evaluated runtimes that compete for the phase machine. A new Astra *runtime* would fail V1/V2 unless scoped as protocol/docs.

---

## 4. Lens B — Graphify + GitNexus evidence

### 4.1 This environment (honest)

| Probe | Result | Consequence for an orchestrator |
|-------|--------|----------------------------------|
| `graphify-out/GRAPH_REPORT.md` | **Absent** (gitignored; not generated on this Cloud Agent VM) | Cannot cite live god nodes / communities from the graph |
| `graphify-out/wiki/index.md` | **Absent** | Same |
| `graphify` CLI | **Not on PATH** | `graphify query` could not run; R10 says do not install unprompted |
| `npx gitnexus status` | **"Repository not indexed"**; `gitnexus list` empty | No MCP `gitnexus_impact` / clusters this session |
| GitNexus MCP | **Not in GetDynamicTools** | Fell back to CLI + skill docs (R10 cascade) |

So the **AS-IS retrieval story the plan depends on is not guaranteed** on a cold Cloud Agent. That is a **scaffolding / environment** failure, not a model-IQ failure. An Astra-class model sitting in the same pod would hit the same wall.

`[NEEDS VERIFICATION]` typical god-node / community list on a developer machine with a fresh `graphify update .` + `npx gitnexus analyze`. Proxy communities below are inferred from specs, guide §4, and directory layout — **not** from GRAPH_REPORT.

### 4.2 Proxy "communities" (docs/specs, not the graph)

If Graphify were present, the plan's questions ("what is related to orchestration / agents / sessions?") would almost certainly land on these clusters — they are the normative neighborhoods:

```
  sdd-session-handoff ─── 015-session-phases ─── /opsx:* skills
           │                        │
           ▼                        ▼
  sdd-session-coordination ── R11 ── sdd-session-*.sh ── kit templates
           │
           ▼
  sdd-ci-gates ── sdd-gates.yml ── verify-*.sh
           │
           ▼
  avaliacoes (Deer, LifeOS, TencentDB, Graft, G6)
           │
           ▼
  project.md Non-goals ── README "no second orchestration framework"
```

Guide §4 already assigns the exact questions the plan wants:

| Question | Tool |
|----------|------|
| What should we change, and is it agreed? | OpenSpec |
| What symbols / callers break? | GitNexus |
| What concepts / past decisions apply? | Graphify |

### 4.3 Blast radius IF this were later implemented

**Docs-only / protocol spike (recommended possibility):**

| Surface | Risk |
|---------|------|
| `openspec/changes/explore-astra-orchestrator/` | This change only |
| Later: `doc/avaliacoes/YYYY-MM-DD-astra-orchestrator.md` + README index row | Low — same pattern as Deer/LifeOS |
| Later: pointer in guide §3.4 or day-1 | Medium — kit `guide_version` / checksum if the guide is in MANIFEST templates |

**If someone implemented plan §8–§21 as code (not recommended):**

| Surface | Depth | Why |
|---------|-------|-----|
| `sdd-session-handoff` spec + `015-session-phases.mdc` + four `/opsx:*` skills + Claude mirrors + **sdd-kit templates of all of the above** | d=1 WILL BREAK | Second program counter vs artifacts |
| `sdd-session-coordination` + `scripts/sdd-session-*.sh` + kit copies | d=1 | Headless multi-node apply vs flock-per-worktree |
| `openspec/project.md` Non-goals | d=1 | Would need an explicit constitution change |
| `sdd-ci-gates` / `sdd-gates.yml` | d=2 | VALIDATE duplication or bypass |
| `AGENTS.md` R1–R11 + kit `AGENTS.core.md` | d=1 | Instruction locus drift (Deer already named this anti-pattern) |
| Consumer APP repos after C1 | d=2–3 | Payload ships a harness they did not ask for |

GitNexus impact on **symbols** was not available this session. File-level blast radius above is from specs + kit layout + Deer evaluation. `[NEEDS VERIFICATION]` after `npx gitnexus analyze --force` on a machine with an index.

### 4.4 Existing symbols / docs that already approximate an orchestrator

- `/opsx:explore|propose|apply|archive|help` skills — interactive procedures (Deer: 151–318 lines; flattening them into `agent()` prompts was a discard reason)
- `tasks.md` — apply program counter
- Session Handoff block — cross-session program counter
- `sdd-session-status.sh` — presence, not a workflow engine
- `correctness-review` — post-apply VALIDATE judgment
- Cursor Automations playbook — **outer** orchestrator is the operator + Automation, **inner** agent stays one-phase
- Guide §11.3 `orchestrator.service.ts` — **do not confuse** with the hub; that is a sample APP module

---

## 5. Lens C — Model readiness without GPT-6

Split four failure modes. Do **not** claim GPT-6 / Astra product capabilities. Web search (2026-09-05) returns pages that *describe* "GPT-6 Astra" as an OpenAI agent-native model; those pages are **not** AGENTS.md sources 1–6. Treat product name, API id, GA date, and scores as `[NEEDS VERIFICATION]`. The operator's own plan already says: *do not assume speculated capabilities before official docs.*

### 5.1 Model reasoning quality

**Today (observable in this session + repo practice):** a current Cursor Cloud Agent (this run: Cursor Grok 4.6) can classify Type E, refuse apply, read skills/specs/evaluations, synthesize a role matrix, and write English artifacts. The same class of work is already done by other models in this hub (Deer/LifeOS/Graft explores; i18n wave agents).

**What still fails for capability reasons (honest):**

- Spec-vs-implementation review that is not a rubber stamp (issue #349 exists *because* LLM review is easy to skip or to flatter)
- A–E auto-classification from a vague prompt (guide §3.2: **ask**, do not infer)
- Resisting silent scope expansion during a long apply
- Holding a large `tasks.md` graph in working memory without the artifact

A stronger model may shrink these. **None of them require waiting** to start using the protocol.

### 5.2 Tool-use reliability

**Today:** models follow `/opsx:*` and R10 **when the tools are installed**. This session: unpinned `npx openspec` failed; pinned `@fission-ai/openspec@1.3.1` worked; Graphify CLI missing; GitNexus unindexed; GitHub MCP `search_issues` needed the current repo slug (`pvilarim/byebyevibe`, not the legacy `gitnexus-graphify-openspec`).

**Failure class:** environment + cascade discipline, not "we need GPT-6 to call Graphify." A future Astra in the same VM would also need `graphify` on PATH and a GitNexus index. That is kit/preflight work (`verify-infra.sh`, `preflight-sdd.sh`), already specified.

### 5.3 Long-horizon orchestration

This is the only dimension where a future agent-native model *might* matter — and it is also the dimension the constitution **caps on purpose**.

| Horizon | Current models | Process cap |
|---------|----------------|-------------|
| One phase, one change, artifact-backed | **Good enough** (this repo's daily practice) | Encouraged |
| Many independent proposes (disjoint files) | Good enough via parallel Cloud Agents | Automations playbook |
| One process, many phases, hours/days, no handoff | Tempting for marketing; **forbidden** here | `sdd-session-handoff` |
| Many dependent apply tasks, one worktree | Fragile (drift, dirty tree, R11) | Sequential apply or worktrees |

If GPT-6 / Astra later proves long-horizon coherence, the **correct** integration is still: better quality *inside* apply or *inside* explore — not deleting handoffs. LifeOS already considered "one run until token budget"; this repo chose phase boundaries instead.

### 5.4 Product / process constraints (not model)

These do not yield to a smarter model:

- Durable vs volatile program counter (`tasks.md` vs `workflow.ts`)
- Human gate before code (R7)
- Fresh chat per phase
- English artifacts (F7)
- No second constitution / no third graph / no inferred memory
- DOCS_SPECS has no executor test loop

**Conclusion:** today's Cursor models (Composer, Grok, Claude, GPT-5.x family, Gemini — exact catalog `[NEEDS VERIFICATION]`) can run the Astra *role* **now**, as the agent that reads the protocol. What "fails today" is mostly (4) process and (2) missing graphs on cold VMs. Waiting for GPT-6 to "make orchestration possible" mistakes a governance design for a benchmark.

---

## 6. Possibility, not commitment

### 6.1 Can this realistically happen given OpenSpec / GitNexus / Graphify?

**Yes, as a role + protocol.** The three tools plus `/opsx:*` already implement the plan's architecture diagram. An orchestrator is "whoever is in the chair for this phase."

**No, as a new hub runtime.** That path is pre-lost against `project.md` Non-goals and the Deer/LifeOS/G6 record.

**Partially, as VALIDATE naming + executor report convention.** Cheap, compatible, and useful even if Astra never ships.

### 6.2 Can this be done today without GPT-6?

**Yes — one phase at a time, with a human or Automation as the outer scheduler.** Evidence: this explore; i18n Cloud Agent factory; archived Type E evaluations.

**No — fully autonomous explore→archive on a goal like "add DXF export" without human gates.** Not because the model is too weak; because the repo forbids it.

### 6.3 Is a later `/opsx:propose` warranted?

**Warranted only as a narrow spike**, not as "implement Astra." This explore does **not** ship `proposal.md` (OpenSpec spec-driven schema would then require spec deltas and fail `sdd-gates`; other Type E folders are research-only). A later propose session writes its own `proposal.md`. Candidate scopes (pick one later):

| Spike | Type | What | What it is not |
|-------|------|------|----------------|
| **S1 — Evaluation note** | A/C docs | Promote this research into `doc/avaliacoes/YYYY-MM-DD-astra-orchestrator.md` + index row (Deer template) | No skill, no runtime |
| **S2 — Protocol pointer** | C | Short guide / day-1 / `AGENTS.md` Integrations note: "principal agent = orchestrator of *this* phase; executor may be another run" | No `/opsx:orchestrate` mega-skill |
| **S3 — VALIDATE checklist** | C | Explicit "run gates + optional reviews before archive handoff" already mostly in apply/archive skills — tighten wording only if a gap is shown | No new phase skill unless evidence |
| **S4 — Executor report convention** | C | Markdown/JSON stub the apply agent fills (files, tests, errors) — still in `tasks.md` / PR body | No event bus |

**Do not propose in a later apply:** TypeScript `ChangeState` machine, PolicyEngine package, LangChain-like router, autonomy L3 default, collapsing 015, third graph, inferred memory.

**Smallest next step:** S1 (evaluation index) so future agents do not re-open Deer/G6 under a new brand name. S2 only if Pedro wants operators to *name* the role.

### 6.4 Open forks (not a single path)

```
                    THIS RESEARCH
                          │
          ┌───────────────┼───────────────┐
          ▼               ▼               ▼
     Keep as           S1 evaluation    Wait for official
     explore-only      in avaliacoes    Astra docs, then
     (enough)          (index hygiene)  re-read §20.1
          │               │               │
          │               ▼               ▼
          │          optional S2      still shapes A/B
          │          protocol note    never shape D
          │
          └─── APP consumer later wants
               headless fan-out ──► Deer deferred
               scope (i18n / workflow.ts),
               NOT this hub
```

---

## 7. Unknowns

Mark anything not anchored to specs / archive / this repo's docs / this session's probes:

- Official product name, API, GA, pricing, Cursor availability of "Astra" / GPT-6 — `[NEEDS VERIFICATION]` (web only; plan §20.1 / §28 Phase 0 still applies)
- Whether Cursor will expose an Astra-class model as the Cloud Agent default — `[NEEDS VERIFICATION]`
- Live Graphify god nodes / GitNexus clusters on a built index — `[NEEDS VERIFICATION]` (absent this VM)
- Token cost of a full C/D change with Graphify+GitNexus on every hop — `[NEEDS VERIFICATION]` (unmeasured; Deer also left this open)
- Whether issue #349's automated review should be the VALIDATE spike instead of a new orchestrator change — product choice
- Pi harness (PR #383) vs Cursor as host: orthogonal; Astra-the-model could sit in either host — `[NEEDS VERIFICATION]` on Pi's current `/opsx` coverage

---

## 8. Sources (R8)

1. Operator plan: *ByeByeVibe — Preparação para Orquestração Autônoma por um Modelo Astra* (upload, 2026-09-05)
2. `openspec/project.md` — stack, DOCS_SPECS, Non-goals (Deer / LifeOS / TencentDB / Graft)
3. `openspec/infra.md` — OpenSpec 1.3.1, GitNexus 1.6.9, Graphify 0.9.31, skills, session scripts, kit 1.10.0
4. Specs: `sdd-session-handoff`, `sdd-session-coordination`, `sdd-ci-gates`, `sdd-docs-language` (F7), `sdd-task-patterns`
5. `AGENTS.md` R1–R11, A–E, Integrations (GitNexus, Graphify, github-mcp, gates, Probity, metrics)
6. `doc/byebyevibe-guide.md` §3.1–§3.4, §4, §11.3; `README.md` (no second orchestration framework)
7. Evaluations: `doc/avaliacoes/2026-08-13-deer-workflow.md`, `2026-08-11-lifeos.md`, `2026-08-07-tencentdb-agent-memory.md`, `2026-08-17-nanonets-graft.md`, `2026-07-25-oss-coverage-gaps-tooling.md`; research `openspec/changes/explore-oss-coverage-gaps/`
8. `doc/i18n/CURSOR-AUTOMATIONS.md` §1 (one Cloud Agent run = one phase)
9. GitHub (read-only): open issues #364, #363, #349; draft PR #383 (Pi harness). No open issue titled Astra/orchestrator.
10. This session: `npx --yes @fission-ai/openspec@1.3.1 list --json`; Graphify/GitNexus probes (absent); GitNexus exploring/impact skills (read, not executed against an index)

Web (last resort, not used as capability claims): search hits describing "GPT-6 Astra" — `[NEEDS VERIFICATION]`.
