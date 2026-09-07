# Astra phase-run contract documentation review

Status: **PASS for documentary contract publication**. Pilot execution, adapter readiness, dashboard behavior and consumer adoption remain **NOT TESTED / NOT AUTHORIZED**. All scenario results below are desk-review expectations, not measurements or runtime claims.

## Reviewed revision and sources

- Repository HEAD during review: `1606be65b2d4a61e3b0950416657fb0ffd5183cb` plus the working-tree artifacts listed below.
- Proposal SHA-256: `18ae53e46fbce76288d629132c0b92106addf156b5773092528abae849f2d987`.
- Design SHA-256: `4ecaa6e15df11e4eaf419269abdfb556c5fe37010b01d964272d17c986269fad`.
- Tasks input SHA-256 before completion updates: `47c07e1c18660cde01c45afc0f32fead8e649ff646f347a2729bad04063d7761`.
- New-capability spec SHA-256: `fbf7d331448abe7fe73286cdd9a0dac2c913fc13741c62ec5aa102e3ba2fee0d`.
- Coordination delta SHA-256: `95d65c649cbbbae959ae9e58926d52b9ce8e89b8d1135dd1ef92bf6fddfc3431`.
- Handoff delta SHA-256: `bc7b5cf4b50b34be3c2b628af7607c193ab3d82116a9c4407c7eb3287b63a1e3`.
- Contract SHA-256: `ed78e6e00c5974d77b7058fdb90c268ef3c93d2f0ab37b08f90e13f99f4f888a`.
- Demand-map template SHA-256: `36f8e4de5a5d739f11129cc3d3c0376507be7393722c51a14f776969236ea882`.
- Receipt template SHA-256: `905178713cc89a115790697143c708b44994bc870a7b1c02942d9acf8f5754ec`.

## Requirement-to-artifact mapping

| Changed requirement | Contract / guide / template coverage | Desk result |
|---|---|---|
| Astra coordinates authorized phase runs without replacing OpenSpec | Contract opening/Consumer adoption; guide §2.19; README | PASS: authority and ordinary non-Astra path are explicit |
| Demand maps carry explicit nodes and dependency edges | Contract “Demand map and dependency semantics”; demand-map front matter and tables | PASS: typed edges, evidence-derived readiness and shared-contract ordering are explicit |
| Admission freezes a revision-bound phase-run packet | Contract “Immutable admission packet”; receipt front matter/Admission packet | PASS: identity, scope, approval, revisions, gates, host/model and limits are covered |
| Writer ownership remains explicit and locally enforced | Contract “Worktree and writer ownership”; receipt Ownership section | PASS: one writer, separate worktrees, live-lock priority and no heartbeat takeover |
| Knowledge evidence exposes identity freshness and coverage | Contract “Knowledge identity, freshness and fallback”; receipt Knowledge section | PASS: four states, invalidation, serialization and degraded-empty limitation |
| Restart and duplicate triggers preserve attempt history | Contract “Restart, duplicate triggers and recovery”; receipt lineage/recovery fields | PASS: stable logical run, immutable linked attempts and conservative replacement |
| Durable receipts form a non-authoritative projection contract | Contract field table; receipt template | PASS: phase/status separation, lifecycle evidence, unknown/disputed and usage coverage |
| Contract adoption is optional and release-neutral | Contract Consumer adoption; guide §2.19; README | PASS: no installer, migration, routing, pilot, dashboard, release or tag |
| Coordinated attempts bind durable ownership to transient locks | Contract ownership; receipt lock evidence | PASS: receipt observes but cannot replace/release the live lock |
| Coordinated runs preserve phase-session boundaries | Contract opening; guide §2.19 | PASS: exactly one phase per new session; durable artifacts carry handoff |

## Scenario walkthrough

