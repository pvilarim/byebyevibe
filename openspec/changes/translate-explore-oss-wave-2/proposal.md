**Issue:** —

## Why

Wave-1 of the explore-oss track (`translate-explore-oss-wave-1`, open propose PR #108) owns `openspec/changes/explore-oss-coverage-gaps/research.md`. The sibling methodology artifact `metodologia-insercao.md` (~182 LOC, ~51 deny-list hits) remains residual Portuguese — a completable whole-file slice within ≤4 files / ≤350–400 LOC, disjoint from every owned path on base and open translate propose PRs.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`
- Preserve methodology phases (0–5), verification ids (V1–V5, F1–F5), 6-point registry (R1–R6), activation modes (A–D), A–E task matrix, tool/gap links (G1–G8), change-id links, paths, URLs, and brand/tool names
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed explore-oss methodology surface MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; methodology phase structure and registry contract MUST keep the same meaning after label language is normalized.

## Impact

- Files modified: `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none for propose; apply is independent of `translate-explore-oss-wave-1` merge (disjoint files). Infra ✅ — `verify-i18n-wave.sh` already registered. Path not owned by active `translate-*` on base or open translate PRs #84 / #93–#115
- Risks: G-PT false positives on quoted historical PT / proper nouns; G-INV if change-ids or paths rewritten; accidental semantic drift of phase order, pilot exception, or 6-point registry (language only)
- **Non-goals:** `research.md` (owned by wave-1 / PR #108); sibling explores (`explore-public-release-surface`, `explore-adversarial-sdd-review`); other active `openspec/changes/*/design.md|proposal.md|tasks.md` still in PT; `openspec/changes/archive/`; canonical guide; curso `aula-05` / design `001` (over budget); kit templates; dual-file `*.en.md` / `*-pt.md`; global G-DoD; changing methodology decisions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. Phase 0 pre-checks before propose; 6-point registry after approve; Probity remains the only in-band automatic activation).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids (`explore-oss-coverage-gaps`, `add-probity-tdd-module`, `add-sdd-ci-gates-workflow`, …), `/opsx:*`, package pins, URLs, brand/tool names untouched
- [ ] Phase structure (0–5), verification ids, registry R1–R6, modes A–D, and A–E matrix outcomes unchanged (only label language / surrounding prose)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — evaluation/Adopted/Deferred/wave/Session Handoff already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative / absolute links and change-id references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-explore-oss-wave-2

Change: openspec/changes/translate-explore-oss-wave-2/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
