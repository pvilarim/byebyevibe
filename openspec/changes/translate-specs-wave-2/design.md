# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Open DRAFT PR #104 (`translate-specs-wave-1`) owns `openspec/specs/sdd-ci-gates|sdd-post-install-verification|sdd-session-coordination` and **defers** `openspec/specs/sdd-install-kit/spec.md` to this change-id.
- Active translate ownership on current base includes kit W2c/W2d, hub `openspec/infra.md`, skills waves 1–6, avaliacoes-wave-1, design-waves 1–2, agents-rules 1/1b/1c. None own `sdd-install-kit/spec.md` as a translation target.
- Open translate PRs (owned paths): #78 kit apply; #84 avaliacoes-wave-2; #93–#98 commands-wave-1..4; #99–#103 curso aulas/scripts; #104 specs-wave-1 (three other specs). Install-kit path is free.
- Chosen slice: 1 file / ~292 LOC — within ≤4 files / ≤350–400 LOC; residual deny-list hits + surrounding PT in upgrade/bootstrap/header requirements.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT).
- Preserve normative meaning: MANIFEST integrity, install abort on checksum mismatch, upgrade dry-run/apply gates, MERGE vs COPY, HYBRID bootstrap WARN, ByeByeVibe public name vs `sdd-kit/` path.
- Keep OpenSpec structure (`## Purpose`, `### Requirement:`, `#### Scenario:`, `MUST`/`WHEN`/`THEN`) and freeze-list identifiers byte-stable.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`.

**Non-Goals:**

- Specs owned by wave-1 (#104).
- Full i18n of `sdd-kit/upgrade.sh` (still contains PT operator messages / scaffold lines — separate kit-script wave).
- Canonical guide, skills/commands, kit templates, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing install/upgrade semantics — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` in-scope for residual PT only
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`
- Open PR #104 body — explicit deferral of this path to wave-2
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown specs; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = sdd-install-kit only (honor wave-1 deferral)

| Option | Verdict |
|--------|---------|
| A — Pack with wave-1 three-spec cluster | Rejected — would exceed ≤350–400 LOC (~357+292) |
| B — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| C — aula-05 alone (~503) | Rejected — exceeds budget |
| D — Kit `templates/doc/design/003` (~103) | Deferred — checksum-aware; prefer after hub design apply+archive |
| E — `sdd-install-kit` alone (~292 / 1 file) | **Chosen** — deferred by #104; within budget; whole-file G-PT; disjoint |
| F — Include full `sdd-kit/upgrade.sh` i18n | Rejected — ~280 LOC additional PT residual; blows budget; separate wave |

**Rationale:** Follows the explicit Session Handoff / deferral from specs-wave-1; one coherent capability surface.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at the same path. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees under `openspec/specs/`.

### D3: UPGRADE_REPORT approval marker — reference `upgrade.sh` SSOT (avoid embedding PT deny-list token)

| Option | Verdict |
|--------|---------|
| A — Keep literal `[x] Actualização aprovada` in EN spec | Rejected — fails G-PT (`atualização`/`actualização` deny-list) |
| B — Translate marker in spec **and** update `upgrade.sh` grep + scaffold in this wave | Rejected for scope — touching `upgrade.sh` pulls other PT operator strings into Slice DoD / budget |
| C — EN requirement: approved checkbox = the literal that `sdd-kit/upgrade.sh` greps (script remains SSOT) | **Chosen** — language-only on the spec; runtime contract unchanged; G-PT green |

**Rationale:** Normative behavior stays “must match what upgrade.sh checks”; English prose must not paste the legacy Portuguese checkbox substring. A future kit-script i18n wave may rename the marker in script + docs together (**BREAKING** for in-flight UPGRADE_REPORT checkboxes — out of scope here).

### D4: Parallel propose OK while #104 is unmerged

Per `CURSOR-AUTOMATIONS.md` §2, disjoint propose PRs may proceed without waiting for wave-1 merge. Paths do not overlap.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Accidental change to MERGE/COPY/integrity semantics | Tasks forbid semantic edits; G-SMOKE advisory |
| Approval-marker ambiguity after EN rewrite | D3: always point to `upgrade.sh` grep as SSOT |
| Drift vs wave-1 wording | Independent delta requirement for wave-2 path only |
| False G-PT on path `doc/sistema-sdd-pedro.md` or brand strings | Freeze/allowlist; paths are identifiers |

## Migration / Apply notes

1. Substitute PT→EN **in-place** on the single listed path only.
2. Do not create dual-file siblings.
3. Do not edit `sdd-kit/upgrade.sh` / templates in this wave.
4. Run the per-wave verify command from the proposal.
5. Do not run `--dod` as a required gate for this wave.
