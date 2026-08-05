## 1. Extract the release-readiness checks

- [ ] 1.1 Create `scripts/verify-release-readiness.sh`: move the version-sync (`check_version_claim` + its three call sites), kit-integrity (checksum parity), and hub scripts-to-templates parity blocks out of `sdd-kit/verify.sh` verbatim, with their own independent exit code — the source sections are marked `# Version sync`, `# Kit integrity parity check`, and `# Hub drift gate`.
  - **Pattern:** `sdd-kit/verify.sh`
  - **Gate:** `test -x scripts/verify-release-readiness.sh`
- [ ] 1.2 Update `sdd-kit/verify.sh` to call the new script in place of the inlined logic; console output and `FAILURES` contribution for these checks must be unchanged.
  - **Gate:** `bash sdd-kit/verify.sh` exits 0 on the hub's current clean state (same result as before the refactor)

## 2. Mirror into the kit template and wire CI

- [ ] 2.1 Copy `scripts/verify-release-readiness.sh` to `sdd-kit/templates/scripts/verify-release-readiness.sh`.
  - **Gate:** `diff -q scripts/verify-release-readiness.sh sdd-kit/templates/scripts/verify-release-readiness.sh`
- [ ] 2.2 Add a `Release readiness (blocking)` step to `.github/workflows/sdd-gates.yml` that runs `bash scripts/verify-release-readiness.sh`, placed alongside the existing `sdd-kit verify (report-only)` step but without copying its continue-on-error setting.
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -q 'Release readiness' .github/workflows/sdd-gates.yml`
- [ ] 2.3 Mirror the same step into `sdd-kit/templates/.github/workflows/sdd-gates.yml`.
  - **Gate:** `diff -q .github/workflows/sdd-gates.yml sdd-kit/templates/.github/workflows/sdd-gates.yml`

## 3. MANIFEST tracking

- [ ] 3.1 Add `scripts/verify-release-readiness.sh` as a new entry in `sdd-kit/MANIFEST.yaml` (`merge: COPY`, `profiles: [APP, DOCS_SPECS, HYBRID]`, `gate: "test -x scripts/verify-release-readiness.sh"`), modeled on the sibling entry for `scripts/verify-task-patterns.sh`.
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -q 'verify-release-readiness.sh' sdd-kit/MANIFEST.yaml`
- [ ] 3.2 Regenerate checksums for the new script and the changed `sdd-gates.yml` template.
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh --check`

## 4. Version and changelog

- [ ] 4.1 Bump `sdd-kit/MANIFEST.yaml` `version:` (minor bump — new CI-blocking behavior, per kit precedent).
  - **Gate:** `grep -E '^version: "1\.11\.0"' sdd-kit/MANIFEST.yaml`
- [ ] 4.2 Sync `sdd-kit/README.md` H1 to the new version in the same commit (the version-sync gate must not fail on its own introduction).
  - **Gate:** `grep -q '1.11.0' sdd-kit/README.md`
- [ ] 4.3 Add a dated entry to `doc/byebyevibe-guide.md` `## Guide changelog` describing the new blocking step, the extracted script, and the manual branch-protection follow-up.
  - **Gate:** `grep -q '### 1.11.0' doc/byebyevibe-guide.md`

## 5. Verification

- [ ] 5.1 Run `bash sdd-kit/verify.sh` — must exit 0.
  - **Gate:** `bash sdd-kit/verify.sh`
- [ ] 5.2 Run `bash scripts/verify-release-readiness.sh` standalone — must exit 0 on the hub's own clean state.
  - **Gate:** `bash scripts/verify-release-readiness.sh`
- [ ] 5.3 Validate the change against OpenSpec.
  - **Gate:** `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict`

## 6. Manual follow-up (outside apply)

- [ ] 6.1 [MANUAL ACTION REQUIRED] After merge, add `Release readiness (blocking)` as a required status check under GitHub Settings → Branches for the default branch.
  - **Gate:** — (GitHub repository setting, not a repo file; verify by inspecting branch protection rules)
