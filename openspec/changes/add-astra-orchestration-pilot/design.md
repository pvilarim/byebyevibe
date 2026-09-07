## Context

The consolidated research at `openspec/changes/evaluate-astra-orchestration-readiness/research.md` identifies viable phase-local coordination and unresolved economics, recovery and observability. The operator authorized recording the experiment and preparing this proposal. This hub is DOCS_SPECS; consumer code and trial execution belong in the selected APP repository.

Current sources: `openspec/project.md`; specs `sdd-session-handoff`, `sdd-session-coordination`, `sdd-issue-traceability`, `sdd-metrics`; `doc/i18n/CURSOR-AUTOMATIONS.md` sections 1–3. Graphify/GitNexus were consulted during exploration but freshness/FTS limitations preclude claiming a current graph-derived blast radius. The change edits documentation only.

## Goals / Non-Goals

**Goals:** prepare an executable-by-operator experimental procedure, registration/evidence/report templates, falsifiable hypotheses, and decision criteria that guide a later release roadmap.

**Non-Goals:** run the experiment in this hub; build a scheduler, dashboard, telemetry service, API adapter or router; change phase authority; choose a production model default; promise savings; ship new kit payload; amend or merge remote Astra drafts.

## Decisions

### D1 — Publish a hub-only experiment package

Deliver `doc/experiments/astra-orchestration-pilot.md`, `doc/experiments/README.md`, and templates `astra-pilot-registration.md`, `astra-pilot-run.md`, `astra-pilot-decision.md` under `doc/experiments/templates/`. Use relative links within the package and to the existing research. No guide/template parity or manifest change is needed because this package is not kit-distributed.

Alternative: build the platform first. Rejected because that commits to architecture before measuring whether coordination, parallelism or model routing solves the observed bottleneck. The companion dashboard remains a potential follow-up.

Consumer handoff instructions must name a consumer-owned evidence directory under its approved change, explain which templates to copy, and replace hub-relative references with revision-pinned hub links. Check links both in the hub layout and in a representative copied consumer layout; update active-change references when their sources are archived. No kit install is implied by copying an experiment template.

### D2 — Fix an initial host hypothesis, defer deployment inputs to registration

Local Codex with Astra and existing CLI/MCP tools is the initial candidate. The registration must record actual host/version, model identifiers/settings, repository and base commit, consumer change/proposal approval, tool availability/index coverage, acceptance commands, and authorization evidence. If the host cannot launch separate phase runs, the operator launches them from bounded handoffs and that effort is measured. Do not describe this fallback as autonomous launch support.

The numeric spend/credit ceiling and unit, elapsed-time limit, retry limit, and quality/productivity targets must be chosen before running, not invented by the executor. Missing required fields mean NOT READY. Missing token telemetry permits functional testing only when an enforceable alternative budget exists; economic conclusions remain unavailable if costs cannot be established. Host substitution creates a new configuration, not an unrecorded deviation.

Alternative: block proposal on choosing an APP now. Rejected: a reusable protocol can be fully specified before configuring its first run. Consumer selection remains a hard trial-admission gate.

Admission must verify actual model access and settings, separate phase sessions, Bash/script execution and worktree-lock behavior on the chosen OS, required tools, and the source and enforcement mechanism for budgets. Record the person or host control responsible for stopping work at each limit. If neither usage nor an enforceable alternative cost/credit ceiling is available, remain NOT READY. Cursor, an API adapter and GitHub write access are not implicit prerequisites; record each external capability actually needed and use authorized local evidence when sufficient. Model capability alone does not supply scheduling, tools, persistence or approval.

### D3 — Use a functional stage, then isolate variables

Stage F: three fronts A (shared report/export contract), B (dependent UI), C (independent reproducible bug). An equivalent consumer demand is allowed if dependency and independence properties are preserved. At most two active workers and one writer per worktree; no uncontrolled nested fan-out. Test stale index, interrupted worker and changed contract on disposable trial branches with pre-recorded expected recovery.

Stage T: compare A operator-coordinated sequential, B Astra-directed sequential, C Astra-directed parallel. Hold scope, base, acceptance rubric, worker models/settings, tools and reviewer protocol constant. Coordinator differences are the treatment in A versus B; concurrency is the treatment in B versus C. Record operator scheduling overhead rather than hiding it.

Stage M: only after topology selection, compare fixed worker allocation with mixed-model routing. Three trials per configuration are exploratory screening; vary arm order, reset equivalent initial state, prevent cross-arm solution leakage, and record caches/environment differences. Extend sampling when results are unstable; do not claim statistical significance from three trials.

