## 1. Protocol

- [x] 1.1 Write `doc/experiments/astra-orchestration-pilot.md` following design D1–D8: H1–H7, functional stage, controlled topology comparisons, separate routing stage, knowledge triggers, authority/ownership, limits, recovery and roadmap decisions. Include sections `## Trial admission`, `## Hypotheses`, `## Comparisons`, `## Recovery`, `## Knowledge tools`, and `## Consumer handoff`.
  - **Acceptance:** separate H1 demand input from the reserved evaluator reference; record the initial answer before disclosure. Require passed F before T and quality-approved topology selection before M. Include pre-registered sampling/clock/routing rules, H3 usefulness rubric, total H6 effort, H7 unknown/disputed states, and the full D7/D8 fallback matrix with owners and resumption criteria. Preserve separate phase chats and revision-bound approval.
  - **Pattern:** `doc/i18n/CURSOR-AUTOMATIONS.md`
  - **Invariants:** one run per phase; no APP execution in hub; two active workers maximum initially
  - **Forbidden:** runtime implementation; disabling mandatory graph checks; invented results
  - **Gate:** `test -s doc/experiments/astra-orchestration-pilot.md && for h in 'Trial admission' Hypotheses Comparisons Recovery 'Knowledge tools' 'Consumer handoff'; do grep -q "^## $h" doc/experiments/astra-orchestration-pilot.md || exit 1; done && for n in 1 2 3 4 5 6 7; do grep -q "H$n" doc/experiments/astra-orchestration-pilot.md || exit 1; done`

## 2. Evidence templates

- [x] 2.1 Create `doc/experiments/templates/astra-pilot-registration.md` with all D2/D6 required fields and a `## Admission checklist`; unresolved execution inputs remain visibly NOT READY. Include numeric budget/unit, elapsed-time/retry limits, acceptance thresholds, authority and host-access checks.
  - **Acceptance:** distinguish H1 assessment admission from dependent implementation admission; protect the reference map from executor context. Require verified shell/locks/model capabilities, named budget enforcement owner/mechanism, quality tolerance, eligibility/exclusion rules, sample-extension limit and stopping rule, clock boundary and configuration-specific F/T/M admission evidence. Ambiguous approval and unenforceable budget remain NOT READY.
  - **Pattern:** `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`
  - **Forbidden:** pre-approved consumer, fabricated budget, launching trials
  - **Gate:** `test -s doc/experiments/templates/astra-pilot-registration.md && grep -q '^## Admission checklist' doc/experiments/templates/astra-pilot-registration.md && grep -q 'NOT READY' doc/experiments/templates/astra-pilot-registration.md`

- [x] 2.2 Create `doc/experiments/templates/astra-pilot-run.md` with D6 identity, phase/status, revision, authority, knowledge, tests, findings, interventions and usage fields. Include sections `## Identity`, `## Evidence`, `## Findings`, `## Recovery`, `## Usage`, `## Outcome`; use explicit unknown/not measured placeholders.
  - **Acceptance:** distinguish injected stimulus from failed recovery; capture oracle/deadline, ownership/effects reconciliation, approval coverage, invalidated evidence, configuration changes and blocked/resumed work. Separate operator effort categories and end-to-end versus active time; retain failed/contaminated attempts. Include R6 bug triage and required evidence for unknown/disputed status.
  - **Pattern:** `openspec/changes/evaluate-astra-orchestration-readiness/research.md`
  - **Forbidden:** raw secrets; claiming temporary session JSON is durable run history; token estimates from prose
  - **Gate:** `test -s doc/experiments/templates/astra-pilot-run.md && for h in Identity Evidence Findings Recovery Usage Outcome; do grep -q "^## $h" doc/experiments/templates/astra-pilot-run.md || exit 1; done`

