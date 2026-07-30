# Design — translate-agents-rules-wave-1b (W1b always-apply Cursor rules)

## Context

- Prerequisite W1 (`translate-agents-rules-wave-1`) substituted agent entry points and explicitly deferred `.cursor/rules/*.mdc` for budget (≤4 files).
- Layer-1 policy `add-english-docs-policy` archived — capability `sdd-docs-language`, glossary, wave inventory, and `scripts/verify-i18n-wave.sh` are live.
- `doc/i18n/WAVES.md` lists W1 as: `AGENTS.md` + `openspec/project.md` + `CLAUDE.md` + rules prose (`.mdc`). This change is **slice 1 of 2** of the deferred rules surface.
- **LOC inventory (2026-07-26):** W1b four files = **88 LOC / 4 files** (within ≤350–400 LOC and ≤4 files). Remaining W1c = `010-typescript` (18) + `020-python` (17) + `030-supabase` (18) + `graphify.mdc` (10) = **63 LOC / 4 files**.
- AS-IS: the four always-apply rules are Portuguese prose with English tokens (paths, script names, `/opsx:*`, security identifiers). `graphify.mdc` is already mostly English (deferred to W1c for completeness of the remaining set).
- No `.claude/rules/` mirror exists — rules are Cursor-only `.mdc` files (G-MIRROR N/A).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the four W1b `.mdc` files with glossary-canonical English **in-place**.
- Preserve YAML frontmatter structure and freeze-list tokens (paths, scripts, `/opsx:*`, pins, brands).
- Pass `bash scripts/verify-i18n-wave.sh --files .cursor/rules/000-base.mdc,.cursor/rules/015-session-phases.mdc,.cursor/rules/016-session-coordination.mdc,.cursor/rules/050-security.mdc`.
- Document follow-up `translate-agents-rules-wave-1c` for the remaining four rule files.

**Non-Goals:**

- Guide, skills, kit templates, evaluations, course, dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Translating `010-typescript.mdc`, `020-python.mdc`, `030-supabase.mdc`, `graphify.mdc` in this change.
- Semantic changes to session phases, R11 coordination, or security guardrails — language only.
- Path renames; creating `.claude/rules/` mirrors.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — wave budgets, gates, W1 order
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, freeze list
- `openspec/changes/translate-agents-rules-wave-1/` — W1 precedent (budget split → 1b)
- `openspec/infra.md` — R10; assume ✅ (no reinstall)
- AS-IS targets: `.cursor/rules/000-base.mdc`, `015-session-phases.mdc`, `016-session-coordination.mdc`, `050-security.mdc`
- `scripts/verify-i18n-wave.sh` — gate commands and PT deny-list
- Graphify `GRAPH_REPORT.md` — unavailable in this environment (`[NEEDS VERIFICATION]` / SKIP); knowledge anchored to i18n docs + W1 change artifacts instead

## Decisions

### D1: Scope = four always-apply rules (operator-specified W1b slice)

| Option | Verdict |
|--------|---------|
| A — All 8 `.mdc` in one change | Rejected — 8 files violates ≤4-file budget |
| B — Always-apply cluster: `000`, `015`, `016`, `050` | **Chosen** — 4 files, 88 LOC; operator-specified |
| C — Stack-scoped first (`010`/`020`/`030`/`graphify`) | Rejected — lower session leverage; always-apply load every chat |

**Rationale:** Normative wave budgets; always-apply rules have highest agent-session impact. W1c takes the remainder.

### D2: In-place substitution — no dual-file

**Chosen:** Replace PT prose at the same `.mdc` path. Forbidden: `*.en.mdc`, `*-pt.mdc` siblings.

**Rationale:** `sdd-docs-language` dual-file prohibition; Cursor loads these paths via alwaysApply.

### D3: Frontmatter `description` → English; keys/structure unchanged

**Chosen:** Translate human-readable `description:` values to English. Keep `alwaysApply: true` and key names unchanged. Do not add `globs` where absent.

**Rationale:** `description` is agent-facing prose subject to G-PT; YAML keys and booleans are freeze-stable structure.

### D4: Glossary-canonical vocabulary; expand only if needed

**Chosen:** Use existing glossary forms (`Session Handoff`, `apply`, `propose`, `explore`, `archive`, `gate`, `worktree`, `fail-closed`, `wave`). Likely no new rows — security/session vocabulary already covered or is English jargon (`RLS` N/A here; `RCE`, `eval`, `PostHog` are brand/tech).

**Rationale:** G-GLOSS; avoid synonym drift.

### D5: Freeze-list discipline

**Chosen:** Do not alter paths (`openspec/infra.md`, `doc/sistema-sdd-pedro.md`, `scripts/sdd-session-*.sh`, `sdd-kit/MANIFEST.yaml`), `/opsx:*`, fenced or inline shell commands, pins (`@fission-ai/openspec@1.3.1`), MANIFEST keys (`gate:`, `sha256:`), finding IDs (`F-SEC-5`, `F-SEC-3`), or brands.

**Rationale:** G-INV; install and session coordination depend on byte-stable tokens.

### D6: Spec delta = lasting always-apply rules EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that these four always-apply rule files MUST be English. Avoid encoding “wave-1b” as permanent numbered clutter beyond acceptance scenarios.

**Rationale:** Same pattern as W1 entry-point requirement; wave IDs live in change-id / `WAVES.md`.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT false positives (path segments, quoted PT) | Allowlist per `GLOSSARY.md`; document exceptions in apply notes if needed |
| Accidental rewrite of script paths or `/opsx:*` | G-INV; tasks freeze checklist; edit prose only |
| Semantic drift in security MUST/NEVER lists | Translate faithfully; preserve bullet semantics and section structure |
| Session-phase / R11 meaning drift | Keep explore\|propose\|apply\|archive phase names and MUST/advisory distinction |
| Always-apply rules EN while stack rules still PT | Explicit non-goal + Session Handoff to propose `translate-agents-rules-wave-1c` |

## Migration Plan

1. Apply: rewrite the four `.mdc` files EN in-place (tasks.md).
2. Gate: `bash scripts/verify-i18n-wave.sh --files .cursor/rules/000-base.mdc,.cursor/rules/015-session-phases.mdc,.cursor/rules/016-session-coordination.mdc,.cursor/rules/050-security.mdc`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-agents-rules-wave-1b --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up propose: `translate-agents-rules-wave-1c` for `010-typescript`, `020-python`, `030-supabase`, `graphify.mdc`.

**Rollback:** `git checkout -- .cursor/rules/000-base.mdc .cursor/rules/015-session-phases.mdc .cursor/rules/016-session-coordination.mdc .cursor/rules/050-security.mdc` (content-only; no path moves).

## Open Questions

- None blocking propose. W1c is fully scoped (four remaining files, 63 LOC).
