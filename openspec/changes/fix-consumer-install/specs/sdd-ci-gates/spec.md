# Delta — sdd-ci-gates

## MODIFIED Requirements

### Requirement: verify-infra.sh runs report-only in CI

The step that runs `sdd-kit/verify.sh` **against the hub checkout** in the CI workflow MUST be configured with `continue-on-error: true`. `sdd-kit/verify.sh` internally invokes `scripts/verify-infra.sh`, which reports FAIL for knowledge CLIs (GitNexus, Graphify) absent on ephemeral runners; making the hub-checkout step blocking would produce false negatives that would block legitimate merges. The fail-closed policy MUST apply to the `openspec validate`, `verify-task-patterns.sh`, **and OSV-Scanner when a lockfile is present** steps — the hub-checkout `sdd-kit verify` step MUST NOT block merge. This report-only mandate is scoped to the hub-checkout step: the consumer install smoke test MAY assert `sdd-kit/verify.sh` exit 0 as a blocking condition inside its temporary consumer repository, because `verify-infra.sh`'s advisory exit semantics make that exit code independent of the runner's knowledge CLIs.

#### Scenario: Runner without GitNexus/Graphify installed

- **WHEN** the `sdd-kit verify (report-only)` step runs against the hub checkout on a runner where GitNexus and Graphify are not installed
- **THEN** the step reports WARN/FAIL internally but the workflow continues and the overall job result is not affected by this step alone

#### Scenario: openspec validate fails in the same run

- **WHEN** `openspec validate --all --strict` fails with non-zero exit
- **THEN** the workflow ends in failure (fail-closed) regardless of the report-only step result

#### Scenario: OSV-Scanner fails with vulnerable lockfile

- **WHEN** OSV-Scanner runs (lockfile present) and reports a vulnerability
- **THEN** the workflow ends in failure (fail-closed) regardless of the report-only `sdd-kit verify` step result

#### Scenario: Consumer smoke verify assertion stays blocking

- **WHEN** the consumer install smoke test's `bash sdd-kit/verify.sh` assertion fails inside the temporary consumer repository
- **THEN** the job fails — the report-only mandate does not extend to the smoke test

## ADDED Requirements

### Requirement: CI exercises a consumer APP install end to end

The `sdd-gates` workflow MUST perform a blocking consumer-install smoke test in APP profile against a temporary repository created within the run, **outside the hub checkout** and not pre-seeded with anything the install is expected to create. This gate exists because every previously existing gate ran against the hub — with `sdd-kit/` complete, `templates/` present, no `_template/`, `project.md` hand-written — and each of those conditions is the inverse of a consumer's state: seven consumer defects appeared in forty minutes of real use after 369 green hub PRs.

The test MUST cover two variations:

**Canonical consumer (kit inside the target, the tarball layout):** copy `sdd-kit/` into the temp repository, create an initial commit, run `install.sh --profile APP` with explicit language flags, and assert all of:

1. **Every APP-profile MANIFEST entry was applied** — the assertion enumerates entries from the MANIFEST at run time and checks each destination path exists; a hardcoded count or the installer's exit code alone MUST NOT satisfy it.
2. `bash sdd-kit/verify.sh` exits 0.
3. `openspec validate --all --strict` exits 0 (validating, among the rest, the distributed `_template`).
4. `openspec/project.md` exists **and** contains the `## Language policy` block with its anchor markers.

**Hub-mode (no kit in the target):** run the hub checkout's `install.sh --repo <temp>` against a second temp repository that has no `sdd-kit/`, and assert entries applied and `project.md` with the policy block — this variation reproduces the `--kit-root` asymmetry that silently produced zero-payload installs.

The job MUST provision the tools the assertions legitimately require (the OpenSpec CLI the workflow already pins) and MUST NOT provision tools that cannot change any assertion's outcome: `verify-infra.sh` is advisory by design (exits 0 without a TTY or `--write`), so the knowledge CLIs (GitNexus, Graphify) buy no gate strength and stay out of the job — a workflow comment MUST state this so the narrowing is not later "fixed" into flakiness. The job MUST NOT fabricate artifacts (e.g. a fake graph report) to make a verification pass.

#### Scenario: The job carries no knowledge-CLI provisioning

- **WHEN** the consumer smoke test job definition is read
- **THEN** it installs no GitNexus or Graphify, and a comment states why their absence does not weaken the `verify.sh` assertion

#### Scenario: Full-payload APP install passes

- **WHEN** the smoke test runs against a healthy kit
- **THEN** both variations complete, every enumerated MANIFEST destination exists, verify and strict validation exit 0, and the job passes

#### Scenario: A dying template loop fails the gate

- **WHEN** any MANIFEST entry aborts the copy loop partway (e.g. a src==dest copy), leaving later entries unapplied
- **THEN** the per-entry enumeration finds at least one missing destination and the job fails, even if the installer exited 0

#### Scenario: Consumer misdetected as hub fails the gate

- **WHEN** `verify.sh` in the temp consumer applies a hub-only check or skips a consumer check because of directory shape
- **THEN** its exit code or the language-policy assertion fails the job

#### Scenario: Missing language policy fails the gate

- **WHEN** the install completes but `openspec/project.md` is absent or lacks the Language policy block
- **THEN** assertion 4 fails the job regardless of the installer's exit code

#### Scenario: Hub-mode zero-payload regression is caught

- **WHEN** the hub-mode variation's preflight rejects the target for a missing `sdd-kit/` and the installer exits non-zero or applies nothing
- **THEN** the job fails, instead of the failure being downgraded to a warning
