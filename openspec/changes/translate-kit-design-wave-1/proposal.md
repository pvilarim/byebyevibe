**Issue:** —

## Why

Hub design wave-1 owns `doc/design/002|003|004` (propose merged or in-flight). Consumer installs still receive Portuguese from the matching kit mirrors under `sdd-kit/templates/doc/design/` (~385 LOC, 3 files). This checksum-aware kit-design slice was an explicit non-goal of `translate-design-wave-1` and is the next completable whole-file residual within wave budgets, disjoint from owned hub/kit-rules/specs/curso/commands paths and open translate PRs.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `sdd-kit/templates/doc/design/002-ui-module-install.md`
  - `sdd-kit/templates/doc/design/003-ui-stack-adapters.md`
  - `sdd-kit/templates/doc/design/004-probity-module-install.md`
- After template edits: run `bash sdd-kit/gen-manifest-checksums.sh` so `sdd-kit/MANIFEST.yaml` `sha256:` fields match (G-MANIFEST)
- Align wording with hub `doc/design/{002,003,004}` English when hub apply has landed; if hub EN is not yet on the apply base, translate from the kit PT AS-IS using glossary-canonical English and the hub propose/design intent (procedure parity)
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, script names `install-ui-module.sh` / `install-probity-module.sh`, package pins, URLs, brand/tool names, fenced shell, scenario labels `C1-UI` / `G2`, MANIFEST keys) byte-stable
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed kit `sdd-kit/templates/doc/design/` module-install / adapter surfaces MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; G-MANIFEST satisfied when templates change.

## Impact

- Files modified: the three kit design template paths above; `sdd-kit/MANIFEST.yaml` checksums only (mechanical); optional `doc/i18n/GLOSSARY.md` if new terms
- Dependencies: soft apply preference — prefer hub `translate-design-wave-1` apply-complete (or archived) so kit mirrors can copy hub EN; propose itself has no hard blocker. Infra ✅ — `verify-i18n-wave.sh`, `gen-manifest-checksums.sh`, `sdd-kit/verify.sh` already registered
- Risks: G-PT false positives; G-INV if script paths/`/opsx:*`/pins rewritten; stale checksums if G-MANIFEST skipped; concurrent kit-template apply collision with PR #78 (W2c/W2d kit rules) — serialize kit-template **applies**; accidental semantic drift of install steps (language only)
- **Non-goals:** hub `doc/design/002|003|004` (owned by `translate-design-wave-1`); kit `000` / `001` design templates (`000` ~310 later wave; `001` ~592 over budget — split later); canonical guide; skills/commands; kit Cursor rules (W2c/W2d); hub `openspec/infra.md`; evaluations; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install procedure semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN kit text (e.g. run `install-ui-module.sh --detect` → `--apply`; opt-out adapter checklist without assuming shadcn; run `install-probity-module.sh --detect` → pilot before default activation).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, script names, package pins, URLs, brand/tool names, scenario labels `C1-UI` / `G2`, MANIFEST keys untouched
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / gate / Session Handoff already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] `bash sdd-kit/gen-manifest-checksums.sh` after template edits; `bash sdd-kit/verify.sh` green
- [ ] Relative links among kit `doc/design/*` templates still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-design-wave-1

Change: openspec/changes/translate-kit-design-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md
Soft prerequisite: prefer translate-design-wave-1 apply-complete before this apply (hub EN source); serialize vs other sdd-kit/templates applies (e.g. PR #78)
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
