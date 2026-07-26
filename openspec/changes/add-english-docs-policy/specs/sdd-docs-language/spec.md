# sdd-docs-language Specification (delta)

## Purpose

Normative requirements for English as the canonical default language of versioned repository artifacts, controlled PT→EN substitution waves, glossary and inventory, verification gates, and the F7 distinction between chat language and repository language.

## ADDED Requirements

### Requirement: English is the canonical default for versioned artifacts

English MUST be the default and canonical language of all versioned repository artifacts after this capability is adopted. New OpenSpec proposals, designs, specs, tasks, skills, guide prose, evaluations, rules prose, and kit template markdown MUST be written in English. Portuguese (pt-BR) remaining in versioned files MUST be treated as legacy to be replaced, not as a permanent bilingual layer.

#### Scenario: Agent creates a new proposal after policy adoption

- **WHEN** an agent creates a new OpenSpec change artifact under `openspec/changes/<id>/`
- **THEN** the proposal, design, specs, and tasks are written in English

#### Scenario: Agent must not author new PT docs

- **WHEN** an agent would otherwise write or expand documentation, skills, or specs in Portuguese after policy adoption
- **THEN** the agent MUST write the artifact in English instead

### Requirement: Chat may remain Portuguese (F7)

Human↔agent conversation MAY use Portuguese (pt-BR) for operator speed. Chat language MUST NOT authorize creating or editing versioned repository artifacts in Portuguese after policy adoption. `AGENTS.md` (Comunicação) and `openspec/project.md` (Conventions) MUST state this distinction explicitly.

#### Scenario: Operator chats in Portuguese

- **WHEN** the operator converses with the agent in pt-BR
- **THEN** the agent may reply in pt-BR in chat while still writing commits and versioned artifacts in English

#### Scenario: Pointers document F7

- **WHEN** an agent reads `AGENTS.md` Comunicação or `openspec/project.md` Conventions after this capability is applied
- **THEN** it finds an explicit statement that chat MAY be pt-BR and versioned artifacts MUST be English

### Requirement: Waves replace Portuguese in-place — dual-file forbidden

Migration waves MUST replace Portuguese prose with canonical English **in the same file path**. Creating permanent dual-file pairs such as `*.en.md` alongside a Portuguese original, or `*-pt.md` mirrors, is FORBIDDEN as a migration strategy. Path renames of Portuguese-named files are out of scope for language waves and require a separate change if desired.

#### Scenario: Wave migrates a markdown file

- **WHEN** a translation wave applies to `doc/sistema-sdd-pedro.md` (or another in-scope path)
- **THEN** English content replaces Portuguese content at that same path and no sibling `*.en.md` dual-file is introduced

#### Scenario: Dual-file strategy rejected

- **WHEN** an agent proposes adding `README.en.md` while keeping a Portuguese `README.md` as the long-term model
- **THEN** the proposal is rejected as violating `sdd-docs-language`

### Requirement: Wave size limits

Each substitution wave (one OpenSpec change / one apply session / one PR) MUST respect all of the following budgets:

1. At most **350–400** lines of source content substituted in the wave
2. At most **4** files touched, OR one logical skill with both Cursor and Claude mirrors (2 files) counted as a single skill unit
3. At most **one** logical skill per wave when skills are in scope
4. Zero residual Portuguese prose in the files touched by that wave (slice Definition of Done)

If a surface exceeds the budget, it MUST be split across multiple waves.

#### Scenario: Oversized guide section is split

- **WHEN** a guide section exceeds ~400 lines of Portuguese prose to substitute
- **THEN** the work is proposed as two or more `translate-*-wave-N` changes rather than a single wave

#### Scenario: Skill mirrors stay paired

- **WHEN** a wave migrates an openspec skill under `.cursor/skills/<name>/`
- **THEN** the matching `.claude/skills/<name>/` mirror is updated in the same wave

### Requirement: In-scope and out-of-scope surfaces

Language-migration waves MUST treat the following surfaces as **in-scope** for PT→EN substitution until residual Portuguese prose is approximately zero: canonical guide, `AGENTS.md`, rules prose, skills, commands, kit templates/READMEs, `doc/avaliacoes/`, `doc/design/`, `doc/curso/` (by default, via its own waves), residual Portuguese in `openspec/specs/`, and active (non-archived) OpenSpec changes still in Portuguese.

Waves MUST NOT rewrite `openspec/changes/archive/` for language migration (out of scope). Proper names, URLs, quoted historical Portuguese, and freeze-list tokens MUST NOT be required to be “translated.”

#### Scenario: Course docs are in-scope by default

