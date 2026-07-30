# Design — translate-probity-wave-1 (add-probity-tdd-module proposal/tasks/pilot-note PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active `translate-*` on current base own kit rules, hub infra, skills 1–6, avaliacoes-wave-1, design-wave-1/2 — none own `openspec/changes/add-probity-tdd-module/{proposal,tasks,piloto-nota}.md`.
- Open translate propose PRs (#84, #93–#116) own commands, curso aulas 01–04 + scripts AGENTS, specs-wave-1/2, kit-design-wave-1/2, avaliacoes-wave-2, explore-oss research + metodologia, explore-public-release research, active-changes (correctness), metrics-cadence/script, discovery artifacts (not research), and supply-chain proposal/tasks/design — still disjoint from these three Probity paths.
- Canonical guide and over-budget surfaces (`aula-05` ~503 LOC, hub/kit `doc/design/001` ~592 LOC, `explore-adversarial` research ~459 LOC, discovery `research.md` ~404 LOC) remain deferred for G-PT-safe split strategies.
- Chosen WAr/active-changes slice: completed-change package `add-probity-tdd-module` proposal + tasks + pilot note (~214 LOC / 3 files / ~31 deny-list hits) — within ≤4 files / ≤350–400 LOC; whole-file G-PT achievable. Sibling `design.md` (~292 LOC) is deferred to wave-2; delta specs under that change are already English (0 deny hits).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the three listed artifacts with glossary-canonical English **in-place**.
- Preserve historical apply meaning (pilot **PENDING** / blocked-by-missing-APP-worktree, kit scaffolding delivered, 6-point registry, TDD Guard → Probity migration, `[x]` completion markers) — language only.
- Map SDD vocabulary to glossary EN (`pilot`, `session`, Session Handoff, gate, change, wave, evaluation, install kit).
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-probity-tdd-module/proposal.md,openspec/changes/add-probity-tdd-module/tasks.md,openspec/changes/add-probity-tdd-module/piloto-nota.md`.

**Non-Goals:**

- `openspec/changes/add-probity-tdd-module/design.md` (→ `translate-probity-wave-2`).
- Delta specs under `openspec/changes/add-probity-tdd-module/specs/` (already EN).
- Other completed-change PT artifacts already owned by open PRs (#110–#116 and earlier).
- Explore research files (owned or over budget).
- `openspec/changes/archive/` (immutable).
- Canonical guide, curso `aula-05`, design `001`, kit templates, skills/commands mirrors.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Re-opening Probity product decisions, unchecking historical `[x]` tasks, or advancing the pilot — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WAr/active-changes; ≤4 files / ≤350–400 LOC; archive OUT; active PT changes IN
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open PRs #110–#116 — prior factory propose pattern for active `openspec/changes/*` surfaces
- AS-IS: `openspec/changes/add-probity-tdd-module/{proposal,tasks,piloto-nota,design}.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown change artifacts; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = Probity completed-change prose trio without design.md

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `aula-05` / design `001` / `explore-adversarial` / discovery `research.md` whole file | Rejected — over ≤350–400 LOC |
| C — Tiny polish only (`WAVE-PROPOSAL-TEMPLATE` / i18n-automations proposal, 1 deny hit each) | Deferred — lower residual value than Probity package |
| D — All four Probity artifacts including `design.md` (~506 LOC) | Rejected — exceeds LOC budget |
| E — `proposal.md` + `tasks.md` + `piloto-nota.md` (~214 LOC); `design.md` → wave-2 | **Accepted** — fits budgets; specs already EN; disjoint from owned set |

### D2: Keep filename `piloto-nota.md`

Rename would be a separate path-change (non-goal). Translate file **contents** only; path stays `piloto-nota.md` (freeze-list / link stability).

### D3: Historical `[x]` and pilot PENDING stay semantically stable

Apply MUST NOT reopen product work. Translate labels/prose around completed tasks and the pilot-pending note; do not flip checkboxes or invent a completed pilot.

### D4: No kit checksum / mirror work this wave

Targets are OpenSpec change artifacts only — G-MANIFEST and G-MIRROR N/A.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT false positive on quoted PT workshop titles / path segments | Document allowlist in apply notes; keep quotes clearly quoted |
| Accidental rewrite of `@nizos/probity@1.10.0`, `enforceTdd`, script names | Freeze checklist + G-INV |
| Semantic drift of pilot PENDING / blocked-by-APP-worktree | Preserve status table meanings; English labels only |
| Overlap with future `translate-probity-wave-2` | Explicit non-goal: `design.md` owned by wave-2 only after this propose lands |

## Migration Plan

1. Propose merges (this PR) — artifacts only under `openspec/changes/translate-probity-wave-1/`.
2. Separate `/opsx:apply` run substitutes the three target files in-place.
3. Gate with `verify-i18n-wave.sh --files …` + openspec validate.
4. Archive in a later run after apply merges.
5. Rollback: `git checkout --` the three target paths if apply regresses meaning.

## Open Questions

- None for propose. Wave-2 should pick up `design.md` alone (~292 LOC) after this slice is owned.
