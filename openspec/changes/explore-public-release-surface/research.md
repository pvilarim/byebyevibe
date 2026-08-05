# Research — Public surface at launch (visibility + changelog)

| Field | Value |
|-------|-------|
| **Date** | 2026-07-26 (updated 2026-07-26 — EN default + full pt-BR substitution; updated 2026-08-05 — F3/F4 pickup dependency analysis) |
| **Change** | `explore-public-release-surface` (type E — exploration) |
| **Status** | **Ready for propose** — EN = canonical repo language; pt-BR in artifacts = legacy to **substitute** (not permanent bilingual); migration only via policy+waves |
| **Trigger** | Operator requests EN policy / waves propose (public launch or preparation) |
| **Objective** | Record explore decisions on (1) public surface, (2) changelog, and (3) **safe migration to English as default**, with substitution of all versioned Portuguese — without bugs, context loss, wrong terms, or token overflow |
| **Do not do in this explore phase** | No bulk translations, no `CHANGELOG.md`, no repo split, no specs `.gitignore` |
| **Sources** | Explore 2026-07-26; `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` roadmap §11; `doc/sistema-sdd-pedro.md`; discovery design D1/D10; LOC inventory 2026-07-26; human decision: EN = default, substitute all PT terms |

## Executive summary

On a **public** GitHub repo, **it is not possible** to have versioned folders invisible to visitors. Hiding `openspec/` / `doc/` via `.gitignore` breaks the SDD hub (agents, gates, OpenSpec).

**Language decision (2026-07-26):**

| Layer | Language |
|-------|----------|
| **Default / canonical for the repository** | **English** — all new and migrated versioned artifacts |
| **pt-BR in repo files** | **Legacy to eliminate** — substitute in-place by waves until residual ≈ 0 on in-scope surfaces |
| **Pedro ↔ agent conversation** | May continue in **pt-BR** (human speed) — that **does not** authorize writing artifacts in PT |

**Future development:**

1. EN-default policy + **substitution** waves (not “EN layer on top of PT”).
2. Optional root `CHANGELOG.md` EN (F3).
3. Private ops split only if real pain after migration.
4. **Forbidden:** gitignore specs/docs to “hide Portuguese”; permanent dual-file `*.en.md`.

## Problem explored

| Request | Interpretation |
|---------|----------------|
| Specs/folders in the repo but “not visible” | Avoid third parties seeing pt-BR content and the development trail |
| Changelog of main modifications | Stable surface for “what changed” in the project |

## Recorded decision (deferred)

| ID | Item | Decision | When to reopen |
|----|------|----------|----------------|
| F1 | Hide folders in public git | **Do not implement** (impossible without removing from git) | — |
| F2 | Policy **EN = default** + safe **full pt-BR substitution** waves | **Ready for propose** — see § Safe i18n methodology; `add-english-docs-policy` + waves until residual PT ≈ 0 | Operator requests propose / launch |
| F7 | Chat pt-BR vs EN artifacts | **Adopted** — chat MAY pt-BR; **MUST NOT** create/edit docs/skills/specs/templates in PT after policy | — |
| F3 | Root `CHANGELOG.md` (EN, thin) | **Deferred** — future change `add-root-changelog` | Launch / public repo |
| F4 | GitHub Releases mirroring kit versions | **Deferred** — optional together with F3 | **Reopened 2026-08-05** — issue #350; see § F3/F4 pickup |
| F5 | Private ops repo (guide/evaluations/archive) | **Deferred — only if real pain** after F2 | If public surface still feels like “noise” |
| F6 | `.gitignore` of specs/changes/docs | **Discarded** as privacy strategy | New proposal only with strong justification |

## Relation to discovery backlog

```
① README EN                    ✅
②–③ ByeByeVibe + slug          ✅ (manual on GitHub)
④ EN policy + waves            ← F2 (this research; future)
   + root CHANGELOG.md (EN)    ← F3 (this research; future)
⑤ GIF                          Deferred (P5)
⑥ Landing/Discord              Do not implement
```

Detailed i18n inventory: see § AS-IS inventory (below). Translation waves: **forbidden** in the policy change — only after gates exist.

## Safe i18n methodology (crystallized 2026-07-26)

Reframed problem: **English is the default/canonical language of the repository.** pt-BR in versioned files is legacy to **substitute** (in-place), not to maintain in parallel. Still controlled migration (executability + glossary + token budget), but the **Definition of Done** is residual PT ≈ 0 on in-scope surfaces.

