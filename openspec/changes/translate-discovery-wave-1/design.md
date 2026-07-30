# Design — translate-discovery-wave-1 (add-sdd-discovery-positioning artifacts PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active `translate-*` on current base own kit rules, hub infra, skills 1–6, avaliacoes-wave-1, design-wave-1/2 — none own `openspec/changes/add-sdd-discovery-positioning/{proposal,design,tasks}.md`.
- Open translate propose PRs (#84, #93–#112) own commands, curso aulas 01–04 + scripts AGENTS, specs-wave-1/2, kit-design-wave-1/2, avaliacoes-wave-2 (evaluation doc under `doc/avaliacoes/`), explore-oss / explore-public-release research, active-changes-wave-1 (correctness), metrics-cadence-wave-1, and metrics-script-wave-1 — still disjoint from these three paths.
- Canonical guide and over-budget surfaces (`aula-05` ~503 LOC, hub/kit `doc/design/001` ~592 LOC, `explore-adversarial` research ~459 LOC, `add-probity-tdd-module` ~462, `add-supply-chain-gates` ~421, discovery `research.md` alone ~404) remain deferred for G-PT-safe split strategies.
- Chosen WAr/active-changes slice: completed-change package `add-sdd-discovery-positioning` proposal + design + tasks (~246 LOC / 3 files / ~55 deny-list hits) — within ≤4 files / ≤350–400 LOC; whole-file G-PT achievable. Sibling research stays out of scope.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the three listed artifacts with glossary-canonical English **in-place**.
- Preserve historical apply meaning (EN root README / vibe→agentic positioning, evaluation promotion, kit README framing, guide first-contact quickstart, D9 permanent non-goals, D10 README→name→EN→GIF roadmap, D11 metrics blurb without ML claims, manual About/topics checklist, historical `[x]` tasks) — language only.
- Map SDD vocabulary to glossary EN (`change`, `propose` / `proposal`, `apply`, `archive`, Session Handoff, gate, wave, inventory, evaluation).
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/proposal.md,openspec/changes/add-sdd-discovery-positioning/design.md,openspec/changes/add-sdd-discovery-positioning/tasks.md`.

**Non-Goals:**

- Sibling `openspec/changes/add-sdd-discovery-positioning/research.md` (over ≤350–400 LOC alone — later split).
- `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (owned by avaliacoes-wave-2 / open PR #84).
- Other completed-change PT artifacts (`add-probity-tdd-module`, `add-supply-chain-gates`; correctness/metrics packages owned by #110–#112).
- Explore research files (owned by open PRs #108/#109; adversarial over budget).
- `openspec/changes/archive/` (immutable).
- Canonical guide, curso `aula-05`, design `001`, kit templates, skills/commands mirrors.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Re-opening discovery product decisions or unchecking historical `[x]` tasks — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WAr/active-changes; ≤4 files / ≤350–400 LOC; archive OUT; active PT changes IN
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open PR #112 — prior factory propose pattern for metrics-script completed-change artifact trio
- AS-IS: `openspec/changes/add-sdd-discovery-positioning/{proposal,design,tasks}.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown change artifacts; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = discovery completed-change prose trio (WAr entry)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `aula-05` / design `001` / `explore-adversarial` / discovery research whole file | Rejected — over ≤350–400 LOC |
| C — Bundle with metrics-script / metrics-cadence / correctness packages | Rejected — already owned by open PRs #110–#112 |
| D — Bundle discovery proposal+design+tasks with research.md | Rejected — research alone ~404 LOC; combined exceeds budget |
| E — Bundle discovery trio with `doc/avaliacoes/2026-07-26-…` | Rejected — evaluation path owned by avaliacoes-wave-2 (#84) |
| F — `add-sdd-discovery-positioning` proposal + design + tasks | **Chosen** — 3 files / ~246 LOC; residual PT; disjoint; whole-file G-PT |

**Rationale:** Next densest in-budget completed-change PT package after metrics-script (#112); comfortably under the LOC ceiling as a single completable whole-file wave while leaving over-budget research for a later split.

### D2: In-place substitution — no dual-file; archive untouched

**Chosen:** Edit the three artifact paths in place. Forbidden: `*.en.md` / `*-pt.md` siblings; rewriting `openspec/changes/archive/`.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES archive-out.

### D3: Historical outcomes stable under EN prose

**Chosen:** Translate proposal/design/tasks prose and headings to English. Do not change D9 permanent non-goals (Landing/Discord/one-liner/scaffold/BMAD/brand), D10 README→name→EN→GIF sequence, D11 metrics framing (calibrate-as-you-go / no ML claims), evaluation promotion path, root README / kit README / guide quickstart intents, or historical task completion markers (`[x]`). Keep Gate/Pattern/Forbidden structural fields intact while translating surrounding Portuguese description lines. Manual-action cue `[AÇÃO MANUAL NECESSÁRIA]` → `[MANUAL ACTION REQUIRED]` (or glossary-aligned EN operator cue already used elsewhere) only as language normalization — keep meaning.

**Rationale:** Agents and humans must still read an accurate historical record of what was approved and applied; language migration must not look like a re-decision or a re-open of checked tasks.

### D4: Glossary — no new terms expected

**Chosen:** Reuse existing glossary rows (`change`, `propose`/`proposal`, `apply`, `archive`, Session Handoff, gate, wave, inventory, evaluation). Expand `GLOSSARY.md` only if apply discovers a true gap.

**Rationale:** Keeps the wave inside language-only scope; avoids drive-by glossary churn.

### D5: Parallel propose OK

**Chosen:** Open this propose PR without waiting for #112 (or any other translate propose) to merge.

**Rationale:** `CURSOR-AUTOMATIONS.md` §2 — disjoint file slices are not blocked by unmerged propose PRs.

### D6: Sibling research and evaluation doc out of scope

**Chosen:** Do not include `research.md` or `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` in this wave.

**Rationale:** Research exceeds LOC budget alone; the promoted evaluation is already owned by avaliacoes-wave-2 (#84). Including either would violate budgets or double-own paths.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT false positive on quoted PT / path segments / brand names | Document allowlist exceptions in apply notes if needed; do not invent dual-file escapes |
| Rewriting change-ids / `/opsx:*` / research § anchors | Freeze-list + G-INV; keep fenced commands byte-stable |
| Semantic drift of D9/D10/D11 product decisions | Explicit D3; G-SMOKE checklist |
| Accidental edit of research.md or avaliacoes evaluation path | Non-goals + tasks Forbidden lines |
| Confusion with avaliacoes-wave-2 “discovery” naming | Impact/non-goals call out PR #84 owns evaluation doc only |

## Migration Plan

1. Merge this propose (artifacts only under `openspec/changes/translate-discovery-wave-1/`).
2. Separate `/opsx:apply` session substitutes the three target files in place and runs the wave gate.
3. Separate `/opsx:archive` after apply merge.
4. Rollback: revert the three artifact files (and optional glossary rows) — no runtime behavior change from this language-only wave.

## Open Questions

| Question | Proposed resolution |
|----------|---------------------|
| Include sibling `research.md`? | **No** — over LOC; later dedicated wave/split |
| Include promoted evaluation under `doc/avaliacoes/`? | **No** — owned by avaliacoes-wave-2 (#84) |
| Bundle with `add-probity-tdd-module` or supply-chain? | **No** — those packages exceed budget alone or when combined |
| Touch live `README.md` / kit README / guide quickstart? | **No** — those are product surfaces already applied; this wave is historical change artifacts only |
