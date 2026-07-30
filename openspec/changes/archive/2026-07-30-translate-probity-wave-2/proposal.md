**Issue:** —

## Why

Wave-1 (`translate-probity-wave-1`, open DRAFT PR #117) owns the in-budget half of the completed-change package `add-probity-tdd-module` (proposal + tasks + `piloto-nota.md`). The deferred sibling `design.md` (~292 LOC / 1 file / residual Portuguese) is the next completable whole-file residual on the WAr/active-changes track — within ≤4 files / ≤350–400 LOC, and path-disjoint from every open `translate-*` propose PR and active base ownership.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/changes/add-probity-tdd-module/design.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, package pin `@nizos/probity@1.10.0`, `enforceTdd`, `forbidCommandPattern`, `requireCommand`, URLs, brand/tool names, fenced shell, MANIFEST keys, decision IDs D1–D10, A–E matrix labels, pilot PENDING semantics) byte-stable aside from intentional non-i18n fixes
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-probity-tdd-module/design.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the `add-probity-tdd-module` design artifact MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; historical design decisions (Probity over TDD Guard, mode B in-band, `probity.config.ts` template, `install-probity-module.sh`, PreToolUse stacking, Cursor IDE support status, A–E matrix, 6-point registry, lint gap, optional `probity-guard` skill, quantified pilot before MANIFEST bump) MUST keep the same meaning after prose is normalized.

## Impact

- Files modified: `openspec/changes/add-probity-tdd-module/design.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path not owned by active `translate-*` on base or open translate PRs #84 / #93–#117 — wave-1 owns proposal/tasks/piloto-nota only)
- Risks: G-PT false positives on quoted historical PT / path segments; G-INV if change-ids/pins/`enforceTdd` rewritten; accidental semantic drift of pilot-pending / stacking / profile-SKIP decisions (language only)
- **Non-goals:** wave-1 paths (`proposal.md`, `tasks.md`, `piloto-nota.md` — owned by PR #117); delta specs under `openspec/changes/add-probity-tdd-module/specs/` (already EN / 0 deny hits); other completed-change packages already owned by open PRs; `openspec/changes/archive/`; canonical guide; curso `aula-05` / design `001` / `explore-adversarial` / discovery `research.md` (over budget); kit templates; dual-file `*.en.md` / `*-pt.md`; global G-DoD; re-opening Probity product decisions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/add-probity-tdd-module/design.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. Probity pin + `enforceTdd` PreToolUse; APP/HYBRID install / DOCS_SPECS SKIP; quantified pilot before MANIFEST bump).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids (`add-probity-tdd-module`, `explore-oss-coverage-gaps`, `translate-probity-wave-1`, …), `/opsx:*`, pin `@nizos/probity@1.10.0`, rule identifiers (`enforceTdd`, `forbidCommandPattern`, `requireCommand`), MANIFEST keys, URLs, brand/tool names untouched
- [ ] Decision IDs (D1–D10) and A–E matrix labels remain structurally intact (prose language only)
- [ ] Pilot PENDING / quantified-pilot-before-MANIFEST, mode B stacking, profile SKIP, and 6-point registry semantics unchanged
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — Session Handoff / gate / change / wave / evaluation already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links and change-id references still resolve (G-LINK)
- [ ] Path basename `piloto-nota.md` (wave-1) not edited by this wave

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-probity-wave-2

Change: openspec/changes/translate-probity-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/add-probity-tdd-module/design.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
