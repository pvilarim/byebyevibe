# sdd-astra-phase-run-contract Specification

## Purpose
TBD - created by archiving change add-astra-phase-run-contract. Update Purpose after archive.
## Requirements
### Requirement: Astra coordinates authorized phase runs without replacing OpenSpec
The hub MUST define Astra as a coordinator that may map demand, evaluate readiness, queue work and launch bounded phase runs only within referenced authorization. OpenSpec specifications and reviewed change artifacts MUST remain the authority for requirements and phase memory. Approval, merge, archive and release authority MUST NOT be inferred from coordinator state, a run receipt or a projected status. Each coordinated run MUST execute exactly one OpenSpec phase in a separate session. The standard `/opsx` workflow MUST remain fully usable without Astra or the contract templates.

#### Scenario: Astra admits an authorized apply
- **WHEN** a reviewed change, valid approval reference, satisfied dependencies and free owned worktree establish apply readiness
- **THEN** Astra may launch one bounded apply session whose receipt cites those sources without becoming the specification or approval authority

#### Scenario: User does not enable Astra
- **WHEN** a user continues with the standard ByeByeVibe workflow
- **THEN** explore, propose, apply and archive remain available without Astra records, a coordinator runtime or a dashboard

### Requirement: Demand maps carry explicit nodes and dependency edges
A demand map MUST identify its contract version, demand ID and revision, repository/base, coordinator, evidence root, change nodes, goals, owners, affected capabilities/paths, acceptance references and unresolved decisions. Every dependency edge MUST identify source and target nodes, edge type, required evidence, current state, decision owner and revision. Contract, artifact/approval, implementation, integration and spec-promotion dependencies MUST be distinguishable. Readiness MUST derive from satisfied evidence and compatible revisions, not worker availability, PR order or file disjointness. Cycles, unresolved edges and competing ownership of shared contracts or overlapping spec promotion MUST block affected admissions.

#### Scenario: Dependent work has an unavailable contract
- **WHEN** a phase-run node depends on a contract whose required revision and approval evidence are not available
- **THEN** the node remains blocked while independent authorized nodes may proceed

#### Scenario: Paths are disjoint but assumptions conflict
- **WHEN** two candidate runs write different files but share an unresolved API, migration, manifest or promoted-spec decision
- **THEN** the map records an ordering or designated-owner edge instead of admitting them as independent

### Requirement: Admission freezes a revision-bound phase-run packet
Before launch, the coordinator MUST record an immutable packet containing logical run and idempotency identities, repository/worktree, base revision and relevant dirty-content fingerprints, change ID, phase, artifact revisions, bounded scope, dependency evidence, approval references, ownership, knowledge-tool expectations, acceptance/gates, host/model facts and applicable limits. An approval reference MUST identify approver, authorized action/scope and covered artifact revision. A new attempt MUST retain still-valid approval and MUST require reassessment when scope, contract, base assumptions or covered artifact revision changes materially. Missing or ambiguous authorization MUST block the affected action.

#### Scenario: New attempt uses unchanged approval
- **WHEN** an interrupted run restarts with unchanged authorized scope and covered artifact revision
- **THEN** the new attempt may cite the existing approval instead of requesting approval solely because the session changed

#### Scenario: Reviewed contract changes before launch
- **WHEN** a material contract or artifact revision no longer matches the recorded approval or dependency evidence
- **THEN** admission stops until the affected evidence is reassessed and authorization is valid for the new revision

### Requirement: Writer ownership remains explicit and locally enforced
Every writing attempt MUST name one writer, worktree, session ID and paths scope. Apply attempts MUST use the existing local registration, check and release protocol, and parallel writers MUST use separate worktrees. Durable receipts MUST record observed ownership and lock events but MUST NOT replace, override or force-release a live lock. Read-only runs MAY share an identified snapshot; concurrent writes to the same artifact MUST be prohibited. Heartbeat age alone MUST NOT prove that ownership or side effects have ended.

#### Scenario: Another writer owns the worktree
- **WHEN** admission detects an active apply owner for the target worktree
- **THEN** the candidate run remains queued or blocked and does not write or force-release the owner

#### Scenario: Presence is stale but effects are unknown
- **WHEN** heartbeat evidence is stale and the writer or its side effects cannot be established
- **THEN** replacement writes remain blocked until ownership and effects are reconciled

