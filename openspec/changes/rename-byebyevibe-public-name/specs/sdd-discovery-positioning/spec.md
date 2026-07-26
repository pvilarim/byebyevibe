## MODIFIED Requirements

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

### Requirement: Manual GitHub About and topics checklist

Discovery metadata that cannot be versioned in git (repository About description, GitHub topics, and repository rename) MUST be documented as an `[AÇÃO MANUAL NECESSÁRIA]` checklist in the evaluation document and/or root README. The checklist MUST include: (1) recommended About blurb naming **ByeByeVibe** and the vibe→agentic positioning; (2) topic list from the research (at least: `vibe-coding`, `spec-driven-development`, `context-engineering`, `claude-code`, `cursor`); (3) recommended repository slug rename from `gitnexus-graphify-openspec` to `byebyevibe` (or the slug recorded in the change design).

#### Scenario: Operator finds manual checklist

- **WHEN** an operator finishes applying this capability’s documentation tasks
- **THEN** they can locate a checklist that lists the About text, topics, and repo rename action to perform in GitHub repository settings

#### Scenario: About names ByeByeVibe

- **WHEN** the operator reads the recommended About blurb in the checklist
- **THEN** the blurb includes the display name **ByeByeVibe** (not only the legacy working title “SDD Install Kit”)

### Requirement: Competitive evaluation document is the lasting research artifact

The repository MUST include `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (or a successor path linked from `doc/avaliacoes/README.md`) that captures market keywords, competitor comparison, semantic feature↔project map, and the product backlog derived from the analysis (including deferred items). The evaluation MUST record public name **ByeByeVibe** as the adopted P10 decision (docs) and MUST keep GitHub repository rename as a manual operator action when not yet performed. The evaluation MUST be indexed in `doc/avaliacoes/README.md`.

#### Scenario: Evaluation discoverable from index

- **WHEN** an operator or agent opens `doc/avaliacoes/README.md`
- **THEN** a row exists pointing to the 2026-07-26 discovery/positioning evaluation

#### Scenario: Backlog of product improvements recorded

- **WHEN** the evaluation document is read
- **THEN** it records adopted discovery surfaces, the ByeByeVibe public-name decision for P10, remaining deferred items (e.g. GIF, i18n waves), and explicit non-goals for app scaffolding

### Requirement: Positioning forbids pretending to be an app starter

Public discovery surfaces (root README and kit README positioning intro) MUST NOT claim ByeByeVibe / the SDD install kit is a full-stack application template, Next.js starter, or equivalent Camada B boilerplate. They MUST describe the project as a control plane / install kit for agent-assisted development.

#### Scenario: Anti-boilerplate language present

- **WHEN** the root README hero or equivalent opening is read
- **THEN** it explicitly disclaims being an application boilerplate or starter template

## ADDED Requirements

### Requirement: Root README may include maintainer links

The root `README.md` MAY include a short Maintainer (or Author) section **below** the hero and primary capability sections, linking to the maintainer’s public LinkedIn and/or portfolio URLs when those URLs are provided by the operator. The section MUST NOT place social or portfolio links in the first-viewport hero block. Agents MUST NOT invent LinkedIn or portfolio URLs.

#### Scenario: Maintainer section without inventing URLs

- **WHEN** LinkedIn/portfolio URLs have not been supplied by the operator
- **THEN** the README either omits the links or uses an explicit `[AÇÃO MANUAL NECESSÁRIA]` placeholder — never fabricated URLs

#### Scenario: Maintainer section not in hero

- **WHEN** LinkedIn and/or portfolio URLs are present in the root README
- **THEN** they appear in a Maintainer/Author section after the primary discovery content, not as hero chrome
