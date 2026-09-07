## Context

The approved portfolio prototype is retained in `C:/apps/pedrocode.art`. Its `doc/experiments/cube-scene-local.md` records source hashes, tests, measurements and Pedro's visual acceptance on 2026-09-06. Baseline `ec0f201501fee07341e3d85e2020d5427b717e48`; candidate `js/portfolio.js` SHA-256 `c6cf907722eb1713c485f609e09f4833c5e0409feb51faad53e674be97ec5155`; helper `js/scene-quality.js` SHA-256 `43f1428e7843b22b5d178951e8742763cc1127114b1680142d788962cefb9b05`. These are local source locators, not portable committed consumer evidence.

The final short desktop samples observed about 204 versus 22 draw calls and 3.569 versus 0.523 ms synchronous RAF CPU time. Candidate still had two frames over 50 ms. Initial preview runs had missing images, corrected before final runs. Mobile was emulated; random initialization, cache/order and long-duration behavior were not controlled. The harness overwrites latest results. This supports process lessons, not a statistical performance guarantee or an Astra outcome.

Sources and compatibility review:

- `openspec/specs/sdd-task-patterns/spec.md`: deterministic Gate, task completion, guide §12.10 and DOCS_SPECS boundaries remain intact; add applicable semantic evidence as a complementary condition.
- `openspec/specs/sdd-ci-gates/spec.md`: a green structural workflow retains its current meaning; no universal visual CI gate.
- `openspec/specs/sdd-metrics/spec.md`: G4 git/archive proxies stay separate from product measurements.
- `openspec/specs/sdd-session-handoff/spec.md` and `sdd-session-coordination/spec.md`: durable change artifacts, separate phases, existing local register/check/release and one writer per worktree.
- `openspec/specs/sdd-tooling-guidance/spec.md`, `sdd-install-kit/spec.md`, `sdd-install-narrative/spec.md`: reuse tool fallback policy; no unrequested install or silent consumer upgrade.
- `openspec/project.md`: no rival authority or mandatory coordinator runtime.
- `openspec/changes/add-astra-orchestration-pilot/specs/sdd-astra-orchestration-pilot/spec.md`, `doc/experiments/astra-orchestration-pilot.md` and its registration/run templates already cover experimental admission, budgets, revisions and outcomes. They are active work, not a current archived capability. This change neither rewrites nor depends on their archive.

Knowledge readiness on 2026-09-06: hub HEAD `861c20fd5ccaceb2215b895961d4d15bedcde2ac`; Graphify report built from `5e68200a` on 2026-08-17, stale. Query `semantic validation performance evidence` failed on cp1252 output, then returned 29 navigation nodes with UTF-8 output. GitNexus status reports index `8666235` from 2026-08-06, stale; MCP query `validation evidence gate` returned empty with missing FTS/degraded search. No index regenerated. Direct current sources establish the contract; no conclusion is inferred from empty results. Open issues #364, #363 and #349 were checked; none duplicates this scope.

## Goals / Non-Goals

**Goals:** proportionate observable acceptance, traceable tested revisions, honest performance claims, durable failed-attempt records and actionable handoffs in the standard workflow.

**Non-Goals:** APP implementation here; a browser/testing framework; an always-on observer; distribution of the product-validation protocol/templates through the kit; CI or G4 rewrites; Astra adoption, installation, legacy migration, dashboard or model-routing changes. The existing guide mirror and manifest checksum are synchronized because hub release readiness requires parity. Human visual acceptance is recorded, not promoted to release approval.

## Decisions

