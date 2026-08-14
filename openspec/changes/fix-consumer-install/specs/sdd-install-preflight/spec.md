# Delta — sdd-install-preflight

## MODIFIED Requirements

### Requirement: Repo prerequisite gate

In `--repo` or `--all` mode, preflight MUST FAIL when `sdd-kit/` is absent/unreadable under the repo root or when the repo root is not writable — except in hub-sourced greenfield mode: when the caller provides a source kit root (`--kit-root <path>`) whose `sdd-kit/` is present and readable, the kit-presence check MUST pass against that source root instead of the target repo root. Providing or deriving the source kit root is the obligation of **every caller** that runs from a kit outside the target repo — not only `bootstrap-sdd.sh`: `sdd-kit/install.sh` MUST derive the source kit root from its own location (`KIT_DIR`) and pass it to the repo preflight whenever the target repo root does not contain `sdd-kit/`, without requiring a new public flag on `install.sh`. The repo-root writability check always applies to the target. When neither the target nor a provided source root carries a readable `sdd-kit/`, the gate MUST FAIL as before. Profile hints MUST remain advisory (WARN at most, never FAIL). The coexistence of `package.json` and `openspec/` MUST NOT trigger a profile hint: HYBRID is retired as a deprecated alias of APP (kit 1.9.0), and that coexistence is the normal post-install state of every APP repository.

Repo mode MUST additionally FAIL when the interpreter the install path depends on cannot be resolved. This check exists because `sdd-kit/install.sh` runs preflight in repo mode only, and would otherwise begin copying templates without knowing whether the runtime it needs is available. It is scoped to that runtime alone and MUST NOT pull the remaining host prerequisites into repo mode.

Because the caller is a parent process that cannot receive an environment variable from its child, repo mode MUST communicate the resolved interpreter over standard output: on success it prints exactly one machine-readable line of the form `SDD_PYTHON=<candidate>` to stdout, and nothing else on stdout — human-readable output stays on stderr, where the script already sends it. A caller that captures stdout therefore obtains the resolution; a human running the mode interactively sees the ordinary report on stderr.

#### Scenario: Repo mode emits the resolution on stdout

- **WHEN** `bash scripts/preflight-sdd.sh --repo` succeeds in a repository with a readable `sdd-kit/`
- **THEN** stdout consists of exactly one line matching `SDD_PYTHON=<candidate>`, and all human-readable report lines appear on stderr

#### Scenario: Missing sdd-kit fails repo gate

- **WHEN** `bash scripts/preflight-sdd.sh --repo` runs in a directory without `sdd-kit/` and no source kit root is provided
- **THEN** the script reports FAIL and exits non-zero

#### Scenario: Hub-resolved kit satisfies the gate

- **WHEN** preflight runs against a greenfield target with a source kit root argument pointing to a hub clone containing `sdd-kit/`
- **THEN** the kit-presence check passes and the remaining target checks (writability, profile hints) still run against the target

#### Scenario: install.sh in hub-mode passes its own kit root

- **WHEN** `bash <hub>/sdd-kit/install.sh --repo <target>` runs against a target that has no `sdd-kit/`
- **THEN** the repo preflight it invokes receives the source kit root derived from the installer's own location, the kit-presence check passes against that source, and the install proceeds to template copy

#### Scenario: package.json plus openspec/ produces no profile hint

- **WHEN** both `package.json` and `openspec/` exist and `--repo` runs
- **THEN** the script emits no HYBRID suggestion and does not FAIL solely for that coexistence

#### Scenario: Repo mode catches an unresolvable interpreter

- **WHEN** `bash scripts/preflight-sdd.sh --repo` runs on a host where no interpreter candidate satisfies the kit floor
- **THEN** the gate reports FAIL and exits non-zero, so a caller that aborts on failure never reaches its file-copy phase

#### Scenario: Repo mode stays narrow

- **WHEN** repo mode runs on a host missing GitNexus build tools but with a resolvable interpreter
- **THEN** the gate does not FAIL, because build tools are not a runtime the install path executes
