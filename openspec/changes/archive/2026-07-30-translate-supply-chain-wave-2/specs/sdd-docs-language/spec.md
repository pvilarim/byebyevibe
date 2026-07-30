## ADDED Requirements

### Requirement: Supply-chain wave-2 design artifact is English

The active-change design artifact at `openspec/changes/add-supply-chain-gates/design.md` MUST be written in English after the supply-chain wave-2 substitution. Residual Portuguese prose in that file is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, workflow names, OSV action SHA pins, package pins, MANIFEST keys including `merge:`, `gate:`, and `sha256:`, decision IDs `D1`–`D9`, URLs, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Historical design decisions (OSV inside `sdd-gates`, SHA pin, lockfile execution matrix, mode A for OSV and Renovate, profile matrix, conservative Renovate preset, SDD PR classification, optional skill SKIP, Renovate pilot, 6-point registry, and rollback) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Supply-chain wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-supply-chain-gates/design.md` after the supply-chain wave-2 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for supply-chain wave-2

- **WHEN** the supply-chain wave-2 substitution apply completes
- **THEN** English content is at `openspec/changes/add-supply-chain-gates/design.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Supply-chain design decisions remain stable

- **WHEN** an agent reads the translated design for `add-supply-chain-gates`
- **THEN** the OSV-inside-sdd-gates choice, action SHA pin, lockfile matrix, Renovate profile SKIP rules, mode A, pilot-exception rationale, 6-point registry, rollback intent, and decision ID labels remain equivalent to the pre-wave Portuguese artifact while surrounding prose and headings are English
