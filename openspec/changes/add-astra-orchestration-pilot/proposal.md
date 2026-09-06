**Issue:** — (related: #349 automated PR review; not duplicated)

## Why

ByeByeVibe has phase-local agents and documented parallel automation patterns, but no repeatable evidence that Astra-led coordination improves integrated delivery, recovery, operator effort, or cost. The completed exploration supports a bounded experiment before adopting a coordinator runtime, dashboard, or model-routing default.

## What Changes

- Publish a hub-only pilot protocol at `doc/experiments/astra-orchestration-pilot.md`, including H1–H7, staged controls, failure injections, knowledge-tool triggers, phase/approval boundaries, and outcome decisions.
- Provide three reusable Markdown templates under `doc/experiments/templates/`: experiment registration, run evidence, and decision report. Each distinguishes declared intent, observed execution, and missing evidence.
- Add an index at `doc/experiments/README.md` for discovery and link the protocol to the consolidated research.
- Define a consumer handoff: local Codex is the initial host candidate, subject to verifying Astra/tool access; a selected APP consumer supplies actual tasks/tests, a reviewed consumer change, accepted thresholds, and a numeric budget before any run.
- Prepare the experiment; do not execute APP tasks or generate claimed measurements in this DOCS_SPECS hub. A full scheduler and dashboard remain later evidence-driven proposals.

## Capabilities

### New Capabilities

- `sdd-astra-orchestration-pilot`: documented experiment registration, execution boundaries, evidence contract, comparisons, and decision criteria for a bounded orchestration pilot.

### Modified Capabilities

None. Existing handoff, coordination, issue traceability, and metrics requirements remain authoritative.

## Impact

- New documentation: protocol, index, and three templates; an additive spec is promoted at archive.
- Research source: `openspec/changes/evaluate-astra-orchestration-readiness/research.md`, including the recorded H1–H7 experiment.
- No new dependency, service, application code, CI workflow, always-on rule, kit payload, version bump, or persistent supervisor exception.
- No modification/merge of drafts #384–#386. Their product-evidence and consumer-link issues remain separately identified by the research.
- Apply produces a reviewed, usable experiment package. Actual trial execution and any consumer code require a separate consumer change and recorded run authorization; protocol completion is not a successful experiment.
- Sources: specs `sdd-session-handoff`, `sdd-session-coordination`, `sdd-issue-traceability`, `sdd-metrics`; `doc/i18n/CURSOR-AUTOMATIONS.md` sections 1–3; `openspec/project.md` non-goals; consolidated research. Graph consultations were degraded as recorded there, so structural claims use direct source reads.
