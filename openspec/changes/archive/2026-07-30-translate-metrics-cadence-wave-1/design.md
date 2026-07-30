# Design — translate-metrics-cadence-wave-1 (add-sdd-metrics-cadence-nudge artifacts PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active `translate-*` on current base own kit rules, hub infra, skills 1–6, avaliacoes-wave-1, design-wave-1/2 — none own `openspec/changes/add-sdd-metrics-cadence-nudge/{proposal,design,tasks}.md`.
- Open translate propose PRs (#84, #93–#110) own commands, curso aulas 01–04 + scripts AGENTS, specs-wave-1/2, kit-design-wave-1/2, avaliacoes-wave-2, explore-oss / explore-public-release research, and active-changes-wave-1 (correctness package) — still disjoint from these three paths.
- Canonical guide and over-budget surfaces (`aula-05` ~503 LOC, hub/kit `doc/design/001` ~592 LOC, `explore-adversarial` research ~459 LOC, `add-probity-tdd-module` ~462, `add-supply-chain-gates` ~421, discovery research alone ~404) remain deferred for G-PT-safe split strategies.
- Chosen WAr/active-changes slice: completed-change package `add-sdd-metrics-cadence-nudge` proposal + design + tasks (~242 LOC / 3 files / ~39 deny-list hits) — within ≤4 files / ≤350–400 LOC; whole-file G-PT achievable.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the three listed artifacts with glossary-canonical English **in-place**.
- Preserve historical apply meaning (playbook Interpret→act, cadence nudge on archive Session Handoff, stamp `.sdd/metrics-last-run`, `--check-cadence`, N=5 / T=30, mode C opt-in, pilot exception, rollback) — language only.
- Map SDD vocabulary to glossary EN (`change`, `propose` / `proposal`, `apply`, `archive`, Session Handoff, gate, wave).
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-metrics-cadence-nudge/proposal.md,openspec/changes/add-sdd-metrics-cadence-nudge/design.md,openspec/changes/add-sdd-metrics-cadence-nudge/tasks.md`.

**Non-Goals:**

- Other completed-change PT artifacts (`add-sdd-metrics-script`, `add-probity-tdd-module`, `add-supply-chain-gates`, `add-sdd-discovery-positioning`, `add-correctness-review-skill` owned by #110).
- Explore research files (owned by open PRs #108/#109; adversarial over budget).
- `openspec/changes/archive/` (immutable).
- Canonical guide, curso `aula-05`, design `001`, kit templates, skills/commands mirrors.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Re-opening metrics-cadence product decisions or unchecking historical `[x]` tasks — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WAr/active-changes; ≤4 files / ≤350–400 LOC; archive OUT; active PT changes IN
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open PR #110 — prior factory propose pattern for completed-change artifact trios
- AS-IS: `openspec/changes/add-sdd-metrics-cadence-nudge/{proposal,design,tasks}.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown change artifacts; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = metrics-cadence completed-change prose trio (WAr entry)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `aula-05` / design `001` / `explore-adversarial` / discovery research whole file | Rejected — over ≤350–400 LOC |
| C — Bundle with correctness package | Rejected — already owned by open PR #110 |
| D — Bundle metrics-script + cadence + supply-chain | Rejected — exceeds file/LOC budgets |
| E — `add-sdd-metrics-cadence-nudge` proposal + design + tasks | **Chosen** — 3 files / ~242 LOC; residual PT; disjoint; whole-file G-PT |

**Rationale:** Next densest in-budget completed-change PT package after correctness (#110), preferred over the larger `add-sdd-metrics-script` trio (~340 LOC) for a cleaner single-wave slice.

### D2: In-place substitution — no dual-file; archive untouched

**Chosen:** Edit the three artifact paths in place. Forbidden: `*.en.md` / `*-pt.md` siblings; rewriting `openspec/changes/archive/`.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES archive-out.

### D3: Historical outcomes stable under EN prose

**Chosen:** Translate proposal/design/tasks prose and headings to English. Do not change cadence defaults (N=5, T=30), stamp path, `--check-cadence` semantics (advisory, never auto-run report, never block archive), pilot-exception approval, rollback steps, or historical task completion markers (`[x]`). Keep Gate/Pattern/Forbidden structural fields intact while translating surrounding Portuguese description lines.

**Rationale:** Agents and humans must still read an accurate historical record of what was approved and applied; language migration must not look like a re-decision or a re-open of checked tasks.

### D4: Glossary — no new terms expected

**Chosen:** Reuse existing glossary rows (`change`, `propose`/`proposal`, `apply`, `archive`, Session Handoff, gate, wave, inventory). Expand `GLOSSARY.md` only if apply discovers a true gap.

**Rationale:** Keeps the wave inside language-only scope; avoids drive-by glossary churn.

### D5: Parallel propose OK

**Chosen:** Open this propose PR without waiting for #110 (or any other translate propose) to merge.

**Rationale:** `CURSOR-AUTOMATIONS.md` §2 — disjoint file slices are not blocked by unmerged propose PRs.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT false positive on quoted PT / path segments | Document allowlist exceptions in apply notes if needed; do not invent dual-file escapes |
| Rewriting `--check-cadence` / stamp path / N=T constants | Freeze-list + G-INV; keep fenced commands byte-stable |
| Semantic drift of “advisory never blocks archive” | Explicit D3; G-SMOKE checklist |
| Accidental edit of `add-sdd-metrics-script` or skill mirrors | Non-goals + tasks Forbidden lines |

## Migration Plan

1. Merge this propose (artifacts only under `openspec/changes/translate-metrics-cadence-wave-1/`).
2. Separate `/opsx:apply` session substitutes the three target files in place and runs the wave gate.
3. Separate `/opsx:archive` after apply merge.
4. Rollback: revert the three artifact files (and optional glossary rows) — no runtime behavior change from this language-only wave.

## Open Questions

| Question | Proposed resolution |
|----------|---------------------|
| Include `add-sdd-metrics-script` in the same wave? | **No** — keep cadence package alone (~242 LOC); metrics-script is a follow-up disjoint propose |
| Translate delta specs under the change if present? | Only if residual PT is found at apply time and still within budget; otherwise leave / separate wave |
| Touch live guide §2.17 / scripts / archive skill? | **No** — those are product surfaces already applied; this wave is historical change artifacts only |