Stage F must pass before admitting T or M for that configuration. For each injection, pre-record the injected event, expected containment/recovery, oracle, recovery deadline and failure condition. The injected interruption or stale index is not itself a failed recovery; unauthorized dependent work, unresolved ownership, duplicate effects or failure to meet the recovery oracle is. A material repair creates a new configuration and requires repeating affected functional cases before comparisons; preserve failed attempts and their costs. Pre-register the sample-extension trigger, maximum trial count and stopping rule; inconclusive results at the limit remain inconclusive. Freeze the fixed and mixed routing policies, including escalation rules, before M.

Alternative: all-Astra sequential versus cheap-model parallel only. Rejected because model and concurrency effects would be confounded.

### D4 — Keep hypotheses falsifiable

The protocol must carry the research H1–H7 matrix: decomposition, parallelism, knowledge usefulness, artifact recovery, routing economics, operator effort, and reconstructible state. Independent acceptance rubrics must allow valid alternative decompositions. H3 uses source/decision traces and independent usefulness assessment; it is observational and does not establish causality. Mandatory knowledge consultations are not disabled to construct a baseline.

Every hypothesis records metric, expected evidence, pre-registered criterion, observed result, limitation and roadmap consequence. Report unsupported/inconclusive as well as supported/refuted outcomes. The illustrative 20% time target is not a default promise; record the chosen target before collecting data.

H1 must receive only the demand and applicable source constraints, not the evaluator's expected decomposition or dependency map. Store the reference rubric separately from worker/coordinator context; record its revision before assessment and capture Astra's first decomposition before revealing it. The A/B/C split in D3 is an evaluator fixture, not the H1 answer prompt. Score acceptance coverage, missed dependencies and invalid splits, allowing valid alternatives. If the reference has leaked, H1 is inconclusive and needs a fresh equivalent fixture; retain the contaminated attempt. The reviewed execution dependency map is finalized after this bounded assessment and before any dependent implementation. H1 itself still requires an approved consumer assessment scope and budget.

H3 tests observed usefulness, not causal improvement: an independent reviewer scores whether a trace supplied a relevant source, changed or confirmed a named decision, or was unusable, under a pre-recorded rubric. H6 records preparation, scheduling, supervision, approval and corrective minutes separately and compares total operator effort over the same boundary. H7 uses a pre-recorded state vocabulary and evaluator-held evidence oracle to score reconstructed phase/status, approval, tested revision and integration state; missing evidence means unknown, contradictory evidence means disputed, never inferred success. The reconstruction and any later dashboard are projections, not competing authority. H2/H5 require pre-registered quality tolerance as well as time/cost targets.

### D5 — Preserve phase and integration authority

Each phase executes in a fresh run reading durable artifacts. Astra supervision means scoped phase decisions and handoffs; it does not create a long-lived cross-phase constitutional exception. The operator/host carries the scheduling boundary, preserving approvals tied to artifact revisions. Changed scope/contracts require reassessment of the affected approval before dependent execution.

Use existing local apply register/check/release scripts, distinct worktrees, dependency-ready contracts, integration tests on the combined revision, and ordered promotion of overlapping specs. A receipt records an attempt, never overrides a spec or grants permission. Archive/merge/release are distinct observations. Local presence JSON is not sufficient durable history or proof of the agent's process identity.

Fresh run means a separate phase chat/session with the existing Session Handoff, not a new run ID inside a cross-phase conversation. Approval evidence identifies the approver, authorized action/scope and artifact revision; absence or ambiguity blocks affected work. Preserve valid authorization across attempts without asking again solely because the session changed. Contract/base changes invalidate affected dependency decisions and verification receipts until reassessed and retested.

### D6 — Specify evidence rather than implement instrumentation

Registration sections: experiment identity, repository/base, host/models, demand/rubric, dependency map, arm schedule, tools/snapshots, limits/approval, and admission checklist.

Run template sections: experiment/run/parent/attempt IDs, change/phase/status, host/model/settings, worktree/base/artifact revisions, timestamps, dependency/approval references, knowledge queries and coverage, executed checks and tested revision, findings and repair evidence, injection/recovery, operator interventions, usage and units, outcome/deviation. Mark unavailable values explicitly; no invented sample successes. Secrets and unnecessary raw prompts are excluded.

