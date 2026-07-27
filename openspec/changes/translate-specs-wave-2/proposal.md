**Issue:** —

## Why

`translate-specs-wave-1` (open DRAFT PR #104) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly defers `openspec/specs/sdd-install-kit/spec.md` (~292 LOC, 1 file) to this wave. That path still has residual PT requirement/scenario prose and is the next whole-file residual that fits budgets and stays disjoint from the owned set.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, script names, fenced shell, brand/tool names, OpenSpec `MUST`/`WHEN`/`THEN` keywords, MANIFEST keys such as `merge: COPY` / `merge: MERGE`, and the runtime approval marker `[x] Actualização aprovada` checked by `sdd-kit/upgrade.sh`) byte-stable
- If the freeze approval marker alone would fail G-PT after prose substitution, narrow-exempt that exact marker in `scripts/verify-i18n-wave.sh` (documented allowlist — do **not** rewrite `upgrade.sh` / UPGRADE_REPORT scaffold in this language wave)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done (include `scripts/verify-i18n-wave.sh` in `--files` if that script is edited)

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved (including the upgrade approval marker string). Normative semantics of `sdd-install-kit` MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `scripts/verify-i18n-wave.sh` for freeze-marker G-PT exemption; optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none for propose (disjoint from wave-1 paths). Soft: apply may land before or after wave-1 apply — path sets do not overlap.
- Risks: G-PT false positives on the freeze approval marker; G-INV if script/MANIFEST tokens rewritten; accidental semantic drift of upgrade/bootstrap/integrity contracts (language only); over-broad verify-script exemption
- **Non-goals:** wave-1 capability specs (`sdd-ci-gates` / `sdd-post-install-verification` / `sdd-session-coordination`); already-EN specs; rewriting `upgrade.sh` / guide UPGRADE_REPORT scaffold to English approval text (separate coordinated change); `openspec/changes/archive/`; canonical guide; skills/commands; kit templates; hub `openspec/infra.md`; evaluations; design docs; course; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/integrity semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

If `scripts/verify-i18n-wave.sh` is edited for the freeze-marker exemption, include it:

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,scripts/verify-i18n-wave.sh
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `install.sh` integrity abort; `upgrade.sh --dry-run` vs `--apply` + `[x] Actualização aprovada` gate; `bootstrap-sdd.sh` HYBRID warning).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `UPGRADE_REPORT.md`, MANIFEST keys), change-ids, `/opsx:*`, package pins, OpenSpec keywords (`MUST`/`WHEN`/`THEN`) untouched as identifiers
- [ ] Runtime approval marker `[x] Actualização aprovada` left byte-stable (matches `sdd-kit/upgrade.sh` grep) — allowlisted for G-PT if needed via narrow verify-script exemption
- [ ] Normative outcomes unchanged (integrity fail-closed, dry-run labels, HYBRID warning, mutual exclusion of flags) — language only
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
