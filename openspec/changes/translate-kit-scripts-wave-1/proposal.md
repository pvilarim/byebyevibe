**Issue:** —

## Why

Open translate proposes already cover markdown kit design mirrors, hub rules/skills/commands, specs, curso aulas 01–04, and many active-change artifacts. The next completable whole-file residual-PT slice that fits budgets and is disjoint from every owned path is the C2 upgrade-diff helper pair — hub `scripts/sdd-upgrade-diff.sh` plus kit template `sdd-kit/templates/scripts/sdd-upgrade-diff.sh` (~287 LOC total, 2 files) — whose comments and operator-facing `echo` strings still fail G-PT.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `scripts/sdd-upgrade-diff.sh`
  - `sdd-kit/templates/scripts/sdd-upgrade-diff.sh`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, MANIFEST keys, merge labels, profile names, brand/tool names, fenced/shell identifiers, variable names such as `CURATED_FILES` / `CURATED_DESTS` / `CURATED_SOURCES` / `STAGING_DIR` / `GUIDE_VERSION`) byte-stable aside from intentional non-i18n fixes
- Keep hub vs template **logic divergence** intact (template already parses MANIFEST `source:`; hub still uses the older path-only parser) — this wave is language-only, not a behavior sync
- After template edit: run `bash sdd-kit/gen-manifest-checksums.sh` so `sdd-kit/MANIFEST.yaml` `sha256:` for this template stays honest (G-MANIFEST)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files scripts/sdd-upgrade-diff.sh,sdd-kit/templates/scripts/sdd-upgrade-diff.sh` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed upgrade-diff script paths MUST be English after substitution (comments + operator-facing messages); dual-file siblings forbidden; freeze-list tokens and per-file logic preserved; MANIFEST checksum regeneration required when the template is touched

## Impact

- Files modified: `scripts/sdd-upgrade-diff.sh`, `sdd-kit/templates/scripts/sdd-upgrade-diff.sh`, and `sdd-kit/MANIFEST.yaml` (checksums only after template prose change); optional: `doc/i18n/GLOSSARY.md` if new terms
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` / kit checksum scripts already registered; paths not owned by active `translate-*` on base or open translate propose PRs #84 / #93–#121)
- Risks: G-PT false positives; accidental logic sync between hub and template; G-MANIFEST if checksums skipped; operator-facing string changes that guide/docs quote historically (language only)
- **Non-goals:** `sdd-kit/upgrade.sh` / `bootstrap-sdd.sh` (owned or freeze-referenced by specs-wave-2 / related proposes); `install-ui-module.sh` hub+template pair (~604 LOC combined — over budget); `verify-infra.sh` (tied to hub `openspec/infra.md` Portuguese chrome owned by `translate-infra-wave-1`); canonical guide; design `001` / aula-05 / explore-adversarial `research.md` / discovery `research.md` (over whole-file G-PT budget); rewriting `openspec/changes/archive/`; dual-file `*.en.md` / `*-pt.md`; global G-DoD; unifying hub↔template parser behavior — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files scripts/sdd-upgrade-diff.sh,sdd-kit/templates/scripts/sdd-upgrade-diff.sh
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN script text (e.g. inventory-only run without `STAGING_DIR`; MANIFEST-present inventory listing; staged diff against templates).

## Freeze / allowlist checklist

- [ ] Shell logic, exit codes, and identifier names (`CURATED_*`, `STAGING_DIR`, `GUIDE_VERSION`, `MANIFEST`) byte-stable aside from string/comment language
- [ ] Paths (`scripts/sdd-upgrade-diff.sh`, `sdd-kit/templates/scripts/sdd-upgrade-diff.sh`, `sdd-kit/MANIFEST.yaml`, `openspec/project.md`, `doc/sistema-sdd-pedro.md`), change-ids, `/opsx:*`, merge labels, profiles untouched as identifiers
- [ ] Hub and template keep their current structural/logic differences (no drive-by port of `source:` parsing into hub in this wave)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — inventory / install kit / gate / wave already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] `bash sdd-kit/gen-manifest-checksums.sh` run after template edit; `bash sdd-kit/verify.sh` / G-MANIFEST green

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-scripts-wave-1

Change: openspec/changes/translate-kit-scripts-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files scripts/sdd-upgrade-diff.sh,sdd-kit/templates/scripts/sdd-upgrade-diff.sh
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
