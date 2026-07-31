# Design — translate-commands-wave-2 (opsx-archive commands PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-commands-wave-1` (open DRAFT PR #93) owns `.cursor/commands/opsx-apply.md`, `.claude/commands/opsx/apply.md`, and the G-MIRROR peer-map fix in `scripts/verify-i18n-wave.sh` for asymmetric opsx command paths.
- Active translate ownership on current base also includes kit W2c/W2d, hub `openspec/infra.md`, avaliacoes-wave-1, design-wave-1/2, skills-wave-1–6. None own `opsx-archive` command paths.
- Open translate PRs relevant to ownership: kit apply #78; avaliacoes-wave-2 #84; commands-wave-1 #93 (`opsx-apply` + verify script). None own `opsx-archive`.
- Command layout is **asymmetric**: Cursor `.cursor/commands/opsx-archive.md` ↔ Claude `.claude/commands/opsx/archive.md`. YAML frontmatter differs by IDE. Prose bodies are near-duplicates with residual Portuguese in a reusable-pattern prompt and Session Handoff stubs (~179 LOC per side).
- Canonical guide (~2847 LOC) and `doc/design/001` (~592 LOC) remain deferred (whole-file G-PT / over budget).
- This wave is **language only** — archive workflow semantics stay unchanged. No second edit to `verify-i18n-wave.sh` (peer map is wave-1’s job).

## Goals / Non-Goals

**Goals:**

- Substitute all residual Portuguese prose in both `opsx-archive` command files with glossary-canonical English **in-place**.
- Update **both** IDE sides in the same apply.
- Preserve freeze-list tokens and `/opsx:archive` / `/opsx:explore` / `/opsx:propose` workflow semantics.
- Align Session Handoff / chat stubs with F7 (chat MAY be pt-BR; versioned command MUST be English).
- Pass `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-archive.md,.claude/commands/opsx/archive.md` (requires wave-1 peer map on the apply base).

**Non-Goals:**

- `opsx-apply` (owned by commands-wave-1 / PR #93).
- `opsx-propose` / `opsx-explore` command pairs (later `translate-commands-wave-N`).
- Skills; canonical guide; `doc/design/001`; kit templates; hub infra; evaluations; course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing archive sync/assessment behavior — language only.
- Forcing Cursor ↔ Claude command files to become byte-identical.
- Re-patching `scripts/verify-i18n-wave.sh` in this wave.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WRu budgets; ≤4 files / 1 command × 2 mirrors
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open DRAFT PR #93 artifacts (`translate-commands-wave-1`) — prior commands propose + peer-map decision
- Open DRAFT PRs #78 / #84 / #93 — owned path lists (skip)
- AS-IS: `.cursor/commands/opsx-archive.md` ↔ `.claude/commands/opsx/archive.md`
- Graphify / GitNexus — SKIP / docs-only (markdown commands; no code symbols)
- GitHub Issues — unavailable to this integration (**Issue:** —)

## Decisions

### D1: Scope = opsx-archive pair only (2 files)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `doc/design/001` alone (~592) | Rejected — exceeds ≤350–400 LOC; needs future split |
| C — archive + propose + explore (= 6 files) | Rejected — exceeds ≤4-file budget |
| D — archive + propose (4 files) | Valid alternate; deferred — prefer one verb per wave after wave-1 pattern |
| E — `opsx-archive` × 2 as `translate-commands-wave-2` | **Chosen** — next residual after apply; ~179 LOC; disjoint; no script touch |
| F — Course `aula-04` alone | Valid alternate; deferred — continue WRu commands track |

**Rationale:** Continues the commands track unlocked by wave-1; single verb keeps review small and parallel-safe with other propose factory runs.

### D2: Soft prerequisite on commands-wave-1 apply (G-MIRROR)

**Chosen:** Propose may land in parallel with PR #93. **Apply** of this wave SHOULD wait until wave-1’s peer-map fix is on the apply base so G-MIRROR resolves asymmetric opsx paths without inventing `.claude/commands/opsx-archive.md`.

**Rationale:** `CURSOR-AUTOMATIONS.md` §2 — dependent apply after peer infrastructure; propose remains disjoint.

### D3: In-place substitution — no dual-file; both IDE sides required

**Chosen:** Edit both command paths in the same apply. Forbidden: `*.en.md` / `*-pt.md` siblings; updating only Cursor or only Claude.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES commands-mirrors pairing intent.

### D4: F7 chat language vs command language

**Chosen:** Translate residual Portuguese Session Handoff stubs (`Arquivo concluído…`, `Cole no primeiro…`, `assumir ✅ — não reinstalar`, placeholder cues `<tópico>` / `<descrição>`) and the reusable-pattern prompt (`Este change estabeleceu…`) to English. Keep F7-aligned: chat MAY use pt-BR; versioned command MUST be English.

**Rationale:** Versioned artifacts MUST be English; leaving PT handoff stubs fails G-PT and fights F7.

### D5: Freeze archive semantics and `/opsx:*`

**Chosen:** Keep archive sync assessment, `.openspec.yaml` preservation, and `/opsx:archive` slash forms unchanged. Translate surrounding prose only. Preserve platform-specific YAML frontmatter structure per IDE.

**Rationale:** G-INV + behavioral stability for archive sessions.

### D6: Spec delta = lasting opsx-archive EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that the `opsx-archive` command pair MUST be English on both IDE paths. Do not invent a new capability. Do not restate the wave-1 G-MIRROR peer-map requirement (already owned there).

**Rationale:** Same ADDED-requirement pattern as commands-wave-1 / skills waves; scopes this slice only.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Agent updates only one IDE side | Tasks gate both Cursor and Claude paths |
| Apply before wave-1 peer map lands | Soft prerequisite in proposal/design/Session Handoff; G-MIRROR will fail closed until then |
| Semantic drift on archive sync | Tasks forbid changing archive workflow semantics; language only |
| G-PT false positives | Prefer glossary EN; re-run deny-list locally before done |
| Parallel conflict with other command proposes | Own only these two paths; document non-goals for other verbs |

## Migration Plan

1. Apply (after wave-1 peer map preferred): rewrite residual PT → EN in both `opsx-archive` command files; keep IDE frontmatter; freeze `/opsx:*` / archive semantics.
2. Gate: `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-archive.md,.claude/commands/opsx/archive.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-commands-wave-2 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- .cursor/commands/opsx-archive.md .claude/commands/opsx/archive.md`.

## Open Questions

- None blocking propose. Follow-up residual candidates after this: `opsx-propose` / `opsx-explore` commands (`translate-commands-wave-3+`), course WCu, `doc/design/001` split, kit `sdd-kit/templates/doc/design/` mirrors (checksum-aware; prefer after hub design apply), residual `openspec/specs/*` PT, guide G-PT strategy.
