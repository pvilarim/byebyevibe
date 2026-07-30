# Design — translate-commands-wave-1 (opsx-apply commands PT→EN + G-MIRROR peer map)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- WSk skills waves 1–5 proposed review + opsx skill mirrors; open DRAFT PR #91 owns `openspec-propose` skill paths (colliding change-id vs master explore wave-4 — human resolve).
- Active translate ownership on current base also includes kit W2c/W2d, hub `openspec/infra.md`, avaliacoes-wave-1, design-wave-1/2. None own `.cursor/commands/opsx-*` or `.claude/commands/opsx/*`.
- Open translate PRs: kit apply #78 (kit templates); avaliacoes-wave-2 #84; skills propose #91 (`openspec-propose`). None own opsx command paths.
- Command layout is **asymmetric**: Cursor uses `.cursor/commands/opsx-<verb>.md`; Claude uses `.claude/commands/opsx/<verb>.md`. YAML frontmatter differs by IDE. Prose bodies are near-duplicates with residual Portuguese in Session Handoff / R11 stubs (densest in `opsx-apply`).
- Current `scripts/verify-i18n-wave.sh` `mirror_peer` only string-replaces `.cursor/` ↔ `.claude/`, so it expects `.claude/commands/opsx-apply.md` (missing) and would fail G-MIRROR even after perfect EN prose. Skill mirrors must keep strict `cmp -s`.
- Canonical guide (~2847 LOC) and `doc/design/001` (~592 LOC) remain deferred (whole-file G-PT / over budget).
- This wave is **language only** for command prose — R11 flock semantics stay unchanged. Script change is gate infrastructure only.

## Goals / Non-Goals

**Goals:**

- Substitute all residual Portuguese prose in both `opsx-apply` command files with glossary-canonical English **in-place**.
- Update **both** IDE sides in the same apply.
- Fix G-MIRROR peer mapping for asymmetric opsx command paths; do not require byte-identical command content.
- Preserve freeze-list tokens and R11 / `/opsx:apply` workflow semantics.
- Align Session Handoff / chat stubs with F7 (chat MAY be pt-BR; versioned command MUST be English).
- Pass `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-apply.md,.claude/commands/opsx/apply.md`.

**Non-Goals:**

