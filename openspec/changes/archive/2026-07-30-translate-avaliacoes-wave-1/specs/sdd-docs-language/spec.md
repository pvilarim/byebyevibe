## ADDED Requirements

### Requirement: Evaluation wave-1 surfaces are English

The following evaluation documentation paths MUST be written in English after the evaluations substitution wave: `doc/avaliacoes/README.md`, `doc/avaliacoes/TEMPLATE.md`, `doc/avaliacoes/2026-03-26-headroom-context-compression.md`, and `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths including the `doc/avaliacoes/` directory segment until a dedicated rename wave, change-ids, slash commands such as `/opsx:*`, package pins, URLs, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Historical decision outcomes (Adopted / Discarded / Deferred / Under evaluation) MUST keep the same meaning after label language is normalized to glossary-canonical English.

#### Scenario: Evaluation wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/README.md,doc/avaliacoes/TEMPLATE.md,doc/avaliacoes/2026-03-26-headroom-context-compression.md,doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` after the evaluations substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for evaluation wave-1

- **WHEN** the evaluations substitution wave apply completes
- **THEN** English content is at the four listed `doc/avaliacoes/` paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: Decision outcomes remain stable

- **WHEN** an agent reads the Headroom and OSS coverage-gaps evaluation records after substitution
- **THEN** Headroom remains Discarded (not re-opened as Adopted) and each OSS-gaps row keeps its pre-wave Adopted / Deferred / mixed outcome meaning while prose and status labels are English
