**Issue:** —

## Why

Open DRAFT PR #104 (`translate-specs-wave-1`) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly defers `openspec/specs/sdd-install-kit/spec.md` (~292 LOC / 1 file) to this wave. That file is the next completable whole-file residual on the specs track: mixed EN/PT requirement and scenario prose (upgrade MERGE classification, HYBRID bootstrap warning, COPY classify label, dry-run/apply header, approval checkbox). It fits budgets (≤4 files / ≤350–400 LOC for the primary surface), passes whole-file G-PT on apply, and is disjoint from active `translate-*` ownership and open translate PRs #78 / #84 / #93–#104. Canonical guide and aula-05 remain deferred (mid-file G-PT / over LOC).

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Companion mechanical literal updates (same apply; contract parity with live scripts — not full script i18n waves):
  - `sdd-kit/upgrade.sh` — approval marker / related ERROR strings currently matching `[x] Actualização aprovada` → English equivalent (e.g. `[x] Upgrade approved`); keep behavior identical
  - `sdd-kit/templates/scripts/bootstrap-sdd.sh` — HYBRID coexistence WARN strings (and residual PT echo lines in that template) → English; regenerate checksums via `bash sdd-kit/gen-manifest-checksums.sh`
  - `scripts/bootstrap-sdd.sh` — sync hub copy with the English template (including HYBRID detect/warn block already present in the template)
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, script names, MANIFEST keys such as `merge:` / `COPY` / `MERGE`, header strings `SDD UPGRADE REPORT (dry-run)` / `SDD UPGRADE APPLY`, fenced shell, brand/tool names, OpenSpec `MUST`/`WHEN`/`THEN` keywords)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/templates/scripts/bootstrap-sdd.sh,scripts/bootstrap-sdd.sh` before marking tasks done (upgrade.sh intentionally omitted from G-PT `--files` because residual PT scaffold/report chrome outside the approval marker is out of this slice; dedicated gates assert the EN approval marker)

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed residual-PT install-kit capability spec MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; quoted runtime contracts that this spec asserts (upgrade approval marker; HYBRID bootstrap WARN) MUST use English literals and MUST stay byte-aligned with `sdd-kit/upgrade.sh` / bootstrap scripts. Normative semantics of `sdd-install-kit` MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md`; companion: `sdd-kit/upgrade.sh`, `sdd-kit/templates/scripts/bootstrap-sdd.sh`, `scripts/bootstrap-sdd.sh`; mechanical: `sdd-kit/MANIFEST.yaml` checksums only; optional: `doc/i18n/GLOSSARY.md`
- Dependencies: none for propose; apply is path-disjoint from `translate-specs-wave-1` targets (infra ✅ — `verify-i18n-wave.sh` / `gen-manifest-checksums.sh` already registered)
- Risks: G-PT false positives; G-INV if MANIFEST keys rewritten; approval-marker / WARN drift if scripts not updated with the spec; G-MANIFEST if checksums skipped after template edit
- **Non-goals:** specs owned by `translate-specs-wave-1`; full i18n of `upgrade.sh` UPGRADE_REPORT scaffold beyond the approval marker / ERROR lines needed for contract parity; other already-EN specs; `openspec/changes/archive/`; canonical guide; skills/commands; kit design templates; hub `openspec/infra.md`; evaluations; design docs; course; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/bootstrap semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/templates/scripts/bootstrap-sdd.sh,scripts/bootstrap-sdd.sh
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST** (template bootstrap touched), **G-OPENSPEC**.  
N/A this wave: **G-MIRROR**, **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `upgrade.sh --dry-run` COPY vs APPLY labeling; HYBRID bootstrap warning when `package.json` + `openspec/` coexist; dry-run vs apply header distinction + EN approval checkbox before `--apply`).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable (except intentional EN contract string updates listed above)
- [ ] Paths (`sdd-kit/`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `MANIFEST.yaml`, `UPGRADE_REPORT.md`), change-ids, `/opsx:*`, MANIFEST `merge:` values (`COPY` / `MERGE`), OpenSpec keywords (`MUST`/`WHEN`/`THEN`) untouched as identifiers
- [ ] Normative outcomes unchanged (no curated overwrite without `--apply` + approval; MERGE preserves local upgrade-diff; HYBRID warning is advisory non-fatal; COPY label not `APPLY_TEMPLATE`) — language only
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links / cross-spec references still resolve (G-LINK)
- [ ] After template edit: `bash sdd-kit/gen-manifest-checksums.sh` + kit verify

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-specs-wave-2

Change: openspec/changes/translate-specs-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/templates/scripts/bootstrap-sdd.sh,scripts/bootstrap-sdd.sh
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
