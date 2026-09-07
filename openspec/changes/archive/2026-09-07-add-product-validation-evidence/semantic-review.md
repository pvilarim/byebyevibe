# Semantic review

Reviewer: Codex apply session on 2026-09-06. Sources reviewed: change proposal/design/tasks/specs, current task-patterns guidance, Astra pilot protocol/templates, local portfolio report at `C:/apps/pedrocode.art/doc/experiments/cube-scene-local.md`, Graphify report and GitNexus CLI status/query. Graphify report is stale (`5e68200a`, 2026-08-17); GitNexus index is stale (`8666235`, 2026-08-06) and the query warned that FTS indexes are missing. Current OpenSpec files and direct source reads are the governing evidence.

## Requirement-to-section review

| Requirement | Governing source | Implemented artifact fields/sections | Disposition |
|---|---|---|---|
| Proportionate semantic acceptance contract | `specs/sdd-product-validation/spec.md` | `doc/experiments/product-validation.md` sections When to use, Plan before collection, Run records; plan template Scope and Completion rule | Pass. Standard/non-Astra and DOCS_SPECS use are explicit; browser/runtime checks are scoped to relevance. |
| Durable revision-bound run evidence | `specs/sdd-product-validation/spec.md` | protocol Run records; run template Identity, Scenario results, Attempts; plan Evidence retention | Pass. Attempts are append-only, dirty hashes and superseding records are required, missing material is disclosed. |
| Performance claims have declared measurement boundaries | `specs/sdd-product-validation/spec.md` | protocol Measurement modes; plan Performance registration; run Performance observations; portfolio case Limitations | Pass. Exploratory and prospective modes are separated and metric boundaries are named. |
| Tool readiness and equivalent verification are explicit | `specs/sdd-product-validation/spec.md` | protocol Tool readiness; plan Tool readiness and fallback; run Tool readiness observed | Pass. Fallbacks and uncovered scope are explicit, with no new mandatory tool. |
| Product and orchestration outcomes remain separate | `specs/sdd-product-validation/spec.md` | protocol Outcome separation; run Outcome; portfolio case Separated outcomes | Pass. Visual acceptance, performance and Astra status are separate. |
| Semantic evidence supplements applicable task gates | `specs/sdd-task-patterns/spec.md` | guide section 12.10, propose/apply skills and duplicated command bodies after this change | Pass. Deterministic Gate remains required; evidence is subordinate to tasks and only counts for applicable current scenarios. |

## Adversarial walkthrough

| Case | Governing requirement | Expected decision | Actual artifact fields | Observed disposition |
|---|---|---|---|---|
| Green build with missing images | Proportionate semantic acceptance contract; Semantic evidence supplements applicable task gates | Required image-loading scenario fails; affected task remains incomplete despite Gate success. | plan Scope and Deterministic gates; run Scenario results and Deterministic gates; apply guidance completion rule. | Pass. Gate success and semantic pass are both required. |
| Unavailable browser with manual or not-run outcome | Tool readiness and equivalent verification are explicit | Manual evidence can cover observed scenarios; otherwise required scenarios stay not run/blocked. | protocol Tool readiness; plan/run tool-readiness tables. | Pass. No browser dependency is introduced. |
| Source edited after testing | Durable revision-bound run evidence | Earlier run remains recorded but affected checks must repeat or justify reuse. | run Scenario results `Invalidated by / reuse rationale`; protocol Run records. | Pass. Stale evidence cannot count silently. |
| Single headless benchmark | Performance claims have declared measurement boundaries | Report as exploratory unless prospective boundaries were frozen before collection. | plan Performance registration; run Performance observations; protocol Measurement modes. | Pass. Headless context is labeled and not promoted. |
| Discarded failed attempts | Durable revision-bound run evidence | Failed attempts remain identifiable; a correction supersedes but does not erase. | run Attempts, failures and exclusions; protocol Run records. | Pass. Append-only attempt handling is explicit. |
| Lower draw calls without better frame pacing | Performance claims have declared measurement boundaries | State draw-call result and frame observations separately; no GPU or stutter-free claim. | run Performance observations; portfolio case Observed result and Limitations. | Pass. Metrics are not interchangeable. |
| Visual acceptance without Astra comparison | Product and orchestration outcomes remain separate | Visual acceptance recorded for revision; Astra not evaluated. | protocol Outcome separation; portfolio case Separated outcomes. | Pass. No retrospective Astra admission. |
| DOCS_SPECS with no UI | Proportionate semantic acceptance contract; Semantic evidence supplements applicable task gates | Use document scenario walkthroughs; runtime/browser checks not applicable. | protocol When to use; plan Scope; guide §12.10 DOCS_SPECS rule. | Pass. This hub change uses docs evidence only. |
| Standard user without Astra | Product and orchestration outcomes remain separate | Standard SDD phases and local tools remain usable without installing Astra. | protocol Consumer handoff and Outcome separation; README index links standard workflow. | Pass. Astra remains optional and separate. |
| Absent local source/raw artifact | Durable revision-bound run evidence | Disclose the gap and limit the claim; do not reconstruct missing observations. | protocol Run records; plan Evidence retention; portfolio case Limitations. | Pass. Local case says raw early attempts are not append-only/portable. |

No failed row remains open.

## Mirror inventory

| Copy | Reviewed guidance |
|---|---|
| `.cursor/skills/openspec-propose/SKILL.md` | Enriched task bullets now require semantic evidence planning when applicable. |
| `.claude/skills/openspec-propose/SKILL.md` | Equivalent to Cursor propose skill. |
| `.cursor/commands/opsx-propose.md` | Equivalent propose command body updated. |
| `.claude/commands/opsx/propose.md` | Equivalent propose command body updated. |
| `.cursor/skills/openspec-apply-change/SKILL.md` | Task execution now requires current passing semantic evidence before checking applicable tasks. |
| `.claude/skills/openspec-apply-change/SKILL.md` | Equivalent to Cursor apply skill. |
| `.cursor/commands/opsx-apply.md` | Equivalent apply command body updated. |
| `.claude/commands/opsx/apply.md` | Equivalent apply command body updated. |

## Limitations

- Graphify and GitNexus were consulted but stale/degraded; direct current files supplied the authoritative evidence for this documentation-only apply.
- The portfolio raw artifacts are local to `C:/apps/pedrocode.art` and not committed in this hub.
- No product-validation protocol/template payload, CI workflow, G4 metrics script, installer, consumer APP code, Astra activation or archive was performed. The existing kit guide mirror and its manifest checksum were synchronized to satisfy release-readiness parity; no kit version or installer behavior changed.
