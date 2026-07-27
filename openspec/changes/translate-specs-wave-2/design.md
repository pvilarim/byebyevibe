# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-specs-wave-1` (DRAFT PR #104) owns `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and **deferred** `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to wave-2.
- Other owned surfaces (active base `translate-*` + open translate PRs #78 / #84 / #93–#103): kit W2c/W2d, hub infra, skills 1–6, commands 1–4, curso aulas 01–04 + scripts AGENTS, avaliacoes 1–2, design 000/002–004, agents-rules 1/1b/1c. None own `sdd-install-kit/spec.md` as a primary path.
- Residual deny-list hits on install-kit are concentrated in mixed PT/EN requirement bodies and scenarios (MANIFEST upgrade-tool classification; bootstrap profile warning; dry-run `COPY` label; UPGRADE_REPORT approval checkbox Portuguese text).
- Larger residuals deferred elsewhere: canonical guide (~2847 LOC, mid-file G-PT); aula-05 (~503 LOC over budget); hub `doc/design/001` (~592 LOC); kit `templates/doc/design/*` (checksum-aware, prefer after hub design apply).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT).
- Preserve normative meaning: kit layout, sha256 integrity, path-traversal abort, upgrade dry-run/apply/report approval, verify post-checks, bootstrap profile warning, ByeByeVibe brand vs `sdd-kit/` path, metrics script MANIFEST entry / non-eval `gate:`.
- Keep OpenSpec structure (`## Purpose`, `### Requirement:`, `#### Scenario:`, `MUST`/`WHEN`/`THEN`) and freeze-list identifiers byte-stable.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`.

**Non-Goals:**

- Specs owned by `translate-specs-wave-1`.
- Already-English specs without residual PT.
- Rewriting `openspec/changes/archive/`.
- Canonical guide, skills/commands, kit templates, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing install/upgrade/verify/bootstrap semantics — language only.
- Waiting for wave-1 apply/merge (disjoint path; parallel propose OK).

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` in-scope for residual PT only
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open DRAFT PR #104 / `translate-specs-wave-1` — explicit deferral of install-kit to wave-2
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown spec; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = `sdd-install-kit` alone (1 file / ~292 LOC)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC |
| C — `doc/design/001` (~592) | Rejected — over budget; needs split |
| D — Kit `templates/doc/design/003` (+ peers) | Deferred — G-MANIFEST / prefer after hub design apply |
| E — Active-change proposals theme wave | Deferred — lower DoD leverage than normative install-kit residual |
| F — `sdd-install-kit` alone (~292 / 1 file) | **Chosen** — named deferral from wave-1; within budget; whole-file G-PT; disjoint from owned set |

**Rationale:** Continues the specs residual track without overlapping wave-1 paths; single-file apply can satisfy slice DoD.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at `openspec/specs/sdd-install-kit/spec.md`. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees.

**Rationale:** Normative `sdd-docs-language` / WAVES.md dual-file prohibition.

### D3: Freeze normative identifiers; translate prose only

Keep byte-stable: `sdd-kit/`, `MANIFEST.yaml`, `sha256:`, `merge: COPY|MERGE`, `gate:`, `install.sh`, `upgrade.sh`, `verify.sh`, `bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `scripts/sdd-metrics.sh`, `UPGRADE_REPORT.md`, profile names, scenario C1/C2/C3, brand **ByeByeVibe**, OpenSpec keywords.

Translate: residual PT requirement bodies and scenario titles/WHEN/THEN (bootstrap warning; dry-run COPY label; MANIFEST upgrade-tool classification sentence; Portuguese approval checkbox wording → English form that documents the same approval gate without inventing a second checkbox dialect).

**Rationale:** Agents and install scripts must keep the same executable contracts after language substitution. If the live script still matches a Portuguese checkbox string, apply MUST either (a) keep the quoted expected string as a freeze/allowlist citation while surrounding prose is EN, or (b) update the quoted expectation only when an accompanying non-i18n script change is explicitly out of scope — prefer documenting the English label the script SHOULD accept if the AS-IS script already accepts EN, else freeze the historical quoted token and note allowlist in the apply PR.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution. Do not invent a new capability. Do not weaken or rewrite `sdd-install-kit` normative meaning beyond language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including specs-wave-1).

### D5: No dependency on specs-wave-1 apply

**Chosen:** Propose (and later apply) may proceed without waiting for wave-1 merge/apply because paths do not overlap.

**Rationale:** `CURSOR-AUTOMATIONS.md` §2 — parallel disjoint proposes allowed.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of integrity / dry-run / approval gates | Tasks require fact parity; freeze flags, labels `COPY`/`APPLY`, exit codes |
| Accidental edit to wave-1 specs | Explicit non-goal; own only install-kit path |
| UPGRADE_REPORT checkbox string mismatch (PT in script vs EN in spec) | Apply notes allowlist vs script AS-IS; language-only unless script already EN |
| G-PT false positives on path segments | Freeze/allowlist paths; no dual-file |
| Parallel propose factory races | Owned-set includes open PR path lists; install-kit absent as primary on #78/#84/#93–#104 |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-2` session after propose merge (or when artifacts are on apply base).
3. Apply substitutes `sdd-install-kit/spec.md` in place; run wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up residuals: aula-05 split; design-001 split; kit design template mirrors; guide G-PT strategy; optional active-changes theme wave.

## Open Questions

- None blocking propose. Confirm at apply whether the UPGRADE_REPORT approval checkbox string in live `upgrade.sh` is still Portuguese; if so, freeze the quoted token under allowlist for this language-only wave (do not change script behavior here).
