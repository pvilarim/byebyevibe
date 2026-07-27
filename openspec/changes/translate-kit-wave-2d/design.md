# Design — translate-kit-wave-2d (W2d kit residual rules + proposal scaffold)

## Context

- Prerequisite W2c (`translate-kit-wave-2c`) proposed the first kit Cursor-rules slice and **deferred** this residual set via design **D1** / proposal. W2c propose is **merged** (PR #76). W2c **apply + archive may still be pending** at propose time for W2d — apply of this wave MUST wait until W2c is apply-complete and archived (or at least apply-complete so overlapping kit rule paths are not in flight).
- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- AS-IS residual kit inventory after W2c scope:

  | File | ~LOC | Language |
  |------|------|----------|
  | `020-python.mdc` | 17 | PT |
  | `030-supabase.mdc` | 18 | PT |
  | `050-security.mdc` | 47 | PT |
  | `_template/proposal.md` | 25 | PT (placeholders `PREENCHER` / PT Impact labels) |
  | `graphify.mdc` | 10 | EN (skip — already English) |

- Residual PT set for this wave = **4 files / ~107 LOC** — fits ≤4 files and ≤350–400 LOC budgets.
- Hub `.cursor/rules/{020,030,050}*.mdc` are fully English (W1/W1b/W1c) — primary language pattern for kit rule copies.
- Proposal scaffold pattern: `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` (EN) + English **FILL IN** placeholders (not bilingual dual-file).
- Touching `sdd-kit/templates/` requires `bash sdd-kit/gen-manifest-checksums.sh` (G-MANIFEST).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the three residual kit rule files with glossary-canonical English **in-place**.
- Align wording with hub `.cursor/rules/` English for the same filenames (description + body).
- Substitute `_template/proposal.md` Portuguese labels/placeholders with English **FILL IN** forms aligned with WAVE-PROPOSAL-TEMPLATE section structure.
- Preserve freeze-list tokens, YAML structure/`globs`/`alwaysApply`, paths, pins, `gate:`, and code identifiers.
- Update MANIFEST checksums after template edits; pass `verify-i18n-wave.sh` including **G-MANIFEST**.
- Close the W2c D1 deferral for kit residual rules + proposal scaffold.

**Non-Goals:**

- Kit W2c slice (`000-base`, `015-session-phases`, `016-session-coordination`, `010-typescript`) — owned by `translate-kit-wave-2c`.
- Kit `graphify.mdc` (already English).
- Hub live `.cursor/rules/` (already EN); hub `openspec/infra.md` residual PT.
- Guide, skills, evaluations, course, dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Path renames; creating `.claude/rules/` mirrors; semantic changes to conventions — language only.
- Changing MANIFEST `gate:` beyond checksum regeneration.
- Applying this wave before W2c apply+archive (sequencing constraint, not a content change).

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — wave budgets, W2 order, G-MANIFEST
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape + FILL IN pattern
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, freeze list (+ archived W2/W2b requirements)
- `openspec/changes/translate-kit-wave-2c/` — D1 deferral of `020`/`030`/`050` + `_template/proposal.md`
- Hub `.cursor/rules/020-python.mdc`, `030-supabase.mdc`, `050-security.mdc` — EN language patterns
- AS-IS targets under `sdd-kit/templates/.cursor/rules/` and `sdd-kit/templates/openspec/changes/_template/proposal.md`
- `scripts/verify-i18n-wave.sh`, `sdd-kit/gen-manifest-checksums.sh`
- `openspec/infra.md` — R10; assume ✅ (no reinstall)
- Graphify / GitNexus — SKIP / `[NEEDS VERIFICATION]` (docs/templates only; blast radius is install payloads)

## Decisions

### D1: Scope = 020 + 030 + 050 + `_template/proposal.md` (4 files); no further kit-rules deferral

| Option | Verdict |
|--------|---------|
| A — Fold into W2c | Rejected — W2c already at 4-file cap; D1 deferred this set |
| B — `020+030+050+proposal` in W2d | **Chosen** — exact W2c D1 suggestion; 4 files / ~107 LOC |
| C — Rules only; leave proposal for W2e | Rejected — wastes budget; proposal is 25 LOC and was explicitly folded into W2d plan |
| D — Proposal + hub infra residual | Rejected — hub `openspec/infra.md` is a non-goal; operator excluded it |

**Rationale:** Completes the kit Cursor-rules PT residual (except already-EN `graphify.mdc`) and the install-time proposal scaffold in one budget-clean wave.

### D2: In-place substitution — no dual-file

**Chosen:** Replace PT prose at the same paths. Forbidden: `*.en.mdc`, `*-pt.mdc`, `proposal.en.md` siblings.

**Rationale:** `sdd-docs-language` dual-file prohibition; `install.sh` copies these exact sources into consumer repos.

### D3: Hub rules = language pattern for `.mdc`; WAVE-PROPOSAL-TEMPLATE = pattern for proposal scaffold

**Chosen:**

- Prefer hub English wording for matching rule filenames (frontmatter `description` + body). Do not invent synonym section titles.
- For `_template/proposal.md`, use English section headings already present where identical (`Why`, `What Changes`, `Capabilities`, `Impact`) and replace Portuguese placeholder/instruction text with **FILL IN** English prompts (e.g. `[FILL IN: …]`), Impact bullets such as `Files modified` / `New dependencies` / `Risks or notes`, matching WAVE-PROPOSAL-TEMPLATE intent.

**Rationale:** Hub rules already passed W1/W1b/W1c G-PT; WAVE-PROPOSAL-TEMPLATE is the documented pattern for the kit proposal scaffold.

### D4: Freeze YAML keys / globs / paths / pins / identifiers / MANIFEST `gate:`

**Chosen:** Translate `description:` **values** and markdown prose only. Keep `alwaysApply`, `globs` keys and pattern strings, paths, package pins (`@fission-ai/openspec@1.3.1`), `OPENSPEC_TELEMETRY`, `gate:`, `F-SEC-5`/`F-SEC-3`, and code tokens (`Zod`, `asyncio`, `Pydantic`, `structlog`, `pytest-asyncio`, `ivfflat`, etc.) byte-stable.

**Rationale:** Freeze list (G-INV); globs drive Cursor rule activation; security identifiers must stay searchable.

### D5: G-MANIFEST is mandatory apply work, not a fifth “content” file

**Chosen:** After editing any of the four templates, run `bash sdd-kit/gen-manifest-checksums.sh`. Count mechanical `MANIFEST.yaml` checksum updates outside the ≤4 LOC-substitution budget. `--files` list for verify remains the four content paths; G-MANIFEST triggers from templates in that list.

**Rationale:** Same as W2 / W2b / W2c D5; kit integrity.

### D6: Spec delta = lasting W2d residual kit EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that these four kit template paths MUST be English. Avoid encoding “wave-2d” as permanent numbered clutter beyond acceptance scenarios.

**Rationale:** Same pattern as W2 / W2b / W2c slices.

### D7: Apply sequencing — W2c first

**Chosen:** Document apply prerequisite: `/opsx:apply` then `/opsx:archive` for `translate-kit-wave-2c` before applying W2d. Propose of W2d may land while W2c is still apply-pending (artifacts only; no template writes).

**Rationale:** Operator instruction; avoids two concurrent kit-template applies and ensures W2c ADDED requirement reaches main specs before W2d archive.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Stale MANIFEST checksums | Explicit checksum task + G-MANIFEST via `verify-i18n-wave.sh` |
| Semantic drift vs hub conventions | Tasks Pattern-point to hub `.cursor/rules/` siblings; prefer hub EN wording |
| G-PT false positives (European spelling leftovers, deny-list tokens such as `ficheiro`) | Align to hub EN; replace PT Impact labels (`Ficheiros`) with EN |
| Applying W2d before W2c apply/archive | Explicit prerequisite in proposal/tasks Session Handoff |
| Accidental edit of hub live rules | Tasks target only `sdd-kit/templates/` paths |
| Proposal placeholder wording drift vs WAVE-PROPOSAL-TEMPLATE | Pattern-point to `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`; use FILL IN not PREENCHER |

## Migration Plan

1. Prerequisite: apply + archive `translate-kit-wave-2c` if not already done.
2. Apply: rewrite three kit `.mdc` files EN in-place aligned with hub; rewrite `_template/proposal.md` EN FILL IN placeholders; freeze YAML/globs/paths/pins/`gate:`.
3. Checksums: `bash sdd-kit/gen-manifest-checksums.sh`.
4. Gate: `bash scripts/verify-i18n-wave.sh --files` on the four paths.
5. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-wave-2d --strict`.
6. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout --` the four template paths + `sdd-kit/MANIFEST.yaml` (content-only; no path moves).

## Open Questions

- None blocking propose. Hub infra residual PT remains a documented non-goal; not a blocker for this wave.
