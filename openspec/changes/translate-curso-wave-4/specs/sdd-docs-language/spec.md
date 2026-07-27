## ADDED Requirements

### Requirement: Course wave-4 workshop lesson 01 is English

The following course documentation path MUST be written in English after the course substitution wave: `doc/curso/aula-01-workshop-ia-5-2026.md`. Residual Portuguese prose in this file is FORBIDDEN after apply, including structured enrichment chrome (title, summary, topics, link-table category labels, spoken-reference blurbs, how-to-use blurb) and the spoken transcript body. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, URLs, transcript/lesson/section IDs, relative link to `aula-01-shared-files.md`, brand/tool names including Cursor, AGENTS.md, CLAUDE.md, MCP, Linear, Confluence, Anthropic, DORA, METR, Excalidraw, and Tech Leads Club, and speaker/org proper nouns including Waldemar Neto / Valdemar, Uncle Bob, Chip Huyen, and Matt Pocock) MUST remain unaltered aside from intentional non-i18n fixes. Workshop adoption / Context Engineering / RPI talk facts (DORA ROI and adoption friction, user-dev vs agent-builder iceberg, vibe coding vs AI-assisted development, probabilistic LLM + agent + harness, AGENTS.md / on-demand loading / context rot, MCP for external context, Research→Plan→Implement with Cursor plan mode, Anthropic Skills vs rules lazy loading, Technical Design Doc → phased tasks, sub-agents / context-window management, Q&A on legacy / language / MCP security / CLAUDE.md vs AGENTS.md) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Course wave-4 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files doc/curso/aula-01-workshop-ia-5-2026.md` after the course substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for course wave-4

- **WHEN** the course substitution wave apply completes
- **THEN** English content is at `doc/curso/aula-01-workshop-ia-5-2026.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Metadata links and talk facts remain stable

- **WHEN** an agent reads the aula-01 workshop lesson after substitution
- **THEN** lesson URL, section/lesson/transcript identifiers, relative link to `aula-01-shared-files.md`, numbered link-table URLs, and adoption / Context Engineering / RPI talk facts remain equivalent to the pre-wave Portuguese doc while surrounding prose and headings are English
