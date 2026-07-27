**Issue:** —

## Why

`translate-specs-wave-1` (open DRAFT PR #104) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly defers `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to this wave. Completing that deferred single-file slice clears the last deny-list residual on active capability specs and stays within wave budgets.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, script names, MANIFEST keys such as `merge:` / `sha256:` / `gate:`, package pins, fenced shell, brand/tool names, OpenSpec `MUST`/`WHEN`/`THEN` keywords) byte-stable
- For the upgrade approval checkbox matched by `sdd-kit/upgrade.sh`: **do not** paste the legacy Portuguese marker string into the English spec (it would fail G-PT). Refer to the script’s existing `grep` contract instead; renaming that marker in `upgrade.sh` is a **non-goal** of this wave
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved. Normative semantics of `sdd-install-kit` MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none for propose; apply soft-gate prefers `translate-specs-wave-1` merged first only if operators want sequential archive of ADDED deltas — **path ownership is disjoint**, so propose/apply may proceed in parallel with wave-1
- Risks: G-PT if legacy Portuguese approval marker is copied into the EN spec; G-INV if script/MANIFEST identifiers rewritten; accidental semantic drift of upgrade/bootstrap/profile contracts (language only)
- **Non-goals:** rewriting `sdd-kit/upgrade.sh` / guide checklist marker strings; other already-EN specs; wave-1’s three capability specs; `openspec/changes/archive/`; canonical guide; skills/commands; kit templates; hub `openspec/infra.md`; evaluations; design docs; course aulas / scripts; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/bootstrap semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `upgrade.sh --dry-run` then `--apply` approval gate; `bootstrap-sdd.sh` APP+`openspec/` profile warning; dry-run `COPY` vs `APPLY_TEMPLATE` label rule).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/`, `scripts/bootstrap-sdd.sh`, `UPGRADE_REPORT.md`, MANIFEST keys), change-ids, `/opsx:*`, OpenSpec keywords untouched as identifiers
- [ ] Legacy Portuguese approval marker remains **only** inside `sdd-kit/upgrade.sh` until a future kit-script wave; English spec references the script contract without embedding deny-list tokens
- [ ] Normative outcomes unchanged (dry-run vs apply; profile warning; COPY label) — language only
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / gate / fail-closed already seeded)
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
