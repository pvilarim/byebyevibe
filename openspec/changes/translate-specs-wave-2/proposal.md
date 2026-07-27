**Issue:** —

## Why

`translate-specs-wave-1` (open DRAFT PR #104) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly deferred `openspec/specs/sdd-install-kit/spec.md` (~293 LOC / 1 file) to this wave. Closing that deferral completes residual-PT capability specs that fit whole-file G-PT within budgets, without touching the guide, aula-05, or kit design mirrors.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths, script names, MANIFEST keys/`merge:` values, `/opsx:*`, package pins, fenced shell, OpenSpec `MUST`/`WHEN`/`THEN` keywords, brand/tool names) byte-stable
- Translate residual PT requirement titles/bodies and scenario WHEN/THEN prose (upgrade MANIFEST MERGE note; HYBRID bootstrap WARN; `upgrade.sh` COPY label + header mode) so G-PT passes on the whole file
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved. Normative semantics of `sdd-install-kit` MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path not owned by active `translate-*` changes or open translate PRs #78 / #84 / #93–#104; disjoint from specs-wave-1 paths)
- Risks: G-PT false positives on allowlisted path segments / WARN string content that must stay byte-stable if it is an observed CLI message; G-INV if script/MANIFEST keys rewritten; accidental semantic drift of install/upgrade/bootstrap contracts (language only)
- **Non-goals:** specs-wave-1 paths (`sdd-ci-gates` / `sdd-post-install-verification` / `sdd-session-coordination`); already-EN specs; `openspec/changes/archive/`; canonical guide; skills/commands; kit templates (including `sdd-kit/templates/doc/design/`); hub `openspec/infra.md`; evaluations; design docs; course aulas / scripts; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/bootstrap semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `sdd-kit/install.sh` C1 layout; `upgrade.sh --dry-run` / `--apply` approval gate; HYBRID `bootstrap-sdd.sh` WARN when `package.json` + `openspec/` coexist).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/`, `MANIFEST.yaml`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `UPGRADE_REPORT.md`, `doc/sistema-sdd-pedro.md`), change-ids, `/opsx:*`, MANIFEST keys (`sha256:`, `merge:`, `gate:`), OpenSpec keywords (`MUST`/`WHEN`/`THEN`) untouched as identifiers
- [ ] Observed CLI WARN/error string literals remain byte-stable when they are normative outputs (translate surrounding prose only)
- [ ] Normative outcomes unchanged (MERGE vs COPY; dry-run vs APPLY header; HYBRID warn-continue) — language only
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / fail-closed / wave already seeded)
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
