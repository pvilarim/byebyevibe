# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-specs-wave-1` (open DRAFT PR #104) owns `sdd-ci-gates` / `sdd-post-install-verification` / `sdd-session-coordination` and defers `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to this wave.
- Active translate ownership on current base includes kit W2c/W2d, hub `openspec/infra.md`, skills waves 1–6, avaliacoes-wave-1, design-waves 1–2, agents-rules 1/1b/1c. None own `sdd-install-kit/spec.md`.
- Open translate PRs (owned paths): #78 kit apply; #84 avaliacoes-wave-2; #93–#98 commands; #99–#103 curso; #104 specs-wave-1. None list `sdd-install-kit` as primary ownership.
- Residual PT in `sdd-install-kit` is concentrated in upgrade/bootstrap label requirements and scenario prose (~12 deny-list hit lines), plus citations of the runtime approval marker `[x] Actualização aprovada`.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT for substitutable prose).
- Preserve normative meaning: MANIFEST integrity, install/upgrade fail-closed checks, dry-run `COPY` labels, HYBRID bootstrap warning, `--dry-run`/`--apply` mutual exclusion, UPGRADE_REPORT approval gate.
- Keep OpenSpec structure and freeze-list identifiers byte-stable, including the upgrade approval marker string that `sdd-kit/upgrade.sh` greps.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` (plus verify script path if edited).

**Non-Goals:**

- Specs owned by `translate-specs-wave-1`.
- Rewriting `sdd-kit/upgrade.sh`, guide § UPGRADE_REPORT scaffold, or consumer report checkbox text to English (coordinated follow-up).
- Already-English specs without residual PT.
- Rewriting `openspec/changes/archive/`.
- Canonical guide, skills/commands, kit templates, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing install/upgrade/integrity semantics — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` in-scope for residual PT only
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`
- `sdd-kit/upgrade.sh` — greps `[x] Actualização aprovada` (freeze contract)
- `scripts/verify-i18n-wave.sh`
- Open PR #104 proposal (explicit deferral of this path)
- Graphify / GitNexus — SKIP / docs-only (markdown specs; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = sdd-install-kit alone (specs-wave-2)

| Option | Verdict |
|--------|---------|
| A — Pack with wave-1’s three specs | Rejected — owned by open PR #104; would double-own |
| B — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| C — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC |
| D — `sdd-install-kit` alone (~292) | **Chosen** — deferred by wave-1; within budget; residual PT; whole-file G-PT; disjoint |
| E — Kit `templates/doc/design/002–004` | Deferred — checksum-aware; prefer after hub design apply+archive |
| F — design/001 alone (~592) | Rejected — over LOC |

**Rationale:** Completes the residual-PT specs track started by wave-1 without overlapping owned paths.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at the same path. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees under `openspec/specs/`.

**Rationale:** Normative `sdd-docs-language` / WAVES.md.

### D3: Freeze runtime approval marker; narrow G-PT exemption if needed

**Chosen:** Keep `[x] Actualização aprovada` byte-stable in the capability spec (matches `sdd-kit/upgrade.sh`). If that token alone trips G-PT after all other PT prose is removed, add a **narrow** exemption in `scripts/verify-i18n-wave.sh` for that exact freeze phrase (document in script comment + this design). Do **not** broaden exemptions to arbitrary Portuguese.

**Rejected:** Translating the marker in the spec only (breaks contract with `upgrade.sh`). Rewriting `upgrade.sh` + guide scaffold in this wave (out of language-only / non-goal; needs coordinated behavior change).

**Rationale:** Freeze-list treats shell-checked strings as invariants; G-PT must still become passable for the wave DoD.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution. Do not invent a new `sdd-specs-i18n` capability. Do not weaken `sdd-install-kit` normative meaning beyond language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of upgrade/integrity contracts | Tasks require fact parity; freeze script names, MANIFEST keys, flags |
| G-PT fail on freeze approval marker | D3 narrow verify-script exemption for exact phrase only |
| Accidental edit to wave-1 specs | Explicit non-goal; own only `sdd-install-kit` |
| Over-broad PT exemption in verify script | Require exact-string match / documented freeze comment; review in apply |
| Parallel propose factory races | Owned-set includes open PR path lists; this path deferred (not primary) on #104 |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-2` session after propose merge (or when artifacts are on apply base).
3. Apply substitutes `sdd-install-kit` in place; add narrow G-PT exemption only if required; run wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up (optional): coordinated EN migration of UPGRADE_REPORT approval checkbox across `upgrade.sh` + guide + scaffold, then remove the narrow exemption.

## Open Questions

- None blocking propose. Optional later: whether to migrate the approval marker string to English in a dedicated non-i18n or paired change.
