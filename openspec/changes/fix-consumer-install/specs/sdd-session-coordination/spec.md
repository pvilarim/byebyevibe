# Delta — sdd-session-coordination

## MODIFIED Requirements

### Requirement: Local apply lock per worktree

The repository MUST provide `scripts/sdd-session-register.sh` and `scripts/sdd-session-check.sh` that guard apply-phase writes with a lock at `.sdd/runtime/apply.lock` relative to the worktree root. The guard is **two stacked mechanisms** and MUST be honest about which of them is active: (1) a PID-file liveness check, pure shell, guaranteed on every supported platform — a second apply session on the **same worktree path** MUST fail with exit code non-zero and a human-readable message; (2) an advisory OS-level `flock`, which is **best-effort**: the `flock` binary is absent from Git Bash on Windows and from macOS. Before attempting the advisory lock, the library MUST detect whether `flock` is available; when it is absent, it MUST print exactly one line stating that the advisory lock is unavailable on this platform and that the PID-file check is the active guard, and MUST skip the flock acquisition instead of letting it fail invisibly inside a background subshell (per `sdd-fail-loud`). The library MUST NOT report or imply that an advisory lock is held when it is not.

#### Scenario: Concurrent apply on same worktree

- **WHEN** session A holds the apply lock on worktree `/apps/client-intake`
- **AND** session B runs `sdd-session-check.sh --phase apply` on the same worktree
- **THEN** session B exits non-zero and reports that another apply session is active

#### Scenario: Parallel apply on different worktrees

- **WHEN** session A applies on worktree `/apps/client-intake`
- **AND** session B applies on worktree `/apps/client-intake-wt-b` (separate git worktree)
- **THEN** both sessions MAY proceed (separate lock files per worktree root)

#### Scenario: Missing flock degrades loudly, once

- **WHEN** the lock is acquired on a platform where `command -v flock` finds nothing
- **THEN** the library prints one explicit line naming the degradation (advisory lock unavailable — PID-file check only), skips the flock subshell, and the PID-file mechanism still guards the worktree
