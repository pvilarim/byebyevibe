# Design — translate-discovery-research-wave-2 (discovery research.md §11–§12 PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-discovery-research-wave-1` (merged PR #131) owns `add-sdd-discovery-positioning/research.md` lines **1–261** (§1–§10) and deferred lines **262–404** (§11–§12, ~143 LOC).
- Canonical guide is fully proposed (`translate-guide-wave-1`..`14` on base — apply chain pending). Kit/hub install-critical scripts and design templates are covered by kit-scripts waves 1–6 and kit-design waves 1–4.
- Chosen slice: `openspec/changes/add-sdd-discovery-positioning/research.md` lines **262–404** (§11–§12, ~143 LOC) — mid-file slice within ≤350–400 LOC; disjoint from wave-1 line ownership.
- Completes the discovery research file after wave-1 apply; no further slices remain in this path until new content is added.
- Over-budget explore sibling: `explore-adversarial-sdd-review/research.md` (~459 LOC) remains on a separate split track.

## Goals / Non-Goals

**Goals:**

- Substitute Portuguese prose in research.md lines 262–404 with glossary-canonical English **in-place**.
- Preserve §11 canonical dissemination sequence (steps ①–⑥) and rationale table semantics.
- Preserve §12 honest-metrics framing (permitted vs forbidden README copy; no auto-learning claims).
- Map operator vocabulary to glossary EN (`evaluation`, discovery, wave, glossary, canonical guide, install kit, fail-closed, session / Session Handoff).
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md`.

**Non-Goals:**

- Lines 1–261 (§1–§10 — owned by discovery-research-wave-1).
- `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (owned by avaliacoes-wave-2).
- Discovery artifact trio (owned by discovery-wave-1).
- `openspec/changes/archive/` (immutable).
- Canonical guide, curso, kit templates, skills/commands.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Re-opening discovery positioning or G4 metrics product decisions — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WAr/active-changes; mid-file slices; ≤350–400 LOC; archive OUT
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-discovery-research-wave-1/` — prior factory propose; explicit §11–§12 deferral
- `openspec/changes/translate-guide-wave-1/proposal.md` — mid-file slice pattern on single file
- AS-IS: `openspec/changes/add-sdd-discovery-positioning/research.md` lines 262–404
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown research; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = discovery research mid-file slice lines 262–404

| Option | Verdict |
|--------|---------|
| A — Canonical guide mid-file slice | Rejected — all 14 guide slices already proposed on base |
| B — Whole `research.md` (~404 LOC) | Rejected — exceeds ≤350–400 LOC whole-file budget; wave-1 already owns 1–261 |
| C — Bundle with discovery artifact trio | Rejected — trio already owned by discovery-wave-1 |
| D — `research.md` lines 262–404 (§11–§12) | **Chosen** — ~143 LOC; natural section boundary completing the deferred tail |

**Rationale:** Closes the discovery research track in budget-safe slices; §11–§12 references stable EN anchors from §9–§10 without re-deciding product outcomes.

### D2: In-place substitution — no dual-file; archive untouched

**Chosen:** Edit the research path in place for the listed line range only. Forbidden: `*.en.md` / `*-pt.md` siblings; rewriting `openspec/changes/archive/`.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES archive-out rule.

### D3: §11 sequence and §12 honest-metrics claims stable under EN labels

**Chosen:** Translate §11–§12 prose and table headers to English. Do not change step order (①–⑥), non-goals (Landing/Discord/BMAD outside roadmap), or §12.4 permitted vs forbidden README copy semantics. Keep quoted EN blocks in §12.4 as allowlisted copy examples (may remain verbatim).

**Rationale:** Apply agents must still honor dissemination roadmap and honest G4 hook; language migration must not look like a re-decision.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that research.md lines 262–404 MUST be English after substitution. Do not invent a new capability.

**Rationale:** Same pattern as discovery-research-wave-1 and guide-wave ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT fails on §1–§10 PT outside slice | Soft prerequisite: apply wave-1 first; document in Session Handoff |
| Accidental edit outside lines 262–404 | Tasks gate with line-boundary checklist + grep spot-checks |
| Outcome drift in §11 step order or §12 claims | Tasks forbid changing sequence/non-goals; language only |
| G-PT false positives on quoted PT / proper nouns | Allowlist brands; quotes only when clearly historical |
| Broken links after heading renames | G-LINK on whole file; careful §-anchor preservation |
| Apply before wave-1 lines 1–261 EN | Soft prerequisite noted in proposal + Session Handoff |

## Migration Plan

1. Apply: rewrite lines 262–404 EN in-place; freeze paths/change-ids/URLs; map §11–§12 headings and prose.
2. Gate: `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-discovery-research-wave-2 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- openspec/changes/add-sdd-discovery-positioning/research.md`.

## Open Questions

- None blocking propose. Follow-up: `translate-adversarial-research-wave-*` split for explore-adversarial research (~459 LOC); gitnexus skill waves (`.claude/skills/gitnexus/*` — no `.cursor` mirrors today).
