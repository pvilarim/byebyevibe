# Delta — sdd-ci-gates

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

The job MUST provision, with pinned versions where available, the tools the assertions legitimately require (the OpenSpec CLI the workflow already pins; the knowledge CLIs that `verify.sh` checks). The job MUST NOT fabricate artifacts (e.g. a fake graph report) to make a verification pass, and every step of the smoke test MUST use constructs portable per the workflow's Linux runner without misrepresenting other platforms.

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
