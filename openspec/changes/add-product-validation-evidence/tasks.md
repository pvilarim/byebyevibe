## 1. Protocol and reusable evidence

- [x] 1.1 Publish `doc/experiments/product-validation.md` with the scoped contract, workflow, measurement modes, tool readiness and outcome separation.
  - **Pattern:** `doc/experiments/astra-orchestration-pilot.md`
  - **Gate:** `test -s doc/experiments/product-validation.md && npx openspec validate add-product-validation-evidence --strict --no-interactive`
  - **Evidence:** Record a requirement-to-section review in `openspec/changes/add-product-validation-evidence/semantic-review.md`; verify standard/non-Astra and DOCS_SPECS examples. Gate success alone is insufficient.

- [x] 1.2 Add `product-validation-plan.md` and `product-validation-run.md` under `doc/experiments/templates/` with revision identity, scenario results, sampling boundaries and retained attempts.
  - **Pattern:** `doc/experiments/templates/astra-pilot-registration.md`, `doc/experiments/templates/astra-pilot-run.md`
  - **Gate:** `test -s doc/experiments/templates/product-validation-plan.md && test -s doc/experiments/templates/product-validation-run.md`
  - **Evidence:** Walk through a failed first attempt, superseding correction, unavailable artifact and source edit; show that templates preserve uncertainty and prevent stale acceptance. No fabricated populated trial.

## 2. Standard workflow guidance

- [x] 2.1 Link the protocol/templates in the experiments index and guide §12.10; update hub propose/apply skill mirrors and duplicated commands with the semantic-evidence completion rule.
  - **Pattern:** `doc/experiments/README.md`, `doc/byebyevibe-guide.md`, `.cursor/skills/openspec-propose/SKILL.md`, `.cursor/skills/openspec-apply-change/SKILL.md`
  - **Gate:** `npx openspec validate add-product-validation-evidence --strict --no-interactive && bash scripts/verify-task-patterns.sh`
  - **Evidence:** Inventory `.cursor/skills/` and `.claude/skills/` propose/apply bodies plus `.cursor/commands/opsx-propose.md`, `.cursor/commands/opsx-apply.md`, `.claude/commands/opsx/propose.md`, `.claude/commands/opsx/apply.md`; verify pointers or equivalent guidance in each actual copy and record the review. Preserve deterministic Gate and existing handoff/approval semantics.
  - **Invariants:** No kit payload, CI, G4, consumer application or installer changes; no new always-on rule.

## 3. Case evidence and semantic validation

- [x] 3.1 Publish `doc/experiments/product-validation-portfolio-case.md` with source identifiers, approved product scope, observed measurements and evidence limitations; link it from the protocol.
  - **Gate:** `test -s doc/experiments/product-validation-portfolio-case.md && npx openspec validate add-product-validation-evidence --strict --no-interactive`
  - **Evidence:** Verify accessible consumer report and hashes identified in design; disclose inaccessible or missing raw attempts rather than claiming retrospective reproduction. Record visual acceptance separately from performance certainty and Astra not-evaluated status.

- [x] 3.2 Complete the adversarial semantic walkthrough in `semantic-review.md` for every case listed in design and resolve failures before completion.
  - **Gate:** `test -s openspec/changes/add-product-validation-evidence/semantic-review.md && npx openspec validate --all --strict --no-interactive && bash scripts/verify-task-patterns.sh && git diff --check`
  - **Evidence:** Each row must cite requirement, expected decision, actual artifact fields, observed disposition and reviewer. Include knowledge-tool readiness and remaining limitations. Passing commands or headings do not replace this review; any failed/unreviewed required row keeps this task unchecked.

All tasks are future apply work. Register/check the local worktree before apply and release on completion/pause under existing coordination rules. No archive, commit or release is authorized by this checklist.
