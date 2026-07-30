# Design — translate-design-wave-1 (UI module + adapters + Probity install PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base: kit W2c/W2d (kit Cursor rules + proposal scaffold), hub `openspec/infra.md` (`translate-infra-wave-1`), `correctness-review` / `simplify-review` skills, `translate-avaliacoes-wave-1` (four evaluation files). None own `doc/design/002|003|004`.
- Open translate PRs: kit apply PR #78 (kit templates); avaliacoes-wave-2 propose PR #84 (discovery-positioning + UI-module evaluation). Neither owns hub `doc/design/` install docs.
- Canonical guide (`doc/sistema-sdd-pedro.md`, ~2847 LOC) remains deferred for mid-file G-PT; factory prefers completable whole-file slices.
- Design surface inventory: `000` ~310 LOC (deferred), `001` ~592 LOC (over budget — must split later), `002`+`003`+`004` ~385 LOC / 3 files (**this wave**). Kit mirrors under `sdd-kit/templates/doc/design/` need a checksum-aware later wave (G-MANIFEST).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the three listed design files with glossary-canonical English **in-place**.
- Preserve install/detect/apply procedure semantics, scenario labels (`C1-UI`, `G2`), script paths, and relative links.
- Map common PT vocabulary via glossary (`ficheiro`→file, `secção`/`seção`→section, `requisito`→requirement, `avaliação`→evaluation where prose, `canónico`→canonical, `próximo`→next) without inventing synonym drift.
- Pass `bash scripts/verify-i18n-wave.sh --files doc/design/002-ui-module-install.md,doc/design/003-ui-stack-adapters.md,doc/design/004-probity-module-install.md`.

**Non-Goals:**

- `doc/design/000-*`, `doc/design/001-*`.
- `sdd-kit/templates/doc/design/*` mirrors.
- Canonical guide, skills/commands, kit rules, hub infra, evaluations.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Path renames; changing what `--apply` does or does not do — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `doc/design/` in-scope
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-avaliacoes-wave-1/` — prior factory propose pattern
- AS-IS: the three `doc/design/` files listed in the proposal
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown design docs; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = three module-install / adapter docs (design wave-1)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `doc/design/000` alone (~310) | Deferred — valid alternate; this run follows factory memory preferring 002+003+004 cluster |
| C — `doc/design/001` alone (~592) | Rejected — exceeds ≤350–400 LOC; needs split |
| D — Bundle kit `sdd-kit/templates/doc/design/{002,003,004}` with hub | Rejected this slot — G-MANIFEST / checksum coupling; prefer hub-first then kit mirror wave |
| E — Hub `002`+`003`+`004` as `translate-design-wave-1` | **Chosen** — 3 files / ~385 LOC; dense residual PT; whole-file G-PT; disjoint from owned set |

**Rationale:** Closely related optional-module install docs (C1-UI, adapters, Probity G2) review as one coherent slice within budget.

### D2: In-place substitution — no dual-file; no kit checksums this wave

**Chosen:** Edit the three hub paths in place. Forbidden: `*.en.md` / `*-pt.md` siblings; editing `sdd-kit/templates/doc/design/` in this change.

**Rationale:** `sdd-docs-language` dual-file prohibition; kit mirrors are a separate G-MANIFEST wave.

### D3: Preserve procedure semantics and scenario labels

**Chosen:** Translate prose/headings/tables to English. Keep `C1-UI`, `G2`, script invocations, `--detect` / `--apply` / `--yes`, matrix row meanings, and “what apply does not do” lists semantically identical.

**Rationale:** Agents and operators must still execute the same install steps after language migration.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that these three design files MUST be English after substitution. Do not invent a new `sdd-design-docs` capability in this language wave.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of install steps / “does not” lists | Tasks require procedure parity; freeze script paths and flags |
| G-PT false positives on brand/tool names or path segments | Freeze/allowlist; quoted historical PT only when clearly cited |
| Broken relative links after heading renames | Prefer careful heading translation; G-LINK on touched files |
| Parallel conflict with kit design-template proposes | Own only hub `doc/design/002|003|004`; document kit mirrors as non-goals |
| LOC near upper budget (~385) | Cap at these three files; do not add `000`/`001` |

## Migration Plan

1. Apply: rewrite the three files EN in-place; freeze paths/scripts/pins/flags; keep procedure semantics.
2. Gate: `bash scripts/verify-i18n-wave.sh --files doc/design/002-ui-module-install.md,doc/design/003-ui-stack-adapters.md,doc/design/004-probity-module-install.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-design-wave-1 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- doc/design/002-ui-module-install.md doc/design/003-ui-stack-adapters.md doc/design/004-probity-module-install.md`.

## Open Questions

- None blocking propose. Follow-up design candidates: `000` (~310, own wave); `001` (split into ≤400 LOC section waves); kit `sdd-kit/templates/doc/design/` mirrors after hub apply+archive. Guide whole-file G-PT strategy remains separate.
