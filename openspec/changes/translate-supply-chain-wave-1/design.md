# Design — translate-supply-chain-wave-1 (add-supply-chain-gates proposal/tasks/ci-gates delta PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active `translate-*` on current base own kit rules, hub infra, skills 1–6, avaliacoes-wave-1, design-wave-1/2 — none own `openspec/changes/add-supply-chain-gates/{proposal,tasks}.md` or `specs/sdd-ci-gates/spec.md`.
- Open translate propose PRs (#84, #93–#113) own commands, curso aulas 01–04 + scripts AGENTS, specs-wave-1/2, kit-design-wave-1/2, avaliacoes-wave-2, explore research, active-changes / metrics / discovery artifact trios — still disjoint from these three paths.
- Full `add-supply-chain-gates` package (~496 LOC with `design.md`) exceeds ≤350–400 LOC; explicit split is required.
- Chosen WAr/active-changes slice: proposal + tasks + sdd-ci-gates delta (~200 LOC / 3 files / ~17 deny-list hits) — within budget; whole-file G-PT achievable. Sibling `specs/sdd-supply-chain/spec.md` is already English. `design.md` deferred to wave-2.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the three listed artifacts with glossary-canonical English **in-place**.
- Preserve historical apply meaning (Renovate + OSV templates in sdd-kit, profile SKIP for DOCS_SPECS Renovate, OSV fail-closed when lockfile present / SKIP without lockfile, 6-point registry, G8 → Adopted, OSV pilot exception as CI-only step, Renovate GitHub app manual activation) — language only.
- Map SDD vocabulary to glossary EN (`change`, `propose` / `proposal`, `apply`, `archive`, Session Handoff, gate, wave, evaluation, inventory).
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-supply-chain-gates/proposal.md,openspec/changes/add-supply-chain-gates/tasks.md,openspec/changes/add-supply-chain-gates/specs/sdd-ci-gates/spec.md`.

**Non-Goals:**

- `openspec/changes/add-supply-chain-gates/design.md` (→ `translate-supply-chain-wave-2`).
- Sibling `openspec/changes/add-supply-chain-gates/specs/sdd-supply-chain/spec.md` (already EN / 0 deny hits).
- Other completed-change PT packages (`add-probity-tdd-module` needs its own split; discovery `research.md` over budget alone; packages owned by #110–#113).
- Explore research files (owned by open PRs #108/#109; adversarial over budget).
- `openspec/changes/archive/` (immutable).
- Canonical guide, curso `aula-05`, design `001`, kit templates, skills/commands mirrors.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Re-opening supply-chain product decisions or unchecking historical `[x]` tasks — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WAr/active-changes; ≤4 files / ≤350–400 LOC; archive OUT; active PT changes IN
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes; explicit split when over budget
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open PRs #111–#113 — prior factory propose patterns for completed-change artifact slices
- AS-IS: `openspec/changes/add-supply-chain-gates/{proposal,tasks}.md` + `specs/sdd-ci-gates/spec.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown change artifacts; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = supply-chain proposal + tasks + ci-gates delta (explicit package split)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — Full supply-chain package including `design.md` | Rejected — ~496 LOC over ≤350–400 |
| C — `design.md` alone as wave-1 | Viable but leaves proposal/tasks/spec residual; prefer consumer-facing artifacts first |
| D — Bundle with `add-probity-tdd-module` | Rejected — exceeds file/LOC budgets |
| E — Tiny polish only (`WAVE-PROPOSAL-TEMPLATE` / i18n-automations proposal) | Deferred — lower value than a substantive WAr split |
| F — proposal + tasks + `specs/sdd-ci-gates/spec.md` | **Chosen** — 3 files / ~200 LOC; residual PT; disjoint; whole-file G-PT; design → wave-2 |

**Rationale:** Explicit split strategy for an over-budget completed-change package; densest in-budget free residual after discovery/metrics/active-changes factory proposes.

### D2: In-place substitution — no dual-file; archive untouched

**Chosen:** Edit the three artifact paths in place. Forbidden: `*.en.md` / `*-pt.md` siblings; rewriting `openspec/changes/archive/`.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES archive-out.

### D3: Historical outcomes stable under EN prose

**Chosen:** Translate proposal/tasks/delta-spec prose and headings to English. Do not change Renovate profile SKIP rules, OSV fail-closed-when-lockfile behavior, action SHA pins, workflow step names/order, G8 → Adopted outcome, pilot-exception rationale, 6-point registry contents, or historical task completion markers (`[x]`). Keep Gate/Pattern/Forbidden structural fields intact while translating surrounding Portuguese description lines.

**Rationale:** Agents and humans must still read an accurate historical record of what was approved and applied; language migration must not look like a re-decision or a re-open of checked tasks.

### D4: Glossary — no new terms expected

**Chosen:** Reuse existing glossary rows (`change`, `propose`/`proposal`, `apply`, `archive`, Session Handoff, gate, wave, evaluation, inventory). Expand `GLOSSARY.md` only if apply discovers a true gap.

**Rationale:** Keeps the wave inside language-only scope; avoids drive-by glossary churn.

### D5: Parallel propose OK

**Chosen:** Open this propose PR without waiting for #84 / #93–#113 (or any other translate propose) to merge.

**Rationale:** `CURSOR-AUTOMATIONS.md` §2 — disjoint file slices are not blocked by unmerged propose PRs.

### D6: Sibling design + sdd-supply-chain delta out of scope

**Chosen:** Do not include `design.md` or `specs/sdd-supply-chain/spec.md` in this wave.

**Rationale:** `design.md` is the budget overflow half (wave-2); `sdd-supply-chain` delta already shows 0 G-PT deny-list hits.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT false positive on quoted PT / path segments / `[AÇÃO MANUAL NECESSÁRIA]` | Document allowlist exceptions in apply notes if needed; keep the manual-action marker if it is an operational token, or translate surrounding prose only |
| Rewriting action SHAs / workflow names / change-ids | Freeze-list + G-INV; keep fenced commands byte-stable |
| Semantic drift of Renovate SKIP / OSV fail-closed | Explicit D3; G-SMOKE checklist |
| Accidental edit of `design.md` or live workflows / kit templates | Non-goals + tasks Forbidden lines |
| Wave-2 ownership of `design.md` forgotten | Non-goals name `translate-supply-chain-wave-2`; Session Handoff notes deferral |

## Migration Plan

1. Merge this propose (artifacts only under `openspec/changes/translate-supply-chain-wave-1/`).
2. Separate `/opsx:apply` session substitutes the three target files in place and runs the wave gate.
3. Separate `/opsx:archive` after apply merge.
4. Follow-up propose factory run may open `translate-supply-chain-wave-2` for `design.md` once this propose owns the wave-1 paths (or after merge — either way design remains free until proposed).
5. Rollback: revert the three artifact files (and optional glossary rows) — no runtime behavior change from this language-only wave.

## Open Questions

| Question | Proposed resolution |
|----------|---------------------|
| Include `design.md` in this wave? | **No** — over budget together; defer to wave-2 |
| Include sibling `specs/sdd-supply-chain/spec.md`? | **No** — already English; leave out of `--files` |
| Bundle with `add-probity-tdd-module`? | **No** — that package also needs its own split |
| Touch live `.github/workflows/sdd-gates.yml` / kit templates? | **No** — those are product surfaces already applied; this wave is historical change artifacts only |
