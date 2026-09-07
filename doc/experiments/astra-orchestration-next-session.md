# Astra Orchestration Next Session Handoff

Date: 2026-09-07

## Repository state

The four open PRs that preceded the Astra pilot sequence were merged into `master` first:

- #383 `docs(avaliacoes): register Pi harness research (deferred)`
- #384 `docs(sdd): register Astra orchestrator possibility (explore-astra-orchestrator)`
- #385 `docs(sdd): propose Astra orchestrator S1+S2 (explore-astra-orchestrator)`
- #386 `docs(sdd): apply Astra orchestrator S1+S2 (explore-astra-orchestrator)`

The `#386` merge conflict was resolved by keeping both evaluation index rows (`Pi` and `Astra`) and regenerating the final `sdd-kit/MANIFEST.yaml` checksum for `sdd-kit/templates/doc/byebyevibe-guide.md`.

Validation before pushing:

- `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict` — 27 passed, 0 failed
- `bash scripts/verify-task-patterns.sh` — passed
- `bash sdd-kit/verify.sh` — passed; `verify-infra.sh` reported advisory local tool-version drift only

## Correct next sequence

1. Fix G1 consumer provenance links before any pilot execution.
   - Correct stale hub/archive references from the Astra pilot docs.
   - Correct mirrored guide links so installed consumers can reach the referenced Astra documents or deliberately expand `MANIFEST.yaml`.
   - Reproduce the current failure first, then patch and verify representative consumer accessibility.
   - If any `sdd-kit/templates/` file changes, run `bash sdd-kit/gen-manifest-checksums.sh`.

2. Complete the active pilot preparation change.
   - Use `openspec/changes/pilot-astra-orchestration-run/`.
   - Select the APP repository, demand, operators, models, budget, and admissible evidence.
   - Fill the admission dossier, consumer handoff, and validation artifacts.
   - Keep the pilot as preparation only until reviewed.

3. Run the pilot phases only after admission is ready.
   - H1: decomposition, with hidden evaluator rubric kept away from the executor.
   - F: functional and recovery checks.
   - T: operator sequential vs Astra sequential vs Astra parallel.
   - M: mixed-model economics only after valid timing/topology data.

4. Review pilot results before productizing.
   - Create `review-astra-pilot-results`.
   - Keep the control-panel artifact separate.
   - Only propose optional Astra orchestration mode if pilot evidence supports it.

5. Treat release as a separate track.
   - Use an optional, reversible mode.
   - Preserve the existing `/opsx:*` handoff model.
   - Run a clean checkout dry run before any release cut.

## Guardrails

- Do not add a code-first hub runtime, `ChangeState`, `PolicyEngine`, event bus, or one-process explore-to-archive flow.
- Do not claim official GPT-6/Astra capabilities without verification.
- Do not run experiments without a numeric enforced budget.
- Do not merge panel/dashboard, migration, routing, pilot execution, and release into one proposal.
