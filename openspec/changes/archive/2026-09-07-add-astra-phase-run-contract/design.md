## Context

The archived Astra pilot capability defines admission and evidence expectations, while the registered release track names a bounded phase-run contract as the next step before pilot execution and control-panel work. Today, OpenSpec change artifacts carry reviewed requirements and phase memory; handoff requires a separate session per phase; apply ownership is enforced by ephemeral, per-worktree locks and presence files. Those mechanisms do not yet define a demand-level dependency map, coordinator admission packet, restart identity, or durable operational receipt.

The initial host hypothesis is **local Codex with Astra coordinating separate phase sessions**. Access, launch mechanics, and exposed usage remain registration-time facts rather than promised platform features. The contract is host-adapter-neutral so a later pilot can reject or replace that hypothesis without changing authority semantics.

Knowledge sources consulted:

- `openspec/changes/evaluate-astra-orchestration-readiness/research.md`, especially “Parallel streams,” “Knowledge tools,” “Dashboard,” and “Registered release track.”
- `openspec/specs/sdd-astra-orchestration-pilot/spec.md` for admission, phase boundaries, knowledge evidence, recovery, and source-backed records.
- `openspec/specs/sdd-product-validation/spec.md` for revision-bound evidence and separation of product and orchestration outcomes.
- `openspec/specs/sdd-session-handoff/spec.md` and `openspec/specs/sdd-session-coordination/spec.md` for phase/session and worktree ownership authority.
- `openspec/project.md` for the prohibition on a volatile code-first runtime owning pipeline state.
- `graphify-out/GRAPH_REPORT.md` and GitNexus were consulted as required navigation aids. Both were stale at proposal time; GitNexus also reported missing FTS indexes, so direct source reads supplied the normative evidence.

## Goals / Non-Goals

**Goals:**

- Establish one versioned contract for demand maps, dependency edges, phase-run admission, approval references, ownership, knowledge freshness, restarts, and durable receipts.
- Make coordinator decisions deterministic enough to review: every admission or block cites source evidence and revision identity.
- Preserve OpenSpec artifacts and explicit approvals as authority while allowing Astra to launch already-authorized bounded phase runs.
- Give the later pilot and read-only control panel a stable, human-reviewable and machine-projectable record shape.
- Preserve the standard non-Astra `/opsx` workflow without requiring new tools or migration.

**Non-Goals:**

- Implementing a scheduler, host adapter, long-lived runtime, dashboard, control API, model router, distributed lock service, installer, enablement, migration, or release.
- Executing the Astra pilot or claiming model quality, savings, availability, or production readiness.
- Replacing OpenSpec, Git/GitHub evidence, product-validation records, or existing session scripts.
- Granting a coordinator a cross-phase chat exemption or permission to infer approval.

## Decisions

### D1. The coordinator proposes and admits runs; OpenSpec remains authoritative

Astra may create a demand map, evaluate readiness, queue work, and launch a phase adapter only when the referenced scope is already authorized. The map and receipts are operational evidence, not requirement, approval, merge, archive, or release authority. Each run still executes exactly one OpenSpec phase in a separate session.

Alternative: let a long-lived Astra runtime own phase state and approvals. Rejected because it conflicts with current project non-goals and makes restart safety depend on volatile process state.

### D2. Use two stable identities: logical run and immutable attempt

A logical `run_id` identifies one change/phase assignment. Every execution has a unique `attempt_id`; retries reference a `parent_attempt_id` and never overwrite prior evidence. A duplicate launch key resolves to the existing logical run and requires effect/ownership inspection before another attempt can write.

Alternative: treat every trigger as an unrelated run. Rejected because it permits duplicate applies and loses recovery lineage.

### D3. Demand readiness is an explicit directed dependency model

The demand map records demand identity/revision, coordinator, evidence root, change nodes, acceptance references, unresolved decisions, and typed dependency edges. Edge types distinguish contract, artifact/approval, implementation, integration, and spec-promotion ordering. Readiness is derived from edge conditions and referenced evidence, never from worker availability or file disjointness alone. Cycles, unresolved edge state, incompatible bases, and overlapping promotion ownership block affected admissions.

Alternative: infer order from PR creation, task order, or paths. Rejected because shared contracts can conflict without touching the same file.

### D4. Admission uses an immutable phase-run packet

Before launch, the coordinator freezes repository/worktree identity, base and dirty fingerprints, change/phase, artifact revisions, scope paths, dependencies, approval evidence, ownership, tool/freshness expectations, acceptance/gates, host/model facts, and limits. Approval references identify approver, authorized action/scope, and covered artifact revision. A new attempt may reuse still-valid approval; a material scope, contract, or covered-revision change requires reassessment rather than automatic reuse.

The reference host adapter is local Codex with Astra, but the packet records observed adapter capabilities. Absence of an executable adapter leaves the run blocked and does not affect standard manual `/opsx` operation.