Decision template sections: H1–H7 evidence table, all admitted trials including failures, exclusions with reasons, quality gates, total cost per accepted outcome, time/operator effort, variance/limitations, and chosen follow-up. Use provider usage with documented coverage; avoid double-counting reasoning/output or nested usage. Include coordinator, workers, review, retries, integration and tools. Without comparable billing data, the economic conclusion is inconclusive.

Finding lifecycle references existing issue/PR/change evidence: report, reproduction, cause, fix, regression verification, integrated revision, release status. Changelog is only a delivered-fix summary. `sdd-metrics.sh` remains a historical proxy and is not relabeled as trial telemetry.

Use one accepted integrated demand as the fixed outcome unit, never individual tasks or arbitrarily split changes. Per configuration, cost per accepted outcome is total comparable measured cost of all eligible attempts (including failures, recovery and retries) divided by accepted integrated demands. With zero accepted demands the ratio is undefined; report spend and failure count. Missing cost coverage makes the economic conclusion inconclusive. Pre-register eligibility/exclusion rules; retain every admitted run and show excluded costs separately with reasons. Record functional/setup costs separately from comparison costs, plus the full pilot total, so a repair or configuration reset cannot erase expenditure. Pre-register clock start/end, treatment of queue/approval waits, quality acceptance and observation window. Report end-to-end elapsed time including waits and separately report active execution time; do not silently stop the clock for difficult runs.

### D7 — Make stop conditions and next decisions explicit

Stop the affected trial on scope/approval violation, conflicting concurrent writes, unmet dependency execution, duplicate effects, lost recovery state, false completion, breached registered budget/time/retry limit, or inability to validate integration. Preserve evidence and classify failure versus infrastructure/inconclusive outcome; do not discard failed runs to improve averages. Recovery must not force-release a genuinely active writer.

Quality gates precede efficiency comparison. Potential outcomes: no adoption, sequential coordination, selective parallelism, recovery work first, mixed-model routing, or instrumentation before dashboard. A failed trial can still be valuable research. No passing report is written before execution. After execution, the decision report MUST include a post-pilot proposal review that explains how a definitive orchestration/adoption proposal should change based on observed results, defects, costs, operator interventions, capability gaps, and standard-workflow compatibility evidence. It must identify unresolved evidence and recommend proceeding, further experiments or deferral before any definitive adoption proposal.

That review must preserve the standard ByeByeVibe workflow for users who decline Astra. Any future enablement is explicit opt-in, reversible without removing OpenSpec artifacts/gates, and separate from routine framework upgrades. Older releases must never be silently converted through C2: a later proposal must define source-version detection, supported versions, repair, framework upgrade if needed, a separate enablement step, dry-run diff and rollback evidence. The pilot gathers requirements and compatibility evidence only; installer changes, migration implementation, dashboard and production routing require separately reviewed scopes. A dashboard must remain a read-only evidence projection until a separate controls proposal is approved.

The protocol must provide this fallback matrix with detection evidence, decision owner, affected work, retained evidence and resumption criteria:

| Condition | Required response and resumption |
|---|---|
| Astra/host access unavailable before or during a run | Before admission remain NOT READY; during execution stop new affected admissions, preserve attempts and establish worker ownership before recovery. Operator may resume the same verified configuration or register/revalidate a replacement configuration; never silently substitute a model. Standard workflow remains usable outside the trial. |
| Unknown ownership or uncertain side effects after interruption | Block replacement writes until the operator establishes ownership and reconciles effects from source evidence; never force-release an active writer or retry speculatively. |
| Git conflict, semantic incompatibility, or overlapping spec promotion | Designated integration owner stops affected integration, preserves both revisions and resolves in dependency order. Scope/contract changes require approval reassessment; re-run affected checks on the combined revision and serialize spec promotion. Independent authorized work may continue. |
| Shared contract changes | Block dependent work, invalidate affected approval/verification evidence, reassess the reviewed contract and resume only on an available approved base with fresh checks. |
| Bug discovered | Record reproduction first. Repair within approved scope under R6 with a failing test then regression evidence; changed contract requires artifact reassessment/handoff; unrelated defects require separately scoped work. Classify safety/correctness failures before continuing comparisons. External issue/PR writes require authorization. |
| Missing or ambiguous approval | Block affected actions, record the missing approver/scope/revision and obtain an explicit decision; silence, a receipt or a dashboard status cannot authorize execution. |
| Missing usage | Record unknown and coverage; functional testing only with an enforceable alternative budget and named limit owner. No comparable costs means no economic conclusion. |

