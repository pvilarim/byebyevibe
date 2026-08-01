## ADDED Requirements

### Requirement: Root README v2 section order and above-fold value

The root `README.md` MUST follow the discovery v2 section order for first-contact visitors: (1) hero with **ByeByeVibe** H1, approved tagline, dual naming (`sdd-kit/` payload), and the phrase that the project is an **installable toolkit for AI-assisted development**; (2) a **Why install this** (or equivalent) subsection with at least four value bullets appearing **before** the Get started CTA; (3) explicit anti-boilerplate / control-plane disclaimer in the above-fold block; (4) Get started with copy-pasteable `sdd-kit/install.sh` dry-run command. Subsequent sections MUST include, in order: The problem; Core tools; User-friendly OpenSpec; Demo; Optional modules; Calibrate as you go; Not another starter kit; Who it's for; Compare; Stack & docs; manual About/topics checklist; Maintainer.

#### Scenario: Value bullets appear before install CTA

- **WHEN** a visitor reads the root README from the top
- **THEN** a "Why install" (or equivalent) value subsection with at least four bullets appears before the "Get started" install command block

#### Scenario: Toolkit phrase is explicit

- **WHEN** a visitor reads the opening of the root README
- **THEN** the README states that ByeByeVibe is an installable toolkit for AI-assisted development (Cursor and Claude Code)

#### Scenario: AI-assisted development wording present

- **WHEN** the root README opening is searched for discovery keywords
- **THEN** it contains the phrase "AI-assisted development" (case-insensitive)

### Requirement: Root README documents /opsx:help day-1 operator map

The root README MUST document `/opsx:help` as the day-1 operator map for the ByeByeVibe control plane, MUST state that it complements upstream `/opsx:onboard`, and MUST link to `doc/sdd-operator-day1.md` (or the canonical day-1 doc path recorded in infra).

#### Scenario: Help command documented

- **WHEN** the root README is read
- **THEN** it references `/opsx:help` (or `opsx:help`) and describes it as a day-1 operator map

#### Scenario: Onboard vs help framing

- **WHEN** the User-friendly OpenSpec section (or equivalent) is read
- **THEN** both `/opsx:help` and the OpenSpec lifecycle (`explore` → `propose` → `apply` → `archive`) are named

### Requirement: Root README core tools use didactic What / Without it table

The root README MUST include a **Core tools** section with a table (or equivalent structured overview) using **What it is** and **Without it** columns (or rows) for at least: OpenSpec, GitNexus, Graphify, `sdd-kit/`, CI `sdd-gates`, and session locks.

#### Scenario: Didactic columns present

- **WHEN** the Core tools section of the root README is read
- **THEN** it uses What / Without it framing for the listed core tools

#### Scenario: Composed stack named in table

- **WHEN** the Core tools table is read
- **THEN** rows or entries exist for OpenSpec, GitNexus, and Graphify

### Requirement: Root README optional modules block

The root README MUST include a dedicated **Optional modules** section (or equivalent titled block) that names at least C1-UI (UI module), G2 Probity, and post-apply review skills, with pointers to the canonical guide sections (e.g. §2.11, §2.16).

#### Scenario: Optional modules section exists

- **WHEN** the root README is read
- **THEN** a section titled or labeled for optional modules is present and is distinct from the core tools table

#### Scenario: C1-UI and G2 named

- **WHEN** the optional modules section is read
- **THEN** it references C1-UI and G2 Probity (or Probity) by name or code

### Requirement: Root README G4 calibrate-as-you-go without ML claims

The root README MUST include a **Calibrate as you go** (or equivalent) subsection describing SDD metrics via `scripts/sdd-metrics.sh` as process retrospectives (volume, lead time, rework) and MUST NOT claim machine learning, self-learning agents, or automatic kit adaptation.

#### Scenario: Metrics script referenced

- **WHEN** the root README is read
- **THEN** it references `sdd-metrics.sh` or "calibrate as you go" framing for G4 metrics

#### Scenario: No ML claims

- **WHEN** the root README is searched for forbidden G4 claims
- **THEN** it does not assert ML, self-learning, or automatic adaptation of the kit based on metrics

## MODIFIED Requirements

### Requirement: Root README includes demo and capability overview

The root README MUST include (1) a short narrative or dialogue demonstrating the `/opsx:explore` → `/opsx:propose` → `/opsx:apply` → `/opsx:archive` flow (or equivalent OpenSpec workflow names) and (2) a structured overview of what the kit includes. The capability overview MUST cover at least: specs/OpenSpec, code graph/GitNexus, knowledge graph/Graphify, CI gates, session coordination, and optional modules (UI, Probity, metrics) in a dedicated optional-modules section separate from the core tools table.

#### Scenario: Demo section present

- **WHEN** the root README is read
- **THEN** it contains a demo section referencing the opsx (or OpenSpec) propose/apply/archive workflow

#### Scenario: Capability table or list present

- **WHEN** the root README is read
- **THEN** it lists or tables the major kit capabilities including OpenSpec, GitNexus, and Graphify

#### Scenario: Optional modules not only inline in core table

- **WHEN** the root README is read
- **THEN** optional modules (e.g. C1-UI, G2 Probity) appear in a dedicated optional-modules section, not only as a single row in the core tools table

### Requirement: Competitive evaluation document is the lasting research artifact

The repository MUST include `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (or a successor path linked from `doc/avaliacoes/README.md`) that captures market keywords, competitor comparison, semantic feature↔project map, and the product backlog derived from the analysis (including deferred items). The evaluation MUST record public name **ByeByeVibe** as the adopted P10 decision (docs) and MUST keep GitHub repository rename as a manual operator action when not yet performed. The evaluation MUST be indexed in `doc/avaliacoes/README.md`. The evaluation MUST record the README discovery v2 layout decision (hybrid conversion + pedagogy, section order, `/opsx:help`, optional modules block) when change `update-readme-discovery-v2` is applied, without removing or downgrading deferred backlog items P5 (GIF) or P11/P12 (i18n / root CHANGELOG).

#### Scenario: Evaluation discoverable from index

- **WHEN** an operator or agent opens `doc/avaliacoes/README.md`
- **THEN** a row exists pointing to the 2026-07-26 discovery/positioning evaluation

#### Scenario: Backlog of product improvements recorded

- **WHEN** the evaluation document is read
- **THEN** it records adopted discovery surfaces, the ByeByeVibe public-name decision for P10, remaining deferred items (e.g. GIF, i18n waves), and explicit non-goals for app scaffolding

#### Scenario: V2 layout decision recorded

- **WHEN** the evaluation document roadmap or decisions section is read after v2 apply
- **THEN** it documents the README v2 hybrid layout and references change `update-readme-discovery-v2`
