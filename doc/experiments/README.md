# Experiments

Experiments prepare evidence for decisions; publishing a protocol is neither execution nor adoption.

## Astra orchestration pilot

Status: experimental, optional, hub documentation only. Consumer trials are not measured.

- [Protocol](astra-orchestration-pilot.md): admission, hypotheses, controlled comparisons, recovery and knowledge evidence.
- [Registration template](templates/astra-pilot-registration.md): required inputs and separate assessment/implementation gates; starts NOT READY.
- [Run evidence template](templates/astra-pilot-run.md): durable attempts, findings, recovery and measured usage.
- [Decision report template](templates/astra-pilot-decision.md): all outcomes, limitations and post-pilot proposal review.

Follow the protocol's [consumer handoff](astra-orchestration-pilot.md#consumer-handoff). Select an APP repository, obtain a reviewed consumer proposal and explicit run authorization, then copy the three templates into that change's own evidence directory. Pin hub sources to a revision containing the reviewed package; do not copy hub development history. This does not install or enable Astra.

Users declining Astra retain the [standard workflow](../byebyevibe-guide.md). Dashboard, optional installation, legacy migration and production model routing remain separately reviewed follow-ups. Routine C2 upgrades cannot silently enable Astra.

## Astra phase-run contract

Status: experimental, optional contract documentation only. Publishing it neither executes the pilot nor enables adoption.

- [Contract](astra-phase-run-contract.md): OpenSpec authority, demand/dependency semantics, immutable admission, ownership, knowledge freshness, restart and receipt projection.
- [Demand-map template](templates/astra-demand-map.md): explicit demand nodes, typed dependency edges and source-backed readiness.
- [Phase-run receipt template](templates/astra-phase-run-receipt.md): immutable attempt lineage with phase/status separation, ownership, checks, recovery and usage coverage.

Consumers copy both templates into their reviewed change's own evidence root and pin a hub revision containing the exact contract and templates. The copies are consumer-owned evidence: replace placeholders with accessible sources and do not depend on mutable hub working-tree state. Pilot execution, Astra enablement/adoption and any control panel remain separate reviewed changes. Non-Astra users continue the standard `/opsx` path without these records.

## Product validation evidence

Status: standard workflow guidance, hub documentation only. It records product behavior evidence without requiring Astra or a universal browser job.

- [Protocol](product-validation.md): scoped semantic acceptance, revision-bound run evidence, measurement limits, tool readiness and outcome separation.
- [Plan template](templates/product-validation-plan.md): maps changed behavior to OpenSpec scenarios, expected observations, methods, owners and acceptance criteria.
- [Run template](templates/product-validation-run.md): records attempts, tested revisions, scenario results, tool readiness, measurements and limitations.
- [Portfolio case note](product-validation-portfolio-case.md): source-backed local example showing visual acceptance and exploratory performance observations without Astra admission.

Use this protocol when applicable task Gates need semantic product evidence before completion. Evidence supplements the OpenSpec task checklist; it does not replace reviewed specs, phase handoffs or explicit human approval.
