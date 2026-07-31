# sdd-docs-language Specification

## Purpose

Normative requirements for English as the canonical default language of versioned repository artifacts, controlled PT→EN substitution waves, glossary and inventory, verification gates, and the F7 distinction between chat language and repository language.
## Requirements
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

### Requirement: Kit README and AGENTS install templates (W2 slice) are English

The files `sdd-kit/README.md`, `sdd-kit/templates/AGENTS.core.md`, `sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md`, and `sdd-kit/templates/AGENTS.commands.APP.md` MUST be written in English as the canonical language of those surfaces. Residual Portuguese prose in these files is FORBIDDEN after the W2 substitution wave. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, brand/tool names, profile codes `APP`/`DOCS_SPECS`/`HYBRID`, scenario codes `C1`/`C2`/`C2b`/`C3`/`C1-UI`/`G2`/`G4`, package pins, shell/CI command fences, and HTML markers `<!-- SDD_KIT_COMMANDS_START -->` / `<!-- SDD_KIT_COMMANDS_END -->`) MUST remain unaltered aside from intentional non-i18n fixes. When any of the three template paths under `sdd-kit/templates/` change, MANIFEST checksums MUST be regenerated so `bash sdd-kit/verify.sh` passes (G-MANIFEST).

#### Scenario: W2 file list passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/README.md,sdd-kit/templates/AGENTS.core.md,sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md,sdd-kit/templates/AGENTS.commands.APP.md` after the W2 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on that file list)

#### Scenario: No dual-file migration for W2 kit AGENTS/README

- **WHEN** W2 apply completes
- **THEN** English content is at the four paths listed above and no permanent `*.en.md` / `*-pt.md` sibling for those paths exists

#### Scenario: AGENTS command-injection markers preserved

- **WHEN** an agent reads `sdd-kit/templates/AGENTS.core.md` after W2
- **THEN** both `<!-- SDD_KIT_COMMANDS_START -->` and `<!-- SDD_KIT_COMMANDS_END -->` remain present and byte-identical so `install.sh` profile injection continues to work

### Requirement: Kit CLAUDE and openspec/infra install templates (W2b slice) are English

The files `sdd-kit/templates/CLAUDE.md` and `sdd-kit/templates/openspec/infra.md` MUST be written in English as the canonical language of those surfaces. Residual Portuguese prose in these files is FORBIDDEN after the W2b substitution wave. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, brand/tool names, package pins, shell/CI command fences, and HTML markers used by `scripts/verify-infra.sh` such as `<!-- openspec-version -->` / `<!-- /openspec-version -->`, `<!-- mcp-list -->` / `<!-- /mcp-list -->`, `<!-- env-list -->` / `<!-- /env-list -->`, and kit version/status markers) MUST remain unaltered aside from intentional non-i18n fixes to marker **bodies** that remove Portuguese filler. When either template path under `sdd-kit/templates/` changes, MANIFEST checksums MUST be regenerated so `bash sdd-kit/verify.sh` passes (G-MANIFEST).

#### Scenario: W2b file list passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/CLAUDE.md,sdd-kit/templates/openspec/infra.md` after the W2b substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on that file list)

#### Scenario: No dual-file migration for W2b kit CLAUDE/infra

- **WHEN** W2b apply completes
- **THEN** English content is at the two paths listed above and no permanent `*.en.md` / `*-pt.md` sibling for those paths exists

#### Scenario: verify-infra HTML markers preserved

- **WHEN** an agent reads `sdd-kit/templates/openspec/infra.md` after W2b
- **THEN** the HTML comment marker tags used by `scripts/verify-infra.sh` (including openspec-version, mcp-list, env-list, and kit-version/status pairs) remain present so infra verification injection continues to work

### Requirement: Kit Cursor rules install templates (W2c slice) are English

The files `sdd-kit/templates/.cursor/rules/000-base.mdc`, `sdd-kit/templates/.cursor/rules/015-session-phases.mdc`, `sdd-kit/templates/.cursor/rules/016-session-coordination.mdc`, and `sdd-kit/templates/.cursor/rules/010-typescript.mdc` MUST be written in English as the canonical language of those surfaces. Residual Portuguese prose in these files is FORBIDDEN after the W2c substitution wave. Dual-file siblings such as `*.en.mdc` or `*-pt.mdc` MUST NOT be introduced for these paths. Freeze-list tokens (paths, brand/tool names, YAML keys `alwaysApply`/`globs` and glob pattern strings, slash commands such as `/opsx:propose`, shell/script paths, and code identifiers such as `cn` and `Zod`) MUST remain unaltered aside from intentional non-i18n fixes. Human-readable YAML `description` values MUST be English. When any of these template paths under `sdd-kit/templates/` change, MANIFEST checksums MUST be regenerated so `bash sdd-kit/verify.sh` passes (G-MANIFEST).

#### Scenario: W2c file list passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/.cursor/rules/000-base.mdc,sdd-kit/templates/.cursor/rules/015-session-phases.mdc,sdd-kit/templates/.cursor/rules/016-session-coordination.mdc,sdd-kit/templates/.cursor/rules/010-typescript.mdc` after the W2c substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on that file list)

#### Scenario: No dual-file migration for W2c kit Cursor rules

- **WHEN** W2c apply completes
- **THEN** English content is at the four paths listed above and no permanent `*.en.mdc` / `*-pt.mdc` sibling for those paths exists

#### Scenario: YAML globs and alwaysApply preserved

- **WHEN** an agent reads the four W2c kit rule templates after substitution
- **THEN** each file retains its YAML frontmatter keys `alwaysApply` and (where present) `globs` with glob pattern strings unchanged so Cursor rule activation behavior is preserved

### Requirement: Kit-scripts wave-1 sdd-upgrade-diff residual-PT scripts are English

