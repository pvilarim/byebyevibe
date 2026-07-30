**Issue:** —

## Why

Kit-scripts waves 1–4 (open PRs #122 / #123 / #124 / #125) own the `sdd-upgrade-diff.sh`, `verify-infra.sh`, `bootstrap-sdd.sh` hub+template pairs and `sdd-kit/upgrade.sh`. The next completable whole-file residual-PT kit-script slice that fits budgets and is disjoint from every primary owned path is `sdd-kit/install-ui-module.sh` alone (~302 LOC / 1 file) — the embedded UI Development Module block written into `openspec/infra.md` still uses Portuguese table headers and deny-listed `sessão` / `sob demanda` chrome. The identical template twin is deferred to a follow-up wave (combined ~604 LOC exceeds ≤350–400).

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `sdd-kit/install-ui-module.sh`
- Translate the embedded `openspec/infra.md` UI Development Module section strings (`Componente` / `Estado` / `Verificar com`, `sob demanda`, `na sessão`) to glossary-canonical English aligned with `translate-infra-wave-1` chrome (`Component` / `Status` / `Verify with`, on-demand / in-session wording)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files sdd-kit/install-ui-module.sh` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `sdd-kit/install-ui-module.sh` MUST be English after substitution (comments, operator-facing messages, and embedded infra UI-module table chrome); dual-file siblings forbidden; freeze-list tokens and install-ui-module control flow preserved; template twin `sdd-kit/templates/install-ui-module.sh` is out of this wave’s file list

## Impact

- Files modified: `sdd-kit/install-ui-module.sh` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none for propose (infra ✅ — `verify-i18n-wave.sh` already registered; path not primary-owned by active `translate-*` on base or open translate propose PRs #84 / #93–#125). Soft apply note: align embedded table headers with infra-wave-1 EN chrome (`Component` / `Status` / `Verify with`) so post-apply UI-module installs do not reintroduce Portuguese headers into `openspec/infra.md`
- Risks: G-PT false positives; temporary hub↔template drift until a follow-up wave translates `sdd-kit/templates/install-ui-module.sh`; accidental change to `--detect` / `--dry-run` / `--apply` / `--yes` / stack-detection behavior
- **Non-goals:** `sdd-kit/templates/install-ui-module.sh` (follow-up wave — combined hub+template ~604 LOC over budget); kit-scripts waves 1–4 paths; live `openspec/infra.md` body (owned by `translate-infra-wave-1`); `sdd-metrics.sh` hub+template (over budget); canonical guide; design `001` / aula-05 / over-budget research files; EN gate/glossary quote hits inside existing `translate-*/tasks.md|design.md|spec.md`; rewriting `openspec/changes/archive/`; dual-file `*.en.md` / `*-pt.md` / `*.en.sh`; global G-DoD; changing detect/apply/impeccable control flow — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files sdd-kit/install-ui-module.sh
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/` edits), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN script text (e.g. `--detect` inventory; `--dry-run` plans docs/infra updates; `--apply` installs design docs + updates infra UI section; `--yes` accepts Impeccable prompt path).

## Freeze / allowlist checklist

- [ ] Shell logic, exit codes, flags (`--detect` / `--dry-run` / `--apply` / `--yes` / `--repo`), design-doc file list, stack detection, and Impeccable install control flow byte-stable aside from string/comment language
- [ ] Paths (`sdd-kit/install-ui-module.sh`, `doc/design/002-ui-module-install.md`, `openspec/infra.md`, `openspec/project.md`), change-ids, `/opsx:*`, brand/tool names (Impeccable, Open Design, Pencil, Figma MCP, shadcn) untouched as identifiers
- [ ] Embedded infra UI-module table headers use the same EN forms as infra-wave-1 / kit infra template (`Component` / `Status` / `Verify with`)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / gate / wave / session already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Do not edit `sdd-kit/templates/install-ui-module.sh` or live `openspec/infra.md` in this apply

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-scripts-wave-5

Change: openspec/changes/translate-kit-scripts-wave-5/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files sdd-kit/install-ui-module.sh
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
