## ADDED Requirements

### Requirement: Archive Session Handoff includes metrics cadence nudge when due

When the archive phase completes successfully, the `openspec-archive-change` skill Session Handoff MUST incorporate an advisory metrics cadence nudge if `bash scripts/sdd-metrics.sh --check-cadence` (or equivalent) indicates a nudge is due. The nudge MUST include the command to run metrics and a pointer to the §2.17 playbook. The nudge MUST NOT auto-execute the metrics report, MUST NOT block archive completion, and MUST NOT be required when the metrics script is absent (SKIP with no failure).

#### Scenario: Archive completes and cadence is due

- **WHEN** an operator finishes `/opsx:archive` for a change and `--check-cadence` exits non-zero
- **THEN** the Session Handoff text includes an advisory suggesting `bash scripts/sdd-metrics.sh` and reading the interpretation playbook in §2.17

#### Scenario: Archive completes and cadence is fresh

- **WHEN** an operator finishes `/opsx:archive` and `--check-cadence` exits 0
- **THEN** the Session Handoff omits the metrics nudge block (core handoff unchanged)

#### Scenario: Metrics script not installed

- **WHEN** `scripts/sdd-metrics.sh` is missing in the repository
- **THEN** archive Session Handoff still succeeds without failing the archive phase
