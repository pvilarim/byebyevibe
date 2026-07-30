## ADDED Requirements

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
