## Context

`sdd-kit/verify.sh` accumulates every check it runs into a single `FAILURES` counter and a single exit code (see `run_check()` and the inline `((FAILURES++))` calls throughout the script). That counter mixes two very different kinds of check:

- **Environment-dependent**: `scripts/verify-infra.sh`, which FAILs on any runner missing GitNexus/Graphify — true on essentially every stock GitHub-hosted runner.
- **Repo-state**: version-sync (kit README/guide headers vs. `sdd-kit/MANIFEST.yaml`), kit-integrity (template checksum parity), and hub scripts↔templates parity — pure facts about the files in the repo, independent of what's installed on the runner.

Because both feed the same exit code, `.github/workflows/sdd-gates.yml` has to run the whole `bash sdd-kit/verify.sh` step with `continue-on-error: true` (see `sdd-ci-gates` spec, "verify-infra.sh runs report-only in CI") — otherwise every CI run would redden on the environment check alone. The repo-state checks ride along as report-only collateral, which is the gap issue #348 opened and this change closes.

Two follow-on efforts depend on this: an automated multi-agent review pipeline (#349) and tagged GitHub Releases (#350). Both need a green `master` to actually mean "safe to release" — today it doesn't for a version-sync or checksum mismatch.

## Goals / Non-Goals

**Goals:**

- Make version-sync + kit-integrity + hub-parity block CI, without reintroducing `verify-infra.sh`'s environment false positives.
- Zero behavior change to `sdd-kit/verify.sh`'s existing local output or exit-code contract.
- Ship through the normal MANIFEST-tracked template path, like any other kit change — no special-casing.

**Non-Goals:**

- Making `verify-infra.sh`'s CLI-presence checks blocking. Still not solvable on stock runners; out of scope here.
- Changing `verify-task-patterns.sh` behavior. Already blocking on DOCS_SPECS, already report-only on APP/UNKNOWN (its own spec, `sdd-task-patterns`) — untouched.
- Auto-configuring branch protection. GitHub repository settings, not a repo file; stays `[MANUAL ACTION REQUIRED]`, same as the existing "SDD Gates" check.
- The review pipeline (#349) or release/tag automation (#350) — separate changes.

## Decisions

### D1 — Extract the checks into a script, don't duplicate them inline

**Chosen:** move version-sync, kit-integrity, and hub-parity out of `sdd-kit/verify.sh` into a new standalone script, `scripts/verify-release-readiness.sh`, with its own independent exit code. `verify.sh` calls it like it already calls `verify-infra.sh` and `verify-task-patterns.sh`.

**Alternative rejected:** leave the logic inline in `verify.sh` and have a new CI step grep the log output for `FAIL:` lines to decide pass/fail. Rejected — turning human-readable log text into a control-flow signal is fragile (a wording change silently breaks the gate), and it doesn't actually avoid the extraction work, it just defers it.

### D2 — Scope of the extracted script

Exactly the three repo-state checks named above. `verify-infra.sh`, the `verify-task-patterns.sh` invocation, session-status, and the Probity/metrics presence checks stay inside `verify.sh` untouched — they either already have correct exit-code semantics of their own (task-patterns) or were never meant to gate CI at all (presence-only INFO/WARN checks).

### D3 — No new hub/consumer branching needed

The extracted script reuses the same guards `verify.sh` already applies: kit-integrity and hub-parity are gated on `-d sdd-kit/templates` (hub-only); version-sync degrades to an INFO skip when `sdd-kit/README.md` or `doc/byebyevibe-guide.md` are absent (the existing D3 degrade table from the version-sync gate's own design). A consumer repo running the new CI step gets INFO-skip lines and a `0` exit, same as it gets from `verify.sh` today — no separate consumer-mode logic required.

### D4 — New CI step, not a modified existing one

Add a step named `Release readiness (blocking)` that runs `scripts/verify-release-readiness.sh` directly, with no `continue-on-error`, alongside the existing `sdd-kit verify (report-only)` step (unchanged). Rejected alternative: drop `continue-on-error` from the existing step. That step's spec requirement ("verify-infra.sh runs report-only in CI") stays true and unmodified either way, but changing the step itself would force re-verifying every check that currently rides inside `verify.sh`'s one exit code, not just the three being promoted here.

### D5 — Minor version bump; this one carries a real file diff

Unlike the mostly-docs 1.10.0 release immediately before it, this change touches two MANIFEST-tracked templates (`scripts/verify-release-readiness.sh` is new; `.github/workflows/sdd-gates.yml` gains a step) — `gen-manifest-checksums.sh` runs, checksums change, and consumers get an actual diff on their next C2 upgrade. Minor bump, per the kit's own precedent (new CI-blocking behavior = minor, not patch).

### D6 — Branch protection stays manual

Consistent with the existing `[MANUAL ACTION REQUIRED]` note for the "SDD Gates" check (`doc/byebyevibe-guide.md` §2.12). This change makes the check exist and pass/fail correctly; it does not and — from inside a workflow running with the default `GITHUB_TOKEN` — cannot flip it to "required" in repository settings.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| A consumer's customized `sdd-kit/README.md` heading has no parseable version token, or the repo lacks `doc/byebyevibe-guide.md` | Existing D3 degrade semantics (WARN/INFO, exit unchanged) carry over unmodified — no new false block |
| Extraction subtly changes which branch increments `FAILURES` inside `verify.sh` | Move the check functions and their call sites verbatim; diff `bash sdd-kit/verify.sh` output on a known-good and a known-bad repo state before/after the refactor |
| Operators never flip branch protection, so the new step is visible but non-blocking in practice | Same gap as "SDD Gates" today; documented identically rather than solved differently for this one check |
| This release lands a real template diff on every DOCS_SPECS/APP consumer's next C2 upgrade, unlike recent docs-only bumps | Expected and acceptable; called out explicitly in the proposal's Impact section |

## Migration Plan

Single commit/PR on this change's branch:

1. Write `scripts/verify-release-readiness.sh` (version-sync + kit-integrity + hub-parity, moved verbatim from `verify.sh`).
2. Point `sdd-kit/verify.sh` at the new script; remove the now-duplicated inline logic.
3. Mirror both into `sdd-kit/templates/scripts/verify-release-readiness.sh` and update `.github/workflows/sdd-gates.yml` (hub + `sdd-kit/templates/` copy) with the new blocking step.
4. `bash sdd-kit/gen-manifest-checksums.sh` to regenerate the two changed/new checksums.
5. Bump `sdd-kit/MANIFEST.yaml` `version:` (minor); bump `guide_version:` too only if §2.12 prose changes.
6. Add the changelog entry in `doc/byebyevibe-guide.md` §14.
7. `bash sdd-kit/verify.sh` locally — must stay green (it's exercising its own refactor).
8. Push; confirm on the resulting `sdd-gates` run that both the old report-only step and the new blocking step appear and report correctly.
9. Separate manual follow-up, not part of this PR: enable the new check as a required status check under branch protection.

Rollback: `git revert` the single commit — restores the inline `verify.sh` logic and removes the new step together, no intermediate broken state.

## Open Questions

None blocking. Whether `verify-task-patterns.sh` should eventually be folded into `verify-release-readiness.sh` too (it's already its own script with its own correct exit semantics) is deliberately left alone — see Non-Goals.
