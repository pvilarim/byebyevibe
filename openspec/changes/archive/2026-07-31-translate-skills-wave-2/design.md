# Design — translate-skills-wave-2 (simplify-review skill PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base: kit W2c/W2d (kit Cursor rules + proposal scaffold), hub `openspec/infra.md` (`translate-infra-wave-1`), `correctness-review` mirrors (`translate-skills-wave-1`). None own `simplify-review` paths.
- Open translate PRs do not claim these skill mirrors (kit apply PR #78 owns kit templates only).
- Canonical guide (`doc/sistema-sdd-pedro.md`, ~2847 LOC) remains deferred for mid-file G-PT; factory prefers completable whole-file slices.
- `simplify-review` mirrors are identical today (~196 LOC each, ~392 total) and are mostly Portuguese prose (frontmatter `description`, headings, tables, examples, verdicts). Fits ≤1 skill × 2 mirrors and ≤350–400 LOC.
- Behavioral guidance already lives in `AGENTS.md` “Post-implementation reviews” and the skill itself — this wave is **language only**, not a semantics redesign. There is no separate `sdd-simplify-review` capability yet; language ownership stays under `sdd-docs-language`.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in both `simplify-review` skill mirrors with glossary-canonical English **in-place**.
- Keep `.cursor` ↔ `.claude` mirrors content-equivalent (G-MIRROR / `cmp -s`).
- Preserve freeze-list tokens, finding tags, `/opsx:*`, invoke thresholds (~80 lines / >4 files), protected-boundary table semantics, and pipeline position vs `correctness-review` / `security-reviewer`.
- Align response-language guidance with F7 (chat MAY be pt-BR; skill artifact MUST be English).
- Pass `bash scripts/verify-i18n-wave.sh --files .cursor/skills/simplify-review/SKILL.md,.claude/skills/simplify-review/SKILL.md`.

**Non-Goals:**

- Other skills (`openspec-*`, `correctness-review`, gitnexus).
- Commands under `.cursor/commands/` / `.claude/commands/opsx/`.
- Canonical guide section waves; kit templates; hub infra; evaluations; course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing invoke rules, tag set, protected boundaries, or pipeline order — language only.
- Creating `.claude/agents/simplify-reviewer.md` (still deferred per skill table).

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WSk budgets; 1 skill × 2 mirrors
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, skill-mirror pairing
- `openspec/specs/sdd-correctness-review/spec.md` — sibling skill boundaries (do not weaken)
- `openspec/changes/translate-skills-wave-1/` — prior WSk propose pattern
- AS-IS: `.cursor/skills/simplify-review/SKILL.md` (= `.claude` mirror)
- Pattern: `AGENTS.md` “Post-implementation reviews” (already EN) for when-to-invoke table tone
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown skills; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = `simplify-review` only (1 skill × 2 mirrors)

| Option | Verdict |
|--------|---------|
| A — Guide W3 front+§1 partial file | Rejected — G-PT scans whole `--files` paths; residual PT elsewhere in the guide fails the gate |
| B — Bundle small `doc/avaliacoes/` files (WAv) | Deferred — WSk continuation preferred after wave-1; avaliacoes remain available for a later disjoint propose |
| C — `openspec-apply-change` residual PT | Rejected for this slot — mixed EN body + small residual; better as a later opsx residual wave; may need LOC splits with explore |
| D — `simplify-review` as `translate-skills-wave-2` | **Chosen** — substantial PT; within LOC; whole-file G-PT + G-MIRROR achievable; disjoint from wave-1 / kit / infra |

**Rationale:** Continues WSk with the next full-PT review skill while guide strategy remains open.

### D2: In-place substitution — no dual-file; mirrors stay paired

**Chosen:** Edit both skill paths in the same apply; keep content identical. Forbidden: `SKILL.en.md` / `*-pt.md` siblings; updating only one mirror.

**Rationale:** `sdd-docs-language` dual-file prohibition + G-MIRROR + skill-mirror pairing requirement.

### D3: F7 chat language vs skill language

**Chosen:** Translate the skill body (including frontmatter `description` and `adaptedFrom`) to English. Replace hard “always respond in pt-BR” with F7-aligned wording: chat MAY use pt-BR; do not require Portuguese for findings. Example snippets in the skill MUST use English sample prose (findings format stays tag-based).

**Rationale:** Versioned artifacts MUST be English; forcing PT chat in an EN skill would reintroduce deny-list tokens and fight F7.

### D4: Freeze tags, thresholds, verdicts, and sibling skill names

**Chosen:** Keep `delete:` / `stdlib:` / `native:` / `yagni:` / `shrink:`, marker `sdd-shortcut:`, verdicts `LEAN` / `TRIMMABLE`, `/opsx:apply`, sibling names `correctness-review` / `security-reviewer`, and numeric thresholds (~80 lines, >4 files) unchanged in meaning. Map Portuguese verdict `ESCOPO CONFLITANTE` → `CONFLICTING SCOPE`. Translate surrounding prose and table headers only.

**Rationale:** G-INV + behavioral stability; agents parse tags as identifiers; same mapping pattern as wave-1 (`ESCOPO INSUFICIENTE` → `INSUFFICIENT SCOPE`).

### D5: Spec delta = lasting skill-mirror EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that `simplify-review` mirrors MUST be English and content-equivalent. Do not invent a new `sdd-simplify-review` capability in this language wave.

**Rationale:** Same pattern as W1/W2/infra/skills-wave-1 slice ADDED requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Mirror drift after edit | Single source edit then `cp`/`cmp`; G-MIRROR in gate |
| Semantic drift on protected boundaries | Tasks forbid changing protected table / thresholds / tags; language only |
| G-PT false positives on leftover European forms | Prefer glossary EN; re-run deny-list locally before done |
| Example blocks still PT after partial translate | Slice DoD = zero residual PT prose in both files — translate examples too |
| Parallel conflict with other skill proposes | Own only these two paths; document non-goals for other skills |
| LOC at upper budget (~392) | Fits “≤350–400”; do not bundle glossary unless a new term is truly required |

## Migration Plan

1. Apply: rewrite both skill mirrors EN in-place (identical content); F7 chat note; freeze tags/paths/`/opsx:*`/`sdd-shortcut:`.
2. Gate: `bash scripts/verify-i18n-wave.sh --files .cursor/skills/simplify-review/SKILL.md,.claude/skills/simplify-review/SKILL.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-skills-wave-2 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- .cursor/skills/simplify-review/SKILL.md .claude/skills/simplify-review/SKILL.md`.

## Open Questions

- None blocking propose. Follow-up WSk / residual candidates after this: opsx skills (`openspec-apply-change` residual PT; propose/archive/explore Session Handoff stubs), then WAv (`doc/avaliacoes/`) or design docs within budgets. Guide whole-file G-PT strategy remains separate.
