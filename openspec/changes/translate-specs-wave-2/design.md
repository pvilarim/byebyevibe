# Design — translate-specs-wave-2 (sdd-install-kit spec PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-specs-wave-1` (open DRAFT PR #104) owns `sdd-ci-gates` / `sdd-post-install-verification` / `sdd-session-coordination` and deferred **`openspec/specs/sdd-install-kit/spec.md`** (~293 LOC) to this wave.
- Active translate ownership on current base (kit W2c/W2d, infra, skills 1–6, avaliacoes-1, design 1–2, agents-rules) does **not** own this path. Open translate PRs #78 / #84 / #93–#104 likewise do not list it as primary ownership.
- Other residual candidates deferred again: canonical guide (~2848, mid-file G-PT blocked); aula-05 (~504, over LOC); kit `templates/doc/design/` (checksum-aware, prefer after hub design apply+archive); `doc/design/001` (~593, over LOC / needs split).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT).
- Preserve normative meaning: versioned kit layout; MANIFEST sha256; `install.sh` / `upgrade.sh` / `verify.sh` contracts; MERGE vs COPY; HYBRID bootstrap WARN (continue, not fail); dry-run vs APPLY header labels.
- Keep OpenSpec structure (`## Purpose`, `### Requirement:`, `#### Scenario:`, `MUST`/`WHEN`/`THEN`) and freeze-list identifiers byte-stable.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`.

**Non-Goals:**

- Specs-wave-1 capability paths.
- Already-English specs without residual PT.
- Rewriting `openspec/changes/archive/`.
- Canonical guide, skills/commands, kit templates, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing install/upgrade/bootstrap semantics — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` in-scope for residual PT only
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-specs-wave-1/` (PR #104) — explicit deferral of this path
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown spec; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = `sdd-install-kit` alone (honor wave-1 deferral)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — aula-05 alone (~504) | Rejected — exceeds ≤350–400 LOC |
| C — `sdd-install-kit` alone (~293) | **Chosen** — deferred by wave-1; within budget; whole-file G-PT; path-disjoint |
| D — Kit `templates/doc/design/002+003+004` (~385) | Deferred — G-MANIFEST / checksum coupling; prefer after hub design apply+archive |
| E — Kit design `000` alone (~311) | Deferred — same checksum preference; leave for kit-design mirror wave |
| F — Bundle with specs-wave-1 paths | Rejected — those paths already owned by open PR #104 |

**Rationale:** Closes the explicit wave-1 deferral; 1 file / ~293 LOC; no MANIFEST work; parallel-safe with open proposes.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at `openspec/specs/sdd-install-kit/spec.md`. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees under `openspec/specs/`.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Freeze normative identifiers and observed CLI strings; translate prose only

Keep byte-stable: `sdd-kit/install.sh` / `upgrade.sh` / `verify.sh`, `MANIFEST.yaml`, `sha256:`, `merge: COPY|MERGE`, `gate:`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `UPGRADE_REPORT.md`, profile labels APP/DOCS_SPECS/HYBRID, OpenSpec keywords, and normative WARN/error string literals that operators grep for (e.g. the HYBRID coexistence WARN text if specified as exact output).

Translate: residual PT requirement titles/bodies and scenario WHEN/THEN prose (MANIFEST MERGE classification sentence; bootstrap HYBRID requirement + scenarios; upgrade COPY label + header mode requirements/scenarios).

**Rationale:** Agents and kit scripts must keep the same executable contracts after language substitution.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution. Do not invent a new capability. Do not weaken or rewrite `sdd-install-kit` normative meaning beyond language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including specs-wave-1).

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of MERGE/COPY or HYBRID warn-continue | Tasks require fact parity; freeze MANIFEST keys and WARN literals |
| Accidental rewrite of observed CLI strings while translating scenario THEN clauses | Freeze checklist; only translate surrounding PT narrative |
| Overlap with specs-wave-1 | Explicit non-goal; different path |
| Parallel propose factory races | Owned-set includes open PR path lists; this path absent as primary on #78/#84/#93–#104 |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-2` session after propose merge (or when artifacts are on apply base). Soft preference: specs-wave-1 may land first, but paths are disjoint so apply order is not a hard gate.
3. Apply substitutes `sdd-install-kit/spec.md` in place; run wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up factory candidates: kit design mirrors; aula-05 split; guide G-PT strategy; `doc/design/001` section waves.

**Rollback:** `git checkout -- openspec/specs/sdd-install-kit/spec.md` (content-only; no path moves).

## Open Questions

- None blocking propose. Exact WARN string byte-stability vs English WARN text: if G-PT fails on Portuguese inside a normative CLI string, apply session documents an allowlist exception or a coordinated script+spec update outside this language-only change (prefer allowlist for this wave).