The upgrade-diff script paths `scripts/sdd-upgrade-diff.sh` and `sdd-kit/templates/scripts/sdd-upgrade-diff.sh` MUST be written in English after the kit-scripts substitution wave. Residual Portuguese prose in these files is FORBIDDEN after apply, including file-header comments and operator-facing `echo` / stderr messages that previously used Portuguese vocabulary matching the wave deny-list. Dual-file siblings such as `*.en.sh`, `*-pt.sh`, `*.en.md`, or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths including `scripts/sdd-upgrade-diff.sh`, `sdd-kit/templates/scripts/sdd-upgrade-diff.sh`, `sdd-kit/MANIFEST.yaml`, `openspec/project.md`, and `doc/sistema-sdd-pedro.md`; shell identifiers such as `CURATED_FILES`, `CURATED_DESTS`, `CURATED_SOURCES`, `STAGING_DIR`, and `GUIDE_VERSION`; merge strategy label `MERGE`; profile names APP / DOCS_SPECS / HYBRID; slash commands such as `/opsx:*`; fenced shell commands; and brand/tool names including ByeByeVibe) MUST remain unaltered aside from intentional non-i18n fixes. Per-file control flow and the existing hub↔template logic divergence (hub path-only inventory vs template MANIFEST `source:`-aware inventory) MUST keep the same meaning after prose is normalized to glossary-canonical English. When the kit template file is edited, `sdd-kit/MANIFEST.yaml` checksums for that template MUST be regenerated via `bash sdd-kit/gen-manifest-checksums.sh` so kit integrity remains honest.

#### Scenario: Kit-scripts wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files scripts/sdd-upgrade-diff.sh,sdd-kit/templates/scripts/sdd-upgrade-diff.sh` after the kit-scripts substitution is applied (including MANIFEST checksum regeneration)
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on those paths)

#### Scenario: No dual-file migration for kit-scripts wave-1

- **WHEN** the kit-scripts substitution wave apply completes
- **THEN** English content is at `scripts/sdd-upgrade-diff.sh` and `sdd-kit/templates/scripts/sdd-upgrade-diff.sh` and no permanent language-suffixed sibling exists for those paths

#### Scenario: Upgrade-diff contracts remain stable

- **WHEN** an operator runs the hub or template upgrade-diff script after substitution
- **THEN** inventory-without-staging, MANIFEST-present vs built-in fallback listing, staged template comparison behavior, and the hub↔template parser divergence remain equivalent to the pre-wave Portuguese-message scripts while comments and operator-facing messages are English

### Requirement: Active-changes wave-1 correctness-review artifacts are English

The following active-change artifact paths under `openspec/changes/add-correctness-review-skill/` MUST be written in English after the active-changes substitution wave: `proposal.md`, `design.md`, and `tasks.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, skill names including `correctness-review` and `simplify-review`, package pins, URLs, fenced shell commands, A–E matrix labels, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Historical apply outcomes (skill registration points, A–E invocation matrix, pilot-exception rationale, rollback plan, and task completion markers) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Active-changes wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-correctness-review-skill/proposal.md,openspec/changes/add-correctness-review-skill/design.md,openspec/changes/add-correctness-review-skill/tasks.md` after the active-changes substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for active-changes wave-1

- **WHEN** the active-changes substitution wave apply completes
- **THEN** English content is at the three listed `add-correctness-review-skill` artifact paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: Correctness-review historical outcomes remain stable

- **WHEN** an agent reads the translated proposal, design, and tasks for `add-correctness-review-skill`
- **THEN** the A–E invocation matrix, pilot-exception approval, rollback steps, skill mirror paths, and historical `[x]` completion markers remain equivalent to the pre-wave Portuguese artifacts while surrounding prose and headings are English

### Requirement: Discovery wave-1 active-change artifacts are English

The following active-change artifact paths under `openspec/changes/add-sdd-discovery-positioning/` MUST be written in English after the discovery substitution wave: `proposal.md`, `design.md`, and `tasks.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, research section anchors such as `§11` / `§12`, decision ids D1–D11 and backlog ids P0–P10, URLs, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Historical apply outcomes (EN root README with vibe→agentic positioning, evaluation promotion path, kit README discovery framing, guide first-contact quickstart, D9 permanent non-goals, D10 README→name→EN→GIF roadmap, D11 metrics blurb without ML claims, manual About/topics checklist, and task completion markers) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Discovery wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/proposal.md,openspec/changes/add-sdd-discovery-positioning/design.md,openspec/changes/add-sdd-discovery-positioning/tasks.md` after the discovery substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for discovery wave-1

- **WHEN** the discovery substitution wave apply completes
- **THEN** English content is at the three listed `add-sdd-discovery-positioning` artifact paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: Discovery historical outcomes remain stable

- **WHEN** an agent reads the translated proposal, design, and tasks for `add-sdd-discovery-positioning`
- **THEN** the D9 permanent non-goals, D10 roadmap sequence, D11 metrics framing without ML claims, evaluation promotion intent, root README / kit README / guide quickstart intents, manual About/topics checklist meaning, and historical `[x]` completion markers remain equivalent to the pre-wave Portuguese artifacts while surrounding prose and headings are English

### Requirement: Design wave-1 module-install surfaces are English

The following design documentation paths MUST be written in English after the design substitution wave: `doc/design/002-ui-module-install.md`, `doc/design/003-ui-stack-adapters.md`, and `doc/design/004-probity-module-install.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, script names including `install-ui-module.sh` and `install-probity-module.sh`, package pins, URLs, fenced shell commands, scenario labels `C1-UI` and `G2`, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Install / detect / apply procedure semantics (including “what `--apply` does not do” lists and adapter opt-out steps) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Design wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files doc/design/002-ui-module-install.md,doc/design/003-ui-stack-adapters.md,doc/design/004-probity-module-install.md` after the design substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for design wave-1

- **WHEN** the design substitution wave apply completes
- **THEN** English content is at the three listed `doc/design/` paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: Install procedure semantics remain stable

- **WHEN** an agent reads the C1-UI, UI stack adapters, and Probity G2 install docs after substitution
- **THEN** detect→apply command sequences, scenario applicability, and “does not” / opt-out constraints remain equivalent to the pre-wave Portuguese docs while surrounding prose and headings are English

### Requirement: Explore-oss research wave-1 surface is English

The path `openspec/changes/explore-oss-coverage-gaps/research.md` MUST be written in English after the explore-oss substitution wave. Residual Portuguese prose in this file is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, package pins, URLs, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Gap recommendation outcomes (add to kit / manual fix / do not add / hybrid / do not adopt now for G1–G8) MUST keep the same meaning after label language is normalized to glossary-canonical English.

