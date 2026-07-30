# Design — translate-kit-wave-2c (W2c kit Cursor rules slice)

## Context

- Prerequisite W2b (`translate-kit-wave-2b`) substituted kit `CLAUDE.md` + `openspec/infra.md` and is **apply-complete / merged** (PR #75) and **archived** (`openspec/changes/archive/2026-07-26-translate-kit-wave-2b/`). Main `sdd-docs-language` now includes the W2b CLAUDE/infra English requirement.
- W2b design **D1** / proposal deferred kit `.cursor/rules/*.mdc` copies to this change-id.
- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- AS-IS kit rules inventory (`sdd-kit/templates/.cursor/rules/`):

  | File | ~LOC | Language |
  |------|------|----------|
  | `000-base.mdc` | 16 | PT |
  | `015-session-phases.mdc` | 12 | PT |
  | `016-session-coordination.mdc` | 13 | PT |
  | `010-typescript.mdc` | 18 | PT |
  | `020-python.mdc` | 17 | PT |
  | `030-supabase.mdc` | 18 | PT |
  | `050-security.mdc` | 47 | PT |
  | `graphify.mdc` | 10 | EN (skip) |
  | `_template/proposal.md` (sibling surface) | 25 | PT |

- Full residual PT set ≈ **7 `.mdc` + proposal = 8 files / ~166 LOC** — exceeds ≤4 files → must split.
- Hub `.cursor/rules/{000,010,015,016}*.mdc` are fully English (W1/W1b/W1c) — primary language pattern for kit copies.
- Touching `sdd-kit/templates/` requires `bash sdd-kit/gen-manifest-checksums.sh` (G-MANIFEST).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the four W2c kit rule files with glossary-canonical English **in-place**.
- Align wording with hub `.cursor/rules/` English for the same filenames (description + body).
- Preserve freeze-list tokens, YAML structure/`globs`/`alwaysApply`, paths, `/opsx:*`, and code identifiers.
- Update MANIFEST checksums after template edits; pass `verify-i18n-wave.sh` including **G-MANIFEST**.
- Document the deferred W2d slice (`020`/`030`/`050` + `_template/proposal.md`) for the next propose.

**Non-Goals:**

- Kit `020-python.mdc`, `030-supabase.mdc`, `050-security.mdc`, `_template/proposal.md` (→ `translate-kit-wave-2d`).
- Kit `graphify.mdc` (already English).
- Hub live `.cursor/rules/` (already EN); hub `openspec/infra.md` residual PT.
- Guide, skills, evaluations, course, dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Path renames; creating `.claude/rules/` mirrors; semantic changes to conventions — language only.
- Changing MANIFEST `gate:` beyond checksum regeneration.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — wave budgets, W2 order, G-MANIFEST
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, freeze list (+ archived W2/W2b requirements)
- `openspec/changes/archive/2026-07-26-translate-kit-wave-2b/` — D1 deferral of kit rules
- Hub `.cursor/rules/000-base.mdc`, `015-session-phases.mdc`, `016-session-coordination.mdc`, `010-typescript.mdc` — EN language patterns
- AS-IS targets under `sdd-kit/templates/.cursor/rules/`
- `scripts/verify-i18n-wave.sh`, `sdd-kit/gen-manifest-checksums.sh`
- `openspec/infra.md` — R10; assume ✅ (no reinstall)
- Graphify / GitNexus — SKIP / `[NEEDS VERIFICATION]` (docs/templates only; blast radius is install payloads)

## Decisions

### D1: Scope = 000 + 015 + 016 + 010 (4 files); defer rest to W2d

| Option | Verdict |
|--------|---------|
| A — All 7 PT `.mdc` in one wave | Rejected — breaches ≤4 files |
| B — `000+015+016+010` then later `020+030+050+proposal` | **Chosen** — matches operator hint; always-apply trio + TypeScript; proposal fold considered but would force dropping a rule |
| C — `000+015+016+proposal` then stack rules | Rejected — delays TypeScript kit copy; operator example preferred rules-first pack |
| D — `000+015+016+050` (alwaysApply-only) | Rejected — leaves TypeScript orphaned; 050 alone was an alternate 4+1 split, not needed if W2d takes four files cleanly |

**Rationale:** Normative ≤4-file budget + coherent follow-up. W2d suggestion: `020-python`, `030-supabase`, `050-security`, `openspec/changes/_template/proposal.md` (4 files / ~107 LOC).

**Fold note:** `_template/proposal.md` (25 LOC) was considered for W2c; it does **not** fit without exceeding 4 files or dropping `010`. Explicitly deferred to W2d.

### D2: In-place substitution — no dual-file

**Chosen:** Replace PT prose at the same paths. Forbidden: `*.en.mdc`, `*-pt.mdc` siblings.

**Rationale:** `sdd-docs-language` dual-file prohibition; `install.sh` copies these exact sources into consumer `.cursor/rules/`.

### D3: Hub rules = language pattern (byte-align where identical intent)

**Chosen:** Prefer hub English wording for matching filenames (frontmatter `description` + body). Do not invent synonym section titles. Keep kit-only differences only if the kit file intentionally differs (none expected for these four).

**Rationale:** Hub already passed W1/W1b/W1c G-PT; install consumers should match hub agent behavior for the same rule ids.

### D4: Freeze YAML keys / globs / paths / `/opsx:*` / identifiers

**Chosen:** Translate `description:` **values** and markdown prose only. Keep `alwaysApply`, `globs` keys and pattern strings, paths (`./AGENTS.md`, `openspec/infra.md`, scripts), slash commands, and code tokens (`cn`, `Zod`, `@/`) byte-stable.

**Rationale:** Freeze list (G-INV); globs drive Cursor rule activation.

### D5: G-MANIFEST is mandatory apply work, not a fifth “content” file

**Chosen:** After editing any of the four templates, run `bash sdd-kit/gen-manifest-checksums.sh`. Count mechanical `MANIFEST.yaml` checksum updates outside the ≤4 LOC-substitution budget. `--files` list for verify remains the four content paths; G-MANIFEST triggers from templates in that list.

**Rationale:** Same as W2 / W2b D5; kit integrity.

### D6: Spec delta = lasting W2c kit rules EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that these four kit rule paths MUST be English. Avoid encoding “wave-2c” as permanent numbered clutter beyond acceptance scenarios.

**Rationale:** Same pattern as W2 / W2b slices.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Stale MANIFEST checksums | Explicit checksum task + G-MANIFEST via `verify-i18n-wave.sh` |
| Semantic drift vs hub conventions | Tasks Pattern-point to hub `.cursor/rules/` siblings; prefer hub EN wording |
| G-PT false positives (European spelling leftovers, deny-list tokens) | Align to hub EN; avoid legacy pt-BR orthography (`projecto`→`project` already EN in hub) |
| Remaining kit rules still PT after W2c | Explicit W2d deferral in proposal/design/tasks + Session Handoff |
| Accidental edit of hub live rules | Tasks target only `sdd-kit/templates/.cursor/rules/` paths |

## Migration Plan

1. Apply: rewrite four kit `.mdc` files EN in-place aligned with hub; freeze YAML/globs/paths/`/opsx:*`.
2. Checksums: `bash sdd-kit/gen-manifest-checksums.sh`.
3. Gate: `bash scripts/verify-i18n-wave.sh --files` on the four paths.
4. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-wave-2c --strict`.
5. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
6. Follow-up propose: `translate-kit-wave-2d` for `020`/`030`/`050` + `_template/proposal.md`.

**Rollback:** `git checkout --` the four template paths + `sdd-kit/MANIFEST.yaml` (content-only; no path moves).

## Open Questions

- None blocking propose. Hub infra residual PT and W2d slice are noted; not blockers for this wave.
