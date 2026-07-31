## ADDED Requirements

### Requirement: bootstrap-sdd.sh supports quiet didactic banners

`scripts/bootstrap-sdd.sh` as distributed by the kit (`sdd-kit/templates/scripts/bootstrap-sdd.sh`, and the hub copy when present) MUST support a `--quiet` / `-q` flag that suppresses didactic S-layer install banners. Didactic banners MUST appear only when stdout is a TTY and quiet mode is off. The script MUST preserve existing C1 phase order (OpenSpec → GitNexus → Graphify → `sdd-kit/install.sh`) and MUST continue to emit WARN/ERROR diagnostics regardless of quiet mode.

#### Scenario: Quiet flag documented in help or usage

- **WHEN** an operator inspects bootstrap usage (`-h`/`--help` if present, or guide §2 / kit README mention)
- **THEN** `--quiet` is documented as suppressing didactic banners for CI/agents

#### Scenario: Quiet run keeps phase order

- **WHEN** `bash scripts/bootstrap-sdd.sh --quiet` runs in a target repo
- **THEN** OpenSpec, GitNexus, Graphify, and kit install still execute in that order (subject to existing optional-continue WARN behavior for GitNexus)

### Requirement: install.sh emits optional add-ons teaser without installing them

`sdd-kit/install.sh` MUST append an optional add-ons teaser after its standard next-steps output. The teaser MUST reference optional UI, Probity, CI gates, and metrics entry points (guide sections and/or commands) and MUST NOT call `install-ui-module.sh`, `install-probity-module.sh`, or otherwise auto-install optional modules.

#### Scenario: Successful install shows add-ons teaser

- **WHEN** `bash sdd-kit/install.sh --profile HYBRID` completes file copy (or dry-run planning) and prints next steps
- **THEN** stdout also includes an optional add-ons teaser and exit code remains success when install itself succeeded

#### Scenario: Teaser does not invoke UI installer

- **WHEN** the optional add-ons teaser is printed
- **THEN** `install-ui-module.sh` is not executed as part of that `install.sh` run