### Requirement: Knowledge evidence exposes identity freshness and coverage
For each consulted knowledge tool, the run MUST record repository/worktree, base and relevant dirty fingerprints, index or configuration version, corpus coverage, freshness state, query or refresh action, limitations and the decision supported. Freshness states MUST distinguish healthy, stale, unavailable and unknown. Rebase, merge, checkout, new worktree, relevant dirty changes, changed index configuration and incomplete refresh MUST invalidate affected cached evidence. Graphify code-AST refresh MUST NOT imply Markdown semantic ingestion; GitNexus impact evidence MUST identify the actual snapshot. Shared index writers MUST be serialized and only completed snapshots treated as current.

Existing task-classification and tooling-guidance rules MUST determine required consultations and authorized fallback; this contract MUST NOT make Graphify, GitNexus or a specific host a new unconditional dependency. Stale, unavailable or degraded empty results MUST NOT prove absence of dependencies.

#### Scenario: GitNexus query is empty on a degraded index
- **WHEN** the index identity is stale or search coverage is degraded and a query returns no result
- **THEN** the receipt records the limitation and the dependent impact claim waits for an authorized refresh or source-based fallback

#### Scenario: Standard Type A edit uses no coordinator knowledge record
- **WHEN** a user performs a standard non-Astra Type A edit for which existing rules require no graph consultation
- **THEN** this contract introduces no Graphify or GitNexus prerequisite

### Requirement: Restart and duplicate triggers preserve attempt history
A logical run MUST retain a stable `run_id`, and every execution MUST create a unique immutable `attempt_id` linked to its predecessor when applicable. On interruption, the coordinator MUST stop affected admissions, preserve existing artifacts and receipts, establish writer ownership and side effects, release locks only through verified ownership, and reassess base, contracts, approvals, dependencies and affected checks before replacement writes. Duplicate triggers MUST resolve through an idempotency key to the same logical work item and MUST NOT silently create duplicate apply, merge or release effects. Unknown or disputed ownership or effects MUST block replacement writes.

#### Scenario: Interrupted executor is safely replaced
- **WHEN** the prior attempt is durably recorded, no active writer or duplicate effect remains, and revision-bound admission evidence is valid
- **THEN** a new linked attempt may resume from artifacts and rerun every invalidated check

#### Scenario: Same launch request arrives twice
- **WHEN** two triggers carry the same idempotency key for a writing phase
- **THEN** they resolve to one logical run and cannot create concurrent duplicate effects

### Requirement: Durable receipts form a non-authoritative projection contract
The hub MUST publish a versioned, consumer-copyable demand-map template and phase-run receipt template using constrained YAML front matter plus human-reviewable Markdown evidence. The consumer-owned evidence root and hub contract revision MUST be recorded. A receipt MUST include run, parent and attempt identities; phase separately from operational status; change, host/model and worktree/base/artifact revisions; scope; dependency and approval references; ownership; knowledge evidence; timestamps; checks and tested revision; findings, recovery and interventions; usage with coverage; outcome; and evidence links. Previous attempts MUST remain available, corrections MUST identify superseded records, and unavailable, unknown or disputed data MUST be explicit.

The projection MUST distinguish proposed, approved, applied, integrated, archived and released evidence and MUST NOT turn task completion, transient session presence or a receipt into authority. The contract MUST be sufficient for a later read-only control panel, but this change MUST NOT implement dashboard or state-changing controls.

#### Scenario: Dashboard later reads a failed attempt
- **WHEN** a later read-only projector consumes a valid receipt for a failed apply attempt
- **THEN** it can show apply as the phase and failed as the status while retaining approval, evidence, costs and retry lineage without marking the change complete

#### Scenario: Usage telemetry is unavailable
- **WHEN** the host exposes no comparable usage measurement
- **THEN** the receipt records unknown usage and its coverage limitation instead of estimating a value

### Requirement: Contract adoption is optional and release-neutral
The guide MUST present the phase-run contract as an optional Astra layer over the standard workflow. Contract publication MUST NOT enable Astra, change install or routine upgrade behavior, migrate legacy consumers, select production routing, execute a pilot, publish a dashboard, cut a release or create a tag. Later pilot, control-panel, adoption and release changes MUST consume this contract through separate review.

#### Scenario: Contract artifacts are published in the hub
- **WHEN** this documentation change is applied and validated
- **THEN** the hub is ready for a separately authorized pilot while all enablement, dashboard, migration and release actions remain unperformed