### D8 — Knowledge triggers and snapshot accounting

Protocol documents queries at architecture/impact decisions, `impact` before symbol mutation, `detect_changes` before commit, and freshness checks after edits/rebase/merge. Record worktree, revision and relevant dirty content/coverage; empty degraded results are not negative evidence. Graphify AST refresh is distinct from document-semantic ingestion, whose configuration/cost must be verified. Do not rebuild per keystroke or treat idle time as a semantic trigger.

Use the existing tooling cascade (session override → configured CLI → configured MCP → capped offer → manual instructions), honoring declined integrations and prohibiting unrequested installation. For healthy indexes, query the relevant snapshot and verify cited sources. For stale indexes, use an authorized refresh that preserves corpus coverage, then query again. For absent/broken retrieval, record the limitation and use the existing authorized equivalent codebase-read path (`sdd-task-patterns`) where applicable: inspect changed symbols, callers/contracts and affected tests on the actual revision, recording paths and uncovered scope. This is not a blanket waiver of mandatory D/E consultations or change detection; attempt required consultations, document failures, and block dependent mutations/commits if required evidence cannot be established under existing rules. Unknown blast radius is not zero blast radius.

Registration distinguishes an ordinary degraded environment from a declared fault injection. Injection authorization specifies its bounded scope and oracle; it does not authorize implementation before impact is established. Record index identity, dirty-content fingerprints and coverage; serialize writes to a shared index directory. Consult on architectural uncertainty and before relevant mutations; refresh after coherent changes when downstream decisions need current evidence. Reuse results only for an unchanged relevant snapshot. No unconditional graph investigation for type A or repeated rebuild after each keystroke; accepted Markdown needs verified document ingestion, not an AST-only green indicator.

Additional normative sources for these decisions: `openspec/specs/sdd-tooling-guidance/spec.md` (resolution and refusals), `openspec/specs/sdd-task-patterns/spec.md` (equivalent codebase read and task gates), `openspec/specs/sdd-install-kit/spec.md` (C2 approval and preservation), `openspec/specs/sdd-install-narrative/spec.md` (consumer scope and optional add-ons), and `openspec/specs/sdd-ci-gates/spec.md` (structural checks do not establish tool availability).

### D9 — Validate documents with structural checks and scenario review

Task gates check file existence, required headings/hypotheses, index links and OpenSpec conformance. They do not certify experimental validity. Apply must additionally create `readiness-review.md` in this change, mapping every spec requirement to published sections and dry-reading normal/missing-budget/stale-index/interruption/changed-contract/missing-telemetry cases. This is a desk review with expected outcomes, not fake trial evidence. Resolve mismatches before marking documentation tasks complete.

Also walk through leaked H1 reference, failed F attempting T admission, zero accepted outcomes with failed-attempt costs, missing/ambiguous approval, unavailable Astra before/during execution, absent knowledge tools, unknown ownership, integration conflict, out-of-scope bug and copied-consumer links. Each case must identify detection, decision owner, affected work, preserved evidence, expected result and resumption criteria. Check post-pilot opt-in/legacy protections and unknown/disputed H7 states explicitly. The reviewer records artifact revisions and unresolved gaps; any unresolved normative mismatch prevents package readiness even when structural commands pass.

## Risks / Trade-offs

- [Protocol mistaken for operational platform] → explicit preparation/execution/outcome states and separate consumer handoff.
- [Manual scheduling biases benefit] → measure operator launch time and document host limitations in all arms.
- [Tiny sample or model/environment drift] → report per-run values and variability, pin configurations, extend comparisons when needed.
- [Session metadata lost or misleading] → persist bounded evidence receipts; do not use deleted presence/PID as historical authority.
- [Research references drift at archive] → update links when moving research; index/readiness review includes link checks. Remote drafts are not prerequisites.
- [Safety constraints prevent an arm] → report not executed/inconclusive, never relax current policy silently.

## Migration Plan

Apply writes the documentation package and reviews its coverage; archive promotes the new additive spec. No installed consumer changes occur. A later consumer proposal configures and authorizes the experiment. Rollback removes only the new package/index entry and reverts the additive spec via normal change control if already archived.

## Open Questions

Required before trials, not before documentation apply: consumer repository/base and representative demand; actual host/model access and phase-launch mechanism; numeric limits and quality/productivity thresholds; independent reviewer; usage source/coverage. A persistent autonomous supervisor and interactive dashboard require separate proposals if trial evidence warrants them.
