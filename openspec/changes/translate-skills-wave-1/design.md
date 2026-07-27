# Design — translate-skills-wave-1 (correctness-review skill PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership: kit W2c/W2d (kit Cursor rules + proposal scaffold), hub `openspec/infra.md` (`translate-infra-wave-1`). None own skill mirrors.
- Canonical guide (`doc/sistema-sdd-pedro.md`, ~2847 LOC) is next in WAVES.md order but cannot pass whole-file G-PT until a section strategy lands; prior factory design deferred guide mid-file proposes.
- `correctness-review` mirrors are identical today (~182 LOC each, ~364 total) and are mostly Portuguese prose (frontmatter `description`, headings, tables, examples, verdicts). Fits ≤1 skill × 2 mirrors and ≤350–400 LOC.
- Behavioral capability already exists as `sdd-correctness-review` — this wave is **language only**, not a semantics redesign.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in both `correctness-review` skill mirrors with glossary-canonical English **in-place**.
- Keep `.cursor` ↔ `.claude` mirrors content-equivalent (G-MIRROR / `cmp -s`).
- Preserve freeze-list tokens, finding tags, `/opsx:*`, invoke thresholds (~80 lines / >4 files), and pipeline ordering vs `simplify-review` / `security-reviewer`.
- Align response-language guidance with F7 (chat MAY be pt-BR; skill artifact MUST be English).
- Pass `bash scripts/verify-i18n-wave.sh --files .cursor/skills/correctness-review/SKILL.md,.claude/skills/correctness-review/SKILL.md`.

**Non-Goals:**

- Other skills (`openspec-*`, `simplify-review`, gitnexus).
- Commands under `.cursor/commands/` / `.claude/commands/opsx/` (path layout differs; separate WRu waves).
- Canonical guide section waves; kit templates; hub infra; evaluations; course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing `sdd-correctness-review` invoke rules, tag set, or boundaries — language only.
- Creating `.claude/agents/correctness-reviewer.md` (still deferred per skill table).

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WSk budgets; 1 skill × 2 mirrors
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, skill-mirror pairing
- `openspec/specs/sdd-correctness-review/spec.md` — behavioral contract (do not weaken)
- `openspec/changes/translate-infra-wave-1/design.md` — guide mid-file G-PT deferral; factory → skills/avaliacoes next
- AS-IS: `.cursor/skills/correctness-review/SKILL.md` (= `.claude` mirror)
- Pattern: `AGENTS.md` “Post-implementation reviews” (already EN) for tone of when-to-invoke table
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown skills; no code symbols)

## Decisions

### D1: Scope = `correctness-review` only (1 skill × 2 mirrors)

| Option | Verdict |
|--------|---------|
| A — Guide W3 front+§1 partial file | Rejected — G-PT scans whole `--files` paths; residual PT elsewhere in the guide fails the gate |
| B — `openspec-propose` skill first | Rejected for this slot — near-EN already (Session Handoff residual only); lower factory value vs full-PT review skill |
| C — `correctness-review` as `translate-skills-wave-1` | **Chosen** — substantial PT; within LOC; whole-file G-PT + G-MIRROR achievable; disjoint paths |
| D — Bundle 4 `doc/avaliacoes/` files | Deferred — WAv later; WSk next after guide deferral |

**Rationale:** Unblocks WSk with a completable slice while guide strategy remains open.

### D2: In-place substitution — no dual-file; mirrors stay paired

**Chosen:** Edit both skill paths in the same apply; keep content identical. Forbidden: `SKILL.en.md` / `*-pt.md` siblings; updating only one mirror.

**Rationale:** `sdd-docs-language` dual-file prohibition + G-MIRROR + skill-mirror pairing requirement.

### D3: F7 chat language vs skill language

**Chosen:** Translate the skill body (including frontmatter `description`) to English. Replace hard “always respond in pt-BR” with F7-aligned wording: chat MAY use pt-BR; do not require Portuguese for findings. Example snippets in the skill MAY use English sample prose (findings format stays tag-based).

**Rationale:** Versioned artifacts MUST be English; forcing PT chat in an EN skill would reintroduce deny-list tokens and fight F7.

### D4: Freeze tags, thresholds, and sibling skill names

**Chosen:** Keep `logic:` / `edge:` / `contract:` / `race:` / `silent:`, verdict tokens mapped to English (`CORRECT`, `RISKY`, `INSUFFICIENT SCOPE`), `/opsx:apply`, `simplify-review`, `security-reviewer`, and numeric thresholds (~80 lines, >4 files) unchanged in meaning. Translate surrounding prose and table headers only.

**Rationale:** G-INV + `sdd-correctness-review` behavioral stability; agents parse tags as identifiers.

### D5: Spec delta = lasting skill-mirror EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that `correctness-review` mirrors MUST be English and content-equivalent. Do not MODIFY `sdd-correctness-review` unless a normative English-language statement is required there (prefer docs-language ownership).

**Rationale:** Same pattern as W1/W2/infra slice ADDED requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Mirror drift after edit | Single source edit then `cp`/`cmp`; G-MIRROR in gate |
| Semantic drift vs `sdd-correctness-review` | Tasks forbid changing thresholds/tags/boundaries; language only |
| G-PT false positives on leftover European forms | Prefer glossary EN; re-run deny-list locally before done |
| Example blocks still PT after partial translate | Slice DoD = zero residual PT prose in both files — translate examples too |
| Parallel conflict with other skill proposes | Own only these two paths; document non-goals for other skills |

## Migration Plan

1. Apply: rewrite both skill mirrors EN in-place (identical content); F7 chat note; freeze tags/paths/`/opsx:*`.
2. Gate: `bash scripts/verify-i18n-wave.sh --files .cursor/skills/correctness-review/SKILL.md,.claude/skills/correctness-review/SKILL.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-skills-wave-1 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- .cursor/skills/correctness-review/SKILL.md .claude/skills/correctness-review/SKILL.md`.

## Open Questions

- None blocking propose. Guide whole-file G-PT strategy remains a separate design (out of scope). Follow-up WSk candidates: `simplify-review`, then opsx skills with residual Session Handoff PT / larger apply+explore splits.
