# sdd-install-preflight Specification

## Purpose

Normative requirements for phase-0 host/repo/operator prerequisite checks before C1 install: CLI modes (`--host`, `--repo`, `--all`), FAIL/WARN/SKIP semantics, GitNexus build-tools WARN with escape paths, IDE detection advisory, github-mcp advisory, and exclusive ownership of the `openspec/infra.md` Preflight section.

## Requirements

### Requirement: Preflight CLI with host, repo, and all modes

The distribution MUST provide `scripts/preflight-sdd.sh` (shipped from `sdd-kit/templates/scripts/preflight-sdd.sh`) that supports `--host`, `--repo`, and `--all` modes, plus optional `--json` output. When no mode flag is passed, the script MUST default to `--all`. The script MUST classify each check as FAIL, WARN, or SKIP and MUST exit non-zero if any FAIL occurred.

#### Scenario: Default runs all checks

- **WHEN** an operator runs `bash scripts/preflight-sdd.sh` with no mode flags in a writable repo that has `sdd-kit/` and required host tools
- **THEN** the script performs both host and repo checks and exits 0 when no FAIL checks are present

#### Scenario: FAIL aborts with non-zero exit

- **WHEN** `bash scripts/preflight-sdd.sh --host` runs on a host without `node` on PATH
- **THEN** the script reports a FAIL for Node and exits non-zero

#### Scenario: JSON summary available

- **WHEN** an operator runs `bash scripts/preflight-sdd.sh --all --json`
- **THEN** stdout includes a JSON summary of checks with level and message fields suitable for tooling

### Requirement: Host prerequisite FAIL and WARN matrix

In `--host` or `--all` mode, preflight MUST FAIL when Git, Node (minimum 20.19.0), npm, or Python 3.10+ is missing or below the documented minimum. Missing recommended `uv` MUST be WARN (bootstrap may install it later). Missing GitNexus build tools MUST be WARN (never FAIL) per the GitNexus escape-paths requirement.

#### Scenario: Missing Git fails host preflight

- **WHEN** `git` is not on PATH and `--host` runs
- **THEN** preflight reports FAIL for Git and exits non-zero

#### Scenario: Missing uv warns but continues

- **WHEN** `uv` is not on PATH and all FAIL-level host tools are present
- **THEN** preflight reports WARN for uv and exits 0

### Requirement: Repo prerequisite gate

In `--repo` or `--all` mode, preflight MUST FAIL when `sdd-kit/` is absent/unreadable under the repo root or when the repo root is not writable. Profile hints (e.g. coexistence of `package.json` and `openspec/` suggesting HYBRID) MUST be WARN when ambiguous, not FAIL.

#### Scenario: Missing sdd-kit fails repo gate

- **WHEN** `bash scripts/preflight-sdd.sh --repo` runs in a directory without `sdd-kit/`
- **THEN** the script reports FAIL and exits non-zero

#### Scenario: Ambiguous HYBRID hint warns

- **WHEN** both `package.json` and `openspec/` exist and `--repo` runs
- **THEN** the script emits a WARN about possible HYBRID profile and does not FAIL solely for that reason

### Requirement: GitNexus build-tools WARN with escape paths

When build tools required for GitNexus tree-sitter grammars are missing, preflight MUST emit WARN (not FAIL). For profile DOCS_SPECS the WARN MAY be normal severity; for APP or HYBRID the WARN MUST be strong (impact analysis / code map may be unavailable). The message MUST list all three escape paths: install build tools; `GITNEXUS_SKIP_OPTIONAL_GRAMMARS=1`; defer via C2b §2.9.4.

#### Scenario: Missing build tools warn with escapes

- **WHEN** `--host` runs on Linux without `make` or `g++` and FAIL-level tools are present
- **THEN** preflight exits 0 with a WARN whose message mentions build tools, `GITNEXUS_SKIP_OPTIONAL_GRAMMARS=1`, and C2b or §2.9.4

#### Scenario: APP profile strong WARN

- **WHEN** `--host --profile APP` runs without build tools
- **THEN** the WARN text indicates code map or impact analysis may be unavailable

### Requirement: IDE detection is advisory WARN

Preflight MUST detect IDE presence via `command -v` for `cursor`, `code`, and `claude`, then directory fallbacks `$HOME/.cursor/` and `$HOME/.claude/`. If none are detected, preflight MUST WARN and MUST NOT FAIL solely for missing IDE.

#### Scenario: No IDE detected warns

- **WHEN** no IDE binary or config directory is found and `--all` runs with otherwise healthy host/repo
- **THEN** preflight reports WARN that `/opsx:*` may be unavailable and exits 0

#### Scenario: Cursor directory counts as detected

- **WHEN** `$HOME/.cursor/` exists even if `cursor` is not on PATH
- **THEN** preflight does not emit the “no IDE detected” WARN solely for missing `cursor` on PATH

### Requirement: github-mcp absence is advisory

Preflight MAY list MCP server names from `~/.cursor/mcp.json` (names only). Absence of github-mcp MUST NOT FAIL C1 preflight; at most WARN advisory aligned with guide §2.15 fail-open posture.

#### Scenario: Missing github-mcp does not fail

- **WHEN** mcp.json lacks github-mcp and host/repo FAIL checks are clear
- **THEN** preflight exits 0 (optional WARN allowed)

### Requirement: Preflight updates infra.md Preflight section only

When `openspec/infra.md` exists (or is created by install templates), `scripts/preflight-sdd.sh` MUST update a `## Preflight (last run)` section including timestamp, detected IDE(s), WARN summary, and advisory MCP names, using dedicated HTML comment markers. No other tool in the post-install verification path SHALL overwrite those preflight markers.

#### Scenario: Preflight stamps timestamp marker

- **WHEN** preflight completes successfully against a repo with `openspec/infra.md` containing Preflight markers
- **THEN** the `preflight-timestamp` marker value is updated to a non-placeholder timestamp

#### Scenario: verify-infra does not clear Preflight

- **WHEN** `bash scripts/verify-infra.sh` runs after a preflight stamp
- **THEN** the Preflight section markers remain intact (verify-infra updates SDD Stack markers only)
