# Design — translate-explore-public-release-wave-1 (explore-public-release research.md PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active `translate-*` on current base own kit rules, hub infra, skills 1–6, avaliacoes-wave-1, design-wave-1/2 — none own `openspec/changes/explore-public-release-surface/research.md`.
- Open translate propose PRs (#84, #93–#108) own commands, curso aulas 01–04 + scripts AGENTS, specs-wave-1/2, kit-design-wave-1/2, avaliacoes-wave-2, and explore-oss research — still disjoint from this path.
- Canonical guide and over-budget surfaces (`aula-05` ~503 LOC, hub/kit `doc/design/001` ~593 LOC, `explore-adversarial` research ~459 LOC) remain deferred for G-PT-safe split strategies.
- Chosen WAr/active-changes slice: single file `openspec/changes/explore-public-release-surface/research.md` (~314 LOC, dense residual Portuguese, ~98 deny-list hits) — within ≤4 files / ≤350–400 LOC; whole-file G-PT achievable.
- Sibling explores: `explore-oss-coverage-gaps/research.md` owned by open PR #108; `explore-adversarial-sdd-review/research.md` deferred (over budget).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/changes/explore-public-release-surface/research.md` with glossary-canonical English **in-place**.
- Preserve decision outcomes F1–F7 (do not implement / ready for propose / Adopted / Deferred / Discarded) — language only.
- Map evaluation-scale and decision vocabulary to glossary EN (`evaluation`, Adopted/Deferred/Discarded, wave, glossary, Session Handoff, fail-closed).
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-public-release-surface/research.md`.

**Non-Goals:**

- Other active change artifacts (sibling explores; completed-change design/proposal/tasks still in PT).
- `openspec/changes/archive/` (immutable).
- Canonical guide, curso `aula-05`, design `001`, kit templates, skills/commands.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Re-opening F1–F7 decisions or inventing a new public-release strategy — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WAr/active-changes; ≤4 files / ≤350–400 LOC; archive OUT
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-explore-oss-wave-1/` (open PR #108) — prior factory propose pattern for explore research
- AS-IS: `openspec/changes/explore-public-release-surface/research.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown research; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = single explore-public-release research file (WAr entry)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `aula-05` / design `001` / `explore-adversarial` whole file | Rejected — over ≤350–400 LOC |
| C — Bundle with explore-oss research | Rejected — explore-oss already owned by open PR #108; bundling would double-own |
| D — Bundle multiple completed-change design.md files | Deferred — finish explore-research siblings first |
| E — `explore-public-release-surface/research.md` alone | **Chosen** — 1 file / ~314 LOC; high residual PT; disjoint; whole-file G-PT |

**Rationale:** Continues the active-changes / explore-research track with the public-release + EN-migration research that seeded F2/F7 and the wave methodology.

### D2: In-place substitution — no dual-file; archive untouched

**Chosen:** Edit the research path in place. Forbidden: `*.en.md` / `*-pt.md` siblings; rewriting `openspec/changes/archive/`.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES archive-out rule.

### D3: Decision outcomes F1–F7 stable under EN labels

**Chosen:** Translate matrix cells and surrounding prose to English. Do not change which items are ready-for-propose vs Deferred vs Discarded vs do-not-implement. Keep change-id links (`add-english-docs-policy`, `add-root-changelog`, …) and freeze-list tables intact as structure.

**Rationale:** Agents must still honor F2/F7 policy outcomes and F6 discard; language migration must not look like a re-decision.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that this research file MUST be English after substitution. Do not invent a new capability for explore research language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including explore-oss-wave-1).

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Outcome drift (Deferred → looks Adopted) | Tasks forbid changing F1–F7 cells; only language |
| G-PT false positives on quoted PT / proper nouns | Quotes only when clearly historical; allowlist brands |
| Broken links after heading renames | Prefer translating headings carefully; G-LINK on touched file |
| Parallel conflict with explore-oss propose | Own only this one path; document #108 ownership of sibling |
| Portuguese orthography variants (`actualizado`/`atualizado`, `ficheiro`, `canónico`) | G-PT deny-list + explicit Forbidden PT phrases in task gates |

## Migration Plan

1. Apply: rewrite `research.md` EN in-place; freeze paths/change-ids/pins/URLs; map decision labels; keep F1–F7 outcomes.
2. Gate: `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-public-release-surface/research.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-explore-public-release-wave-1 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- openspec/changes/explore-public-release-surface/research.md`.

## Open Questions

- None blocking propose. Follow-up candidates: over-budget `explore-adversarial` / `aula-05` / design `001` after split strategy; remaining completed-change design/proposal/tasks PT as a later active-changes theme wave; WAVE-PROPOSAL-TEMPLATE Session Handoff stub residual polish.
