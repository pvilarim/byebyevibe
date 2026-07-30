# Design — translate-specs-wave-1 (residual-PT capability specs PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base includes kit W2c/W2d, hub `openspec/infra.md`, skills waves 1–6, avaliacoes-wave-1, design-waves 1–2, agents-rules 1/1b/1c. None own residual-PT rows inside `openspec/specs/sdd-ci-gates|sdd-post-install-verification|sdd-session-coordination`.
- Open translate PRs (owned paths): #78 kit apply; #84 avaliacoes-wave-2; #93–#98 commands-wave-1..4; #99–#102 curso aulas 04–01; #103 curso scripts AGENTS. None list these three capability-spec paths as primary ownership.
- Canonical guide (`doc/sistema-sdd-pedro.md`) remains deferred for mid-file G-PT; aula-05 (~503) exceeds ≤350–400 LOC; kit `templates/doc/design/` prefers post hub-design apply+archive.
- Chosen specs slice (~357 LOC, 3 files): residual deny-list hits + surrounding PT requirement/scenario prose on CI gates, post-install verification, and session coordination.
- Deferred: `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) → `translate-specs-wave-2`.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the three listed capability specs with glossary-canonical English **in-place** (whole-file G-PT).
- Preserve normative meaning: CI fail-closed vs report-only `sdd-kit verify`; post-install constitution/AGENTS/infra checks; local apply lock per worktree and session registry.
- Keep OpenSpec structure (`## Purpose`, `### Requirement:`, `#### Scenario:`, `MUST`/`WHEN`/`THEN`) and freeze-list identifiers byte-stable.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-ci-gates/spec.md,openspec/specs/sdd-post-install-verification/spec.md,openspec/specs/sdd-session-coordination/spec.md`.

**Non-Goals:**

- `openspec/specs/sdd-install-kit/spec.md` (wave-2).
- Already-English specs without residual PT.
- Rewriting `openspec/changes/archive/`.
- Canonical guide, skills/commands, kit templates, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing CI/post-install/session-coordination semantics — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` in-scope for residual PT only
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- AS-IS: the three capability `spec.md` files listed in the proposal
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown specs; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = three residual-PT specs (defer install-kit)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC |
| C — `sdd-install-kit` alone (~292) | Deferred — leave for wave-2; pack smaller residuals first |
| D — ci-gates + post-install + session-coordination (~357 / 3 files) | **Chosen** — within ≤4 files / ≤350–400 LOC; residual PT; whole-file G-PT; disjoint from owned set |
| E — Kit `sdd-kit/templates/doc/design/003` | Deferred — checksum-aware; prefer after hub design apply+archive |
| F — Explore `research.md` theme wave | Deferred — optional active-changes track; specs residual is higher-leverage for DoD |

**Rationale:** WAVES.md marks `openspec/specs/` as residual-PT only; these three files are the smallest coherent residual cluster that still fits budget without owning install-kit.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at the same paths. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees under `openspec/specs/`.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Freeze normative identifiers; translate prose only

Keep byte-stable: `.github/workflows/sdd-gates.yml`, `sdd-kit/verify.sh`, `scripts/verify-infra.sh`, `scripts/verify-task-patterns.sh`, `scripts/sdd-session-register.sh` / `check` / `status` / `release`, `.sdd/runtime/apply.lock`, `openspec/project.md`, `AGENTS.md`, `CLAUDE.md`, `graphify-out/GRAPH_REPORT.md`, Action pin names, OpenSpec keywords.

Translate: residual PT requirement bodies and scenario WHEN/THEN prose (ci-gates report-only section; post-install Purpose/requirements still in PT; session-coordination Purpose sentence).

**Rationale:** Agents and CI must keep the same executable contracts after language substitution.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that these three capability specs MUST be English after substitution. Do not invent a new `sdd-specs-i18n` capability in this language wave. Do not weaken or rewrite the normative meaning of the three target capabilities beyond language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of fail-closed vs report-only | Tasks require fact parity; freeze workflow step names and `continue-on-error` semantics |
| Accidental edit to `sdd-install-kit` | Explicit non-goal; own only the three listed paths |
| G-PT false positives on path segments / Portuguese filenames historically quoted | Freeze/allowlist paths; no dual-file |
| Parallel propose factory races | Owned-set includes open PR path lists; these specs are absent as primary on #78/#84/#93–#103 |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-1` session after propose merge (or when artifacts are on apply base).
3. Apply substitutes the three capability specs in place; run wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up: `translate-specs-wave-2` for `sdd-install-kit`; aula-05 split; kit design mirrors; guide G-PT strategy.
