# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-specs-wave-1` (open DRAFT PR #104) owns `sdd-ci-gates` / `sdd-post-install-verification` / `sdd-session-coordination` and explicitly deferred `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to this wave.
- Other open translate ownership (#78 kit apply; #84 avaliacoes-wave-2; #93–#98 commands; #99–#103 curso) does not list `sdd-install-kit/spec.md` as primary ownership.
- Canonical guide and aula-05 remain deferred (whole-file G-PT / over budget). Kit `templates/doc/design/` remains checksum-aware later.
- Chosen slice: single capability spec with residual Portuguese in bootstrap HYBRID warning, dry-run COPY labeling, MANIFEST upgrade-tool classification prose, and `--apply` approval-guard scenarios.
- Runtime detail: `sdd-kit/upgrade.sh` greps a Portuguese approval checkbox substring before `--apply` writes. That script string is **out of scope** for this language wave; the migrated spec must keep the contract without re-introducing deny-listed tokens into EN prose.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT).
- Preserve normative meaning: HYBRID ambiguous-repo bootstrap warning; dry-run `COPY` label (not `APPLY_TEMPLATE`); `--apply` approval-guard against unapproved `UPGRADE_REPORT.md`; MANIFEST merge classification for upgrade helper scripts.
- Keep OpenSpec structure (`## Purpose`, `### Requirement:`, `#### Scenario:`, `MUST`/`WHEN`/`THEN`) and freeze-list identifiers byte-stable.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`.

**Non-Goals:**

- Specs owned by `translate-specs-wave-1`.
- Editing `sdd-kit/upgrade.sh`, guide § checklist strings, or renaming the runtime approval marker (optional later coordinated change).
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
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`; runtime guard in `sdd-kit/upgrade.sh`
- Open DRAFT PR #104 (`translate-specs-wave-1`) — deferred this path to wave-2
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown spec; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = `sdd-install-kit` only (wave-2 as deferred by wave-1)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC |
| C — Kit `templates/doc/design/{002,003,004}` | Valid alternate; deferred — specs-wave-1 already named this as wave-2 |
| D — `sdd-install-kit` alone (~292 / 1 file) | **Chosen** — within budget; residual PT; whole-file G-PT; disjoint from owned set; honors wave-1 deferral |
| E — Bundle install-kit + verify-script allowlist patch | Rejected — `scripts/verify-i18n-wave.sh` owned by open commands-wave-1 (#93) |

**Rationale:** Continues the specs residual track exactly where wave-1 left off; one file under LOC budget; no ownership collision.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at the same path. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees under `openspec/specs/`.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Approval-marker contract by reference (G-PT + freeze)

**Chosen:** Do **not** edit `sdd-kit/upgrade.sh` in this wave. In the migrated EN requirement/scenarios for the `--apply` approval guard, describe the check as matching **the exact approval checkbox substring hardcoded in `sdd-kit/upgrade.sh`** (and/or cite the script path). Do **not** paste deny-listed Portuguese tokens (e.g. forms matching `actualização`) into the capability spec prose.

**Rationale:** The script’s `grep` string is a runtime freeze token. Pasting it into the EN spec would fail G-PT; rewriting the script here would expand scope and risk operator-checklist breakage. Reference-by-script preserves semantics and passes deny-list.

### D4: Freeze normative identifiers; translate prose only

Keep byte-stable: `sdd-kit/install.sh`, `sdd-kit/upgrade.sh`, `scripts/bootstrap-sdd.sh`, `UPGRADE_REPORT.md`, MANIFEST keys (`merge: COPY`, `merge: MERGE`, `sha256:`, `gate:` as docs metadata), profile names APP/DOCS_SPECS/HYBRID, OpenSpec keywords.

Translate: residual PT requirement bodies and scenario WHEN/THEN prose (HYBRID bootstrap warning; COPY dry-run labeling; upgrade-tool MANIFEST classification; `--apply` approval-guard wording via D3).

**Rationale:** Agents and install/upgrade tooling must keep the same executable contracts after language substitution.

### D5: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution. Do not invent a new capability. Do not weaken or rewrite `sdd-install-kit` normative meaning beyond language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including specs-wave-1).

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of bootstrap warning / COPY label / approval guard | Tasks require fact parity; freeze script paths and MANIFEST tokens; G-SMOKE on three procedures |
| Accidental paste of Portuguese approval marker into EN spec | D3 + task Forbidden/Gate deny patterns for deny-list tokens |
| Parallel conflict with specs-wave-1 | Own only `sdd-install-kit`; wave-1 lists it as deferred non-goal |
| Operators want EN checkbox in the report scaffold | Out of scope — optional later coordinated rename of script + guide + report template |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-2` session after propose merge (or when artifacts are on apply base). Parallel with specs-wave-1 apply is OK (disjoint paths).
3. Apply substitutes `sdd-install-kit/spec.md` in place using D3 for the approval marker; run wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up residuals: aula-05 split; kit `templates/doc/design/` mirrors (checksum-aware); guide G-PT strategy; optional EN rename of upgrade approval marker in `sdd-kit/upgrade.sh` + guide.
