# Proposal review

Date: 2026-09-06. Phase: propose only. Status: ready for human proposal review and a separately authorized apply. All five implementation tasks remain unchecked.

## Checks

- `npx openspec validate add-product-validation-evidence --strict --no-interactive`: passed.
- `npx openspec validate --all --strict --no-interactive`: 26 passed, 0 failed.
- `bash scripts/verify-task-patterns.sh`: passed, zero skipped/warnings.
- `git diff --check`: passed in hub and portfolio.
- Portfolio candidate source hashes reconfirmed unchanged; visual acceptance recorded in its original report. No commit or deployment performed.

## Semantic proposal review

Read-only researchers reviewed current specs, graph readiness and the new contract. No blocking contradiction was found. Clarified performance targets/tolerances and the distinction between browser mode and emulated/physical device context.

| Case | Proposed disposition | Contract reviewed |
| --- | --- | --- |
| Green build, broken images/interaction | Task incomplete | Semantic contract plus task-pattern delta |
| Missing browser | Equivalent evidenced method or not run | Tool readiness requirement |
| Revision changes after test | Recheck affected behavior | Revision-bound evidence |
| Single headless sample | Exploratory claim with limits | Performance boundaries |
| Failed attempts or lost raw material | Retain failure identity; disclose loss | Durable evidence |
| Lower draw calls with long frames | Separate measurements; no stutter-free claim | Performance boundaries |
| Product visually accepted | Record visual approval; Astra not evaluated | Separate outcomes |
| Docs-only or standard non-Astra consumer | Applicable walkthrough; no mandatory browser/runtime | Proportional scope |

This reviews the proposed rules, not the future implemented templates. Task 3.2 still requires an actual artifact-level semantic walkthrough after apply.

## Readiness and limits

Graphify is stale (2026-08-17, `5e68200a`); UTF-8 retry of the query succeeded after an output-encoding failure. GitNexus is stale (2026-08-06, `8666235`) and FTS search degraded. Hub HEAD and queries are recorded in design.md. Direct specs/source reads support the proposal; no generated indexes changed.

The portfolio observations are local, short, not randomized/repeated and not a formal Astra run. Its approved implementation remains in the original working tree without a commit. No universal performance guarantee, consumer migration, kit rollout or definitive Astra adoption is authorized. No unresolved blocker for completing propose; apply authorization remains the next phase decision.
