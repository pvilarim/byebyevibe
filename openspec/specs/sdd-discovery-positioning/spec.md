# sdd-discovery-positioning Specification

## Purpose

Normative requirements for public discovery and positioning surfaces of ByeByeVibe (SDD Install Kit payload in `sdd-kit/`): root README, market/competitive evaluation document, first-contact quickstart, and manual GitHub About/topics checklist. Positions the project as the control plane from vibe coding to shippable AI engineering — not as an application boilerplate.

## Requirements

### Requirement: Root README exists with vibe-to-agentic positioning

The hub repository MUST include a root `README.md` written primarily in English for GitHub discovery. The README MUST use the public display name **ByeByeVibe** as the primary H1 (or equivalent top-level title). The README MUST communicate the positioning “from vibe coding to shippable AI engineering” (or the approved equivalent tagline), MUST state that the project is not an application/boilerplate starter and is the SDD control plane (OpenSpec + graphs + gates), MUST name the composed stack (OpenSpec, GitNexus, Graphify), MUST clarify that the install payload path remains `sdd-kit/`, and MUST provide a concrete install or dry-run CTA (e.g. `bash sdd-kit/install.sh --profile <PROFILE> --dry-run`).

#### Scenario: Visitor opens repository root

- **WHEN** a visitor opens the hub repository on GitHub
- **THEN** a root `README.md` is present and its opening section titles the project **ByeByeVibe**, includes the vibe-to-agentic (shippable AI engineering) positioning, and an explicit non-boilerplate / control-plane disclaimer

#### Scenario: CTA is copy-pasteable

- **WHEN** a visitor reads the Get Started / install section of the root README
- **THEN** they can copy a shell command that invokes `sdd-kit/install.sh` (dry-run or apply) without reading the full procedural guide first

#### Scenario: Dual naming is explicit

- **WHEN** a visitor reads the opening or a glossary near the top of the root README
- **THEN** they can tell that **ByeByeVibe** is the public name and `sdd-kit/` is the install payload path

### Requirement: Root README includes demo and capability overview

The root README MUST include (1) a short narrative or dialogue demonstrating the `/opsx:explore` → `/opsx:propose` → `/opsx:apply` → `/opsx:archive` flow (or equivalent OpenSpec workflow names) and (2) a structured overview of what the kit includes (at least: specs/OpenSpec, code graph/GitNexus, knowledge graph/Graphify, CI gates, and optional modules such as UI or Probity when present in the kit).

#### Scenario: Demo section present

- **WHEN** the root README is read
- **THEN** it contains a demo section referencing the opsx (or OpenSpec) propose/apply/archive workflow

#### Scenario: Capability table or list present

- **WHEN** the root README is read
- **THEN** it lists or tables the major kit capabilities including OpenSpec, GitNexus, and Graphify

### Requirement: Competitive evaluation document is the lasting research artifact

The repository MUST include `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (or a successor path linked from `doc/avaliacoes/README.md`) that captures market keywords, competitor comparison, semantic feature↔project map, and the product backlog derived from the analysis (including deferred items). The evaluation MUST record public name **ByeByeVibe** as the adopted P10 decision (docs) and MUST keep GitHub repository rename as a manual operator action when not yet performed. The evaluation MUST be indexed in `doc/avaliacoes/README.md`.

#### Scenario: Evaluation discoverable from index

- **WHEN** an operator or agent opens `doc/avaliacoes/README.md`
- **THEN** a row exists pointing to the 2026-07-26 discovery/positioning evaluation

#### Scenario: Backlog of product improvements recorded

- **WHEN** the evaluation document is read
- **THEN** it records adopted discovery surfaces, the ByeByeVibe public-name decision for P10, remaining deferred items (e.g. GIF, i18n waves), and explicit non-goals for app scaffolding

### Requirement: First-contact quickstart in the canonical guide

`doc/sistema-sdd-pedro.md` MUST include a short first-contact / vibe-coder quickstart section that points to the root README and `sdd-kit/install.sh`, without replacing the full installation procedure. The section MUST be linked from the guide’s “Como usar este documento” table or index.

#### Scenario: Vibe coder path exists in guide

- **WHEN** a newcomer opens `doc/sistema-sdd-pedro.md` looking for a minimal path
- **THEN** they find a short quickstart section that references the root README and an install dry-run command

### Requirement: Manual GitHub About and topics checklist

Discovery metadata that cannot be versioned in git (repository About description, GitHub topics, and repository rename) MUST be documented as an `[AÇÃO MANUAL NECESSÁRIA]` checklist in the evaluation document and/or root README. The checklist MUST include: (1) recommended About blurb naming **ByeByeVibe** and the vibe→agentic positioning; (2) topic list from the research (at least: `vibe-coding`, `spec-driven-development`, `context-engineering`, `claude-code`, `cursor`); (3) recommended repository slug rename from `gitnexus-graphify-openspec` to `byebyevibe` (or the slug recorded in the change design).

#### Scenario: Operator finds manual checklist

- **WHEN** an operator finishes applying this capability’s documentation tasks
- **THEN** they can locate a checklist that lists the About text, topics, and repo rename action to perform in GitHub repository settings

#### Scenario: About names ByeByeVibe

- **WHEN** the operator reads the recommended About blurb in the checklist
- **THEN** the blurb includes the display name **ByeByeVibe** (not only the legacy working title “SDD Install Kit”)

### Requirement: Positioning forbids pretending to be an app starter

Public discovery surfaces (root README and kit README positioning intro) MUST NOT claim ByeByeVibe / the SDD install kit is a full-stack application template, Next.js starter, or equivalent Camada B boilerplate. They MUST describe the project as a control plane / install kit for agent-assisted development.

#### Scenario: Anti-boilerplate language present

- **WHEN** the root README hero or equivalent opening is read
- **THEN** it explicitly disclaims being an application boilerplate or starter template

### Requirement: Root README includes maintainer links

The root `README.md` MUST include a short Maintainer (or Author) section **below** the hero and primary capability sections, linking to:

- LinkedIn: `https://www.linkedin.com/in/pedrovilarim/`
- Portfolio: `https://pedrocodeart.netlify.app/`

The section MUST NOT place social or portfolio links in the first-viewport hero block. Agents MUST NOT invent alternate LinkedIn or portfolio URLs.

#### Scenario: Maintainer links present

- **WHEN** the root README is read
- **THEN** it contains a Maintainer/Author section with the canonical LinkedIn and portfolio URLs above

#### Scenario: Maintainer section not in hero

- **WHEN** LinkedIn and portfolio URLs are present in the root README
- **THEN** they appear in a Maintainer/Author section after the primary discovery content, not as hero chrome
