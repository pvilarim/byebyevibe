# Design — translate-kit-scripts-wave-4 (upgrade.sh PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Propose-factory owned-set = union of **primary** paths in active `openspec/changes/translate-*/` on base **and** open GitHub translate propose PRs (#84, #93–#124): prefer What Changes / Impact **Files modified** / `--files` gates; exclude Non-goals and freeze-checklist mentions (false ownership).
- Kit-scripts waves 1–3 (PRs #122 / #123 / #124) own `sdd-upgrade-diff.sh`, `verify-infra.sh`, and `bootstrap-sdd.sh` hub+template pairs. Wave-3 explicitly deferred `sdd-kit/upgrade.sh` as contract-adjacent.
- AS-IS: `sdd-kit/upgrade.sh` (~280 LOC) is mostly English CLI chrome (`usage`, classify labels, branch safety) with residual Portuguese in: mutual-exclusion stderr (`são mutuamente exclusivos`); dry-run `UPGRADE_REPORT.md` scaffold (`Relatório de actualização`, table headers, `Actualização aprovada pelo utilizador`, `Matriz de ficheiros`, `Aprovação`, human AGENTS merge checkbox prose); stop banner (`PARAR: revisar relatório…`); `--apply` missing-report / unapproved-report stderr (`não encontrado`, `não foi aprovado`, `Correr primeiro`, `Marcar '- [x] Actualização aprovada'`).
- Runtime contract: `--apply` greps `\[x\] Actualização aprovada` in `UPGRADE_REPORT.md`. Specs-wave-2 (PR #105) owns `openspec/specs/sdd-install-kit/spec.md` and already requires EN prose to **cross-reference** this script’s grep needle rather than re-embed the deny-listed token `Actualização`.
- `sdd-kit/upgrade.sh` is **not** under `sdd-kit/templates/`; G-MANIFEST is N/A for this wave.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese comments, report-scaffold prose, and operator-facing messages in `sdd-kit/upgrade.sh` with glossary-canonical English **in-place** (whole-file G-PT / Slice DoD).
- Rename the approval checkbox + matching `grep -q` needle atomically to English (recommended canonical: `[x] Upgrade approved`) so G-PT passes and `--apply` keeps working.
- Keep COPY/MERGE/profile/`--force`/integrity-check control flow unchanged.
- Pass `bash scripts/verify-i18n-wave.sh --files sdd-kit/upgrade.sh`.

**Non-Goals:**

- Editing `openspec/specs/sdd-install-kit/spec.md` (owned by specs-wave-2).
- Translating `install-ui-module.sh` hub+template, `sdd-metrics.sh`, or kit-scripts waves 1–3 paths.
- Canonical guide checkbox docs (`doc/sistema-sdd-pedro.md` — over whole-file G-PT budget).
- design `001` / aula-05 / over-budget research files.
- Rewriting `openspec/changes/archive/`.
- Dual-file `*.en.sh` / `*-pt.sh` siblings.
- Global G-DoD (`--dod`).
- Changing which files COPY vs MERGE, profile filtering, branch safety, or sha256 integrity behavior — language (+ coordinated checkbox needle) only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; kit operator scripts in-scope per factory precedent
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- AS-IS: `sdd-kit/upgrade.sh` (G-PT currently fails on report scaffold / checkbox lines)
- Contract note: `translate-specs-wave-2` / PR #105 design D5 — approval checkbox is script SoT; renaming is a separate contract-aware language wave (this change)
- Prior kit-scripts propose: PR #124 (deferred upgrade.sh); PR #122 / #123 patterns
- `scripts/verify-i18n-wave.sh`
- Open translate PR primary path lists #84 / #93–#124
- Graphify / GitNexus — SKIP / shell operator strings; no application symbol rename
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = `sdd-kit/upgrade.sh` alone (~280 LOC / 1 file)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — design `001` / aula-05 / over-budget research | Rejected — over ≤350–400 LOC |
| C — `install-ui-module.sh` hub+template | Rejected — ~604 LOC combined; single-file would leave template residual / MANIFEST mirror drift for a later wave |
| D — EN gate/glossary quotes in existing `translate-*` artifacts | Rejected — not substantive residual-PT slices (stubs exhausted by #119–#121) |
| E — `sdd-kit/upgrade.sh` alone (~280) | **Chosen** — within budget; substantive residual PT; path-disjoint; deferred by wave-3; contract-aware checkbox rename is explicit and contained in one file |

**Rationale:** Fits ≤4 files / ≤350–400 LOC; continues kit-scripts series; whole-file G-PT completable; matches factory follow-up after #124.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese strings at the same path. Forbidden: parallel `*.en.sh`, `*-pt.sh`, or language-suffixed siblings.

**Rationale:** Normative `sdd-docs-language` / WAVES.md.

### D3: Atomic English rename of approval checkbox + grep needle

**Chosen:** Replace scaffold `- [ ] Actualização aprovada pelo utilizador` with an English form such as `- [ ] Upgrade approved by the user`, and change `grep -q '\[x\] Actualização aprovada'` to `grep -q '\[x\] Upgrade approved'` (same visible checkbox stem). Error hints that tell the operator what to mark MUST quote the new English needle.

**Rationale:** Leaving `Actualização` fails G-PT. Renaming only the scaffold without the grep breaks `--apply`. Specs-wave-2 already points at script SoT, so the capability spec need not be edited here. In-flight reports with the legacy PT checkbox are a documented migration risk (re-check EN box).

### D4: Do not touch specs-wave-2 artifacts

**Chosen:** No edits under `openspec/specs/sdd-install-kit/` or `openspec/changes/translate-specs-wave-2/`. Soft coordination only: after apply, the script remains the SoT that specs-wave-2 already requires operators/agents to follow.

**Rationale:** Avoid double-owning PR #105 primary path.

### D5: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `sdd-kit/upgrade.sh` MUST be English after substitution, including the approval checkbox / grep needle. Do not invent a new `sdd-upgrade-i18n` capability.

**Rationale:** Same pattern as prior `translate-*` ADDED slice requirements.

### D6: G-MANIFEST N/A

**Chosen:** No `sdd-kit/templates/` edit → skip checksum regeneration.

**Rationale:** WAVES.md G-MANIFEST applies when templates are touched; `upgrade.sh` lives at kit root.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| In-flight `UPGRADE_REPORT.md` still has PT checkbox | Proposal marks **BREAKING** runtime string; apply notes + G-SMOKE; operators re-check EN box |
| Specs-wave-2 apply embeds old PT checkbox quotes | PR #105 design already forbids re-embedding deny-listed token; cross-ref script SoT |
| Guide still documents PT checkbox | Explicit non-goal (over-budget guide); follow-up guide wave |
| Accidental COPY/MERGE/`--force` behavior change | Tasks forbid control-flow edits; only string/comment language |
| Parallel propose factory races | Owned-set includes open PR primaries; `sdd-kit/upgrade.sh` absent as primary on #84/#93–#124 |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR (artifacts only under `openspec/changes/translate-kit-scripts-wave-4/`).
2. Separate `/opsx:apply translate-kit-scripts-wave-4` after propose merge (or when artifacts are on apply base).
3. Apply substitutes `sdd-kit/upgrade.sh` in place (including checkbox + grep); runs wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up candidates: `install-ui-module.sh` one-file or paired strategy; over-budget whole-file splits; guide G-PT strategy; optional guide sync of the new EN checkbox wording.

## Open Questions

None blocking propose. Recommended English needle `[x] Upgrade approved` may be adjusted at apply if a glossary row is added in the same PR — keep scaffold and grep identical.
