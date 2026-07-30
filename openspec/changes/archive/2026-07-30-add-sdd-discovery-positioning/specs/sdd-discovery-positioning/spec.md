# sdd-discovery-positioning Specification (delta)

## Purpose

Normative requirements for public discovery and positioning surfaces of the SDD Install Kit: root README, market/competitive evaluation document, first-contact quickstart, and manual GitHub About/topics checklist. Positions the kit as the control plane from vibe coding to agentic engineering — not as an application boilerplate.

## ADDED Requirements

### Requirement: Root README exists with vibe-to-agentic positioning

The hub repository MUST include a root `README.md` written primarily in English for GitHub discovery. The README MUST communicate the positioning “from vibe coding to agentic engineering” (or equivalent wording), MUST state that the kit is not an application/boilerplate starter, MUST name the composed stack (OpenSpec, GitNexus, Graphify), and MUST provide a concrete install or dry-run CTA (e.g. `bash sdd-kit/install.sh --profile <PROFILE> --dry-run`).

#### Scenario: Visitor opens repository root

- **WHEN** a visitor opens the hub repository on GitHub
- **THEN** a root `README.md` is present and its opening section includes the vibe-to-agentic positioning and an explicit non-boilerplate disclaimer

#### Scenario: CTA is copy-pasteable

- **WHEN** a visitor reads the Get Started / install section of the root README
- **THEN** they can copy a shell command that invokes `sdd-kit/install.sh` (dry-run or apply) without reading the full procedural guide first

### Requirement: Root README includes demo and capability overview

The root README MUST include (1) a short narrative or dialogue demonstrating the `/opsx:explore` → `/opsx:propose` → `/opsx:apply` → `/opsx:archive` flow (or equivalent OpenSpec workflow names) and (2) a structured overview of what the kit includes (at least: specs/OpenSpec, code graph/GitNexus, knowledge graph/Graphify, CI gates, and optional modules such as UI or Probity when present in the kit).

#### Scenario: Demo section present

- **WHEN** the root README is read
- **THEN** it contains a demo section referencing the opsx (or OpenSpec) propose/apply/archive workflow

#### Scenario: Capability table or list present

- **WHEN** the root README is read
- **THEN** it lists or tables the major kit capabilities including OpenSpec, GitNexus, and Graphify

### Requirement: Competitive evaluation document is the lasting research artifact

The repository MUST include `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (or a successor path linked from `doc/avaliacoes/README.md`) that captures market keywords, competitor comparison, semantic feature↔project map, and the product backlog derived from the analysis (including deferred items). The evaluation MUST be indexed in `doc/avaliacoes/README.md`.

#### Scenario: Evaluation discoverable from index

- **WHEN** an operator or agent opens `doc/avaliacoes/README.md`
- **THEN** a row exists pointing to the 2026-07-26 discovery/positioning evaluation

#### Scenario: Backlog of product improvements recorded

- **WHEN** the evaluation document is read
- **THEN** it records both adopted discovery surfaces and deferred product improvements (e.g. GIF, Pages, Discord, repo rename) with explicit non-goals for app scaffolding

### Requirement: First-contact quickstart in the canonical guide

`doc/sistema-sdd-pedro.md` MUST include a short first-contact / vibe-coder quickstart section that points to the root README and `sdd-kit/install.sh`, without replacing the full installation procedure. The section MUST be linked from the guide’s “Como usar este documento” table or index.

#### Scenario: Vibe coder path exists in guide

- **WHEN** a newcomer opens `doc/sistema-sdd-pedro.md` looking for a minimal path
- **THEN** they find a short quickstart section that references the root README and an install dry-run command

### Requirement: Manual GitHub About and topics checklist

Discovery metadata that cannot be versioned in git (repository About description and GitHub topics) MUST be documented as an `[AÇÃO MANUAL NECESSÁRIA]` checklist in the evaluation document and/or root README, including the recommended About blurb and topic list from the research (at least: `vibe-coding`, `spec-driven-development`, `context-engineering`, `claude-code`, `cursor`).

#### Scenario: Operator finds manual checklist

- **WHEN** an operator finishes applying this capability’s documentation tasks
- **THEN** they can locate a checklist that lists the About text and topics to set in GitHub repository settings

### Requirement: Positioning forbids pretending to be an app starter

Public discovery surfaces (root README and kit README positioning intro) MUST NOT claim the SDD Kit is a full-stack application template, Next.js starter, or equivalent Camada B boilerplate. They MUST describe the kit as a control plane / install kit for agent-assisted development.

#### Scenario: Anti-boilerplate language present

- **WHEN** the root README hero or equivalent opening is read
- **THEN** it explicitly disclaims being an application boilerplate or starter template
