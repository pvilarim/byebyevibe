**Issue:** —

## Why

`translate-kit-design-wave-1` (remote factory branches, no open PR required for ownership) owns kit mirrors `sdd-kit/templates/doc/design/002|003|004` and defers kit `000` / `001`. Hub `translate-design-wave-2` owns hub `doc/design/000-impeccable-design-system-guia.md`. The next completable whole-file residual on the kit design track is the Impeccable reference guide payload `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md` (~310 LOC / 1 file): within budgets, path-disjoint from active `translate-*` ownership and open translate PRs, and avoidable of mid-file guide G-PT. Kit `001` (~592 LOC) stays deferred for a later split. (`translate-specs-wave-2` is already multiply claimed on other factory branches — skipped.)

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`
- Prefer aligning kit mirror wording with hub `doc/design/000-impeccable-design-system-guia.md` English after `translate-design-wave-2` apply (soft apply prerequisite); if hub apply is still pending, translate the kit mirror from AS-IS Portuguese with the same glossary mapping
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, URLs, brand/tool names including Impeccable / shadcn / ByeByeVibe / Open Design / Pencil / Figma, fenced shell, status marker `[REFERÊNCIA — REQUER ADAPTAÇÃO]` → English equivalent label only if G-PT requires, profile label `DOCS_SPECS`, applicability marker `[se aplicável]` → `[if applicable]`) while keeping reference/adaptation semantics intact
- After template edit: `bash sdd-kit/gen-manifest-checksums.sh` so `MANIFEST.yaml` `sha256:` fields match (G-MANIFEST)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — kit Impeccable design reference mirror (`sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`) MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; G-MANIFEST satisfied when templates change.

## Impact

- Files modified: `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`; `sdd-kit/MANIFEST.yaml` checksums only (mechanical); optional `doc/i18n/GLOSSARY.md` if new terms
- Dependencies: soft — prefer `translate-design-wave-2` apply-complete before this apply so kit mirror matches hub EN; propose is disjoint and does not wait on merge. Paths not owned by open translate PRs #78 / #84 / #93–#104 or remote `translate-kit-design-wave-1` / `translate-specs-wave-2` claims. Serialize kit-template **apply** vs other in-flight kit applies that touch `MANIFEST.yaml`
- Risks: G-PT false positives on allowlisted tokens / path segments; G-INV if script paths/`/opsx:*`/pins are rewritten; stale checksums if G-MANIFEST skipped; hub/kit drift if applied before hub design-wave-2 EN lands; MANIFEST write conflicts with concurrent kit applies
- **Non-goals:** hub `doc/design/000-*` (owned by `translate-design-wave-2`); kit/hub `001-*` (over LOC — split later); kit `002|003|004` (owned by `translate-kit-design-wave-1`); canonical guide; skills/commands; kit Cursor rules / proposal scaffold (W2c/W2d); hub `openspec/infra.md`; evaluations; curso; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing Impeccable adoption recommendations — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md
bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. distinguish Impeccable vs inventing a design system; apply `[if applicable]` markers correctly for DOCS_SPECS hub vs APP target; follow future pipeline integration pointer to guide / kit without installing Impeccable on this hub).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, package pins, URLs, brand/tool names, profile `DOCS_SPECS`, relative links to `001`/`002`/`003`/`doc/sistema-sdd-pedro.md` untouched as path strings
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — design system / install kit / canonical / Session Handoff already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] MANIFEST checksums regenerated after template edit (G-MANIFEST)
- [ ] Status / applicability markers translated only as needed for G-PT (`[REFERÊNCIA — REQUER ADAPTAÇÃO]`, `[se aplicável]`) without changing meaning

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-design-wave-2

Change: openspec/changes/translate-kit-design-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
Note: after template edit run bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh
```
