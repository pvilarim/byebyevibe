**Issue:** —

## Why

WAv waves own `doc/avaliacoes/` (wave-1 on base; wave-2 propose PR #84). The next high-value completable whole-file residual on the design track is the three module-install / adapter docs (~385 LOC, 3 files): C1-UI install, UI stack adapters, and Probity G2 install. This slice fits budgets, is disjoint from kit/infra/skills/avaliacoes ownership and open translate PRs, and avoids mid-file guide G-PT. Larger design docs `000` (~310) and `001` (~592 — over budget) are deferred to later waves.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `doc/design/002-ui-module-install.md`
  - `doc/design/003-ui-stack-adapters.md`
  - `doc/design/004-probity-module-install.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, script names `install-ui-module.sh` / `install-probity-module.sh`, package pins, URLs, brand/tool names, fenced shell, scenario labels `C1-UI` / `G2`) byte-stable
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files doc/design/002-ui-module-install.md,doc/design/003-ui-stack-adapters.md,doc/design/004-probity-module-install.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed `doc/design/` module-install / adapter surfaces MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved.

## Impact

- Files modified: the three design paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; paths not owned by active `translate-*` changes or open translate PRs #78 / #84)
- Risks: G-PT false positives on allowlisted tokens; G-INV if script paths/`/opsx:*`/pins are rewritten; accidental semantic drift of install steps (language only)
- **Non-goals:** `doc/design/000-impeccable-design-system-guia.md`; `doc/design/001-pipeline-open-design-shadcn-impeccable.md` (over LOC — split later); `sdd-kit/templates/doc/design/` mirrors (checksum-aware later wave); canonical guide; skills/commands; kit rules templates; hub `openspec/infra.md`; evaluations; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install procedure semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files doc/design/002-ui-module-install.md,doc/design/003-ui-stack-adapters.md,doc/design/004-probity-module-install.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. run `install-ui-module.sh --detect` → `--apply`; opt-out adapter checklist without assuming shadcn; run `install-probity-module.sh --detect` → pilot before default activation).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, script names, package pins, URLs, brand/tool names, scenario labels `C1-UI` / `G2` untouched
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / gate / Session Handoff already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links among `doc/design/*` and to guide/evaluations still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-design-wave-1

Change: openspec/changes/translate-design-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files doc/design/002-ui-module-install.md,doc/design/003-ui-stack-adapters.md,doc/design/004-probity-module-install.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
