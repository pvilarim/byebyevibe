# Astra phase-run contract

Contract version: `1.0.0`. Status: experimental, optional and host-adapter-neutral.

This contract defines a durable boundary for coordinating bounded OpenSpec phase runs. OpenSpec specifications, reviewed change artifacts and explicit approvals remain the authority. A demand map or receipt is operational evidence only: it cannot approve, merge, archive, release, or replace phase memory. Every coordinated run executes exactly one of `explore`, `propose`, `apply`, or `archive` in a separate session. The ordinary `/opsx` workflow remains unchanged when Astra is absent or disabled.

The initial, falsifiable host hypothesis is local Codex with Astra coordinating separate phase sessions. Registration must record observed launch, cancellation, session, model and usage capabilities. Missing adapter capability blocks only the coordinated run; it does not create a platform promise or block manual `/opsx` work.

## Demand map and dependency semantics

A consumer copies the [demand-map template](templates/astra-demand-map.md) into a reviewed, consumer-owned evidence root. The map pins this contract version and hub revision, plus demand/repository/base identity, coordinator, change nodes, goals, owners, affected capabilities and paths, acceptance references and unresolved decisions.

Every directed dependency edge names source and target, revision, decision owner, required evidence, current state and one type: `contract`, `artifact-approval`, `implementation`, `integration`, or `spec-promotion`. Readiness follows satisfied evidence on compatible revisions. Worker availability, PR order and disjoint paths are not proof of independence. Cycles, unresolved edges, incompatible bases, competing shared-contract ownership, and overlapping spec promotion block affected nodes; independent authorized nodes may still proceed.

## Immutable admission packet

Before launch, the coordinator freezes an admission packet in a new [phase-run receipt](templates/astra-phase-run-receipt.md): logical run/idempotency identity; repository, worktree, base and relevant dirty fingerprints; change and phase; artifact revisions; bounded scope; dependency evidence; approval references; ownership; knowledge expectations; acceptance checks; host/model facts; and limits.

An approval reference names the approver, authorized action and scope, covered artifact revision and evidence location. A retry may reuse it only when its covered scope, contract and revision assumptions remain valid. A material scope, contract, base-assumption or covered-revision change requires reassessment. Missing, ambiguous or disputed authorization blocks the affected action.

## Worktree and writer ownership

Each writing attempt names exactly one writer, worktree, session ID and paths scope. Parallel writers use separate worktrees and never write the same artifact concurrently. Apply still runs `sdd-session-register`, `sdd-session-check` and `sdd-session-release`; a receipt records observed lock events but is not a lock and cannot override or force-release a live owner. Read-only work may share an identified snapshot. Heartbeat age alone never proves that ownership or side effects ended.

## Knowledge identity, freshness and fallback

For each consulted tool, record repository/worktree, base and dirty fingerprints, index/configuration version, corpus coverage, freshness (`healthy`, `stale`, `unavailable`, or `unknown`), query or refresh, limitations and the decision supported. Rebase, merge, checkout, a new worktree, relevant dirty changes, configuration changes, or incomplete refresh invalidates affected evidence.

Graphify conceptual/document coverage and code-AST refresh are separate facts. GitNexus structural/impact evidence identifies the actual snapshot. Shared index writes are serialized and only completed snapshots are current. Existing classification and tooling rules decide when consultation and fallback are required; this contract adds no unconditional tool dependency. An empty stale, unavailable or degraded result never proves that a dependency is absent.

## Restart, duplicate triggers and recovery

One stable `run_id` represents a logical change/phase assignment. Every execution creates an immutable unique `attempt_id`; retries link `parent_attempt_id` and preserve prior receipts. The `idempotency_key` maps duplicate launch requests to the same logical run and prevents concurrent duplicate apply, merge or release effects.

After interruption, stop affected admissions, preserve evidence, verify writer ownership and possible effects, and release locks only through verified ownership. Reassess base, contracts, approvals, dependencies and affected checks before replacement writes. Unknown or disputed ownership/effects remain blocked. A new linked attempt may reuse a completed check only with explicit unchanged-scope justification; invalidated checks rerun on the integrated revision.

## Versioned projection fields

YAML front matter is the constrained machine projection; Markdown sections hold bounded, source-linked evidence. Required fields are never silently omitted: use `unknown` when evidence is unavailable and `disputed` when sources conflict, then explain the limitation.

| Record | Field group | Required meaning |
|---|---|---|
| Both | `contract_version`, `contract_revision`, `evidence_root` | Parser version, exact reviewed hub revision, consumer-owned record root |
| Demand | `demand_id`, `demand_revision`, repository/base, coordinator | Stable demand and source snapshot identity |
| Demand | nodes, edges, unresolved decisions, acceptance references | Explicit readiness inputs and ordering evidence |
| Receipt | `run_id`, `attempt_id`, `parent_attempt_id`, `idempotency_key` | Logical identity, immutable attempt and retry lineage |
| Receipt | `phase`, `status` | Phase separate from operational status (`not-started`, `running`, `blocked`, `failed`, `completed`, `unknown`, `disputed`) |
| Receipt | change, host/model, worktree/base/artifact revisions, scope | Immutable admission identity |
| Receipt | dependency/approval references, ownership, knowledge evidence | Source-backed authorization and safety evidence |
| Receipt | timestamps, checks and tested revision, findings, recovery/interventions | Attempt chronology and verification boundary |
| Receipt | usage and coverage, outcome, evidence links | Honest telemetry and non-authoritative result |
| Receipt | proposed/approved/applied/integrated/archived/released evidence | Distinct lifecycle evidence, never inferred from `status` |

Corrections create or identify a superseding record and retain the superseded attempt. A future read-only control panel may project these fields, including unknown/disputed states, but this contract implements no dashboard, state-changing control, installer, migration, routing policy, pilot, release or tag.

## Consumer adoption

Copy the contract templates into the consumer change's own evidence directory and replace every placeholder with source-backed values. Pin the full reviewed hub revision containing this contract and templates. Consumer evidence must not depend on mutable hub working-tree state. Adoption, pilot execution and control-panel implementation each require separate review.
