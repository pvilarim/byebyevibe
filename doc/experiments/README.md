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
