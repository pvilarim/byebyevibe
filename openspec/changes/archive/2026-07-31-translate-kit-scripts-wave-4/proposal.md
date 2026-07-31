**Issue:** —

## Why

Kit-scripts waves 1–3 (open PRs #122 / #123 / #124) own the `sdd-upgrade-diff.sh`, `verify-infra.sh`, and `bootstrap-sdd.sh` hub+template pairs. The next completable whole-file residual-PT kit-script slice that fits budgets and is disjoint from every primary owned path is `sdd-kit/upgrade.sh` alone (~280 LOC / 1 file) — dry-run report scaffold, approval-gate grep, and several operator-facing stderr strings still fail G-PT / Slice DoD. Wave-3 explicitly deferred this path as contract-adjacent; this propose owns it with an explicit source-of-truth rename plan for the approval checkbox.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `sdd-kit/upgrade.sh`
- Translate dry-run `UPGRADE_REPORT.md` scaffold headings/labels and operator-facing `echo` / stderr strings (including mutual-exclusion and missing-report messages)
- **BREAKING (runtime string):** rename the approval checkbox / grep needle from `[x] Actualização aprovada` to an English canonical form (recommended: `[x] Upgrade approved`) in the same apply — scaffold text and `grep -q` MUST stay byte-identical to each other after substitution so `--apply` keeps working
- Treat `sdd-kit/upgrade.sh` as the runtime source-of-truth for the approval checkbox string; do **not** edit `openspec/specs/sdd-install-kit/spec.md` in this wave (owned by `translate-specs-wave-2` / PR #105, which already requires cross-referencing the script rather than re-embedding deny-listed Portuguese)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files sdd-kit/upgrade.sh` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `sdd-kit/upgrade.sh` MUST be English after substitution (comments, report scaffold, operator-facing messages, and the approval checkbox / grep needle); dual-file siblings forbidden; freeze-list tokens and upgrade control flow preserved; the script remains SoT for the UPGRADE_REPORT approval string

## Impact

- Files modified: `sdd-kit/upgrade.sh` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none for propose (infra ✅ — `verify-i18n-wave.sh` already registered; path not primary-owned by active `translate-*` on base or open translate propose PRs #84 / #93–#124). Soft apply note: specs-wave-2 (PR #105) already treats the checkbox as script SoT — after this apply, that cross-reference continues to hold with the new English needle
- Risks: G-PT false positives; in-flight `UPGRADE_REPORT.md` files still using the legacy Portuguese checkbox fail `--apply` until re-checked with the EN string; guide prose may still document the old PT checkbox until a guide wave; accidental change to COPY/MERGE/profile/`--force` behavior
- **Non-goals:** `openspec/specs/sdd-install-kit/spec.md` (owned by specs-wave-2); `install-ui-module.sh` hub+template (~604 LOC combined — over budget / split later); `sdd-metrics.sh` hub+template (over budget / weak deny-list); kit-scripts waves 1–3 paths; canonical guide; design `001` / aula-05 / over-budget research files; EN gate/glossary quote hits inside existing `translate-*/tasks.md|design.md|spec.md`; rewriting `openspec/changes/archive/`; dual-file `*.en.md` / `*-pt.md` / `*.en.sh`; global G-DoD; changing COPY/MERGE classification, profile filters, branch safety, or integrity-check semantics — language (+ coordinated checkbox needle) only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files sdd-kit/upgrade.sh
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/` edits), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN script text (e.g. `--dry-run` scaffolds `UPGRADE_REPORT.md`; checkbox + `--apply` gate; mutual exclusion of `--dry-run`/`--apply`; branch safety on main/master).

## Freeze / allowlist checklist

- [ ] Shell logic, exit codes, flags (`--from` / `--to` / `--profile` / `--dry-run` / `--apply` / `--force` / `--repo`), MERGE labels (`KEEP_LOCAL` · `MERGE` · `COPY` · `NEW` · `SKIP`), and Python MANIFEST parser byte-stable aside from string/comment language
- [ ] Paths (`sdd-kit/upgrade.sh`, `sdd-kit/MANIFEST.yaml`, `UPGRADE_REPORT.md`, `openspec/changes/upgrade-sdd-v*`), change-ids, `/opsx:*`, brand/tool names untouched as identifiers
- [ ] Approval checkbox scaffold text and `grep -q` needle remain identical to each other after EN rename (single SoT inside this script)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / gate / wave / upgrade already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Do not edit specs-wave-2 artifacts in this apply

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-kit-scripts-wave-4

Change: openspec/changes/translate-kit-scripts-wave-4/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files sdd-kit/upgrade.sh
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
