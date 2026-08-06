## MODIFIED Requirements

### Requirement: Host prerequisite FAIL and WARN matrix

In `--host` or `--all` mode, preflight MUST FAIL when Git, Node (minimum 20.19.0), npm, or a usable Python interpreter is missing or below the documented minimum. Missing recommended `uv` MUST be WARN (bootstrap may install it later). Missing GitNexus build tools MUST be WARN (never FAIL) per the GitNexus escape-paths requirement.

The Python check MUST resolve an interpreter by capability rather than testing for the command name `python3`, and MUST report the resolved command alongside its version so the operator can see which interpreter was selected. The check MUST distinguish two floors and MUST NOT conflate them:

- the floor the kit's own scripts require, which is what gates the install; and
- the higher floor an optional integration such as Graphify requires.

An interpreter satisfying the kit floor but not an optional integration's floor MUST NOT FAIL the host matrix. It MAY WARN, scoped to the integration that needs more, because the guide already permits deferring that integration.

When no interpreter is resolvable, the FAIL message MUST name the candidates tried rather than reporting a version for a name that could not be executed. Reporting a fabricated version for an unusable command sends the operator to reinstall software they already have.

#### Scenario: Missing Git fails host preflight

- **WHEN** `git` is not on PATH and `--host` runs
- **THEN** preflight reports FAIL for Git and exits non-zero

#### Scenario: Missing uv warns but continues

- **WHEN** `uv` is not on PATH and all FAIL-level host tools are present
- **THEN** preflight reports WARN for uv and exits 0

#### Scenario: Interpreter present under a different name

- **WHEN** `--host` runs on a machine where `python3` is absent but another candidate satisfies the kit floor
- **THEN** the Python check reports OK, names the resolved command and its version, and does not FAIL

#### Scenario: Kit floor met, integration floor not met

- **WHEN** the resolved interpreter satisfies the kit floor but is below the floor an optional integration declares
- **THEN** the host matrix does not FAIL for Python, and any advisory is attributed to the integration that requires the higher version

#### Scenario: No interpreter resolvable

- **WHEN** no candidate yields a parseable version
- **THEN** preflight reports FAIL naming the candidates tried, and does not attribute a version number to any of them

### Requirement: Repo prerequisite gate

In `--repo` or `--all` mode, preflight MUST FAIL when `sdd-kit/` is absent/unreadable under the repo root or when the repo root is not writable — except in hub-sourced greenfield mode: when the caller provides a source kit root (e.g. a `--kit-root <path>` flag passed by `bootstrap-sdd.sh` hub-mode resolution) whose `sdd-kit/` is present and readable, the kit-presence check MUST pass against that source root instead of the target repo root. The repo-root writability check always applies to the target. When neither the target nor a provided source root carries a readable `sdd-kit/`, the gate MUST FAIL as before. Profile hints MUST remain advisory (WARN at most, never FAIL). The coexistence of `package.json` and `openspec/` MUST NOT trigger a profile hint: HYBRID is retired as a deprecated alias of APP (kit 1.9.0), and that coexistence is the normal post-install state of every APP repository.

Repo mode MUST additionally FAIL when the interpreter the install path depends on cannot be resolved. This check exists because `sdd-kit/install.sh` runs preflight in repo mode only, and would otherwise begin copying templates without knowing whether the runtime it needs is available. It is scoped to that runtime alone and MUST NOT pull the remaining host prerequisites into repo mode.

#### Scenario: Missing sdd-kit fails repo gate

- **WHEN** `bash scripts/preflight-sdd.sh --repo` runs in a directory without `sdd-kit/` and no source kit root is provided
- **THEN** the script reports FAIL and exits non-zero

#### Scenario: Hub-resolved kit satisfies the gate

- **WHEN** preflight runs against a greenfield target with a source kit root argument pointing to a hub clone containing `sdd-kit/`
- **THEN** the kit-presence check passes and the remaining target checks (writability, profile hints) still run against the target

#### Scenario: package.json plus openspec/ produces no profile hint

- **WHEN** both `package.json` and `openspec/` exist and `--repo` runs
- **THEN** the script emits no HYBRID suggestion and does not FAIL solely for that coexistence

#### Scenario: Repo mode catches an unresolvable interpreter

- **WHEN** `bash scripts/preflight-sdd.sh --repo` runs on a host where no interpreter candidate satisfies the kit floor
- **THEN** the gate reports FAIL and exits non-zero, so a caller that aborts on failure never reaches its file-copy phase

#### Scenario: Repo mode stays narrow

- **WHEN** repo mode runs on a host missing GitNexus build tools but with a resolvable interpreter
- **THEN** the gate does not FAIL, because build tools are not a runtime the install path executes

### Requirement: Preflight updates infra.md Preflight section only

When `openspec/infra.md` exists (or is created by install templates), `scripts/preflight-sdd.sh` MUST update a `## Preflight (last run)` section including timestamp, detected IDE(s), WARN summary, and advisory MCP names, using dedicated HTML comment markers. No other tool in the post-install verification path SHALL overwrite those preflight markers. Marker ownership is additionally scoped **per mode**: in `--repo` mode, the script MUST NOT overwrite host-derived markers (`preflight-ides`, `preflight-mcp`) — it SHALL update only the timestamp and WARN summary. Host-derived markers are written only by runs that executed host checks (`--host` or `--all`).

The update MUST be confined to the marker values themselves. Lines the script did not edit MUST keep their original bytes, including their line endings, so that stamping a timestamp produces a diff proportional to the change rather than a rewrite of the whole file.

#### Scenario: Preflight stamps timestamp marker

- **WHEN** preflight completes successfully against a repo with `openspec/infra.md` containing Preflight markers
- **THEN** the `preflight-timestamp` marker value is updated to a non-placeholder timestamp

#### Scenario: verify-infra does not clear Preflight

- **WHEN** `bash scripts/verify-infra.sh` runs after a preflight stamp
- **THEN** the Preflight section markers remain intact (verify-infra updates SDD Stack markers only)

#### Scenario: Repo-mode run preserves host stamp

- **WHEN** `bash scripts/preflight-sdd.sh --all` stamped `preflight-ides` with detected IDEs, and later `bash scripts/preflight-sdd.sh --repo` runs (e.g. invoked by `sdd-kit/install.sh`)
- **THEN** the `preflight-ides` and `preflight-mcp` marker values from the `--all` run remain unchanged, while `preflight-timestamp` reflects the repo-mode run

#### Scenario: Stamping does not rewrite untouched lines

- **WHEN** preflight stamps its markers in an `openspec/infra.md` whose lines end with CRLF
- **THEN** only the marker lines differ afterwards, and every other line keeps its original ending
