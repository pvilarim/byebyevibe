# Design — translate-explore-oss-wave-2 (explore-oss metodologia-insercao.md PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-explore-oss-wave-1` (open propose PR #108) owns `openspec/changes/explore-oss-coverage-gaps/research.md` — sibling methodology file remains free.
- Open translate propose PRs (#84, #93–#115) own commands, curso, specs, kit-design, avaliacoes-wave-2, active-changes, metrics, discovery, supply-chain — still disjoint from `metodologia-insercao.md`.
- Canonical guide and over-budget surfaces (`aula-05` ~504 LOC, hub/kit `doc/design/001` ~593 LOC, `explore-adversarial` research ~460 LOC, discovery `research.md` ~405 LOC) remain deferred for G-PT-safe split strategies.
- Chosen WAr/active-changes continuation: single file `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` (~182 LOC, ~51 deny-list hits) — within ≤4 files / ≤350–400 LOC; whole-file G-PT achievable.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` with glossary-canonical English **in-place**.
- Preserve methodology phase structure (Phase 0–5), verification tables (V1–V5, F1–F5), pilot exception rule, 6-point registry (R1–R6), activation modes (A–D), A–E selectivity matrix, and tool/gap mappings.
- Map evaluation-scale and decision vocabulary to glossary EN (`evaluation`, Adopted/Deferred, Session Handoff, wave).
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`.

**Non-Goals:**

- `research.md` (wave-1 / PR #108).
- Other active change artifacts (sibling explores; completed-change design/proposal/tasks still in PT — e.g. probity package).
- `openspec/changes/archive/` (immutable).
- Canonical guide, curso `aula-05`, design `001`, kit templates, skills/commands.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Re-opening methodology decisions (phase order, pilot skip rule, registry points) — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — WAr/active-changes; ≤4 files / ≤350–400 LOC; archive OUT
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-explore-oss-wave-1/` (PR #108) — prior factory propose pattern for this package
- AS-IS: `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown methodology; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = single explore-oss methodology file (wave-2 after research)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `aula-05` / design `001` / adversarial research whole file | Rejected — over ≤350–400 LOC |
| C — Bundle methodology + probity package | Rejected — unrelated packages; prefer thematic continuation |
| D — Tiny polish (`WAVE-PROPOSAL-TEMPLATE` 1 deny hit) | Deferred — prefer high-residual completable methodology first |
| E — `explore-oss-coverage-gaps/metodologia-insercao.md` alone | **Chosen** — 1 file / ~182 LOC; high residual PT; disjoint from wave-1 `research.md`; whole-file G-PT |

**Rationale:** Completes the explore-oss package language migration after wave-1 owns research; agents reading insertion methodology get EN without waiting for wave-1 apply.

### D2: In-place substitution — no dual-file; archive untouched

**Chosen:** Edit the methodology path in place. Forbidden: `*.en.md` / `*-pt.md` siblings; rewriting `openspec/changes/archive/`.

**Rationale:** `sdd-docs-language` dual-file prohibition + WAVES archive-out rule.

### D3: Methodology structure stable under EN labels

**Chosen:** Translate headings, table cells, and surrounding prose to English. Do not change phase numbering, verification ids, registry R1–R6 destinations, activation modes A–D, or A–E matrix on/off outcomes. Keep change-id links, paths, and tool names intact.

**Rationale:** Apply agents must still follow Phase 0→5 and the 6-point registry; language migration must not look like a methodology redesign.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that this methodology file MUST be English after substitution. Do not invent a new capability for explore methodology language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including wave-1 for `research.md`).

### D5: Parallel OK with wave-1 propose/apply

**Chosen:** Propose and later apply of wave-2 may proceed independently of wave-1 merge/apply because the path sets are disjoint (`metodologia-insercao.md` vs `research.md`).

**Rationale:** CURSOR-AUTOMATIONS.md §2 — unmerged propose PRs do not block disjoint proposes.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Structure drift (drop Phase 2 pilot exception / change R1–R6) | Tasks forbid changing phase ids and registry destinations; only language |
| G-PT false positives on quoted PT / proper nouns | Quotes only when clearly historical; allowlist brands |
| Broken links after heading renames | Prefer translating headings carefully; G-LINK on touched file |
| Parallel conflict with other active-change proposes | Own only this one path; document deferred siblings (probity package, adversarial research) |
| Portuguese orthography variants in Session Handoff stub | Explicit Forbidden PT phrases in task gates (`Objectivo`, `Fase`, `Registo`, `utilizador`, …) |

## Migration Plan

1. Apply: rewrite `metodologia-insercao.md` EN in-place; freeze paths/change-ids/pins/URLs; map phase/registry labels; keep structure.
2. Gate: `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-explore-oss-wave-2 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`.

## Open Questions

- None blocking propose. Follow-up candidates: `translate-probity-wave-1` (split `add-probity-tdd-module`); discovery `research.md` / `explore-adversarial` / `aula-05` / design `001` after split strategy; tiny polish (`WAVE-PROPOSAL-TEMPLATE` Session Handoff stub).
