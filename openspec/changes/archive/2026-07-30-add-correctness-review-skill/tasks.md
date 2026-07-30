# Tasks — add-correctness-review-skill

> Apply scope after human approval (R7/R11). G7 qualifies for pilot exception: Phase 1 → Phase 3 direct (no new binary/hook; user confirmed pilot waived).

## 1. Skill files (R3)

- [x] 1.1 Create `.claude/skills/correctness-review/SKILL.md` with: frontmatter (name/description/license/metadata), When to invoke sections (A–E matrix), Output format (tags logic/edge/contract/race/silent, verdicts CORRECT/RISKY/INSUFFICIENT SCOPE), Boundaries (never flag), SDD integration and Useful commands
  - **Pattern:** `.claude/skills/simplify-review/SKILL.md`
  - **Invariants:** `sdd-correctness-review` — Skill file exists in canonical locations; Skill targets correctness exclusively; Skill uses standardised output format
  - **Gate:** `test -f .claude/skills/correctness-review/SKILL.md`

- [x] 1.2 Create `.cursor/skills/correctness-review/SKILL.md` as identical copy of item 1.1
  - **Pattern:** `.cursor/skills/simplify-review/SKILL.md`
  - **Invariants:** `sdd-correctness-review` — Skill file exists in canonical locations
  - **Gate:** `diff .claude/skills/correctness-review/SKILL.md .cursor/skills/correctness-review/SKILL.md`

## 2. AGENTS.md (R2)

- [x] 2.1 Update "Post-implementation reviews" section in `AGENTS.md`: add `correctness-review` line with pipeline position (before `simplify-review`) and when to invoke/not invoke per A–E matrix; update pipeline order line
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-correctness-review` — Pipeline position is documented; Skill is invoked on-demand only
  - **Gate:** `grep -q 'correctness-review' AGENTS.md`

## 3. openspec/infra.md (R1)

- [x] 3.1 Add `correctness-review` line in the Skills section of `openspec/infra.md` (path, review phase, status ✅)
  - **Pattern:** `openspec/infra.md`
  - **Invariants:** `sdd-workspace-manifest` — Skills section lists all active review skills; `sdd-correctness-review` — Skill is registered in all 6 contract points
  - **Gate:** `grep -q 'correctness-review' openspec/infra.md`

## 4. Canonical guide — human operation (R4)

- [x] 4.1 Add `correctness-review` subsection in `doc/sistema-sdd-pedro.md` (logical position after `simplify-review`): when to trigger, how to read output (tags, verdicts), when not to trigger, troubleshooting
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Invariants:** `sdd-correctness-review` — Skill is registered in all 6 contract points
  - **Gate:** `grep -q 'correctness-review' doc/sistema-sdd-pedro.md`

## 5. Evaluation (R5)

- [x] 5.1 Update `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G7 → "Adopted — local skill created, change `add-correctness-review-skill`" + reference to this change + re-evaluation conditions (conversion to subagent, PR-Agent phase 2)
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Invariants:** `sdd-correctness-review` — Skill is registered in all 6 contract points
  - **Gate:** `grep -q 'add-correctness-review-skill' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`

## 6. sdd-kit (R6) and spec

- [x] 6.1 Add manual installation note in `sdd-kit/README.md` (analogous to `simplify-review`): skill file paths, no automatic script in this phase, and that apply promotes the spec to `openspec/specs/`
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `grep -qi 'correctness-review' sdd-kit/README.md`

- [x] 6.2 Promote `openspec/changes/add-correctness-review-skill/specs/sdd-correctness-review/spec.md` to `openspec/specs/sdd-correctness-review/spec.md`
  - **Pattern:** `openspec/specs/sdd-ci-gates/spec.md`
  - **Invariants:** `sdd-correctness-review` — Skill is registered in all 6 contract points
  - **Gate:** `test -f openspec/specs/sdd-correctness-review/spec.md`

## 7. Validation

- [x] 7.1 Run `scripts/verify-task-patterns.sh` on this `tasks.md`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [x] 7.2 Validate change with openspec CLI
  - **Pattern:** `openspec/changes/add-correctness-review-skill/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-correctness-review-skill 2>/dev/null || test -f openspec/changes/add-correctness-review-skill/tasks.md`

## 8. Post-register (best-effort)

- [x] 8.1 `graphify update .` + `npx gitnexus analyze --force` if available
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify ❌ in infra.md)'`
