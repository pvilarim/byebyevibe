## ADDED Requirements

### Requirement: Supply-chain wave-1 active-change artifacts are English

The following active-change artifact paths under `openspec/changes/add-supply-chain-gates/` MUST be written in English after the supply-chain wave-1 substitution: `proposal.md`, `tasks.md`, and `specs/sdd-ci-gates/spec.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, workflow names, OSV action SHA pins, package pins, MANIFEST keys including `merge:`, `gate:`, and `sha256:`, URLs, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Historical apply outcomes (Renovate + OSV templates by profile, Renovate SKIP on DOCS_SPECS, OSV fail-closed when a lockfile is present and SKIP when absent, 6-point registry, G8 → Adopted, OSV pilot exception as CI-only step, Renovate GitHub app manual activation, and task completion markers) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Supply-chain wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-supply-chain-gates/proposal.md,openspec/changes/add-supply-chain-gates/tasks.md,openspec/changes/add-supply-chain-gates/specs/sdd-ci-gates/spec.md` after the supply-chain wave-1 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for supply-chain wave-1

- **WHEN** the supply-chain wave-1 substitution apply completes
- **THEN** English content is at the three listed `add-supply-chain-gates` artifact paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: Supply-chain historical outcomes remain stable

- **WHEN** an agent reads the translated proposal, tasks, and sdd-ci-gates delta for `add-supply-chain-gates`
- **THEN** the Renovate profile SKIP rules, OSV fail-closed-when-lockfile contract, action SHA pins, G8 Adopted status, pilot-exception rationale, 6-point registry, rollback intent, and historical `[x]` completion markers remain equivalent to the pre-wave Portuguese artifacts while surrounding prose and headings are English
