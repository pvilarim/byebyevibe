**Issue:** — (open issues checked on 2026-09-06; #349 concerns automated PR review and #363 native-Windows support, neither is duplicated here).

## Why

The `pedrocode.art` rendering prototype exposed a practical gap between passing structural checks and demonstrating product behavior with reproducible evidence. Astra's existing pilot already has rigorous experiment controls; the standard SDD workflow needs a lightweight product-validation contract usable without Astra.

## What Changes

- Document applicable semantic acceptance scenarios and revision-bound evidence alongside deterministic task gates.
- Provide a hub-only product-validation guide and reusable plan/run templates, including tool readiness, failed attempts, human acceptance and scoped revalidation after edits.
- Define prospective performance comparisons with declared metrics, targets/tolerances, environment and sampling controls; keep exploratory observations explicitly observational.
- Connect the contract to the canonical guide's task guidance and hub propose/apply skill mirrors, without adding a universal browser or benchmark job.
- Separate product acceptance, performance claims and orchestration outcomes. Preserve OpenSpec authority, phase handoffs and explicit human approval.
- Include a source-backed portfolio case note and adversarial semantic walkthrough. Do not retrospectively admit the portfolio work as an Astra trial.

## Capabilities

### New Capabilities

- `sdd-product-validation`: proportional semantic validation, durable evidence and performance claim limits in the standard workflow.

### Modified Capabilities

- `sdd-task-patterns`: applicable semantic evidence supplements deterministic gates before completing behavior-changing tasks.

## Impact

- Documentation and templates under `doc/experiments/`; guide §12.10; existing hub propose/apply skill bodies and command mirrors where those instructions are duplicated.
- No consumer application changes in this hub. The approved portfolio version stays in its original repository, without an automatic commit or deployment.
- No CI workflow change, G4 script change, installer, kit version update, mandatory dependency, new always-on rule or central runtime. The required guide edit is mirrored into the existing kit guide payload with its checksum to preserve hub parity; the product-validation protocol/templates are not added to the kit. Consumer use remains manual and explicitly selected; broader kit distribution is a separate follow-up.
- Astra remains experimental and optional. Its active change is not modified or archived; this proposal does not authorize installation, legacy migration, dashboard adoption or production model routing.
- Proposal only: implementation tasks remain unchecked until a separately authorized apply.