```
┌──────────────────────────────────────────────────────────────┐
│  LAYER 1 — POLICY (1 change, 0 bulk substitution)              │
│  EN=default · glossary · PT inventory · gates · wave limits  │
└────────────────────────────┬─────────────────────────────────┘
                             │ green gates
                             ▼
┌──────────────────────────────────────────────────────────────┐
│  LAYER 2 — WAVES (N changes; 1 wave = 1 apply = 1 PR)        │
│  slice · SUBSTITUTE pt→EN same path · verify · commit        │
└────────────────────────────┬─────────────────────────────────┘
                             │ all in-scope waves
                             ▼
┌──────────────────────────────────────────────────────────────┐
│  GLOBAL DoD — residual PT scanner fail-closed (in-scope)       │
└──────────────────────────────────────────────────────────────┘
```

### Principles (MUST)

1. **EN = default repo language.** New artifacts (proposal, design, specs, skills, guide, evaluations, rules prose, kit templates) **MUST** be written in English after the policy.
2. **Substitution, not bilingualism.** Waves **substitute** pt-BR prose with canonical EN on the **same path**. Permanent dual-file `*.en.md` / `*-pt.md` = **forbidden**.
3. **Goal: substitute all PT terms** on in-scope surfaces. Permanent exceptions only with explicit human decision in the spec.
4. **Policy before substituting.** Without glossary + gates + wave limit + PT inventory, migration apply is forbidden.
5. **One wave = one apply session.** Do not stack the entire guide (~2.8k lines) in one session.
6. **Freeze invariants.** Paths, change-ids, slash commands, code/shell fences, file names, pins, MANIFEST keys — **never** “translate”.
7. **Glossary required.** Canonical EN form; inventing synonyms per wave is forbidden.
8. **Translate meaning, not word-for-word.** Ambiguous → `[NEEDS VERIFICATION]`.
9. **Chat ≠ repo (F7).** Pedro ↔ agent conversation **MAY** pt-BR; commits/artifacts **MUST** EN after policy.
10. **Mirrors in sync.** `.cursor/skills/` ↔ `.claude/skills/` (and commands) in the **same wave**.
11. **Kit templates = checksums.** `sdd-kit/templates/` → `gen-manifest-checksums.sh` in the wave.
12. **Fail-closed.** Wave closes only with green gates; no premature N+1.
13. **Features do not wait for 100% EN** — legacy PT only until its wave; migrated file stays EN-only.

### What NOT to translate (freeze list)

| Category | Examples | Why |
|----------|----------|-----|
| Paths / globs | `openspec/changes/`, `sdd-kit/install.sh` | Breaks install and agents |
| Change-ids / branches | `add-english-docs-policy` | Links and `openspec validate` |
| Slash / skills | `/opsx:apply`, `openspec-explore` | Skill discovery |
| Shell / CI | `npx openspec validate`, `bash scripts/…` | Executability |
| Pins / versions | `@fission-ai/openspec@1.3.1` | Supply chain |
| Code identifiers | `enforceTdd`, `MANIFEST.yaml` keys | Runtime |
| Stable EN anchors | RFC headings in specs | Internal links |
| Brand | ByeByeVibe, OpenSpec, GitNexus, Graphify | SEO + identity |

### Glossary

Canonical legacy pt-BR → EN term bank: `doc/i18n/GLOSSARY.md` (seed from this research; expand in the same wave that introduces new terms).

### Wave limits (anti token-overflow)

LOC inventory (2026-07-26):

| Surface | ~LOC | Risk if 1 session |
|---------|------|-------------------|
| `doc/sistema-sdd-pedro.md` | ~2847 | **Critical** — overflow + context loss |
| Skills (mirrors) | ~2922 total | Critical if single batch |
| Evaluations | ~523 | Medium |
| `AGENTS.md` + rules | ~300 | Low–medium |
| `sdd-kit/templates/*.md` | 11 files | Medium + checksums |

**Per-wave budget (proposed normative):**

