## ADDED Requirements

### Requirement: Discovery wave-1 active-change artifacts are English

The following active-change artifact paths under `openspec/changes/add-sdd-discovery-positioning/` MUST be written in English after the discovery substitution wave: `proposal.md`, `design.md`, and `tasks.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, research section anchors such as `§11` / `§12`, decision ids D1–D11 and backlog ids P0–P10, URLs, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Historical apply outcomes (EN root README with vibe→agentic positioning, evaluation promotion path, kit README discovery framing, guide first-contact quickstart, D9 permanent non-goals, D10 README→name→EN→GIF roadmap, D11 metrics blurb without ML claims, manual About/topics checklist, and task completion markers) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Discovery wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/proposal.md,openspec/changes/add-sdd-discovery-positioning/design.md,openspec/changes/add-sdd-discovery-positioning/tasks.md` after the discovery substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for discovery wave-1

- **WHEN** the discovery substitution wave apply completes
- **THEN** English content is at the three listed `add-sdd-discovery-positioning` artifact paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: Discovery historical outcomes remain stable

- **WHEN** an agent reads the translated proposal, design, and tasks for `add-sdd-discovery-positioning`
- **THEN** the D9 permanent non-goals, D10 roadmap sequence, D11 metrics framing without ML claims, evaluation promotion intent, root README / kit README / guide quickstart intents, manual About/topics checklist meaning, and historical `[x]` completion markers remain equivalent to the pre-wave Portuguese artifacts while surrounding prose and headings are English
