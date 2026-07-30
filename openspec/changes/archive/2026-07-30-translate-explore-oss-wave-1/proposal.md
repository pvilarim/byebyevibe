**Issue:** —

## Why

WAv, WSk, WRu/commands, kit-design, specs, and curso waves 1–5 already own (or propose to own) their path slices. The next high-value completable whole-file residual is the WAr/active-changes track: `openspec/changes/explore-oss-coverage-gaps/research.md` (~245 LOC, ~44 deny-list hits) — an active explore artifact still in Portuguese, within ≤4 files / ≤350–400 LOC, and disjoint from every open `translate-*` propose PR.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/changes/explore-oss-coverage-gaps/research.md`
- Preserve explore decisions (Adopt / do not add / defer), gap ids (G1–G6), change-id links, package pins, URLs, and tool/brand names
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/research.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed active explore research surface MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; explore recommendation outcomes MUST keep the same meaning after label language is normalized.

## Impact

- Files modified: `openspec/changes/explore-oss-coverage-gaps/research.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path not owned by active `translate-*` on base or open translate PRs #78 / #84 / #93–#107)
- Risks: G-PT false positives on quoted historical PT / tool names; G-INV if change-ids or pins rewritten; accidental semantic drift of Adopt vs do-not-add recommendations (language only)
- **Non-goals:** sibling explore research (`explore-public-release-surface`, `explore-adversarial-sdd-review`); other active `openspec/changes/*/design.md|proposal.md|tasks.md` still in PT; `openspec/changes/archive/`; canonical guide; curso `aula-05` / design `001` (over budget); kit templates; dual-file `*.en.md` / `*-pt.md`; global G-DoD; changing gap recommendations — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/research.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. honor G2 Probity Adopt path; do not add G3 error-tracking to kit core; do not adopt G6 multi-agent orchestration now).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids (`add-probity-tdd-module`, `explore-oss-coverage-gaps`, …), `/opsx:*`, package pins (`@nizos/probity@…`), URLs, brand/tool names untouched
- [ ] Gap recommendation outcomes unchanged (only label language / surrounding prose)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — evaluation/Adopted/Deferred/wave already seeded; `correcção manual` → manual fix already in glossary)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative / absolute links and change-id references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-explore-oss-wave-1

Change: openspec/changes/translate-explore-oss-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/research.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
