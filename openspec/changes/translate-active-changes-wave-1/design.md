# Design — translate-active-changes-wave-1 (add-correctness-review-skill artifacts PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active `translate-*` on current base own kit rules, hub infra, skills 1–6, avaliacoes-wave-1, design-wave-1/2 — none own `openspec/changes/add-correctness-review-skill/{proposal,design,tasks}.md`.
- Open translate propose PRs (#84, #93–#109) own commands, curso aulas 01–04 + scripts AGENTS, specs-wave-1/2, kit-design-wave-1/2, avaliacoes-wave-2, and explore-oss / explore-public-release research — still disjoint from these three paths.
- Canonical guide and over-budget surfaces (`aula-05` ~503 LOC, hub/kit `doc/design/001` ~592 LOC, `explore-adversarial` research ~459 LOC) remain deferred for G-PT-safe split strategies.
- Chosen WAr/active-changes slice: completed-change package `add-correctness-review-skill` proposal + design + tasks (~305 LOC / 3 files / ~59 deny-list hits) — within ≤4 files / ≤350–400 LOC; whole-file G-PT achievable. Sibling delta specs under that change are already English (0 deny hits) and are explicit non-goals.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the three listed artifacts with glossary-canonical English **in-place**.
- Preserve historical apply meaning (skill paths, A–E invocation matrix, pilot-exception rationale, rollback plan, six contract registration points) — language only.
- Map SDD vocabulary to glossary EN (`skill`, `evaluation`, Session Handoff, gate, change, wave).
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-correctness-review-skill/proposal.md,openspec/changes/add-correctness-review-skill/design.md,openspec/changes/add-correctness-review-skill/tasks.md`.

**Non-Goals:**

- Delta specs under `openspec/changes/add-correctness-review-skill/specs/` (already EN).
- Other completed-change PT artifacts (`add-probity-tdd-module`, `add-sdd-metrics-*`, `add-supply-chain-gates`, `add-sdd-discovery-positioning`).
- Explore research files (owned by open PRs #108/#109; adversarial over budget).
- `openspec/changes/archive/` (immutable).
- Canonical guide, curso `aula-05`, design `001`, kit templates, skills/commands mirrors.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Re-opening correctness-review product decisions or unchecking historical `[x]` tasks — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WAr/active-changes; ≤4 files / ≤350–400 LOC; archive OUT; active PT changes IN
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open PRs #108/#109 — prior factory propose pattern for active `openspec/changes/*` surfaces
- AS-IS: `openspec/changes/add-correctness-review-skill/{proposal,design,tasks}.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown change artifacts; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = correctness-review completed-change prose trio (WAr entry)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `aula-05` / design `001` / `explore-adversarial` whole file | Rejected — over ≤350–400 LOC |
| C — Bundle with explore-public-release / explore-oss research | Rejected — already owned by open PRs #108/#109 |
| D — Bundle multiple completed-change packages (probity + metrics + supply-chain) | Rejected — exceeds file/LOC budgets |
| E — `add-correctness-review-skill` proposal + design + tasks | **Chosen** — 3 files / ~305 LOC; high residual PT; disjoint; whole-file G-PT; specs already EN |

**Rationale:** Starts the completed-change / active-changes theme with the densest in-budget PT package that is not already owned.

### D2: In-place substitution — no dual-file; archive untouched; specs untouched

**Chosen:** Edit the three artifact paths in place. Forbidden: `*.en.md` / `*-pt.md` siblings; rewriting `openspec/changes/archive/`; rewriting already-EN delta specs under the same change.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES archive-out + residual-PT-only rule for specs.

### D3: Historical outcomes stable under EN prose

**Chosen:** Translate proposal/design/tasks prose and headings to English. Do not change A–E matrix cells, pilot-exception approval, rollback steps, skill paths, or historical task completion markers (`[x]`). Keep Gate/Pattern/Forbidden structural fields intact while translating surrounding Portuguese description lines.

**Rationale:** Agents and humans must still read an accurate historical record of what was approved and applied; language migration must not look like a re-decision or a re-open of tasks.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that these three artifact files MUST be English after substitution. Do not invent a new capability for active-change language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including explore-public-release-wave-1).

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Outcome drift (A–E matrix / pilot exception) | Tasks forbid changing matrix cells and exception rationale; only language |
| Accidental uncheck of historical `[x]` | Explicit Forbidden: do not flip completion markers |
| G-PT false positives on quoted PT / proper nouns | Quotes only when clearly historical; allowlist brands |
| Parallel conflict with other active-changes proposes | Own only these three paths; document deferred siblings |
| Portuguese orthography variants (`actualização`/`atualização`, `ficheiro`, `secção`) | G-PT deny-list + explicit Forbidden PT phrases in task gates |

## Migration Plan

1. Apply: rewrite the three artifacts EN in-place; freeze paths/change-ids/skill names/pins/URLs; keep historical outcomes and `[x]` markers.
2. Gate: `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-correctness-review-skill/proposal.md,openspec/changes/add-correctness-review-skill/design.md,openspec/changes/add-correctness-review-skill/tasks.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-active-changes-wave-1 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- openspec/changes/add-correctness-review-skill/proposal.md openspec/changes/add-correctness-review-skill/design.md openspec/changes/add-correctness-review-skill/tasks.md`.

## Open Questions

- None blocking propose. Follow-up candidates: other completed-change PT packages within budget (`add-sdd-metrics-cadence-nudge` ~242 LOC; `add-sdd-metrics-script` ~340 LOC); over-budget packages after split (`add-probity-tdd-module`, `add-supply-chain-gates`, discovery research); over-budget `explore-adversarial` / `aula-05` / design `001` after G-PT-safe split strategy; WAVE-PROPOSAL-TEMPLATE Session Handoff stub residual polish.
