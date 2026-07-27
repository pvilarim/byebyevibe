**Issue:** —

## Why

Specs wave-1 (open DRAFT PR #104) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly defers `openspec/specs/sdd-install-kit/spec.md` (~293 LOC / 1 file) to wave-2. That file still mixes English requirements with Portuguese bootstrap/upgrade prose and is the next completable whole-file residual that fits budgets and is path-disjoint from active `translate-*` ownership and open translate PRs.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths including `sdd-kit/`, `MANIFEST.yaml`, `install.sh` / `upgrade.sh` / `verify.sh` / `bootstrap-sdd.sh`, `UPGRADE_REPORT.md`, merge strategies `COPY`/`MERGE`, profile names APP/DOCS_SPECS/HYBRID, package pins, fenced shell, OpenSpec `MUST`/`WHEN`/`THEN`, brand **ByeByeVibe**) byte-stable
- **Freeze runtime contract strings** (do not “translate away”): `[x] Actualização aprovada` (matched by `sdd-kit/upgrade.sh --apply`) and the bootstrap stderr WARN text currently emitted by `sdd-kit/templates/scripts/bootstrap-sdd.sh` (`WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID.` and sibling confirmation lines) — quote them as literals; translate surrounding requirement/scenario prose only
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution except allowlisted freeze/runtime contract strings documented in this wave; dual-file siblings forbidden; normative install/upgrade/verify semantics MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path deferred by `translate-specs-wave-1` / PR #104 and not primary-owned by other open translate PRs #78 / #84 / #93–#103)
- Risks: G-PT false positives on frozen PT contract strings (`Actualização`, `coexistem`, `perfil`); G-INV if script/MANIFEST identifiers rewritten; accidental semantic drift of upgrade approval / HYBRID warning / COPY dry-run label contracts (language only around frozen literals)
- **Non-goals:** other `openspec/specs/**` (wave-1 trio or already-EN); rewriting `sdd-kit/upgrade.sh` / `bootstrap-sdd.sh` message strings in this wave (separate change if EN UX is desired); `openspec/changes/archive/`; canonical guide; skills/commands; kit templates; hub `openspec/infra.md`; evaluations; design docs; course; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/verify semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**Allowlist note (G-PT):** residual deny-list hits that remain **only** inside frozen quoted runtime contract strings (`[x] Actualização aprovada`, bootstrap WARN/confirm stderr literals) are documented exceptions for this wave until a coordinated script+spec EN message change lands.

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `upgrade.sh --dry-run` shows `COPY` not `APPLY_TEMPLATE`; `--apply` requires checked `[x] Actualização aprovada`; ambiguous `package.json`+`openspec/` bootstrap warns then defaults to APP).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/`, `MANIFEST.yaml`, scripts), merge labels `COPY`/`MERGE`/`APPLY_TEMPLATE`, profiles, OpenSpec keywords untouched as identifiers
- [ ] Runtime contract strings `[x] Actualização aprovada` and bootstrap WARN/confirm stderr lines kept verbatim when cited
- [ ] Normative outcomes unchanged (integrity abort, path traversal block, dry-run vs apply mutual exclusion, backup-before-overwrite) — language only
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