| Limit | Suggested value | Reason |
|-------|-----------------|--------|
| Source lines to **substitute** | **≤ 350–400** | Fits input + glossary + diff + gates |
| Files touched | **≤ 4** (or 1 skill × 2 mirrors = 2) | Viable human review |
| Guide sections | **1 large `##` section** or **2–3 small** | “On-demand context” (~693 lines) = **≥2 waves** |
| Skills | **1 logical skill** (Cursor + Claude mirror same wave) | Avoid mirror drift |
| Wave close criterion | **Zero residual PT prose** in wave files (deny-list) | Complete slice substitution |
| Duration | 1 apply session; if approaching limit → **stop, partial commit if gates OK, Session Handoff** | |

**Suggested wave order (after policy):**

```
W0  Policy (EN=default, inventory, gates) — no bulk substitution
W1  AGENTS.md + openspec/project.md + CLAUDE.md + rules prose (.mdc)
W2  sdd-kit/README.md + kit AGENTS.* / infra templates (+ checksums)
W3+ Canonical guide by section (install → pipelines → rules → appendices)
WSk /opsx:* and review skills — one logical skill per wave (×2 mirrors)
WRu Remaining rules / commands mirrors
WAv Evaluations + TEMPLATE (substitute PT)
WCu doc/curso/ — in-scope by default (meta “all PT terms”);
    own waves; exception only with human decision in propose
WAr openspec/changes/archive/** — OUT (immutable history);
    active changes still PT → theme wave or active-changes wave
WCh Root CHANGELOG.md (F3 — own change)
WDoD Global residual PT scanner fail-closed in-scope
```

### Verification gates (per wave)

Proposed script: `scripts/verify-i18n-wave.sh` (created in **policy** change; used in each wave).

| Gate | What it verifies | Fails if |
|------|------------------|----------|
| G-INV | Freeze: paths/commands/`opsx`/pins in output = AS-IS | Command or path “translated” |
| G-GLOSS | Glossary canonical form; no invented synonyms | Term outside bank |
| G-PT | PT prose deny-list in wave files (after migration) | Residual deny-list tokens (allowlist: proper nouns, cites) |
| G-LINK | Relative markdown links resolve | Broken link |
| G-MIRROR | `.cursor` ↔ `.claude` pairs equivalent | Only one side changed |
| G-MANIFEST | Templates touched → checksums + `verify.sh` | Stale SHA |
| G-OPENSPEC | `openspec validate --all --strict` | Broken spec |
| G-SMOKE | 3 critical procedures executable from EN text | Pedro marks fail |
| G-DoD | (global close) residual PT scanner on all in-scope | Any remaining PT prose |

**Human review required** on waves: install (§2), R1–R11, session coordination, MANIFEST/install docs.

### File strategy

| Option | Decision |
|--------|----------|
| A — EN **substitutes** PT on same path | **Required** — single source of truth |
| B — dual-file `*.en.md` | **Rejected** |
| C — PT snapshot in branch/tag before wave | Optional for emergency rollback only |

Paths with PT names (`doc/sistema-sdd-pedro.md`, `doc/avaliacoes/`) may **keep the path** until separate rename wave (breaks links) — **content** is already EN. Path rename ≠ policy obligation; own change if desired.

### In-scope surfaces vs exceptions

| Surface | In-scope (substitute PT) | Notes |
|---------|--------------------------|-------|
| Guide, AGENTS, rules, skills, commands, kit templates/READMEs | **Yes** | Core |
| `doc/avaliacoes/`, `doc/design/` | **Yes** | |
| `doc/curso/` | **Yes by default** | High volume — own waves; Pedro may mark exception in propose |
| `openspec/specs/` | Residual PT only | Mostly already EN |
| `openspec/changes/<active>/` | **Yes** if still PT | |
| `openspec/changes/archive/` | **No** | History; do not rewrite |
| Quotes / proper nouns / URLs | Allowlist | Not “terms to translate” |

### Risks and mitigations

| Risk | Mitigation |
|------|------------|
| Token overflow | ≤400 LOC; handoff mid-wave |
| Inconsistent term | Glossary; G-GLOSS |
| LLM “helped” command | G-INV; do not rewrite fences |
| Forgotten residual PT | G-PT per wave + global G-DoD |
| Cursor≠Claude mirror | G-MIRROR |
| Kit checksums | G-MANIFEST |
| Nuance loss | Intent; `[NEEDS VERIFICATION]`; human review |
| Mega-PR | 1 wave = 1 PR; policy ≠ waves |
| Already-EN spec rewritten | Out of waves unless explicit delta |
| “EN default” vs chat pt-BR | F7 explicit in AGENTS.md Communication |

