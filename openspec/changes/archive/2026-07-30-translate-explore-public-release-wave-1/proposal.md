**Issue:** —

## Why

WAv, WSk, WRu/commands, kit-design, specs, curso waves 1–5, and explore-oss-wave-1 already own (or propose to own) their path slices. The next high-value completable whole-file residual on the WAr/active-changes track is `openspec/changes/explore-public-release-surface/research.md` (~314 LOC, ~98 deny-list hits) — an active explore artifact still in Portuguese, within ≤4 files / ≤350–400 LOC, and disjoint from every open `translate-*` propose PR (including #108 explore-oss).

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** (same path) in:
  - `openspec/changes/explore-public-release-surface/research.md`
- Preserve explore decisions (F1–F7), change-id links (`add-english-docs-policy`, `add-root-changelog`, …), freeze-list tokens, URLs, brand/tool names, and i18n methodology outcomes (EN-default, in-place substitution, dual-file forbidden)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-public-release-surface/research.md` before marking tasks done

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — the listed active explore research surface MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved; explore decision outcomes (F1–F7) MUST keep the same meaning after label language is normalized.

## Impact

- Files modified: `openspec/changes/explore-public-release-surface/research.md` (optional: `doc/i18n/GLOSSARY.md` if new terms)
- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; path not owned by active `translate-*` on base or open translate PRs #78 / #84 / #93–#108)
- Risks: G-PT false positives on quoted historical PT / proper nouns; G-INV if change-ids rewritten; accidental semantic drift of Adopted vs Deferred vs Discarded decisions (language only)
- **Non-goals:** sibling explore research (`explore-oss-coverage-gaps` owned by open PR #108; `explore-adversarial-sdd-review` over budget); other active `openspec/changes/*/design.md|proposal.md|tasks.md` still in PT; `openspec/changes/archive/`; canonical guide; curso `aula-05` / design `001` (over budget); kit templates; dual-file `*.en.md` / `*-pt.md`; global G-DoD; changing F1–F7 decisions — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-public-release-surface/research.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A this wave: **G-MIRROR** (not skill/command mirrors), **G-MANIFEST** (no `sdd-kit/templates/`), **G-DoD** (global — later).

**G-SMOKE (advisory):** human confirms 3 critical procedures remain executable from the EN text (e.g. F2 EN-default + substitution waves ready for propose; F7 chat MAY pt-BR / artifacts MUST EN; F6 `.gitignore` of specs discarded as privacy strategy).

## Freeze / allowlist checklist

- [ ] Shell/CI fences and backticked commands byte-stable
- [ ] Paths, change-ids (`add-english-docs-policy`, `add-root-changelog`, `explore-public-release-surface`, …), `/opsx:*`, package pins, URLs, brand/tool names untouched
- [ ] Decision outcomes F1–F7 unchanged (only label language / surrounding prose)
- [ ] Glossary forms used; new terms added to `GLOSSARY.md` (none expected — evaluation/Adopted/Deferred/wave/glossary already seeded)
- [ ] No dual-file EN/PT siblings introduced
- [ ] Relative / absolute links and change-id references still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply translate-explore-public-release-wave-1

Change: openspec/changes/translate-explore-public-release-wave-1/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-public-release-surface/research.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
