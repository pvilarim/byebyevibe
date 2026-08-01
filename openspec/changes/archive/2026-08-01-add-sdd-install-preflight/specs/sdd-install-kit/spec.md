## ADDED Requirements

### Requirement: Kit ships preflight-sdd.sh

`sdd-kit/MANIFEST.yaml` MUST register a COPY entry for `scripts/preflight-sdd.sh` sourced from `templates/scripts/preflight-sdd.sh` with a `sha256` field. The `gate:` value is documentation metadata only and MUST NOT be executed via `eval` or equivalent (F-SEC-5).

#### Scenario: MANIFEST lists preflight script

- **WHEN** `sdd-kit/MANIFEST.yaml` is read after this capability is applied
- **THEN** an entry exists with `path: scripts/preflight-sdd.sh` and a non-empty `sha256` field

#### Scenario: install copies preflight script

- **WHEN** `bash sdd-kit/install.sh --profile DOCS_SPECS` completes successfully on a greenfield target
- **THEN** the target has an executable `scripts/preflight-sdd.sh` copied from the kit template

### Requirement: bootstrap-sdd.sh runs full preflight unless skipped

`sdd-kit/templates/scripts/bootstrap-sdd.sh` (and the hub mirror) MUST invoke full preflight (`--all`) at the start of bootstrap, after resolving the repo path and before OpenSpec install, unless `--skip-preflight` is passed. On preflight FAIL, bootstrap MUST abort with non-zero exit before installing CLIs.

#### Scenario: Bootstrap aborts when preflight fails

- **WHEN** `bootstrap-sdd.sh` runs without `--skip-preflight` and preflight reports FAIL
- **THEN** bootstrap exits non-zero before `npm install -g` OpenSpec/GitNexus steps

#### Scenario: skip-preflight bypasses the gate

- **WHEN** `bootstrap-sdd.sh --skip-preflight` is invoked
- **THEN** bootstrap does not require a successful preflight run to continue

### Requirement: install.sh applies repo-only preflight gate

`sdd-kit/install.sh` MUST run repo-only preflight (`scripts/preflight-sdd.sh --repo` or equivalent inline checks matching that mode) before copying templates, unless `--skip-preflight` is passed. It MUST NOT repeat the full host prerequisite scan as part of that gate.

#### Scenario: Standalone install fails without sdd-kit readability

- **WHEN** `install.sh` is invoked in a broken layout where repo preflight would FAIL and `--skip-preflight` is not set
- **THEN** install aborts before template copy

#### Scenario: install does not require host build tools

- **WHEN** `install.sh` runs with repo preflight PASS and host build tools absent
- **THEN** install does not FAIL solely due to missing GitNexus build tools

### Requirement: infra.md template includes Preflight section

`sdd-kit/templates/openspec/infra.md` MUST include a `## Preflight (last run)` section with markers reserved for `preflight-sdd.sh` (timestamp, IDEs, WARN summary, MCP names).

#### Scenario: Template contains Preflight heading

- **WHEN** the infra.md kit template is read after apply
- **THEN** it contains `## Preflight (last run)` and `preflight-timestamp` markers
