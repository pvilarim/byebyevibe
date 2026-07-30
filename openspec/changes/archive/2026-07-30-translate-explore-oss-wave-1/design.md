# Design — translate-explore-oss-wave-1 (explore-oss research.md PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active `translate-*` on current base own kit rules, hub infra, skills 1–6, avaliacoes-wave-1, design-wave-1/2 — none own `openspec/changes/explore-oss-coverage-gaps/research.md`.
- Open translate propose PRs (#84, #93–#107) own commands, curso aulas 01–04 + scripts AGENTS, specs-wave-1/2, kit-design-wave-1/2, avaliacoes-wave-2 — still disjoint from this path.
- Canonical guide and over-budget surfaces (`aula-05` ~503 LOC, hub/kit `doc/design/001` ~593 LOC, `explore-adversarial` research ~460 LOC) remain deferred for G-PT-safe split strategies.
- Chosen WAr/active-changes slice: single file `openspec/changes/explore-oss-coverage-gaps/research.md` (~245 LOC, dense residual Portuguese) — within ≤4 files / ≤350–400 LOC; whole-file G-PT achievable.
- Sibling explores deferred: `explore-public-release-surface/research.md` (~314 LOC — next candidate), `explore-adversarial-sdd-review/research.md` (over budget).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/changes/explore-oss-coverage-gaps/research.md` with glossary-canonical English **in-place**.
- Preserve gap recommendation outcomes (G1–G8): manual fix / add to kit / do not add / hybrid / do not adopt now — language only.
- Map evaluation-scale and decision vocabulary to glossary EN (`evaluation`, Adopted/add-to-kit phrasing, Deferred, manual fix from `correcção manual`).
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/research.md`.

**Non-Goals:**

- Other active change artifacts (sibling explores; completed-change design/proposal/tasks still in PT).
- `openspec/changes/archive/` (immutable).
- Canonical guide, curso `aula-05`, design `001`, kit templates, skills/commands.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Re-opening gap decisions or changing which tools are adopted — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist (`avaliação` → evaluation; `correcção manual` → manual fix)
- `doc/i18n/WAVES.md` — WAr/active-changes; ≤4 files / ≤350–400 LOC; archive OUT
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-avaliacoes-wave-1/` — prior factory propose pattern for WAv
- AS-IS: `openspec/changes/explore-oss-coverage-gaps/research.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown research; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = single explore-oss research file (WAr entry)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `aula-05` / design `001` whole file | Rejected — over ≤350–400 LOC |
| C — Bundle explore-oss + explore-public-release (~245+314) | Rejected — exceeds LOC budget |
| D — Bundle multiple completed-change design.md files | Deferred — prefer thematic explore-research entry first |
| E — `explore-oss-coverage-gaps/research.md` alone | **Chosen** — 1 file / ~245 LOC; high residual PT; disjoint; whole-file G-PT |

**Rationale:** Starts the active-changes / explore-research track with a complete, reviewable research artifact that already seeded Probity / metrics / supply-chain decisions.

### D2: In-place substitution — no dual-file; archive untouched

**Chosen:** Edit the research path in place. Forbidden: `*.en.md` / `*-pt.md` siblings; rewriting `openspec/changes/archive/`.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES archive-out rule.

### D3: Recommendation outcomes stable under EN labels

**Chosen:** Translate matrix cells and surrounding prose to English. Do not change which gaps are “add to kit” vs “manual fix” vs “do not add/adopt”. Keep change-id links (`add-probity-tdd-module`, …), package pins, and tool URLs intact.

**Rationale:** Agents must still honor Adopt vs Discard/Defer decisions; language migration must not look like a re-decision.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that this research file MUST be English after substitution. Do not invent a new capability for explore research language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Outcome drift (do-not-add → looks Adopt) | Tasks forbid changing recommendation cells; only language |
| G-PT false positives on quoted PT / proper nouns | Quotes only when clearly historical; allowlist brands |
| Broken links after heading renames | Prefer translating headings carefully; G-LINK on touched file |
| Parallel conflict with other active-change proposes | Own only this one path; document deferred siblings |
| Portuguese orthography variants (`adopção`/`adoção`, `projecto`) | G-PT deny-list + explicit Forbidden PT phrases in task gates |

## Migration Plan

1. Apply: rewrite `research.md` EN in-place; freeze paths/change-ids/pins/URLs; map decision labels; keep outcomes.
2. Gate: `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/research.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-explore-oss-wave-1 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- openspec/changes/explore-oss-coverage-gaps/research.md`.

## Open Questions

- None blocking propose. Follow-up candidates: `explore-public-release-surface/research.md` (~314 LOC); over-budget `explore-adversarial` / `aula-05` / design `001` after split strategy; remaining completed-change design/proposal/tasks PT as a later active-changes theme wave.
