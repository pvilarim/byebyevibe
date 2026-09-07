## ADDED Requirements

### Requirement: Hub experiment package

The hub MUST provide a pilot protocol at `doc/experiments/astra-orchestration-pilot.md`, an experiment index, and registration, run-evidence and decision-report Markdown templates. The package MUST distinguish protocol readiness, authorized execution and measured outcome. It MUST NOT claim that publishing documentation implements orchestration or proves model superiority.

#### Scenario: Operator discovers the pilot
- **WHEN** the operator opens `doc/experiments/README.md`
- **THEN** it links the protocol and its three templates and identifies separate APP execution prerequisites

### Requirement: Trial admission is explicit

The registration template MUST require repository/base revision, reviewed consumer change, host/models/settings, tool/index availability, task/rubric, dependency map, reviewer, authorization references, and numeric cost-or-credit, time, concurrency and retry limits before trial admission. Missing required inputs MUST produce NOT READY. Initial concurrency MUST be at most two workers with one writer per worktree.

Registration MUST distinguish authorized H1 assessment from implementation admission: the evaluator reference map remains reserved during H1, and the reviewed execution dependency map MUST be available before dependent implementation. It MUST record verified model access, necessary shell/scripts and lock behavior, actual external capabilities, budget enforcement mechanism and limit owner. No enforceable cost/credit ceiling means NOT READY even for functional testing. Missing or ambiguous approval MUST block affected actions; approval evidence MUST identify approver, action/scope and covered artifact revision. Valid approval MUST NOT be discarded solely because a new attempt/session starts.

#### Scenario: Budget has not been selected
- **WHEN** an operator completes registration without a numeric budget and unit
- **THEN** the protocol marks the experiment NOT READY and permits no trial execution

### Requirement: Comparable staged hypotheses

The protocol MUST define H1–H7 for decomposition, parallelism, knowledge usefulness, recovery, routing, human effort and observable state. It MUST compare operator-sequential, Astra-sequential and Astra-parallel configurations with equivalent tasks, bases, worker models and acceptance rules, and evaluate mixed-model routing separately afterward. It MUST describe three trials per configuration as exploratory screening, record order/configuration deviations and avoid treating observational graph traces as causal proof.

Each hypothesis MUST have a pre-registered metric, evidence oracle, acceptance criterion and inconclusive outcome. H1 MUST reserve the evaluator's reference decomposition/map and record the initial candidate decomposition before disclosure, scoring coverage, omitted dependencies and invalid splits while accepting justified alternatives. H3 MUST score observed usefulness independently without causal claims. H6 MUST compare total operator minutes and separately record preparation, scheduling, supervision, approval and corrections. H7 MUST compare reconstructed states against a pre-recorded vocabulary and independent evidence oracle, representing absent evidence as unknown and contradictory evidence as disputed. H2/H5 MUST require registered quality tolerances. Sampling extensions, maximum count, stopping rules, clock boundaries and routing/escalation policies MUST be fixed before the relevant comparison.

#### Scenario: H1 reference is disclosed early
- **WHEN** the evaluated coordinator receives the reference decomposition before its initial answer is recorded
- **THEN** H1 is inconclusive, the contaminated attempt remains recorded, and a new assessment requires a fresh equivalent fixture

#### Scenario: Parallel configuration appears faster
- **WHEN** worker models or acceptance scope also changed between sequential and parallel trials
- **THEN** the report identifies the confound and does not attribute the difference solely to parallelism

### Requirement: Existing phase and worktree boundaries

The protocol MUST retain one phase per run, artifact-backed handoffs, approval references, local apply registration/check/release, isolated writer worktrees, dependency admission and validation of the integrated revision. Overlapping spec promotions MUST be ordered. Supervisory decisions MUST NOT create a permanent cross-phase session exemption.

A phase run MUST be a separate chat/session following the existing Session Handoff, not merely a new ID in a cross-phase conversation. Changed contracts/bases MUST invalidate affected dependency and verification evidence pending reassessment and fresh checks. Receipts and projected status MUST NOT override OpenSpec or grant approval.

