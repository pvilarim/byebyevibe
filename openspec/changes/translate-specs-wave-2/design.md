# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-specs-wave-1` (open DRAFT PR #104) owns residual PT in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and explicitly defers `openspec/specs/sdd-install-kit/spec.md` to this wave.
- Active translate ownership on current base includes kit W2c/W2d, hub `openspec/infra.md`, skills waves 1–6, avaliacoes-wave-1, design-waves 1–2, agents-rules 1/1b/1c. None own `sdd-install-kit/spec.md` as a translation target.
- Open translate PRs (owned paths): #78 kit apply; #84 avaliacoes-wave-2; #93–#98 commands-wave-1..4; #99–#103 curso; #104 specs-wave-1 (other three specs). Install-kit path is absent as primary ownership.
- AS-IS: `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) is mostly English with residual PT in upgrade/bootstrap requirement bodies and scenarios (deny-list hits ≈12; additional PT scenario chrome).
- Hard contract: `sdd-kit/upgrade.sh` greps `[x] Actualização aprovada` before `--apply` — that substring is freeze-list for this language wave.

## Goals / Non-Goals

**Goals:**

- Substitute Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT, except documented freeze tokens).
- Preserve normative meaning: install/upgrade/bootstrap/MANIFEST contracts, dry-run vs apply, MERGE vs COPY labels, path-traversal block, profile APP/DOCS_SPECS/HYBRID warnings.
- Keep OpenSpec structure (`## Purpose`, `### Requirement:`, `#### Scenario:`, `MUST`/`WHEN`/`THEN`) and freeze-list identifiers byte-stable — including the approval checkbox marker.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` (or document allowlist-only residual on the freeze marker if G-PT cannot ignore it without script changes).

**Non-Goals:**

- Specs owned by `translate-specs-wave-1`.
- Rewriting `sdd-kit/upgrade.sh`, `scripts/bootstrap-sdd.sh`, or guide § strings that emit the Portuguese approval checkbox (separate change if EN marker migration is desired).
- Already-English specs without residual PT.
- Rewriting `openspec/changes/archive/`.
- Canonical guide, skills/commands, kit templates, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing install-kit semantics — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` in-scope for residual PT only
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/specs/sdd-install-kit/spec.md` — AS-IS target
- `sdd-kit/upgrade.sh` — approval grep contract (`[x] Actualização aprovada`)
- Open PR #104 proposal — deferred install-kit → wave-2
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown specs; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = sdd-install-kit alone (wave-2)

| Option | Verdict |
|--------|---------|
| A — Bundle with wave-1 three-spec slice | Rejected — wave-1 already proposed; would exceed budget / double-own |
| B — `sdd-install-kit` alone (~292 LOC / 1 file) | **Chosen** — within ≤4 files / ≤350–400 LOC; explicitly deferred; disjoint |
| C — Kit `sdd-kit/templates/doc/design/{002,003,004}` | Deferred — G-MANIFEST / prefer after hub design apply+archive |
| D — Hub `doc/design/001` mid-file split | Deferred — needs section strategy; G-PT whole-file constraint |
| E — aula-05 (~503) | Rejected — exceeds ≤350–400 LOC |

**Rationale:** Factory deferred this path from wave-1; single-file residual completes the current specs residual cluster without overlapping open PRs.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at `openspec/specs/sdd-install-kit/spec.md`. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Freeze approval checkbox and MANIFEST/script identifiers

Keep byte-stable:

- `[x] Actualização aprovada` (grep target in `sdd-kit/upgrade.sh`)
- Paths: `sdd-kit/install.sh`, `sdd-kit/upgrade.sh`, `sdd-kit/MANIFEST.yaml`, `sdd-kit/verify.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `doc/sistema-sdd-pedro.md`
- MANIFEST tokens: `merge: COPY`, `merge: MERGE`, `sha256:`, `gate:`
- Profile names APP / DOCS_SPECS / HYBRID; OpenSpec keywords

Translate: residual PT requirement titles/bodies and scenario WHEN/THEN prose (bootstrap HYBRID warning; COPY dry-run label; upgrade header mode; mixed PT fragments in Deterministic SDD upgrade requirement).

**Rationale:** Translating the approval marker without a paired script change would break `--apply` (fail-closed security control). That paired rename is out of scope for this language wave.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `sdd-install-kit/spec.md` MUST be English after substitution except documented freeze/script-contract tokens. Do not invent a new capability. Do not weaken install-kit normative meaning beyond language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including wave-1).

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Breaking `--apply` by translating approval checkbox | Hard freeze on `[x] Actualização aprovada`; tasks Gate greps for exact substring |
| G-PT fails on frozen marker | Keep marker in backticks/code; document allowlist in apply PR; do not edit `upgrade.sh` here |
| Semantic drift of COPY vs APPLY_TEMPLATE / HYBRID warning | Tasks require fact parity; freeze MANIFEST values and WARN contract meaning |
| Race with specs-wave-1 | Disjoint paths; parallel propose OK per CURSOR-AUTOMATIONS §2 |
| Accidental edit to wave-1 specs | Explicit non-goal; own only install-kit |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-2` session after propose merge (or when artifacts are on apply base). Soft preference: wave-1 apply may land independently (disjoint).
3. Apply substitutes install-kit spec in place; run wave gates; keep approval marker frozen.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up candidates: kit `templates/doc/design/` mirrors; hub `doc/design/001` section splits; aula-05 split; guide mid-file G-PT strategy; optional later change to EN-migrate the upgrade approval checkbox **and** `upgrade.sh` together.

## Open Questions

- None blocking propose. Optional later: rename `[x] Actualização aprovada` → English marker with coordinated `upgrade.sh` + guide scaffold update (not this wave).
