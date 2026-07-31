**Issue:** —

## Why

WAv wave-1 proposed the evaluations index/template plus Headroom and OSS-gaps records. Two residual whole-file evaluation records remain: discovery/positioning (~214 LOC) and the UI-module evaluation (~76 LOC). Together they are ~290 LOC / 2 files — within budgets, disjoint from wave-1 and other in-flight translate ownership, and completable under whole-file G-PT (unlike the canonical guide).

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`
  - `doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`
- Keep decision statuses as glossary-aligned English labels (`Adopted` / `Discarded` / `Deferred` / `Under evaluation` / `Do not implement`) without changing historical decision outcomes
- Preserve freeze-list tokens (paths including `doc/avaliacoes/`, change-ids, `/opsx:*`, package pins, URLs, brand/tool names including ByeByeVibe, fenced shell, `[AÇÃO MANUAL]` → `[MANUAL ACTION]` only as the EN operator cue already used elsewhere — keep meaning) byte-stable for invariants
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md,doc/avaliacoes/2026-06-27-sdd-ui-development-module.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed `doc/avaliacoes/` evaluation records MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens (including the `doc/avaliacoes/` path segment until a rename wave) preserved.

## Impact

- Files modified: the two evaluation paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none blocking propose (wave-1 owns different paths; apply of wave-1 may still be open — path sets are disjoint). Infra ✅ — `verify-i18n-wave.sh` already registered
- Risks: G-PT false positives on path `avaliacoes` / brand names; G-INV if change-ids or paths rewritten; accidental semantic drift of Adopted / Deferred / Do-not-implement rows (language only)
- **Non-goals:** wave-1 files (`README`, `TEMPLATE`, Headroom, OSS gaps); `doc/design/`; canonical guide; skills/commands; kit templates; hub `openspec/infra.md`; dual-file `*.en.md` / `*-pt.md`; global G-DoD; renaming `doc/avaliacoes/` → `doc/evaluations/`; changing product decisions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md,doc/avaliacoes/2026-06-27-sdd-ui-development-module.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. honor ByeByeVibe / P1–P4 Adopted surfaces; keep GitHub slug rename as manual operator action; treat UI-module as Adopted add-on with Impeccable `--yes` confirmation).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (including `doc/avaliacoes/`), change-ids, `/opsx:*`, package pins, URLs, brand/tool names untouched
- [ ] Historical decision outcomes unchanged (only label language / surrounding prose)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links in both records still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-avaliacoes-wave-2

Change: openspec/changes/translate-avaliacoes-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md,doc/avaliacoes/2026-06-27-sdd-ui-development-module.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
