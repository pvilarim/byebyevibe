# Design — translate-skills-wave-4 (openspec-explore skill PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base includes kit W2c/W2d (apply landed), hub `openspec/infra.md`, `correctness-review` / `simplify-review` / `openspec-apply-change` skills, avaliacoes-wave-1, design-wave-1/2. None own `openspec-explore` paths.
- Open translate PRs: kit apply PR #78 (may still list kit templates); avaliacoes-wave-2 propose PR #84 (two evaluation records). Neither owns these skill mirrors.
- Canonical guide (`doc/sistema-sdd-pedro.md`, ~2847 LOC) and `doc/design/001` (~592 LOC) remain deferred (whole-file G-PT / over budget).
- `openspec-explore` mirrors are identical today (~304 LOC each). Core Steps/Guardrails are already English; residual Portuguese is concentrated in the Session Handoff stub. Fits ≤1 skill × 2 mirrors and ≤350–400 LOC (logical skill body).
- This wave is **language only** — explore Guardrails (do not implement), research capture offers, and propose handoff targets stay unchanged. Language ownership stays under `sdd-docs-language`.

## Goals / Non-Goals

**Goals:**

- Substitute all residual Portuguese prose in both `openspec-explore` skill mirrors with glossary-canonical English **in-place**.
- Keep `.cursor` ↔ `.claude` mirrors content-equivalent (G-MIRROR / `cmp -s`).
- Preserve freeze-list tokens, `/opsx:propose` / explore workflow semantics, and Guardrails meaning.
- Align Session Handoff / chat stubs with F7 (chat MAY be pt-BR; skill artifact MUST be English).
- Pass `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-explore/SKILL.md,.claude/skills/openspec-explore/SKILL.md`.

**Non-Goals:**

- Other opsx skills (`openspec-propose`, `openspec-archive-change`) and skills already proposed (apply / review).
- Commands under `.cursor/commands/` / `.claude/commands/opsx/` (paired residual stubs → later WRu / commands wave).
- Canonical guide; `doc/design/001` over-budget split; kit templates; hub infra; evaluations; course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing explore Guardrails, auto-capture policy, or propose handoff targets — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WSk budgets; 1 skill × 2 mirrors
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, skill-mirror pairing
- `openspec/changes/translate-skills-wave-3/` — prior WSk propose pattern (deferred this residual as D1 option D)
- AS-IS: `.cursor/skills/openspec-explore/SKILL.md` (= `.claude` mirror)
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown skills; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = `openspec-explore` only (1 skill × 2 mirrors)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `doc/design/001` alone (~592) | Rejected — exceeds ≤350–400 LOC; needs future split + G-PT strategy |
| C — Bundle four opsx command mirrors | Rejected — would exceed 1-skill×2 budget pattern and mix skill/command surfaces |
| D — `openspec-propose` (~141) | Deferred — smaller; valid later WSk wave after explore |
| E — `openspec-explore` as `translate-skills-wave-4` | **Chosen** — next deferred WSk residual from wave-3 open questions; within LOC; whole-file G-PT + G-MIRROR; disjoint from owned set |

**Rationale:** Continues WSk with the largest remaining opsx skill still holding residual PT Session Handoff prose; propose/archive skills remain for later disjoint waves.

### D2: In-place substitution — no dual-file; mirrors stay paired

**Chosen:** Edit both skill paths in the same apply; keep content identical. Forbidden: `SKILL.en.md` / `*-pt.md` siblings; updating only one mirror.

**Rationale:** `sdd-docs-language` dual-file prohibition + G-MIRROR + skill-mirror pairing requirement.

### D3: F7 chat language vs skill language

**Chosen:** Translate residual Portuguese Session Handoff stubs (`Esta fase terminou…`, `Cole no primeiro message…`, `Ler:…`, `assumir ✅ — não reinstalar`, placeholder fragments such as `ou descrição` / `se existir` / `notas de exploração`) to English. Keep F7-aligned: chat MAY use pt-BR; versioned skill MUST be English.

**Rationale:** Versioned artifacts MUST be English; leaving PT handoff stubs fails G-PT and fights F7.

### D4: Freeze explore Guardrails and `/opsx:*`

**Chosen:** Keep Guardrails semantics (Don't implement / Don't fake understanding / etc.), `/opsx:propose` handoff target, skill `name: openspec-explore`, and research.md path references unchanged. Translate surrounding prose only.

**Rationale:** G-INV + behavioral stability for type-E explore sessions.

### D5: Spec delta = lasting skill-mirror EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec-explore` mirrors MUST be English and content-equivalent. Do not invent a new capability in this language wave.

**Rationale:** Same pattern as skills-wave-1 / -2 / -3 ADDED requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Mirror drift after edit | Single source edit then `cp`/`cmp`; G-MIRROR in gate |
| Semantic drift on Guardrails | Tasks forbid changing Guardrails meaning or explore→implement behavior; language only |
| G-PT false positives on leftover European forms | Prefer glossary EN; re-run deny-list locally before done |
| Parallel conflict with other skill/command proposes | Own only these two paths; document non-goals for sibling opsx skills/commands |
| Commands remain PT while skill is EN | Accept temporary skew; commands get a later disjoint wave |

## Migration Plan

1. Apply: rewrite both skill mirrors EN in-place (identical content); F7 handoff stubs; freeze `/opsx:*` / Guardrails.
2. Gate: `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-explore/SKILL.md,.claude/skills/openspec-explore/SKILL.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-skills-wave-4 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- .cursor/skills/openspec-explore/SKILL.md .claude/skills/openspec-explore/SKILL.md`.

## Open Questions

- None blocking propose. Follow-up residual candidates after this: `openspec-propose` / `openspec-archive-change`, opsx commands (≤4 files or paired mirrors), course WCu, `doc/design/001` split strategy, kit `sdd-kit/templates/doc/design/` mirrors (checksum-aware), guide G-PT strategy.
