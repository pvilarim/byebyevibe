# sdd-task-patterns Specification

## Purpose

Normative requirements for enriched OpenSpec `tasks.md`: pattern pointers, deterministic gates, three-level anchoring, DOCS_SPECS repository boundaries, and cross-repo guidance via skills. Reduces agent reinvention and makes task completion verifiable by shell commands.
## Requirements
### Requirement: Task pattern pointer format

For implementation tasks in `openspec/changes/<id>/tasks.md` that modify code or executable scripts, each task MUST use structured sub-bullets below the checkbox. At minimum, tasks that change behavior MUST include a **Gate** sub-bullet with a deterministic shell command. Tasks SHOULD include a **Pattern** sub-bullet pointing to an existing file path (and optional line) to follow, not reinvent.

#### Scenario: Code task with pattern and gate

- **WHEN** an agent creates a task that implements a new repository in an APP-profile repo
- **THEN** the task includes `- **Pattern:**` with a repo-relative path to an existing similar file and `- **Gate:**` with a test or lint command that verifies completion

#### Scenario: Documentation-only task

- **WHEN** a task only edits markdown or OpenSpec artifacts
- **THEN** the task MAY omit `Pattern` but MUST include a verifiable `Gate` (e.g., `npx openspec validate <id>`, `wc -l AGENTS.md`)

### Requirement: Three-level anchoring model

The SDD guide MUST document a three-level anchoring model for task guidance: (1) **pointer** — file path reference only (default); (2) **skeleton** — at most 15 lines of interface/signature/example test; (3) **boilerplate snippet** — full snippet only for stable boilerplate (migrations, Zod base schemas, hook templates), tagged as boilerplate-only with a source reference.

#### Scenario: Default task uses pointer only

- **WHEN** an existing implementation clearly demonstrates the pattern
- **THEN** the task uses Nível 1 (pointer) without embedding the full source file in `tasks.md`

#### Scenario: Long snippet rejected in tasks

- **WHEN** a propose-phase agent would embed more than 15 lines of code in a single task
- **THEN** the content MUST be moved to a skill (`.cursor/skills/` or `.claude/skills/`) or referenced via archived change path, with the task retaining only a pointer

### Requirement: Design versus tasks content separation

`design.md` MUST contain architectural decisions, alternatives, and knowledge-source citations. `tasks.md` MUST contain atomic steps, pattern pointers, gates, and optional `Proibido` (anti-patterns). `tasks.md` MUST NOT duplicate decision rationale already captured in `design.md`.

#### Scenario: Decision lives in design only

- **WHEN** a propose phase documents why cosine similarity was chosen over dot product
- **THEN** that rationale appears in `design.md` Decisions, not repeated as prose in `tasks.md`

### Requirement: SDD guide template section 12.10

`doc/sistema-sdd-pedro.md` MUST include section **12.10** with a complete `tasks.md` template showing checkbox format, sub-bullets (`Pattern`, `Gate`, `Invariants`, `Proibido`), the three-level model, and examples for APP and DOCS_SPECS profiles.

#### Scenario: New installation copies task template

- **WHEN** an operator or agent installs SDD using the guide templates
- **THEN** section 12.10 provides a copy-paste template for enriched `tasks.md` entries

### Requirement: Propose-phase task generation rules

The `openspec-propose` skill (and mirrored commands) MUST instruct agents to generate enriched tasks per section 12.10 for code-touching work, validate that `Pattern` paths exist in the repo when resolvable, and mark unresolvable cross-repo paths as `[NEEDS VERIFICATION]`.

#### Scenario: Propose validates pattern path

- **WHEN** a propose-phase task includes `Pattern: doc/curso/scripts/enrich-transcripts.py`
- **THEN** the agent confirms the path exists before finalizing `tasks.md`

#### Scenario: Cross-repo pattern

- **WHEN** a pattern lives in another repository
- **THEN** the task uses `Pattern: <repo-name>:<path>` and flags `[NEEDS VERIFICATION]` if not confirmable in the current workspace

### Requirement: Apply-phase impact and gate enforcement

The `openspec-apply-change` skill MUST require `gitnexus impact` (or equivalent codebase read) before the first task that modifies code, and MUST run each task's `Gate` command before marking the task complete (`- [x]`).

