# sdd-session-coordination Specification (delta)

## ADDED Requirements

### Requirement: Explicit session identification

`sdd-session-register.sh` MUST emit the generated `session_id` in a machine-parseable form on stdout. `sdd-session-check.sh`, `sdd-session-heartbeat.sh`, and `sdd-session-release.sh` MUST accept an explicit `--session-id <id>` argument and MUST use it in preference to any shared "current session" pointer when provided. The shared pointer (`.sdd/runtime/current-session.id`) MAY be used as a fallback only when `--session-id` is omitted, and its use MUST emit a warning when more than one session is registered for the same worktree.

#### Scenario: Agent captures session id explicitly

- **WHEN** an agent runs `sdd-session-register.sh --phase apply --change-id <id>`
- **THEN** it captures the emitted `session_id` and passes it via `--session-id` to subsequent `sdd-session-check.sh`, `sdd-session-heartbeat.sh`, and `sdd-session-release.sh` calls

#### Scenario: Two sessions active on the same worktree

- **WHEN** session A (explore) and session B (apply) are both registered on the same worktree
- **AND** session A calls `sdd-session-release.sh --session-id <A>`
- **THEN** only session A's session file is removed; session B's lock and session file are unaffected

#### Scenario: Apply session self-identifies without relying on the shared pointer

- **WHEN** session B (apply) calls `sdd-session-check.sh --phase apply --session-id <B>` while session A (explore, registered after B) is the current shared-pointer value
- **THEN** session B correctly skips its own session file in the conflict scan and does not block on itself

### Requirement: Infra manifest reflects session coordination status

`scripts/verify-infra.sh` MUST update the "Session Coordination" status markers in `openspec/infra.md` (`<!-- session-status -->...<!-- /session-status -->` or equivalent) with the actual result of the session-scripts check, using the same marker mechanism already used for OpenSpec/GitNexus/Graphify status rows.

#### Scenario: Verify updates infra.md

- **WHEN** `bash sdd-kit/verify.sh` runs and session coordination scripts are present and executable
- **THEN** `openspec/infra.md` "Session Coordination" section shows ✅, matching the console output

### Requirement: Always-on coordination rule documents explicit session id

`.cursor/rules/016-session-coordination.mdc` MUST instruct the agent to capture the `session_id` emitted by `sdd-session-register.sh` and pass it explicitly via `--session-id` to `sdd-session-check.sh` and `sdd-session-release.sh`, rather than relying solely on the shared `current-session.id` pointer. Wiring this into the `openspec-apply-change` skill mirrors (`.cursor/skills/`, `.claude/skills/`) is out of scope for `sdd-kit` — those files are generated/overwritten by `openspec init`/upgrade and are not part of the kit's distributed payload.

#### Scenario: Cursor loads workspace after redesign

- **WHEN** Cursor opens the workspace with the updated rule
- **THEN** `016-session-coordination.mdc` documents capturing and passing `--session-id` explicitly

## MODIFIED Requirements

### Requirement: Session presence registry

The repository MUST maintain ephemeral session metadata at `.sdd/runtime/sessions/<session-id>.json` (gitignored) containing at minimum: `phase`, `change_id`, `worktree_path`, `branch`, `paths_scope`, `pid`, `lock_holder_pid` (apply phase only, empty otherwise), `started_at`, `heartbeat_at`. `pid` records the invoking `register.sh` process for audit only and MUST NOT be used as a liveness signal — liveness for apply sessions MUST be determined via `lock_holder_pid`.

#### Scenario: Apply session records lock holder PID

- **WHEN** `sdd-session-register.sh --phase apply` succeeds
- **THEN** the session JSON includes `lock_holder_pid` matching the background `flock` holder process, not the (already-exited) `register.sh` PID

#### Scenario: Operator inspects active sessions

- **WHEN** the operator runs `bash scripts/sdd-session-status.sh`
- **THEN** active sessions with fresh heartbeat are listed with phase, change-id, and worktree path

### Requirement: Local apply lock per worktree

The repository MUST provide `scripts/sdd-session-register.sh` and `scripts/sdd-session-check.sh` that acquire an exclusive OS-level lock at `.sdd/runtime/apply.lock` relative to the worktree root before apply-phase writes. A second apply session on the **same worktree path** MUST fail with exit code non-zero and a human-readable message. Conflict detection for apply sessions MUST be based on whether the recorded `lock_holder_pid` of another session is alive, not on heartbeat freshness alone.

#### Scenario: Concurrent apply on same worktree

- **WHEN** session A holds the apply lock on worktree `/apps/client-intake`
- **AND** session B runs `sdd-session-check.sh --phase apply` on the same worktree
- **THEN** session B exits non-zero and reports that another apply session is active

#### Scenario: Parallel apply on different worktrees

- **WHEN** session A applies on worktree `/apps/client-intake`
- **AND** session B applies on worktree `/apps/client-intake-wt-b` (separate git worktree)
- **THEN** both sessions MAY proceed (separate lock files per worktree root)

#### Scenario: Orphaned apply session does not block

- **WHEN** a previous apply session's `lock_holder_pid` is no longer alive (crash without `release`), regardless of `heartbeat_at` freshness
- **THEN** `sdd-session-check.sh` does NOT report a conflict for that session, and MAY clean up the stale session file with `--clean-stale`

### Requirement: Stale session cleanup

`sdd-session-check.sh` MUST treat another worktree's apply session as stale when its `lock_holder_pid` is not running, regardless of `heartbeat_at` freshness, and MAY warn and clean it up with `--clean-stale` instead of treating it as an active conflict.

#### Scenario: Stale apply session cleanup

- **WHEN** a previous apply session's `lock_holder_pid` is no longer alive (crash without `release`)
- **THEN** `sdd-session-check.sh` treats the session as stale and MAY proceed after warning or `--clean-stale`, even if its `heartbeat_at` is recent
