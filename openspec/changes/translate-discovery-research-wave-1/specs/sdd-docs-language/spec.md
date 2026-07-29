## ADDED Requirements

### Requirement: Discovery research wave-1 slice is English

The path `openspec/changes/add-sdd-discovery-positioning/research.md` lines **1–261** (§1–§10) MUST be written in English after the discovery-research substitution wave. Residual Portuguese prose in this line range is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, package pins, URLs, fenced shell commands, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. §9 pre-apply decision defaults (including P6–P8 / BMAD / Landing / Discord non-goals and deferral of full EN translation until stable name) MUST keep the same meaning after label language is normalized to glossary-canonical English.

#### Scenario: Discovery research slice passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md` after the discovery-research wave-1 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for discovery research

- **WHEN** the discovery-research wave-1 apply completes
- **THEN** English content for §1–§10 is at `openspec/changes/add-sdd-discovery-positioning/research.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Pre-apply decision defaults remain stable

- **WHEN** an agent reads §9 after substitution
- **THEN** P6–P8 / BMAD / Landing / Discord remain non-goals, full EN translation remains deferred until stable name (with §11 step ④ still referenced structurally), and prose/labels in lines 1–261 are English
