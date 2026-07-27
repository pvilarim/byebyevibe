**Issue:** —

## Why

`translate-specs-wave-1` (open DRAFT PR #104) owns residual-PT capability specs `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly defers `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to `translate-specs-wave-2`. That file still has Portuguese requirement/scenario prose (bootstrap HYBRID warning, upgrade dry-run labels/headers, mixed MANIFEST sentence, UPGRADE_REPORT approval checkbox text) and is the next disjoint whole-file residual that fits wave budgets.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, script names, MANIFEST keys `sha256:` / `merge:` / `gate:`, package pins, fenced shell, brand/tool names including ByeByeVibe, OpenSpec `MUST`/`WHEN`/`THEN` keywords) byte-stable
- Translate residual PT requirement/scenario prose (and any mixed PT fragments in otherwise-EN requirements) so G-PT passes on the whole file
- Keep the UPGRADE_REPORT approval checkbox string contract explicit in English (document the exact marker the script checks; do not change runtime behavior in this language wave)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved. Normative semantics of `sdd-install-kit` MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (disjoint from `translate-specs-wave-1` targets and from open translate PRs #78 / #84 / #93–#104); infra ✅ — `verify-i18n-wave.sh` already registered
- Risks: G-PT false positives on allowlisted path segments; G-INV if script/MANIFEST identifiers rewritten; accidental semantic drift of install/upgrade/verify contracts (language only); approval-checkbox string must stay consistent with `upgrade.sh` expectations (document EN form; do not retarget script behavior here)
- **Non-goals:** the three specs owned by `translate-specs-wave-1`; other already-EN specs; `openspec/changes/archive/`; canonical guide; skills/commands; kit templates (including `sdd-kit/templates/doc/design/`); hub `openspec/infra.md`; evaluations; design docs; course aulas / scripts; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/verify semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/` edits), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `install.sh` integrity abort on sha256 mismatch; `upgrade.sh --dry-run` then approve then `--apply`; `bootstrap-sdd.sh` HYBRID coexistence WARN).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `scripts/sdd-metrics.sh`, `doc/sistema-sdd-pedro.md`), change-ids, `/opsx:*`, MANIFEST keys (`sha256:`, `merge:`, `gate:`, `source:`, `path:`), OpenSpec keywords (`MUST`/`WHEN`/`THEN`) untouched as identifiers
- [ ] Normative outcomes unchanged (integrity fail-closed; dry-run vs apply mutual exclusion; MERGE vs COPY; backup-before-overwrite) — language only
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / fail-closed / gate / wave already seeded)
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
