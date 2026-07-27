# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-specs-wave-1` (open DRAFT PR #104) owns `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and **defers** `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to this wave.
- Active translate ownership on current base includes kit W2c/W2d, hub `openspec/infra.md`, skills waves 1–6, avaliacoes/design/agents-rules waves. None list `sdd-install-kit/spec.md` as primary ownership.
- Open translate PRs #78 / #84 / #93–#104 do not own this path (PR #104 names it as non-goal / wave-2).
- Canonical guide and aula-05 remain deferred (mid-file G-PT / over LOC). Kit `templates/doc/design/` prefers post hub-design apply+archive.
- AS-IS: Purpose and early requirements are largely English; residual PT clusters around upgrade MANIFEST merge wording, bootstrap HYBRID warning, COPY dry-run labels, and upgrade `--apply` approval scenarios. Runtime marker `[x] Actualização aprovada` is grepped by `sdd-kit/upgrade.sh` and MUST stay byte-stable.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT), except the documented freeze/allowlist runtime approval marker.
- Preserve normative meaning: versioned kit layout, sha256 integrity, install abort on mismatch, upgrade dry-run/`--apply` gates, bootstrap profile warning (non-fatal), COPY vs APPLY_TEMPLATE labels.
- Keep OpenSpec structure (`## Purpose`, `### Requirement:`, `#### Scenario:`, `MUST`/`WHEN`/`THEN`) and freeze-list identifiers byte-stable.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` (allowlist note for the freeze marker if needed).

**Non-Goals:**

- Specs owned by `translate-specs-wave-1`.
- Renaming `[x] Actualização aprovada` or changing `sdd-kit/upgrade.sh` / UPGRADE_REPORT scaffold (separate runtime/i18n change if desired later).
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
- Open PR #104 proposal/design — explicit deferral of `sdd-install-kit` to wave-2
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`
- `sdd-kit/upgrade.sh` — greps `[x] Actualização aprovada`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown specs; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = sdd-install-kit alone (specs wave-2)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC |
| C — `sdd-install-kit` alone (~292 / 1 file) | **Chosen** — deferred by wave-1; within budget; whole-file G-PT; disjoint from owned set |
| D — Active-change theme (`add-sdd-discovery-positioning` artifacts) | Deferred — valid WAr/active-changes track; specs residual finishes the wave-1 handoff first |
| E — Kit `sdd-kit/templates/doc/design/{002,003,004}` | Deferred — checksum-aware; prefer after hub design apply+archive |

**Rationale:** PR #104 / wave-1 design already named this file as the next specs slice; 1 file / ~292 LOC fits budgets and avoids overlap.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at the same path. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees under `openspec/specs/`.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Freeze runtime approval marker; translate surrounding prose

Keep byte-stable: `sdd-kit/` paths, `MANIFEST.yaml`, `sha256:`, `merge: COPY|MERGE`, `gate:`, `install.sh`, `upgrade.sh`, `verify.sh`, `bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `UPGRADE_REPORT.md`, `doc/sistema-sdd-pedro.md`, OpenSpec keywords, and the exact approval marker `[x] Actualização aprovada` (runtime contract with `sdd-kit/upgrade.sh`).

Translate: residual PT requirement bodies and scenario WHEN/THEN prose (HYBRID bootstrap warning; COPY dry-run label scenarios; upgrade apply-approval scenario prose around the freeze marker; mixed PT fragments in upgrade MANIFEST wording).

**Wave allowlist:** G-PT deny-list token `actualização` inside the freeze marker is an intentional exception (document in proposal checklist). If stock `verify-i18n-wave.sh --files` fails solely on that marker, apply MAY add a minimal line-level exemption for that exact string (or filter) without renaming the runtime contract — prefer documenting over changing `upgrade.sh` in this language wave.

**Rationale:** Agents and scripts must keep the same executable contracts after language substitution.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution (except the documented freeze/allowlist marker). Do not invent a new `sdd-install-kit-i18n` capability. Do not weaken or rewrite normative install-kit meaning beyond language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements / specs wave-1.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT fail on freeze marker `Actualização` | Explicit allowlist; do not rename marker in this wave; optional minimal verify exemption only if needed |
| Semantic drift of integrity / upgrade / bootstrap contracts | Tasks require fact parity; freeze script names and MANIFEST keys |
| Accidental overlap with specs wave-1 paths | Own only `sdd-install-kit/spec.md`; non-goal the three wave-1 specs |
| Parallel propose factory races | Owned-set includes open PR path lists; this path is deferred/non-goal on #104 and absent as primary elsewhere |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-2` session after propose merge (or when artifacts are on apply base). Prefer wave-1 apply+archive first only if shared delta-spec conflicts arise; file slices are disjoint so parallel apply is OK after each propose merges.
3. Apply substitutes `sdd-install-kit/spec.md` in place; run wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up: aula-05 split; kit design mirrors; guide G-PT strategy; optional rename of UPGRADE_REPORT approval marker + `upgrade.sh` (separate change).
