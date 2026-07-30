# Design — translate-discovery-research-wave-1 (discovery research.md §1–§10 PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-discovery-wave-1` (merged PR #113) owns `add-sdd-discovery-positioning` `proposal.md` + `design.md` + `tasks.md` and deferred `research.md` as over whole-file budget (~404 LOC).
- Canonical guide is fully proposed (`translate-guide-wave-1`..`14` on base — apply chain pending). Kit/hub install-critical scripts and design templates are covered by kit-scripts waves 1–6 and kit-design waves 1–4.
- Chosen slice: `openspec/changes/add-sdd-discovery-positioning/research.md` lines **1–261** (§1–§10, ~261 LOC) — mid-file slice within ≤350–400 LOC; disjoint from discovery-wave-1 trio ownership.
- Sibling deferred: lines **262–404** (§11–§12 roadmap + G4 README hook) → `translate-discovery-research-wave-2` (follow-up propose).
- Over-budget explore sibling: `explore-adversarial-sdd-review/research.md` (~459 LOC) remains on a separate split track.

## Goals / Non-Goals

**Goals:**

- Substitute Portuguese prose in research.md lines 1–261 with glossary-canonical English **in-place**.
- Preserve §9 pre-apply decision defaults (P6–P8 / BMAD / Landing / Discord non-goals; full EN translation deferred until stable name).
- Map operator vocabulary to glossary EN (`evaluation`, discovery, wave, glossary, canonical guide, install kit, fail-closed).
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md`.

**Non-Goals:**

- Lines 262–404 (§11–§12 — follow-up wave).
- `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (owned by avaliacoes-wave-2).
- Discovery artifact trio (owned by discovery-wave-1).
- `openspec/changes/archive/` (immutable).
- Canonical guide, curso, kit templates, skills/commands.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Re-opening discovery positioning decisions — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WAr/active-changes; mid-file slices; ≤350–400 LOC; archive OUT
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-discovery-wave-1/` — prior factory propose; explicit research.md deferral
- `openspec/changes/translate-guide-wave-1/proposal.md` — mid-file slice pattern on single file
- AS-IS: `openspec/changes/add-sdd-discovery-positioning/research.md` lines 1–261
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown research; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = discovery research mid-file slice lines 1–261

| Option | Verdict |
|--------|---------|
| A — Canonical guide mid-file slice | Rejected — all 14 guide slices already proposed on base |
| B — Whole `research.md` (~404 LOC) | Rejected — exceeds ≤350–400 LOC whole-file budget |
| C — Bundle with discovery artifact trio | Rejected — trio already owned by discovery-wave-1 |
| D — `research.md` lines 1–261 (§1–§10) | **Chosen** — ~261 LOC; natural section boundary before §11 roadmap |

**Rationale:** Completes the deferred discovery research track in budget-safe slices; §11–§12 references stable EN anchors from §9 without re-deciding product outcomes.

### D2: In-place substitution — no dual-file; archive untouched

**Chosen:** Edit the research path in place for the listed line range only. Forbidden: `*.en.md` / `*-pt.md` siblings; rewriting `openspec/changes/archive/`.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES archive-out rule.

### D3: §9 decision defaults stable under EN labels

**Chosen:** Translate §9 table and surrounding prose to English. Do not change which items are non-goals vs deferred vs ready-for-apply. Keep cross-refs to §11 step ④ as structural references (wording may become EN while preserving step identity).

**Rationale:** Apply agents must still honor pre-apply defaults; language migration must not look like a re-decision.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that research.md lines 1–261 MUST be English after substitution. Do not invent a new capability.

**Rationale:** Same pattern as guide-wave and explore-public-release ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT fails on §11–§12 PT outside slice | Document wave-2 follow-up; sequential apply per slice |
| Accidental edit outside lines 1–261 | Tasks gate with line-boundary checklist + grep spot-checks |
| Outcome drift in §9 defaults | Tasks forbid changing non-goals / deferrals; language only |
| G-PT false positives on quoted PT / proper nouns | Allowlist brands; quotes only when clearly historical |
| Broken links after heading renames | G-LINK on whole file; careful §-anchor preservation |
| Apply before discovery-wave-1 trio EN | Soft prerequisite noted in proposal + Session Handoff |

## Migration Plan

1. Apply: rewrite lines 1–261 EN in-place; freeze paths/change-ids/URLs; map §1–§10 headings and prose.
2. Gate: `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-discovery-research-wave-1 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- openspec/changes/add-sdd-discovery-positioning/research.md`.

## Open Questions

- None blocking propose. Follow-up: `translate-discovery-research-wave-2` for lines 262–404 (§11–§12); `translate-adversarial-research-wave-*` split for explore-adversarial research (~459 LOC).