#### Scenario: Explore-oss research passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/research.md` after the explore-oss substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for explore-oss research

- **WHEN** the explore-oss substitution wave apply completes
- **THEN** English content is at `openspec/changes/explore-oss-coverage-gaps/research.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Gap recommendation outcomes remain stable

- **WHEN** an agent reads the explore-oss decision matrix after substitution
- **THEN** G2 Probity remains an add-to-kit recommendation (linked to `add-probity-tdd-module`), G3 error-tracking remains do-not-add to kit core, and G6 multi-agent orchestration remains do-not-adopt-now, while prose and labels are English

### Requirement: Discovery research wave-1 slice is English

The path `openspec/changes/add-sdd-discovery-positioning/research.md` lines **1–261** (§1–§10) MUST be written in English after the discovery-research substitution wave. Residual Portuguese prose in this line range is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, package pins, URLs, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. §9 pre-apply decision defaults (including P6–P8 / BMAD / Landing / Discord non-goals and deferral of full EN translation until stable name) MUST keep the same meaning after label language is normalized to glossary-canonical English.

#### Scenario: Discovery research slice passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md` after the discovery-research wave-1 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for discovery research

- **WHEN** the discovery-research wave-1 apply completes
- **THEN** English content for §1–§10 is at `openspec/changes/add-sdd-discovery-positioning/research.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Pre-apply decision defaults remain stable

- **WHEN** an agent reads §9 after substitution
- **THEN** P6–P8 / BMAD / Landing / Discord remain non-goals, full EN translation remains deferred until stable name (with §11 step ④ still referenced structurally), and prose/labels in lines 1–261 are English

### Requirement: Explore-oss research wave-1 surface is English

The path `openspec/changes/explore-oss-coverage-gaps/research.md` MUST be written in English after the explore-oss substitution wave. Residual Portuguese prose in this file is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, package pins, URLs, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Gap recommendation outcomes (add to kit / manual fix / do not add / hybrid / do not adopt now for G1–G8) MUST keep the same meaning after label language is normalized to glossary-canonical English.

#### Scenario: Explore-oss research passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/research.md` after the explore-oss substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for explore-oss research

- **WHEN** the explore-oss substitution wave apply completes
- **THEN** English content is at `openspec/changes/explore-oss-coverage-gaps/research.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Gap recommendation outcomes remain stable

- **WHEN** an agent reads the explore-oss decision matrix after substitution
- **THEN** G2 Probity remains an add-to-kit recommendation (linked to `add-probity-tdd-module`), G3 error-tracking remains do-not-add to kit core, and G6 multi-agent orchestration remains do-not-adopt-now, while prose and labels are English

### Requirement: Explore-oss methodology wave-2 surface is English

The path `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` MUST be written in English after the explore-oss methodology substitution wave. Residual Portuguese prose in this file is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, package pins, URLs, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Methodology phase structure (Phases 0–5), verification ids (V1–V5, F1–F5), 6-point registry destinations (R1–R6), activation modes (A–D), and A–E task-matrix on/off outcomes MUST keep the same meaning after label language is normalized to glossary-canonical English.

#### Scenario: Explore-oss methodology passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` after the explore-oss methodology substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for explore-oss methodology

- **WHEN** the explore-oss methodology substitution wave apply completes
- **THEN** English content is at `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Methodology structure and registry remain stable

- **WHEN** an agent reads the insertion methodology after substitution
- **THEN** Phases 0–5 remain present in order, the 6-point registry still points R1→`openspec/infra.md` through R6→`sdd-kit/`, Probity (G2) remains the only in-band automatic activation mode, and the pilot-skippable exception for no-new-binary/hook insertions remains documented, while prose and labels are English

### Requirement: Agent entry-point documents are English

`AGENTS.md`, `CLAUDE.md`, and `openspec/project.md` MUST be written in English as the canonical language of those surfaces. Residual Portuguese prose in these files is FORBIDDEN after the W1 substitution wave. Dual-file siblings such as `AGENTS.en.md` or `*-pt.md` MUST NOT be introduced for these paths. The F7 distinction (human↔agent chat MAY use pt-BR; versioned artifacts MUST be English) MUST remain stated explicitly in `AGENTS.md` (Communication section) and `openspec/project.md` (Conventions).

#### Scenario: W1 file list passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files AGENTS.md,openspec/project.md,CLAUDE.md` after the W1 substitution is applied
- **THEN** the script exits 0 (including G-PT on those three files)

#### Scenario: F7 remains explicit after substitution

- **WHEN** an agent reads `AGENTS.md` Communication and `openspec/project.md` Conventions after W1
- **THEN** both files state that chat MAY be pt-BR and versioned artifacts MUST be English

#### Scenario: No dual-file migration for entry points

- **WHEN** W1 apply completes
- **THEN** English content is at `AGENTS.md`, `CLAUDE.md`, and `openspec/project.md` and no permanent `*.en.md` / `*-pt.md` sibling for those paths exists

### Requirement: opsx-archive command mirrors are English

The logical command `opsx-archive` MUST be written in English at both mirror paths `.cursor/commands/opsx-archive.md` and `.claude/commands/opsx/archive.md`. Residual Portuguese prose in either path is FORBIDDEN after the commands substitution wave. Dual-file siblings such as `opsx-archive.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:archive`, `/opsx:explore`, `/opsx:propose`, and `/opsx:apply`, fenced shell commands, archive workflow semantics including sync assessment and `.openspec.yaml` preservation, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Platform-specific YAML frontmatter structure MAY differ between Cursor and Claude (keys such as `name`, `id`, `tags`); human-readable `description` values MUST be English. Chat-language and Session Handoff guidance in the command MUST align with F7 (chat MAY be Portuguese; the versioned command artifact MUST be English) and MUST NOT hard-require Portuguese-only responses.

#### Scenario: opsx-archive mirrors pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-archive.md,.claude/commands/opsx/archive.md` after the commands substitution is applied on a base that includes the asymmetric opsx G-MIRROR peer map
- **THEN** the script exits 0 (including G-PT on those files and G-MIRROR peer listing for the asymmetric opsx command paths)

