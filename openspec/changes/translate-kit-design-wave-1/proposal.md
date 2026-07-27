**Issue:** —

## Why

Hub design wave-1 owns `doc/design/002|003|004`. Those same three documents are mirrored under `sdd-kit/templates/doc/design/` (~385 LOC / 3 files) with residual Portuguese and were explicitly deferred as a checksum-aware later wave. This slice fits budgets, is path-disjoint from active `translate-*` ownership and open translate PRs (#78 kit rules apply; #84–#104 propose factory waves), and avoids mid-file guide G-PT.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `sdd-kit/templates/doc/design/002-ui-module-install.md`
  - `sdd-kit/templates/doc/design/003-ui-stack-adapters.md`
  - `sdd-kit/templates/doc/design/004-probity-module-install.md`
- After template edits: run `bash sdd-kit/gen-manifest-checksums.sh` so `sdd-kit/MANIFEST.yaml` `sha256:` fields match (G-MANIFEST)
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, script names `install-ui-module.sh` / `install-probity-module.sh`, package pins, URLs, brand/tool names, fenced shell, scenario labels `C1-UI` / `G2`) byte-stable
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed `sdd-kit/templates/doc/design/` module-install / adapter mirrors MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; MANIFEST checksums updated when templates change.

## Impact

- Files modified: the three kit design template paths above; `sdd-kit/MANIFEST.yaml` checksums (via `gen-manifest-checksums.sh`); optional: `doc/i18n/GLOSSARY.md` if new terms
- Dependencies: none for propose; apply should prefer hub `translate-design-wave-1` apply-complete when aligning wording, but paths are disjoint so language substitution may proceed independently
- Risks: G-PT false positives on allowlisted tokens; G-INV if script paths/`/opsx:*`/pins are rewritten; G-MANIFEST / integrity failure if checksums skipped; accidental semantic drift of install steps (language only); concurrent kit-template apply with PR #78 (kit rules) — coordinate apply sessions per CURSOR-AUTOMATIONS §5
- **Non-goals:** hub `doc/design/002|003|004` (owned by `translate-design-wave-1`); hub/kit `000` and `001` design docs; kit Cursor rules templates (W2c/W2d); canonical guide; skills/commands; hub `openspec/infra.md`; evaluations; course aulas; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install procedure semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN kit templates (e.g. run `install-ui-module.sh --detect` → `--apply`; opt-out adapter checklist without assuming shadcn; run `install-probity-module.sh --detect` → pilot before default activation).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, script names, package pins, URLs, brand/tool names, scenario labels `C1-UI` / `G2` untouched
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / gate / Session Handoff already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links among kit `doc/design/*` templates still resolve (G-LINK)
- [ ] `bash sdd-kit/gen-manifest-checksums.sh` run after template edits; `bash sdd-kit/verify.sh` integrity OK

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-design-wave-1

Change: openspec/changes/translate-kit-design-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
