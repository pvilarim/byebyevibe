## Why

`.github/workflows/sdd-gates.yml` runs `bash sdd-kit/verify.sh` with `continue-on-error: true` because that single step also runs `scripts/verify-infra.sh`, which legitimately reports FAIL for knowledge CLIs (GitNexus, Graphify) that most CI runners don't have installed. The side effect: the version-sync check and the MANIFEST checksum-integrity check — both pure repo-state facts, unrelated to which CLIs a runner happens to have — currently share that same exit code, so neither one blocks a PR either. This was left open deliberately (Q1 in the version-sync gate's own design doc) as "advisory, revisit if drift recurs." It needs revisiting now because two follow-on efforts (an automated multi-agent review pipeline, and tagged GitHub Releases — issues #349 and #350) both depend on a green `master` actually meaning "safe to release," which today it doesn't for this class of failure.

## What Changes

- Extract the repo-state checks currently inlined in `sdd-kit/verify.sh` — version-sync (kit README/guide headers vs. `MANIFEST.yaml`), kit-integrity (template checksum parity), and hub scripts↔templates parity — into a new standalone script, `scripts/verify-release-readiness.sh`, with its own exit code covering only these checks.
- `sdd-kit/verify.sh` calls the new script instead of inlining the logic. Its console output and its existing contribution to `verify.sh`'s overall exit code are unchanged — no behavior change for existing consumers of `verify.sh`.
- `.github/workflows/sdd-gates.yml` (hub, and the `sdd-kit/templates/` mirror shipped to consumers) gains a new step that runs `scripts/verify-release-readiness.sh` directly, with no `continue-on-error`. This step never touches `verify-infra.sh` or any GitNexus/Graphify presence check, so it cannot produce the false positives that motivated the existing step's advisory posture.
- **BREAKING (opt-in, manual):** the new step only blocks merges once an operator adds it as a required status check under branch protection — the same `[MANUAL ACTION REQUIRED]` pattern already documented for the existing "SDD Gates" check. No repo is blocked by default from this change alone.
- `sdd-kit/MANIFEST.yaml` gains the new script as a tracked template entry (`scripts/verify-release-readiness.sh`), checksums regenerated, version bumped (minor — new CI-blocking behavior, per the kit's own precedent for what counts as a minor release).
- Changelog entry added to `doc/byebyevibe-guide.md` §14.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `sdd-ci-gates`: adds a requirement that a release-readiness check (version-sync + kit-integrity) runs as a blocking CI step, independent of and unaffected by the existing report-only `sdd-kit verify` step.

## Impact

- `sdd-kit/verify.sh` — refactored to call the extracted script; behavior and exit-code contribution unchanged.
- New `scripts/verify-release-readiness.sh` + `sdd-kit/templates/scripts/verify-release-readiness.sh` mirror.
- `.github/workflows/sdd-gates.yml` + `sdd-kit/templates/.github/workflows/sdd-gates.yml` — new step.
- `sdd-kit/MANIFEST.yaml` — new tracked entry, regenerated checksums, version bump.
- `doc/byebyevibe-guide.md` — §2.12 (CI gates operation) and §14 (changelog).
- Branch protection settings (GitHub UI) — manual operator action, outside this repo's files.
- Consumer repos see no behavior change until they run the C2 upgrade **and** the operator opts the new check into required status checks.

**Issue:** https://github.com/pvilarim/byebyevibe/issues/348
