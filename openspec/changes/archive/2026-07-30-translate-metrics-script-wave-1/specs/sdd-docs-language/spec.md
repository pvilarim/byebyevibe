## ADDED Requirements

### Requirement: Metrics-script wave-1 active-change artifacts are English

The following active-change artifact paths under `openspec/changes/add-sdd-metrics-script/` MUST be written in English after the metrics-script substitution wave: `proposal.md`, `design.md`, and `tasks.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, script flags such as `--since` / `--output` / `--help`, package pins, MANIFEST keys including `merge:`, `gate:`, and `sha256:`, URLs, fenced shell commands, kit version bump `1.5.0` → `1.6.0`, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Historical apply outcomes (mode C on-demand script, M1–M4 proxy definitions from git + archive, 6-point registry with R3 N/A, pilot-exception rationale, DevLake remains deferred, rollback plan, and task completion markers) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Metrics-script wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-metrics-script/proposal.md,openspec/changes/add-sdd-metrics-script/design.md,openspec/changes/add-sdd-metrics-script/tasks.md` after the metrics-script substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for metrics-script wave-1

- **WHEN** the metrics-script substitution wave apply completes
- **THEN** English content is at the three listed `add-sdd-metrics-script` artifact paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: Metrics-script historical outcomes remain stable

- **WHEN** an agent reads the translated proposal, design, and tasks for `add-sdd-metrics-script`
- **THEN** the mode C contract, M1–M4 proxy definitions, CLI flags, kit MANIFEST bump 1.5.0→1.6.0, 6-point registry, pilot-exception approval, DevLake deferred status, rollback steps, and historical `[x]` completion markers remain equivalent to the pre-wave Portuguese artifacts while surrounding prose and headings are English