| Case | Source-backed expected decision | Result |
|---|---|---|
| Authorized admission | Reviewed change, valid approval, satisfied edges and free owned worktree permit one bounded phase attempt; receipt cites sources | PASS |
| Missing approval | Missing approver/action/scope/revision blocks the affected action; silence or receipt status cannot authorize | PASS |
| Changed approval coverage | Material scope, contract, base assumption or covered revision change forces reassessment before launch/retry | PASS |
| Unavailable dependency | A node requiring an unavailable contract/revision remains blocked; independent authorized nodes may proceed | PASS |
| Shared-contract ordering | Disjoint paths with a shared unresolved contract receive a typed ordering/designated-owner edge | PASS |
| Active ownership | Verified live worktree owner blocks a replacement writer; receipt cannot override it | PASS |
| Stale ownership evidence | Stale heartbeat with unknown writer/effects remains blocked until reconciled | PASS |
| Stale/unavailable knowledge | Receipt records identity, coverage and limitation; an empty degraded result is not negative proof | PASS |
| Interruption | Preserve the old attempt, stop affected admissions, verify ownership/effects and reassess invalidated evidence | PASS |
| Duplicate trigger | Same idempotency key resolves to one logical run and cannot create concurrent duplicate effects | PASS |
| Changed base | Rebase/merge/checkout or relevant dirty change invalidates affected knowledge and admission/check evidence | PASS |
| Unknown/disputed evidence | Required field uses explicit `unknown` or `disputed` plus limitation; completion is not inferred | PASS |
| Missing usage | Receipt records unknown telemetry and coverage rather than estimating cost/tokens | PASS |
| Ordinary non-Astra operation | Standard `/opsx` phases and session scripts remain usable without contract records or Astra | PASS |

## Knowledge and coordination evidence

- `graphify query "Astra phase run contract authority demand dependency receipt restart OpenSpec"`: exit 0; returned session/OpenSpec anchors but incomplete semantic coverage. Treated as navigation evidence only.
- `npx gitnexus status` initially reported stale (`315038d` vs HEAD `1606be6`). `npx gitnexus analyze --force` completed successfully; subsequent status reported current HEAD and 9 flows. This documentary change modifies no runtime symbols, so direct source/pattern review supplies normative coverage.
- Apply registration/check: exit 0. On Windows, `flock` was unavailable and the existing PID-file guard was active. This observation does not certify a future consumer's exclusive-lock capability.

## Structural gates

The task 1.1, 1.2, 1.3 and 2.1 exact gates exited 0. `bash sdd-kit/gen-manifest-checksums.sh` updated the guide-template checksum without changing kit/guide version; `bash sdd-kit/gen-manifest-checksums.sh --check` reported all 45 entries matched. `bash sdd-kit/verify.sh` passed its completed core checks; final exact gates are recorded below after execution.

Structural success proves document shape, links, parity and OpenSpec conformance only. It does not prove Astra availability, orchestration quality, runtime recovery, usage telemetry, pilot outcomes or dashboard behavior.

## Final gate record

| Command | Result |
|---|---|
| `bash scripts/verify-task-patterns.sh` | Exit 0; all verifiable Pattern paths passed, 0 skipped/warnings |
| `npx --yes @fission-ai/openspec@1.3.1 validate add-astra-phase-run-contract --strict` | Exit 0; change valid |
| `bash sdd-kit/gen-manifest-checksums.sh --check` | Exit 0; 45 entries compared, 0 warnings |
| `bash sdd-kit/verify.sh` | Exit 0; core, parity, integrity, release-readiness and policy checks passed |
| `git diff --check` | Exit 0 after normalizing the regenerated MANIFEST checksum line |

Final apply-owned scope is nine files: three new experiment artifacts, the experiments README, the canonical and kit guide copies, the MANIFEST checksum, this review, and task checkboxes. The enclosing OpenSpec proposal/design/delta files were pre-existing inputs to this apply. Unrelated modified `AGENTS.md`/`CLAUDE.md` and untracked media were preserved and excluded.

## Scope audit

Expected final diff for this change: one canonical contract, two templates, experiments README, canonical/kit guide mirrors, one MANIFEST checksum, this validation review and task checkboxes. No pilot was executed; no dashboard/control, installer behavior, migration, model routing, release metadata, release, tag or external write was produced. Pre-existing unrelated working-tree changes and media are excluded and preserved.

## Unresolved gaps

- Actual local-Codex/Astra launch, cancellation, session, model and usage capabilities remain registration-time facts for a separately reviewed pilot.
- Consumer repository, demand, approval locations, adapter limits and exclusive-lock behavior are not selected or tested here.
- A later parser/control-panel proposal must define implementation/storage and remain read-only unless separately authorized.