#### Scenario: Apply runs gate before checkbox

- **WHEN** an agent completes a task with `Gate: npm test -- subscription.repo`
- **THEN** the agent runs the gate command and only marks the task complete if it exits 0

#### Scenario: Apply pauses on missing pattern file

- **WHEN** a task's `Pattern` path does not exist at apply time
- **THEN** the agent pauses, reports the broken pointer, and suggests updating `tasks.md` or the codebase before continuing

### Requirement: Task pattern verification script

The repository MUST provide `scripts/verify-task-patterns.sh` that scans active change `tasks.md` files for `Pattern:` paths and reports missing files. The script MUST exit non-zero if any resolvable repo-relative path is missing.

#### Scenario: Script catches stale pointer

- **WHEN** `tasks.md` references `Pattern: src/moved-away.ts` and that file does not exist
- **THEN** `bash scripts/verify-task-patterns.sh` exits non-zero and lists the broken reference

### Requirement: Post-archive pattern promotion checklist

The `openspec-archive-change` skill MUST evaluate, as an agent-assessed item inside the same consolidated closing assessment defined by `sdd-skill-guidance`, whether a stable pattern from the archived change should be promoted to a reusable skill or noted in `openspec/project.md` Cross-references for future tasks. The skill MUST always print the per-item verdict in the archive summary (this printed line is the operator reminder), MUST prompt the operator at most once via the single consolidated prompt covering only positively-signaled items, and MUST NOT block the archive.

#### Scenario: Archive prompts pattern promotion

- **WHEN** all tasks are complete and the agent's assessment finds a reusable pattern in the archived change
- **THEN** the pattern-promotion item appears in the single consolidated closing prompt (promotion targets: reusable skill or `openspec/project.md` Cross-references) before archiving completes

#### Scenario: Clean archive prints reminder without prompting

- **WHEN** all tasks are complete and the agent's assessment finds no reusable pattern
- **THEN** the archive summary shows the pattern-promotion verdict as a printed line and no promotion prompt is presented

### Requirement: AGENTS.md references task patterns

`AGENTS.md` MUST include a row in the "Contexto sob demanda" table pointing to `doc/sistema-sdd-pedro.md` §12.10 for task pattern and gate conventions. The addition MUST keep `AGENTS.md` at or below 150 lines.

#### Scenario: Agent loads task conventions on demand

- **WHEN** an agent needs to write or execute enriched tasks
- **THEN** AGENTS.md directs it to §12.10 without duplicating the full template

### Requirement: DOCS_SPECS repository boundary for patterns

In repositories with profile **DOCS_SPECS** (no application code at repo root), `tasks.md` MUST NOT use cross-repo `Pattern: <repo>:<path>` references. Implementation tasks for application code (e.g. `src/`, Next.js routes) MUST live in an OpenSpec change in the application repository. Cross-repository guidance MUST use `- **Skill:** <name>` pointing to a lazy-loaded skill, not embedded APP code paths in this hub repo.

#### Scenario: DOCS_SPECS rejects cross-repo pattern in task

- **WHEN** a propose-phase agent adds `Pattern: multi-agent-bot:src/infra/foo.ts` in a DOCS_SPECS hub repo
- **THEN** `scripts/verify-task-patterns.sh` exits non-zero and the agent must use a Skill reference or move implementation to the APP repo change

#### Scenario: DOCS_SPECS allows in-repo script pattern

- **WHEN** a task modifies `doc/curso/scripts/enrich-transcripts.py` with `Pattern: doc/curso/scripts/extract-lessons-batch.py`
- **THEN** the pattern is valid and verifiable within the DOCS_SPECS repository

### Requirement: Cross-repo patterns via skills

When a canonical pattern lives in another repository or exceeds 15 lines, the task MUST reference `- **Skill:** <skill-name>` instead of embedding code or using `repo:path` in DOCS_SPECS hubs. The skill body MAY describe structure and canonical paths in the APP repo as prose.

#### Scenario: Long pattern moved to skill

- **WHEN** a pattern requires more than 15 lines of example code
- **THEN** the propose phase creates or updates `.cursor/skills/<domain>-pattern/SKILL.md` and the task references the skill name

