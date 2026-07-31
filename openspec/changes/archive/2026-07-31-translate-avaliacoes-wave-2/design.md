# Design — translate-avaliacoes-wave-2 (discovery-positioning + UI-module evaluations PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base (exact targets): kit W2c/W2d templates; hub `openspec/infra.md` (`translate-infra-wave-1`); `correctness-review` / `simplify-review` (skills waves 1–2); WAv wave-1 four files (`README`, `TEMPLATE`, Headroom, OSS gaps). Wave-1 explicitly deferred these two sibling records.
- Open translate PRs: kit apply PR #78 owns kit templates only — not these evaluation paths. No open propose PR owns these two files.
- Canonical guide (`doc/sistema-sdd-pedro.md`, ~2847 LOC) remains deferred for mid-file G-PT; factory prefers completable whole-file slices.
- Chosen WAv residual slice (~290 LOC, 2 files): discovery/positioning evaluation + UI-module evaluation — dense residual Portuguese, within ≤4 files / ≤350–400 LOC.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the two listed evaluation files with glossary-canonical English **in-place**.
- Preserve decision outcomes (ByeByeVibe / P1–P4 Adopted surfaces; P5/P6/P7/… Do-not-implement or Deferred rows; UI-module Adopted with Impeccable confirmation semantics).
- Map status vocabulary to glossary EN: Adoptado→Adopted, Descartado→Discarded, Adiado→Deferred, Em avaliação→Under evaluation, Não implementar→Do not implement; avaliação→evaluation where it is prose (not the path).
- Normalize operator cue `[AÇÃO MANUAL]` → `[MANUAL ACTION]` (same EN form as hub infra / prior waves) without changing that the action is human-only.
- Keep path `doc/avaliacoes/` unchanged (freeze until a rename wave).
- Pass `bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md,doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`.

**Non-Goals:**

- Wave-1 evaluation files (owned by `translate-avaliacoes-wave-1`).
- `doc/design/`, course, canonical guide, skills/commands, kit templates, hub infra.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Renaming `doc/avaliacoes/` → `doc/evaluations/`.
- Re-opening product decisions or changing normative install behavior — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist (`avaliação` → evaluation; path until rename)
- `doc/i18n/WAVES.md` — WAv order; ≤4 files / ≤350–400 LOC
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-avaliacoes-wave-1/` — prior WAv propose; deferred these two files
- AS-IS: the two `doc/avaliacoes/` files listed in the proposal
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown evaluations; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = two residual evaluation records (WAv wave-2)

| Option | Verdict |
|--------|---------|
| A — Guide W3 front+§1 partial file | Rejected — G-PT scans whole `--files` paths; residual PT elsewhere in the guide fails the gate |
| B — Bundle `doc/design/002`+`003`+`004` (~385 LOC) | Rejected this slot — still leaves WAv residual; kit mirrors of design docs would need a separate checksum wave if bundled with templates |
| C — Single-file discovery-positioning only | Viable but leaves a tiny sibling (76 LOC) for another propose; better to finish residual avaliacoes records together |
| D — Discovery-positioning + UI-module as `translate-avaliacoes-wave-2` | **Chosen** — 2 files / ~290 LOC; whole-file G-PT achievable; disjoint from wave-1 / kit / infra / skills |

**Rationale:** Completes the remaining WAv whole-file evaluation records deferred by wave-1 within one budget-compliant slice.

### D2: In-place substitution — no dual-file; path segment frozen

**Chosen:** Edit the two paths in place. Forbidden: `*.en.md` / `*-pt.md` siblings; renaming `doc/avaliacoes/`.

**Rationale:** `sdd-docs-language` dual-file prohibition + glossary freeze for path segments until a dedicated rename change.

### D3: Decision labels → glossary EN without outcome drift

**Chosen:** Translate status labels and surrounding prose to English. Do not change which candidates are Adopted vs Deferred vs Do-not-implement. Keep change-id links, research.md pointers, and tool URLs intact.

**Rationale:** Agents must still honor Adopted surfaces and deferred/non-goals; language migration must not look like a re-decision.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that these two evaluation files MUST be English after substitution. Do not invent a new capability in this language wave.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including wave-1).

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Outcome drift (Adopted → looks Deferred) | Tasks forbid changing decision cells/outcomes; only language |
| G-PT false positives on path `avaliacoes` or quoted PT | Path is freeze/allowlist; quotes only when clearly historical |
| Broken relative links after heading renames | Prefer translating headings carefully; G-LINK on touched files |
| Parallel conflict with wave-1 apply | Own only these two paths; wave-1 owns four different files |
| Mixing hub design docs into this wave | Explicit non-goal — design remains later WAv/WDo slices |

## Migration Plan

1. Apply: rewrite the two files EN in-place; freeze paths/change-ids/URLs; map status labels; keep outcomes.
2. Gate: `bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md,doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-avaliacoes-wave-2 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`.

## Open Questions

- None blocking propose. Follow-up factory candidates: `doc/design/` hub slices (optionally paired with kit template mirrors in a checksum-aware apply); residual opsx skill/command stubs; guide whole-file G-PT strategy remains separate.
