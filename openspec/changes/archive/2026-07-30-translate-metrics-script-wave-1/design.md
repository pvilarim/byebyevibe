# Design — translate-metrics-script-wave-1 (add-sdd-metrics-script artifacts PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active `translate-*` on current base own kit rules, hub infra, skills 1–6, avaliacoes-wave-1, design-wave-1/2 — none own `openspec/changes/add-sdd-metrics-script/{proposal,design,tasks}.md`.
- Open translate propose PRs (#84, #93–#111) own commands, curso aulas 01–04 + scripts AGENTS, specs-wave-1/2, kit-design-wave-1/2, avaliacoes-wave-2, explore-oss / explore-public-release research, active-changes-wave-1 (correctness package), and metrics-cadence-wave-1 — still disjoint from these three paths.
- Canonical guide and over-budget surfaces (`aula-05` ~503 LOC, hub/kit `doc/design/001` ~592 LOC, `explore-adversarial` research ~459 LOC, `add-probity-tdd-module` ~462, `add-supply-chain-gates` ~421, discovery research alone ~404) remain deferred for G-PT-safe split strategies.
- Chosen WAr/active-changes slice: completed-change package `add-sdd-metrics-script` proposal + design + tasks (~340 LOC / 3 files / ~35 deny-list hits) — within ≤4 files / ≤350–400 LOC; whole-file G-PT achievable. Sibling specs under the change are already English.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the three listed artifacts with glossary-canonical English **in-place**.
- Preserve historical apply meaning (mode C on-demand script, M1–M4 proxies from git+archive, kit MANIFEST bump 1.5.0→1.6.0, 6-point registry R1–R6 with R3 N/A, pilot exception, DevLake remains deferred, rollback) — language only.
- Map SDD vocabulary to glossary EN (`change`, `propose` / `proposal`, `apply`, `archive`, Session Handoff, gate, wave, inventory).
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-metrics-script/proposal.md,openspec/changes/add-sdd-metrics-script/design.md,openspec/changes/add-sdd-metrics-script/tasks.md`.

**Non-Goals:**

- Sibling specs under `openspec/changes/add-sdd-metrics-script/specs/` (already EN / 0 deny hits).
- Other completed-change PT artifacts (`add-probity-tdd-module`, `add-supply-chain-gates`, `add-sdd-discovery-positioning`, `add-correctness-review-skill` owned by #110, `add-sdd-metrics-cadence-nudge` owned by #111).
- Explore research files (owned by open PRs #108/#109; adversarial over budget).
- `openspec/changes/archive/` (immutable).
- Canonical guide, curso `aula-05`, design `001`, kit templates, skills/commands mirrors.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Re-opening metrics-script product decisions or unchecking historical `[x]` tasks — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WAr/active-changes; ≤4 files / ≤350–400 LOC; archive OUT; active PT changes IN
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open PR #111 — prior factory propose pattern for metrics-cadence completed-change artifact trio
- AS-IS: `openspec/changes/add-sdd-metrics-script/{proposal,design,tasks}.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown change artifacts; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = metrics-script completed-change prose trio (WAr entry)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `aula-05` / design `001` / `explore-adversarial` / discovery research whole file | Rejected — over ≤350–400 LOC |
| C — Bundle with metrics-cadence package | Rejected — already owned by open PR #111 |
| D — Bundle metrics-script + probity + supply-chain | Rejected — exceeds file/LOC budgets |
| E — `add-sdd-metrics-script` proposal + design + tasks | **Chosen** — 3 files / ~340 LOC; residual PT; disjoint; whole-file G-PT |

**Rationale:** Next densest in-budget completed-change PT package after metrics-cadence (#111); sits just under the LOC ceiling as a single completable whole-file wave.

### D2: In-place substitution — no dual-file; archive untouched

**Chosen:** Edit the three artifact paths in place. Forbidden: `*.en.md` / `*-pt.md` siblings; rewriting `openspec/changes/archive/`.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES archive-out.

### D3: Historical outcomes stable under EN prose

**Chosen:** Translate proposal/design/tasks prose and headings to English. Do not change M1–M4 proxy definitions, CLI flags (`--since`, `--output`, `--help`), mode C (not CI), kit bump 1.5.0→1.6.0, 6-point registry contents, pilot-exception approval, DevLake deferred status, rollback steps, or historical task completion markers (`[x]`). Keep Gate/Pattern/Forbidden structural fields intact while translating surrounding Portuguese description lines.

**Rationale:** Agents and humans must still read an accurate historical record of what was approved and applied; language migration must not look like a re-decision or a re-open of checked tasks.

### D4: Glossary — no new terms expected

**Chosen:** Reuse existing glossary rows (`change`, `propose`/`proposal`, `apply`, `archive`, Session Handoff, gate, wave, inventory). Expand `GLOSSARY.md` only if apply discovers a true gap.

**Rationale:** Keeps the wave inside language-only scope; avoids drive-by glossary churn.

### D5: Parallel propose OK

**Chosen:** Open this propose PR without waiting for #111 (or any other translate propose) to merge.

**Rationale:** `CURSOR-AUTOMATIONS.md` §2 — disjoint file slices are not blocked by unmerged propose PRs.

### D6: Sibling specs out of scope

**Chosen:** Do not include `openspec/changes/add-sdd-metrics-script/specs/**` in this wave.

**Rationale:** Those delta specs already show 0 G-PT deny-list hits; including them would burn budget without residual PT work and risk overlapping promoted specs already covered by other tracks.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT false positive on quoted PT / path segments | Document allowlist exceptions in apply notes if needed; do not invent dual-file escapes |
| Rewriting `--since` / MANIFEST keys / change-ids | Freeze-list + G-INV; keep fenced commands byte-stable |
| Semantic drift of M1–M4 proxies or “DevLake deferred” | Explicit D3; G-SMOKE checklist |
| Accidental edit of metrics-cadence artifacts or live `scripts/sdd-metrics.sh` | Non-goals + tasks Forbidden lines |

## Migration Plan

1. Merge this propose (artifacts only under `openspec/changes/translate-metrics-script-wave-1/`).
2. Separate `/opsx:apply` session substitutes the three target files in place and runs the wave gate.
3. Separate `/opsx:archive` after apply merge.
4. Rollback: revert the three artifact files (and optional glossary rows) — no runtime behavior change from this language-only wave.

## Open Questions

| Question | Proposed resolution |
|----------|---------------------|
| Include sibling specs under the change? | **No** — already English; leave out of `--files` |
| Bundle with `add-probity-tdd-module` or supply-chain? | **No** — those packages exceed budget alone or when combined |
| Touch live `scripts/sdd-metrics.sh` / guide §2.17 / kit template? | **No** — those are product surfaces already applied; this wave is historical change artifacts only |
