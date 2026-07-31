**Issue:** —

## Why

Kit-scripts wave-1 (open PR #122) owns the `sdd-upgrade-diff.sh` hub+template pair. The next completable whole-file residual-PT kit-script slice that fits budgets and is disjoint from every owned path is the C2 `verify-infra` helper pair — hub `scripts/verify-infra.sh` plus kit template `sdd-kit/templates/scripts/verify-infra.sh` (~362 LOC total, 2 identical files) — whose Portuguese chrome matchers (`Última verificação`, env-table headers, `Regra agentes`) and operator strings still fail G-PT / Slice DoD.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `scripts/verify-infra.sh`
  - `sdd-kit/templates/scripts/verify-infra.sh`
- Align sed/Python match-and-rewrite chrome with the already-English kit manifesto labels in `sdd-kit/templates/openspec/infra.md` (`Last verified`, `Variable | Present | Verify with`, `## Agent rule`)
- Preserve freeze-list tokens (paths, HTML `<!-- marker -->` names, package/tool names, status glyphs ✅/❌, `[NEEDS VERIFICATION]`, fenced/shell identifiers, env var **names**) byte-stable aside from intentional non-i18n fixes
- Keep hub vs template **byte-identical** after substitution (they are identical today) — language only, no behavior fork
- After template edit: run `bash sdd-kit/gen-manifest-checksums.sh` so `sdd-kit/MANIFEST.yaml` `sha256:` for this template stays honest (G-MANIFEST)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files scripts/verify-infra.sh,sdd-kit/templates/scripts/verify-infra.sh` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed verify-infra script paths MUST be English after substitution (comments, operator-facing messages, and infra.md chrome matchers); dual-file siblings forbidden; freeze-list tokens and script control flow preserved; MANIFEST checksum regeneration required when the template is touched

## Impact

- Files modified: `scripts/verify-infra.sh`, `sdd-kit/templates/scripts/verify-infra.sh`, and `sdd-kit/MANIFEST.yaml` (checksums only after template prose change); optional: `doc/i18n/GLOSSARY.md` if new terms
- Dependencies: **soft apply-after** `translate-infra-wave-1` — after this wave’s apply, sed/Python chrome targets EN labels (`Last verified`, `Variable | Present | Verify with`, `## Agent rule`). Applying verify-infra **before** hub `openspec/infra.md` is English will stop matching the still-Portuguese timestamp/env-table chrome until infra-wave-1 apply lands. Propose is path-disjoint and may merge in parallel.
- Risks: G-PT false positives; apply-order race vs infra-wave-1; G-MANIFEST if checksums skipped; operators relying on Portuguese echo/`ausente` strings (language only)
- **Non-goals:** editing `openspec/infra.md` (owned by `translate-infra-wave-1`); `install-ui-module.sh` hub+template (~604 LOC combined — over budget); `sdd-metrics.sh` hub+template (~467 LOC each — over budget / weak deny-list today); `sdd-kit/upgrade.sh` / `bootstrap-sdd.sh` (owned or freeze-referenced by specs-wave-2 / related proposes); canonical guide; design `001` / aula-05 / explore-adversarial `research.md` / discovery `research.md` (over whole-file G-PT budget); EN gate/glossary quote hits inside existing `translate-*/tasks.md|design.md|spec.md`; rewriting `openspec/changes/archive/`; dual-file `*.en.md` / `*-pt.md`; global G-DoD; changing verify-infra check semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files scripts/verify-infra.sh,sdd-kit/templates/scripts/verify-infra.sh
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN script text (e.g. OpenSpec/GitNexus/Graphify status lines; timestamp update against EN `openspec/infra.md` after infra-wave-1; env-table rewrite against `## Agent rule`).

## Freeze / allowlist checklist

- [ ] Shell logic, exit codes, HTML marker names (`openspec-version`, `mcp-list`, `kit-version`, …), and identifier names byte-stable aside from string/comment language
- [ ] Paths (`scripts/verify-infra.sh`, `sdd-kit/templates/scripts/verify-infra.sh`, `openspec/infra.md`, `sdd-kit/MANIFEST.yaml`), change-ids, `/opsx:*`, brand/tool names untouched as identifiers
- [ ] Hub and template remain content-equivalent after substitution (no intentional fork)
- [ ] Chrome strings align to kit EN manifesto (`Last verified`, `Variable | Present | Verify with`, `## Agent rule`) — not invented synonyms
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — verification / gate / install kit / wave / Session Coordination already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] `bash sdd-kit/gen-manifest-checksums.sh` run after template edit; `bash sdd-kit/verify.sh` / G-MANIFEST green

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-scripts-wave-2

Change: openspec/changes/translate-kit-scripts-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Prerequisite (soft): prefer apply after translate-infra-wave-1 so hub openspec/infra.md chrome is already EN
Gate: bash scripts/verify-i18n-wave.sh --files scripts/verify-infra.sh,sdd-kit/templates/scripts/verify-infra.sh
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
