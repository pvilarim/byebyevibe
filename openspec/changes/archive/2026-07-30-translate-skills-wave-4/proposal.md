**Issue:** —

## Why

WSk waves 1–3 proposed `correctness-review`, `simplify-review`, and `openspec-apply-change`. The next completable whole-file residual on the WSk track is the `openspec-explore` skill (~304 LOC × Cursor + Claude mirrors). The body is mostly English already; residual Portuguese remains in the Session Handoff stub (operator-facing strings). Canonical guide section waves remain blocked for mid-file G-PT; this slice fits budgets (1 skill × 2 mirrors; ≤350–400 LOC counting one logical skill body), passes whole-file G-PT/G-MIRROR on apply, and is disjoint from in-flight kit/infra/avaliacoes/design/skills-wave-1–3 ownership and open translate PRs.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `.cursor/skills/openspec-explore/SKILL.md`
  - `.claude/skills/openspec-explore/SKILL.md`
- Keep both mirrors **byte-identical** after substitution (G-MIRROR)
- Preserve freeze-list tokens (paths, change-ids, `/opsx:propose` / `/opsx:explore`, skill name `openspec-explore`, fenced shell, brand/tool names, explore Guardrails semantics) byte-stable
- Align Session Handoff / chat stubs with F7: skill body English; chat MAY remain pt-BR (do not hard-require Portuguese responses)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-explore/SKILL.md,.claude/skills/openspec-explore/SKILL.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec-explore` skill mirrors (`.cursor` + `.claude`) MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; G-MIRROR content equivalence required.

## Impact

- Files modified: the two skill mirror paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; skill paths not owned by active kit/infra/avaliacoes/design/`translate-skills-wave-1`/`-2`/`-3` changes or open translate PRs #78 / #84)
- Risks: G-PT false positives; G-INV if `/opsx:*` rewritten; mirror drift (G-MIRROR); accidental semantic drift vs explore Guardrails (language only — still MUST NOT implement application code)
- **Non-goals:** other skills (`openspec-propose` / `openspec-archive-change`, apply/review skills already proposed); commands under `.cursor/commands/` / `.claude/commands/opsx/`; canonical guide; kit templates; hub `openspec/infra.md`; evaluations; design docs; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing explore Guardrails, research capture behavior, or propose handoff semantics beyond language — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-explore/SKILL.md,.claude/skills/openspec-explore/SKILL.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MIRROR**, **G-OPENSPEC**.  
N/A this wave: **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. enter explore without implementing; offer research capture without auto-writing; Session Handoff to `/opsx:propose` with clean context).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, skill directory name `openspec-explore`, brand/tool names untouched
- [ ] YAML frontmatter keys (`name`, `description`, `license`, `compatibility`, `metadata`) structure preserved; translate `description` string values to English if residual PT
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected)
- [ ] No dual-file EN/PT siblings introduced
- [ ] `.cursor` and `.claude` mirrors updated together and remain content-equivalent

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-skills-wave-4

Change: openspec/changes/translate-skills-wave-4/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-explore/SKILL.md,.claude/skills/openspec-explore/SKILL.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
