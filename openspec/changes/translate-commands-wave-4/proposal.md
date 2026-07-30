**Issue:** —

## Why

`translate-commands-wave-1` (open DRAFT PR #93) owns the `opsx-apply` command pair plus the G-MIRROR peer-map fix; `translate-commands-wave-2` (open DRAFT PR #96) owns `opsx-archive`; `translate-commands-wave-3` (open DRAFT PR #97) owns `opsx-propose` **commands**. The next completable residual on the WRu commands track is the `opsx-explore` pair (~189 LOC × Cursor + Claude mirrors). Residual Portuguese remains in Session Handoff stubs (`Esta fase terminou…`, `Cole no primeiro…`, `Ler:`, `notas de exploração`, `assumir ✅ — não reinstalar`). This slice fits budgets (1 logical command × 2 mirrors; ≤350–400 LOC counting one logical body), is path-disjoint from open translate PRs and active translate-* ownership, and avoids mid-file guide G-PT.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `.cursor/commands/opsx-explore.md`
  - `.claude/commands/opsx/explore.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, fenced shell, brand/tool names, explore workflow semantics including research.md / Session Handoff to propose) byte-stable
- Preserve **platform-specific YAML frontmatter** differences between Cursor and Claude command files (do **not** require byte-identical content)
- Align Session Handoff / chat stubs with F7: command body English; chat MAY remain pt-BR (do not hard-require Portuguese responses)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-explore.md,.claude/commands/opsx/explore.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `opsx-explore` command mirror pair MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; platform-specific frontmatter MAY differ; G-MIRROR peer listing required (peer-map from `translate-commands-wave-1`).

## Impact

- Files modified: the two command paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: **soft** — apply SHOULD wait until `translate-commands-wave-1` apply has landed the asymmetric opsx G-MIRROR peer map in `scripts/verify-i18n-wave.sh` (otherwise G-MIRROR fails closed on these paths). Propose is disjoint and may proceed in parallel with open PRs #93 / #96 / #97.
- Risks: G-PT false positives; G-INV if `/opsx:*` rewritten; accidental semantic drift vs explore workflow (language only); apply before wave-1 peer-map lands; confusion with `openspec-explore` **skill** (already apply-complete via `translate-skills-wave-4`)
- **Non-goals:** `opsx-apply` (owned by commands-wave-1 / PR #93); `opsx-archive` (owned by commands-wave-2 / PR #96); `opsx-propose` commands (owned by commands-wave-3 / PR #97); skills (including `openspec-explore` skill mirrors — owned / apply-complete via `translate-skills-wave-4`); canonical guide; kit templates; hub `openspec/infra.md`; evaluations; design docs; course; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing explore workflow Steps/Output or research.md conventions — language only; re-editing `scripts/verify-i18n-wave.sh` in this wave

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-explore.md,.claude/commands/opsx/explore.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MIRROR** (peers listed; content `cmp` N/A for commands after wave-1 script fix), **G-OPENSPEC**.  
N/A this wave: **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. explore mode / research.md capture; Session Handoff to `/opsx:propose`; freeze-list and F7 chat-vs-artifact guidance).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, brand/tool names untouched
- [ ] Platform-specific YAML frontmatter keys/`name`/`id`/`tags` structure preserved per IDE; translate human-readable `description` values to English if residual PT
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Both Cursor and Claude sides of `opsx-explore` updated in the same apply

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-commands-wave-4

Change: openspec/changes/translate-commands-wave-4/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Prerequisite: prefer translate-commands-wave-1 apply complete (G-MIRROR peer map in scripts/verify-i18n-wave.sh)
Gate: bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-explore.md,.claude/commands/opsx/explore.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
