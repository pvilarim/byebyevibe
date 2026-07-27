**Issue:** —

## Why

W2b migrated kit `openspec/infra.md` to English; hub live `openspec/infra.md` still mixes Portuguese table headers and R10 prose with English sections (Docs language / i18n). W2c/W2d explicitly deferred this residual as a non-goal. Closing it restores a fully English R10 manifesto (~139 LOC, 1 file) before guide/skills waves, within wave budgets.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/infra.md`
- Align wording with kit template `sdd-kit/templates/openspec/infra.md` (already EN after W2b) for shared labels (Component/Status/Verify with, `[MANUAL ACTION]`, Agent rule), while preserving hub-specific status values, skill rows, and verified ✅/❌ cells
- Preserve freeze-list tokens (paths, HTML `verify-infra.sh` markers, package pins, Action SHA, `/opsx:*`, brand/tool names, status glyphs ✅/❌) byte-stable
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/infra.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — hub `openspec/infra.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens (including `verify-infra.sh` HTML markers) preserved.

## Impact

- Files modified: `openspec/infra.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; kit `openspec/infra.md` EN via archived W2b; W2c/W2d do not own this path)
- Risks: G-PT false positives; G-INV if HTML markers/pins/SHA rewritten; accidental status-cell drift vs live verification markers
- **Non-goals:** kit templates (owned by W2c/W2d); canonical guide; skills; commands; evaluations; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; re-running `verify-infra.sh` to change ✅/❌ (language only); semantic changes to R10 — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/infra.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (single file, no skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from EN text (e.g. R10 read-before-install; `bash scripts/verify-infra.sh`; Session Coordination script checks).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, pins, Action SHA, brand/tool names untouched
- [ ] HTML comment markers for `verify-infra.sh` (`<!-- openspec-version -->`, `<!-- mcp-list -->`, `<!-- env-list -->`, kit status markers, etc.) tag-stable; translate marker **body** filler only when Portuguese
- [ ] Status glyphs ✅/❌ and `[NEEDS VERIFICATION]` / `[STALE >30d]` kept; `[AÇÃO MANUAL]` → `[MANUAL ACTION]` (kit EN pattern)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected)
- [ ] No dual-file EN/PT siblings introduced

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-infra-wave-1

Change: openspec/changes/translate-infra-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/infra.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
