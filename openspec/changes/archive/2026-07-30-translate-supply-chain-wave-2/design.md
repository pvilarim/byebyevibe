# Design — translate-supply-chain-wave-2 (add-supply-chain-gates design.md PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active `translate-*` on current base own kit rules, hub infra, skills 1–6, avaliacoes-wave-1, design-wave-1/2 — none own `openspec/changes/add-supply-chain-gates/design.md`.
- Open translate propose PRs (#84, #93–#114) own commands, curso aulas 01–04 + scripts AGENTS, specs-wave-1/2, kit-design-wave-1/2, avaliacoes-wave-2, explore research, active-changes / metrics / discovery artifact trios, and supply-chain **wave-1** (proposal + tasks + sdd-ci-gates delta) — still disjoint from `design.md`.
- Full `add-supply-chain-gates` package exceeded ≤350–400 LOC; wave-1 explicitly deferred this file to wave-2.
- Chosen WAr/active-changes slice: `design.md` alone (~292 LOC / 1 file / ~29 deny-list hits) — within budget; whole-file G-PT achievable.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/changes/add-supply-chain-gates/design.md` with glossary-canonical English **in-place**.
- Preserve historical design meaning (OSV step inside `sdd-gates.yml`, OSV action SHA pin, lockfile presence matrix, mode A for OSV+Renovate, APP/DOCS_SPECS/HYBRID install matrix, conservative Renovate preset fields, SDD classification of Renovate PRs, optional skill SKIP, Renovate pilot, 6-point registry, rollback) — language only.
- Map SDD vocabulary to glossary EN (`change`, `propose` / `proposal`, `apply`, `archive`, Session Handoff, gate, wave, evaluation, inventory).
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-supply-chain-gates/design.md`.

**Non-Goals:**

- Wave-1 paths (`proposal.md`, `tasks.md`, `specs/sdd-ci-gates/spec.md`) — owned by `translate-supply-chain-wave-1` / PR #114.
- Sibling `openspec/changes/add-supply-chain-gates/specs/sdd-supply-chain/spec.md` (already EN / 0 deny hits).
- Other completed-change PT packages (`add-probity-tdd-module` needs its own split; packages owned by #110–#113).
- Explore research files (owned by open PRs #108/#109; `metodologia-insercao.md` residual; adversarial over budget).
- `openspec/changes/archive/` (immutable).
- Canonical guide, curso `aula-05`, design `001`, kit templates, skills/commands mirrors.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Re-opening supply-chain product decisions D1–D9 — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WAr/active-changes; ≤4 files / ≤350–400 LOC; archive OUT; active PT changes IN
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes; explicit split when over budget
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open PR #114 / `translate-supply-chain-wave-1` — sibling split that deferred this file
- AS-IS: `openspec/changes/add-supply-chain-gates/design.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown change artifacts; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = supply-chain design.md only (wave-2 of explicit package split)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — Re-bundle with wave-1 paths | Rejected — those paths are already owned by PR #114; would double-own |
| C — Bundle with `add-probity-tdd-module` | Rejected — exceeds file/LOC budgets; separate package |
| D — Tiny polish only (`WAVE-PROPOSAL-TEMPLATE` / i18n-automations proposal) | Deferred — lower value than completing the supply-chain design half |
| E — Split design.md into mid-file sections | Rejected — whole-file G-PT; file is already within budget alone |
| F — `design.md` alone | **Chosen** — 1 file / ~292 LOC; residual PT; disjoint; whole-file G-PT; completes the wave-1 deferral |

**Rationale:** Explicit follow-through on the wave-1 split; densest in-budget free residual that finishes the supply-chain completed-change package language work (sibling sdd-supply-chain delta already EN).

### D2: In-place substitution — no dual-file; archive untouched

**Chosen:** Edit `openspec/changes/add-supply-chain-gates/design.md` in place. Forbidden: `*.en.md` / `*-pt.md` siblings; rewriting `openspec/changes/archive/`.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES archive-out.

### D3: Historical design decisions stable under EN prose

**Chosen:** Translate design prose and headings to English. Do not change decision outcomes D1–D9, G1 compatibility mapping, OSV SHA pin value, lockfile matrix, Renovate preset field list, profile SKIP rules, pilot-exception rationale, 6-point registry contents, or rollback steps. Keep decision ID labels (`D1`…`D9`) and table structure intact while translating surrounding Portuguese description lines.

**Rationale:** Agents and humans must still read an accurate historical record of what was decided; language migration must not look like a re-decision.

### D4: Glossary — no new terms expected

**Chosen:** Reuse existing glossary rows (`change`, `propose`/`proposal`, `apply`, `archive`, Session Handoff, gate, wave, evaluation, inventory). Expand `GLOSSARY.md` only if apply discovers a true gap.

**Rationale:** Keeps the wave inside language-only scope; avoids drive-by glossary churn.

### D5: Parallel propose OK

**Chosen:** Open this propose PR without waiting for #84 / #93–#114 (including sibling wave-1) to merge.

**Rationale:** `CURSOR-AUTOMATIONS.md` §2 — disjoint file slices are not blocked by unmerged propose PRs. Wave-1 owns different paths; apply sessions remain independent (wave-2 apply does not require wave-1 apply first).

### D6: Wave-1 paths and sdd-supply-chain delta out of scope

**Chosen:** Do not include wave-1 targets or `specs/sdd-supply-chain/spec.md` in this wave.

**Rationale:** Avoid double-ownership with PR #114; `sdd-supply-chain` delta already shows 0 G-PT deny-list hits.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT false positive on quoted PT / path segments / `[AÇÃO MANUAL NECESSÁRIA]` | Document allowlist exceptions in apply notes if needed; keep the manual-action marker if it is an operational token, or translate surrounding prose only |
| Rewriting action SHAs / workflow names / change-ids / decision IDs | Freeze-list + G-INV; keep fenced commands and ID labels byte-stable |
| Semantic drift of OSV fail-closed / Renovate SKIP / pilot exception | Explicit D3; G-SMOKE checklist |
| Accidental edit of wave-1 paths or live workflows / kit templates | Non-goals + tasks Forbidden lines |
| Double-own with PR #114 | Owned-set check: only `design.md`; wave-1 non-goals already named this wave |

## Migration Plan

1. Merge this propose (artifacts only under `openspec/changes/translate-supply-chain-wave-2/`).
2. Separate `/opsx:apply` session substitutes `design.md` in place and runs the wave gate (independent of wave-1 apply timing — different paths).
3. Separate `/opsx:archive` after apply merge.
4. Next factory candidates after this propose: `translate-probity-wave-1` (explicit split of `add-probity-tdd-module`), tiny polish (`WAVE-PROPOSAL-TEMPLATE` / i18n-automations proposal), or over-budget splits (`explore-adversarial`, discovery `research.md`, `aula-05`, design `001`).
5. Rollback: revert `design.md` (and optional glossary rows) — no runtime behavior change from this language-only wave.

## Open Questions

| Question | Proposed resolution |
|----------|---------------------|
| Wait for wave-1 propose merge before proposing wave-2? | **No** — paths are disjoint; parallel propose OK |
| Require wave-1 apply before wave-2 apply? | **No** — different files; either order is fine |
| Include sibling `specs/sdd-supply-chain/spec.md`? | **No** — already English; leave out of `--files` |
| Bundle with `add-probity-tdd-module`? | **No** — that package needs its own split |
| Touch live `.github/workflows/sdd-gates.yml` / kit templates? | **No** — those are product surfaces already applied; this wave is the historical design artifact only |
