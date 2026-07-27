**Issue:** —

## Why

WCu proposes (open DRAFT PRs #99–#103) own workshop aulas 01–04 and `doc/curso/scripts/AGENTS.md`. The next completable whole-file residual that fits budgets and avoids mid-file guide G-PT is residual Portuguese prose inside active capability specs: `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination` (~357 LOC / 3 files). `sdd-install-kit` (~292 LOC) is deferred to `translate-specs-wave-2`. Dense aula-05 (~503) remains deferred pending a split strategy.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `openspec/specs/sdd-ci-gates/spec.md`
  - `openspec/specs/sdd-post-install-verification/spec.md`
  - `openspec/specs/sdd-session-coordination/spec.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, workflow names, package pins, script names, fenced shell, brand/tool names, OpenSpec `MUST`/`WHEN`/`THEN` keywords) byte-stable
- Translate residual PT requirement/scenario prose (and Purpose where still PT) so G-PT passes on each whole file
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-ci-gates/spec.md,openspec/specs/sdd-post-install-verification/spec.md,openspec/specs/sdd-session-coordination/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed residual-PT capability specs MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved. Normative semantics of `sdd-ci-gates` / `sdd-post-install-verification` / `sdd-session-coordination` MUST NOT change beyond language.

## Impact

- Files modified: the three `openspec/specs/**/spec.md` paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; paths not owned by active `translate-*` changes or open translate PRs #78 / #84 / #93–#103)
- Risks: G-PT false positives on allowlisted path segments; G-INV if script/workflow names rewritten; accidental semantic drift of CI fail-closed / post-install / session-lock requirements (language only)
- **Non-goals:** `openspec/specs/sdd-install-kit/spec.md` (deferred wave-2); other already-EN specs; `openspec/changes/archive/`; canonical guide; skills/commands; kit templates; hub `openspec/infra.md`; evaluations; design docs; course aulas / scripts; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing gate/lock/verification semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-ci-gates/spec.md,openspec/specs/sdd-post-install-verification/spec.md,openspec/specs/sdd-session-coordination/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. `sdd-gates` fail-closed vs report-only `sdd-kit verify`; post-install checklist expectations for `AGENTS.md` / `openspec/project.md` / `openspec/infra.md`; `sdd-session-check` / worktree lock semantics).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths (`.github/workflows/sdd-gates.yml`, `sdd-kit/`, `scripts/sdd-session-*.sh`, `.sdd/runtime/`, `openspec/specs/`), change-ids, `/opsx:*`, Action pins, workflow step names, OpenSpec keywords (`MUST`/`WHEN`/`THEN`) untouched as identifiers
- [ ] Normative outcomes unchanged (fail-closed vs report-only; lock per worktree; post-install MUST checks) — language only
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — gate / Session Handoff / fail-closed / worktree already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links / cross-spec references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-specs-wave-1

Change: openspec/changes/translate-specs-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-ci-gates/spec.md,openspec/specs/sdd-post-install-verification/spec.md,openspec/specs/sdd-session-coordination/spec.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
