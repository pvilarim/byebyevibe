**Issue:** —

## Why

`translate-specs-wave-1` (open DRAFT PR #104) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly defers `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to wave-2. That capability spec still mixes English Purpose/early requirements with Portuguese requirement bodies and scenarios (bootstrap HYBRID warning, COPY dry-run labels, upgrade `--apply` approval gate). This change substitutes that residual PT **in-place** within wave budgets so install/upgrade contracts remain whole-file G-PT clean.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths, `MANIFEST.yaml` keys including `merge:` / `sha256:` / `gate:`, script names, fenced shell, OpenSpec `MUST`/`WHEN`/`THEN`, brand/tool names) byte-stable
- **Freeze runtime approval marker:** keep the exact substring `[x] Actualização aprovada` (and the matching UPGRADE_REPORT checkbox wording checked by `sdd-kit/upgrade.sh`) byte-stable — document as wave allowlist for G-PT
- Translate residual PT requirement/scenario prose (and any residual PT outside the freeze marker) so surrounding text is English
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done (see allowlist note if G-PT hits only the freeze marker)

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution except the documented freeze/allowlist runtime approval marker; dual-file siblings forbidden; freeze-list tokens preserved. Normative install/upgrade/bootstrap semantics MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path deferred by PR #104 / not owned by other active `translate-*` changes or open translate PRs #78 / #84 / #93–#103 / #104)
- Risks: G-PT on freeze marker `Actualização` (allowlist); G-INV if script/MANIFEST keys rewritten; accidental semantic drift of install/upgrade/bootstrap contracts (language only)
- **Non-goals:** the three specs owned by `translate-specs-wave-1`; already-EN specs; renaming the UPGRADE_REPORT approval checkbox / changing `upgrade.sh` grep (separate runtime change); `openspec/changes/archive/`; canonical guide; skills/commands; kit templates; hub `openspec/infra.md`; evaluations; design docs; course; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing merge/checksum/install semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT** (with documented freeze/allowlist for `[x] Actualização aprovada` if the deny-list still matches that exact runtime marker), **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `install.sh` integrity abort on sha256 mismatch; `upgrade.sh --dry-run` `COPY` label vs `APPLY_TEMPLATE`; `upgrade.sh --apply` requires approved `UPGRADE_REPORT.md` marker).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `UPGRADE_REPORT.md`, `doc/sistema-sdd-pedro.md`), change-ids, `/opsx:*`, MANIFEST keys (`merge:`, `sha256:`, `gate:`), OpenSpec keywords (`MUST`/`WHEN`/`THEN`) untouched as identifiers
- [ ] Runtime approval marker `[x] Actualização aprovada` byte-stable (matches `sdd-kit/upgrade.sh`); wave-specific G-PT allowlist for that exact string only
- [ ] Normative outcomes unchanged (integrity fail-closed, HYBRID warning non-fatal, COPY dry-run label, apply-after-approval) — language only
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