#### Scenario: No dual-file migration for opsx-archive

- **WHEN** the commands substitution wave apply completes
- **THEN** English content is at both `.cursor/commands/opsx-archive.md` and `.claude/commands/opsx/archive.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for either path

#### Scenario: Platform frontmatter may differ

- **WHEN** an agent compares Cursor and Claude `opsx-archive` command files after substitution
- **THEN** YAML frontmatter MAY differ by IDE while both prose bodies are English and free of residual Portuguese deny-list hits

### Requirement: opsx-propose command mirrors are English

The logical command `opsx-propose` MUST be written in English at both mirror paths `.cursor/commands/opsx-propose.md` and `.claude/commands/opsx/propose.md`. Residual Portuguese prose in either path is FORBIDDEN after the commands substitution wave. Dual-file siblings such as `opsx-propose.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:propose`, `/opsx:apply`, `/opsx:explore`, and `/opsx:archive`, fenced shell commands, propose workflow semantics including the create-change → status → instructions loop, enriched-tasks §12.10 Gate/Pattern rules, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Platform-specific YAML frontmatter structure MAY differ between Cursor and Claude (keys such as `name`, `id`, `tags`); human-readable `description` values MUST be English. Chat-language and Session Handoff guidance in the command MUST align with F7 (chat MAY be Portuguese; the versioned command artifact MUST be English) and MUST NOT hard-require Portuguese-only responses. This requirement covers the **command** mirrors only and MUST NOT be read as superseding or replacing the separate `openspec-propose` **skill** mirror requirement.

#### Scenario: opsx-propose mirrors pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-propose.md,.claude/commands/opsx/propose.md` after the commands substitution is applied on a base that includes the asymmetric opsx G-MIRROR peer map
- **THEN** the script exits 0 (including G-PT on those files and G-MIRROR peer listing for the asymmetric opsx command paths)

#### Scenario: No dual-file migration for opsx-propose

- **WHEN** the commands substitution wave apply completes
- **THEN** English content is at both `.cursor/commands/opsx-propose.md` and `.claude/commands/opsx/propose.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for either path

#### Scenario: Platform frontmatter may differ

- **WHEN** an agent compares Cursor and Claude `opsx-propose` command files after substitution
- **THEN** YAML frontmatter MAY differ by IDE while both prose bodies are English and free of residual Portuguese deny-list hits

### Requirement: opsx-explore command mirrors are English

The logical command `opsx-explore` MUST be written in English at both mirror paths `.cursor/commands/opsx-explore.md` and `.claude/commands/opsx/explore.md`. Residual Portuguese prose in either path is FORBIDDEN after the commands substitution wave. Dual-file siblings such as `opsx-explore.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:explore`, `/opsx:propose`, `/opsx:apply`, and `/opsx:archive`, fenced shell commands, explore workflow semantics including research.md conventions and Session Handoff to `/opsx:propose`, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Platform-specific YAML frontmatter structure MAY differ between Cursor and Claude (keys such as `name`, `id`, `tags`); human-readable `description` values MUST be English. Chat-language and Session Handoff guidance in the command MUST align with F7 (chat MAY be Portuguese; the versioned command artifact MUST be English) and MUST NOT hard-require Portuguese-only responses. This requirement covers the **command** mirrors only and MUST NOT be read as superseding or replacing the separate `openspec-explore` **skill** mirror requirement.

#### Scenario: opsx-explore mirrors pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-explore.md,.claude/commands/opsx/explore.md` after the commands substitution is applied on a base that includes the asymmetric opsx G-MIRROR peer map
- **THEN** the script exits 0 (including G-PT on those files and G-MIRROR peer listing for the asymmetric opsx command paths)

#### Scenario: No dual-file migration for opsx-explore

- **WHEN** the commands substitution wave apply completes
- **THEN** English content is at both `.cursor/commands/opsx-explore.md` and `.claude/commands/opsx/explore.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for either path

#### Scenario: Platform frontmatter may differ

- **WHEN** an agent compares Cursor and Claude `opsx-explore` command files after substitution
- **THEN** YAML frontmatter MAY differ by IDE while both prose bodies are English and free of residual Portuguese deny-list hits

### Requirement: translate-design-wave-3 target surface is English

The following path MUST be written in English after substitution: `doc/design/001-pipeline-open-design-shadcn-impeccable.md`. Residual Portuguese prose in the substituted slice (lines 1–325) is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced. Freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, URLs, fenced shell, profile labels, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes.

#### Scenario: Per-wave verification passes

- **WHEN** an operator runs the wave gate command after apply
- **THEN** the script exits 0 (including G-PT and G-LINK on `doc/design/001-pipeline-open-design-shadcn-impeccable.md`)

#### Scenario: No dual-file migration

- **WHEN** the wave apply completes
- **THEN** English content remains at `doc/design/001-pipeline-open-design-shadcn-impeccable.md` with no permanent `*.en.md` / `*-pt.md` sibling

### Requirement: translate-design-wave-4 target surface is English

The following path MUST be written in English after substitution: `doc/design/001-pipeline-open-design-shadcn-impeccable.md`. Residual Portuguese prose in the substituted slice (lines 326–592) is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced. Freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, URLs, fenced shell, profile labels, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes.

#### Scenario: Per-wave verification passes

- **WHEN** an operator runs the wave gate command after apply
- **THEN** the script exits 0 (including G-PT and G-LINK on `doc/design/001-pipeline-open-design-shadcn-impeccable.md`)

#### Scenario: No dual-file migration

- **WHEN** the wave apply completes
- **THEN** English content remains at `doc/design/001-pipeline-open-design-shadcn-impeccable.md` with no permanent `*.en.md` / `*-pt.md` sibling

### Requirement: translate-guide-wave-2 target surface is English

The following path MUST be written in English after substitution: `doc/sistema-sdd-pedro.md`. Residual Portuguese prose in the substituted slice (lines 133–297) is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced. Freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, URLs, fenced shell, profile labels, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes.

#### Scenario: Per-wave verification passes

- **WHEN** an operator runs the wave gate command after apply
- **THEN** the script exits 0 (including G-PT and G-LINK on `doc/sistema-sdd-pedro.md`)

#### Scenario: No dual-file migration

- **WHEN** the wave apply completes
- **THEN** English content remains at `doc/sistema-sdd-pedro.md` with no permanent `*.en.md` / `*-pt.md` sibling

### Requirement: translate-guide-wave-3 target surface is English

The following path MUST be written in English after substitution: `doc/sistema-sdd-pedro.md`. Residual Portuguese prose in the substituted slice (lines 298–424) is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced. Freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, URLs, fenced shell, profile labels, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes.

#### Scenario: Per-wave verification passes

- **WHEN** an operator runs the wave gate command after apply
- **THEN** the script exits 0 (including G-PT and G-LINK on `doc/sistema-sdd-pedro.md`)

#### Scenario: No dual-file migration

- **WHEN** the wave apply completes
- **THEN** English content remains at `doc/sistema-sdd-pedro.md` with no permanent `*.en.md` / `*-pt.md` sibling

### Requirement: Evaluation wave-2 surfaces are English

The following evaluation documentation paths MUST be written in English after the evaluations substitution wave: `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` and `doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`. Residual Portuguese prose in either of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths including the `doc/avaliacoes/` directory segment until a dedicated rename wave, change-ids, slash commands such as `/opsx:*`, package pins, URLs, fenced shell commands, and brand/tool names including ByeByeVibe) MUST remain unaltered aside from intentional non-i18n fixes. Historical decision outcomes (Adopted / Discarded / Deferred / Under evaluation / Do not implement) MUST keep the same meaning after label language is normalized to glossary-canonical English.

#### Scenario: Evaluation wave-2 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md,doc/avaliacoes/2026-06-27-sdd-ui-development-module.md` after the evaluations substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for evaluation wave-2

