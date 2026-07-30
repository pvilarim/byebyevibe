## ADDED Requirements

### Requirement: Metrics-cadence wave-1 active-change artifacts are English

The following active-change artifact paths under `openspec/changes/add-sdd-metrics-cadence-nudge/` MUST be written in English after the metrics-cadence substitution wave: `proposal.md`, `design.md`, and `tasks.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, skill names including `openspec-archive-change`, script flags such as `--check-cadence`, package pins, URLs, fenced shell commands, cadence defaults N=5 and T=30, stamp path `.sdd/metrics-last-run`, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Historical apply outcomes (Interpret→act playbook, advisory archive Session Handoff nudge, stamp write on successful metrics run, mode C opt-in, pilot-exception rationale, rollback plan, and task completion markers) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Metrics-cadence wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-metrics-cadence-nudge/proposal.md,openspec/changes/add-sdd-metrics-cadence-nudge/design.md,openspec/changes/add-sdd-metrics-cadence-nudge/tasks.md` after the metrics-cadence substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for metrics-cadence wave-1

- **WHEN** the metrics-cadence substitution wave apply completes
- **THEN** English content is at the three listed `add-sdd-metrics-cadence-nudge` artifact paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: Metrics-cadence historical outcomes remain stable

- **WHEN** an agent reads the translated proposal, design, and tasks for `add-sdd-metrics-cadence-nudge`
- **THEN** the playbook contract, `--check-cadence` advisory-only nudge, stamp path, N=5 / T=30 defaults, pilot-exception approval, rollback steps, and historical `[x]` completion markers remain equivalent to the pre-wave Portuguese artifacts while surrounding prose and headings are English
