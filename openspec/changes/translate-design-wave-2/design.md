# Design — translate-design-wave-2 (Impeccable design-system reference PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base: kit W2c/W2d (kit Cursor rules + proposal scaffold; apply PR #78), hub `openspec/infra.md` (`translate-infra-wave-1`), `correctness-review` / `simplify-review` skills, `translate-avaliacoes-wave-1` (four evaluation files), `translate-design-wave-1` (`doc/design/002|003|004`). None own `doc/design/000-impeccable-design-system-guia.md`.
- Open translate PRs: kit apply PR #78 (kit templates); avaliacoes-wave-2 propose PR #84 (discovery-positioning + UI-module evaluation). Neither owns hub `doc/design/000`.
- Canonical guide (`doc/sistema-sdd-pedro.md`, ~2847 LOC) remains deferred for mid-file G-PT; factory prefers completable whole-file slices.
- Design surface inventory: `000` ~311 LOC (**this wave**), `001` ~592 LOC (over budget — must split later), `002`+`003`+`004` owned by wave-1. Kit mirrors under `sdd-kit/templates/doc/design/` need a checksum-aware later wave (G-MANIFEST).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `doc/design/000-impeccable-design-system-guia.md` with glossary-canonical English **in-place**.
- Preserve reference/adaptation status meaning, DOCS_SPECS vs APP-target applicability, shadcn-default stance, adoption checklist semantics, and relative links.
- Map common PT vocabulary via glossary (`ficheiro`→file, `secção`/`seção`→section, `avaliação`→evaluation where prose, `canónico`→canonical, `próximo`→next, `apenas`→only, `não`→not) without inventing synonym drift.
- Pass `bash scripts/verify-i18n-wave.sh --files doc/design/000-impeccable-design-system-guia.md`.

**Non-Goals:**

- `doc/design/001-*` (over LOC — split later).
- `doc/design/002|003|004` (wave-1).
- `sdd-kit/templates/doc/design/*` mirrors.
- Canonical guide, skills/commands, kit rules, hub infra, evaluations.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Path renames; changing Impeccable adoption recommendations or installing Impeccable on this hub — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `doc/design/` in-scope
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-design-wave-1/` — prior design-track propose pattern
- AS-IS: `doc/design/000-impeccable-design-system-guia.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown design doc; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = Impeccable reference guide alone (design wave-2)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — Hub `doc/design/000` alone (~311) | **Chosen** — 1 file / ~311 LOC; dense residual PT; whole-file G-PT; disjoint from owned set; explicitly deferred by wave-1 |
| C — `doc/design/001` alone (~592) | Rejected — exceeds ≤350–400 LOC; needs split |
| D — Bundle kit `sdd-kit/templates/doc/design/000` with hub | Rejected this slot — G-MANIFEST / checksum coupling; prefer hub-first then kit mirror wave |
| E — Bundle `000` with residual course aulas | Rejected — different surface; keep design-track coherent |

**Rationale:** Wave-1 deferred `000` as the natural next whole-file design slice within budget.

### D2: In-place substitution — no dual-file; no kit checksums this wave

**Chosen:** Edit the hub path in place. Forbidden: `*.en.md` / `*-pt.md` siblings; editing `sdd-kit/templates/doc/design/` in this change.

**Rationale:** `sdd-docs-language` dual-file prohibition; kit mirrors are a separate G-MANIFEST wave.

### D3: Preserve reference status and DOCS_SPECS applicability

**Chosen:** Translate prose/headings/tables to English. Keep import origin, `[if applicable]` / DOCS_SPECS hub notes, shadcn-default Fase 2 stance, relative links to `001`/`002`/`003`/canonical guide, and adoption checklist meaning semantically identical. Status label may move from Portuguese marker text to an English equivalent (e.g. `[REFERENCE — NEEDS ADAPTATION]`) so G-PT passes while meaning stays.

**Rationale:** Agents must still treat this as an APP-target reference doc, not an install instruction for the DOCS_SPECS hub.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that this design file MUST be English after substitution. Do not invent a new `sdd-design-docs` capability in this language wave.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of adoption checklist / applicability notes | Tasks require procedure/status parity; freeze paths and profile labels |
| G-PT false positives on brand/tool names or path segments | Freeze/allowlist; quoted historical PT only when clearly cited |
| Broken relative links after heading renames | Prefer careful heading translation; G-LINK on touched file |
| Parallel conflict with kit design-template proposes | Own only hub `doc/design/000`; document kit mirror as non-goal |
| Status marker PT tokens fail G-PT if left as-is | Translate marker to EN equivalent in apply; keep meaning |

## Migration Plan

1. Apply: rewrite the file EN in-place; freeze paths/pins/flags; keep reference/adaptation and DOCS_SPECS semantics.
2. Gate: `bash scripts/verify-i18n-wave.sh --files doc/design/000-impeccable-design-system-guia.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-design-wave-2 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- doc/design/000-impeccable-design-system-guia.md`.

## Open Questions

- None blocking propose. Follow-up design candidates: `001` (split into ≤400 LOC section waves); kit `sdd-kit/templates/doc/design/` mirrors after hub apply+archive. Guide whole-file G-PT strategy remains separate. Course aulas remain a separate WCu track.
