# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-specs-wave-1` (open DRAFT PR #104) owns `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly deferred `openspec/specs/sdd-install-kit/spec.md` to this wave.
- Active translate ownership on current base includes kit W2c/W2d, hub `openspec/infra.md`, skills waves 1–6, avaliacoes-wave-1, design-waves 1–2, agents-rules 1/1b/1c. None own residual-PT rows inside `sdd-install-kit`.
- Open translate PRs (owned paths): #78 kit apply; #84 avaliacoes-wave-2; #93–#98 commands-wave-1..4; #99–#103 curso aulas/scripts; #104 specs-wave-1 (three other capability specs). None list `sdd-install-kit/spec.md` as primary ownership.
- Canonical guide remains deferred for mid-file G-PT; aula-05 (~503) exceeds ≤350–400 LOC; kit `templates/doc/design/` prefers post hub-design apply+archive.
- Chosen slice: `openspec/specs/sdd-install-kit/spec.md` alone (~292 LOC / 1 file) — residual deny-list hits + surrounding PT requirement/scenario prose (upgrade MERGE sentence; bootstrap HYBRID warning; dry-run COPY label; upgrade headers; approval-gate scenarios).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT).
- Preserve normative meaning: install/upgrade/verify contracts, MERGE vs COPY, profile detection, dry-run vs apply headers, mutual exclusion of flags, backup-before-overwrite, metrics MANIFEST entry.
- Keep OpenSpec structure (`## Purpose`, `### Requirement:`, `#### Scenario:`, `MUST`/`WHEN`/`THEN`) and freeze-list identifiers byte-stable.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`.

**Non-Goals:**

- Specs owned by `translate-specs-wave-1` / PR #104.
- Already-English specs without residual PT.
- Rewriting `openspec/changes/archive/`.
- Canonical guide, skills/commands, kit templates, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Renaming runtime checkbox / stderr strings inside `sdd-kit/upgrade.sh` or `bootstrap-sdd.sh` (separate contract change if ever needed).
- Changing install/upgrade/verify semantics — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` in-scope for residual PT only
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`
- `scripts/verify-i18n-wave.sh`; runtime refs `sdd-kit/upgrade.sh`, `sdd-kit/templates/scripts/bootstrap-sdd.sh`
- Open PR #104 proposal (deferred this path)
- Graphify / GitNexus — SKIP / docs-only (markdown specs; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = sdd-install-kit alone (wave-2 as deferred by wave-1)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC |
| C — `sdd-install-kit` alone (~292) | **Chosen** — within budget; residual PT; whole-file G-PT; disjoint; deferred by wave-1 |
| D — Pack install-kit with already-owned wave-1 specs | Rejected — would double-own PR #104 paths |
| E — Kit `sdd-kit/templates/doc/design/003` | Deferred — checksum-aware; prefer after hub design apply+archive |
| F — Explore `research.md` theme wave | Deferred — optional active-changes track |

**Rationale:** WAVES.md marks `openspec/specs/` as residual-PT only; this is the next deferred residual after wave-1 and fits ≤4 files / ≤350–400 LOC alone.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at the same path. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees under `openspec/specs/`.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Freeze normative identifiers; translate prose only

Keep byte-stable: `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `scripts/sdd-metrics.sh`, `UPGRADE_REPORT.md`, merge labels `COPY`/`MERGE`, profiles APP/DOCS_SPECS/HYBRID, OpenSpec keywords, package pins, ByeByeVibe.

Translate: residual PT requirement titles/bodies and scenario WHEN/THEN prose (Deterministic SDD upgrade MERGE sentence; bootstrap HYBRID warning requirement; dry-run COPY label; upgrade header modes; approval-gate scenario chrome still mixing PT).

**Rationale:** Agents and operators must keep the same executable contracts after language substitution.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution. Do not invent a new `sdd-install-kit-i18n` capability. Do not weaken or rewrite normative meaning of `sdd-install-kit` beyond language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including wave-1).

### D5: Runtime PT strings — script is source of truth; avoid deny-list re-embed

| Runtime string | Source of truth | Spec apply strategy |
|----------------|-----------------|---------------------|
| `WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID.` | `sdd-kit/templates/scripts/bootstrap-sdd.sh` | Keep exact stderr expectation in backticks (does not hit current PT deny-list tokens) |
| `[x] Actualização aprovada` (approval checkbox grepped by upgrade) | `sdd-kit/upgrade.sh` | **Do not re-embed** the deny-listed token `Actualização` / `atualização` in the capability spec. EN prose MUST require that `--apply` verifies the approval checkbox string that `sdd-kit/upgrade.sh` greps in `UPGRADE_REPORT.md` (same meaning). Renaming the checkbox in script+guide is a **separate** contract change — out of scope. |

**Rationale:** G-PT has no per-token allowlist; embedding `Actualização` would fail whole-file G-PT while changing the script string would be a behavior change outside this language wave. Cross-referencing the script preserves fact parity.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of MERGE/COPY or dry-run vs apply | Tasks require fact parity; freeze merge labels and header strings `SDD UPGRADE REPORT (dry-run)` / `SDD UPGRADE APPLY` |
| Accidental edit to wave-1 specs | Explicit non-goal; own only `sdd-install-kit/spec.md` |
| G-PT fail on approval checkbox token | D5 — script cross-reference instead of re-embedding deny-listed Portuguese |
| Parallel propose factory races | Owned-set includes open PR path lists; this path is absent as primary on #78/#84/#93–#104 |
| Soft dependency on wave-1 merge | None for propose/apply of this file — path-disjoint; apply may proceed independently once this propose is on base |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-2` session after propose merge (or when artifacts are on apply base).
3. Apply substitutes `sdd-install-kit/spec.md` in place; run wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up candidates: aula-05 split; kit design mirrors; guide G-PT strategy; optional checkbox EN rename change (script+guide+spec) if product wants EN runtime strings.

## Open Questions

- None blocking propose. Optional later: dedicated change to rename UPGRADE_REPORT approval checkbox to English in `upgrade.sh` + guide + consumers (contract migration, not this wave).
