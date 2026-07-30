## ADDED Requirements

### Requirement: Probity module documentation exists

The distribution repository MUST include installation documentation for the Probity module at `doc/design/004-probity-module-install.md` (or equivalent path referenced from `doc/sistema-sdd-pedro.md` §2.16). The document MUST describe `--detect`, `--apply`, `--dry-run`, `--yes`, `--uninstall`, plugin install, pilot criteria, and rollback.

#### Scenario: Agent discovers Probity module from guide

- **WHEN** an operator or agent reads `doc/sistema-sdd-pedro.md` §2.16
- **THEN** it finds pointers to the install doc and `sdd-kit/install-probity-module.sh` without duplicating full Probity upstream docs

#### Scenario: Hub ships reference install doc

- **WHEN** `sdd-kit/install.sh --profile DOCS_SPECS` completes on the distribution hub
- **THEN** `doc/design/004-probity-module-install.md` exists in the target repository (distributed via kit templates)

---

### Requirement: Optional post-C1 install script

`sdd-kit/install-probity-module.sh` MUST exist separately from `sdd-kit/install.sh` and MUST support:

- `--detect` — report test runner presence and Probity applicability
- `--dry-run` — print planned operations without writing
- `--apply` — install module artifacts (requires prior C1 or equivalent SDD core)
- `--yes` — skip interactive npm install prompt on apply
- `--uninstall` — remove Probity config, documented hook entries, and devDependency when present

#### Scenario: Detect skips repository without test runner

- **WHEN** the operator runs `bash sdd-kit/install-probity-module.sh --detect` on a DOCS_SPECS hub without Vitest, Jest, or pytest
- **THEN** output indicates `SKIP: no test runner` and exit code 0

#### Scenario: Detect identifies Vitest

- **WHEN** the repository contains `vitest` in `package.json` dependencies or scripts
- **THEN** `--detect` reports `Test runner: vitest` and `Probity: applicable`

#### Scenario: Apply without prior C1 blocked or warned

- **WHEN** the operator runs `--apply` on a repository without `AGENTS.md` and `openspec/infra.md`
- **THEN** the script exits non-zero or prints a clear warning that C1 core SDD install is required first

---

### Requirement: Probity config template shipped

The kit MUST ship `sdd-kit/templates/probity.config.ts` (or equivalent template path) with:

- `enforceTdd()` scoped to production code paths (`app/**`, `components/**`, `lib/**`, `src/**`) and test paths
- Exclusions for `doc/**`, `openspec/**`, `sdd-kit/**`
- SDD R6 addendum in `instructions`
- Optional `forbidCommandPattern(/rm\s+-rf/)` aligned with security rule 050-security

#### Scenario: Apply copies config to repo root

- **WHEN** `install-probity-module.sh --apply` completes successfully on an APP repository
- **THEN** `probity.config.ts` exists at the repository root

#### Scenario: Missing config fails closed

- **WHEN** Probity hook is active but `probity.config.ts` is absent
- **THEN** Probity blocks write actions (fail-closed) until config is restored

---

### Requirement: Pinned Probity version

The module MUST pin `@nizos/probity` to version **1.10.0** in install script and `openspec/infra.md`. The version MUST be verifiable with `npm view @nizos/probity@1.10.0 version`.

#### Scenario: Infra manifest lists pinned version

- **WHEN** an agent reads `openspec/infra.md` after module install (R10)
- **THEN** it finds `@nizos/probity@1.10.0` in the Probity Module section with status ✅ or SKIP

---

### Requirement: enforceTdd active on production paths during apply

For APP/HYBRID repositories with the module active, `enforceTdd()` MUST be configured to block production code writes unless session history shows a failing test that the pending change addresses. The rule MUST NOT apply to documentation-only paths excluded by config globs.

#### Scenario: Bug fix blocked without failing test

- **WHEN** an agent attempts to edit production code under `src/` during a type B apply without a prior failing test in the session transcript
- **THEN** Probity blocks the write and surfaces TDD guidance to the agent

#### Scenario: Documentation edit allowed

- **WHEN** an agent edits `doc/sistema-sdd-pedro.md` during a type A task
- **THEN** Probity does not block the write (path excluded by globs or no hook on docs paths)

---

### Requirement: Module is optional — not core SDD

Probity MUST NOT be installed by default `sdd-kit/install.sh`. It MUST be an explicit post-C1 module for APP/HYBRID profiles only. DOCS_SPECS hubs without tests MUST skip the module without error.

#### Scenario: Core C1 install does not install Probity

- **WHEN** the operator runs `bash sdd-kit/install.sh --profile DOCS_SPECS`
- **THEN** `@nizos/probity` is not added to any `package.json` and `probity.config.ts` is not created

#### Scenario: MANIFEST lists module with APP HYBRID profiles

- **WHEN** the operator reads `sdd-kit/MANIFEST.yaml` after this change is archived
- **THEN** `install-probity-module.sh` and `probity.config.ts` template are listed with `profiles: [APP, HYBRID]` only

---

### Requirement: Pilot required before MANIFEST promotion

Promotion of Probity entries to `sdd-kit/MANIFEST.yaml` on consumer repos MUST follow a pilot on an APP worktree with quantified success criteria documented in `design.md` (latency p95, false positive rate, type B R6 compliance, Cursor hook verification).

#### Scenario: Pilot failure blocks promotion

- **WHEN** pilot criteria are not met on the APP worktree
- **THEN** the operator MUST NOT merge MANIFEST changes promoting Probity as default-ready; evaluation status remains "Adoptado (pendente piloto)"

---

### Requirement: Six-point contract registration

Per `metodologia-insercao.md` Fase 3, the module MUST be registered in: `openspec/infra.md` (R1), `AGENTS.md` (R2), optional skill (R3), `doc/sistema-sdd-pedro.md` §2.16 (R4), `doc/avaliacoes/` (R5), and `sdd-kit/` (R6).

#### Scenario: Agent discovers Probity via infra.md

- **WHEN** an agent reads `openspec/infra.md` looking for TDD enforcement (R10)
- **THEN** it finds the Probity Module section with version, status, and verification command

---

### Requirement: TDD Guard supersession documented

Documentation that previously cited TDD Guard as the G2 candidate MUST be updated to cite Probity, with a one-line historical note that TDD Guard was superseded by Probity (2026-07).

#### Scenario: Research doc updated

- **WHEN** an agent reads `openspec/changes/explore-oss-coverage-gaps/research.md` section G2
- **THEN** the primary candidate is Probity, with a historical note about TDD Guard supersession