### Scope of `add-english-docs-policy` change (Layer 1)

**Includes:**

- Spec `sdd-docs-language` — **EN = repo default**; new artifacts MUST EN; chat MAY pt-BR; waves MUST substitute (not dual-file); limits + gates; DoD residual PT ≈ 0 in-scope
- `doc/i18n/GLOSSARY.md` — canonical bank
- `doc/i18n/WAVES.md` (or equivalent) — PT inventory + order + in-scope/exceptions
- `scripts/verify-i18n-wave.sh` (+ global DoD mode) — G-INV, G-GLOSS, G-PT, G-LINK, G-MIRROR, G-MANIFEST, G-OPENSPEC
- AGENTS.md / `openspec/project.md` pointers (Communication section: chat vs artifacts)
- `translate-*-wave-N` proposal template (substitution, not “add English layer”)

**Does not include:**

- Bulk substitution of guide / skills / evaluations / curso
- Root `CHANGELOG.md` (F3)
- Rename PT paths (`sistema-sdd-pedro.md` → `…`)
- Rewrite `openspec/changes/archive/`
- Dual-file `*.en.md`

## AS-IS inventory (order of magnitude)

| Path | ~LOC / N | Public priority | Notes |
|------|----------|-----------------|-------|
| `README.md` | ~129 | — | Already EN |
| `doc/sistema-sdd-pedro.md` | ~2847 | High | Waves by section; § “On-demand context” ~693 → multi-wave |
| Mirrored skills | ~2922 | High (opsx) | 1 skill/wave |
| `sdd-kit/templates/*.md` | 11 files | High (consumers) | + checksums |
| `AGENTS.md` / rules | ~300 | High | W1 |
| `doc/avaliacoes/` | ~523 | Medium | After core guide |
| `openspec/specs/` | — | Low | Mostly already EN — do not rewrite |
| `doc/curso/` | large | Medium (volume) | **In-scope** — own waves; exception only if Pedro marks in propose |
| `openspec/changes/archive/` | — | — | **Out** — history |

## Changelog — AS-IS (2026-07-26)

| Surface | Status |
|---------|--------|
| `doc/sistema-sdd-pedro.md` § Guide changelog | ✅ canonical (v1.6.1 …) — pt-BR |
| `sdd-kit/MANIFEST.yaml` `version` | ✅ aligned with guide |
| Root `CHANGELOG.md` | ❌ does not exist |
| GitHub Releases as product changelog | not adopted as process |

## F3/F4 pickup — dependency analysis (2026-08-05)

F4 was reopened as issue #350 ("Assemble GitHub Release flow"), authored as the third of a
3-issue chain: #348 (fail-closed CI gate) → #349 (automated PR review pipeline) → #350. The
chain order was a **proposed** sequence, not a derived one. Question explored: does #350 carry
a real technical dependency on #349?

### D-REL-1 — #349 does **not** block #350

**No input of #350 is produced by #349.** Every input the release flow reads already exists:

| Input needed by #350 | Origin | Produced by #349? |
|----------------------|--------|-------------------|
| Tags `kit-v*` / `guide-v*` | nothing exists yet (`git tag -l` empty) | no |
| Version numbers | `sdd-kit/MANIFEST.yaml` → `version:` / `guide_version:` | no — exists |
| Release-notes body | `doc/byebyevibe-guide.md` → `### X.Y.Z (YYYY-MM-DD)` + bullets | no — exists, already machine-parseable |
| Pre-tag repo-state guard | `scripts/verify-release-readiness.sh` | no — **#348 built exactly this** |
| Kit tarball | `git archive` from the tagged commit | no |
| `permissions: contents: write` | new workflow file | no |

`#349` produces LLM review comments on pull requests plus one real static/executed check. A
release is cut from a commit **already on the default branch** — release tooling has nothing to
query there, and should not re-run PR review.

The chain's stated rationale ("only tag a commit that passed automated review") is a **policy**
claim, not an interface one. Its enforcement point is **branch protection on the default
branch**, not the release script: if the review is a required status check, every commit on
`master` satisfies it by construction.

### D-REL-2 — the substantive prerequisite is #348's unfinished manual step

Issue #348 is closed (PR #352 merged, all `add-release-readiness-gate` code tasks `[x]`), but its
guarantee is **not in effect**. `openspec/changes/add-release-readiness-gate/tasks.md` task 6.1
remains open:

