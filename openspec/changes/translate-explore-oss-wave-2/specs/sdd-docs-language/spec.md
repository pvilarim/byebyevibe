## ADDED Requirements

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
