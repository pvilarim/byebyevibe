## ADDED Requirements

### Requirement: Course wave-2 workshop lesson 03 is English

The following course documentation path MUST be written in English after the course substitution wave: `doc/curso/aula-03-workshop-ia-5-2026.md`. Residual Portuguese prose in this file is FORBIDDEN after apply, including structured enrichment chrome (title, summary, topics, link-table category labels, spoken-reference blurbs, how-to-use blurb) and the spoken transcript body. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, URLs, transcript/lesson/section IDs, relative link to `aula-03-shared-files.md`, brand/tool names including Cursor, Anthropic, Coinbase, Slack, Linear, Excalidraw, Novatec, and Tech Leads Club, and speaker/org proper nouns including Felipe Adamolli, Valdemar, Geovani, and Bruno) MUST remain unaltered aside from intentional non-i18n fixes. Workshop career/market talk facts (productivity plateau range, product engineer vs PM vs builder distinctions, manager IC time expectation, Brazil vs Silicon Valley contrasts, QA gate→coach/platform evolution, four practical moves) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Course wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files doc/curso/aula-03-workshop-ia-5-2026.md` after the course substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for course wave-2

- **WHEN** the course substitution wave apply completes
- **THEN** English content is at `doc/curso/aula-03-workshop-ia-5-2026.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Metadata links and talk facts remain stable

- **WHEN** an agent reads the aula-03 workshop lesson after substitution
- **THEN** lesson URL, section/lesson/transcript identifiers, relative link to `aula-03-shared-files.md`, numbered link-table URLs, and career/market talk facts remain equivalent to the pre-wave Portuguese doc while surrounding prose and headings are English
