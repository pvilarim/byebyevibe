**Issue:** —

## Why

W1c (`translate-agents-rules-wave-1c`) finished the hub agents/rules PT→EN track (merged). Consumer installs still receive Portuguese from `sdd-kit/templates/AGENTS.*` and mixed PT in `sdd-kit/README.md` — the next inventory slice (W2). Full kit surface exceeds the ≤4-file budget, so this change takes README + AGENTS templates only; CLAUDE/infra kit copies defer to `translate-kit-wave-2b`.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `sdd-kit/README.md`
  - `sdd-kit/templates/AGENTS.core.md`
  - `sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md`
  - `sdd-kit/templates/AGENTS.commands.APP.md`
- Preserve freeze-list tokens (paths, HTML `SDD_KIT_COMMANDS_*` markers, profile codes `APP`/`DOCS_SPECS`/`HYBRID`, scenario codes `C1`/`C2`/`C2b`/`C3`/`C1-UI`/`G2`/`G4`, shell fences, pins, brand names) byte-stable
- Translate `[PREENCHER:…]` install placeholders to English `[FILL:…]` (or equivalent glossary-stable filler) without breaking `install.sh` marker injection
- After template edits: `bash sdd-kit/gen-manifest-checksums.sh` so `MANIFEST.yaml` `sha256:` fields match (G-MANIFEST)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files sdd-kit/README.md,sdd-kit/templates/AGENTS.core.md,sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md,sdd-kit/templates/AGENTS.commands.APP.md` before marking tasks done
- **Budget split:** `sdd-kit/templates/CLAUDE.md` + `sdd-kit/templates/openspec/infra.md` (+ later kit rule copies) → deferred to `translate-kit-wave-2b`

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — W2 kit README + AGENTS.* install templates MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens and command-injection markers preserved; G-MANIFEST satisfied when templates change.

## Impact

- Files modified: the four paths above; `sdd-kit/MANIFEST.yaml` checksums only (mechanical); optional `doc/i18n/GLOSSARY.md` if new terms
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh`, `gen-manifest-checksums.sh`, `sdd-kit/verify.sh` already registered; W1c apply-complete / merged on master)
- Risks: G-PT false positives; G-INV if markers/fences rewritten; broken `install.sh` AGENTS commands injection if markers move; stale checksums if G-MANIFEST skipped; hub `AGENTS.md` already EN while template diverges until apply
- **Non-goals:** kit `CLAUDE.md` / `openspec/infra.md` templates; kit `.cursor/rules/` copies; `_template/proposal.md`; hub live `AGENTS.md`/`CLAUDE.md` (already W1); guide; skills; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; semantic changes to install behavior — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files sdd-kit/README.md,sdd-kit/templates/AGENTS.core.md,sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md,sdd-kit/templates/AGENTS.commands.APP.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (no `.cursor`/`.claude` skill pair in scope), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. C1 `install.sh --profile`, C2 `upgrade.sh --dry-run`, `verify.sh` / commands table meaning).

## Freeze / allowlist checklist

- [x] Shell/CI fences byte-stable (except intentional non-i18n fixes)
- [x] Paths, change-ids, `/opsx:*`, pins, brand names untouched
- [x] `<!-- SDD_KIT_COMMANDS_START -->` / `<!-- SDD_KIT_COMMANDS_END -->` markers byte-stable and still wrapping the commands slot
- [x] Glossary forms used; new terms added to `GLOSSARY.md`
- [x] No dual-file EN/PT siblings introduced
- [x] `bash sdd-kit/gen-manifest-checksums.sh` run after template edits; `bash sdd-kit/verify.sh` green

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-wave-2

Change: openspec/changes/translate-kit-wave-2/
Ler: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md
Gate: bash scripts/verify-i18n-wave.sh --files sdd-kit/README.md,sdd-kit/templates/AGENTS.core.md,sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md,sdd-kit/templates/AGENTS.commands.APP.md
Infra: openspec/infra.md (assumir ✅ — não reinstalar)
```
