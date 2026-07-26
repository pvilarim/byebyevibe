# sdd-metrics Specification (delta)

## Purpose

Normative requirements for on-demand (mode C) measurement of SDD framework effectiveness via a local bash script. Metrics are derived from git history and `openspec/changes/archive/` — without adopting Apache DevLake or any external analytics platform.

## ADDED Requirements

### Requirement: Local metrics script exists and is executable

The repository MUST include `scripts/sdd-metrics.sh` — an executable bash script that generates a markdown report of SDD framework effectiveness metrics. The script MUST depend only on bash and `git` (no network, no tokens, no external analytics service). Apache DevLake MUST NOT be required to obtain these metrics.

#### Scenario: Operator runs metrics script

- **WHEN** an operator runs `bash scripts/sdd-metrics.sh` at the repository root
- **THEN** the script exits 0 and prints a markdown report to stdout containing the required metric sections

#### Scenario: Empty archive

- **WHEN** `openspec/changes/archive/` has no archived changes
- **THEN** the script still exits 0 and reports zero archived changes without failing

#### Scenario: Invalid usage

- **WHEN** the operator passes an invalid flag or malformed `--since` date
- **THEN** the script exits with code 2 and prints usage help

### Requirement: Report covers volume, lead time, and post-archive rework

The metrics report MUST include at least:

1. **Volume (M1):** counts of active changes under `openspec/changes/` (excluding `archive/` and templates) and archived changes under `openspec/changes/archive/`.
2. **Lead time propose→archive (M2):** for each archived change directory named `YYYY-MM-DD-<change-id>`, the number of days between the first git commit referencing `<change-id>` (or the first commit that added that change's `proposal.md` when recoverable) and the archive date from the directory prefix; plus summary statistics (at least mean or median).
3. **Rework pós-archive (M3):** count of commits after the archive date whose subject matches a `fix` conventional-commit type and that mention the archived `<change-id>` (R9).
4. **Actividade pós-archive (M4):** a dedicated section summarizing post-archive corrective activity, using M3 as the primary proxy.

The report MUST document that M2/M3 are proxies (propose may precede the first commit; R9 discipline affects M3 completeness).

#### Scenario: Hub with archived changes

- **WHEN** the hub repository contains at least one `openspec/changes/archive/YYYY-MM-DD-<id>/` directory and matching git history
- **THEN** the report lists that change under M2 with a non-empty lead-time value or an explicit "n/a" when `t_start` cannot be determined

#### Scenario: Rework commits after archive

- **WHEN** a `fix(...): ... (<change-id>)` commit exists after the archive date of `<change-id>`
- **THEN** M3 counts that commit under the corresponding change-id

### Requirement: CLI flags for since-filter, output file, and help

`scripts/sdd-metrics.sh` MUST support:

- `--since YYYY-MM-DD` — limit archived changes (and related rework window as designed) to those on or after the given date
- `--output PATH` — write the same markdown report to `PATH` in addition to stdout
- `--help` — print usage and metric definitions, then exit 0

#### Scenario: Since filter

- **WHEN** the operator runs `bash scripts/sdd-metrics.sh --since 2026-07-01`
- **THEN** archived changes with directory dates before 2026-07-01 are excluded from M1–M4 aggregations

#### Scenario: Output file

- **WHEN** the operator runs `bash scripts/sdd-metrics.sh --output /tmp/sdd-metrics.md`
- **THEN** `/tmp/sdd-metrics.md` contains the same markdown body printed to stdout

### Requirement: On-demand mode C — not a CI gate

The metrics script MUST be invoked on demand by a human or agent (mode C). It MUST NOT be added as a required blocking step of the `SDD Gates` CI workflow in this capability. No skill or always-on rule MUST be required to discover the command — documentation in `AGENTS.md` Commands / Integrações is sufficient (R3 N/A).

#### Scenario: CI workflow inspection

- **WHEN** `.github/workflows/sdd-gates.yml` is reviewed after this capability is adopted
- **THEN** `sdd-metrics.sh` is not a required blocking job step

#### Scenario: Agent discovers command

- **WHEN** an agent reads `AGENTS.md` Commands table
- **THEN** an entry for `bash scripts/sdd-metrics.sh` (or equivalent) documents how to generate the metrics report

### Requirement: DevLake remains out of scope

Adopting Apache DevLake (or equivalent DORA platforms) MUST NOT be part of fulfilling `sdd-metrics`. Re-evaluation of DevLake remains a separate decision when team scale justifies DORA dashboards.

#### Scenario: Evaluation record

- **WHEN** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` is updated for G4
- **THEN** the manual `sdd-metrics.sh` approach is recorded as Adopted and Apache DevLake remains Adiado with its re-evaluation condition
