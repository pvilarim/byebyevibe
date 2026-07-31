# Design — translate-skills-wave-6 (openspec-propose skill PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base includes kit W2c/W2d, hub `openspec/infra.md`, skills waves 1–5 (`correctness-review` / `simplify-review` / `openspec-apply-change` / `openspec-explore` / `openspec-archive-change`), avaliacoes/design waves. None own `openspec-propose` paths.
- Open translate PRs may include kit/avaliacoes applies; none own `openspec-propose` mirrors. Former colliding PR #91 (wrong change-id wave-4) is rematerialized as this wave-6.
- Canonical guide (`doc/sistema-sdd-pedro.md`, ~2847 LOC) remains deferred (whole-file G-PT / over budget) — not proposed in this wave.
- `openspec-propose` mirrors are identical today (~141 LOC each). Core Steps/Output/Enriched tasks sections are already English; residual Portuguese is concentrated in the Session Handoff stub (e.g. “Esta fase terminou…”, “Cole no primeiro message…”, “Ler:”, “assumir ✅ — não reinstalar”). Fits ≤1 skill × 2 mirrors and ≤350–400 LOC (logical skill body).
- This wave is **language only** — propose workflow Steps, AskUserQuestion flow, and §12.10 Gate/Pattern rules stay unchanged. Language ownership stays under `sdd-docs-language`.

## Goals / Non-Goals

**Goals:**

- Substitute all residual Portuguese prose in both `openspec-propose` skill mirrors with glossary-canonical English **in-place**.
- Keep `.cursor` ↔ `.claude` mirrors content-equivalent (G-MIRROR / `cmp -s`).
- Preserve freeze-list tokens, `/opsx:*`, sibling skill/command names, §12.10 references, and propose workflow semantics.
- Align Session Handoff / chat stubs with F7 (chat MAY be pt-BR; skill artifact MUST be English).
- Pass `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-propose/SKILL.md,.claude/skills/openspec-propose/SKILL.md`.

**Non-Goals:**

- Other opsx skills already proposed as waves 1–5 (`openspec-explore`, `openspec-archive-change`, apply/review skills).
- Commands under `.cursor/commands/` / `.claude/commands/opsx/` (paired residual stubs → later WRu / commands wave).
- Canonical guide; kit templates; hub infra; evaluations; design docs; course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing propose Steps, AskUserQuestion flow, or §12.10 Gate/Pattern/Skill rules — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WSk budgets; 1 skill × 2 mirrors
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, skill-mirror pairing
- `openspec/changes/translate-skills-wave-4/` / `translate-skills-wave-5/` — prior WSk propose patterns (explore / archive); this wave continues with propose skill
- AS-IS: `.cursor/skills/openspec-propose/SKILL.md` (= `.claude` mirror)
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown skills; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = `openspec-propose` only (1 skill × 2 mirrors)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths; operator forbade canonical guide this wave |
| B — Bundle `openspec-explore` (~304) with propose | Rejected — exceeds 1-skill×2 budget pattern |
| C — Bundle four opsx command mirrors | Rejected — mixes skill/command surfaces and file budget |
| D — `openspec-archive-change` | Already proposed as wave-5 |
| E — `openspec-propose` as `translate-skills-wave-6` | **Chosen** — rematerialized after change-id collision on wave-4 (explore took wave-4; archive took wave-5); within LOC; whole-file G-PT + G-MIRROR; disjoint from owned set |

**Rationale:** Continues WSk with the opsx propose skill still holding residual PT Session Handoff prose; mirrors already byte-identical and under budget.

### D2: In-place substitution — no dual-file; mirrors stay paired

**Chosen:** Edit both skill paths in the same apply; keep content identical. Forbidden: `SKILL.en.md` / `*-pt.md` siblings; updating only one mirror.

**Rationale:** `sdd-docs-language` dual-file prohibition + G-MIRROR + skill-mirror pairing requirement.

### D3: F7 chat language vs skill language

**Chosen:** Translate residual Portuguese Session Handoff stubs to English (e.g. phase-complete nudge, “paste into the first message”, “Read:”, “assume ✅ — do not reinstall”). Keep F7-aligned: chat MAY use pt-BR; versioned skill MUST be English.

**Rationale:** Versioned artifacts MUST be English; leaving PT handoff stubs fails G-PT and fights F7.

### D4: Freeze workflow steps and §12.10 rules

**Chosen:** Keep Steps 0–5, Guardrails, Enriched tasks (§12.10) Gate/Pattern/Skill rules, `/opsx:apply`, `openspec` CLI fences, and YAML frontmatter `name: openspec-propose` unchanged. Translate surrounding prose / handoff stubs only.

**Rationale:** G-INV + behavioral stability for the propose factory Automation and enriched-task verification.

### D5: Spec delta = lasting skill-mirror EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec-propose` mirrors MUST be English and content-equivalent. Do not invent a new capability in this language wave.

**Rationale:** Same pattern as skills-wave-1–5 ADDED requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Mirror drift after edit | Single source edit then `cp`/`cmp`; G-MIRROR in gate |
| Semantic drift on propose Steps / §12.10 | Tasks forbid changing workflow steps or Gate/Pattern rules; language only |
| G-PT false positives on leftover European forms | Prefer glossary EN; re-run deny-list locally before done |
| Parallel conflict with other skill/command proposes | Own only these two paths; document non-goals for sibling opsx skills/commands |
| Commands remain PT while skill is EN | Accept temporary skew; commands get a later disjoint wave |

## Migration Plan

1. Apply: rewrite both skill mirrors EN in-place (identical content); F7 handoff stubs; freeze paths/`/opsx:*`/CLI fences.
2. Gate: `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-propose/SKILL.md,.claude/skills/openspec-propose/SKILL.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-skills-wave-6 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- .cursor/skills/openspec-propose/SKILL.md .claude/skills/openspec-propose/SKILL.md`.

## Open Questions

- None blocking propose. Follow-up residual candidates after this: opsx commands (≤4 files or paired mirrors), course WCu, `doc/design/001` split strategy, kit `sdd-kit/templates/doc/design/` mirrors (checksum-aware), guide G-PT strategy. Opsx explore/archive skills already have proposes (waves 4–5).
