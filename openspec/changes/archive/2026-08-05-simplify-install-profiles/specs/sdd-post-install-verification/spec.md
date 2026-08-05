# Delta: sdd-post-install-verification — simplify-install-profiles

## MODIFIED Requirements

### Requirement: Task pattern verification script present

The repository MUST have `scripts/verify-task-patterns.sh` after SDD install **in every profile**, executable, validating `Pattern:` paths in active change `tasks.md` files. Exit semantics MUST be profile-aware: in DOCS_SPECS the script MUST exit non-zero when any local `Pattern:` path is broken or a cross-repo pattern appears (fail-closed, unchanged); in APP — and when the profile cannot be determined — the script MUST run **report-only**: broken local paths print as WARN, cross-repo patterns print as SKIP, and the script exits 0 with a summary line naming the report-only mode and noting that enforcement is a future change. Profile detection MUST consult, in order: a profile marker in `openspec/project.md`, AGENTS.md command-table markers (`12.2b` → DOCS_SPECS, `12.2a` → APP), then legacy string fallbacks for pre-1.9.0 installs.

#### Scenario: Verify task patterns on checklist

- **WHEN** the operator runs `bash scripts/verify-task-patterns.sh` after install
- **THEN** the script exits 0 when no broken in-repo Pattern paths exist

#### Scenario: APP repo with broken pattern stays green

- **WHEN** the script runs in an APP-profile repo whose active `tasks.md` references a non-existent local path
- **THEN** the path is reported as WARN, the summary names report-only mode, and the exit code is 0

#### Scenario: DOCS_SPECS repo with broken pattern fails

- **WHEN** the script runs in a DOCS_SPECS-profile repo whose active `tasks.md` references a non-existent local path
- **THEN** the script reports FAIL and exits non-zero

#### Scenario: Unknown profile degrades to report-only

- **WHEN** neither `openspec/project.md` nor AGENTS.md carries a recognizable profile marker
- **THEN** the script runs report-only and exits 0
