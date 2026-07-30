# Design — translate-skills-wave-3 (openspec-apply-change skill PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base includes kit W2c/W2d, hub `openspec/infra.md`, `correctness-review` / `simplify-review` skills, avaliacoes-wave-1, design-wave-1/2. None own `openspec-apply-change` paths.
- Open translate PRs: kit apply PR #78 (kit templates); avaliacoes-wave-2 propose PR #84 (two evaluation records). Neither owns these skill mirrors.
- Canonical guide (`doc/sistema-sdd-pedro.md`, ~2847 LOC) and `doc/design/001` (~592 LOC) remain deferred (whole-file G-PT / over budget).
- `openspec-apply-change` mirrors are identical today (~224 LOC each). Core Steps/Output sections are already English; residual Portuguese is concentrated in Session coordination, Session Handoff stubs, and a few operator strings (e.g. simplify-review suggestion, “Reviews pós-implementação”). Fits ≤1 skill × 2 mirrors and ≤350–400 LOC (logical skill body).
- This wave is **language only** — apply workflow, R11 locks, and review-suggestion thresholds stay unchanged. Language ownership stays under `sdd-docs-language`.

## Goals / Non-Goals

**Goals:**

- Substitute all residual Portuguese prose in both `openspec-apply-change` skill mirrors with glossary-canonical English **in-place**.
- Keep `.cursor` ↔ `.claude` mirrors content-equivalent (G-MIRROR / `cmp -s`).
- Preserve freeze-list tokens, `/opsx:*`, session scripts, sibling skill names, numeric thresholds (~80 lines / >4 files), and apply workflow semantics.
- Align Session Handoff / chat stubs with F7 (chat MAY be pt-BR; skill artifact MUST be English).
- Pass `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-apply-change/SKILL.md,.claude/skills/openspec-apply-change/SKILL.md`.

**Non-Goals:**

- Other opsx skills (`openspec-propose`, `openspec-explore`, `openspec-archive-change`) and review skills already proposed.
- Commands under `.cursor/commands/` / `.claude/commands/opsx/` (paired residual stubs → later WRu / commands wave).
- Canonical guide; `doc/design/001` over-budget split; kit templates; hub infra; evaluations; course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing apply steps, R11 register/check/release semantics, or simplify-review suggestion thresholds — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WSk budgets; 1 skill × 2 mirrors
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, skill-mirror pairing
- `openspec/changes/translate-skills-wave-2/` — prior WSk propose pattern (deferred this residual)
- AS-IS: `.cursor/skills/openspec-apply-change/SKILL.md` (= `.claude` mirror)
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown skills; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = `openspec-apply-change` only (1 skill × 2 mirrors)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `doc/design/001` alone (~592) | Rejected — exceeds ≤350–400 LOC; needs future split + G-PT strategy |
| C — Bundle four opsx command mirrors | Rejected — would exceed 1-skill×2 budget pattern and mix skill/command surfaces |
| D — `openspec-explore` (~304) | Deferred — larger residual surface; valid later WSk wave |
| E — `openspec-apply-change` as `translate-skills-wave-3` | **Chosen** — next deferred WSk residual; within LOC; whole-file G-PT + G-MIRROR; disjoint from owned set |

**Rationale:** Continues WSk with the highest-leverage opsx skill still holding residual PT Session Handoff / R11 prose.

### D2: In-place substitution — no dual-file; mirrors stay paired

**Chosen:** Edit both skill paths in the same apply; keep content identical. Forbidden: `SKILL.en.md` / `*-pt.md` siblings; updating only one mirror.

**Rationale:** `sdd-docs-language` dual-file prohibition + G-MIRROR + skill-mirror pairing requirement.

### D3: F7 chat language vs skill language

**Chosen:** Translate residual Portuguese (Session coordination headings, Session Handoff stubs, operator suggestion strings, section cross-refs such as “Reviews pós-implementação” → “Post-implementation reviews”) to English. Keep F7-aligned: chat MAY use pt-BR; versioned skill MUST be English.

**Rationale:** Versioned artifacts MUST be English; leaving PT handoff stubs fails G-PT and fights F7.

### D4: Freeze scripts, thresholds, and sibling skill names

**Chosen:** Keep `scripts/sdd-session-register.sh` / `check` / `release`, `/opsx:apply` / `/opsx:archive`, sibling names `simplify-review` / `security-reviewer`, and numeric thresholds (~80 lines, >4 files) unchanged. Translate surrounding prose only.

**Rationale:** G-INV + behavioral stability for R11 and review nudges.

### D5: Spec delta = lasting skill-mirror EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec-apply-change` mirrors MUST be English and content-equivalent. Do not invent a new capability in this language wave.

**Rationale:** Same pattern as skills-wave-1 / skills-wave-2 ADDED requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Mirror drift after edit | Single source edit then `cp`/`cmp`; G-MIRROR in gate |
| Semantic drift on R11 / thresholds | Tasks forbid changing scripts, thresholds, workflow steps; language only |
| G-PT false positives on leftover European forms | Prefer glossary EN; re-run deny-list locally before done |
| Parallel conflict with other skill/command proposes | Own only these two paths; document non-goals for sibling opsx skills/commands |
| Commands remain PT while skill is EN | Accept temporary skew; commands get a later disjoint wave |

## Migration Plan

1. Apply: rewrite both skill mirrors EN in-place (identical content); F7 handoff stubs; freeze scripts/paths/`/opsx:*`.
2. Gate: `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-apply-change/SKILL.md,.claude/skills/openspec-apply-change/SKILL.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-skills-wave-3 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- .cursor/skills/openspec-apply-change/SKILL.md .claude/skills/openspec-apply-change/SKILL.md`.

## Open Questions

- None blocking propose. Follow-up residual candidates after this: other opsx skills (`openspec-explore` / `propose` / `archive-change`), opsx commands (≤4 files or paired mirrors), course WCu, `doc/design/001` split strategy, kit `sdd-kit/templates/doc/design/` mirrors (checksum-aware), guide G-PT strategy.
