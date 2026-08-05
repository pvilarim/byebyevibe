# sdd-discovery-positioning Specification

## Purpose

Normative requirements for public discovery and positioning surfaces of ByeByeVibe (SDD Install Kit payload in `sdd-kit/`): root README, market/competitive evaluation document, first-contact quickstart, and manual GitHub About/topics checklist. Positions the project as the control plane from vibe coding to shippable AI engineering — not as an application boilerplate.
## Requirements
### Requirement: Root README exists with vibe-to-agentic positioning

The hub repository MUST include a root `README.md` written primarily in English for GitHub discovery. The README MUST use the public display name **ByeByeVibe** as the primary H1 (or equivalent top-level title). The README MUST communicate the positioning "from vibe coding to shippable AI engineering" (or the approved equivalent tagline), MUST state that the project is not an application/boilerplate starter and is the SDD control plane (OpenSpec + graphs + gates), MUST name the composed stack (OpenSpec, GitNexus, Graphify) with each name hyperlinked to its GitHub repository, MUST include a pointer from the intro area to the "Core tools" section (or its current heading) so a visitor can find what each named project does, MUST clarify that the install payload path remains `sdd-kit/`, and MUST provide a concrete install or dry-run CTA (e.g. `bash sdd-kit/install.sh --profile <PROFILE> --dry-run`).

#### Scenario: Visitor opens repository root

- **WHEN** a visitor opens the hub repository on GitHub
- **THEN** a root `README.md` is present and its opening section titles the project **ByeByeVibe**, includes the vibe-to-agentic (shippable AI engineering) positioning, and an explicit non-boilerplate / control-plane disclaimer

#### Scenario: CTA is copy-pasteable

- **WHEN** a visitor reads the Get Started / install section of the root README
- **THEN** they can copy a shell command that invokes `sdd-kit/install.sh` (dry-run or apply) without reading the full procedural guide first

#### Scenario: Dual naming is explicit

- **WHEN** a visitor reads the opening or a glossary near the top of the root README
- **THEN** they can tell that **ByeByeVibe** is the public name and `sdd-kit/` is the install payload path

#### Scenario: Composed stack names are links

- **WHEN** a visitor reads any section of the root README that names OpenSpec, GitNexus, or Graphify
- **THEN** each name is a Markdown hyperlink to its GitHub repository (OpenSpec → `https://github.com/Fission-AI/OpenSpec`, GitNexus → `https://github.com/abhigyanpatwari/GitNexus`, Graphify → `https://github.com/Graphify-Labs/graphify`)

#### Scenario: Intro points to Core tools

- **WHEN** a visitor reads the intro area of the root README (the block right after the opening positioning paragraph)
- **THEN** they find a link into the "Core tools" section explaining what each named project does

### Requirement: Root README v2 section order and above-fold value

The root `README.md` MUST follow the discovery section order for first-contact visitors: (1) hero with **ByeByeVibe** H1, approved tagline, dual naming (`sdd-kit/` payload), and the phrase that the project is an **installable toolkit for AI-assisted development**; (2) a **Why install this** (or equivalent) subsection with at least four value bullets appearing **before** the Get started CTA; (3) explicit anti-boilerplate / control-plane disclaimer in the above-fold block; (4) Get started with copy-pasteable `sdd-kit/install.sh` dry-run command. Subsequent sections MUST include, in order: The problem; Core tools; User-friendly OpenSpec; Demo; Optional modules; Calibrate as you go; Not another starter kit; Who it's for; Stack & docs; manual About/topics checklist; Maintainer. A dedicated Compare section is NOT required (removed in v3); the competitive evaluation document MUST remain linked from the Docs table (or equivalent docs listing).

#### Scenario: Value bullets appear before install CTA

- **WHEN** a visitor reads the root README from the top
- **THEN** a "Why install" (or equivalent) value subsection with at least four bullets appears before the "Get started" install command block

#### Scenario: Toolkit phrase is explicit

- **WHEN** a visitor reads the opening of the root README
- **THEN** the README states that ByeByeVibe is an installable toolkit for AI-assisted development (Cursor and Claude Code)

#### Scenario: AI-assisted development wording present

- **WHEN** the root README opening is searched for discovery keywords
- **THEN** it contains the phrase "AI-assisted development" (case-insensitive)

#### Scenario: Compare section absent but evaluation doc still linked

- **WHEN** the root README is read after v3
- **THEN** no "Compare (summary)" section is present and the Docs table (or equivalent) still links `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (or its successor path)

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

### Requirement: First-contact quickstart in the canonical guide

`doc/sistema-sdd-pedro.md` MUST include a short first-contact / vibe-coder quickstart section that points to the root README and `sdd-kit/install.sh`, without replacing the full installation procedure. The section MUST be linked from the guide's "Como usar este documento" table or index.

#### Scenario: Vibe coder path exists in guide

- **WHEN** a newcomer opens `doc/sistema-sdd-pedro.md` looking for a minimal path
- **THEN** they find a short quickstart section that references the root README and an install dry-run command

### Requirement: Manual GitHub About and topics checklist

Discovery metadata that cannot be versioned in git (repository About description, GitHub topics, and repository rename) MUST be documented as an `[AÇÃO MANUAL NECESSÁRIA]` checklist in the evaluation document and/or root README. The checklist MUST include: (1) recommended About blurb naming **ByeByeVibe** and the vibe→agentic positioning; (2) topic list from the research (at least: `vibe-coding`, `spec-driven-development`, `context-engineering`, `claude-code`, `cursor`); (3) recommended repository slug rename from `gitnexus-graphify-openspec` to `byebyevibe` (or the slug recorded in the change design).

#### Scenario: Operator finds manual checklist

- **WHEN** an operator finishes applying this capability's documentation tasks
- **THEN** they can locate a checklist that lists the About text, topics, and repo rename action to perform in GitHub repository settings

#### Scenario: About names ByeByeVibe

- **WHEN** the operator reads the recommended About blurb in the checklist
- **THEN** the blurb includes the display name **ByeByeVibe** (not only the legacy working title "SDD Install Kit")

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

### Requirement: Root README names gap-aware detection with offer-only framing

The root README MUST mention the control plane's proactive gap-detection mechanisms — skill suggestion on repeated re-teaching of domain facts (`sdd-skill-guidance`) and tooling suggestion / static gap-check for CLI/MCP integrations (`sdd-tooling-guidance`, `scripts/verify-infra.sh`) — and MUST frame them as offer-only: no skill is created and no integration is installed without operator decision. The README MUST NOT present these mechanisms as machine learning, self-learning, or automatic adaptation (same register as the G4 no-ML-claims constraint).

#### Scenario: Gap-aware content present

- **WHEN** the root README is read
- **THEN** it references both the skill-suggestion mechanism and the tooling gap-check (e.g. `verify-infra.sh`), in a value bullet, the Calibrate section, or both

#### Scenario: Offer-only framing enforced

- **WHEN** the gap-aware content is read
- **THEN** it states that suggestions are offers (no auto-create / auto-install) and contains no ML or self-learning claims

