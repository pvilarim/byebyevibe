## ADDED Requirements

### Requirement: Course wave-5 scripts AGENTS.md is English

The following course documentation path MUST be written in English after the course substitution wave: `doc/curso/scripts/AGENTS.md`. Residual Portuguese prose in this file is FORBIDDEN after apply, including title/intro blurb, Commands table headers and usage blurbs, Prerequisites / Local rules / Flow headings, and local-rule / workflow prose. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `../../../AGENTS.md` and `doc/curso/scripts/`, script names `extract-lessons-batch.py`, `enrich-transcripts.py`, and `_debug-lessons345.py`, CDP flag `--remote-debugging-port=9222`, VTT host path `techleads.club/media_transcripts/`, output filename patterns `aula-XX-workshop-*.md` / `aula-XX-shared-files.md`, brand/org Tech Leads Club, and the A–E task-classification / security inheritance pointer to root `AGENTS.md`) MUST remain unaltered aside from intentional non-i18n fixes. Course-script workflow facts (Chrome CDP extract → enrich pipeline, clear resource timings before each lesson navigation, prefer VTT transcripts, do not commit session tokens/cookies/credentials, inherit root AGENTS protocol) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Course wave-5 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files doc/curso/scripts/AGENTS.md` after the course substitution is applied
- **THEN** the script exits 0 (including G-PT on that file)

#### Scenario: No dual-file migration for course wave-5

- **WHEN** the course substitution wave apply completes
- **THEN** English content is at `doc/curso/scripts/AGENTS.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Script workflow tokens remain stable

- **WHEN** an agent reads the course-scripts AGENTS file after substitution
- **THEN** script filenames, CDP remote-debugging flag, VTT host path, relative pointer to root `AGENTS.md`, and extract→enrich flow order remain equivalent to the pre-wave Portuguese doc while surrounding prose and headings are English
