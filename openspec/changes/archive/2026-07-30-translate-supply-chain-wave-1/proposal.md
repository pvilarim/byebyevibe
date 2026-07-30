**Issue:** —

## Why

Completed-change packages still in Portuguese on the WAr/active-changes track include `add-supply-chain-gates` (~496 LOC across proposal/design/tasks + delta spec — over the ≤350–400 LOC budget as one wave). The next high-value completable whole-file residual is an explicit **split**: proposal + tasks + `specs/sdd-ci-gates/spec.md` (~200 LOC, 3 files, residual Portuguese), disjoint from every open `translate-*` propose PR and active base ownership. `design.md` (~292 LOC) is deferred to `translate-supply-chain-wave-2`.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same paths) in:
  - `openspec/changes/add-supply-chain-gates/proposal.md`
  - `openspec/changes/add-supply-chain-gates/tasks.md`
  - `openspec/changes/add-supply-chain-gates/specs/sdd-ci-gates/spec.md`
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, workflow/action SHAs, package pins, URLs, brand/tool names, fenced shell, MANIFEST keys, checklist completion markers `[x]`) byte-stable aside from intentional non-i18n fixes
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-supply-chain-gates/proposal.md,openspec/changes/add-supply-chain-gates/tasks.md,openspec/changes/add-supply-chain-gates/specs/sdd-ci-gates/spec.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed active-change artifacts for `add-supply-chain-gates` (proposal, tasks, sdd-ci-gates delta) MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; historical apply outcomes (Renovate + OSV templates, profile SKIP rules, fail-closed OSV when lockfile present, 6-point registry, G8 → Adopted, pilot exception for OSV CI step) MUST keep the same meaning after prose is normalized.

## Impact

- Files modified: the three `add-supply-chain-gates` artifact paths above (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; paths not owned by active `translate-*` on base or open translate PRs #84 / #93–#113)
- Risks: G-PT false positives on quoted historical PT / path segments; G-INV if change-ids/action SHAs/workflow names rewritten; accidental semantic drift of Renovate profile policy or OSV fail-closed contract (language only)
- **Non-goals:** `openspec/changes/add-supply-chain-gates/design.md` (deferred to `translate-supply-chain-wave-2`); sibling `specs/sdd-supply-chain/spec.md` under the change (already EN / 0 deny hits); other completed-change PT packages (`add-probity-tdd-module`, discovery research); `openspec/changes/archive/`; canonical guide; curso `aula-05` / design `001` (over budget); kit templates; dual-file `*.en.md` / `*-pt.md`; global G-DoD; re-opening supply-chain product decisions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/add-supply-chain-gates/proposal.md,openspec/changes/add-supply-chain-gates/tasks.md,openspec/changes/add-supply-chain-gates/specs/sdd-ci-gates/spec.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. OSV blocking when lockfile present; Renovate SKIP on DOCS_SPECS; G8 Adopted / Renovate manual app activation note).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids (`add-supply-chain-gates`, `explore-oss-coverage-gaps`, …), `/opsx:*`, action SHAs, workflow names, MANIFEST keys (`merge:`, `gate:`, `sha256:`), URLs, brand/tool names untouched
- [ ] Historical task completion markers `[x]` and Gate/Pattern lines remain structurally intact (prose language only)
- [ ] Renovate profile SKIP, OSV fail-closed-when-lockfile, G8 → Adopted, and pilot-exception semantics unchanged
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — Session Handoff / gate / change / wave / evaluation already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative links and change-id references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-supply-chain-wave-1

Change: openspec/changes/translate-supply-chain-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/add-supply-chain-gates/proposal.md,openspec/changes/add-supply-chain-gates/tasks.md,openspec/changes/add-supply-chain-gates/specs/sdd-ci-gates/spec.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
