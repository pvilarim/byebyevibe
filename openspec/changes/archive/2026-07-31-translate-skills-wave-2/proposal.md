**Issue:** —

## Why

WSk wave 1 proposed `correctness-review`. The next completable whole-file residual on the WSk track is the `simplify-review` skill (~196 LOC × Cursor + Claude mirrors = ~392 LOC). Canonical guide section waves remain blocked for mid-file G-PT; this slice fits budgets (1 skill × 2 mirrors; ≤350–400 LOC), passes whole-file G-PT/G-MIRROR on apply, and is disjoint from in-flight kit W2c/W2d, infra, and `translate-skills-wave-1` paths.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `.cursor/skills/simplify-review/SKILL.md`
  - `.claude/skills/simplify-review/SKILL.md`
- Keep both mirrors **byte-identical** after substitution (G-MIRROR)
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, sibling skill names `correctness-review` / `security-reviewer`, finding tags `delete:` / `stdlib:` / `native:` / `yagni:` / `shrink:`, marker `sdd-shortcut:`, fenced shell, brand/tool names) byte-stable
- Align chat-language instruction with F7: skill body English; chat MAY remain pt-BR (do not hard-require Portuguese responses)
- Map verdict label `ESCOPO CONFLITANTE` → `CONFLICTING SCOPE` and metric/header vocabulary (`achados` → `findings`, etc.) without changing tag identifiers
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files .cursor/skills/simplify-review/SKILL.md,.claude/skills/simplify-review/SKILL.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `simplify-review` skill mirrors (`.cursor` + `.claude`) MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; G-MIRROR content equivalence required.

## Impact

- Files modified: the two skill mirror paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; skill paths not owned by active kit/infra/`translate-skills-wave-1` changes)
- Risks: G-PT false positives; G-INV if `/opsx:*` or tag names rewritten; mirror drift (G-MIRROR); accidental semantic drift vs when-to-invoke matrix / protected boundaries (language only)
- **Non-goals:** other skills (`openspec-*`, `correctness-review`, gitnexus); commands; canonical guide; kit templates; hub `openspec/infra.md`; evaluations; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing invoke thresholds, tag set, or protected-boundary semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files .cursor/skills/simplify-review/SKILL.md,.claude/skills/simplify-review/SKILL.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MIRROR**, **G-OPENSPEC**.  
N/A this wave: **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. invoke after large apply/pre-PR; one-finding-per-line with tags; do not flag protected Zod/RLS/shadcn/spec-required code).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, skill directory names, finding tags (`delete:` …), `sdd-shortcut:`, brand/tool names untouched
- [ ] YAML frontmatter keys (`name`, `description`, `license`, `metadata`) structure preserved; translate `description` / `adaptedFrom` string values to English
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected)
- [ ] No dual-file EN/PT siblings introduced
- [ ] `.cursor` and `.claude` mirrors updated together and remain content-equivalent

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-skills-wave-2

Change: openspec/changes/translate-skills-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files .cursor/skills/simplify-review/SKILL.md,.claude/skills/simplify-review/SKILL.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
