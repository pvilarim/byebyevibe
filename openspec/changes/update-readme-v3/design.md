# Design — update-readme-v3

## D1. Compare removal mechanics

Delete the `## Compare (summary)` heading, the stars-disclaimer line, and the 6-row star table (`README.md:122–133`). Two pieces survive elsewhere:

- The full-table link (`doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`) — already present in the Docs table row 5; no move needed.
- The line "We **compose** OpenSpec; we don't replace it." — relocate into "Stack & companions" as the section's first line. It carries positioning weight independent of the star table.

## D2. Gap-aware bullet (Why install this)

Append as the sixth bullet, matching the existing `**Bold lead** — clause` pattern:

> - **Gap-aware** — notices when you keep re-teaching the same facts (offers a skill) or narrating manual steps (offers a CLI/MCP integration) — offer-only, never creates or installs anything unprompted

The trailing disclaimer is normative, not decorative: it is what keeps the bullet inside the no-ML-claims register that `sdd-discovery-positioning` already enforces for the Calibrate section, extended to gap-aware content by this change's delta.

## D3. Calibrate as you go — extension paragraph

Insert after the existing metrics paragraph, before the `bash scripts/sdd-metrics.sh` block:

> The same posture covers memory and integrations: re-teach the agent the same domain facts and it offers to save a skill; watch it fall back to manual steps for the same external tool twice and it offers a CLI/MCP integration — `bash scripts/verify-infra.sh` reports which integrations are configured, missing, or declined. Everything is offer-only: nothing is created or installed without your decision.

Rationale: Calibrate is the "system observes itself" section; metrics/skills/tooling are one gesture (control plane audits itself, operator decides). Mechanism detail stays in `doc/sdd-operator-day1.md` §7–§8 — README carries the promise, day-1 doc carries the mechanics (existing division of labor).

## D4. Spec delta shape

- **MODIFIED** "Root README v2 section order and above-fold value": section list drops `Compare`; adds the constraint that the competitive evaluation doc remains linked from the Docs table (so removal never orphans the research artifact). Requirement name kept verbatim (rename would churn cross-references for no behavior gain).
- **ADDED** "Root README names gap-aware detection with offer-only framing": README must mention both detection mechanisms and must frame them offer-only / non-ML. Guards against future editorial drift in either direction (deleting the content or overselling it).

## D5. What this change deliberately does not touch

`doc/avaliacoes/` (lasting artifact + index), `doc/sdd-operator-day1.md`, all kit templates (root README is hub-only — verified: `sdd-kit/templates/README.md` does not exist), MANIFEST/checksums, day-1 §8 renumbering.
