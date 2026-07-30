**Issue:** —

## Why

WSk skills waves 1–5 proposed the review and opsx skill mirrors; open DRAFT PR #91 still owns `openspec-propose`. The next completable residual on the WRu track is the opsx **command** mirrors: Cursor `.cursor/commands/opsx-*.md` paired with Claude `.claude/commands/opsx/*.md`. Residual Portuguese remains in Session Handoff stubs and R11 coordination prose (densest in `opsx-apply`). This slice takes the `opsx-apply` pair (2 files) plus a minimal `scripts/verify-i18n-wave.sh` G-MIRROR peer-map fix so asymmetric command paths can pass gates (3 files total; ≤350–400 LOC). Canonical guide section waves remain blocked for mid-file G-PT.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `.cursor/commands/opsx-apply.md`
  - `.claude/commands/opsx/apply.md`
- Update `scripts/verify-i18n-wave.sh` `mirror_peer` so `.cursor/commands/opsx-<verb>.md` maps to `.claude/commands/opsx/<verb>.md` (and reverse); for command pairs, G-MIRROR MUST require both peers in `--files` but MUST NOT require byte-identical content (platform-specific YAML frontmatter differs by design — warn or skip `cmp`, still fail if peer missing/unlisted)
- Preserve freeze-list tokens (paths, change-ids, `/opsx:apply` / `/opsx:archive` / `/opsx:propose` / `/opsx:explore`, fenced shell, R11 script names, brand/tool names) byte-stable
- Preserve **platform-specific YAML frontmatter** differences between Cursor and Claude command files
- Align Session Handoff / chat stubs with F7: command body English; chat MAY remain pt-BR (do not hard-require Portuguese responses)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-apply.md,.claude/commands/opsx/apply.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `opsx-apply` command mirror pair MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; platform-specific frontmatter MAY differ; G-MIRROR peer mapping MUST understand asymmetric opsx command paths.

## Impact

- Files modified: the two command paths above + `scripts/verify-i18n-wave.sh` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; command paths not owned by active translate-* changes or open translate PRs #78 / #84 / #91)
- Risks: G-PT false positives; G-INV if `/opsx:*` rewritten; accidental semantic drift vs R11 lock/release (language only); over-broad script change affecting skill mirrors (must keep skill `cmp -s` behavior unchanged)
- **Non-goals:** `opsx-archive` / `opsx-propose` / `opsx-explore` command pairs (later commands waves); skills (already proposed / owned); canonical guide; kit templates; hub `openspec/infra.md`; evaluations; design docs; course; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing R11 flock semantics beyond language — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-apply.md,.claude/commands/opsx/apply.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MIRROR** (peers listed; content `cmp` N/A for commands after script fix), **G-OPENSPEC**.  
N/A this wave: **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. apply with R11 register/check/release; Session Handoff stubs; simplify-review optional suggestion).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, R11 script names, brand/tool names untouched
- [ ] Platform-specific YAML frontmatter keys/`name`/`id`/`tags` structure preserved per IDE; translate human-readable `description` values to English if residual PT
- [ ] Skill mirror G-MIRROR behavior (`cmp -s`) unchanged
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Both Cursor and Claude sides of `opsx-apply` updated in the same apply

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-commands-wave-1

Change: openspec/changes/translate-commands-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-apply.md,.claude/commands/opsx/apply.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
