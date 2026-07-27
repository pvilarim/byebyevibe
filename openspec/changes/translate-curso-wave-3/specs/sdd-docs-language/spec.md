## ADDED Requirements

### Requirement: Course wave-3 workshop lesson 02 is English

The following course documentation path MUST be written in English after the course substitution wave: `doc/curso/aula-02-workshop-ia-5-2026.md`. Residual Portuguese prose in this file is FORBIDDEN after apply, including structured enrichment chrome (title, summary, topics, link-table category labels, spoken-reference blurbs, how-to-use blurb) and the spoken transcript body. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, URLs, transcript/lesson/section IDs, relative link to `aula-02-shared-files.md`, brand/tool names including Cursor, OpenSpec, CodeRabbit, Bugbot, Stripe, Jira, Linear, BMAD, Superpowers, Excalidraw, Martin Fowler, Simon Willison, and Tech Leads Club, and speaker/org proper nouns including Waldemar Neto / Valdemar, Geovani, Bruno, and Felipe) MUST remain unaltered aside from intentional non-i18n fixes. Workshop Spec-Driven / harness / code-review talk facts (native plan limits on large features, TLC Spec-Driven phases with gates/evals/DoD, atomic tasks vs board tasks, ~17% context with sub-agents, harness feedforward vs feedback, OpenSpec/BMAD/Superpowers/spec-kit comparisons, multi-skill code review vs CodeRabbit/Bugbot) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Course wave-3 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files doc/curso/aula-02-workshop-ia-5-2026.md` after the course substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for course wave-3

- **WHEN** the course substitution wave apply completes
- **THEN** English content is at `doc/curso/aula-02-workshop-ia-5-2026.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Metadata links and talk facts remain stable

- **WHEN** an agent reads the aula-02 workshop lesson after substitution
- **THEN** lesson URL, section/lesson/transcript identifiers, relative link to `aula-02-shared-files.md`, numbered link-table URLs, and Spec-Driven / harness / code-review talk facts remain equivalent to the pre-wave Portuguese doc while surrounding prose and headings are English
