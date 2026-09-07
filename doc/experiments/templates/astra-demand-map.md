---
record_type: astra-demand-map
contract_version: "1.0.0"
contract_revision: "unknown"
evidence_root: "unknown"
demand_id: "unknown"
demand_revision: "unknown"
repository: "unknown"
base_revision: "unknown"
coordinator: "unknown"
status: "draft"
change_nodes: []
dependency_edges: []
unresolved_decisions: []
acceptance_references: []
---

# Astra demand map: `<demand_id>`

Use `unknown` for unavailable evidence and `disputed` for contradictory evidence; explain either state below. Do not omit required values or infer authority from this map.

## Demand and goals

- Goal and acceptance boundary:
- Repository/worktree and dirty fingerprint:
- Consumer evidence owner/root:
- Coordinator/host facts:

## Change nodes

For each node record: node/change ID, revision, authorized phase, goal, owner, affected capabilities/paths, acceptance references, readiness state and evidence links.

| Node | Revision | Phase | Owner | Capabilities / paths | Acceptance | State | Evidence |
|---|---|---|---|---|---|---|---|

## Dependency edges

Allowed types: `contract`, `artifact-approval`, `implementation`, `integration`, `spec-promotion`.

| Edge ID | Source | Target | Type | Required evidence | State | Decision owner | Revision |
|---|---|---|---|---|---|---|---|

## Unresolved or disputed decisions

Record cycles, incompatible bases, shared-contract/spec-promotion ownership, unknown evidence and the decision needed to unblock each affected node.

## Admission decisions

For each ready, queued or blocked node, cite satisfied/unsatisfied edges, compatible revision evidence and approval reference. Disjoint files alone do not establish independence.
