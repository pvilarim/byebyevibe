# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN + contract strings)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Open DRAFT PR #104 (`translate-specs-wave-1`) owns `sdd-ci-gates` / `sdd-post-install-verification` / `sdd-session-coordination` and **defers** `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to wave-2.
- Other open translate PRs (#78 kit apply; #84 avaliacoes-wave-2; #93–#98 commands; #99–#103 curso) do not own `sdd-install-kit/spec.md` as a primary path.
- Canonical guide and aula-05 remain deferred (mid-file G-PT / over LOC). Kit `templates/doc/design/` mirrors remain checksum-aware follow-ups after hub design apply.
- Whole-file G-PT on the install-kit spec cannot succeed while the file must keep Portuguese literals that `upgrade.sh` / kit `bootstrap-sdd.sh` currently match — deny-list tokens (`actualização`, `não`, `ficheiros`, …) fire on those strings.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place**.
- Coordinated EN for the two executable operator-facing contract strings so the spec, `upgrade.sh`, and kit `bootstrap-sdd.sh` stay consistent and G-PT passes.
- Preserve normative install/upgrade/integrity meaning (sha256 fail-closed, dry-run vs apply, MERGE vs COPY, path-traversal block, UPGRADE_REPORT gate).
- Regenerate MANIFEST checksums for the touched bootstrap template.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/upgrade.sh,sdd-kit/templates/scripts/bootstrap-sdd.sh` and `bash sdd-kit/verify.sh`.

**Non-Goals:**

- Wave-1 three-spec slice; other already-EN specs.
- Hub `scripts/bootstrap-sdd.sh` (no matching PT HYBRID WARN today).
- Broad kit-script PT cleanup beyond the two contract strings.
- Canonical guide; skills/commands; kit design mirrors; evaluations; course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing install/upgrade **behavior** beyond language of those operator-facing strings.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` residual PT in-scope
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open PR #104 proposal — explicit deferral of `sdd-install-kit` → wave-2
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`, `sdd-kit/upgrade.sh`, `sdd-kit/templates/scripts/bootstrap-sdd.sh`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs+script string swap (no symbol refactor)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = install-kit spec + two contract-string files

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC |
| C — Spec-only leave PT contract literals | Rejected — G-PT deny-list fails on `actualização` / `não` / `ficheiros` in those quotes |
| D — Spec-only + verify-script allowlist | Rejected — out of scope; prefer removing residual PT |
| E — Spec + `upgrade.sh` + kit `bootstrap-sdd.sh` (+ MANIFEST checksums) | **Chosen** — enables whole-file G-PT; ≤4 content files; G-MANIFEST covered |
| F — Kit `templates/doc/design/{002,003,004}` | Deferred — alternate factory candidate; install-kit is the named wave-1 deferral |

**Rationale:** Honors PR #104 deferral naming (`translate-specs-wave-2`) and unblocks G-PT with the smallest coordinated script edits.

### D2: Exact EN replacements for contract strings

| Location | Current PT (freeze until apply) | Target EN (apply MUST use both scaffold + grep / WARN consistently) |
|----------|----------------------------------|---------------------------------------------------------------------|
| `upgrade.sh` scaffold + `grep -q` | `[x] Actualização aprovada` (scaffold line includes `pelo utilizador`) | Checkbox line: `- [ ] Upgrade approved by the user`; grep: `\[x\] Upgrade approved` |
| Kit `bootstrap-sdd.sh` HYBRID WARN | `WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID.` (+ follow-on PT lines) | `WARN: package.json and openspec/ coexist — profile may be HYBRID.` (+ English follow-on lines; keep stderr + default-to-APP semantics) |

**Rationale:** Keep a short stable grep needle (`Upgrade approved`) so minor wording after the marker does not break `--apply`; document exact strings in tasks Gates.

### D3: In-place substitution — no dual-file

**Chosen:** Rewrite at the listed paths. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees.

**Rationale:** Normative `sdd-docs-language` / WAVES.md dual-file prohibition.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution, including scenarios that reference the new EN contract strings. Do not invent a new capability. Do not weaken install/upgrade/integrity MUST semantics.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

### D5: Consumer UPGRADE_REPORT migration note

Operators with an existing PT-approved report (`[x] Actualização aprovada`) MUST re-check the EN checkbox after this wave lands before `--apply`. Document in tasks / G-SMOKE; no automatic rewrite of consumer reports.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Scaffold vs grep mismatch breaks `--apply` | Single task owns both sites; Gate greps both for the same EN needle |
| Spec scenario string drifts from bootstrap WARN | Gate requires identical WARN substring in spec + template |
| Stale MANIFEST sha256 | Mandatory `gen-manifest-checksums.sh` + `sdd-kit/verify.sh` |
| Parallel factory claims same paths | Owned-set includes open PRs; none primary-own install-kit / these two scripts |
| LOC / file budget | Spec ~292 + small script hunks; 3 content paths (+ mechanical MANIFEST) |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR (artifacts only).
2. Separate `/opsx:apply translate-specs-wave-2` after propose merge (or when artifacts are on apply base).
3. Apply: EN rewrite of install-kit spec; swap contract strings in `upgrade.sh` + kit bootstrap; regen checksums; run wave gates + kit verify.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-ups: aula-05 split; kit design mirrors; guide G-PT strategy; optional hub bootstrap alignment if HYBRID WARN is reintroduced there.
