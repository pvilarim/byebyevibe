# Tasks — add-probity-tdd-module

> Apply scope after human approval (R7/R11). **Mandatory pilot** (Phase 2) in an APP worktree before promoting MANIFEST — see quantified criteria in `design.md`.

## 0. Pilot (Phase 2 — APP repo worktree, before MANIFEST)

- [x] 0.1 Run pilot in APP worktree with Vitest or pytest: C1 + GitNexus + Graphify + Probity; measure PreToolUse p95 latency (< 8s), type C false positives (< 15%), type B R6 (100%), Cursor hooks
  - **Pattern:** `openspec/changes/add-probity-tdd-module/design.md`
  - **Gate:** `test -f openspec/changes/add-probity-tdd-module/design.md && grep -q 'p95' openspec/changes/add-probity-tdd-module/design.md`

- [x] 0.2 Record pilot result in a note in the change or issue; if failed → "Deferred" status in G2 evaluation and do not proceed to §6 MANIFEST bump
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Gate:** `grep -q 'Probity' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md || echo 'PENDING apply'`

## 1. sdd-kit — script and templates (R6)

- [x] 1.1 Create `sdd-kit/templates/install-probity-module.sh` with `--detect`, `--dry-run`, `--apply`, `--yes`, `--uninstall`, `--repo`; detect vitest/jest/pytest; SKIP DOCS_SPECS without test runner
  - **Pattern:** `sdd-kit/install-ui-module.sh`
  - **Gate:** `test -f sdd-kit/templates/install-probity-module.sh`

- [x] 1.2 Copy/symlink to executable `sdd-kit/install-probity-module.sh`
  - **Pattern:** `sdd-kit/install-ui-module.sh`
  - **Gate:** `test -x sdd-kit/install-probity-module.sh`

- [x] 1.3 Create `sdd-kit/templates/probity.config.ts` with `enforceTdd()` (SDD R6 addendum), prod+test globs, doc/openspec/sdd-kit exclusions, `forbidCommandPattern(/rm\s+-rf/)`
  - **Pattern:** `openspec/changes/add-probity-tdd-module/design.md`
  - **Gate:** `test -f sdd-kit/templates/probity.config.ts && grep -q 'enforceTdd' sdd-kit/templates/probity.config.ts`

- [x] 1.4 Create `sdd-kit/templates/doc/design/004-probity-module-install.md` (install, plugin, pilot, Cursor, rollback, lint opt-in)
  - **Pattern:** `sdd-kit/templates/doc/design/002-ui-module-install.md`
  - **Gate:** `test -f sdd-kit/templates/doc/design/004-probity-module-install.md`

- [x] 1.5 Update `sdd-kit/README.md`: Probity scenario (G2), install command, pin `@nizos/probity@1.10.0`
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `grep -qi 'install-probity-module' sdd-kit/README.md`

- [x] 1.6 Add entries in `sdd-kit/MANIFEST.yaml` (`install-probity-module.sh`, `probity.config.ts` template, `004-probity-module-install.md`) with `profiles: [APP, HYBRID]`; run `bash sdd-kit/gen-manifest-checksums.sh`
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -q 'install-probity-module' sdd-kit/MANIFEST.yaml && bash sdd-kit/gen-manifest-checksums.sh`

- [x] 1.7 Add Probity check in `sdd-kit/verify.sh` (report-only if module not installed)
  - **Pattern:** `sdd-kit/verify.sh`
  - **Gate:** `grep -q 'probity' sdd-kit/verify.sh`

## 2. openspec/infra.md (R1)

- [x] 2.1 Add "Probity Module" section in `openspec/infra.md` and template: `@nizos/probity@1.10.0`, SKIP (hub) or ✅ status, `test -f probity.config.ts`
  - **Pattern:** `openspec/infra.md`
  - **Gate:** `grep -q 'probity' openspec/infra.md`

- [x] 2.2 Mirror section in `sdd-kit/templates/openspec/infra.md` (if template exists) or document merge in install script
  - **Pattern:** `sdd-kit/templates/openspec/infra.md`
  - **Gate:** `test -f sdd-kit/templates/openspec/infra.md && grep -q 'probity' sdd-kit/templates/openspec/infra.md || test -f sdd-kit/templates/install-probity-module.sh`

## 3. AGENTS.md (R2)

- [x] 3.1 Add ≤10 lines in Integrations Probity (when active, A–E matrix, install command); update review pipeline: `tests (R6/Probity enforceTdd)` → correctness-review → …
  - **Pattern:** `AGENTS.md`
  - **Gate:** `grep -q 'Probity' AGENTS.md && grep -q 'enforceTdd' AGENTS.md`

- [x] 3.2 Update `sdd-kit/templates/AGENTS.core.md` with the same lines
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Gate:** `grep -q 'Probity' sdd-kit/templates/AGENTS.core.md`

## 4. Optional skill (R3 — only if AGENTS.md Integrations >10 lines after 3.1)

- [x] 4.1 If needed: create `.claude/skills/probity-guard/SKILL.md` + mirror `.cursor/skills/probity-guard/SKILL.md` (enforceTdd troubleshooting, override, uninstall)
  - **Pattern:** `.claude/skills/correctness-review/SKILL.md`
  - **Gate:** `test -f .claude/skills/probity-guard/SKILL.md || ! grep -c 'Probity' AGENTS.md | awk '{exit ($1>10)?1:0}'`

## 5. Canonical guide — human operation (R4)

- [x] 5.1 Add §2.16 "Probity Module (G2)" in `doc/sistema-sdd-pedro.md`: install plugin, pilot, Cursor third-party hooks, disable (globs/uninstall), troubleshooting, rollback; renumber §2.14 github-mcp if needed
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q 'Probity' doc/sistema-sdd-pedro.md && grep -q '2.16' doc/sistema-sdd-pedro.md`

