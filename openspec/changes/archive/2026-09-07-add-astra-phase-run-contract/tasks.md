## 1. Canonical phase-run contract

- [x] 1.1 Publish `doc/experiments/astra-phase-run-contract.md` with authority boundaries, the local-Codex/Astra host hypothesis, demand/dependency semantics, immutable admission, approval validity, worktree ownership, freshness/invalidation triggers, restart/idempotency rules, and the versioned projection field table.
  - **Pattern:** `doc/experiments/astra-orchestration-pilot.md`
  - **Gate:** `test -s doc/experiments/astra-phase-run-contract.md && rg -q 'OpenSpec.*authority|authority.*OpenSpec' doc/experiments/astra-phase-run-contract.md && rg -q 'demand|dependency|approval|worktree|freshness|restart|receipt' doc/experiments/astra-phase-run-contract.md`
  - **Evidence:** `openspec/changes/add-astra-phase-run-contract/validation.md` records the authority, blocked-admission, degraded-knowledge and non-Astra walkthroughs.

- [x] 1.2 Add constrained front-matter templates at `doc/experiments/templates/astra-demand-map.md` and `doc/experiments/templates/astra-phase-run-receipt.md`, including contract/revision identity, explicit unknown/disputed values, logical-run/attempt lineage, phase/status separation, ownership, knowledge evidence, checks, recovery, usage coverage and outcomes.
  - **Pattern:** `doc/experiments/templates/astra-pilot-run.md`
  - **Gate:** `test -s doc/experiments/templates/astra-demand-map.md && test -s doc/experiments/templates/astra-phase-run-receipt.md && rg -q 'contract_version|contract revision' doc/experiments/templates/astra-demand-map.md doc/experiments/templates/astra-phase-run-receipt.md && rg -q 'run_id|attempt_id|phase|status' doc/experiments/templates/astra-phase-run-receipt.md`
  - **Evidence:** `openspec/changes/add-astra-phase-run-contract/validation.md` records template-field coverage and restart/duplicate-trigger reconstruction.

- [x] 1.3 Update `doc/experiments/README.md` to link the contract and both templates, state their consumer-owned evidence-copy rules, and keep pilot execution and adoption separate.
  - **Pattern:** `doc/experiments/README.md`
  - **Gate:** `rg -q 'astra-phase-run-contract.md' doc/experiments/README.md && rg -q 'astra-demand-map.md' doc/experiments/README.md && rg -q 'astra-phase-run-receipt.md' doc/experiments/README.md`
  - **Evidence:** Link and scope behavior are covered by the semantic walkthrough in `openspec/changes/add-astra-phase-run-contract/validation.md`.

## 2. Optional standard-workflow guidance

- [x] 2.1 Add a bounded guide section explaining Astra as an optional coordinator of separately authorized phase sessions, linking the contract and making the unchanged standard `/opsx` path explicit; mirror the section in the kit guide without adding installer, migration, dashboard-control, routing or release behavior.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `rg -q 'Astra' doc/byebyevibe-guide.md sdd-kit/templates/doc/byebyevibe-guide.md && cmp -s doc/byebyevibe-guide.md sdd-kit/templates/doc/byebyevibe-guide.md`
  - **Evidence:** `openspec/changes/add-astra-phase-run-contract/validation.md` records the standard non-Astra path and out-of-scope boundary review.

- [x] 2.2 Regenerate `sdd-kit/MANIFEST.yaml` checksums after the guide-template change and verify kit integrity/parity without changing the kit or release version.
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh --check && bash sdd-kit/verify.sh`
  - **Evidence:** Gate output proves payload integrity only; semantic compatibility remains in `validation.md`.

## 3. Semantic contract review

- [x] 3.1 Create `openspec/changes/add-astra-phase-run-contract/validation.md` as a documentation desk review mapping every changed requirement to contract/guide/template sections and walking through authorized admission, missing/changed approval, unavailable dependency, shared-contract ordering, active/stale ownership, stale/unavailable knowledge, interruption, duplicate trigger, changed base, unknown/disputed evidence, missing usage and ordinary non-Astra operation.
  - **Pattern:** `openspec/changes/archive/2026-09-07-add-astra-orchestration-pilot/readiness-review.md`
  - **Gate:** `test -s openspec/changes/add-astra-phase-run-contract/validation.md && rg -q 'authorized admission|approval|dependency|ownership|knowledge|interruption|duplicate|non-Astra' openspec/changes/add-astra-phase-run-contract/validation.md`
  - **Evidence:** The artifact labels all results as desk-review expectations, records reviewed revisions and unresolved gaps, and makes no pilot measurement claim.

## 4. Final gates

- [x] 4.1 Run task-pattern and strict change validation, then record exact commands/results and the final diff scope in `validation.md`.
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && npx --yes @fission-ai/openspec@1.3.1 validate add-astra-phase-run-contract --strict`
  - **Evidence:** `validation.md` distinguishes structural gate success from semantic desk-review evidence and confirms that no pilot, dashboard control, migration, release or tag was produced.
