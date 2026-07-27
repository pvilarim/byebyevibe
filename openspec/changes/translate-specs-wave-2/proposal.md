**Issue:** —

## Why

`translate-specs-wave-1` (open DRAFT PR #104) owns residual Portuguese in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`. The deferred residual-PT capability spec that still fits wave budgets is `openspec/specs/sdd-install-kit/spec.md` (~292 LOC / 1 file): mixed EN/PT requirement and scenario prose (bootstrap HYBRID warning, upgrade dry-run COPY label, upgrade header mode, approval checkbox contract). Completing this slice keeps `openspec/specs/` residual-PT work moving without waiting for wave-1 merge (disjoint paths).

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/specs/sdd-install-kit/spec.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, script names, fenced shell, brand/tool names, OpenSpec `MUST`/`WHEN`/`THEN` keywords, MANIFEST keys such as `merge: COPY` / `merge: MERGE`) byte-stable
- **Hard freeze (script contract):** the literal approval marker `[x] Actualização aprovada` MUST remain unchanged — `sdd-kit/upgrade.sh` greps this exact substring before `--apply`. Surrounding prose may be English; the checkbox token itself is allowlisted residual PT for G-PT (document exception in apply notes if the deny-list still flags it; prefer quoting the freeze form and translating only narrative around it)
- Translate residual PT requirement/scenario prose (bootstrap warning scenarios; upgrade COPY label / header mode requirements; any other deny-list hits) so whole-file G-PT passes aside from documented freeze allowlist tokens
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution except documented freeze-list / script-contract tokens; dual-file siblings forbidden; freeze-list tokens preserved. Normative semantics of `sdd-install-kit` MUST NOT change beyond language.

## Impact

- Files modified: `openspec/specs/sdd-install-kit/spec.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered). Path-disjoint from active `translate-*` on base and open translate PRs #78 / #84 / #93–#104 (wave-1 owns other specs; install-kit explicitly deferred there)
- Risks: G-PT false positives on the frozen `[x] Actualização aprovada` marker and path segments; G-INV if script/MANIFEST tokens rewritten; accidental semantic drift of upgrade/bootstrap/install contracts (language only); breaking `--apply` if the approval checkbox substring is “translated”
- **Non-goals:** specs owned by `translate-specs-wave-1`; already-EN specs; `openspec/changes/archive/`; canonical guide; skills/commands; kit templates (including `sdd-kit/templates/doc/design/`); hub `openspec/infra.md`; evaluations; design docs; course aulas / scripts; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install/upgrade/bootstrap semantics or rewriting `sdd-kit/upgrade.sh` strings in this language wave — language only on the listed spec path

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

If G-PT fails solely on the frozen `[x] Actualização aprovada` substring, document the allowlist exception in the apply PR and keep the token byte-stable (do **not** change `upgrade.sh` in this wave). Prefer narrative EN that still embeds the exact freeze string in backticks/code spans where the gate still flags bare prose.

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `upgrade.sh --dry-run` vs `--apply` + approval checkbox; bootstrap HYBRID warning when `package.json` + `openspec/` coexist; MANIFEST `merge: COPY` dry-run label).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`sdd-kit/install.sh`, `sdd-kit/upgrade.sh`, `sdd-kit/MANIFEST.yaml`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `doc/sistema-sdd-pedro.md`, `openspec/specs/`), change-ids, `/opsx:*`, MANIFEST keys (`merge:`, `sha256:`, `gate:`), OpenSpec keywords untouched as identifiers
- [ ] Literal `[x] Actualização aprovada` (and scaffold wording that `upgrade.sh` emits/greps) untouched
- [ ] Normative outcomes unchanged (dry-run vs apply; MERGE vs COPY; path-traversal block; profile APP/DOCS_SPECS/HYBRID) — language only
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — install kit / upgrade / fail-closed / wave already seeded)
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
Freeze: keep `[x] Actualização aprovada` byte-stable (upgrade.sh grep contract)
```