- **WHEN** the evaluations wave-2 substitution apply completes
- **THEN** English content is at the two listed `doc/avaliacoes/` paths and no permanent `*.en.md` / `*-pt.md` sibling exists for either of them

#### Scenario: Decision outcomes remain stable

- **WHEN** an agent reads the discovery-positioning and UI-module evaluation records after substitution
- **THEN** ByeByeVibe / P1–P4 Adopted surfaces remain Adopted, deferred and do-not-implement rows keep their pre-wave outcome meaning, and the UI-module record remains Adopted (add-on with Impeccable confirmation semantics) while prose and status labels are English

### Requirement: Kit-scripts wave-2 verify-infra residual-PT scripts are English

The verify-infra script paths `scripts/verify-infra.sh` and `sdd-kit/templates/scripts/verify-infra.sh` MUST be written in English after the kit-scripts substitution wave. Residual Portuguese prose in these files is FORBIDDEN after apply, including operator-facing `echo` / stderr messages and the match-and-rewrite chrome strings previously used against `openspec/infra.md` (timestamp line, env-table headers, and the Agent rule section anchor) that matched the wave deny-list or Portuguese manifesto labels. Dual-file siblings such as `*.en.sh`, `*-pt.sh`, `*.en.md`, or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths including `scripts/verify-infra.sh`, `sdd-kit/templates/scripts/verify-infra.sh`, `openspec/infra.md`, and `sdd-kit/MANIFEST.yaml`; HTML comment marker names such as `openspec-version`, `mcp-list`, and `kit-version`; status glyphs ✅/❌; `[NEEDS VERIFICATION]`; env var **names**; slash commands such as `/opsx:*`; fenced shell commands; and brand/tool names including ByeByeVibe, OpenSpec, GitNexus, and Graphify) MUST remain unaltered aside from intentional non-i18n fixes. Script control flow and hub↔template content equivalence MUST keep the same meaning after prose is normalized to glossary-canonical English. Chrome vocabulary MUST align to the kit English manifesto forms already present in `sdd-kit/templates/openspec/infra.md` (`Last verified`, `Variable | Present | Verify with`, `## Agent rule`). When the kit template file is edited, `sdd-kit/MANIFEST.yaml` checksums for that template MUST be regenerated via `bash sdd-kit/gen-manifest-checksums.sh` so kit integrity remains honest.

#### Scenario: Kit-scripts wave-2 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files scripts/verify-infra.sh,sdd-kit/templates/scripts/verify-infra.sh` after the kit-scripts substitution is applied (including MANIFEST checksum regeneration)
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on those paths)

#### Scenario: No dual-file migration for kit-scripts wave-2

- **WHEN** the kit-scripts substitution wave apply completes
- **THEN** English content is at `scripts/verify-infra.sh` and `sdd-kit/templates/scripts/verify-infra.sh` and no permanent language-suffixed sibling exists for those paths

#### Scenario: Verify-infra contracts remain stable

- **WHEN** an operator runs `bash scripts/verify-infra.sh` after substitution against an English `openspec/infra.md` whose chrome matches the kit manifesto labels
- **THEN** core SDD checks, HTML marker status updates, timestamp refresh on the `Last verified` line, and env-table rewrite against `## Agent rule` remain equivalent to the pre-wave Portuguese-chrome scripts while comments and operator-facing messages are English

### Requirement: Kit-scripts wave-3 bootstrap residual-PT scripts are English

The bootstrap script paths `scripts/bootstrap-sdd.sh` and `sdd-kit/templates/scripts/bootstrap-sdd.sh` MUST be written in English after the kit-scripts substitution wave. Residual Portuguese prose in these files is FORBIDDEN after apply, including comments and operator-facing `echo` / stderr messages (shared GitNexus optional-continue banner, failure warnings, and — on the template only — HYBRID coexistence warning lines) that matched the wave deny-list or remaining Portuguese operator chrome. Dual-file siblings such as `*.en.sh`, `*-pt.sh`, `*.en.md`, or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths including `scripts/bootstrap-sdd.sh`, `sdd-kit/templates/scripts/bootstrap-sdd.sh`, `sdd-kit/install.sh`, `sdd-kit/MANIFEST.yaml`, and `openspec/project.md`; profile enum names `APP`, `DOCS_SPECS`, and `HYBRID`; slash commands such as `/opsx:*`; fenced shell commands; and brand/tool names including ByeByeVibe, OpenSpec, GitNexus, and Graphify) MUST remain unaltered aside from intentional non-i18n fixes. Script control flow and the intentional hub↔template profile-detection divergence MUST keep the same meaning after prose is normalized to glossary-canonical English. When the kit template file is edited, `sdd-kit/MANIFEST.yaml` checksums for that template MUST be regenerated via `bash sdd-kit/gen-manifest-checksums.sh` so kit integrity remains honest. Operator-facing bootstrap stderr remains the runtime source-of-truth for those messages (including the template HYBRID warning); other artifacts MUST NOT re-embed legacy Portuguese tokens from these scripts as normative quoted contracts in this wave.

