## ADDED Requirements

### Requirement: Interpretation playbook maps metrics to process actions

The SDD guide section for metrics (`doc/sistema-sdd-pedro.md` §2.17) MUST include an interpretation playbook that maps report sections M1–M4 to concrete process adjustments (at least one suggested action per metric family). The playbook MUST state a minimal ritual: after reading a report, the operator records **one** insight and chooses **one** framework adjustment (or explicitly records “no change”).

#### Scenario: Operator finishes a metrics run

- **WHEN** an operator reads the metrics report and consults §2.17
- **THEN** they find a table or equivalent mapping M1/M2/M3/M4 signals to suggested SDD process actions and the one-insight → one-adjustment ritual

#### Scenario: High rework signal

- **WHEN** M3 shows repeated post-archive `fix` commits for archived change-ids
- **THEN** the playbook suggests investigating premature archive, weak specs, or R9 discipline — not adopting Apache DevLake

### Requirement: Last-run stamp enables cadence checks

A successful `scripts/sdd-metrics.sh` run (exit 0 generating a report) MUST write a local stamp file at `.sdd/metrics-last-run` containing at least an ISO calendar date `YYYY-MM-DD`. The stamp path MUST be gitignored (via `.gitignore` entry for the stamp or a broader `.sdd/` rule that covers it). The stamp MUST NOT contain secrets.

#### Scenario: Metrics script completes successfully

- **WHEN** an operator runs `bash scripts/sdd-metrics.sh` and the command exits 0
- **THEN** `.sdd/metrics-last-run` exists and its first line is a `YYYY-MM-DD` date

#### Scenario: Stamp is not versioned

- **WHEN** a developer inspects `git status` after a metrics run
- **THEN** `.sdd/metrics-last-run` does not appear as an untracked file that should be committed (it is ignored)

### Requirement: Cadence check is advisory and opt-in

`scripts/sdd-metrics.sh` MUST support a cadence-check invocation (flag `--check-cadence` or equivalent) that exits non-zero when a nudge is recommended and prints a short advisory message to stdout/stderr, and exits 0 when no nudge is needed. Defaults MUST be: nudge if archives with directory date after the stamp date are ≥ **5**, OR the stamp age is ≥ **30** days, OR (no stamp and ≥ 1 archive dated within the last 30 days). The check MUST NOT run the full metrics report unless separately requested. Cadence checking MUST NOT be a required blocking step of `sdd-gates` CI.

#### Scenario: Five archives since last run

- **WHEN** `.sdd/metrics-last-run` is dated before five or more `openspec/changes/archive/YYYY-MM-DD-*` directories and the operator runs `bash scripts/sdd-metrics.sh --check-cadence`
- **THEN** the command exits non-zero and the message mentions `sdd-metrics.sh` and the playbook (§2.17)

#### Scenario: Fresh within thresholds

- **WHEN** a metrics run happened fewer than 30 days ago and fewer than 5 archives exist after the stamp date
- **THEN** `--check-cadence` exits 0

#### Scenario: Never run but recent archive activity

- **WHEN** the stamp file is absent and at least one archive directory dated within the last 30 days exists
- **THEN** `--check-cadence` recommends a baseline run (non-zero exit)

### Requirement: Mode C preserved — no always-on metrics skill

Cadence nudges MUST remain opt-in suggestions. The repository MUST NOT add an always-on Cursor rule whose sole purpose is to remind about metrics on every chat, and MUST NOT require a dedicated always-loaded metrics skill for discovery. Documentation in `AGENTS.md` and §2.17 remains sufficient for discovery (R3 N/A for a new metrics skill).

#### Scenario: Agent inspects rules for metrics spam

- **WHEN** `.cursor/rules/` is reviewed after this capability extension
- **THEN** no new always-on rule exists that injects metrics reminders into every session
