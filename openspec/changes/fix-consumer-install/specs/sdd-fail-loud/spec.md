# Delta — sdd-fail-loud (new capability)

## ADDED Requirements

### Requirement: A step that cannot run must say so

Every install, bootstrap, upgrade, or verification step in the kit and its distributed scripts MUST, when it cannot execute its intended check or action, either (a) fail the run with a non-zero exit and a message naming what did not happen, or (b) — only where the step is explicitly declared optional or best-effort by a spec — emit an explicit statement that the step did not run and why. Reporting success, remaining silent, or downgrading a not-run mandatory step to a warning while exiting zero is forbidden.

This is the normative home of the vacuous-pass family observed seven times in the 1.14.0 cycle: the zero-file install that printed "Done.", the release-readiness check that compared nothing, the `flock` acquisition that silently never held a lock, the silenced `openspec init` failure, the `verify.sh` language check skipped when `project.md` was absent, the bootstrap that treated a failed payload install as WARN and exited 0, and the `.sdd/runtime` gitignore check that failed in every consumer forever because nothing in the install ever wrote the entry — masked by an advisory exit code. New gates and checks MUST be designed against this requirement.

#### Scenario: Mandatory step failure is fatal to the caller

- **WHEN** a bootstrap or install phase whose product is mandatory (e.g. the kit payload copy) exits non-zero
- **THEN** the calling script exits non-zero and names the step that failed, instead of warning and completing

#### Scenario: Declared-optional step degrades loudly

- **WHEN** a step declared optional or best-effort by its spec cannot run (e.g. an advisory lock binary is absent on the platform)
- **THEN** the script emits one explicit line stating the step did not run and why, and continues under the documented degraded behavior

#### Scenario: A skipped verification is never reported as passed

- **WHEN** a verification's subject is absent or its machinery cannot execute
- **THEN** the verification reports an explicit skip-with-reason or a failure per its spec — never an OK, and never silence

#### Scenario: Suppressed diagnostics are surfaced on failure

- **WHEN** a step's stderr was suppressed for cosmetic reasons and the step fails
- **THEN** the failure path surfaces the captured diagnostic output to the operator