- [x] 5.2 Update "TDD Guard" → "Probity" references in pipeline §2.14 correctness-review
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `! grep -q 'TDD Guard' doc/sistema-sdd-pedro.md || grep -q 'Probity' doc/sistema-sdd-pedro.md`

## 6. Doc migration TDD Guard → Probity (canonical list)

- [x] 6.1 `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G2 → Probity; TDD Guard supersession note; pilot; link change `add-probity-tdd-module`
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Gate:** `grep -q 'Probity' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md && grep -q 'superseded' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`

- [x] 6.2 `doc/avaliacoes/README.md`: index line 2026-07-25 → "Probity (G2)" instead of TDD Guard
  - **Pattern:** `doc/avaliacoes/README.md`
  - **Gate:** `grep -q 'Probity' doc/avaliacoes/README.md`

- [x] 6.3 `openspec/changes/explore-oss-coverage-gaps/research.md`: G2 candidate Probity; matrix; impl. order #5; risks; links; TDD Guard historical note
  - **Pattern:** `openspec/changes/explore-oss-coverage-gaps/research.md`
  - **Gate:** `grep -q 'Probity' openspec/changes/explore-oss-coverage-gaps/research.md`

- [x] 6.4 `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`: all "TDD Guard" refs → "Probity (G2)"; toggle → globs/disable module
  - **Pattern:** `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`
  - **Gate:** `grep -q 'Probity' openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md && ! grep -q 'TDD Guard' openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`

- [x] 6.5 `openspec/project.md`: G2/Probity cross-reference if applicable (only if mentioning TDD — verify; add optional tests+Probity line)
  - **Pattern:** `openspec/project.md`
  - **Gate:** `grep -q 'Probity' openspec/project.md || ! grep -q 'TDD' openspec/project.md`

- [x] 6.6 Update correctness-review skills: `.claude/skills/correctness-review/SKILL.md` and `.cursor/skills/correctness-review/SKILL.md` — pipeline "R6/Probity" instead of "R6/TDD Guard"
  - **Pattern:** `.claude/skills/correctness-review/SKILL.md`
  - **Gate:** `grep -q 'Probity' .claude/skills/correctness-review/SKILL.md`

## 7. Specs (promote after apply)

- [x] 7.1 Promote `openspec/changes/add-probity-tdd-module/specs/sdd-probity-module/spec.md` → `openspec/specs/sdd-probity-module/spec.md`
  - **Pattern:** `openspec/specs/sdd-ui-module/spec.md`
  - **Gate:** `test -f openspec/specs/sdd-probity-module/spec.md`

- [x] 7.2 Apply `sdd-correctness-review` delta in `openspec/specs/sdd-correctness-review/spec.md` (R6/Probity pipeline)
  - **Pattern:** `openspec/specs/sdd-correctness-review/spec.md`
  - **Gate:** `grep -q 'Probity' openspec/specs/sdd-correctness-review/spec.md`

## 8. Evaluation (R5)

- [x] 8.1 Update G2 in `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` to "Adopted" after pilot + archive (pending until then: "Adopted — change add-probity-tdd-module, pilot pending")
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Gate:** `grep -q 'add-probity-tdd-module' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`

## 9. Validation

- [x] 9.1 Run `scripts/verify-task-patterns.sh` on this `tasks.md`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [x] 9.2 Validate change with openspec CLI
  - **Pattern:** `openspec/changes/add-probity-tdd-module/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-probity-tdd-module --strict`

## 10. Post-register (best-effort)

- [x] 10.1 `graphify update .` + `npx gitnexus analyze --force` if available
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify ❌ in infra.md)'`
