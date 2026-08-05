## ADDED Requirements

### Requirement: Root README stays congruent with the kit README

The root `README.md` MUST NOT contradict `sdd-kit/README.md` on profile or module facts. Specifically: profile listings MUST NOT present `HYBRID` as an active profile choice (it is a deprecated alias of `APP` since kit 1.9.0), and module descriptions MUST NOT scope a module to `HYBRID`. Where the root README lists documentation files with a language column, the language recorded for each file MUST match that file's actual language as governed by `sdd-docs-language`.

#### Scenario: Profiles listing omits the deprecated alias

- **WHEN** a visitor reads the Get started section (or any profile listing) of the root README
- **THEN** the profiles offered are `APP` and `DOCS_SPECS`, and `HYBRID` is not presented as a third choice

#### Scenario: Optional module scope agrees with the kit README

- **WHEN** a visitor reads the optional-modules section of the root README
- **THEN** no module is described as applying to `HYBRID`, matching the profile facts in `sdd-kit/README.md`

#### Scenario: Docs table language column is accurate

- **WHEN** a visitor reads the Docs listing in the root README and opens `sdd-kit/README.md`
- **THEN** the language recorded for that row is `EN`, matching the file's canonical language under `sdd-docs-language`

## MODIFIED Requirements

### Requirement: Root README exists with vibe-to-agentic positioning

The hub repository MUST include a root `README.md` written primarily in English for GitHub discovery. The README MUST use the public display name **ByeByeVibe** as the primary H1 (or equivalent top-level title). The README MUST communicate the positioning "from vibe coding to shippable AI engineering" (or the approved equivalent tagline), MUST state that the project is not an application/boilerplate starter and is the SDD control plane (OpenSpec + graphs + gates), MUST name the composed stack (OpenSpec, GitNexus, Graphify) with each name hyperlinked to its GitHub repository, MUST include a pointer from the intro area to the "Core tools" section (or its current heading) so a visitor can find what each named project does, MUST clarify that the install payload path remains `sdd-kit/`, and MUST provide a concrete install or dry-run CTA (e.g. `bash sdd-kit/install.sh --profile <PROFILE> --dry-run`).

The **first** mention of the payload path in the README MUST be a Markdown link to the `sdd-kit/` folder, so a first-contact visitor can reach the payload from the hero block without scrolling to a later section.

New-tab link behavior (`target="_blank"`) MUST NOT be required of any root README link: GitHub's markdown sanitizer strips the `target` attribute from rendered README HTML and Markdown offers no equivalent syntax, so the behavior is not achievable on the discovery surface.

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

#### Scenario: First payload mention is clickable

- **WHEN** a visitor reads the hero block sentence that names `sdd-kit/` as the install payload
- **THEN** `sdd-kit/` is a Markdown link to the folder, not a plain code span
