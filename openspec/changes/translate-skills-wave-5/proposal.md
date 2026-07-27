**Issue:** —

## Why

WSk waves 1–4 proposed `correctness-review`, `simplify-review`, `openspec-apply-change`, and `openspec-explore`. Open DRAFT PR #91 already owns the `openspec-propose` skill mirrors (path list — even though it reuses the colliding change-id `translate-skills-wave-4`). The next completable whole-file residual on the WSk track is therefore the `openspec-archive-change` skill (~148 LOC × Cursor + Claude mirrors). The body is mostly English already; residual Portuguese remains in the pattern-promotion prompt, Session Handoff stub, and metrics-cadence nudge (operator-facing strings). Canonical guide section waves remain blocked for mid-file G-PT; this slice fits budgets (1 skill × 2 mirrors; ≤350–400 LOC counting one logical skill body), passes whole-file G-PT/G-MIRROR on apply, and is disjoint from in-flight kit/infra/avaliacoes/design/skills-wave-1–4 ownership and open translate PRs #78 / #84 / #91.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `.cursor/skills/openspec-archive-change/SKILL.md`
  - `.claude/skills/openspec-archive-change/SKILL.md`
- Keep both mirrors **byte-identical** after substitution (G-MIRROR)
- Preserve freeze-list tokens (paths, change-ids, `/opsx:archive` / `/opsx:explore` / `/opsx:propose`, skill name `openspec-archive-change`, fenced shell, brand/tool names, archive Guardrails / sync assessment semantics) byte-stable
- Align Session Handoff / chat stubs with F7: skill body English; chat MAY remain pt-BR (do not hard-require Portuguese responses)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-archive-change/SKILL.md,.claude/skills/openspec-archive-change/SKILL.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec-archive-change` skill mirrors (`.cursor` + `.claude`) MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; G-MIRROR content equivalence required.

## Impact

- Files modified: the two skill mirror paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; skill paths not owned by active kit/infra/avaliacoes/design/`translate-skills-wave-1`–`4` changes or open translate PRs #78 / #84 / #91)
- Risks: G-PT false positives; G-INV if `/opsx:*` rewritten; mirror drift (G-MIRROR); accidental semantic drift vs archive Guardrails / sync assessment / metrics cadence (language only — still MUST NOT block archive on optional pattern promotion)
- **Non-goals:** other skills (`openspec-propose` owned by open PR #91; explore/apply/review skills already proposed); commands under `.cursor/commands/` / `.claude/commands/opsx/`; canonical guide; kit templates; hub `openspec/infra.md`; evaluations; design docs; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing archive sync assessment, pattern-promotion optionality, or metrics-cadence behavior beyond language — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-archive-change/SKILL.md,.claude/skills/openspec-archive-change/SKILL.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MIRROR**, **G-OPENSPEC**.  
N/A this wave: **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. archive with sync assessment; optional pattern-promotion prompt without blocking; metrics cadence nudge advisory-only).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, skill directory name `openspec-archive-change`, brand/tool names untouched
- [ ] YAML frontmatter keys (`name`, `description`, `license`, `compatibility`, `metadata`) structure preserved; translate `description` string values to English if residual PT
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected)
- [ ] No dual-file EN/PT siblings introduced
- [ ] `.cursor` and `.claude` mirrors updated together and remain content-equivalent

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-skills-wave-5

Change: openspec/changes/translate-skills-wave-5/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-archive-change/SKILL.md,.claude/skills/openspec-archive-change/SKILL.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