#### Scenario: Dependent apply is scheduled early
- **WHEN** the prerequisite contract is unavailable or its approval no longer covers its revision
- **THEN** the dependent apply waits for reassessment and an available approved base while independent authorized work can continue

### Requirement: Knowledge evidence has identity and coverage

The protocol MUST distinguish queries from rebuilds, record repository/worktree/revision and index coverage, require impact before symbol changes and change detection before commit, and distinguish Graphify code-AST refresh from document ingestion. Degraded or stale results MUST NOT be treated as proof of no dependencies.

It MUST define healthy, stale, unavailable and deliberately injected failure paths, following `sdd-tooling-guidance` without unrequested installation or overriding declined integrations. Authorized equivalent codebase reads under `sdd-task-patterns` MUST identify changed symbols, callers/contracts, tests and uncovered scope on the actual revision. This MUST NOT waive mandatory consultations or change detection: failures and limitations remain recorded, and affected mutations/commits MUST wait when required evidence cannot be established. Fault injection MUST NOT authorize work with unknown impact. The trigger matrix MUST distinguish architecture/impact queries, coherent-batch refresh, snapshot invalidation and type A cases without unconditional graph investigation; shared index writers MUST be serialized.

#### Scenario: Knowledge query returns no results on a stale index
- **WHEN** freshness or search capability is degraded
- **THEN** the run records the limitation and uses the authorized refresh/fallback path before making a dependent impact claim

### Requirement: Functional fault trials and stopping rules

The protocol MUST include stale-index, interrupted-worker and changed-contract trials with pre-recorded expected outcomes. It MUST stop affected work on authority, dependency, concurrent-write, duplicate-effect, recovery or false-completion failures, registered limit exhaustion, or inability to validate integration. Outcomes and infrastructure failures MUST remain visible in the report.

Each injection MUST specify stimulus, expected recovery, oracle, deadline and failure condition. Stage F MUST pass for the registered configuration before T; M MUST require passed functional gates, valid topology comparison quality gates and recorded topology selection. Material repairs MUST create a new configuration and repeat affected functional cases without deleting failed attempts or their costs.

#### Scenario: Functional recovery fails
- **WHEN** an injected interruption occurs and the expected ownership/recovery checks fail
- **THEN** the trial records a recovery failure and T/M admission remains blocked until the repaired configuration passes the affected functional gates

### Requirement: Fallback decisions are operationally explicit

The protocol MUST provide detection evidence, decision owner, affected work, retained evidence and resumption criteria for model/host unavailability, missing knowledge tools, missing usage, uncertain ownership/effects, Git or semantic integration conflicts, overlapping spec promotion, changed contracts, bugs and missing/ambiguous approval. Unknown ownership or side effects MUST block replacement writes. Mid-run model/host substitutions MUST create recorded configurations requiring revalidation. Integration owners MUST reconcile revisions and rerun affected combined-revision checks. Bugs within approved scope MUST follow R6; contract changes require reassessment/handoff and unrelated bugs require separate scope. External issue/PR writes MUST require authorization. The standard workflow MUST remain available outside the trial.

#### Scenario: Astra becomes unavailable during execution
- **WHEN** the registered host loses access to Astra
- **THEN** new affected admissions stop, attempts and ownership evidence are preserved, and the operator resumes a verified configuration or registers and revalidates a replacement without silent model substitution

#### Scenario: Executor is interrupted
- **WHEN** a trial starts a replacement attempt
- **THEN** it records a new attempt linked to the original, recovers from artifacts and evidence, verifies ownership, and checks that effects were not duplicated

### Requirement: Source-backed run and finding records

The run template MUST capture run/parent/attempt IDs, phase separately from status, change/model/host, worktree/base/artifact revisions, timestamps, dependencies/approval, knowledge evidence, executed checks/tested revision, findings/fixes, recovery, interventions, usage units/coverage and outcome. Missing telemetry MUST be explicit; transient session presence MUST NOT substitute for durable history. Findings MUST link reproduction, repair and verification without equating branch fixes with released fixes.

#### Scenario: Host does not report tokens
- **WHEN** a run has only credits or no comparable usage measurement
- **THEN** the record states the available unit and limitation instead of estimating tokens from prose, and economic claims without sufficient evidence remain inconclusive

