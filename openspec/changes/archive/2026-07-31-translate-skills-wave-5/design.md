# Design — translate-skills-wave-5 (openspec-archive-change skill PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base includes kit W2c/W2d (apply landed), hub `openspec/infra.md`, `correctness-review` / `simplify-review` / `openspec-apply-change` / `openspec-explore` skills, avaliacoes-wave-1, design-wave-1/2. None own `openspec-archive-change` paths.
- Open translate PRs: kit apply PR #78 (kit templates); avaliacoes-wave-2 propose PR #84 (two evaluation records); skills propose PR #91 (`openspec-propose` path list — colliding change-id `translate-skills-wave-4` vs master explore wave-4). None own these archive skill mirrors.
- Canonical guide (`doc/sistema-sdd-pedro.md`, ~2847 LOC) and `doc/design/001` (~592 LOC) remain deferred (whole-file G-PT / over budget).
- `openspec-archive-change` mirrors are identical today (~148 LOC each). Core Steps/Guardrails are already English; residual Portuguese is concentrated in the §12.10 pattern-promotion prompt, Session Handoff stub, and metrics-cadence nudge. Fits ≤1 skill × 2 mirrors and ≤350–400 LOC (logical skill body).
- This wave is **language only** — archive sync assessment, optional pattern promotion, and advisory metrics cadence stay unchanged. Language ownership stays under `sdd-docs-language`.

## Goals / Non-Goals

**Goals:**

- Substitute all residual Portuguese prose in both `openspec-archive-change` skill mirrors with glossary-canonical English **in-place**.
- Keep `.cursor` ↔ `.claude` mirrors content-equivalent (G-MIRROR / `cmp -s`).
- Preserve freeze-list tokens, `/opsx:archive` / explore / propose workflow semantics, and Guardrails meaning.
- Align Session Handoff / chat stubs with F7 (chat MAY be pt-BR; skill artifact MUST be English).
- Pass `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-archive-change/SKILL.md,.claude/skills/openspec-archive-change/SKILL.md`.

**Non-Goals:**

- Other opsx skills (`openspec-propose` owned by open PR #91; explore/apply/review already proposed).
- Commands under `.cursor/commands/` / `.claude/commands/opsx/` (paired residual stubs → later WRu / commands wave).
- Canonical guide; `doc/design/001` over-budget split; kit templates; hub infra; evaluations; course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing archive sync assessment, pattern-promotion optionality, or metrics-cadence advisory behavior — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WSk budgets; 1 skill × 2 mirrors
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, skill-mirror pairing
- `openspec/changes/translate-skills-wave-4/` — prior WSk propose pattern (deferred archive / propose residuals)
- Open DRAFT PR #91 — owns `openspec-propose` paths (skip that slice this run)
- AS-IS: `.cursor/skills/openspec-archive-change/SKILL.md` (= `.claude` mirror)
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown skills; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = `openspec-archive-change` only (1 skill × 2 mirrors)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `doc/design/001` alone (~592) | Rejected — exceeds ≤350–400 LOC; needs future split + G-PT strategy |
| C — Bundle four opsx command mirrors | Rejected — would exceed 1-skill×2 budget pattern and mix skill/command surfaces |
| D — `openspec-propose` (~141) | Rejected this run — path list already owned by open DRAFT PR #91 |
| E — `openspec-archive-change` as `translate-skills-wave-5` | **Chosen** — next free WSk residual after explore (merged) and propose (open PR #91); within LOC; whole-file G-PT + G-MIRROR; disjoint from owned set |

**Rationale:** Continues WSk with the remaining opsx archive skill still holding residual PT operator stubs; propose skill deferred to PR #91 apply chain; commands remain for a later disjoint wave.

### D2: In-place substitution — no dual-file; mirrors stay paired

**Chosen:** Edit both skill paths in the same apply; keep content identical. Forbidden: `SKILL.en.md` / `*-pt.md` siblings; updating only one mirror.

**Rationale:** `sdd-docs-language` dual-file prohibition + G-MIRROR + skill-mirror pairing requirement.

### D3: F7 chat language vs skill language

**Chosen:** Translate residual Portuguese pattern-promotion prompt, Session Handoff stubs (`Arquivo concluído…`, `Cole no primeiro message…`, `assumir ✅ — não reinstalar`, placeholders such as `<tópico>` / `<descrição>`), and metrics-cadence nudge prose to English. Keep F7-aligned: chat MAY use pt-BR; versioned skill MUST be English.

**Rationale:** Versioned artifacts MUST be English; leaving PT handoff stubs fails G-PT and fights F7.

### D4: Freeze archive Guardrails, sync assessment, and `/opsx:*`

**Chosen:** Keep Guardrails semantics (prompt for change selection; don't block on warnings; sync assessment before prompt), `/opsx:archive` workflow, skill `name: openspec-archive-change`, optional pattern-promotion checklist, and advisory metrics cadence behavior unchanged. Translate surrounding prose only.

**Rationale:** G-INV + behavioral stability for archive sessions.

### D5: Spec delta = lasting skill-mirror EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec-archive-change` mirrors MUST be English and content-equivalent. Do not invent a new capability in this language wave.

**Rationale:** Same pattern as skills-wave-1 / -2 / -3 / -4 ADDED requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Mirror drift after edit | Single source edit then `cp`/`cmp`; G-MIRROR in gate |
| Semantic drift on Guardrails / sync / metrics | Tasks forbid changing archive behavior; language only |
| G-PT false positives on leftover European forms | Prefer glossary EN; re-run deny-list locally before done |
| Parallel conflict with other skill/command proposes | Own only these two paths; document non-goals for sibling opsx skills/commands |
| PR #91 change-id collision (`translate-skills-wave-4`) | Out of scope; do not reopen propose ownership; human resolve on that PR |
| Commands remain PT while skill is EN | Accept temporary skew; commands get a later disjoint wave |

## Migration Plan

1. Apply: rewrite both skill mirrors EN in-place (identical content); F7 handoff stubs; freeze `/opsx:*` / Guardrails / sync / metrics cadence semantics.
2. Gate: `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-archive-change/SKILL.md,.claude/skills/openspec-archive-change/SKILL.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-skills-wave-5 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- .cursor/skills/openspec-archive-change/SKILL.md .claude/skills/openspec-archive-change/SKILL.md`.

## Open Questions

- None blocking propose. Follow-up residual candidates after this: opsx commands (≤4 files or paired mirrors), course WCu, `doc/design/001` split strategy, kit `sdd-kit/templates/doc/design/` mirrors (checksum-aware), residual `openspec/specs/*` PT, guide G-PT strategy. `openspec-propose` remains owned by open PR #91 until that propose merges/applies.
