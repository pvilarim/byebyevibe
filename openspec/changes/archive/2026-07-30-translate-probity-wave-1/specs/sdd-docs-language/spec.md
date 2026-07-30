## ADDED Requirements

### Requirement: Probity wave-1 active-change artifacts are English

The following active-change artifact paths under `openspec/changes/add-probity-tdd-module/` MUST be written in English after the Probity substitution wave-1: `proposal.md`, `tasks.md`, and `piloto-nota.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, package pin `@nizos/probity@1.10.0`, identifier `enforceTdd`, script names including `install-probity-module.sh`, URLs, fenced shell commands, checklist markers, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Historical apply outcomes (pilot PENDING / blocked-by-missing-APP-worktree status, kit scaffolding already delivered, 6-point registry references, TDD Guard → Probity migration notes, and task completion markers) MUST keep the same meaning after prose is normalized to glossary-canonical English. The path basename `piloto-nota.md` MAY remain unchanged (contents English; no rename in this wave). Sibling `design.md` is OUT of this requirement (deferred to a later wave).

#### Scenario: Probity wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-probity-tdd-module/proposal.md,openspec/changes/add-probity-tdd-module/tasks.md,openspec/changes/add-probity-tdd-module/piloto-nota.md` after the Probity wave-1 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for Probity wave-1

- **WHEN** the Probity wave-1 substitution apply completes
- **THEN** English content is at the three listed `add-probity-tdd-module` artifact paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: Probity historical outcomes remain stable

- **WHEN** an agent reads the translated proposal, tasks, and pilot note for `add-probity-tdd-module`
- **THEN** the pilot PENDING status, kit install pointers, package pin, `enforceTdd` references, 6-point registry contract, and historical `[x]` completion markers remain equivalent to the pre-wave Portuguese artifacts while surrounding prose and headings are English
