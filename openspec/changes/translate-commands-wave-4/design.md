# Design — translate-commands-wave-4 (opsx-explore commands PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-commands-wave-1` (open DRAFT PR #93) owns `.cursor/commands/opsx-apply.md`, `.claude/commands/opsx/apply.md`, and the G-MIRROR peer-map fix in `scripts/verify-i18n-wave.sh` for asymmetric opsx command paths.
- `translate-commands-wave-2` (open DRAFT PR #96) owns `.cursor/commands/opsx-archive.md` and `.claude/commands/opsx/archive.md`.
- `translate-commands-wave-3` (open DRAFT PR #97) owns `.cursor/commands/opsx-propose.md` and `.claude/commands/opsx/propose.md`.
- Active translate ownership on current base also includes kit W2c/W2d, hub `openspec/infra.md`, avaliacoes-wave-1, design-wave-1/2, skills-wave-1–6. None own `opsx-explore` **command** paths (`translate-skills-wave-4` owns / already applied the `openspec-explore` **skill** mirrors only).
- Open translate PRs relevant to ownership: kit apply #78; avaliacoes-wave-2 #84; commands-wave-1 #93; commands-wave-2 #96; commands-wave-3 #97. None own `opsx-explore` commands.
- Command layout is **asymmetric**: Cursor `.cursor/commands/opsx-explore.md` ↔ Claude `.claude/commands/opsx/explore.md`. YAML frontmatter differs by IDE. Prose bodies are near-duplicates; residual Portuguese is concentrated in Session Handoff stubs (~189 LOC per side).
- Canonical guide (~2847 LOC) and `doc/design/001` (~592 LOC) remain deferred (whole-file G-PT / over budget).
- This wave is **language only** — explore workflow Steps/Output and research.md conventions stay unchanged. No edit to `verify-i18n-wave.sh` (peer map is wave-1’s job).

## Goals / Non-Goals

**Goals:**

- Substitute all residual Portuguese prose in both `opsx-explore` command files with glossary-canonical English **in-place**.
- Update **both** IDE sides in the same apply.
- Preserve freeze-list tokens and `/opsx:explore` / `/opsx:propose` / `/opsx:apply` / `/opsx:archive` workflow semantics.
- Align Session Handoff / chat stubs with F7 (chat MAY be pt-BR; versioned command MUST be English).
- Pass `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-explore.md,.claude/commands/opsx/explore.md` (requires wave-1 peer map on the apply base).

**Non-Goals:**

- `opsx-apply` (owned by commands-wave-1 / PR #93).
- `opsx-archive` (owned by commands-wave-2 / PR #96).
- `opsx-propose` commands (owned by commands-wave-3 / PR #97).
- `openspec-explore` skill mirrors (owned / apply-complete via `translate-skills-wave-4`).
- Other skills; canonical guide; `doc/design/001`; kit templates; hub infra; evaluations; course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing explore workflow Steps/Output, research.md capture conventions, or AskUserQuestion flow — language only.
- Forcing Cursor ↔ Claude command files to become byte-identical.
- Re-patching `scripts/verify-i18n-wave.sh` in this wave.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WRu budgets; ≤4 files / 1 command × 2 mirrors
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open DRAFT PR #93 / #96 / #97 artifacts (`translate-commands-wave-1` / `wave-2` / `wave-3`) — prior commands proposes + peer-map decision
- Open DRAFT PRs #78 / #84 / #93 / #96 / #97 — owned path lists (skip)
- AS-IS: `.cursor/commands/opsx-explore.md` ↔ `.claude/commands/opsx/explore.md`
- Graphify / GitNexus — SKIP / docs-only (markdown commands; no code symbols)
- GitHub Issues — no open issue matching this slice (**Issue:** —)

## Decisions

### D1: Scope = opsx-explore pair only (2 files)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `doc/design/001` alone (~592) | Rejected — exceeds ≤350–400 LOC; needs future split |
| C — Course `aula-04` alone (~126) | Valid alternate; deferred — finish WRu commands track first |
| D — Spec residual (`sdd-post-install-verification`) | Valid alternate; deferred — commands track unfinished |
| E — Kit `sdd-kit/templates/doc/design/003` alone | Valid alternate; deferred — checksum-aware; prefer after hub design apply |
| F — `opsx-explore` × 2 as `translate-commands-wave-4` | **Chosen** — last residual opsx command pair; ~189 LOC; disjoint; no script touch |

**Rationale:** Completes the four-verb commands track unlocked by wave-1; single verb keeps review small and parallel-safe with open propose PRs #93–#97.

### D2: Soft prerequisite on commands-wave-1 apply (G-MIRROR)

**Chosen:** Propose may land in parallel with PRs #93 / #96 / #97. **Apply** of this wave SHOULD wait until wave-1’s peer-map fix is on the apply base so G-MIRROR resolves asymmetric opsx paths without inventing wrong peers.

**Rationale:** `CURSOR-AUTOMATIONS.md` §2 — dependent apply after peer infrastructure; propose remains disjoint.

### D3: In-place substitution — no dual-file; both IDE sides required

**Chosen:** Edit both command paths in the same apply. Forbidden: `*.en.md` / `*-pt.md` siblings; updating only Cursor or only Claude.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES commands-mirrors pairing intent.

### D4: F7 chat language vs command language

**Chosen:** Translate residual Portuguese Session Handoff stubs (`Esta fase terminou…`, `Sugestão: abrir novo chat…`, `Cole no primeiro…`, `Ler:`, `notas de exploração`, `assumir ✅ — não reinstalar`) to English. Keep F7-aligned: chat MAY use pt-BR; versioned command MUST be English.

**Rationale:** Versioned artifacts MUST be English; leaving PT handoff stubs fails G-PT and fights F7.

### D5: Freeze explore semantics and `/opsx:*`

**Chosen:** Keep explore Steps/Output, research.md conventions, Session Handoff target `/opsx:propose`, and `/opsx:explore` slash forms unchanged. Translate surrounding prose only. Preserve platform-specific YAML frontmatter structure per IDE.

**Rationale:** G-INV + behavioral stability for explore sessions.

### D6: Spec delta = lasting opsx-explore EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that the `opsx-explore` command pair MUST be English on both IDE paths. Do not invent a new capability. Do not restate the wave-1 G-MIRROR peer-map requirement (already owned there). Do not conflate with the `openspec-explore` **skill** requirement from skills-wave-4.

**Rationale:** Same ADDED-requirement pattern as commands-wave-1/2/3 / skills waves; scopes this slice only.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Agent updates only one IDE side | Tasks gate both Cursor and Claude paths |
| Apply before wave-1 peer map lands | Soft prerequisite in proposal/design/Session Handoff; G-MIRROR will fail closed until then |
| Semantic drift on explore Steps/research.md | Tasks forbid changing explore workflow semantics; language only |
| Confusion with skills-wave-4 (`openspec-explore` skill) | Non-goals + Impact explicitly exclude skill paths; this wave owns **commands** only |
| G-PT false positives | Prefer glossary EN; re-run deny-list locally before done |
| Parallel conflict with other command proposes | Own only these two paths; document non-goals for other verbs |

## Migration Plan

1. Apply (after wave-1 peer map preferred): rewrite residual PT → EN in both `opsx-explore` command files; keep IDE frontmatter; freeze `/opsx:*` / explore semantics.
2. Gate: `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-explore.md,.claude/commands/opsx/explore.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-commands-wave-4 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- .cursor/commands/opsx-explore.md .claude/commands/opsx/explore.md`.

## Open Questions

- None blocking propose. Follow-up residual candidates after this (commands track complete): course WCu (e.g. `aula-04` ~126 LOC), `doc/design/001` split + G-PT strategy, kit `sdd-kit/templates/doc/design/` mirrors (checksum-aware; prefer after hub design apply), residual `openspec/specs/*` PT, guide G-PT strategy.
