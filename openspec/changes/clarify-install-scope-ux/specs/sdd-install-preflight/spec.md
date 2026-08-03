# Delta: sdd-install-preflight — clarify-install-scope-ux

## MODIFIED Requirements

### Requirement: Repo prerequisite gate

In `--repo` or `--all` mode, preflight MUST FAIL when `sdd-kit/` is absent/unreadable under the repo root or when the repo root is not writable — except in hub-sourced greenfield mode: when the caller provides a source kit root (e.g. a `--kit-root <path>` flag passed by `bootstrap-sdd.sh` hub-mode resolution) whose `sdd-kit/` is present and readable, the kit-presence check MUST pass against that source root instead of the target repo root. The repo-root writability check always applies to the target. When neither the target nor a provided source root carries a readable `sdd-kit/`, the gate MUST FAIL as before. Profile hints (e.g. coexistence of `package.json` and `openspec/` suggesting HYBRID) MUST be WARN when ambiguous, not FAIL.

#### Scenario: Missing sdd-kit fails repo gate

- **WHEN** `bash scripts/preflight-sdd.sh --repo` runs in a directory without `sdd-kit/` and no source kit root is provided
- **THEN** the script reports FAIL and exits non-zero

#### Scenario: Hub-resolved kit satisfies the gate

- **WHEN** preflight runs against a greenfield target with a source kit root argument pointing to a hub clone containing `sdd-kit/`
- **THEN** the kit-presence check passes and the remaining target checks (writability, profile hints) still run against the target

#### Scenario: Ambiguous HYBRID hint warns

- **WHEN** both `package.json` and `openspec/` exist and `--repo` runs
- **THEN** the script emits a WARN about possible HYBRID profile and does not FAIL solely for that reason
