## ADDED Requirements

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
