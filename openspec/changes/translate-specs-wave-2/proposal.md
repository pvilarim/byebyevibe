**Issue:** —

## Why

`translate-specs-wave-1` (open DRAFT PR #104) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly deferred `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to this wave. Closing that residual keeps capability specs on the English path without waiting for guide/aula-05 split strategies.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, script names, MANIFEST keys such as `merge: COPY` / `merge: MERGE`, fenced shell, brand/tool names, OpenSpec `MUST`/`WHEN`/`THEN` keywords) byte-stable
- Keep the runtime approval-marker contract of `sdd-kit/upgrade.sh` intact: do **not** rewrite the script in this wave; in the capability spec, refer to the exact checkbox substring the script greps for **by reference** (do not paste deny-listed Portuguese tokens into the migrated EN prose — see design D3)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved. Normative semantics of `sdd-install-kit` MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path deferred by specs-wave-1 and not owned by active `translate-*` on base or open translate PRs #78 / #84 / #93–#104)
- Risks: G-PT false positives if the upgrade approval marker is pasted as Portuguese prose; G-INV if script/MANIFEST tokens rewritten; accidental semantic drift of bootstrap HYBRID warning / dry-run COPY label / `--apply` approval-guard requirements (language only)
- **Non-goals:** specs owned by `translate-specs-wave-1`; already-EN specs; rewriting `sdd-kit/upgrade.sh` or guide checklist strings (separate coordinated rename if desired later); `openspec/changes/archive/`; canonical guide; skills/commands; kit templates; hub `openspec/infra.md`; evaluations; design docs; course aulas / scripts; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/bootstrap semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. HYBRID ambiguous-repo bootstrap warning; `upgrade.sh --dry-run` COPY label vs `APPLY_TEMPLATE`; `--apply` rejects unapproved `UPGRADE_REPORT.md` using the script’s hardcoded approval marker).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/`, `scripts/bootstrap-sdd.sh`, `UPGRADE_REPORT.md`, MANIFEST `merge:` values), change-ids, `/opsx:*`, package pins, OpenSpec keywords (`MUST`/`WHEN`/`THEN`) untouched as identifiers
- [ ] Runtime approval marker in `sdd-kit/upgrade.sh` unchanged this wave; migrated spec references it without embedding deny-listed Portuguese tokens
- [ ] Normative outcomes unchanged (bootstrap warning vs no-warning; COPY dry-run label; `--apply` approval guard) — language only
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
