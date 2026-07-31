**Issue:** —

## Why

Kit-scripts wave-5 (open DRAFT PR #126) owns hub `sdd-kit/install-ui-module.sh` and explicitly deferred the MANIFEST `source:` twin `sdd-kit/templates/install-ui-module.sh` because combined hub+template (~604 LOC) exceeds ≤350–400. That twin remains byte-identical today with residual Portuguese embedded UI Development Module chrome (`Componente` / `Estado` / `Verificar com`, `sob demanda`, deny-listed `sessão`). This wave owns the template path alone (~302 LOC / 1 file) so consumer installs via MANIFEST stay English after apply, with G-MANIFEST checksum refresh in the same apply.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `sdd-kit/templates/install-ui-module.sh`
- Translate the embedded `openspec/infra.md` UI Development Module section strings (`Componente` / `Estado` / `Verificar com`, `sob demanda`, `na sessão`) to glossary-canonical English aligned with `translate-infra-wave-1` and kit-scripts wave-5 hub chrome (`Component` / `Status` / `Verify with`, on-demand / in-session wording)
- After template edit: run `bash sdd-kit/gen-manifest-checksums.sh` so `sdd-kit/MANIFEST.yaml` `sha256:` for this `source:` stays valid
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/install-ui-module.sh` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `sdd-kit/templates/install-ui-module.sh` MUST be English after substitution (comments, operator-facing messages, and embedded infra UI-module table chrome); dual-file siblings forbidden; freeze-list tokens and install-ui-module control flow preserved; G-MANIFEST checksums MUST be refreshed when this template is edited; hub path `sdd-kit/install-ui-module.sh` is out of this wave’s file list (owned by kit-scripts wave-5)

## Impact

- Files modified: `sdd-kit/templates/install-ui-module.sh`; `sdd-kit/MANIFEST.yaml` (`sha256:` for this source — via `gen-manifest-checksums.sh`); optional: `doc/i18n/GLOSSARY.md` if new terms
- Dependencies: none for propose (infra ✅ — `verify-i18n-wave.sh` / kit verify already registered). Soft apply note: align embedded table headers with infra-wave-1 / kit-scripts wave-5 EN chrome (`Component` / `Status` / `Verify with`) so MANIFEST-sourced installs do not reintroduce Portuguese headers into consumer `openspec/infra.md`
- Risks: G-PT false positives; temporary hub↔template drift until wave-5 apply lands (or vice versa); accidental change to `--detect` / `--dry-run` / `--apply` / `--yes` / stack-detection behavior; G-MANIFEST failure if checksums not regenerated
- **Non-goals:** `sdd-kit/install-ui-module.sh` (primary owned by kit-scripts wave-5 / PR #126); kit-scripts waves 1–4 paths; live `openspec/infra.md` body (owned by `translate-infra-wave-1`); `sdd-metrics.sh` hub+template (over budget); canonical guide; design `001` / aula-05 / over-budget research files; EN gate/glossary quote hits inside existing `translate-*/tasks.md|design.md|spec.md`; rewriting `openspec/changes/archive/`; dual-file `*.en.md` / `*-pt.md` / `*.en.sh`; global G-DoD; changing detect/apply/impeccable control flow — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/install-ui-module.sh
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN template text (e.g. `--detect` inventory; `--dry-run` plans docs/infra updates; `--apply` installs design docs + updates infra UI section; `--yes` accepts Impeccable prompt path).

## Freeze / allowlist checklist

- [ ] Shell logic, exit codes, flags (`--detect` / `--dry-run` / `--apply` / `--yes` / `--repo`), design-doc file list, stack detection, and Impeccable install control flow byte-stable aside from string/comment language
- [ ] Paths (`sdd-kit/templates/install-ui-module.sh`, `sdd-kit/install-ui-module.sh`, `doc/design/002-ui-module-install.md`, `openspec/infra.md`, `openspec/project.md`), change-ids, `/opsx:*`, brand/tool names (Impeccable, Open Design, Pencil, Figma MCP, shadcn) untouched as identifiers
- [ ] Embedded infra UI-module table headers use the same EN forms as infra-wave-1 / kit-scripts wave-5 (`Component` / `Status` / `Verify with`)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / gate / wave / session already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Do not edit hub `sdd-kit/install-ui-module.sh` or live `openspec/infra.md` in this apply
- [ ] After template edit: `bash sdd-kit/gen-manifest-checksums.sh` before commit/gate

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-scripts-wave-6

Change: openspec/changes/translate-kit-scripts-wave-6/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/install-ui-module.sh
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
