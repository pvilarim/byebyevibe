**Issue:** —

## Why

`translate-specs-wave-1` (open DRAFT PR #104) owns residual-PT capability specs `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly deferred `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to `translate-specs-wave-2`. That install-kit slice is the next completable residual-PT specs file within budgets and path-disjoint from the owned set.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `openspec/specs/sdd-install-kit/spec.md`
  - `sdd-kit/upgrade.sh` (minimal freeze-list **contract** migration only: UPGRADE_REPORT approval checkbox / `grep` / operator hint strings that currently embed deny-listed `Actualização`, so G-PT can pass without leaving an executable PT marker)
- Preserve freeze-list tokens (paths, MANIFEST keys, `merge:` values, flags `--from`/`--to`/`--dry-run`/`--apply`, profile names, package pins, OpenSpec `MUST`/`WHEN`/`THEN`, brand/tool names) byte-stable
- Keep executable stderr/header contracts that remain Portuguese in scripts **only** when they do not trip G-PT deny-list (e.g. bootstrap HYBRID `WARN:…` string) — quote them unchanged until a separate script EN wave
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/upgrade.sh` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; UPGRADE_REPORT approval marker contract MUST stay synchronized between the capability spec and `sdd-kit/upgrade.sh` after the EN marker migration. Normative install/upgrade/bootstrap semantics of `sdd-install-kit` MUST NOT change beyond language (and the synchronized approval-marker string).

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md`, `sdd-kit/upgrade.sh` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path-disjoint from active `translate-*` ownership and open translate PRs #78 / #84 / #93–#104)
- Risks: G-PT false positives on allowlisted quoted script strings; G-INV if flags/MANIFEST keys rewritten; accidental semantic drift of upgrade/bootstrap/install requirements; breaking `--apply` if approval marker is changed in the spec but not in `upgrade.sh` (or vice versa)
- **Non-goals:** other capability specs (wave-1 owns three residual files); already-EN specs; `openspec/changes/archive/`; canonical guide (incl. guide copy of the approval checkbox); hub `openspec/infra.md`; skills/commands; kit Cursor rule templates / MANIFEST checksum churn beyond touching live `upgrade.sh`; kit `templates/doc/design/`; evaluations; design docs; course aulas / scripts; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/bootstrap **behavior** beyond translating the approval-marker contract string — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/upgrade.sh
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `upgrade.sh --dry-run` then approve checkbox then `--apply`; bootstrap HYBRID coexistence warning; MANIFEST `merge: COPY` dry-run label).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable (except intentional EN migration of the approval-marker contract strings in `upgrade.sh` + matching spec quotes)
- [ ] Paths (`sdd-kit/`, `scripts/bootstrap-sdd.sh`, `UPGRADE_REPORT.md`, MANIFEST keys), change-ids, `/opsx:*`, pins, OpenSpec keywords (`MUST`/`WHEN`/`THEN`) untouched as identifiers
- [ ] Approval marker migrated **in lockstep**: spec + `sdd-kit/upgrade.sh` (`grep` + scaffold checkbox + operator hint) → same English form (prefer `[x] Update approved`)
- [ ] Normative outcomes unchanged (dry-run vs apply; mutual exclusion; backup-before-overwrite; MERGE/COPY classification) — language only
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / fail-closed / wave already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links / cross-spec references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-specs-wave-2

Change: openspec/changes/translate-specs-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/upgrade.sh
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