> `[ ] 6.1 [MANUAL ACTION REQUIRED]` After merge, add `Release readiness (blocking)` as a
> required status check under GitHub Settings → Branches for the default branch.

Observable evidence that it is still pending: on PR #352 the `SDD Gates` run was created at
`23:31:31Z` and the PR merged at `23:31:58Z` — 27 seconds. A run with `setup-node`,
`setup-python` and `npx openspec` cannot complete in that window, so the merge landed with CI
still in flight, i.e. no required status check gating it. (Inference from run/merge timestamps —
branch-protection settings were not directly readable from this session.)

**Consequence:** the one prerequisite of #350 with technical substance is a repository-settings
change, not #349. #349 contributes nothing mechanical to #350 and is fully parallelizable.

### D-REL-3 — the only coupling to #349 is conditional on one trigger choice

#350 requires "a recorded decision on how much of this is automated". Only the most automated
option is coupled:

| Trigger model | Depends on #349? |
|---------------|------------------|
| Fully manual | no |
| Push of a matching tag fires the release workflow | no |
| MANIFEST version bump landing on the default branch fires the release | **yes** — auto-releasing from a merge requires the merge to be trustworthy |

Choosing manual or tag-triggered removes #349 from the critical path entirely. This decision can
be taken in the #350 proposal without waiting for #349's design.

### D-REL-4 — real cost of running #349 and #350 in parallel

One, and it is mechanical: both will touch `sdd-kit/MANIFEST.yaml` (`version:`, `guide_version:`,
regenerated checksums) and insert a new entry at the top of `## Guide changelog`. Every kit change
collides there. That is an argument for **serializing the merges** (either order), not evidence of
a dependency.

### D-REL-5 — the two-axis tagging premise is unsupported by history

#350 proposes mirroring MANIFEST's two version axes into two tag namespaces (`kit-vX.Y.Z` from
`version:`, `guide-vX.Y.Z` from `guide_version:`). The two fields have been **identical in every
recorded commit** of `sdd-kit/MANIFEST.yaml` (1.6.1 → 1.11.0, no divergence), and
`## Guide changelog` carries one entry per release covering kit and guide together.

If the axes never diverge, `kit-v1.11.0` and `guide-v1.11.0` always name the same commit with the
same notes — two tags, one release, duplicated body. **To resolve in the #350 proposal:** adopt a
single tag axis until the versions actually diverge, or justify why they will and how the
single-list changelog would be split to feed two release bodies.

## Non-goals of this explore

- Implement bulk substitution, `CHANGELOG.md`, or repo split in this session
- Change MANIFEST / install paths
- Dual-file `*.en.md`
- Rewrite `openspec/changes/archive/`
- Rename paths with PT names (separate change if desired)

## Next step

Explore **complete** for F2 (EN=default + safe full substitution). Open **new chat** (propose phase):

```
/opsx:propose add-english-docs-policy

Scope = Layer 1 (policy), NOT bulk substitution:
- Spec sdd-docs-language: EN = default/canonical repo language;
  new artifacts MUST EN; chat MAY pt-BR (F7);
  waves MUST substitute PT→EN in-place (dual-file forbidden);
  DoD = residual PT ≈ 0 on in-scope surfaces
- doc/i18n/GLOSSARY.md + doc/i18n/WAVES.md (inventory + order + exceptions)
- scripts/verify-i18n-wave.sh (G-INV, G-GLOSS, G-PT, G-LINK, G-MIRROR,
  G-MANIFEST, G-OPENSPEC + global G-DoD mode)
- Per-wave limit: ≤350–400 LOC, ≤4 files, 1 skill×2 mirrors,
  zero residual PT prose in slice
- translate-*-wave-N template (substitution, not “EN layer”)
- In-scope includes doc/curso/ by default; archive/ OUT
- Non-goals of this change: migrate guide/skills/curso now;
  root CHANGELOG (F3); path rename

Read: openspec/changes/explore-public-release-surface/research.md
     (Safe i18n methodology — EN default + substitution)
Evaluation: doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md (P11/P12)
Discovery: openspec/changes/add-sdd-discovery-positioning/research.md §11
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```

After policy archive: waves `/opsx:propose translate-…` — one slice per chat until G-DoD green.

F3 (`add-root-changelog`) remains its own change.

One change per slice (policy vs wave vs changelog); no mega-PR.