- **WHEN** an operator plans waves after policy archive
- **THEN** `doc/curso/` appears as in-scope in `doc/i18n/WAVES.md` unless a later human decision records an exception in an OpenSpec change

#### Scenario: Archive history is left untouched

- **WHEN** a wave agent considers editing files under `openspec/changes/archive/`
- **THEN** those files are excluded from language substitution

### Requirement: Freeze list of non-translatable tokens

Waves MUST NOT alter: repository paths and globs, OpenSpec change-ids, slash commands and skill directory names, shell/CI command fences, package version pins, code identifiers, MANIFEST keys, already-stable English heading anchors used by links, or brand/tool names (including ByeByeVibe, OpenSpec, GitNexus, Graphify).

#### Scenario: Shell fence preserved

- **WHEN** a wave rewrites surrounding prose in a markdown file that contains a fenced `bash` or `npx` command
- **THEN** the command text inside the fence remains byte-identical aside from intentional out-of-band fixes unrelated to translation

### Requirement: Glossary and wave inventory exist

The repository MUST include:

- `doc/i18n/GLOSSARY.md` — canonical English forms for SDD vocabulary (legacy pt-BR → EN), expandable per wave
- `doc/i18n/WAVES.md` — Portuguese inventory (order-of-magnitude), suggested wave order, in-scope/exception table, and how to invoke verification gates
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — template for future `translate-*-wave-N` substitution changes

Waves MUST use glossary canonical forms and MUST NOT invent synonym variants for the same concept across waves.

#### Scenario: Operator opens i18n docs

- **WHEN** an operator lists `doc/i18n/` after this capability is applied
- **THEN** `GLOSSARY.md`, `WAVES.md`, and `WAVE-PROPOSAL-TEMPLATE.md` exist and are non-empty

#### Scenario: New term introduced during a wave

- **WHEN** a wave needs an English term not yet in the glossary
- **THEN** the glossary is updated in the same wave before or with the substitution

### Requirement: Per-wave and global verification script

The repository MUST include executable `scripts/verify-i18n-wave.sh` that supports verifying a wave file list and a global Definition-of-Done scan. The script MUST implement gates:

| Gate | Purpose |
|------|---------|
| G-INV | Freeze-list / invariant check on touched files |
| G-GLOSS | Glossary canonical-form check |
| G-PT | Portuguese prose deny-list on wave files |
| G-LINK | Relative markdown links resolve for touched files |
| G-MIRROR | `.cursor` ↔ `.claude` skill/command pairs stay in sync when either side is touched |
| G-MANIFEST | Touched `sdd-kit/templates/` files have updated checksums / kit verify integrity |
| G-OPENSPEC | `openspec validate --all --strict` (with `OPENSPEC_TELEMETRY=0` and pinned CLI as used by the hub) |
| G-DoD | Global residual-Portuguese scan over in-scope surfaces (fail-closed) |

The script MUST depend only on local tooling (bash + repo CLIs already assumed by the hub). It MUST NOT require network access beyond what `npx` already uses for OpenSpec validation. It MUST NOT be introduced as a required blocking step of `sdd-gates` CI solely by this capability.

#### Scenario: Wave verification succeeds

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files path/a.md,path/b.md` on a fully substituted wave slice with glossary and mirrors correct
- **THEN** the script exits 0

#### Scenario: Residual Portuguese fails G-PT

- **WHEN** a listed wave file still contains deny-listed Portuguese prose tokens after purported migration
- **THEN** the script exits non-zero and reports G-PT failure

#### Scenario: Global DoD mode

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --dod` after all in-scope waves
- **THEN** the script scans in-scope surfaces from the wave inventory and fails if residual Portuguese prose remains

#### Scenario: Help flag

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --help`
- **THEN** the script exits 0 and prints usage including the gate names

### Requirement: Global Definition of Done is residual Portuguese approximately zero

The migration program’s Definition of Done MUST be: residual Portuguese prose approximately zero on all in-scope surfaces, verified by G-DoD. Policy adoption alone does not satisfy DoD; DoD is reached only after substitution waves plus a green G-DoD run. Features and other OpenSpec changes MUST NOT wait for global DoD — they MUST author new artifacts in English immediately after policy adoption while legacy Portuguese remains only until its wave.

#### Scenario: Policy change does not claim global DoD

- **WHEN** `add-english-docs-policy` is archived
- **THEN** documentation states that global DoD requires subsequent waves and `verify-i18n-wave.sh --dod`

#### Scenario: New feature change after policy

- **WHEN** a new feature change is proposed while legacy Portuguese still exists elsewhere
- **THEN** that feature’s new artifacts are still written in English