1. **One generic protocol, two templates.** Add `doc/experiments/product-validation.md`, `templates/product-validation-plan.md` and `templates/product-validation-run.md`. Plans map OpenSpec scenarios to applicability, expected result, method, owner and acceptance criteria. Run records link the plan and tested revision. Link from the experiments index and guide §12.10. Existing task checkboxes remain completion authority; evidence files supply facts, never a second done ledger.
2. **Proportional gates.** Behavior-changing tasks select relevant functional/visual/recovery scenarios. Documentation-only work uses semantic scenario walkthroughs; no browser requirement. Unrelated one-line edits need no benchmark dossier. Keep deterministic Gate commands and add a semantic evidence reference when applicable. Update existing hub propose/apply skills and actual duplicated command bodies. Mirror the required guide edit into the existing kit guide payload and refresh its checksum, but leave protocol/template distribution for a later change.
3. **Revision-bound, append-only evidence.** Consumer evidence lives under its own change, e.g. `evidence/product-validation/<run-id>/`, with distinct attempt IDs. Record repository/base/tested SHA or dirty hashes, environment, commands, timestamps, expected/observed results, failures, exclusions and source accessibility. Preserve failed attempts; corrections append a superseding record. Store safe compact receipts durably; large/private artifacts can remain in controlled storage with digest, access instructions and retention limits. Missing raw material is disclosed, never reconstructed as observed. Later edits trigger only affected checks, with a recorded rationale for reuse.
4. **Two measurement modes.** Exploratory observations may precede thresholds but cannot claim a registered acceptance test. Prospective comparisons freeze metrics/units, target/tolerance, baseline/configuration, warm-up, duration, repetition/stopping, seed/randomness, cache/order and environment before collection. No universal FPS threshold fits all products. Distinguish CPU, GPU, frame pacing and draw calls. Headless and mobile emulation do not establish real-device results.
5. **Separate decisions.** Record functional result, visual human acceptance, performance conclusion and orchestration outcome separately. The portfolio's approved appearance does not retrospectively pass Astra F/T/M or H1–H7. For a future Astra experiment, reference its separately approved registration and controls. Standard users can use this protocol without Astra or any host-specific integration.
6. **Readiness follows existing tooling policy.** Record available/stale/unavailable tools, consultation failures, chosen equivalent method and uncovered scope. A missing automated browser can use a documented manual check; if evidence for a required scenario is still missing, dependent acceptance stays not run/blocked. Do not bypass certificate validation or silently install dependencies.

Alternatives rejected: heading checks alone (miss observed loading defects); mandatory global benchmark tooling (host coupling and unnecessary cost); putting product FPS in G4 (different metric purpose); extending only Astra templates (leaves standard users uncovered); automatically migrating the consumer into SDD (outside authorization).

## Risks / Trade-offs

- More documentation → scope the contract to changed behavior and performance claims; allow justified N/A and compact receipts.
- Local portfolio evidence is not yet committed/portable → keep full identifiers in the case note, disclose access limits and retain a compact source-backed observation in this change. Do not invent missing early attempts.
- Mirrors may drift → inventory actual hub copies at apply, update duplicated instructions, synchronize the existing guide mirror/checksum, and review semantic consistency. No product-validation protocol/template or installer payload is added by this scope.
- Structural Gate may pass while review fails → the semantic walkthrough is an additional completion condition, and must name observations and disposition; file existence is insufficient.
- Stale graphs → current specs/direct reads are the primary evidence. Index maintenance remains separate.

## Migration Plan

After proposal approval, apply documentation/templates and hub guidance under existing worktree coordination. Consumer use is an explicit manual handoff of revision-pinned references; existing releases and non-Astra users retain their documented workflow. Rollback removes the new guidance links/templates, restores the canonical and mirrored guide text, and refreshes the mirror checksum through a reviewed change; retained evidence is not erased. Any later distribution of the protocol/templates requires its own payload/manifest/checksum and upgrade review.

## Semantic Review Plan

The apply review must walk through: green build with missing images; unavailable browser with manual or not-run outcome; source edited after testing; single headless benchmark; discarded failed attempts; lower draw calls without better frame pacing; visual acceptance without Astra comparison; DOCS_SPECS with no UI; standard user without Astra; absent local source/raw artifact. Each row must cite the governing requirement, expected decision, actual template/guidance fields and a pass/fail explanation. Failed or unreviewed rows prevent relevant task completion.

## Open Questions

No blocking design question for this documentary proposal. Real-device budgets, repetition counts and consumer rollout are demand-specific decisions for subsequent consumer work. General Windows support (#363) and automated PR review (#349) remain separate scopes.
