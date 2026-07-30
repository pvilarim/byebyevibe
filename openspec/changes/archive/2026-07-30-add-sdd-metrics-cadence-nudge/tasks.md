# Tasks — add-sdd-metrics-cadence-nudge

> Apply scope after human approval (R7). **Prerequisite:** `add-sdd-metrics-script` applied in the hub (`scripts/sdd-metrics.sh` + base §2.17). Pilot exception applies (local bash; no new binary/hook/LLM). **Non-goals:** always-on rule; CI cron; DevLake. **Issue:** —

## 0. Prerequisite

- [x] 0.1 Confirm G4 base is in the hub (executable script + §2.17 section)
  - **Pattern:** `openspec/changes/add-sdd-metrics-script/proposal.md`
  - **Invariants:** dependency on `add-sdd-metrics-script`
  - **Gate:** `test -x scripts/sdd-metrics.sh && grep -q '2.17' doc/sistema-sdd-pedro.md && grep -q 'sdd-metrics' doc/sistema-sdd-pedro.md`

## 1. Interpretation playbook (§2.17)

- [x] 1.1 Add to `doc/sistema-sdd-pedro.md` §2.17 the “Interpret → act” section: M1–M4 → process action table; 1 insight → 1 adjustment ritual; note DevLake remains out of scope
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Invariants:** `sdd-metrics` — Interpretation playbook maps metrics to process actions
  - **Gate:** `grep -q 'Interpretar' doc/sistema-sdd-pedro.md && grep -qE 'M1|M2|M3' doc/sistema-sdd-pedro.md && grep -q 'insight' doc/sistema-sdd-pedro.md`

- [x] 1.2 Document cadence thresholds (N=5 archives, T=30 days) and the archive nudge flow in the same §2.17
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -qE '5|30' doc/sistema-sdd-pedro.md && grep -q 'check-cadence\|cadência\|nudge' doc/sistema-sdd-pedro.md`

## 2. Stamp + --check-cadence in script

- [x] 2.1 Ensure `.sdd/metrics-last-run` is gitignored (entry in `.gitignore`)
  - **Pattern:** `.gitignore`
  - **Invariants:** `sdd-metrics` — Last-run stamp enables cadence checks
  - **Gate:** `grep -qE 'metrics-last-run|\.sdd/' .gitignore`

- [x] 2.2 Extend `scripts/sdd-metrics.sh`: write ISO `YYYY-MM-DD` stamp to `.sdd/metrics-last-run` after exit 0 report; add `--check-cadence` (defaults N=5, T=30; onboarding without stamp per design D2/Open Questions); mirror kit template
  - **Pattern:** `scripts/sdd-session-status.sh`
  - **Invariants:** `sdd-metrics` — Cadence check is advisory and opt-in; Last-run stamp enables cadence checks
  - **Gate:** `grep -q 'check-cadence' scripts/sdd-metrics.sh && grep -q 'metrics-last-run' scripts/sdd-metrics.sh && diff -q scripts/sdd-metrics.sh sdd-kit/templates/scripts/sdd-metrics.sh`

- [x] 2.3 Regenerate MANIFEST checksums if the template changed; bump kit patch if G4 already published 1.6.0 (otherwise align with current version)
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && grep -A6 'sdd-metrics.sh' sdd-kit/MANIFEST.yaml | grep -q 'sha256:'`

- [x] 2.4 Validate cadence check behavior (exit codes)
  - **Pattern:** `scripts/sdd-session-status.sh`
  - **Gate:** `bash scripts/sdd-metrics.sh --help | grep -q 'check-cadence' && (bash scripts/sdd-metrics.sh --check-cadence; ec=$?; test "$ec" -eq 0 -o "$ec" -eq 1)`

## 3. Nudge in Session Handoff (archive)

- [x] 3.1 Update `.claude/skills/openspec-archive-change/SKILL.md`: in post-archive Session Handoff, run `--check-cadence` if the script exists; if nudge due, include ≤5 advisory lines (command + §2.17); never auto-execute report; never fail archive if script absent
  - **Pattern:** `.claude/skills/openspec-archive-change/SKILL.md`
  - **Invariants:** `sdd-session-handoff` — Archive Session Handoff includes metrics cadence nudge when due
  - **Gate:** `grep -q 'check-cadence\|sdd-metrics' .claude/skills/openspec-archive-change/SKILL.md && grep -q '2.17' .claude/skills/openspec-archive-change/SKILL.md`

- [x] 3.2 Mirror in `.cursor/skills/openspec-archive-change/SKILL.md`
  - **Pattern:** `.cursor/skills/openspec-archive-change/SKILL.md`
  - **Gate:** `grep -q 'check-cadence\|sdd-metrics' .cursor/skills/openspec-archive-change/SKILL.md`

## 4. Light discovery (R3 N/A)

- [x] 4.1 Add ≤3 lines to `AGENTS.md` (Integrations / metrics): archive cadence + playbook §2.17; **no** new skill/rule
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-metrics` — Mode C preserved — no always-on metrics skill
  - **Gate:** `grep -q 'sdd-metrics' AGENTS.md && grep -q '2.17' AGENTS.md && ! test -f .cursor/rules/0*metrics*.mdc`

- [x] 4.2 Mirror in `sdd-kit/templates/AGENTS.core.md` if the Metrics section exists / was created by G4
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Gate:** `grep -q 'sdd-metrics' sdd-kit/templates/AGENTS.core.md || grep -q '2.17' sdd-kit/templates/AGENTS.core.md`

## 5. Specs — promotion

- [x] 5.1 Apply `sdd-metrics` and `sdd-session-handoff` deltas in `openspec/specs/` (merge ADDED); if `openspec/specs/sdd-metrics/spec.md` does not exist yet, ensure G4 was promoted first (task 0.1)
  - **Pattern:** `openspec/specs/sdd-session-handoff/spec.md`
  - **Gate:** `grep -q 'check-cadence\|cadence\|playbook\|Interpretation' openspec/specs/sdd-metrics/spec.md && grep -q 'metrics cadence\|sdd-metrics' openspec/specs/sdd-session-handoff/spec.md`

## 6. Validation

- [x] 6.1 Run `bash scripts/verify-task-patterns.sh`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [x] 6.2 Validate change with openspec CLI
  - **Pattern:** `openspec/changes/add-sdd-metrics-cadence-nudge/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-sdd-metrics-cadence-nudge --strict`

## 7. Post-register (best-effort)

- [x] 7.1 `graphify update .` + `npx gitnexus analyze --force` if available
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify ❌ in infra.md)'`
