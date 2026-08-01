# sdd-docs-language Specification (delta)

## ADDED Requirements

### Requirement: Canonical guide path reflects the project name

The canonical install guide MUST live at `doc/byebyevibe-guide.md` (project-named, EN). The legacy path `doc/sistema-sdd-pedro.md` MUST contain only a short English redirect stub pointing to the new path and noting that historical artifacts cite the old name. Language gates (`scripts/verify-i18n-wave.sh` file list and any slice tooling such as `scripts/gen-missing-translate-proposes.py` / `scripts/translate-guide-next-wave.sh`) MUST target the new path. Requirements, archived changes, and dated evaluations written before the rename cite the legacy path and MUST NOT be retro-edited — both names refer to the same document, and the rename MUST be recorded as an alias note in `openspec/project.md` Cross-references and `AGENTS.md`. New or modified artifacts MUST cite the new path.

#### Scenario: Language gate targets the renamed guide

- **WHEN** `scripts/verify-i18n-wave.sh` runs its whole-file scope
- **THEN** `doc/byebyevibe-guide.md` is in the checked file list and `doc/sistema-sdd-pedro.md` is not (the stub is EN-only and out of scope)

#### Scenario: Legacy path redirects instead of 404ing

- **WHEN** a reader follows a pre-rename link to `doc/sistema-sdd-pedro.md`
- **THEN** they find a stub (≤5 lines) pointing to `doc/byebyevibe-guide.md` with the archives-cite-old-name note

#### Scenario: Alias is recorded for interpreters of historical text

- **WHEN** an agent reading a pre-rename spec or archive greps for the rename
- **THEN** `openspec/project.md` and `AGENTS.md` each contain a one-line alias note mapping the old path to the new path

#### Scenario: Historical requirements are not retro-edited

- **WHEN** the rename change is applied
- **THEN** `openspec/changes/**` and pre-existing spec files (beyond this change's two deltas) contain no edits substituting the new name into historical text
