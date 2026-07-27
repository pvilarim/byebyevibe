**Issue:** —

## Why

`translate-specs-wave-1` (open DRAFT PR #104) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly defers `openspec/specs/sdd-install-kit/spec.md` (~292 LOC / 1 file) to this wave. That install-kit capability spec still has Portuguese requirement titles, bodies, and scenarios (bootstrap warning, dry-run COPY label, upgrade header, mixed upgrade-tool MERGE sentence) while most neighboring specs are already English. This slice fits budgets, is path-disjoint from the owned set, and avoids mid-file guide G-PT.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, script names, fenced shell, brand/tool names, OpenSpec `MUST`/`WHEN`/`THEN`, MANIFEST keys such as `merge: COPY` / `merge: MERGE`, and the runtime approval checkbox string `[x] Actualização aprovada` that `sdd-kit/upgrade.sh` greps) byte-stable
- Translate residual PT requirement titles/bodies and scenario WHEN/THEN prose so G-PT passes on the whole file
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens (including the `Actualização aprovada` approval checkbox substring matched by `upgrade.sh`) preserved. Normative semantics of `sdd-install-kit` MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path not owned by active `translate-*` changes or open translate PRs #78 / #84 / #93–#104)
- Soft sequencing note: prefer apply after `translate-specs-wave-1` propose is merged when convenient for review clustering; **not** a hard path dependency (disjoint files)
- Risks: G-PT false positives on allowlisted PT runtime strings (`Actualização aprovada`); G-INV if script/MANIFEST identifiers rewritten; accidental semantic drift of install/upgrade/integrity contracts (language only)
- **Non-goals:** other capability specs (wave-1 owns three; already-EN specs untouched); rewriting `sdd-kit/upgrade.sh` / changing the approval checkbox substring; `openspec/changes/archive/`; canonical guide; skills/commands; kit templates (including `sdd-kit/templates/doc/design/`); hub `openspec/infra.md`; evaluations; design docs; course aulas / scripts; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/integrity semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `install.sh` integrity abort on sha256 mismatch; `upgrade.sh --dry-run` then approval checkbox then `--apply`; bootstrap HYBRID warning when `package.json` + `openspec/` coexist).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `UPGRADE_REPORT.md`), change-ids, `/opsx:*`, OpenSpec keywords (`MUST`/`WHEN`/`THEN`), MANIFEST merge labels (`COPY` / `MERGE` / not `APPLY_TEMPLATE`) untouched as identifiers
- [ ] Runtime approval substring `[x] Actualização aprovada` (and scaffold wording matched by `upgrade.sh`) left unchanged in the spec until a separate non-i18n change updates script + scaffold together
- [ ] Normative outcomes unchanged (integrity fail-closed, dry-run vs apply mutual exclusion, MERGE preservation of local upgrade-diff) — language only
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
