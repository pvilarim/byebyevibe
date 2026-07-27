## ADDED Requirements

### Requirement: Course wave-1 workshop lesson 04 is English

The following course documentation path MUST be written in English after the course substitution wave: `doc/curso/aula-04-workshop-ia-5-2026.md`. Residual Portuguese prose in this file is FORBIDDEN after apply, including structured enrichment chrome (title, summary, topics, link-table category labels, how-to-use blurb) and the spoken transcript body. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, URLs, transcript/lesson/section IDs, relative link to `aula-04-shared-files.md`, brand/tool names including Cursor, Notion, Slack, Linear, Figma, Velora, and Tech Leads Club, and speaker/org proper nouns) MUST remain unaltered aside from intentional non-i18n fixes. Workshop case-study facts (AI-first org adoption story, stack, development flow) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Course wave-1 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files doc/curso/aula-04-workshop-ia-5-2026.md` after the course substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for course wave-1

- **WHEN** the course substitution wave apply completes
- **THEN** English content is at `doc/curso/aula-04-workshop-ia-5-2026.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Metadata links and case-study facts remain stable

- **WHEN** an agent reads the aula-04 workshop lesson after substitution
- **THEN** lesson URL, section/lesson/transcript identifiers, relative link to `aula-04-shared-files.md`, numbered link-table URLs, and Velora AI-first case-study facts remain equivalent to the pre-wave Portuguese doc while surrounding prose and headings are English