- [x] 2.3 Create `doc/experiments/templates/astra-pilot-decision.md` with H1–H7, all runs/failures, quality gates, full costs, limitations, and roadmap choices. Include sections `## Hypothesis results`, `## Quality gates`, `## Costs and effort`, `## Limitations`, `## Decision`, `## Post-pilot proposal review` and an inconclusive option.
  - **Acceptance:** use integrated demand as outcome unit and all eligible attempt costs in the numerator; zero accepted outcomes is undefined. Show exclusions/costs, functional/setup costs and full pilot totals. Require evidence-backed post-pilot improvements/defer decision, preserved standard workflow, reversible opt-in and prohibition of silent legacy C2 enablement. Record migration requirements and dashboard/install/routing boundaries without implementing them.
  - **Pattern:** `doc/avaliacoes/TEMPLATE.md`
  - **Forbidden:** declaring superiority or savings without comparable measurements; omitting failed trials
  - **Gate:** `test -s doc/experiments/templates/astra-pilot-decision.md && for h in 'Hypothesis results' 'Quality gates' 'Costs and effort' Limitations Decision 'Post-pilot proposal review'; do grep -q "^## $h" doc/experiments/templates/astra-pilot-decision.md || exit 1; done && grep -qi inconclusive doc/experiments/templates/astra-pilot-decision.md`

## 3. Discovery and readiness

- [x] 3.1 Create `doc/experiments/README.md` linking the protocol and all three templates; link the protocol to the consolidated research and document the separate consumer proposal/registration handoff. Verify each new local Markdown link resolves. Preserve existing remote drafts and kit files.
  - **Acceptance:** document copy instructions and consumer-owned evidence paths; use revision-pinned hub references in copied records. Check a representative consumer-copy layout and research archive relocation without copying hub history or changing the kit. Record link-check results in the readiness review.
  - **Pattern:** `doc/avaliacoes/README.md`
  - **Gate:** `test -s doc/experiments/README.md && grep -q 'astra-orchestration-pilot.md' doc/experiments/README.md && for f in registration run decision; do test -s "doc/experiments/templates/astra-pilot-$f.md" && grep -q "templates/astra-pilot-$f.md" doc/experiments/README.md || exit 1; done`

- [x] 3.2 Desk-review the package against every new requirement, every task Acceptance clause, and all D9 scenarios, including H1 leakage, F failure, zero accepted outcomes, missing/ambiguous approval, Astra unavailable before/during execution, absent knowledge tools, uncertain ownership, integration conflict, out-of-scope bug, consumer-copy links, H7 unknown/disputed states and opt-in/legacy protections. Record section links, reviewed artifact revisions, detection, decision owner, affected work, preserved evidence, expected results, resumption criteria, detected mismatches and their resolution in `openspec/changes/add-astra-orchestration-pilot/readiness-review.md`, using sections `## Requirement coverage`, `## Scenario walkthrough`, `## Remaining execution inputs`. Label it a desk review, state trials are not measured, and leave actual consumer results unpopulated. Any unresolved normative mismatch blocks readiness; structural checks do not replace this content review.
  - **Pattern:** `openspec/changes/add-astra-orchestration-pilot/specs/sdd-astra-orchestration-pilot/spec.md`
  - **Gate:** `test -s openspec/changes/add-astra-orchestration-pilot/readiness-review.md && for h in 'Requirement coverage' 'Scenario walkthrough' 'Remaining execution inputs'; do grep -q "^## $h" openspec/changes/add-astra-orchestration-pilot/readiness-review.md || exit 1; done && grep -qi 'desk review' openspec/changes/add-astra-orchestration-pilot/readiness-review.md`

- [x] 3.3 Run strict change/global validation and task-pattern checks; confirm the package remains documentation-only, the kit is unchanged, and no trial/adoption outcome is asserted. Release the apply session at handoff according to R11.
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `openspec validate add-astra-orchestration-pilot --strict --no-interactive && openspec validate --all --strict --no-interactive && bash scripts/verify-task-patterns.sh && git diff --check`
