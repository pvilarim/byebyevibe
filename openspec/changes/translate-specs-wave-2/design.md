# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Open DRAFT PR #104 (`translate-specs-wave-1`) owns `openspec/specs/sdd-ci-gates|sdd-post-install-verification|sdd-session-coordination` and **defers** `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to this wave.
- Other open translate ownership (path lists): #78 kit apply; #84 avaliacoes-wave-2; #93–#98 commands; #99–#103 curso aulas/scripts. None list `sdd-install-kit/spec.md` as primary ownership.
- Active base `translate-*` changes own agents-rules, kit W2c/W2d, infra, skills 1–6, avaliacoes-1, design 1–2 — not this spec path.
- Canonical guide and aula-05 remain deferred (mid-file / over-LOC). Kit `templates/doc/design/` deferred (checksum-aware; prefer after hub design apply+archive).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT), except frozen script contract literals.
- Preserve normative meaning: install/upgrade integrity checks; dry-run vs apply; UPGRADE_REPORT approval gate; MERGE for upgrade tools; bootstrap HYBRID WARN (informational); classify label `COPY` vs `APPLY_TEMPLATE`.
- Keep OpenSpec structure (`## Purpose`, `### Requirement:`, `#### Scenario:`, `MUST`/`WHEN`/`THEN`) and freeze-list identifiers byte-stable.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`.

**Non-Goals:**

- Specs wave-1 three capability specs (owned by #104).
- Already-English specs without residual PT.
- Rewriting `openspec/changes/archive/`.
- Canonical guide, skills/commands, kit templates, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing install/upgrade/verify **behavior** or renaming script-matched Portuguese literals in `upgrade.sh` / `bootstrap-sdd.sh` — language only in this spec (paired script string renames are a separate change).

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` in-scope for residual PT only
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`
- Open PR #104 proposal — explicit deferral of this path to wave-2
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown spec; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = install-kit alone (wave-2 as deferred by wave-1)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC |
| C — Kit `templates/doc/design/002|003|004` (~385) | Deferred — G-MANIFEST / prefer after hub design apply+archive |
| D — Active PT `openspec/changes/add-*/proposal.md` cluster | Deferred — lower DoD leverage than capability specs |
| E — `sdd-install-kit` alone (~292 / 1 file) | **Chosen** — within budget; whole-file G-PT; disjoint; named deferral from wave-1 |

**Rationale:** WAVES.md marks `openspec/specs/` as residual-PT only; this is the remaining residual capability-spec file called out by the prior propose.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at the same path. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees under `openspec/specs/`.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Freeze normative identifiers **and** script contract literals

Keep byte-stable:

- Paths/scripts: `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `gen-manifest-checksums.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `UPGRADE_REPORT.md`, `doc/sistema-sdd-pedro.md`
- Keys/labels: `sha256:`, `merge: COPY|MERGE`, `gate:`, profiles APP/DOCS_SPECS/HYBRID
- Documented output literals already English: `ERROR: integrity check failed…`, `WARN: no sha256…`, `SDD UPGRADE REPORT (dry-run)`, `SDD UPGRADE APPLY`, `COPY`, `APPLY_TEMPLATE`, `BACKUP $dest`
- **Portuguese contract literals (allowlist / do not translate):** `[x] Actualização aprovada`; `WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID.`

Translate: requirement titles still in PT; requirement bodies and scenario WHEN/THEN prose that mix Portuguese with English (bootstrap HYBRID warning; upgrade classify/header; Deterministic SDD upgrade MANIFEST sentence; scenario titles).

**Rationale:** Agents and scripts must keep the same executable contracts after language substitution; renaming matched strings requires a paired script change (out of scope).

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution (with frozen contract literals allowed). Do not invent a new `sdd-install-kit-i18n` capability. Do not weaken or rewrite normative install/upgrade meaning beyond language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

### D5: G-PT allowlist for frozen Portuguese literals

If G-PT fails on `Actualização` / words inside the HYBRID WARN string, document wave allowlist exceptions in the apply PR (strings are freeze-list contract text, not residual prose). Prefer keeping those substrings only inside the exact backtick-quoted literals already present.

**Rationale:** Deny-list is high-signal; false positives on intentional frozen quotes are expected.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of dry-run / apply / integrity / MERGE | Tasks require fact parity; freeze script names and documented exit behaviors |
| Accidental “translation” of `[x] Actualização aprovada` or HYBRID WARN | Explicit freeze checklist + task Forbidden |
| G-PT false positives on frozen literals | Allowlist note; keep literals only in backticks |
| Parallel propose factory races | Owned-set includes #104 deferral as wave-2 ownership of this path only |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-2` session after propose merge (or when artifacts are on apply base). Parallel OK with specs wave-1 apply (disjoint files).
3. Apply substitutes install-kit spec in place; run wave gates; keep contract literals.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up (other slices): aula-05 split; kit design mirrors; guide G-PT strategy; optional paired change to EN-rename approval checkbox + WARN strings in scripts+spec together.
