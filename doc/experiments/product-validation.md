# Product validation evidence

Product validation is the standard SDD evidence contract for observable product behavior. It is optional by scope, proportional to the changed behavior and usable without Astra, browser automation or a central runtime. OpenSpec requirements and the change's `tasks.md` remain the authority; validation evidence records facts that support task completion.

Sources: [change design](../../openspec/changes/add-product-validation-evidence/design.md), [product-validation spec](../../openspec/changes/add-product-validation-evidence/specs/sdd-product-validation/spec.md), [task-patterns spec](../../openspec/changes/add-product-validation-evidence/specs/sdd-task-patterns/spec.md), [task guidance](../byebyevibe-guide.md#1210-template-openspecchangesidtasksmd-patterns-and-gates), [tooling guidance](../../openspec/specs/sdd-tooling-guidance/spec.md), [CI gates](../../openspec/specs/sdd-ci-gates/spec.md), [metrics](../../openspec/specs/sdd-metrics/spec.md), [session handoff](../../openspec/specs/sdd-session-handoff/spec.md) and [coordination](../../openspec/specs/sdd-session-coordination/spec.md).

## When to use

Use this protocol when a task changes runtime behavior, user-visible UI, recovery behavior, performance claims or other semantic outcomes that a deterministic shell command alone cannot prove. Documentation-only changes can use semantic walkthrough scenarios without a browser. Unrelated one-line edits do not need a validation dossier.

Do not use this protocol to replace OpenSpec, promote evidence files into a second done ledger, introduce a universal visual CI job, add G4 metrics, install tooling silently, activate Astra, migrate a consumer release or approve a deployment.

## Plan before collection

Create a plan from [templates/product-validation-plan.md](templates/product-validation-plan.md) before relying on evidence for task completion. The plan maps changed behavior to OpenSpec scenarios and records:

- affected requirements and tasks;
- scenario applicability, expected observation, method, owner and acceptance criterion;
- deterministic Gate commands that still need to pass;
- required tools, current readiness and accepted fallback;
- evidence location and retention;
- measurement boundaries for any performance comparison.

Every scenario is one of pass, fail, not run or not applicable. Not applicable needs a reason. Not run and fail do not count as acceptance.

## Run records

Create one run record per attempt from [templates/product-validation-run.md](templates/product-validation-run.md). Run evidence is revision-bound and append-only. It records the plan revision, repository, base revision, tested revision or dirty-content hashes, time, environment, commands or manual procedure, expected and observed outcomes, reviewer, failures, exclusions and evidence locations.

Corrections append a superseding record rather than replacing the failed attempt. Missing screenshots, measurements, logs or source material are disclosed with the claim limited to what remains reviewable. If source changes after validation affect the scenario, repeat the affected check or explicitly justify evidence reuse by unchanged scope.

Compact safe receipts should be durable in the consumer change. Large or private raw artifacts may stay in controlled storage when the record includes digest, access instructions and retention limits.

## Measurement modes

Exploratory observations can guide decisions but cannot become a retrospective registered acceptance comparison. Label them as observations and list limitations.

Prospective performance comparisons must freeze before collection: metrics and units, baseline and candidate identity, target or tolerance, environment, warm-up, sample duration, repetition and stopping policy, randomness or seed, cache and run-order policy. CPU time, GPU time, draw calls and frame pacing are separate metrics. Headless browser results, visible-browser checks, mobile emulation and physical-device results must be labeled separately. Missing measurements make the corresponding conclusion inconclusive.

No universal FPS, draw-call or timing threshold applies to every product.

## Tool readiness

Follow the existing tooling cascade: session operator override, configured CLI, configured MCP, capped configuration suggestion and manual instructions. Record tool availability, index freshness, failures, fallback method and uncovered scope. Do not bypass certificate validation or silently install dependencies.

An equivalent manual check can establish the scenarios it actually observes. If the required observation is still missing, the dependent scenario remains not run or blocked.

## Outcome separation

Record product behavior, human visual acceptance, performance conclusions and orchestration outcomes separately. Human acceptance of a visual revision does not establish a performance guarantee, deployment approval or Astra result. Astra claims require a separately approved Astra protocol, configuration, budget and comparison.

## Consumer handoff

1. Keep the plan and run records in the consumer change, commonly under `openspec/changes/<change-id>/evidence/product-validation/<run-id>/`.
2. Pin this hub protocol and templates by accessible revision when copying them outside the hub.
3. Replace hub-relative links with revision-pinned source links or consumer-relative evidence links.
4. Preserve failed attempts and explicit not-run/not-applicable decisions.
5. Complete the change task only when the deterministic Gate passes and all required scenarios have passing, current evidence for the affected revision.

See also the [portfolio case note](product-validation-portfolio-case.md), which illustrates why structural checks, visual acceptance, performance observations and Astra outcomes must stay separate.
