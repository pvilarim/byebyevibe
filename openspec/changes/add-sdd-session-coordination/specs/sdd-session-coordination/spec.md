# sdd-session-coordination Specification

## Purpose

Coordenação operacional de múltiplas sessões de agente na **mesma máquina**, evitando apply concorrente na mesma working tree. Complementa `sdd-session-handoff` (transição de fase) com exclusão mútua local e presença legível.

## Requirements

### Requirement: Local apply lock per worktree

The repository MUST provide `scripts/sdd-session-register.sh` and `scripts/sdd-session-check.sh` that acquire an exclusive OS-level lock at `.sdd/runtime/apply.lock` relative to the worktree root before apply-phase writes. A second apply session on the **same worktree path** MUST fail with exit code non-zero and a human-readable message.

#### Scenario: Concurrent apply on same worktree

- **WHEN** session A holds the apply lock on worktree `/apps/client-intake`
- **AND** session B runs `sdd-session-check.sh --phase apply` on the same worktree
- **THEN** session B exits non-zero and reports that another apply session is active

#### Scenario: Parallel apply on different worktrees

- **WHEN** session A applies on worktree `/apps/client-intake`
- **AND** session B applies on worktree `/apps/client-intake-wt-b` (separate git worktree)
- **THEN** both sessions MAY proceed (separate lock files per worktree root)

### Requirement: Session presence registry

The repository MUST maintain ephemeral session metadata at `.sdd/runtime/sessions/<session-id>.json` (gitignored) containing at minimum: `phase`, `change_id`, `worktree_path`, `branch`, `paths_scope`, `pid`, `started_at`, `heartbeat_at`.

#### Scenario: Operator inspects active sessions

- **WHEN** the operator runs `bash scripts/sdd-session-status.sh`
- **THEN** active sessions with fresh heartbeat are listed with phase, change-id, and worktree path

#### Scenario: Stale session cleanup

- **WHEN** a session JSON has `heartbeat_at` older than 5 minutes and the recorded PID is not running
- **THEN** `sdd-session-check.sh` treats the session as stale and MAY proceed after warning or `--clean-stale`

### Requirement: Apply skill integration

The `openspec-apply-change` skill (Cursor and Claude mirrors) MUST instruct the agent to run `sdd-session-register.sh` and `sdd-session-check.sh` **before** any file writes, and `sdd-session-release.sh` when apply completes or pauses.

#### Scenario: Apply session starts

- **WHEN** a user opens `/opsx:apply <change-id>` in a new chat
- **THEN** the agent runs session check before editing files

#### Scenario: Apply session ends

- **WHEN** apply tasks complete or the agent pauses for handoff
- **THEN** the agent runs `sdd-session-release.sh` before Session Handoff output

### Requirement: Always-on coordination rule

The repository MUST include `.cursor/rules/016-session-coordination.mdc` with `alwaysApply: true`, stating that apply MUST use session scripts, parallel safe apply requires separate git worktrees, and `doc/sistema-sdd-pedro.md` §3.3 is the operational reference.

#### Scenario: Cursor loads workspace after SDD install

- **WHEN** Cursor opens the workspace
- **THEN** rule `016-session-coordination.mdc` is active

### Requirement: AGENTS.md entry point

`AGENTS.md` MUST include rule **R11** (local session coordination: check before apply, release after) and a Commands table entry for `bash scripts/sdd-session-status.sh`, without exceeding 150 lines total.

#### Scenario: Fresh agent reads AGENTS.md

- **WHEN** an agent starts in a repo with SDD installed
- **THEN** R11 directs it to session scripts before apply

### Requirement: SDD installation checklist

`doc/sistema-sdd-pedro.md` §2.8 MUST include checklist items for: session scripts executable, `016-session-coordination.mdc` present, `.sdd/runtime/` in `.gitignore`, and `openspec/infra.md` Session Coordination section.

#### Scenario: Post-install verification

- **WHEN** operator completes SDD installation checklist §2.8
- **THEN** session coordination artifacts are verified present

### Requirement: Operational documentation

`doc/sistema-sdd-pedro.md` §3.3 MUST document: sequential apply (default), parallel apply via git worktree, flock behavior, and conflict messages — aligned with workshop guidance on worktrees.

#### Scenario: Agent consults parallel task guidance

- **WHEN** an agent reads §3.3 for parallel implementation
- **THEN** worktree + session lock workflow is documented

### Requirement: Runtime directory not versioned

`.sdd/runtime/` MUST be listed in `.gitignore`. Lock and session files MUST NOT be committed.

#### Scenario: Git status after apply

- **WHEN** a session holds locks under `.sdd/runtime/`
- **THEN** `git status` does not show those files as trackable changes
