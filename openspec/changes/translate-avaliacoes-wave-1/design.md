# Design — translate-avaliacoes-wave-1 (evaluations index/template + two records PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base: kit W2c/W2d (kit Cursor rules + proposal scaffold), hub `openspec/infra.md` (`translate-infra-wave-1`), `correctness-review` (`translate-skills-wave-1`), `simplify-review` (`translate-skills-wave-2`). None own `doc/avaliacoes/` paths.
- Open translate PRs: kit apply PR #78 owns kit templates only — not evaluations.
- Canonical guide (`doc/sistema-sdd-pedro.md`, ~2847 LOC) remains deferred for mid-file G-PT; factory prefers completable whole-file slices.
- Remaining opsx skills are mostly English (Session Handoff stubs); `openspec-apply-change` (~224×2 ≈ 448 LOC) and `openspec-explore` (~304×2 ≈ 608 LOC) exceed the ≤350–400 LOC budget for a skill×2 wave.
- Chosen WAv slice (~233 LOC, 4 files): README index, TEMPLATE, Headroom discard record, OSS coverage-gaps tooling index — dense residual Portuguese, within ≤4 files / ≤350–400 LOC.
- Deferred same-folder files for later waves: `2026-07-26-sdd-discovery-positioning.md` (~214 LOC), `2026-06-27-sdd-ui-development-module.md` (~76 LOC).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the four listed evaluation files with glossary-canonical English **in-place**.
- Preserve decision outcomes (Headroom remains Discarded; OSS gaps mixed Adopted/Deferred statuses unchanged in meaning).
- Map status vocabulary to glossary EN: Adoptado→Adopted, Descartado→Discarded, Adiado→Deferred, Em avaliação→Under evaluation; avaliação→evaluation where it is prose (not the path).
- Keep path `doc/avaliacoes/` unchanged (freeze until a rename wave).
- Pass `bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/README.md,doc/avaliacoes/TEMPLATE.md,doc/avaliacoes/2026-03-26-headroom-context-compression.md,doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`.

**Non-Goals:**

- Other `doc/avaliacoes/*` files not listed above.
- `doc/design/`, course, canonical guide, skills/commands, kit templates, hub infra.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Renaming `doc/avaliacoes/` → `doc/evaluations/`.
- Re-opening Discarded/Deferred decisions or changing normative specs for those tools — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist (`avaliação` → evaluation; path until rename)
- `doc/i18n/WAVES.md` — WAv order; ≤4 files / ≤350–400 LOC
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-skills-wave-2/` — prior factory propose pattern (deferred WAv there)
- AS-IS: the four `doc/avaliacoes/` files listed in the proposal
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown evaluations; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = four compact evaluation surfaces (WAv entry)

| Option | Verdict |
|--------|---------|
| A — Guide W3 front+§1 partial file | Rejected — G-PT scans whole `--files` paths; residual PT elsewhere in the guide fails the gate |
| B — `openspec-apply-change` skill×2 | Rejected this slot — ~448 LOC exceeds ≤350–400; mostly EN body + small residual better as a dedicated residual wave later |
| C — Bundle discovery-positioning (~214) into this wave | Rejected — would push toward/over LOC with less reviewability; keep as `translate-avaliacoes-wave-2` |
| D — README + TEMPLATE + Headroom + OSS gaps as `translate-avaliacoes-wave-1` | **Chosen** — 4 files / ~233 LOC; high residual PT; whole-file G-PT achievable; disjoint from kit/infra/skills |

**Rationale:** Starts WAv with index+template (agent entry points) plus two complete compact records.

### D2: In-place substitution — no dual-file; path segment frozen

**Chosen:** Edit the four paths in place. Forbidden: `*.en.md` / `*-pt.md` siblings; renaming `doc/avaliacoes/`.

**Rationale:** `sdd-docs-language` dual-file prohibition + glossary freeze for path segments until a dedicated rename change.

### D3: Decision labels → glossary EN without outcome drift

**Chosen:** Translate status labels and surrounding prose to English (`Adopted` / `Discarded` / `Deferred` / `Under evaluation`). Do not change which candidates are Discarded vs Adopted vs Deferred. Keep change-id links and tool URLs intact.

**Rationale:** Agents must still honor Discarded tools; language migration must not look like a re-decision.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that these four evaluation files MUST be English after substitution. Do not invent a new `sdd-evaluations` capability in this language wave.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Outcome drift (Discarded → looks Adopted) | Tasks forbid changing decision cells/outcomes; only language |
| G-PT false positives on path `avaliacoes` or quoted PT | Path is freeze/allowlist; quotes only when clearly historical |
| Broken relative links after heading renames | Prefer translating headings carefully; G-LINK on touched files |
| Parallel conflict with other avaliacoes proposes | Own only these four paths; document deferred siblings |
| Incomplete TEMPLATE placeholders still look PT | Translate placeholder guidance text to EN (`<candidate name>`, etc.) |

## Migration Plan

1. Apply: rewrite the four files EN in-place; freeze paths/change-ids/URLs; map status labels; keep outcomes.
2. Gate: `bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/README.md,doc/avaliacoes/TEMPLATE.md,doc/avaliacoes/2026-03-26-headroom-context-compression.md,doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-avaliacoes-wave-1 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- doc/avaliacoes/README.md doc/avaliacoes/TEMPLATE.md doc/avaliacoes/2026-03-26-headroom-context-compression.md doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`.

## Open Questions

- None blocking propose. Follow-up WAv candidates: `2026-07-26-sdd-discovery-positioning.md`, `2026-06-27-sdd-ui-development-module.md`. Residual opsx skill stubs / oversize skill splits remain available for later WSk residual waves. Guide whole-file G-PT strategy remains separate.
