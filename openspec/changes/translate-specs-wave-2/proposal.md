**Issue:** —

## Why

Specs wave-1 (open DRAFT PR #104) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly defers `openspec/specs/sdd-install-kit/spec.md` (~292 LOC / 1 file) to this wave. That file is the next completable whole-file residual-PT capability-spec slice within budgets and disjoint from the owned set.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, fenced shell, brand/tool names, OpenSpec `MUST`/`WHEN`/`THEN` keywords, MANIFEST keys such as `merge: COPY` / `merge: MERGE`, label tokens `COPY` / `APPLY_TEMPLATE`)
- Translate residual PT requirement titles/bodies and scenario WHEN/THEN prose (HYBRID bootstrap warning, COPY label alignment, mixed upgrade prose) so G-PT passes on the whole file; for runtime Portuguese strings still grepped/emitted by kit scripts (UPGRADE_REPORT approval checkbox in `sdd-kit/upgrade.sh`, HYBRID WARN text), **reference the script implementation** rather than pasting G-PT deny-list tokens into the migrated EN spec (do not rename those script literals in this wave)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; runtime Portuguese script literals referenced indirectly (not pasted) so G-PT can pass. Normative semantics of `sdd-install-kit` MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path not owned as a primary target by active `translate-*` on base or open translate PRs #78 / #84 / #93–#104 — only listed as deferred by #104)
- Risks: G-PT false positives on allowlisted path segments; G-INV if script/flag names rewritten; accidental semantic drift of install/upgrade/bootstrap contracts (language only); pasting deny-list tokens when documenting script-owned Portuguese literals (forbidden — use script indirection); renaming the approval checkbox without updating `sdd-kit/upgrade.sh` (forbidden in this wave)
- **Non-goals:** other capability specs (wave-1 owns three; already-EN specs); `openspec/changes/archive/`; canonical guide; skills/commands; kit templates / `sdd-kit/upgrade.sh` behavior changes; hub `openspec/infra.md`; evaluations; design docs; course aulas / scripts; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `upgrade.sh --dry-run` then approve report then `--apply`; HYBRID ambiguous bootstrap warning; COPY vs APPLY_TEMPLATE dry-run labels).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `MANIFEST.yaml`, `UPGRADE_REPORT.md`), flags (`--from`/`--to`/`--dry-run`/`--apply`), OpenSpec keywords (`MUST`/`WHEN`/`THEN`) untouched as identifiers
- [ ] Runtime Portuguese literals owned by `sdd-kit/upgrade.sh` / bootstrap scripts remain in those scripts; EN spec references them indirectly (no deny-list token paste); do not rename without a separate non-i18n change that updates the scripts
- [ ] Normative outcomes unchanged (dry-run vs apply mutual exclusion; backup before overwrite; HYBRID warning non-fatal; COPY label) — language only
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / gate / fail-closed / wave already seeded)
- [ ] No dual-file EN/PT siblings introduced

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-specs-wave-2

Change: openspec/changes/translate-specs-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
