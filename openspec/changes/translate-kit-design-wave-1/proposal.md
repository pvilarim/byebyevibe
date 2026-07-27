**Issue:** —

## Why

Hub `translate-design-wave-1` owns `doc/design/002|003|004` and explicitly deferred the install-kit mirrors under `sdd-kit/templates/doc/design/` to a checksum-aware later wave. Those three kit payloads (~385 LOC, 3 files) remain Portuguese on the consumer install path and are path-disjoint from active `translate-*` ownership and open translate propose PRs (#84, #93–#104). This slice finishes that deferred kit design mirror cluster within budgets and avoids mid-file guide G-PT.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `sdd-kit/templates/doc/design/002-ui-module-install.md`
  - `sdd-kit/templates/doc/design/003-ui-stack-adapters.md`
  - `sdd-kit/templates/doc/design/004-probity-module-install.md`
- Prefer aligning kit mirror wording with hub `doc/design/002|003|004` English after `translate-design-wave-1` apply (soft apply prerequisite); if hub apply is still pending, translate kit mirrors from AS-IS Portuguese with the same glossary mapping
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, script names `install-ui-module.sh` / `install-probity-module.sh`, package pins, URLs, brand/tool names, fenced shell, scenario labels `C1-UI` / `G2`) byte-stable
- After template edits: `bash sdd-kit/gen-manifest-checksums.sh` so `MANIFEST.yaml` `sha256:` fields match (G-MANIFEST)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — kit design module-install / adapter mirrors (`sdd-kit/templates/doc/design/002-ui-module-install.md`, `003-ui-stack-adapters.md`, `004-probity-module-install.md`) MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; G-MANIFEST satisfied when templates change.

## Impact

- Files modified: the three kit design template paths above; `sdd-kit/MANIFEST.yaml` checksums only (mechanical); optional `doc/i18n/GLOSSARY.md` if new terms
- Dependencies: soft — prefer `translate-design-wave-1` apply-complete before this apply so kit mirrors match hub EN; propose is disjoint and does not wait on merge. Infra ✅ — `verify-i18n-wave.sh`, `gen-manifest-checksums.sh`, `sdd-kit/verify.sh` already registered. Paths not owned by active `translate-*` changes or open translate PRs #84 / #93–#104. Serialize kit-template **apply** vs other in-flight kit applies that touch `MANIFEST.yaml` (e.g. PR #78)
- Risks: G-PT false positives; G-INV if script paths/`/opsx:*`/pins rewritten; stale checksums if G-MANIFEST skipped; hub/kit drift if applied before hub design-wave-1 EN lands; MANIFEST write conflicts with concurrent kit applies
- **Non-goals:** hub `doc/design/002|003|004` (owned by `translate-design-wave-1`); kit `sdd-kit/templates/doc/design/000-*` and `001-*` (later waves; `001` over LOC); canonical guide; skills/commands; kit Cursor rules / proposal scaffold (W2c/W2d); hub `openspec/infra.md`; evaluations; curso; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install procedure semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN kit payloads (e.g. run `install-ui-module.sh --detect` → `--apply`; adapter opt-out checklist without assuming shadcn; run `install-probity-module.sh --detect` → pilot before default activation).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, script names, package pins, URLs, brand/tool names, scenario labels `C1-UI` / `G2` untouched
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / gate / Session Handoff already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links among design docs still resolve (G-LINK)
- [ ] `bash sdd-kit/gen-manifest-checksums.sh` run after template edits; `bash sdd-kit/verify.sh` green

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-design-wave-1

Change: openspec/changes/translate-kit-design-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
Soft prereq: prefer translate-design-wave-1 apply-complete; serialize MANIFEST vs other kit applies
```
