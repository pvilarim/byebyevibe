# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Specs wave-1 (open DRAFT PR #104) owns `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and defers `openspec/specs/sdd-install-kit/spec.md` (~292 LOC) to this wave.
- Active translate ownership on current base includes kit W2c/W2d, hub `openspec/infra.md`, skills waves 1–6, avaliacoes-wave-1, design-waves 1–2, agents-rules 1/1b/1c. None own `sdd-install-kit/spec.md` as a primary translation target.
- Open translate PRs (owned paths): #78 kit apply; #84 avaliacoes-wave-2; #93–#98 commands-wave-1..4; #99–#103 curso; #104 specs-wave-1 (three other specs). `sdd-install-kit` appears only as **deferred** in #104 — not primary ownership.
- Chosen slice: 1 file / ~292 LOC — within ≤4 files / ≤350–400 LOC; residual PT; whole-file G-PT.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT), except freeze/allowlist literals.
- Preserve normative meaning: deterministic install/upgrade, HYBRID bootstrap warning (non-fatal), COPY dry-run label, UPGRADE_REPORT approval gate, backups, mutual exclusion of `--dry-run`/`--apply`.
- Keep OpenSpec structure (`## Purpose`, `### Requirement:`, `#### Scenario:`, `MUST`/`WHEN`/`THEN`) and freeze-list identifiers byte-stable.
- Keep the runtime approval checkbox string `[x] Actualização aprovada` byte-stable (matched by `sdd-kit/upgrade.sh`); document as G-PT allowlist exception.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`.

**Non-Goals:**

- Specs wave-1 paths (already proposed).
- Changing `sdd-kit/upgrade.sh` / renaming the approval checkbox (separate non-i18n change if ever desired).
- Kit `templates/doc/design/` mirrors, guide mid-file G-PT, aula-05 split.
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
- Runtime freeze evidence: `sdd-kit/upgrade.sh` greps `[x] Actualização aprovada`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown specs; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = sdd-install-kit alone (wave-2)

| Option | Verdict |
|--------|---------|
| A — Pack install-kit with kit design template mirrors | Rejected — checksum-aware kit templates; separate surface; exceeds “one slice” clarity |
| B — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths; guide needs split strategy |
| C — aula-05 alone (~504) | Rejected — exceeds ≤350–400 LOC |
| D — `sdd-install-kit` alone (~292 / 1 file) | **Chosen** — deferred by wave-1; within budget; residual PT; disjoint |
| E — Kit `sdd-kit/templates/doc/design/003` only | Deferred — still valid parallel later; this run follows explicit wave-1 handoff |

**Rationale:** CURSOR-AUTOMATIONS §2 allows parallel disjoint proposes; wave-1 already named this change-id for the deferred file.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at the same path. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees under `openspec/specs/`.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Preserve runtime contracts without pasting G-PT deny-list tokens into EN prose

Keep byte-stable identifiers: `sdd-kit/install.sh`, `sdd-kit/upgrade.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `MANIFEST.yaml` keys (`merge: COPY`, `merge: MERGE`, `sha256:`, `gate:`), flags, profile names APP/DOCS_SPECS/HYBRID, label tokens `COPY` / `APPLY_TEMPLATE`.

For the UPGRADE_REPORT approval gate and any Portuguese stderr strings still emitted by kit scripts: **do not** paste deny-list tokens (e.g. the `actualização` fragment in the approval checkbox grep) into the migrated English spec. Instead, require that `--apply` checks the approval checkbox string **as implemented in `sdd-kit/upgrade.sh`** (and likewise for HYBRID WARN text as implemented in the bootstrap script/template). Operators who need the exact bytes read the script. Optionally wrap a one-line historical citation in an explicit allowlist note in the proposal if a future gate gains quote exemptions — Layer-1 G-PT today is a whole-file deny-list scan (`WAVES.md`: do not paste raw deny-list tokens into migrated EN docs).

Translate: residual PT requirement titles/bodies and scenario WHEN/THEN prose (HYBRID warning requirements, COPY label requirement, mixed sentences in Deterministic SDD upgrade, Portuguese operator/scenario lines).

**Rationale:** Renaming the checkbox inside `upgrade.sh` is out of scope for a language-only docs wave. Leaving the Portuguese checkbox string inside the EN spec would fail G-PT. Spec→script indirection preserves the runtime contract without deny-list residue.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution, with an explicit allowlist note for the frozen approval checkbox literal. Do not invent a new capability. Do not weaken install/upgrade semantics beyond language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including specs-wave-1).

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Accidental rewrite of `[x] Actualização aprovada` | Explicit freeze in proposal/tasks; allowlist for G-PT; forbid editing `upgrade.sh` |
| Semantic drift of HYBRID warning / COPY labels | Tasks require fact parity; freeze flag names and label tokens `COPY` / `APPLY_TEMPLATE` |
| Parallel propose factory races | Owned-set includes open PR primary paths; this file is deferred-only on #104 |
| G-PT fail on frozen Portuguese checkbox | Document allowlist exception; if gate still fails, add a wave-local note / script allowlist per WAVES.md false-positive guidance without changing the runtime string |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-2` session after propose merge (or when artifacts are on apply base). Soft preference: specs-wave-1 apply can proceed in parallel (disjoint paths).
3. Apply substitutes `sdd-install-kit/spec.md` in place; run wave gates; keep approval checkbox literal.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up candidates: kit `templates/doc/design/` mirrors; guide G-PT strategy; aula-05 split; optional later change to English-ize the upgrade approval checkbox **and** `upgrade.sh` together.
