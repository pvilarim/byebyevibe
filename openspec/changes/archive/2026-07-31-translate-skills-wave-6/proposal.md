**Issue:** —

## Why

WSk waves 1–5 proposed `correctness-review`, `simplify-review`, `openspec-apply-change`, `openspec-explore`, and `openspec-archive-change`. The next completable whole-file residual on the WSk track is the `openspec-propose` skill (~141 LOC × Cursor + Claude mirrors). The body is mostly English already; residual Portuguese remains in the Session Handoff stub (operator-facing strings). Canonical guide section waves remain blocked for mid-file G-PT; this slice fits budgets (1 skill × 2 mirrors; ≤350–400 LOC counting one logical skill body), passes whole-file G-PT/G-MIRROR on apply, and is disjoint from in-flight kit/infra/avaliacoes/design/skills-wave-1–5 ownership and open translate PRs. Rematerializes the colliding PR #91 slice under a free change-id.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `.cursor/skills/openspec-propose/SKILL.md`
  - `.claude/skills/openspec-propose/SKILL.md`
- Keep both mirrors **byte-identical** after substitution (G-MIRROR)
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, skill names, fenced shell, brand/tool names, §12.10 references) byte-stable
- Align Session Handoff / chat stubs with F7: skill body English; chat MAY remain pt-BR (do not hard-require Portuguese responses)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-propose/SKILL.md,.claude/skills/openspec-propose/SKILL.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec-propose` skill mirrors (`.cursor` + `.claude`) MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; G-MIRROR content equivalence required.

## Impact

- Files modified: the two skill mirror paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; skill paths not owned by active kit/infra/avaliacoes/design/`translate-skills-wave-1`–`5` changes — explore=wave-4, archive=wave-5 — or open translate PRs #78 / #84)
- Risks: G-PT false positives; G-INV if `/opsx:*` or paths rewritten; mirror drift (G-MIRROR); accidental semantic drift vs propose workflow Steps/Output or enriched-tasks (§12.10) rules (language only)
- **Non-goals:** other skills (`openspec-explore` / `openspec-archive-change` already proposed as waves 4–5; review skills and `openspec-apply-change` already proposed); commands under `.cursor/commands/` / `.claude/commands/opsx/`; canonical guide; kit templates; hub `openspec/infra.md`; evaluations; design docs; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing propose workflow steps, AskUserQuestion flow, or §12.10 Gate/Pattern rules — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-propose/SKILL.md,.claude/skills/openspec-propose/SKILL.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MIRROR**, **G-OPENSPEC**.  
N/A this wave: **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. create change → status → instructions loop until apply-ready; enriched tasks Gate/Pattern rules; Session Handoff to `/opsx:apply`).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, skill directory names, brand/tool names untouched
- [ ] YAML frontmatter keys (`name`, `description`, `license`, `compatibility`, `metadata`) structure preserved; translate `description` string values to English if residual PT
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected)
- [ ] No dual-file EN/PT siblings introduced
- [ ] `.cursor` and `.claude` mirrors updated together and remain content-equivalent

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-skills-wave-6

Change: openspec/changes/translate-skills-wave-6/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-propose/SKILL.md,.claude/skills/openspec-propose/SKILL.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
