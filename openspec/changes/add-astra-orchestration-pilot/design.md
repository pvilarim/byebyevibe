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

### D2 — Fix an initial host hypothesis, defer deployment inputs to registration

Local Codex with Astra and existing CLI/MCP tools is the initial candidate. The registration must record actual host/version, model identifiers/settings, repository and base commit, consumer change/proposal approval, tool availability/index coverage, acceptance commands, and authorization evidence. If the host cannot launch separate phase runs, the operator launches them from bounded handoffs and that effort is measured. Do not describe this fallback as autonomous launch support.

The numeric spend/credit ceiling and unit, elapsed-time limit, retry limit, and quality/productivity targets must be chosen before running, not invented by the executor. Missing required fields mean NOT READY. Missing token telemetry permits functional testing only when an enforceable alternative budget exists; economic conclusions remain unavailable if costs cannot be established. Host substitution creates a new configuration, not an unrecorded deviation.

Alternative: block proposal on choosing an APP now. Rejected: a reusable protocol can be fully specified before configuring its first run. Consumer selection remains a hard trial-admission gate.

### D3 — Use a functional stage, then isolate variables

Stage F: three fronts A (shared report/export contract), B (dependent UI), C (independent reproducible bug). An equivalent consumer demand is allowed if dependency and independence properties are preserved. At most two active workers and one writer per worktree; no uncontrolled nested fan-out. Test stale index, interrupted worker and changed contract on disposable trial branches with pre-recorded expected recovery.

Stage T: compare A operator-coordinated sequential, B Astra-directed sequential, C Astra-directed parallel. Hold scope, base, acceptance rubric, worker models/settings, tools and reviewer protocol constant. Coordinator differences are the treatment in A versus B; concurrency is the treatment in B versus C. Record operator scheduling overhead rather than hiding it.

Stage M: only after topology selection, compare fixed worker allocation with mixed-model routing. Three trials per configuration are exploratory screening; vary arm order, reset equivalent initial state, prevent cross-arm solution leakage, and record caches/environment differences. Extend sampling when results are unstable; do not claim statistical significance from three trials.

Alternative: all-Astra sequential versus cheap-model parallel only. Rejected because model and concurrency effects would be confounded.

### D4 — Keep hypotheses falsifiable

The protocol must carry the research H1–H7 matrix: decomposition, parallelism, knowledge usefulness, artifact recovery, routing economics, operator effort, and reconstructible state. Independent acceptance rubrics must allow valid alternative decompositions. H3 uses source/decision traces and independent usefulness assessment; it is observational and does not establish causality. Mandatory knowledge consultations are not disabled to construct a baseline.

Every hypothesis records metric, expected evidence, pre-registered criterion, observed result, limitation and roadmap consequence. Report unsupported/inconclusive as well as supported/refuted outcomes. The illustrative 20% time target is not a default promise; record the chosen target before collecting data.

### D5 — Preserve phase and integration authority

Each phase executes in a fresh run reading durable artifacts. Astra supervision means scoped phase decisions and handoffs; it does not create a long-lived cross-phase constitutional exception. The operator/host carries the scheduling boundary, preserving approvals tied to artifact revisions. Changed scope/contracts require reassessment of the affected approval before dependent execution.

Use existing local apply register/check/release scripts, distinct worktrees, dependency-ready contracts, integration tests on the combined revision, and ordered promotion of overlapping specs. A receipt records an attempt, never overrides a spec or grants permission. Archive/merge/release are distinct observations. Local presence JSON is not sufficient durable history or proof of the agent's process identity.

### D6 — Specify evidence rather than implement instrumentation

Registration sections: experiment identity, repository/base, host/models, demand/rubric, dependency map, arm schedule, tools/snapshots, limits/approval, and admission checklist.

Run template sections: experiment/run/parent/attempt IDs, change/phase/status, host/model/settings, worktree/base/artifact revisions, timestamps, dependency/approval references, knowledge queries and coverage, executed checks and tested revision, findings and repair evidence, injection/recovery, operator interventions, usage and units, outcome/deviation. Mark unavailable values explicitly; no invented sample successes. Secrets and unnecessary raw prompts are excluded.

Decision template sections: H1–H7 evidence table, all admitted trials including failures, exclusions with reasons, quality gates, total cost per accepted outcome, time/operator effort, variance/limitations, and chosen follow-up. Use provider usage with documented coverage; avoid double-counting reasoning/output or nested usage. Include coordinator, workers, review, retries, integration and tools. Without comparable billing data, the economic conclusion is inconclusive.

Finding lifecycle references existing issue/PR/change evidence: report, reproduction, cause, fix, regression verification, integrated revision, release status. Changelog is only a delivered-fix summary. `sdd-metrics.sh` remains a historical proxy and is not relabeled as trial telemetry.

### D7 — Make stop conditions and next decisions explicit

Stop the affected trial on scope/approval violation, conflicting concurrent writes, unmet dependency execution, duplicate effects, lost recovery state, false completion, breached registered budget/time/retry limit, or inability to validate integration. Preserve evidence and classify failure versus infrastructure/inconclusive outcome; do not discard failed runs to improve averages. Recovery must not force-release a genuinely active writer.

Quality gates precede efficiency comparison. Potential outcomes: no adoption, sequential coordination, selective parallelism, recovery work first, mixed-model routing, or instrumentation before dashboard. A failed trial can still be valuable research. No passing report is written before execution.

### D8 — Knowledge triggers and snapshot accounting

Protocol documents queries at architecture/impact decisions, `impact` before symbol mutation, `detect_changes` before commit, and freshness checks after edits/rebase/merge. Record worktree, revision and relevant dirty content/coverage; empty degraded results are not negative evidence. Graphify AST refresh is distinct from document-semantic ingestion, whose configuration/cost must be verified. Do not rebuild per keystroke or treat idle time as a semantic trigger.

### D9 — Validate documents with structural checks and scenario review

Task gates check file existence, required headings/hypotheses, index links and OpenSpec conformance. They do not certify experimental validity. Apply must additionally create `readiness-review.md` in this change, mapping every spec requirement to published sections and dry-reading normal/missing-budget/stale-index/interruption/changed-contract/missing-telemetry cases. This is a desk review with expected outcomes, not fake trial evidence. Resolve mismatches before marking documentation tasks complete.

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