### D5. Worktree ownership combines transient locks with durable evidence

Each writing attempt has one declared writer, worktree, session ID, and paths scope. Apply still runs the existing register/check/release scripts. Durable receipts record lock acquisition/release facts, but cannot replace or override the live lock. Read-only work may share a revision snapshot; writers use separate worktrees and never write the same artifact concurrently. Stale heartbeat alone cannot authorize lock takeover.

Alternative: expand the current session JSON into historical truth. Rejected because it is ephemeral, local to a worktree, and deleted on release.

### D6. Knowledge evidence is revision- and coverage-aware

The contract records, per tool, repository/worktree, base plus dirty fingerprints, index/configuration version, corpus coverage, observed freshness state, query or refresh, result limitation, and decision supported. States are `healthy`, `stale`, `unavailable`, or `unknown`. Rebase, merge, checkout, new worktree, relevant dirty change, changed index configuration, or incomplete refresh invalidates affected evidence.

Graphify conceptual/document coverage and code-AST refresh are recorded separately. GitNexus structural/impact evidence is tied to the actual snapshot. Shared index writes are serialized and only completed snapshots are published. Existing R1/R2/R10 and tooling-guidance rules decide when consultation is mandatory and which fallback is authorized; the contract does not make either tool unconditional. Empty results from stale/degraded retrieval are never negative dependency proof.

### D7. Restart is conservative and evidence-led

On interruption, the coordinator stops affected admissions, preserves the old receipt, establishes whether a writer or side effect remains active, releases locks only through verified ownership, compares current base/contracts/approvals, and starts a linked attempt only when safe. Unknown or disputed ownership/effects block replacement writes. Completed checks may be reused only with explicit unchanged-scope justification; affected checks rerun on the integrated revision.

Alternative: resume from chat history or heartbeat timeout. Rejected because neither proves durable state or absence of effects.

### D8. Markdown with constrained YAML front matter is the durable projection contract

The hub will publish a contract document plus demand-map and run-receipt templates. YAML front matter carries versioned scalar/list identifiers for deterministic projection; Markdown sections carry bounded human evidence and links. The consumer chooses a reviewed, consumer-owned evidence root, and every record pins hub contract revision. Unknown and disputed values are explicit rather than omitted. Receipts separate `phase` from operational `status` and distinguish proposed, approved, applied, integrated, archived, and released evidence.

Alternative: introduce a database or runtime event store now. Rejected because it would prematurely implement the control plane and create a second authority.

### D9. Optionality is structural, not a compatibility promise inferred later

The guide presents Astra coordination as an optional layer. If disabled or unavailable, existing `/opsx` phases, human gates, session scripts, validation, and artifacts operate unchanged. This change adds no installer switch and performs no migration; later enablement and legacy behavior remain separate reviewed changes.

## Risks / Trade-offs

- **[Markdown/front-matter drift]** → Publish a field table, contract version, examples, and deterministic fixture checks; later parsers must reject unsupported versions rather than guess.
- **[Operational records become shadow authority]** → Require authority references and explicit disclaimers; status projection cannot approve, complete, merge, archive, or release work.
- **[Approval reuse becomes too permissive]** → Bind approval to scope and artifact revision, record the validation decision, and block on material mismatch or ambiguity.
- **[Stale indexes create false confidence]** → Record identity/coverage and degraded states; invalidate on snapshot changes and prohibit empty degraded results as negative proof.
- **[Restart duplicates effects]** → Separate logical runs from attempts, use an idempotency key, inspect ownership/effects, and block replacement writes when uncertain.
- **[Host-neutral contract hides adapter gaps]** → Keep local Codex/Astra as a falsifiable pilot hypothesis and record actual adapter capabilities during admission.
- **[Template burden affects non-Astra users]** → Keep all coordinator artifacts opt-in and leave standard workflow instructions and gates unchanged.

## Migration Plan

1. Add the new capability and additive deltas to handoff and coordination specs.
2. Publish the canonical phase-run contract and its demand-map/run-receipt templates in the hub.
3. Add a bounded guide section that explains optional Astra coordination and links the templates without changing install/upgrade behavior.
4. Run structural validation plus a documentation semantic walkthrough covering admission, dependency blocking, stale knowledge, interruption/restart, duplicate triggers, approval invalidation, unknown ownership, and non-Astra operation.
5. Use the contract only in the separately reviewed `pilot-astra-orchestration-run` change.

Rollback removes the additive hub documentation/templates and spec deltas. No runtime state, installer behavior, consumer migration, or release tag is created by this change.

## Open Questions

- The pilot registration must verify whether local Codex exposes the required Astra launch, session, usage, and cancellation capabilities; unsupported features remain blocked or manually adapted.
- The pilot must select the consumer repository/task, concurrency and budget limits, and concrete approval-record location.
- The later control-panel proposal must choose a parser/storage implementation and cannot expand the fields into state-changing authority without a separate review.
