# sdd-ui-module Specification

## Purpose

Normative requirements for the optional **UI development module** (C1-UI) distributed via `sdd-kit/`, separate from core SDD install (C1). Covers detection of frontend/UI stack, shadcn recommendation with explicit opt-out, documentation pointers in the canonical guide, and post-install state in `openspec/infra.md`. Enables reproducible adoption of the Open Design → Pencil/Figma → UI stack → Impeccable pipeline without duplicating operational detail in `doc/sistema-sdd-pedro.md`.

## Requirements

### Requirement: UI module documentation set

The distribution repository MUST include `doc/design/` with at minimum:

- `000-impeccable-design-system-guia.md`
- `001-pipeline-open-design-shadcn-impeccable.md`
- `002-ui-module-install.md` — install procedure, shadcn decision tree, C1-UI checklist
- `003-ui-stack-adapters.md` — Fase 2 variants without shadcn

Each file MUST state that shadcn is the **default recommended** path; alternatives MUST be documented in `003`.

#### Scenario: Agent discovers UI module from guide

- **WHEN** an operator or agent reads `doc/sistema-sdd-pedro.md` §2.11
- **THEN** it finds pointers to `doc/design/002-*` and `doc/design/001-*` without the full pipeline duplicated in the guide

#### Scenario: Hub ships reference docs

- **WHEN** `sdd-kit/install.sh --profile DOCS_SPECS` completes
- **THEN** `doc/design/002-ui-module-install.md` and `doc/design/003-ui-stack-adapters.md` exist in the target repository

### Requirement: Optional post-C1 install script

`sdd-kit/install-ui-module.sh` MUST exist separately from `sdd-kit/install.sh` and MUST support:

- `--detect` — report frontend presence and detected `UI stack`
- `--dry-run` — print planned operations without writing
- `--apply` — install module artifacts (requires prior C1 or equivalent SDD core)
- `--yes` — skip interactive shadcn recommendation prompt on apply

#### Scenario: Detect skips repository without frontend

- **WHEN** the operator runs `bash sdd-kit/install-ui-module.sh --detect` on a DOCS_SPECS hub without `app/` or `apps/web/`
- **THEN** output indicates `SKIP: no frontend` and exit code 0

#### Scenario: Detect identifies shadcn stack

- **WHEN** the repository contains `components.json` or `components/ui/` with shadcn patterns
- **THEN** `--detect` reports `UI stack: shadcn`

#### Scenario: Apply without confirmation blocked

- **WHEN** the operator runs `--apply` on a tailwind-only repo without `--yes` and without interactive TTY
- **THEN** the script MUST NOT run `npx impeccable install` until shadcn recommendation is resolved (install shadcn or record opt-out to `tailwind-custom`)

### Requirement: shadcn recommended with explicit opt-out

For repositories with Next.js (or equivalent) + Tailwind and no detected design system, `install-ui-module.sh` MUST recommend shadcn/ui installation and MUST allow explicit refusal.

#### Scenario: Node version gate before Impeccable

- **WHEN** Node.js version is below 24 and operator runs `--apply` with Impeccable install
- **THEN** the script MUST warn and skip `npx impeccable install` unless Node 24+ is available (per `research.md` M3)

#### Scenario: Operator accepts shadcn recommendation

- **WHEN** detection yields `tailwind-custom` candidate and operator confirms shadcn install
- **THEN** the script documents or invokes shadcn init per `002` and sets `UI stack: shadcn` in project state

#### Scenario: Operator refuses shadcn

- **WHEN** operator refuses shadcn installation
- **THEN** the script records `UI stack: tailwind-custom`, points to `doc/design/003-ui-stack-adapters.md`, and still allows Impeccable setup if frontend exists

### Requirement: Canonical guide sections for UI module

`doc/sistema-sdd-pedro.md` MUST include:

- **§1.6** (or equivalent) entry for scenario **C1-UI** — optional UI module after C1
- **§2.11** — installation entry point, prerequisites, commands, checklist reference
- **§5.6** — cross-reference table to `doc/design/000` through `003`

The guide sections MUST NOT duplicate flow matrices, agent prompts, or phase detail from `001`.

#### Scenario: Human follows C1 then C1-UI

- **WHEN** an operator completes §2.8 checklist then reads §2.11
- **THEN** they can run `install-ui-module.sh` without re-running core `install.sh`

### Requirement: Project constitution UI stack field

The `openspec/project.md` template (via `sdd-kit` or guide §12.1) MUST include a field documenting UI stack:

`UI stack: shadcn | tailwind-custom | other | none`

#### Scenario: UI stack recorded after apply

- **WHEN** `install-ui-module.sh --apply` completes successfully
- **THEN** `openspec/project.md` or `openspec/infra.md` reflects the chosen UI stack value

### Requirement: Infrastructure manifest UI module section

`openspec/infra.md` MUST include a section **UI Development Module** listing:

- Impeccable install status (✅ / SKIP / pending)
- Detected UI stack
- Optional tools: Open Design, Pencil, Figma MCP (manual / not installed)

#### Scenario: Agent reads infra before UI work

- **WHEN** an agent follows R10 before proposing Impeccable install
- **THEN** `openspec/infra.md` states whether the UI module was applied

### Requirement: Impeccable separation from SDD skills

Documentation in `002-ui-module-install.md` MUST state that `.cursor/skills/impeccable` is separate from SDD-versioned skills and MUST NOT be merged into `verify-task-patterns.sh` skill checks.

#### Scenario: Post-install skill layout

- **WHEN** Impeccable is installed via UI module
- **THEN** `002` documents the path `.cursor/skills/impeccable` as distinct from `.claude/skills/` SDD skills

### Requirement: Evaluation before kit adoption

`doc/avaliacoes/2026-06-27-sdd-ui-development-module.md` MUST exist with decision **Adopted** (conditional on this change) covering Impeccable, Open Design, and Pencil as an aggregated UI module evaluation per guide §5.5.

#### Scenario: New tool evaluation lookup

- **WHEN** an agent checks whether UI module tools are pre-evaluated
- **THEN** `doc/avaliacoes/README.md` indexes the aggregated evaluation

### Requirement: MANIFEST entries for UI module

`sdd-kit/MANIFEST.yaml` MUST list `install-ui-module.sh` and all four `doc/design/*` files with appropriate `profiles` and `gate` commands.

#### Scenario: Upgrade diff includes UI module files

- **WHEN** `scripts/sdd-upgrade-diff.sh` reads MANIFEST
- **THEN** `doc/design/002-ui-module-install.md` appears in the diff inventory

## Cross-references

- Procedural guide: `doc/sistema-sdd-pedro.md` §2.11, §5.6
- Pipeline detail: `doc/design/001-pipeline-open-design-shadcn-impeccable.md`
- Install kit pattern: `openspec/specs/sdd-install-kit/spec.md`
- Evaluations index: `doc/avaliacoes/README.md` §5.5
