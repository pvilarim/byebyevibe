**Issue:** —

## Why

W1–W2 and hub-infra proposes closed entry points, kit templates, and `openspec/infra.md`. The next completable whole-file residual on the WSk track is the `correctness-review` skill (~182 LOC × Cursor + Claude mirrors = ~364 LOC). Canonical guide section waves remain blocked for mid-file G-PT; this slice fits budgets, passes whole-file G-PT/G-MIRROR on apply, and is disjoint from in-flight `translate-kit-wave-2c` / `2d` / `translate-infra-wave-1`.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `.cursor/skills/correctness-review/SKILL.md`
  - `.claude/skills/correctness-review/SKILL.md`
- Keep both mirrors **byte-identical** after substitution (G-MIRROR)
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, skill names `simplify-review` / `security-reviewer`, tags `logic:` / `edge:` / `contract:` / `race:` / `silent:`, fenced shell, brand/tool names) byte-stable
- Align chat-language instruction with F7: skill body English; chat MAY remain pt-BR (do not hard-require Portuguese responses)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files .cursor/skills/correctness-review/SKILL.md,.claude/skills/correctness-review/SKILL.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `correctness-review` skill mirrors (`.cursor` + `.claude`) MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; G-MIRROR content equivalence required.

## Impact

- Files modified: the two skill mirror paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; skill paths not owned by active kit/infra translate changes)
- Risks: G-PT false positives; G-INV if `/opsx:*` or tag names rewritten; mirror drift (G-MIRROR); accidental semantic drift vs `sdd-correctness-review` (language only)
- **Non-goals:** other skills (`openspec-*`, `simplify-review`, gitnexus); commands; canonical guide; kit templates; hub `openspec/infra.md` (owned by `translate-infra-wave-1`); evaluations; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing when-to-invoke thresholds or tag semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files .cursor/skills/correctness-review/SKILL.md,.claude/skills/correctness-review/SKILL.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MIRROR**, **G-OPENSPEC**.  
N/A this wave: **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. invoke after Type B apply; one-finding-per-line format with tags; boundaries defer complexity/security to sibling skills).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, skill directory names, finding tags (`logic:` …), brand/tool names untouched
- [ ] YAML frontmatter keys (`name`, `description`, `license`, `metadata`) structure preserved; translate `description` string values to English
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected)
- [ ] No dual-file EN/PT siblings introduced
- [ ] `.cursor` and `.claude` mirrors updated together and remain content-equivalent

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-skills-wave-1

Change: openspec/changes/translate-skills-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files .cursor/skills/correctness-review/SKILL.md,.claude/skills/correctness-review/SKILL.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
