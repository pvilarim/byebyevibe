## Context

Propose-factory residual inventory (2026-07-27) after open translate PRs #84 / #93–#118 shows only two completable ≤budget residual-PT files not already owned:

| Path | ~LOC | G-PT deny hits | Residual |
|------|------|----------------|----------|
| `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` | ~70 | 1 | Session Handoff stub: `Ler:` / `assumir ✅ — não reinstalar` |
| `openspec/changes/add-i18n-cursor-automations-guide/proposal.md` | ~41 | 1 | Same stub pattern |

`doc/i18n/CURSOR-AUTOMATIONS.md` §6 already documents the English stub form. Over-budget residuals (canonical guide, `aula-05`, design/kit `001`, `explore-adversarial` research, discovery `research.md`) need a split strategy and are out of this wave.

Constraints: wave budgets ≤4 files / ≤350–400 LOC; in-place only; F7 English versioned artifacts; G-PT scans whole `--files` paths; archive OUT.

## Goals / Non-Goals

**Goals:**

- Substitute the Portuguese Session Handoff stub labels in both listed files to glossary-canonical English matching `CURSOR-AUTOMATIONS.md` §6.
- Keep stub structure (phase command, Change path, Read/Gate/Infra lines) and freeze-list tokens intact.
- Pass `bash scripts/verify-i18n-wave.sh --files doc/i18n/WAVE-PROPOSAL-TEMPLATE.md,openspec/changes/add-i18n-cursor-automations-guide/proposal.md`.

**Non-Goals:**

- Over-budget surfaces listed above (no mid-file guide slice; no research/aula/design `001` without a later split propose).
- Other owned translate slices (#84 / #93–#118 path lists).
- `openspec/changes/archive/`.
- Rewriting `doc/i18n/CURSOR-AUTOMATIONS.md`, `GLOSSARY.md` term bank rows (unless a new term appears), or `WAVES.md` inventory tables.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Skills/commands mirrors; kit templates / G-MANIFEST.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; i18n policy docs in-scope; archive OUT
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — AS-IS stub (target)
- `doc/i18n/CURSOR-AUTOMATIONS.md` — §4.1 propose factory; §6 English Session Handoff stubs
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open PRs #84 / #93–#118 — owned path union
- `openspec/changes/add-i18n-cursor-automations-guide/proposal.md` — AS-IS stub (target)
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown stubs; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = both tiny stub files in one wave

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `aula-05` / design `001` / `explore-adversarial` / discovery `research.md` | Rejected — over ≤350–400 LOC; needs split strategy |
| C — Only `WAVE-PROPOSAL-TEMPLATE.md` | Viable but leaves sibling 1-hit residual for another cron tick |
| D — Both stub files (~111 LOC, 2 files) | **Accepted** — fits budgets; same residual pattern; disjoint from owned set |

### D2: Align stubs to CURSOR-AUTOMATIONS §6 wording

Apply MUST replace Portuguese stub labels with the English forms already normative in §6 (`Read:`, `assume ✅ — do not reinstall`). Do not invent a third stub dialect.

### D3: Template placeholders stay placeholders

In `WAVE-PROPOSAL-TEMPLATE.md`, keep `translate-<surface>-wave-N` and `<paths>` placeholders intact — only translate the Portuguese prose labels around them.

### D4: No kit checksum / mirror work this wave

Targets are an i18n policy template + one active-change proposal — G-MANIFEST and G-MIRROR N/A.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Future proposes keep copying PT stubs until apply merges | Document in Session Handoff; apply ASAP after propose merge |
| Accidental rewrite of placeholder tokens or change-ids | Freeze checklist + G-INV |
| G-PT still fails if other PT tokens exist outside the stub | Inventory shows 1 deny hit each; verify gate before done |
| Idle factory after this wave (only over-budget residuals left) | Expected — next runs no-op until split strategy or new PT scope |

## Migration Plan

1. Propose merges (this PR) — artifacts only under `openspec/changes/translate-i18n-stubs-wave-1/`.
2. Separate `/opsx:apply` run substitutes the two target files in-place.
3. Gate with `verify-i18n-wave.sh --files …` + openspec validate.
4. Archive in a later run after apply merges.
5. Rollback: `git checkout --` the two target paths if apply regresses meaning.

## Open Questions

- None for propose. After this wave applies, propose factory should idle until an over-budget split strategy or new residual scope appears.
