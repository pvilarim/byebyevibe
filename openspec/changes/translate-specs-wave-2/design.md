# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-specs-wave-1` (open DRAFT PR #104) owns three residual-PT capability specs and **defers** `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to this wave.
- Install-kit capability still mixes English requirements with Portuguese requirement titles/bodies/scenarios (bootstrap HYBRID warning, dry-run COPY label, European spellings such as `ficheiros` / `Actualização`).
- Executable contract: `sdd-kit/upgrade.sh` matches `[x] Actualização aprovada` in `UPGRADE_REPORT.md`. That token is on the G-PT deny-list (`actualização`), so a spec-only EN rewrite that keeps the PT marker fails G-PT; a rewrite that changes only the spec breaks `--apply`.
- Owned set (active base `translate-*` What Changes + open translate PRs #78 / #84 / #93–#104) does **not** list `openspec/specs/sdd-install-kit/spec.md` or `sdd-kit/upgrade.sh` as primary ownership. Kit apply PR #78 touches rule templates + MANIFEST, not `upgrade.sh`.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT).
- Migrate the UPGRADE_REPORT approval-marker contract to English **in lockstep** in `sdd-kit/upgrade.sh` (scaffold checkbox, `grep` needle, operator hint) so G-PT passes and `--apply` keeps working.
- Preserve normative install/upgrade/bootstrap meaning (profiles, MANIFEST merge strategies, dry-run vs apply, mutual exclusion, backups, gate-field non-eval).
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/upgrade.sh`.

**Non-Goals:**

- Specs owned by wave-1 (`sdd-ci-gates`, `sdd-post-install-verification`, `sdd-session-coordination`).
- Already-English specs without residual PT.
- Rewriting `openspec/changes/archive/`.
- Canonical guide copy of the approval checkbox (guide mid-file G-PT deferred).
- Full EN rewrite of all Portuguese stderr in `scripts/bootstrap-sdd.sh` / kit bootstrap templates (only quote freeze when needed; those strings are not this wave’s primary surface).
- Kit Cursor rule templates / `sdd-kit/templates/**` / MANIFEST checksum regeneration.
- Skills/commands, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing install/upgrade semantics beyond the synchronized approval-marker string.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` residual PT only
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-specs-wave-1/` (PR #104) — explicit deferral of install-kit to wave-2
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`, `sdd-kit/upgrade.sh`
- `scripts/verify-i18n-wave.sh` — G-PT deny-list includes `actualização`
- Graphify / GitNexus — SKIP / docs-only (markdown + string literals; no symbol refactor)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = install-kit spec + minimal upgrade.sh contract migration

| Option | Verdict |
|--------|---------|
| A — Spec only; keep `[x] Actualização aprovada` | Rejected — G-PT deny-list hits `actualização` |
| B — Spec only; invent EN marker without editing `upgrade.sh` | Rejected — breaks `--apply` approval gate |
| C — Spec + lockstep EN marker in `sdd-kit/upgrade.sh` | **Chosen** — 2 files; substituted LOC within ≤350–400; G-PT + runtime contract |
| D — Bundle with full bootstrap stderr EN | Rejected — expands surface; HYBRID WARN string does not trip current deny-list; defer |
| E — Wait for kit apply #78 merge | Rejected — different paths; parallel propose allowed |

**Rationale:** Closes wave-1 deferral; fits budgets; keeps executable approval gate coherent.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese at the same paths. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees.

**Rationale:** Normative `sdd-docs-language` / WAVES.md dual-file prohibition.

### D3: Canonical EN approval marker = `[x] Update approved`

**Chosen:** Migrate scaffold from `- [ ] Actualização aprovada pelo utilizador` → `- [ ] Update approved by the operator` (or equivalent glossary-stable EN), and match `grep -q '\[x\] Update approved'` plus the operator hint line. Spec requirement/scenario quotes MUST use the same needle.

**Rationale:** Short, stable EN; parallel to kit EN patterns (`[MANUAL ACTION]`); avoids deny-list tokens.

### D4: Freeze MANIFEST/flags/headers; translate prose around them

Keep byte-stable: `merge: COPY` / `MERGE`, `--dry-run` / `--apply`, `SDD UPGRADE REPORT (dry-run)`, `SDD UPGRADE APPLY`, profile names, `gate:` non-eval rule, paths under `sdd-kit/`.

Translate: Portuguese requirement titles/bodies/scenarios (bootstrap warning requirement, COPY label requirement, mixed European spellings in otherwise EN requirements).

Quoted bootstrap HYBRID WARN may remain Portuguese if the live script still emits it and it does not match G-PT deny-list — document as allowlist/freeze quote in apply notes.

### D5: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec/specs/sdd-install-kit/spec.md` MUST be English and that the approval-marker contract MUST stay synchronized with `sdd-kit/upgrade.sh`. Do not invent a new capability. Do not weaken `sdd-install-kit` semantics beyond language + marker string sync.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Spec/script marker drift | Single apply task touches both; gate greps the same EN needle in both files |
| Operators with old PT-checked reports | Document one-time re-check EN checkbox after upgrade; same as any marker migration |
| Guide still shows PT checkbox text | Explicit non-goal; guide wave later |
| Parallel kit apply #78 conflicts | Different paths (`upgrade.sh` vs rule templates/MANIFEST) |
| Accidental MANIFEST/template edits | Forbidden in tasks; no G-MANIFEST this wave |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-2` after propose merge (or when artifacts are on apply base).
3. Apply: EN rewrite of install-kit spec + lockstep approval-marker migration in `upgrade.sh`; run wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-ups (other waves): aula-05 split; kit design mirrors; guide G-PT strategy; optional bootstrap stderr EN.

**Rollback:** `git checkout -- openspec/specs/sdd-install-kit/spec.md sdd-kit/upgrade.sh`.

## Open Questions

- None blocking propose. Prefer `[x] Update approved` unless apply discovers an existing EN alias already documented in consumer reports (unlikely).
