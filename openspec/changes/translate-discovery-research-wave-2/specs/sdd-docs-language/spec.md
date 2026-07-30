## ADDED Requirements

### Requirement: Discovery research wave-2 slice is English

The path `openspec/changes/add-sdd-discovery-positioning/research.md` lines **262–404** (§11–§12) MUST be written in English after the discovery-research wave-2 substitution. Residual Portuguese prose in this line range is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, package pins, URLs, fenced shell commands, step ids ①–⑥, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. §11 canonical dissemination sequence (steps ①–⑥), §12.4 permitted vs forbidden README copy, and §12.5 apply-① decision MUST keep the same meaning after label language is normalized to glossary-canonical English.

#### Scenario: Discovery research slice passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md` after the discovery-research wave-2 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for discovery research tail

- **WHEN** the discovery-research wave-2 apply completes
- **THEN** English content for §11–§12 is at `openspec/changes/add-sdd-discovery-positioning/research.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Roadmap sequence and honest metrics claims remain stable

- **WHEN** an agent reads §11–§12 after substitution
- **THEN** steps ①–⑥ order and non-goals (Landing/Discord/BMAD outside roadmap) are unchanged, §12.4 permitted vs forbidden README copy semantics are unchanged, and prose/labels in lines 262–404 are English
