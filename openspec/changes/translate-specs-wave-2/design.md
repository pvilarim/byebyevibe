# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-specs-wave-1` (DRAFT PR #104) owns `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and **defers** `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to this wave.
- AS-IS: most of `sdd-install-kit/spec.md` is already English; residual Portuguese clusters in (1) a mixed MANIFEST/`merge: MERGE` sentence under Deterministic SDD upgrade, (2) bootstrap HYBRID warning requirement + scenarios, (3) upgrade dry-run COPY label + header requirements/scenarios, (4) UPGRADE_REPORT approval marker string `[x] Actualização aprovada`.
- Owned-path union (active `openspec/changes/translate-*` + open translate PRs) does **not** list `sdd-install-kit/spec.md` as a primary target.
- Other free residuals (guide mid-file, aula-05 ~503 LOC, kit `templates/doc/design/`, hub design `001` ~592 LOC) are deferred: guide/aula-05/design-001 need splits; kit design templates prefer checksum-aware apply after hub design apply+archive.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT).
- Preserve normative meaning: sha256 integrity abort; path-traversal block; dry-run vs apply mutual exclusion; MERGE vs COPY; backup-before-overwrite; bootstrap HYBRID WARN (non-fatal); ByeByeVibe public name vs on-disk `sdd-kit/`.
- Keep OpenSpec structure (`## Purpose`, `### Requirement:`, `#### Scenario:`, `MUST`/`WHEN`/`THEN`) and freeze-list identifiers byte-stable.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`.

**Non-Goals:**

- Specs owned by `translate-specs-wave-1`.
- Already-English specs without residual PT.
- Rewriting `openspec/changes/archive/`.
- Canonical guide, skills/commands, kit templates, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing install/upgrade/verify **runtime** behavior or retargeting `upgrade.sh` checkbox parsing — language-only propose/apply for the **spec prose**. If the live script still matches a Portuguese checkbox string, document the EN form in the spec and leave any script follow-up to a separate change (do not silently break the approval gate).

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` in-scope for residual PT only
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-specs-wave-1/proposal.md` (PR #104) — explicit deferral of install-kit to wave-2
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown spec; no code symbols edited in propose)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = sdd-install-kit alone (wave-2 as deferred)

| Option | Verdict |
|--------|---------|
| A — Pack with wave-1 three specs | Rejected — already owned by open propose #104; would double-own |
| B — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths; guide needs section split strategy |
| C — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC |
| D — Kit `templates/doc/design/002+003+004` | Deferred — G-MANIFEST / checksum; prefer after hub design apply+archive |
| E — Hub `doc/design/001` (~592) | Rejected — exceeds budget; needs split |
| F — `sdd-install-kit` alone (~292 / 1 file) | **Chosen** — explicitly deferred by wave-1; within budget; whole-file G-PT; disjoint |

**Rationale:** WAVES.md residual-PT-only for specs; wave-1 handoff names this file; single-file keeps review small and avoids checksum/kit apply coupling.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at `openspec/specs/sdd-install-kit/spec.md`. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Freeze normative identifiers; translate prose only

Keep byte-stable: `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `gen-manifest-checksums.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `scripts/sdd-metrics.sh`, `sha256:`, `merge: COPY` / `MERGE`, `gate:`, profile names, ByeByeVibe, OpenSpec keywords, WARN/ERROR message **keys** that scripts emit when those strings are contractual (translate surrounding prose; keep exact stderr tokens that tests/operators grep when documented as literals).

Translate: residual PT requirement titles/bodies and WHEN/THEN prose; mixed PT fragments inside otherwise-EN requirements; Portuguese approval checkbox label in the **spec** to a clear English form (e.g. `[x] Upgrade approved`) while noting apply must not break the live gate — if script still expects PT, either keep the documented marker identical to the script until a follow-up, or translate both in the same apply only if the script string is confirmed. **Propose decision:** apply session MUST grep `upgrade.sh` for the approval marker before rewriting the checkbox string; if script is PT, keep the string byte-stable (allowlist as quoted/contractual) and translate surrounding prose only; if script already accepts EN / is flexible, use English checkbox text.

**Rationale:** Language wave must not silently disable upgrade apply safety.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `sdd-install-kit/spec.md` MUST be English after substitution. Do not invent `sdd-install-kit-i18n`. Do not weaken install-kit normative meaning beyond language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including wave-1).

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Double-own with specs-wave-1 | Wave-1 non-goals already exclude install-kit; this wave lists only that path |
| Semantic drift of integrity / dry-run / MERGE | Tasks require freeze of script names, MANIFEST keys, and exit-code contracts; language-only Forbidden lists |
| UPGRADE_REPORT checkbox string mismatch | Apply gate: inspect `upgrade.sh` marker before changing checkbox prose; prefer allowlist if script still PT |
| G-PT false positives on path Portuguese segments | Document allowlist; paths stay byte-stable |
| Accidental kit template / MANIFEST edits | Non-goals + Forbidden in tasks; no G-MANIFEST this wave |

## Migration Plan

1. Merge this **propose** DRAFT PR (artifacts only under `openspec/changes/translate-specs-wave-2/`).
2. Separate `/opsx:apply translate-specs-wave-2` session substitutes the target spec in-place and runs wave gates.
3. Separate `/opsx:archive` after apply merge.
4. Rollback: revert the apply commit; propose artifacts alone do not change runtime specs until apply.

## Open Questions

- None blocking propose. Apply must confirm the live `upgrade.sh` approval checkbox string before rewriting `[x] Actualização aprovada` in the spec.
