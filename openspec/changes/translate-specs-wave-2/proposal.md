**Issue:** —

## Why

`translate-specs-wave-1` (open DRAFT PR #104) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`. The next completable whole-file residual that fits budgets and avoids mid-file guide G-PT is `openspec/specs/sdd-install-kit/spec.md` alone (~292 LOC / 1 file), explicitly deferred by wave-1.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, script names, fenced shell, brand/tool names, OpenSpec `MUST`/`WHEN`/`THEN` keywords, MANIFEST keys, merge strategy labels `COPY`/`MERGE`, profile names APP/DOCS_SPECS/HYBRID) byte-stable
- Keep runtime stderr / grep contracts source-of-truth in scripts: bootstrap HYBRID warning string in `sdd-kit/templates/scripts/bootstrap-sdd.sh`; UPGRADE_REPORT approval checkbox string grepped by `sdd-kit/upgrade.sh` — EN spec prose MUST NOT weaken those contracts; avoid re-embedding deny-listed Portuguese tokens in the capability spec when a script cross-reference preserves fact parity (see design D5)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved. Normative semantics of `sdd-install-kit` MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path not owned by active `translate-*` on base or open translate PRs #78 / #84 / #93–#104; wave-1 deferred this path)
- Risks: G-PT false positives on allowlisted path segments or runtime PT strings; G-INV if script/MANIFEST identifiers rewritten; accidental semantic drift of install/upgrade/verify contracts (language only)
- **Non-goals:** the three specs owned by `translate-specs-wave-1` / PR #104; other already-EN specs; `openspec/changes/archive/`; canonical guide; skills/commands; kit templates / `MANIFEST.yaml` checksum churn; hub `openspec/infra.md`; evaluations; design docs; course aulas / scripts; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; renaming the upgrade approval checkbox in `upgrade.sh` / guide (separate contract change if ever needed); changing install/upgrade/verify semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/` edits in this language wave), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `install.sh` profile flags; `upgrade.sh --dry-run` then approval then `--apply`; bootstrap HYBRID warning when `package.json` + `openspec/` coexist).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `scripts/sdd-metrics.sh`, `UPGRADE_REPORT.md`), change-ids, `/opsx:*`, OpenSpec keywords (`MUST`/`WHEN`/`THEN`), merge labels `COPY`/`MERGE`, profiles APP/DOCS_SPECS/HYBRID untouched as identifiers
- [ ] Runtime contracts preserved: bootstrap stderr warning text remains as implemented in `sdd-kit/templates/scripts/bootstrap-sdd.sh`; UPGRADE_REPORT approval gate still matches what `sdd-kit/upgrade.sh` greps — do not invent a new checkbox string in this language-only wave
- [ ] Normative outcomes unchanged (MERGE preserves local upgrade tools; dry-run vs apply headers; mutual exclusion of `--dry-run`/`--apply`; backup-before-overwrite) — language only
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / gate / fail-closed / wave already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links / cross-spec references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-specs-wave-2

Change: openspec/changes/translate-specs-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
