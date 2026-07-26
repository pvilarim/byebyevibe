# Design — translate-agents-rules-wave-1c (W1c stack-scoped Cursor rules)

## Context

- Prerequisite W1b (`translate-agents-rules-wave-1b`) substituted always-apply Cursor rules and explicitly deferred the remaining four `.mdc` files for budget (≤4 files). W1b tasks are complete / merged on `master`.
- Layer-1 policy `add-english-docs-policy` archived — capability `sdd-docs-language`, glossary, wave inventory, and `scripts/verify-i18n-wave.sh` are live.
- `doc/i18n/WAVES.md` lists W1 as: `AGENTS.md` + `openspec/project.md` + `CLAUDE.md` + rules prose (`.mdc`). This change is **slice 2 of 2** of the deferred rules surface (final W1 rules slice).
- **LOC inventory (2026-07-26):** W1c four files = **63 LOC / 4 files** (`010-typescript` 18 + `020-python` 17 + `030-supabase` 18 + `graphify.mdc` 10) — within ≤350–400 LOC and ≤4 files.
- AS-IS: `010`/`020`/`030` are Portuguese conventions prose with English tech tokens; `graphify.mdc` is already English (`description` + body) — verify residual PT only.
- No `.claude/rules/` mirror exists — rules are Cursor-only `.mdc` files (G-MIRROR N/A).
- Kit copies under `sdd-kit/templates/.cursor/rules/` are **out of scope** (W2 / kit wave + checksums).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the four W1c `.mdc` files with glossary-canonical English **in-place**.
- Preserve YAML frontmatter structure, globs, and freeze-list tokens (paths, code identifiers, brands).
- Pass `bash scripts/verify-i18n-wave.sh --files .cursor/rules/010-typescript.mdc,.cursor/rules/020-python.mdc,.cursor/rules/030-supabase.mdc,.cursor/rules/graphify.mdc`.
- Close the W1 agents/rules track so subsequent waves can move to kit (W2) without leftover W1 rule debt.

**Non-Goals:**

- Guide, skills, kit templates (including `sdd-kit/templates/.cursor/rules/`), evaluations, course, dual-file `*.en.mdc` / `*-pt.mdc`.
- Global G-DoD (`--dod`).
- Semantic changes to TypeScript / Python / Supabase / Graphify conventions — language only.
- Path renames; creating `.claude/rules/` mirrors.
- Re-translating W1 / W1b files already English.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — wave budgets, gates, W1 order
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, freeze list
- `openspec/changes/translate-agents-rules-wave-1b/` — W1b precedent (budget split → 1c)
- `openspec/changes/translate-agents-rules-wave-1c/knowledge.md` — Graphify researcher summary
- `openspec/infra.md` — R10; assume ✅ (no reinstall)
- AS-IS targets: `.cursor/rules/010-typescript.mdc`, `020-python.mdc`, `030-supabase.mdc`, `graphify.mdc`
- `scripts/verify-i18n-wave.sh` — gate commands and PT deny-list
- Graphify `GRAPH_REPORT.md` — unavailable in this environment (`[NEEDS VERIFICATION]` / SKIP); knowledge anchored to i18n docs + W1b change artifacts + `knowledge.md` instead
- GitNexus MCP — unavailable in this environment (`[NEEDS VERIFICATION]` / SKIP); blast radius is docs-only `.mdc` prose (no code symbols)

## Decisions

### D1: Scope = four remaining W1 rules (operator-specified W1c slice)

| Option | Verdict |
|--------|---------|
| A — Merge into W1b | Rejected — already applied/archived; ≤4-file budget would have been exceeded |
| B — Stack-scoped cluster: `010`, `020`, `030`, `graphify` | **Chosen** — 4 files, 63 LOC; matches W1b D1 follow-up |
| C — Include kit template rule copies | Rejected — triggers G-MANIFEST / checksums; belongs to W2 |

**Rationale:** Completes W1 rules surface per W1b design D1; stays within normative wave budgets.

### D2: In-place substitution — no dual-file

**Chosen:** Replace PT prose at the same `.mdc` path. Forbidden: `*.en.mdc`, `*-pt.mdc` siblings.

**Rationale:** `sdd-docs-language` dual-file prohibition; Cursor loads these paths via `globs` / `alwaysApply`.

### D3: Frontmatter `description` → English; keys/globs/alwaysApply unchanged

**Chosen:** Translate human-readable `description:` values to English. Keep `alwaysApply`, `globs` keys, boolean values, and glob pattern strings byte-stable. Do not add or remove globs.

**Rationale:** `description` is agent-facing prose subject to G-PT; YAML keys, booleans, and glob patterns are freeze-stable structure (operator freeze list).

### D4: Freeze stack code identifiers explicitly

**Chosen:** Do not alter identifiers including `cn`, `Zod`, `RLS`, `ivfflat`, `structlog`, `pytest-asyncio`, `Pydantic`, `asyncio`, `pgvector`, `@/`, `Result`, path `infra/supabase/schemas.ts`, `core/errors.py`, `graphify-out/`, `graphify update .`.

**Rationale:** Operator freeze list + G-INV; conventions must remain executable guidance for agents.

### D5: Glossary-canonical vocabulary; expand only if needed

**Chosen:** Use existing glossary forms where applicable. Stack jargon (`strict mode`, `named exports`, `deny by default`) is already English tech vocabulary — no new SDD term bank rows expected.

**Rationale:** G-GLOSS; avoid synonym drift.

### D6: Spec delta = lasting W1c stack/rules EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that these four rule files MUST be English. Avoid encoding “wave-1c” as permanent numbered clutter beyond acceptance scenarios.

**Rationale:** Same pattern as W1 / W1b; wave IDs live in change-id / `WAVES.md`.

### D7: `graphify.mdc` = verify-first, minimal edit

**Chosen:** If body and `description` are already English with zero deny-list PT, leave content unchanged (or only tiny residual fixes). Still include the file in the wave `--files` list so G-PT covers the full W1c set.

**Rationale:** Operator scope includes closing residual + description if needed; avoid drive-by rewrites of already-EN text.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT false positives (tech tokens resembling PT) | Allowlist per `GLOSSARY.md`; keep identifiers in backticks; document exceptions in apply notes if needed |
| Accidental rewrite of globs or `alwaysApply` | Tasks freeze checklist; edit prose/`description` values only |
| Semantic drift in stack conventions (e.g. RLS deny-by-default) | Translate faithfully; preserve bullet semantics and section structure |
| Kit template rules remain PT after W1c | Explicit non-goal; Session Handoff points to W2 / kit rules wave |
| Over-editing already-EN `graphify.mdc` | D7 verify-first |

## Migration Plan

1. Apply: rewrite the three PT `.mdc` files EN in-place; verify/close `graphify.mdc` (tasks.md).
2. Gate: `bash scripts/verify-i18n-wave.sh --files .cursor/rules/010-typescript.mdc,.cursor/rules/020-python.mdc,.cursor/rules/030-supabase.mdc,.cursor/rules/graphify.mdc`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-agents-rules-wave-1c --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up: W2 kit surface (`sdd-kit/README.md` + templates, including kit rule copies + checksums) — not this change.

**Rollback:** `git checkout -- .cursor/rules/010-typescript.mdc .cursor/rules/020-python.mdc .cursor/rules/030-supabase.mdc .cursor/rules/graphify.mdc` (content-only; no path moves).

## Open Questions

- None blocking propose. W1c is fully scoped (four files, 63 LOC); kit rule templates deferred by design.
