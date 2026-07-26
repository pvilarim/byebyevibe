# sdd-ci-gates Specification (delta)

## MODIFIED Requirements

### Requirement: OpenSpec validation is blocking and fail-closed

**UPDATED:** The workflow's `openspec validate` step MUST be blocking and MUST pin the CLI to the **exact `version`** declared in `sdd-kit/MANIFEST.yaml` (not just `min_openspec`). The step MUST declare `timeout-minutes: 3`.

#### Scenario: Invalid change present
- **WHEN** an active change fails `openspec validate`
- **THEN** the workflow fails and the PR check is red

#### Scenario: Version alignment
- **WHEN** `sdd-kit/MANIFEST.yaml` declares `version: "1.3.2"`
- **THEN** the workflow runs `npx --yes @fission-ai/openspec@1.3.2 validate --all --strict --no-interactive`

### Requirement: Workflow uses immutable action references

**ADDED:** Every `uses:` reference in `sdd-gates.yml` (hub and template) MUST be pinned to a full 40-character commit SHA with a trailing `# vX.Y.Z` comment. Mutable tag references (`@v4`, `@v5`, etc.) MUST NOT appear.

#### Scenario: Workflow is inspected for mutable action references
- **WHEN** `.github/workflows/sdd-gates.yml` is reviewed
- **THEN** all `uses:` lines end with a 40-char SHA and a human-readable version comment, and zero mutable tag references exist

### Requirement: Workflow enforces a job-level timeout

**ADDED:** The `sdd-gates` job MUST declare `timeout-minutes: 10`. Blocking steps (openspec validate, task patterns) MUST declare `timeout-minutes: 3` individually.

#### Scenario: Workflow step hangs on network
- **WHEN** a `npx` invocation waits indefinitely for a network response
- **THEN** the step is killed by the step-level timeout (≤3 min) and the job fails, not after the GitHub default of 6 hours

### Requirement: Skip message for optional scripts must not assume profile

**UPDATED:** When `scripts/verify-task-patterns.sh` is absent, the workflow MUST emit a neutral skip message that does not assume a specific profile. The message MUST guide the operator to install the script via `sdd-kit` if the repo uses a DOCS_SPECS or HYBRID profile.

#### Scenario: verify-task-patterns.sh absent on DOCS_SPECS repo
- **WHEN** a DOCS_SPECS repo is missing `scripts/verify-task-patterns.sh`
- **THEN** the workflow emits `SKIP: scripts/verify-task-patterns.sh not found — install via sdd-kit if profile is DOCS_SPECS/HYBRID` and does NOT say `APP profile`
