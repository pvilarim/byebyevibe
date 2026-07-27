**Issue:** —

## Why

`translate-specs-wave-1` (open DRAFT PR #104) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly deferred `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to wave-2. That single capability spec still mixes English requirements with Portuguese requirement/scenario prose (`ficheiros`, `Quando …`, `Não deve`, approval checkbox text). Closing it is the next completable whole-file residual-PT specs slice within wave budgets (1 file / ≤350–400 LOC), disjoint from owned paths.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths under `sdd-kit/`, `MANIFEST.yaml` keys including `sha256:` / `merge:` / `gate:`, script names, CLI flags, profile names APP/DOCS_SPECS/HYBRID, brand **ByeByeVibe**, OpenSpec `MUST`/`WHEN`/`THEN`, fenced shell) byte-stable
- Translate residual PT requirement/scenario prose (and any PT scenario titles) so G-PT passes on the whole file
- Keep normative install/upgrade/verify/bootstrap semantics unchanged — language only (including approval checkbox label → English equivalent that still matches script contract expectations documented in the spec)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved. Normative semantics of `sdd-install-kit` MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none for propose; apply is independent of specs-wave-1 apply (disjoint paths). Wave-1 merely named this deferral.
- Risks: G-PT false positives on allowlisted path segments; G-INV if script/flag/`gate:` forms rewritten; accidental semantic drift of install integrity, upgrade dry-run/apply mutual exclusion, or bootstrap profile-warning behavior (language only)
- **Non-goals:** specs owned by `translate-specs-wave-1`; already-EN specs; `openspec/changes/archive/`; canonical guide; skills/commands; kit templates (including `sdd-kit/templates/doc/design/`); hub `openspec/infra.md`; evaluations; design docs; course aulas / scripts; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/verify semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. sha256 integrity abort on mismatch; `upgrade.sh` `--dry-run` vs `--apply` mutual exclusion + UPGRADE_REPORT approval; bootstrap profile warning when `package.json` + `openspec/` coexist).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `scripts/sdd-metrics.sh`, `doc/sistema-sdd-pedro.md`), change-ids, `/opsx:*`, `merge:`/`sha256:`/`gate:` keys, profile names, OpenSpec keywords (`MUST`/`WHEN`/`THEN`) untouched as identifiers
- [ ] Normative outcomes unchanged (integrity fail-closed; dry-run labels `COPY` not `APPLY_TEMPLATE`; backup before overwrite; ByeByeVibe brand vs on-disk `sdd-kit/`) — language only
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