- `opsx-archive` / `opsx-propose` / `opsx-explore` command pairs (later `translate-commands-wave-N`).
- Skills (already proposed / owned by open PRs).
- Canonical guide; `doc/design/001`; kit templates; hub infra; evaluations; course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing R11 flock/register/release behavior — language only.
- Forcing Cursor ↔ Claude command files to become byte-identical (frontmatter is platform-specific).
- Broad rewrite of verify-i18n-wave.sh beyond `mirror_peer` / command `cmp` exception.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WRu budgets; ≤4 files
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-skills-wave-5/` — prior propose pattern; deferred commands explicitly
- Open DRAFT PRs #78 / #84 / #91 — owned path lists (skip)
- AS-IS: `.cursor/commands/opsx-apply.md` ↔ `.claude/commands/opsx/apply.md`
- `scripts/verify-i18n-wave.sh` — G-MIRROR peer logic
- Graphify / GitNexus — SKIP / docs-only (markdown commands; no code symbols)
- GitHub Issues — unavailable to this integration (**Issue:** —)

## Decisions

### D1: Scope = opsx-apply pair + verify script (3 files)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `doc/design/001` alone (~592) | Rejected — exceeds ≤350–400 LOC; needs future split |
| C — All four opsx verbs × 2 (= 8 files) | Rejected — exceeds ≤4-file budget |
| D — apply + archive (4 files) without script fix | Rejected — G-MIRROR fails closed on asymmetric paths |
| E — apply + archive + script (≥5 files) | Rejected — exceeds ≤4-file budget |
| F — `opsx-apply` × 2 + `verify-i18n-wave.sh` as `translate-commands-wave-1` | **Chosen** — densest command residual; unlocks G-MIRROR for later command waves; 3 files; within LOC; disjoint |
| G — Course `aula-04` alone | Valid alternate; deferred — WRu commands preferred after WSk per `WAVES.md` order |

**Rationale:** Unblocks the commands track with the densest residual (`opsx-apply` R11/Handoff PT) and fixes the gate so later archive/propose/explore command waves can pass G-MIRROR without repeating the script change.

### D2: In-place substitution — no dual-file; both IDE sides required

**Chosen:** Edit both command paths in the same apply. Forbidden: `*.en.md` / `*-pt.md` siblings; updating only Cursor or only Claude.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES commands-mirrors pairing intent.

### D3: G-MIRROR peer map for opsx commands; skip content cmp for commands

**Chosen:** Extend `mirror_peer` (or equivalent) so:

| Cursor | Claude |
|--------|--------|
| `.cursor/commands/opsx-<verb>.md` | `.claude/commands/opsx/<verb>.md` |

Reverse mapping likewise. For these command pairs: require peer listed + peer file exists; **do not** `cmp -s` (frontmatter differs). Skill paths under `.cursor/skills/` / `.claude/skills/` keep existing strict `cmp -s` behavior.

**Rationale:** Naive `.cursor/` ↔ `.claude/` replace invents missing paths; byte-identity is wrong for IDE-specific command frontmatter.

### D4: F7 chat language vs command language

**Chosen:** Translate residual Portuguese Session Handoff stubs, R11 coordination prose (`Antes de editar ficheiros…`, `não reinstalar`, etc.), and simplify-review suggestion (`N ficheiros`) to English. Keep F7-aligned: chat MAY use pt-BR; versioned command MUST be English.

**Rationale:** Versioned artifacts MUST be English; leaving PT handoff stubs fails G-PT and fights F7.

### D5: Freeze R11 semantics and `/opsx:*`

**Chosen:** Keep R11 register/check/release flow and `/opsx:apply` slash forms unchanged. Translate surrounding prose only. Preserve platform-specific YAML frontmatter structure per IDE.

**Rationale:** G-INV + behavioral stability for apply sessions.

### D6: Spec delta = lasting command EN + G-MIRROR mapping requirement

**Chosen:** ADDED requirements under `sdd-docs-language` that (1) `opsx-apply` command pair MUST be English on both IDE paths, and (2) G-MIRROR peer mapping MUST understand asymmetric opsx command paths without requiring byte-identical command content. Do not invent a new capability.

**Rationale:** Same ADDED-requirement pattern as skills waves; scopes this slice + lasting gate behavior.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Agent updates only one IDE side | Tasks gate both Cursor and Claude paths |
| Script change breaks skill G-MIRROR | Tasks require skill pair still `cmp -s`; regression gate on a known skill path pair optional / smoke |
| Semantic drift on R11 | Tasks forbid changing flock semantics; language only |
| G-PT false positives | Prefer glossary EN; re-run deny-list locally before done |
| Parallel conflict with other command proposes | Own only these three paths; document non-goals for other verbs |
| Temporary skew: archive/propose/explore commands still PT | Accept; later disjoint waves reuse fixed peer map |

## Migration Plan

1. Apply: patch `mirror_peer` / command `cmp` exception in `scripts/verify-i18n-wave.sh`.
2. Apply: rewrite residual PT → EN in both `opsx-apply` command files; keep IDE frontmatter; freeze `/opsx:*` / R11 semantics.
3. Gate: `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-apply.md,.claude/commands/opsx/apply.md`.
4. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-commands-wave-1 --strict`.
5. Archive later (separate session): promote ADDED requirements into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- .cursor/commands/opsx-apply.md .claude/commands/opsx/apply.md scripts/verify-i18n-wave.sh`.

## Open Questions

- None blocking propose. Follow-up residual candidates after this: `opsx-archive` / `opsx-propose` / `opsx-explore` commands, course WCu, `doc/design/001` split, kit `sdd-kit/templates/doc/design/` mirrors (checksum-aware; prefer after hub design apply), residual `openspec/specs/*` PT, guide G-PT strategy. `openspec-propose` **skill** remains owned by open PR #91.
