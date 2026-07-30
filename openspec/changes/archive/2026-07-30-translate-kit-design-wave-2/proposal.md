**Issue:** —

## Why

Hub design wave-2 owns `doc/design/000-impeccable-design-system-guia.md` (propose merged; apply pending). Consumer installs still receive Portuguese from the matching kit mirror under `sdd-kit/templates/doc/design/` (~310 LOC, 1 file). Kit-design wave-1 (open DRAFT PR #106) owns kit `002|003|004` and explicitly deferred kit `000` as the next whole-file residual within budgets — disjoint from owned hub/kit-rules/specs/curso/commands paths and open translate PRs.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`
- After template edits: run `bash sdd-kit/gen-manifest-checksums.sh` so `sdd-kit/MANIFEST.yaml` `sha256:` fields match (G-MANIFEST)
- Align wording with hub `doc/design/000-impeccable-design-system-guia.md` English when hub apply has landed; if hub EN is not yet on the apply base, translate from the kit PT AS-IS using glossary-canonical English and the hub propose/design intent (reference/adaptation + DOCS_SPECS applicability parity)
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, URLs, brand/tool names including Impeccable / shadcn / ByeByeVibe, fenced shell, profile label `DOCS_SPECS`, MANIFEST keys) byte-stable; status marker `[REFERÊNCIA — REQUER ADAPTAÇÃO]` → English equivalent only if G-PT requires; applicability marker `[se aplicável]` → `[if applicable]`
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed kit Impeccable design-system reference template MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; G-MANIFEST satisfied when templates change.

## Impact

- Files modified: `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`; `sdd-kit/MANIFEST.yaml` checksums only (mechanical); optional `doc/i18n/GLOSSARY.md` if new terms
- Dependencies: soft apply preference — prefer hub `translate-design-wave-2` apply-complete (or archived) so the kit mirror can copy hub EN; propose itself has no hard blocker. Serialize vs other in-flight `sdd-kit/templates/` applies (e.g. kit-design-wave-1 PR #106 apply; W2c/W2d PR #78). Infra ✅ — `verify-i18n-wave.sh`, `gen-manifest-checksums.sh`, `sdd-kit/verify.sh` already registered
- Risks: G-PT false positives; G-INV if paths/`/opsx:*`/pins rewritten; stale checksums if G-MANIFEST skipped; concurrent kit-template apply collision — serialize kit-template **applies**; accidental semantic drift of reference/adaptation or DOCS_SPECS applicability notes (language only)
- **Non-goals:** hub `doc/design/000` (owned by `translate-design-wave-2`); kit `002|003|004` (owned by `translate-kit-design-wave-1` / PR #106); kit/hub `001` (~592 over budget — split later); canonical guide; skills/commands; kit Cursor rules (W2c/W2d); hub `openspec/infra.md`; evaluations; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing Impeccable adoption recommendations — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN kit text (e.g. keep shadcn as default Fase 2 path; respect DOCS_SPECS hub vs APP-target applicability; follow adopt checklist without installing Impeccable on this DOCS_SPECS hub).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids, `/opsx:*`, package pins, URLs, brand/tool names, profile `DOCS_SPECS`, MANIFEST keys, relative links to kit `001`/`002`/`003`/`doc/sistema-sdd-pedro.md` untouched as path strings
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — design system / install kit / canonical / Session Handoff already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] `bash sdd-kit/gen-manifest-checksums.sh` after template edits; `bash sdd-kit/verify.sh` green
- [ ] Relative links among kit `doc/design/*` templates still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-design-wave-2

Change: openspec/changes/translate-kit-design-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md
Soft prerequisite: prefer translate-design-wave-2 apply-complete before this apply (hub EN source); serialize vs other sdd-kit/templates applies (e.g. kit-design-wave-1 PR #106, W2c/W2d PR #78)
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
