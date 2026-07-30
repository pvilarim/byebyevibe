**Issue:** —

## Why

Wave-1 (`translate-supply-chain-wave-1`, open DRAFT PR #114) owns the in-budget half of the completed-change package `add-supply-chain-gates` (proposal + tasks + `specs/sdd-ci-gates/spec.md`). The deferred sibling `design.md` (~292 LOC / 1 file / residual Portuguese) is the next completable whole-file residual on the WAr/active-changes track — within ≤4 files / ≤350–400 LOC, and path-disjoint from every open `translate-*` propose PR and active base ownership.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/changes/add-supply-chain-gates/design.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, workflow/action SHAs, package pins, URLs, brand/tool names, fenced shell, MANIFEST keys, decision IDs D1–D9, G1 IDs D1–D11) byte-stable aside from intentional non-i18n fixes
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-supply-chain-gates/design.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the `add-supply-chain-gates` design artifact MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; historical design decisions (OSV inside `sdd-gates`, SHA pin, lockfile execution matrix, mode A, profile matrix, Renovate conservative preset, SDD PR classification, optional skill SKIP, Renovate pilot, 6-point registry, rollback) MUST keep the same meaning after prose is normalized.

## Impact

- Files modified: `openspec/changes/add-supply-chain-gates/design.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path not owned by active `translate-*` on base or open translate PRs #84 / #93–#114 — wave-1 owns proposal/tasks/ci-gates delta only)
- Risks: G-PT false positives on quoted historical PT / path segments; G-INV if change-ids/action SHAs/workflow names rewritten; accidental semantic drift of OSV fail-closed / Renovate profile / pilot-exception decisions (language only)
- **Non-goals:** wave-1 paths (`proposal.md`, `tasks.md`, `specs/sdd-ci-gates/spec.md` — owned by PR #114); sibling `specs/sdd-supply-chain/spec.md` (already EN / 0 deny hits); other completed-change PT packages (`add-probity-tdd-module` needs its own split); `openspec/changes/archive/`; canonical guide; curso `aula-05` / design `001` (over budget); kit templates; dual-file `*.en.md` / `*-pt.md`; global G-DoD; re-opening supply-chain product decisions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/add-supply-chain-gates/design.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. OSV inside sdd-gates with SHA pin; Renovate SKIP on DOCS_SPECS / install for APP/HYBRID; rollback by removing OSV step / renovate template).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids (`add-supply-chain-gates`, `explore-oss-coverage-gaps`, `translate-supply-chain-wave-1`, …), `/opsx:*`, action SHAs, workflow names, MANIFEST keys (`merge:`, `gate:`, `sha256:`), URLs, brand/tool names untouched
- [ ] Decision IDs (D1–D9) and G1 compatibility table IDs remain structurally intact (prose language only)
- [ ] OSV fail-closed-when-lockfile, Renovate profile SKIP, mode A, pilot-exception, and 6-point registry semantics unchanged
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — Session Handoff / gate / change / wave / evaluation already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links and change-id references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-supply-chain-wave-2

Change: openspec/changes/translate-supply-chain-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/add-supply-chain-gates/design.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
