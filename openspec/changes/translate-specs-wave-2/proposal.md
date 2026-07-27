**Issue:** —

## Why

Specs wave-1 (open DRAFT PR #104) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly defers `openspec/specs/sdd-install-kit/spec.md` (~292 LOC / 1 file) to this wave. That file is the next completable whole-file residual on the specs track: within budgets, disjoint from owned translate paths / open PRs, and avoids mid-file guide G-PT.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, MANIFEST keys `sha256:` / `merge:` / `gate:`, profile names APP/DOCS_SPECS/HYBRID, fenced shell, brand/tool names, OpenSpec `MUST`/`WHEN`/`THEN` keywords)
- Preserve **byte-stable contract strings** that scripts match or emit (do not “translate” as prose): `[x] Actualização aprovada`; stderr `WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID.`; English `ERROR:` / `WARN:` / `BACKUP` / `SDD UPGRADE REPORT (dry-run)` / `SDD UPGRADE APPLY` / `COPY` / `APPLY_TEMPLATE` labels already cited as literals
- Translate residual PT requirement titles, bodies, and scenario WHEN/THEN prose (bootstrap HYBRID warning; upgrade classify/header sections; mixed PT in Deterministic SDD upgrade MANIFEST sentence) so G-PT passes on the whole file, with frozen literals allowlisted
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed `sdd-install-kit` capability spec MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens and script contract literals preserved. Normative install/upgrade/verify semantics MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none for propose (infra ✅ — `verify-i18n-wave.sh` already registered). Soft note: specs wave-1 apply may land earlier; paths are disjoint so this propose does not wait on #104 merge
- Risks: G-PT false positives on frozen Portuguese contract strings (`Actualização aprovada`, HYBRID WARN text); G-INV if script/MANIFEST identifiers rewritten; accidental semantic drift of install/upgrade/approval-gate contracts (language only)
- **Non-goals:** specs wave-1 paths (`sdd-ci-gates` / `sdd-post-install-verification` / `sdd-session-coordination`); already-EN specs; rewriting `openspec/changes/archive/`; canonical guide; skills/commands; kit templates; hub `openspec/infra.md`; evaluations; design docs; course aulas; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/verify behavior or renaming the approval checkbox / WARN strings in scripts — language only in this spec file

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `upgrade.sh --dry-run` then approve `[x] Actualização aprovada` then `--apply`; integrity sha256 abort vs warn-if-absent; bootstrap HYBRID coexistence WARN is informational).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `UPGRADE_REPORT.md`), change-ids, `/opsx:*`, MANIFEST keys, profile names, OpenSpec keywords untouched as identifiers
- [ ] Contract literals unchanged: `[x] Actualização aprovada`; `WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID.`; documented `ERROR:` / `COPY` / `APPLY_TEMPLATE` / upgrade header strings
- [ ] Normative outcomes unchanged (dry-run vs apply; integrity fail-closed; MERGE preserves local upgrade tools; mutual exclusion of flags) — language only
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / gate / fail-closed / wave already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative / cross-spec references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-specs-wave-2

Change: openspec/changes/translate-specs-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