#### Scenario: Kit-scripts wave-3 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files scripts/bootstrap-sdd.sh,sdd-kit/templates/scripts/bootstrap-sdd.sh` after the kit-scripts substitution is applied (including MANIFEST checksum regeneration)
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on those paths)

#### Scenario: No dual-file migration for kit-scripts wave-3

- **WHEN** the kit-scripts substitution wave apply completes
- **THEN** English content is at `scripts/bootstrap-sdd.sh` and `sdd-kit/templates/scripts/bootstrap-sdd.sh` and no permanent language-suffixed sibling exists for those paths

#### Scenario: Bootstrap contracts remain stable

- **WHEN** an operator runs `bash scripts/bootstrap-sdd.sh` (hub) or the kit template copy after substitution
- **THEN** OpenSpec init, optional GitNexus continue-on-failure, Graphify setup, and `sdd-kit/install.sh --profile …` invocation remain equivalent to the pre-wave scripts while comments and operator-facing messages are English, and the template-only HYBRID coexistence warning behavior is preserved (not removed and not ported into the hub by this wave)

### Requirement: Kit-scripts wave-4 upgrade.sh residual-PT script is English

The kit upgrade script path `sdd-kit/upgrade.sh` MUST be written in English after the kit-scripts substitution wave. Residual Portuguese prose in this file is FORBIDDEN after apply, including comments, dry-run `UPGRADE_REPORT.md` scaffold headings and labels, operator-facing `echo` / stderr messages, and the approval checkbox text plus the matching `grep` needle used by `--apply`. Dual-file siblings such as `*.en.sh`, `*-pt.sh`, `*.en.md`, or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/upgrade.sh`, `sdd-kit/MANIFEST.yaml`, and `UPGRADE_REPORT.md`; flags `--from`, `--to`, `--profile`, `--dry-run`, `--apply`, `--force`, and `--repo`; merge classification labels `KEEP_LOCAL`, `MERGE`, `COPY`, `NEW`, and `SKIP`; profile enum names `APP`, `DOCS_SPECS`, and `HYBRID`; slash commands such as `/opsx:*`; fenced shell commands; and brand/tool names including ByeByeVibe and OpenSpec) MUST remain unaltered aside from intentional non-i18n fixes. Upgrade control flow (dry-run report scaffolding, approval gate before COPY apply, main/master branch safety, and template integrity checks) MUST keep the same meaning after prose is normalized to glossary-canonical English. The approval checkbox string written into new `UPGRADE_REPORT.md` scaffolds and the string grepped by `--apply` MUST remain identical to each other after substitution; `sdd-kit/upgrade.sh` remains the runtime source-of-truth for that needle. Other artifacts MUST NOT be edited in this wave solely to re-quote a legacy Portuguese checkbox token.

#### Scenario: Kit-scripts wave-4 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/upgrade.sh` after the kit-scripts substitution is applied
- **THEN** the script exits 0 (including G-PT on that path)

#### Scenario: No dual-file migration for kit-scripts wave-4

- **WHEN** the kit-scripts substitution wave apply completes
- **THEN** English content is at `sdd-kit/upgrade.sh` and no permanent language-suffixed sibling exists for that path

#### Scenario: Upgrade approval gate remains coherent

- **WHEN** an operator runs `bash sdd-kit/upgrade.sh --from … --to … --dry-run` and later `--apply` with a matching checked approval checkbox in `UPGRADE_REPORT.md` after substitution
- **THEN** the dry-run scaffold and the `--apply` grep needle use the same English approval string, `--apply` still refuses an unchecked or missing report, and COPY/MERGE/profile/`--force`/integrity behavior remains equivalent to the pre-wave script while comments and operator-facing messages are English

### Requirement: Kit-scripts wave-5 install-ui-module.sh residual-PT script is English

The kit UI-module installer path `sdd-kit/install-ui-module.sh` MUST be written in English after the kit-scripts substitution wave. Residual Portuguese prose in this file is FORBIDDEN after apply, including comments, operator-facing `echo` / stderr messages, and the embedded `openspec/infra.md` UI Development Module table chrome (headers and cell wording) written by the script. Dual-file siblings such as `*.en.sh`, `*-pt.sh`, `*.en.md`, or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/install-ui-module.sh`, `doc/design/002-ui-module-install.md`, `openspec/infra.md`, and `openspec/project.md`; flags `--detect`, `--dry-run`, `--apply`, `--yes`, and `--repo`; brand/tool names including Impeccable, Open Design, Pencil, Figma MCP, and shadcn; slash commands such as `/opsx:*`; and fenced shell commands) MUST remain unaltered aside from intentional non-i18n fixes. Install-ui-module control flow (detect inventory, dry-run planning, design-doc install, infra section update, and optional Impeccable install) MUST keep the same meaning after prose is normalized to glossary-canonical English. The template twin `sdd-kit/templates/install-ui-module.sh` is out of scope for this wave’s file list and MUST NOT be required to change in the same apply.

#### Scenario: Kit-scripts wave-5 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/install-ui-module.sh` after the kit-scripts substitution is applied
- **THEN** the script exits 0 (including G-PT on that path)

#### Scenario: No dual-file migration for kit-scripts wave-5

- **WHEN** the kit-scripts substitution wave apply completes
- **THEN** English content is at `sdd-kit/install-ui-module.sh` and no permanent language-suffixed sibling exists for that path

#### Scenario: Embedded infra UI-module chrome stays English-aligned

