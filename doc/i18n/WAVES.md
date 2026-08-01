# PT→EN substitution waves (inventory + order)

> Capability: `sdd-docs-language` · Layer 1 policy ships as W0 (`add-english-docs-policy`).  
> Later waves: one OpenSpec change per slice — `translate-<surface>-wave-N`.  
> Dual-file `*.en.md` / `*-pt.md` is **forbidden**. Substitute **in-place**.

## Wave budgets (normative)

| Limit | Value |
|-------|-------|
| LOC substituted per wave | ≤ **350–400** |
| Files touched | ≤ **4**, OR 1 logical skill × Cursor + Claude mirrors (= 2 files) |
| Skills | **1** logical skill per wave (both mirrors in the same wave) |
| Slice DoD | **Zero** residual Portuguese prose in files touched by the wave |
| Session | 1 apply session; if approaching the limit → stop + Session Handoff |

If a surface exceeds the budget, split into multiple `translate-*-wave-N` changes.

## LOC inventory (order of magnitude, 2026-07-26)

| Surface | ~LOC / N | Risk if one session |
|---------|----------|---------------------|
| `doc/byebyevibe-guide.md` | ~2847 | Critical — overflow |
| Mirrored skills | ~2922 total | Critical if batched |
| `doc/avaliacoes/` | ~523 | Medium |
| `AGENTS.md` + rules prose | ~300 | Low–medium |
| `sdd-kit/templates/*.md` | 11 files | Medium + checksums |
| `doc/curso/` | large | Medium (volume) — own waves |
| `README.md` | ~129 | Already EN |
| `openspec/specs/` | — | Residual PT only (majority EN) |

## In-scope vs out-of-scope

| Surface | Scope | Notes |
|---------|-------|-------|
| Canonical guide, `AGENTS.md`, rules, skills, commands, kit templates/READMEs | **In** | Core |
| `doc/avaliacoes/`, `doc/design/` | **In** | |
| `doc/curso/` | **Out** (human decision 2026-07-28) | Workshop transcripts — do **not** propose/apply `translate-curso-*`; open curso propose PRs may be closed without apply |
| `openspec/specs/` | **In** (residual PT only) | Do not rewrite already-EN specs |
| Active `openspec/changes/<id>/` still in PT | **In** | Theme wave or active-changes wave |
| `openspec/changes/archive/` | **Out** | Immutable history — do not rewrite for language |
| Quotes, proper names, URLs, freeze-list tokens | Allowlist | See `GLOSSARY.md` |

## Suggested wave order

```
W0   Policy (EN=default, inventory, gates) — no mass substitution  ← this change
W1   AGENTS.md + openspec/project.md + CLAUDE.md + rules prose (.mdc)
W2   sdd-kit/README.md + kit AGENTS.* / infra templates (+ checksums)
W3+  Canonical guide by section (install → pipelines → rules → annexes)
WSk  Skills /opsx:* and reviews — one logical skill per wave (×2 mirrors)
WRu  Remaining rules / commands mirrors
WAv  Evaluations + TEMPLATE (substitute PT)
WCu  doc/curso/ — OUT (human decision); skip translate-curso-*
WAr  openspec/changes/archive/** — OUT; active PT changes → theme or active-changes wave
WCh  Root CHANGELOG.md (F3 — separate change `add-root-changelog`)
WDoD Global residual-PT scan fail-closed on in-scope surfaces
```

**Global Definition of Done:** residual Portuguese prose ≈ 0 on all in-scope surfaces, verified by `bash scripts/verify-i18n-wave.sh --dod`. Policy archive alone does **not** satisfy DoD.

## Verification gates

Script: `scripts/verify-i18n-wave.sh`

| Gate | Role |
|------|------|
| G-INV | Freeze-list / invariant tokens not “translated” |
| G-GLOSS | Glossary canonical forms (spot-check) |
| G-PT | Portuguese prose deny-list on wave files |
| G-LINK | Relative markdown links resolve for touched files |
| G-MIRROR | `.cursor` ↔ `.claude` skill/command pairs stay in sync |
| G-MANIFEST | Touched `sdd-kit/templates/` → checksums / kit integrity |
| G-OPENSPEC | `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict` |
| G-DoD | Global residual-PT scan over in-scope globs (`--dod`) |
| G-SMOKE | **Advisory** — human marks 3 critical procedures executable from EN text (not automated in Layer 1) |

### How to run

```bash
# Per-wave (list every file touched by the wave)
bash scripts/verify-i18n-wave.sh --files path/a.md,path/b.md

# Global Definition of Done (after all in-scope waves)
bash scripts/verify-i18n-wave.sh --dod

# Usage
bash scripts/verify-i18n-wave.sh --help
```

Deny-list tokens for G-PT / G-DoD live in the script header and are documented under **PT deny-list** below. Allowlist / freeze notes: `GLOSSARY.md`.

### In-scope globs for G-DoD

When `--dod` runs, scan these surfaces (exclude `openspec/changes/archive/`):

- `AGENTS.md`, `CLAUDE.md`, `README.md`
- `.cursor/rules/**/*.mdc`, `.cursor/skills/**/*.md`, `.cursor/commands/**/*.md`
- `.claude/skills/**/*.md`, `.claude/commands/**/*.md`
- `doc/byebyevibe-guide.md`, `doc/avaliacoes/**/*.md`, `doc/design/**/*.md`
- _(excluded from G-DoD)_ `doc/curso/**` — out of language scope per human decision
- `doc/i18n/**/*.md` (policy docs — EN; `GLOSSARY.md` exempt from G-PT/G-DoD because it stores legacy→EN rows)
- `sdd-kit/README.md`, `sdd-kit/templates/**/*.{md,mdc}`
- `openspec/project.md`, `openspec/infra.md`, `openspec/specs/**/*.md`
- Active `openspec/changes/*/proposal.md` (and sibling artifacts) **excluding** `openspec/changes/archive/`

### PT deny-list (high-signal)

Curated function words and SDD vocabulary still commonly left in Portuguese. The authoritative regex lives in `scripts/verify-i18n-wave.sh` (`PT_DENY_REGEX` in the script header). False positives: document allowlist exceptions per wave. Do not paste raw deny-list tokens into migrated EN docs (they would fail G-PT).

## Proposal template

Use `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` when proposing `translate-*-wave-N`.

## Cursor Automations / Cloud Agents

Operator playbook for batching wave **propose** / **apply** with Cursor Automations (parallel disjoint proposes, merge vs apply gates, copy-paste prompts): [`CURSOR-AUTOMATIONS.md`](./CURSOR-AUTOMATIONS.md).
