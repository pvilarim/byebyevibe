## 1. Protocol

- [ ] 1.1 Write `doc/experiments/astra-orchestration-pilot.md` following design D1–D8: H1–H7, functional stage, controlled topology comparisons, separate routing stage, knowledge triggers, authority/ownership, limits, recovery and roadmap decisions. Include sections `## Trial admission`, `## Hypotheses`, `## Comparisons`, `## Recovery`, `## Knowledge tools`, and `## Consumer handoff`.
  - **Pattern:** `doc/i18n/CURSOR-AUTOMATIONS.md`
  - **Invariants:** one run per phase; no APP execution in hub; two active workers maximum initially
  - **Forbidden:** runtime implementation; disabling mandatory graph checks; invented results
  - **Gate:** `test -s doc/experiments/astra-orchestration-pilot.md && for h in 'Trial admission' Hypotheses Comparisons Recovery 'Knowledge tools' 'Consumer handoff'; do grep -q "^## $h" doc/experiments/astra-orchestration-pilot.md || exit 1; done && for n in 1 2 3 4 5 6 7; do grep -q "H$n" doc/experiments/astra-orchestration-pilot.md || exit 1; done`

## 2. Evidence templates

- [ ] 2.1 Create `doc/experiments/templates/astra-pilot-registration.md` with all D2/D6 required fields and a `## Admission checklist`; unresolved execution inputs remain visibly NOT READY. Include numeric budget/unit, elapsed-time/retry limits, acceptance thresholds, authority and host-access checks.
  - **Pattern:** `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`
  - **Forbidden:** pre-approved consumer, fabricated budget, launching trials
  - **Gate:** `test -s doc/experiments/templates/astra-pilot-registration.md && grep -q '^## Admission checklist' doc/experiments/templates/astra-pilot-registration.md && grep -q 'NOT READY' doc/experiments/templates/astra-pilot-registration.md`

- [ ] 2.2 Create `doc/experiments/templates/astra-pilot-run.md` with D6 identity, phase/status, revision, authority, knowledge, tests, findings, interventions and usage fields. Include sections `## Identity`, `## Evidence`, `## Findings`, `## Recovery`, `## Usage`, `## Outcome`; use explicit unknown/not measured placeholders.
  - **Pattern:** `openspec/changes/evaluate-astra-orchestration-readiness/research.md`
  - **Forbidden:** raw secrets; claiming temporary session JSON is durable run history; token estimates from prose
  - **Gate:** `test -s doc/experiments/templates/astra-pilot-run.md && for h in Identity Evidence Findings Recovery Usage Outcome; do grep -q "^## $h" doc/experiments/templates/astra-pilot-run.md || exit 1; done`

- [ ] 2.3 Create `doc/experiments/templates/astra-pilot-decision.md` with H1–H7, all runs/failures, quality gates, full costs, limitations, and roadmap choices. Include sections `## Hypothesis results`, `## Quality gates`, `## Costs and effort`, `## Limitations`, `## Decision` and an inconclusive option.
  - **Pattern:** `doc/avaliacoes/TEMPLATE.md`
  - **Forbidden:** declaring superiority or savings without comparable measurements; omitting failed trials
  - **Gate:** `test -s doc/experiments/templates/astra-pilot-decision.md && for h in 'Hypothesis results' 'Quality gates' 'Costs and effort' Limitations Decision; do grep -q "^## $h" doc/experiments/templates/astra-pilot-decision.md || exit 1; done && grep -qi inconclusive doc/experiments/templates/astra-pilot-decision.md`

## 3. Discovery and readiness

- [ ] 3.1 Create `doc/experiments/README.md` linking the protocol and all three templates; link the protocol to the consolidated research and document the separate consumer proposal/registration handoff. Verify each new local Markdown link resolves. Preserve existing remote drafts and kit files.
  - **Pattern:** `doc/avaliacoes/README.md`
  - **Gate:** `test -s doc/experiments/README.md && grep -q 'astra-orchestration-pilot.md' doc/experiments/README.md && for f in registration run decision; do test -s "doc/experiments/templates/astra-pilot-$f.md" && grep -q "templates/astra-pilot-$f.md" doc/experiments/README.md || exit 1; done`

- [ ] 3.2 Desk-review the package against every new requirement and the six D9 scenarios. Record section links, expected results, detected mismatches and their resolution in `openspec/changes/add-astra-orchestration-pilot/readiness-review.md`, using sections `## Requirement coverage`, `## Scenario walkthrough`, `## Remaining execution inputs`. Label it a desk review, state trials are not measured, and leave actual consumer results unpopulated. Structural checks do not replace this content review.
  - **Pattern:** `openspec/changes/add-astra-orchestration-pilot/specs/sdd-astra-orchestration-pilot/spec.md`
  - **Gate:** `test -s openspec/changes/add-astra-orchestration-pilot/readiness-review.md && for h in 'Requirement coverage' 'Scenario walkthrough' 'Remaining execution inputs'; do grep -q "^## $h" openspec/changes/add-astra-orchestration-pilot/readiness-review.md || exit 1; done && grep -qi 'desk review' openspec/changes/add-astra-orchestration-pilot/readiness-review.md`

- [ ] 3.3 Run strict change/global validation and task-pattern checks; confirm the package remains documentation-only, the kit is unchanged, and no trial/adoption outcome is asserted. Release the apply session at handoff according to R11.
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `openspec validate add-astra-orchestration-pilot --strict --no-interactive && openspec validate --all --strict --no-interactive && bash scripts/verify-task-patterns.sh && git diff --check`
