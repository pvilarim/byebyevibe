## ADDED Requirements

### Requirement: Hub experiment package

The hub MUST provide a pilot protocol at `doc/experiments/astra-orchestration-pilot.md`, an experiment index, and registration, run-evidence and decision-report Markdown templates. The package MUST distinguish protocol readiness, authorized execution and measured outcome. It MUST NOT claim that publishing documentation implements orchestration or proves model superiority.

#### Scenario: Operator discovers the pilot
- **WHEN** the operator opens `doc/experiments/README.md`
- **THEN** it links the protocol and its three templates and identifies separate APP execution prerequisites

### Requirement: Trial admission is explicit

The registration template MUST require repository/base revision, reviewed consumer change, host/models/settings, tool/index availability, task/rubric, dependency map, reviewer, authorization references, and numeric cost-or-credit, time, concurrency and retry limits before trial admission. Missing required inputs MUST produce NOT READY. Initial concurrency MUST be at most two workers with one writer per worktree.

#### Scenario: Budget has not been selected
- **WHEN** an operator completes registration without a numeric budget and unit
- **THEN** the protocol marks the experiment NOT READY and permits no trial execution

### Requirement: Comparable staged hypotheses

The protocol MUST define H1–H7 for decomposition, parallelism, knowledge usefulness, recovery, routing, human effort and observable state. It MUST compare operator-sequential, Astra-sequential and Astra-parallel configurations with equivalent tasks, bases, worker models and acceptance rules, and evaluate mixed-model routing separately afterward. It MUST describe three trials per configuration as exploratory screening, record order/configuration deviations and avoid treating observational graph traces as causal proof.

#### Scenario: Parallel configuration appears faster
- **WHEN** worker models or acceptance scope also changed between sequential and parallel trials
- **THEN** the report identifies the confound and does not attribute the difference solely to parallelism

### Requirement: Existing phase and worktree boundaries

The protocol MUST retain one phase per run, artifact-backed handoffs, approval references, local apply registration/check/release, isolated writer worktrees, dependency admission and validation of the integrated revision. Overlapping spec promotions MUST be ordered. Supervisory decisions MUST NOT create a permanent cross-phase session exemption.

#### Scenario: Dependent apply is scheduled early
- **WHEN** the prerequisite contract is unavailable or its approval no longer covers its revision
- **THEN** the dependent apply waits for reassessment and an available approved base while independent authorized work can continue

### Requirement: Knowledge evidence has identity and coverage

The protocol MUST distinguish queries from rebuilds, record repository/worktree/revision and index coverage, require impact before symbol changes and change detection before commit, and distinguish Graphify code-AST refresh from document ingestion. Degraded or stale results MUST NOT be treated as proof of no dependencies.

#### Scenario: Knowledge query returns no results on a stale index
- **WHEN** freshness or search capability is degraded
- **THEN** the run records the limitation and uses the authorized refresh/fallback path before making a dependent impact claim

### Requirement: Functional fault trials and stopping rules

The protocol MUST include stale-index, interrupted-worker and changed-contract trials with pre-recorded expected outcomes. It MUST stop affected work on authority, dependency, concurrent-write, duplicate-effect, recovery or false-completion failures, registered limit exhaustion, or inability to validate integration. Outcomes and infrastructure failures MUST remain visible in the report.

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

#### Scenario: Faster configuration violates scope
- **WHEN** a configuration improves time but performs an unauthorized action
- **THEN** it fails the quality gate and is not recommended for adoption on speed alone

### Requirement: Documentation readiness is reviewed without fake trials

The documentation apply MUST record requirement-to-section coverage and expected outcomes for normal admission, missing budget, stale index, interruption, changed contract and missing telemetry. This review MUST be labeled a desk review and MUST NOT report experimental measurements. Actual code/trials MUST be scoped in a separate consumer change.

#### Scenario: Protocol package is complete
- **WHEN** document checks and desk review pass
- **THEN** the hub change can be completed as protocol preparation while experimental results remain not measured