- **WHEN** an operator runs `bash sdd-kit/install-ui-module.sh --apply` (or `--dry-run` planning that would write the same section) after substitution
- **THEN** the embedded UI Development Module table uses English headers equivalent to `Component` / `Status` / `Verify with` and English on-demand / in-session cell wording, without reintroducing Portuguese `Componente`, `Estado`, `Verificar com`, `sob demanda`, or `sessão` tokens into newly written section text, while detect/apply/impeccable control flow remains equivalent to the pre-wave script

### Requirement: Kit-scripts wave-6 templates/install-ui-module.sh residual-PT script is English

The kit UI-module installer template path `sdd-kit/templates/install-ui-module.sh` MUST be written in English after the kit-scripts substitution wave. Residual Portuguese prose in this file is FORBIDDEN after apply, including comments, operator-facing `echo` / stderr messages, and the embedded `openspec/infra.md` UI Development Module table chrome (headers and cell wording) written by the script. Dual-file siblings such as `*.en.sh`, `*-pt.sh`, `*.en.md`, or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/templates/install-ui-module.sh`, `sdd-kit/install-ui-module.sh`, `doc/design/002-ui-module-install.md`, `openspec/infra.md`, and `openspec/project.md`; flags `--detect`, `--dry-run`, `--apply`, `--yes`, and `--repo`; brand/tool names including Impeccable, Open Design, Pencil, Figma MCP, and shadcn; slash commands such as `/opsx:*`; and fenced shell commands) MUST remain unaltered aside from intentional non-i18n fixes. Install-ui-module control flow (detect inventory, dry-run planning, design-doc install, infra section update, and optional Impeccable install) MUST keep the same meaning after prose is normalized to glossary-canonical English. When this template under `sdd-kit/templates/` is edited, `sdd-kit/MANIFEST.yaml` checksums for the corresponding `source:` MUST be refreshed via `bash sdd-kit/gen-manifest-checksums.sh` in the same apply. The hub path `sdd-kit/install-ui-module.sh` is out of scope for this wave’s file list and MUST NOT be required to change in the same apply.

#### Scenario: Kit-scripts wave-6 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/install-ui-module.sh` after the kit-scripts substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on that path)

#### Scenario: No dual-file migration for kit-scripts wave-6

- **WHEN** the kit-scripts substitution wave apply completes
- **THEN** English content is at `sdd-kit/templates/install-ui-module.sh` and no permanent language-suffixed sibling exists for that path

#### Scenario: Embedded infra UI-module chrome stays English-aligned

- **WHEN** a consumer install copies this MANIFEST `source:` template (or an operator runs the template script with `--apply` / `--dry-run` planning that would write the same section) after substitution
- **THEN** the embedded UI Development Module table uses English headers equivalent to `Component` / `Status` / `Verify with` and English on-demand / in-session cell wording, without reintroducing Portuguese `Componente`, `Estado`, `Verificar com`, `sob demanda`, or `sessão` tokens into newly written section text, while detect/apply/impeccable control flow remains equivalent to the pre-wave script

### Requirement: translate-kit-design-wave-3 target surface is English

The following path MUST be written in English after substitution: `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`. Residual Portuguese prose in the substituted slice (lines 1–325) is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced. Freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, URLs, fenced shell, profile labels, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. G-MANIFEST satisfied when kit templates change. Kit template checksums MUST be regenerated when templates change.

#### Scenario: Per-wave verification passes

- **WHEN** an operator runs the wave gate command after apply
- **THEN** the script exits 0 (including G-PT and G-LINK on `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`)

#### Scenario: No dual-file migration

- **WHEN** the wave apply completes
- **THEN** English content remains at `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md` with no permanent `*.en.md` / `*-pt.md` sibling

### Requirement: translate-kit-design-wave-4 target surface is English

The following path MUST be written in English after substitution: `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`. Residual Portuguese prose in the substituted slice (lines 326–592) is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced. Freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, URLs, fenced shell, profile labels, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. G-MANIFEST satisfied when kit templates change. Kit template checksums MUST be regenerated when templates change.

#### Scenario: Per-wave verification passes

- **WHEN** an operator runs the wave gate command after apply
- **THEN** the script exits 0 (including G-PT and G-LINK on `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`)

#### Scenario: No dual-file migration

- **WHEN** the wave apply completes
- **THEN** English content remains at `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md` with no permanent `*.en.md` / `*-pt.md` sibling

### Requirement: simplify-review skill mirrors are English

The logical skill `simplify-review` MUST be written in English at both mirror paths `.cursor/skills/simplify-review/SKILL.md` and `.claude/skills/simplify-review/SKILL.md`. Residual Portuguese prose in either mirror is FORBIDDEN after the skills substitution wave. The two mirrors MUST remain content-equivalent after substitution. Dual-file siblings such as `SKILL.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:apply`, sibling skill names `correctness-review` and `security-reviewer`, finding tags `delete:` / `stdlib:` / `native:` / `yagni:` / `shrink:`, marker `sdd-shortcut:`, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. YAML frontmatter keys MUST keep their structure; human-readable `description` and `adaptedFrom` values MUST be English. Chat-language guidance in the skill MUST align with F7 (chat MAY be Portuguese; the versioned skill artifact MUST be English) and MUST NOT hard-require Portuguese-only responses.

#### Scenario: simplify-review mirrors pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files .cursor/skills/simplify-review/SKILL.md,.claude/skills/simplify-review/SKILL.md` after the skills substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MIRROR on those files)

#### Scenario: No dual-file migration for simplify-review

- **WHEN** the skills substitution wave apply completes
- **THEN** English content is at both `.cursor/skills/simplify-review/SKILL.md` and `.claude/skills/simplify-review/SKILL.md` and no permanent `SKILL.en.md` / `*-pt.md` sibling exists for either path

#### Scenario: Mirrors stay content-equivalent

- **WHEN** an agent compares the two simplify-review skill mirrors after substitution
- **THEN** the file contents are identical (`cmp` succeeds) so Cursor and Claude load the same English instructions

### Requirement: openspec-apply-change skill mirrors are English

