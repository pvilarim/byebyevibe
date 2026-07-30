# Design — translate-infra-wave-1 (hub openspec/infra.md PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Kit copy `sdd-kit/templates/openspec/infra.md` is already English (archived `translate-kit-wave-2b`).
- Hub live `openspec/infra.md` (~139 LOC) still has Portuguese table headers (`Componente`, `Estado`, `Verificar com`, …), section titles (`Regra agentes`, `Env vars (nomes apenas)`), and body prose (`não`, `directamente`, `[AÇÃO MANUAL]`, European spellings such as `Registo` / `Actualizar` / `activação`).
- W2c/W2d proposals explicitly listed hub infra residual PT as a **non-goal** — this change closes that deferral on a disjoint path (no kit templates; no MANIFEST checksum work).
- Active kit applies (`translate-kit-wave-2c` / `2d`) do **not** own `openspec/infra.md` — parallel propose is safe.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in hub `openspec/infra.md` with glossary-canonical English **in-place**.
- Align shared labels with kit EN infra template (`Component` / `Version` / `Status` / `Verify with`, `[MANUAL ACTION]`, `Agent rule`) without inventing synonym table headers.
- Preserve freeze-list tokens, HTML verification markers, pins, SHA, paths, and hub-specific status cells.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/infra.md` (including G-PT).

**Non-Goals:**

- Kit `sdd-kit/templates/openspec/infra.md` (already EN).
- W2c/W2d kit Cursor rules / proposal scaffold.
- Canonical guide, skills, commands, evaluations, design docs, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Path renames; changing live ✅/❌ via re-verify (language-only edit).
- Semantic changes to R10 / Session Coordination meaning.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; in-scope includes `openspec/infra.md`
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase rules
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, freeze list
- `openspec/changes/translate-kit-wave-2c/` / `translate-kit-wave-2d/` — hub infra deferred as non-goal
- `openspec/changes/archive/2026-07-26-translate-kit-wave-2b/` — kit infra EN pattern (`[MANUAL ACTION]`, marker-body translation)
- AS-IS: `openspec/infra.md` · pattern: `sdd-kit/templates/openspec/infra.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (single markdown; no code symbols)

## Decisions

### D1: Scope = hub `openspec/infra.md` only (1 file / ~139 LOC)

| Option | Verdict |
|--------|---------|
| A — Fold into W2d | Rejected — W2d at 4-file kit cap; design D1 rejected hub infra |
| B — Hub infra alone as `translate-infra-wave-1` | **Chosen** — whole-file G-PT achievable; disjoint from in-flight kit applies |
| C — Bundle with first skill wave | Rejected — mixes surfaces; skills need G-MIRROR pairing |
| D — Wait for guide W3 | Rejected — guide needs section splits; whole-file G-PT cannot pass mid-guide; factory should land completable whole-file slices first |

**Rationale:** Closes W2 deferral; fits ≤4 files and ≤350–400 LOC; apply can satisfy slice DoD + G-PT on the single path.

### D2: In-place substitution — no dual-file

**Chosen:** Replace PT prose at `openspec/infra.md`. Forbidden: `openspec/infra.en.md` / `infra-pt.md` siblings.

**Rationale:** `sdd-docs-language` dual-file prohibition; R10 agents load this exact path.

### D3: Kit EN infra = language pattern; preserve hub facts

**Chosen:** Prefer kit English wording for shared chrome (table headers, `[MANUAL ACTION]`, Agent rule bullets, “Names only”, “Last verified”). Keep hub-specific rows (full Skills table, Session Coordination heartbeat script, Docs language / i18n section, Probity pilot note path, UI module doc paths) and current ✅/❌ / version marker bodies unless they contain Portuguese filler.

**Rationale:** Kit infra already passed W2b G-PT; hub status cells are live operational data, not translation targets.

### D4: Freeze HTML markers / pins / SHA / paths

**Chosen:** Do not move or rename `<!-- … -->` marker **tags** used by `scripts/verify-infra.sh`. Translate Portuguese **inside** marker bodies only when present (e.g. `_(sem .env.example no repo)_` → `_(no .env.example in repo)_`). Keep `@nizos/probity@1.10.0`, Action SHA `8dc09193bb540e09b23da07ad7e30bd33bf87018`, paths, and fenced/backticked commands byte-stable.

**Rationale:** G-INV + operational script contract (same as W2b kit infra).

### D5: Spec delta = lasting hub infra EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that hub `openspec/infra.md` MUST be English. Avoid encoding “wave-1” as permanent numbered clutter beyond acceptance scenarios.

**Rationale:** Same pattern as W1/W2 slice ADDED requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Accidental rewrite of HTML markers | Tasks freeze checklist; Pattern-point to kit EN + W2b archive notes |
| Status-cell drift (changing ✅/❌ while translating) | Explicit non-goal; edit prose/headers only |
| G-PT false positives on European leftovers (`ficheiro`, `activação`) | Align to kit EN; use American/Oxford glossary forms where listed |
| Conflict with parallel kit applies | Different paths; no MANIFEST touch |
| Guide still blocked for parallel section proposes | Documented; not this wave’s problem — factory may propose skills/avaliacoes next |

## Migration Plan

1. Apply: rewrite hub `openspec/infra.md` EN in-place aligned with kit chrome; freeze markers/pins/SHA/paths/status cells.
2. Gate: `bash scripts/verify-i18n-wave.sh --files openspec/infra.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-infra-wave-1 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- openspec/infra.md` (content-only; no path moves).

## Open Questions

- None blocking propose. Guide section waves remain next in WAVES.md order but need whole-file G-PT strategy (out of scope here).
