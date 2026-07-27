**Issue:** —

## Why

`translate-specs-wave-1` (open DRAFT PR #104) owns residual-PT capability specs `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly defers `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to this wave. That file is the next completable residual on the specs track and fits budgets, but whole-file G-PT cannot pass while the spec still quotes Portuguese **executable contract strings** matched by kit scripts (`[x] Actualização aprovada` in `sdd-kit/upgrade.sh`; HYBRID `WARN: package.json e openspec/…` in `sdd-kit/templates/scripts/bootstrap-sdd.sh`). This wave therefore pairs the install-kit spec PT→EN substitution with a minimal coordinated EN update of those two script literals (plus MANIFEST checksum regen for the touched template) so G-PT can pass without leaving deny-listed Portuguese in the spec.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Coordinated executable-string EN (same apply; semantics unchanged):
  - `sdd-kit/upgrade.sh` — UPGRADE_REPORT scaffold checkbox + `grep` approval gate: PT `Actualização aprovada…` → EN `Upgrade approved…` (exact new literal documented in tasks)
  - `sdd-kit/templates/scripts/bootstrap-sdd.sh` — HYBRID coexistence WARN lines → English equivalents (exact new literals documented in tasks)
  - `sdd-kit/MANIFEST.yaml` — mechanical `sha256:` refresh via `bash sdd-kit/gen-manifest-checksums.sh` after the bootstrap template edit
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, MANIFEST keys `sha256:` / `merge:` / `gate:`, profile labels APP/DOCS_SPECS/HYBRID, fenced shell, brand/tool names, OpenSpec `MUST`/`WHEN`/`THEN`) byte-stable aside from the intentional EN string swaps above
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/upgrade.sh,sdd-kit/templates/scripts/bootstrap-sdd.sh` before marking tasks done (G-MANIFEST applies because a kit template is touched)

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved. Normative install/upgrade/integrity semantics of `sdd-install-kit` MUST NOT change beyond language (including coordinated EN operator-facing contract strings in `upgrade.sh` / kit `bootstrap-sdd.sh`).

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md`, `sdd-kit/upgrade.sh`, `sdd-kit/templates/scripts/bootstrap-sdd.sh`, `sdd-kit/MANIFEST.yaml` (checksums only; optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none for propose; apply independent of `translate-specs-wave-1` apply (disjoint paths). Soft note: wave-1 propose PR #104 names this as the deferred follow-up.
- Risks: G-PT false positives; G-INV if paths/keys rewritten; breaking `upgrade.sh --apply` if scaffold checkbox and grep gate diverge; consumer repos with old PT-approved UPGRADE_REPORT checkboxes need re-approval under the new EN marker; G-MANIFEST if checksums skipped
- **Non-goals:** other already-EN specs; wave-1 three-spec slice; hub `scripts/bootstrap-sdd.sh` (different HYBRID detection today — no matching PT WARN); rewriting remaining Portuguese in unrelated kit scripts; `openspec/changes/archive/`; canonical guide; skills/commands; kit `templates/doc/design/`; hub `openspec/infra.md`; evaluations; design docs; course aulas / scripts; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/integrity **behavior** beyond language of operator-facing strings

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/upgrade.sh,sdd-kit/templates/scripts/bootstrap-sdd.sh
bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-MANIFEST**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `install.sh` integrity abort on sha256 mismatch; `upgrade.sh --dry-run` → mark EN approval checkbox → `--apply`; HYBRID warn when kit bootstrap sees `package.json` + `openspec/`).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable except intentional EN swaps for approval checkbox + HYBRID WARN
- [ ] Paths, change-ids, `/opsx:*`, MANIFEST keys, profile labels, OpenSpec keywords untouched as identifiers
- [ ] `upgrade.sh` scaffold checkbox text and `grep -q` approval pattern stay in sync (same EN literal)
- [ ] Kit bootstrap HYBRID WARN text and install-kit spec scenario string stay in sync
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / gate / fail-closed / wave already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] MANIFEST checksums regenerated after template edit (G-MANIFEST)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-specs-wave-2

Change: openspec/changes/translate-specs-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/upgrade.sh,sdd-kit/templates/scripts/bootstrap-sdd.sh
Infra: openspec/infra.md (assume ✅ — do not reinstall)
Note: after template edit run bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh
```