The logical skill `openspec-apply-change` MUST be written in English at both mirror paths `.cursor/skills/openspec-apply-change/SKILL.md` and `.claude/skills/openspec-apply-change/SKILL.md`. Residual Portuguese prose in either mirror is FORBIDDEN after the skills substitution wave. The two mirrors MUST remain content-equivalent after substitution. Dual-file siblings such as `SKILL.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:apply` and `/opsx:archive`, session coordination scripts under `scripts/sdd-session-*.sh`, sibling skill names `simplify-review` and `security-reviewer`, fenced shell commands, numeric review-suggestion thresholds, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. YAML frontmatter keys MUST keep their structure; human-readable `description` values MUST be English. Chat-language and Session Handoff guidance in the skill MUST align with F7 (chat MAY be Portuguese; the versioned skill artifact MUST be English) and MUST NOT hard-require Portuguese-only responses.

#### Scenario: openspec-apply-change mirrors pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-apply-change/SKILL.md,.claude/skills/openspec-apply-change/SKILL.md` after the skills substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MIRROR on those files)

#### Scenario: No dual-file migration for openspec-apply-change

- **WHEN** the skills substitution wave apply completes
- **THEN** English content is at both `.cursor/skills/openspec-apply-change/SKILL.md` and `.claude/skills/openspec-apply-change/SKILL.md` and no permanent `SKILL.en.md` / `*-pt.md` sibling exists for either path

#### Scenario: Mirrors stay content-equivalent

- **WHEN** an agent compares the two openspec-apply-change skill mirrors after substitution
- **THEN** the file contents are identical (`cmp` succeeds) so Cursor and Claude load the same English instructions

### Requirement: openspec-archive-change skill mirrors are English

The logical skill `openspec-archive-change` MUST be written in English at both mirror paths `.cursor/skills/openspec-archive-change/SKILL.md` and `.claude/skills/openspec-archive-change/SKILL.md`. Residual Portuguese prose in either mirror is FORBIDDEN after the skills substitution wave. The two mirrors MUST remain content-equivalent after substitution. Dual-file siblings such as `SKILL.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:archive`, `/opsx:explore`, and `/opsx:propose`, skill directory name `openspec-archive-change`, fenced shell commands, archive Guardrails / sync assessment semantics, optional pattern-promotion checklist meaning, advisory metrics-cadence behavior, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. YAML frontmatter keys MUST keep their structure; human-readable `description` values MUST be English. Chat-language and Session Handoff guidance in the skill MUST align with F7 (chat MAY be Portuguese; the versioned skill artifact MUST be English) and MUST NOT hard-require Portuguese-only responses.

#### Scenario: openspec-archive-change mirrors pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-archive-change/SKILL.md,.claude/skills/openspec-archive-change/SKILL.md` after the skills substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MIRROR on those files)

#### Scenario: No dual-file migration for openspec-archive-change

- **WHEN** the skills substitution wave apply completes
- **THEN** English content is at both `.cursor/skills/openspec-archive-change/SKILL.md` and `.claude/skills/openspec-archive-change/SKILL.md` and no permanent `SKILL.en.md` / `*-pt.md` sibling exists for either path

#### Scenario: Mirrors stay content-equivalent

- **WHEN** an agent compares the two openspec-archive-change skill mirrors after substitution
- **THEN** the file contents are identical (`cmp` succeeds) so Cursor and Claude load the same English instructions

### Requirement: openspec-propose skill mirrors are English

The logical skill `openspec-propose` MUST be written in English at both mirror paths `.cursor/skills/openspec-propose/SKILL.md` and `.claude/skills/openspec-propose/SKILL.md`. Residual Portuguese prose in either mirror is FORBIDDEN after the skills substitution wave. The two mirrors MUST remain content-equivalent after substitution. Dual-file siblings such as `SKILL.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:propose` and `/opsx:apply`, OpenSpec CLI fences, §12.10 Gate/Pattern references, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. YAML frontmatter keys MUST keep their structure; human-readable `description` values MUST be English. Chat-language and Session Handoff guidance in the skill MUST align with F7 (chat MAY be Portuguese; the versioned skill artifact MUST be English) and MUST NOT hard-require Portuguese-only responses.

#### Scenario: openspec-propose mirrors pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-propose/SKILL.md,.claude/skills/openspec-propose/SKILL.md` after the skills substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MIRROR on those files)

#### Scenario: No dual-file migration for openspec-propose

- **WHEN** the skills substitution wave apply completes
- **THEN** English content is at both `.cursor/skills/openspec-propose/SKILL.md` and `.claude/skills/openspec-propose/SKILL.md` and no permanent `SKILL.en.md` / `*-pt.md` sibling exists for either path

#### Scenario: Mirrors stay content-equivalent

- **WHEN** an agent compares the two openspec-propose skill mirrors after substitution
- **THEN** the file contents are identical (`cmp` succeeds) so Cursor and Claude load the same English instructions

### Requirement: translate-guide-wave-4 target surface is English

The following path MUST be written in English after substitution: `doc/sistema-sdd-pedro.md`. Residual Portuguese prose in the substituted slice (lines 425–621) is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced. Freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, URLs, fenced shell, profile labels, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes.

#### Scenario: Per-wave verification passes

- **WHEN** an operator runs the wave gate command after apply
- **THEN** the script exits 0 (including G-PT and G-LINK on `doc/sistema-sdd-pedro.md`)

#### Scenario: No dual-file migration

- **WHEN** the wave apply completes
- **THEN** English content remains at `doc/sistema-sdd-pedro.md` with no permanent `*.en.md` / `*-pt.md` sibling

### Requirement: translate-guide-wave-5 target surface is English

The following path MUST be written in English after substitution: `doc/sistema-sdd-pedro.md`. Residual Portuguese prose in the substituted slice (lines 622–839) is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced. Freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, URLs, fenced shell, profile labels, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes.

#### Scenario: Per-wave verification passes

- **WHEN** an operator runs the wave gate command after apply
- **THEN** the script exits 0 (including G-PT and G-LINK on `doc/sistema-sdd-pedro.md`)

#### Scenario: No dual-file migration

- **WHEN** the wave apply completes
- **THEN** English content remains at `doc/sistema-sdd-pedro.md` with no permanent `*.en.md` / `*-pt.md` sibling

