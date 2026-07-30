**Issue:** —

## Why

WSk waves 1–2 proposed the review skills (`correctness-review`, `simplify-review`). Remaining opsx skills are mostly English with Session Handoff stubs, and `openspec-apply-change` / `openspec-explore` exceed the ≤350–400 LOC skill×2 budget. The next high-value completable whole-file residual is the WAv track: evaluation index + template + two compact evaluation records (~233 LOC, 4 files). This slice fits budgets, is disjoint from in-flight kit/infra/skills ownership, and avoids mid-file guide G-PT.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `doc/avaliacoes/README.md`
  - `doc/avaliacoes/TEMPLATE.md`
  - `doc/avaliacoes/2026-03-26-headroom-context-compression.md`
  - `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
- Keep decision statuses as glossary-aligned English labels (`Adopted` / `Discarded` / `Deferred` / `Under evaluation`) without changing historical decision outcomes
- Preserve freeze-list tokens (paths including `doc/avaliacoes/`, change-ids, `/opsx:*`, package pins, URLs, brand/tool names, fenced shell) byte-stable
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/README.md,doc/avaliacoes/TEMPLATE.md,doc/avaliacoes/2026-03-26-headroom-context-compression.md,doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed `doc/avaliacoes/` evaluation surfaces MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens (including the `doc/avaliacoes/` path segment until a rename wave) preserved.

## Impact

- Files modified: the four evaluation paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; paths not owned by active `translate-*` changes or open translate PRs)
- Risks: G-PT false positives on status vocabulary / proper nouns; G-INV if change-ids or paths rewritten; accidental semantic drift of Discarded/Deferred decisions (language only)
- **Non-goals:** other `doc/avaliacoes/*` files (e.g. discovery-positioning, UI-module evaluation); `doc/design/`; canonical guide; skills/commands; kit templates; hub `openspec/infra.md`; dual-file `*.en.md` / `*-pt.md`; global G-DoD; renaming `doc/avaliacoes/` → `doc/evaluations/`; changing Adopted/Discarded outcomes — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/README.md,doc/avaliacoes/TEMPLATE.md,doc/avaliacoes/2026-03-26-headroom-context-compression.md,doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. copy TEMPLATE for a new evaluation; read README index before proposing tool installs; honor Headroom **Discarded** without reinstall).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (including `doc/avaliacoes/`), change-ids, `/opsx:*`, package pins, URLs, brand/tool names untouched
- [ ] Historical decision outcomes unchanged (only label language / surrounding prose)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — evaluation/Discarded/Deferred already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links in README/TEMPLATE/records still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-avaliacoes-wave-1

Change: openspec/changes/translate-avaliacoes-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/README.md,doc/avaliacoes/TEMPLATE.md,doc/avaliacoes/2026-03-26-headroom-context-compression.md,doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