### Requirement: Decision report includes failures and complete costs

The report template MUST summarize all admitted runs and explained exclusions, H1–H7 outcomes, quality gates, operator approval versus corrective effort, elapsed time, variability, limitations and total measured cost including coordination, workers, reviews, retries, integration and tools. It MUST permit no adoption, sequential coordination, selective parallelism, recovery, routing or instrumentation follow-ups. Efficiency alone MUST NOT compensate for failed correctness or authorization gates.

The outcome unit MUST be one accepted integrated demand. Per-configuration cost per accepted outcome MUST divide comparable costs of all eligible attempts, including failures/retries/recovery, by accepted integrated demands. Zero accepted demands MUST produce an undefined ratio with spend/failures shown. Missing comparable cost coverage MUST make economic conclusions inconclusive. Eligibility/exclusions MUST be pre-registered; excluded costs, setup/functional costs, comparison costs and full pilot totals MUST remain visible. End-to-end time MUST include waits, with active execution reported separately; configuration resets MUST NOT erase effort or cost.

#### Scenario: Every eligible attempt fails
- **WHEN** a configuration incurs costs but produces zero accepted integrated demands
- **THEN** the report includes failed-attempt costs and reports the cost-per-accepted-outcome ratio as undefined, not zero or a success-only average

### Requirement: Post-pilot review preserves optional adoption boundaries

The decision template MUST require a post-pilot proposal review using run evidence, defects, costs, operator interventions, capability gaps and standard-workflow compatibility observations. It MUST state required changes to a definitive proposal, unresolved evidence and proceed/further-experiment/defer disposition. It MUST preserve the standard workflow for users declining Astra, require explicit reversible opt-in for later adoption, and prohibit silent migration of older releases through routine C2 upgrades. Approval of a framework upgrade MUST NOT imply approval to enable Astra. Version detection, supported sources, repair, separate upgrade/enablement, dry-run and rollback evidence MUST be identified as requirements for a later migration proposal, not implemented by this pilot. Dashboard, optional installation, migration and production routing MUST remain separately reviewed scopes. Any dashboard MUST project evidence rather than become an authority.

#### Scenario: Pilot suggests optional adoption
- **WHEN** results justify preparing a definitive adoption proposal
- **THEN** the report supplies evidence-backed improvements and preserves explicit opt-in and legacy protections without authorizing installer, dashboard or routing changes

### Requirement: Consumer copies preserve evidence provenance

The package MUST explain template copying, the approved consumer-owned evidence location and revision-pinned hub references. Copied records MUST NOT depend on hub-relative links or require copying hub development history. The readiness review MUST check hub and representative consumer-copy links, including research archive relocation.

#### Scenario: Template is copied into an APP consumer
- **WHEN** the operator follows the consumer handoff
- **THEN** evidence belongs to the consumer change and hub references resolve at an identified revision without requiring hub specs or research in that consumer

#### Scenario: Faster configuration violates scope
- **WHEN** a configuration improves time but performs an unauthorized action
- **THEN** it fails the quality gate and is not recommended for adoption on speed alone

### Requirement: Documentation readiness is reviewed without fake trials

The documentation apply MUST record requirement-to-section coverage and expected outcomes for normal admission, missing budget, stale index, interruption, changed contract and missing telemetry. This review MUST be labeled a desk review and MUST NOT report experimental measurements. Actual code/trials MUST be scoped in a separate consumer change.

The review MUST also cover leaked H1 references, failed F blocking T, zero accepted outcomes, absent/ambiguous approval, Astra unavailable before/during execution, absent knowledge tools, unknown ownership, integration conflicts, out-of-scope bugs, copied-consumer links, H7 unknown/disputed states and post-pilot opt-in/legacy protections. Each walkthrough MUST record detection, decision owner, affected work, preserved evidence, expected result and resumption criteria. Reviewed artifact revisions and unresolved gaps MUST be recorded; unresolved normative mismatches MUST block readiness regardless of structural gate success.

#### Scenario: Protocol package is complete
- **WHEN** document checks and desk review pass
- **THEN** the hub change can be completed as protocol preparation while experimental results remain not measured
