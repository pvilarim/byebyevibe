## ADDED Requirements

### Requirement: Probity wave-2 design artifact is English

The active-change design artifact at `openspec/changes/add-probity-tdd-module/design.md` MUST be written in English after the probity wave-2 substitution. Residual Portuguese prose in that file is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, package pin `@nizos/probity@1.10.0`, rule identifiers including `enforceTdd`, `forbidCommandPattern`, and `requireCommand`, MANIFEST keys including `merge:`, `gate:`, and `sha256:`, decision IDs `D1`–`D10`, A–E matrix labels, URLs, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Historical design decisions (Probity over TDD Guard, mode B in-band PreToolUse, `probity.config.ts` fail-closed template, `install-probity-module.sh`, PreToolUse stacking order, Cursor IDE support status, A–E matrix, 6-point registry, lint gap deferral, optional `probity-guard` skill, and quantified pilot before MANIFEST bump) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Probity wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-probity-tdd-module/design.md` after the probity wave-2 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for probity wave-2

- **WHEN** the probity wave-2 substitution apply completes
- **THEN** English content is at `openspec/changes/add-probity-tdd-module/design.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Probity design decisions remain stable

- **WHEN** an agent reads the translated design for `add-probity-tdd-module`
- **THEN** the Probity-over-TDD-Guard choice, package pin, mode B stacking, profile SKIP rules, A–E matrix, pilot-before-MANIFEST rationale, 6-point registry, lint-gap deferral, optional skill criteria, and decision ID labels remain equivalent to the pre-wave Portuguese artifact while surrounding prose and headings are English
