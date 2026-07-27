**Issue:** —

## Why

Open DRAFT PR #104 (`translate-specs-wave-1`) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly deferred `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to this wave. That single capability spec still mixes English requirements with Portuguese upgrade/bootstrap prose and is the next completable whole-file residual that fits budgets and stays path-disjoint from open translate proposes.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `scripts/sdd-metrics.sh`, merge labels `COPY`/`MERGE`, profile names, package pins, fenced shell, brand/tool names ByeByeVibe / OpenSpec, OpenSpec `MUST`/`WHEN`/`THEN` keywords) byte-stable
- Translate residual PT requirement/scenario prose (upgrade MERGE classification, HYBRID bootstrap WARN, dry-run `COPY` label, dry-run vs APPLY headers) so G-PT passes on the whole file
- For the UPGRADE_REPORT approval gate: describe the approved-checkbox marker by reference to the literal that `sdd-kit/upgrade.sh` greps (do **not** paste the legacy Portuguese checkbox substring into the EN spec — keeps G-PT green without expanding this wave into kit-script i18n)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved. Normative semantics of `sdd-install-kit` MUST NOT change beyond language (including upgrade approval gate behavior).

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none for propose; soft note — wave-1 (#104) is independent (disjoint paths). Infra ✅ — `verify-i18n-wave.sh` already registered
- Risks: G-PT false positives on allowlisted path segments; G-INV if script/flag names rewritten; accidental semantic drift of install/upgrade/verify/bootstrap contracts (language only); approval-marker phrasing must keep `upgrade.sh` as SSOT for the grep literal
- **Non-goals:** other `openspec/specs/**` (wave-1 owns ci-gates / post-install / session-coordination); already-EN specs; `openspec/changes/archive/`; canonical guide; skills/commands; kit templates / `sdd-kit/upgrade.sh` full-script i18n (separate wave); hub `openspec/infra.md`; evaluations; design docs; course aulas / scripts; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/MERGE/COPY semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `install.sh` integrity abort on sha256 mismatch; `upgrade.sh --dry-run` then approve then `--apply`; `bootstrap-sdd.sh` HYBRID WARN when `package.json` + `openspec/` coexist).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/`, `MANIFEST.yaml`, scripts), change-ids, `/opsx:*`, merge enum values `COPY`/`MERGE`, profile names, OpenSpec keywords (`MUST`/`WHEN`/`THEN`) untouched as identifiers
- [ ] UPGRADE_REPORT approval marker: EN prose references `upgrade.sh` as SSOT — do not embed legacy Portuguese checkbox text in the spec (G-PT); do not change `upgrade.sh` grep in this wave
- [ ] Normative outcomes unchanged (integrity fail-closed, MERGE preserve, COPY dry-run label, mutual exclusion `--dry-run`/`--apply`) — language only
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / fail-closed / wave / canonical already seeded)
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
