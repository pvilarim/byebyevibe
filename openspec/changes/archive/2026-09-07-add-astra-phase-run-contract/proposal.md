## Why

The registered Astra release track requires a durable boundary between coordination and specification authority before any orchestration pilot or control-panel work can proceed. The current pilot protocol identifies the required evidence, but the hub does not yet define a reusable phase-run contract that admits only authorized work, survives restarts, and exposes source-backed state without replacing OpenSpec.

**Issue:** —

## What Changes

- Define Astra as a coordinator that maps demand and launches bounded, separately authorized OpenSpec phase runs; OpenSpec artifacts and approvals remain authoritative.
- Define the demand-map and dependency-edge records used to decide whether work is ready, blocked, ordered, or independently runnable.
- Define immutable phase-run inputs, approval references, worktree/session ownership, one-writer rules, and integration-base checks.
- Define Graphify and GitNexus identity, freshness, invalidation, refresh, fallback, and serialization signals without making either tool a new unconditional dependency.
- Define restart and duplicate-trigger semantics using stable logical run identity, linked attempts, verified ownership/effects, and preserved evidence.
- Define durable run receipts as the future control panel's read-only data contract, with phase separated from status and unknown or disputed evidence represented honestly.
- Add guide and reusable template material for the contract while preserving the ordinary `/opsx` workflow for users who do not enable Astra.
- Exclude orchestration pilot execution, dashboard/control implementation, installer or migration behavior, production model routing, release preparation, and tag creation.

## Capabilities

### New Capabilities

- `sdd-astra-phase-run-contract`: Defines bounded Astra demand coordination, phase-run admission, dependency and approval references, ownership, knowledge freshness, restart behavior, and durable receipts.

### Modified Capabilities

- `sdd-session-handoff`: Clarifies that an Astra-coordinated phase run remains a separate phase session and that durable handoff artifacts, rather than coordinator conversation state, carry authority across phase boundaries.
- `sdd-session-coordination`: Extends the ownership contract so coordinated runs identify their worktree/session writer, reconcile transient locks with durable receipts, and never infer safe replacement from heartbeat age alone.

## Impact

- Adds OpenSpec requirements and documentation/template artifacts for the phase-run and receipt contract.
- Updates the canonical guide and applicable kit payload so consumer copies can adopt the contract explicitly while the standard workflow remains unchanged by default.
- Constrains a later Astra pilot and read-only control panel through stable, source-backed records; it adds no hub orchestration runtime or dashboard implementation.
- No application code, production API, model routing, release metadata, migration, tag, or untracked media is in scope.
