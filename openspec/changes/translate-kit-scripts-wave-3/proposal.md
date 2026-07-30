**Issue:** —

## Why

Kit-scripts waves 1–2 (open PRs #122 / #123) own the `sdd-upgrade-diff.sh` and `verify-infra.sh` hub+template pairs. The next completable whole-file residual-PT kit-script slice that fits budgets and is disjoint from every primary owned path is the bootstrap helper pair — hub `scripts/bootstrap-sdd.sh` plus kit template `sdd-kit/templates/scripts/bootstrap-sdd.sh` (~110 LOC total, 2 files) — whose comments and operator-facing `echo` / stderr strings still fail G-PT / Slice DoD.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `scripts/bootstrap-sdd.sh`
  - `sdd-kit/templates/scripts/bootstrap-sdd.sh`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, profile names `APP` / `DOCS_SPECS` / `HYBRID`, package/tool names, fenced/shell identifiers, variable names such as `REPO` / `PROFILE`) byte-stable aside from intentional non-i18n fixes
- Keep hub vs template **logic divergence** intact (template already emits the HYBRID coexistence stderr warning and defaults to `APP`; hub still uses the simpler package.json / `openspec/project.md` profile inference) — this wave is language-only, not a behavior sync
- Treat operator-facing bootstrap stderr (including the template HYBRID warning lines) as the runtime source-of-truth: translate those strings in the scripts; do **not** re-embed legacy Portuguese tokens into specs or docs in this wave
- After template edit: run `bash sdd-kit/gen-manifest-checksums.sh` so `sdd-kit/MANIFEST.yaml` `sha256:` for this template stays honest (G-MANIFEST)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files scripts/bootstrap-sdd.sh,sdd-kit/templates/scripts/bootstrap-sdd.sh` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed bootstrap script paths MUST be English after substitution (comments + operator-facing messages); dual-file siblings forbidden; freeze-list tokens and per-file logic preserved; MANIFEST checksum regeneration required when the template is touched

## Impact

- Files modified: `scripts/bootstrap-sdd.sh`, `sdd-kit/templates/scripts/bootstrap-sdd.sh`, and `sdd-kit/MANIFEST.yaml` (checksums only after template prose change); optional: `doc/i18n/GLOSSARY.md` if new terms
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` / kit checksum scripts already registered; paths not primary-owned by active `translate-*` on base or open translate propose PRs #84 / #93–#123 — earlier Non-goals that freeze-referenced bootstrap did not list it under Files modified / `--files`)
- Risks: G-PT false positives; accidental logic sync between hub and template; G-MANIFEST if checksums skipped; operators or specs that historically quoted Portuguese HYBRID warning chrome (language only — script remains SoT)
- **Non-goals:** `sdd-kit/upgrade.sh` (contract-adjacent approval checkbox strings; separate wave); `install-ui-module.sh` hub+template (~604 LOC combined — over budget); `sdd-metrics.sh` hub+template (~467 LOC each — over budget / weak deny-list today); `sdd-upgrade-diff.sh` / `verify-infra.sh` (owned by kit-scripts waves 1–2); canonical guide; design `001` / aula-05 / explore-adversarial `research.md` / discovery `research.md` (over whole-file G-PT budget); EN gate/glossary quote hits inside existing `translate-*/tasks.md|design.md|spec.md`; rewriting `openspec/changes/archive/`; dual-file `*.en.md` / `*-pt.md`; global G-DoD; unifying hub↔template profile-detection behavior — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files scripts/bootstrap-sdd.sh,sdd-kit/templates/scripts/bootstrap-sdd.sh
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN script text (e.g. OpenSpec init; optional GitNexus failure continues bootstrap; profile selection + `sdd-kit/install.sh` invocation).

## Freeze / allowlist checklist

- [ ] Shell logic, exit codes, and identifier names (`REPO`, `PROFILE`, profile enums) byte-stable aside from string/comment language
- [ ] Paths (`scripts/bootstrap-sdd.sh`, `sdd-kit/templates/scripts/bootstrap-sdd.sh`, `sdd-kit/install.sh`, `sdd-kit/MANIFEST.yaml`, `openspec/project.md`, `doc/sistema-sdd-pedro.md`), change-ids, `/opsx:*`, brand/tool names untouched as identifiers
- [ ] Hub and template keep their current structural/logic differences (no drive-by port of HYBRID warning / coexistence detection into hub in this wave)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / gate / wave / bootstrap already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] `bash sdd-kit/gen-manifest-checksums.sh` run after template edit; `bash sdd-kit/verify.sh` / G-MANIFEST green

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-scripts-wave-3

Change: openspec/changes/translate-kit-scripts-wave-3/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files scripts/bootstrap-sdd.sh,sdd-kit/templates/scripts/bootstrap-sdd.sh
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
