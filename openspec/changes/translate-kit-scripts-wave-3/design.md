# Design — translate-kit-scripts-wave-3 (bootstrap PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Propose-factory owned-set = union of **primary** paths in active `openspec/changes/translate-*/` on base **and** open GitHub translate propose PRs (#84, #93–#123): prefer What Changes / Impact **Files modified** / `--files` gates; exclude Non-goals and freeze-checklist mentions (false ownership).
- Kit-scripts wave-1 (PR #122) owns `sdd-upgrade-diff.sh` hub+template. Kit-scripts wave-2 (PR #123) owns `verify-infra.sh` hub+template. Markdown kit surfaces, specs, curso 01–04, skills/commands, and many active-change artifacts are already owned. Whole-file over-budget residuals remain: canonical guide (~2848), design `001` hub+template (~593 each), `doc/curso/aula-05-*.md` (~504), `explore-adversarial-sdd-review/research.md` (~460), `add-sdd-discovery-positioning/research.md` (~405), `install-ui-module.sh` hub+template (~604 combined), `sdd-metrics.sh` (~467 each).
- AS-IS: hub `scripts/bootstrap-sdd.sh` (~53 LOC) and kit template `sdd-kit/templates/scripts/bootstrap-sdd.sh` (~57 LOC) share most OpenSpec / GitNexus / Graphify / install-kit chrome but **diverge** on profile selection (hub: simpler package.json / `project.md` inference; template: coexistence HYBRID stderr warning + default `APP`). Residual Portuguese includes deny-list hits (`não`, `opcional` in the shared GitNexus banner; template HYBRID line with `não`) plus additional PT operator strings outside the deny-list (`falhou`, `a continuar`, `instalação`, `coexistem`, `por defeito`, …) that Slice DoD still requires clearing.
- `sdd-kit/MANIFEST.yaml` maps `path: scripts/bootstrap-sdd.sh` → `source: templates/scripts/bootstrap-sdd.sh` (`merge` curated). Template edit implies checksum regeneration.
- Specs-wave-2 (PR #105) freeze-references bootstrap HYBRID stderr as script source-of-truth for install-kit contracts; it does **not** primary-own either bootstrap path (`--files` is only `openspec/specs/sdd-install-kit/spec.md`).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese comments and operator-facing messages in both bootstrap script paths with glossary-canonical English **in-place** (whole-file G-PT / Slice DoD).
- Preserve control flow, exit codes, profile enums, tool invocations, and hub↔template logic divergence.
- Regenerate `sdd-kit/MANIFEST.yaml` checksums after the template edit (G-MANIFEST).
- Pass `bash scripts/verify-i18n-wave.sh --files scripts/bootstrap-sdd.sh,sdd-kit/templates/scripts/bootstrap-sdd.sh`.

**Non-Goals:**

- Porting template HYBRID coexistence detection into the hub (or the reverse).
- Translating `upgrade.sh`, `install-ui-module.sh`, `sdd-metrics.sh`, or already-owned kit-scripts wave 1–2 paths.
- Editing `openspec/specs/sdd-install-kit/spec.md` (owned by specs-wave-2) — bootstrap scripts remain SoT for their stderr contracts.
- Canonical guide / design `001` / aula-05 / over-budget research files.
- Rewriting `openspec/changes/archive/`.
- Dual-file `*.en.md` / `*-pt.md` (or `*.en.sh` siblings).
- Global G-DoD (`--dod`).
- Changing which tools bootstrap installs or how profiles are chosen — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; kit templates in-scope; G-MANIFEST when `sdd-kit/templates/` touched
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- AS-IS: `scripts/bootstrap-sdd.sh`, `sdd-kit/templates/scripts/bootstrap-sdd.sh`, `sdd-kit/MANIFEST.yaml` entry (`path: scripts/bootstrap-sdd.sh`)
- Contract note: `translate-specs-wave-2` / PR #105 — bootstrap HYBRID warning is script SoT (not primary path ownership)
- Prior kit-scripts proposes: PR #122 (logic divergence preserved), PR #123 (verify-infra)
- `scripts/verify-i18n-wave.sh` (confirmed G-PT fail on both paths)
- Open translate PR primary path lists #84 / #93–#123
- Graphify / GitNexus — SKIP / docs+shell operator strings; no application symbol rename
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = bootstrap hub + kit template (2 files, ~110 LOC)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — design `001` / aula-05 / over-budget research | Rejected — over ≤350–400 LOC |
| C — `install-ui-module.sh` hub+template | Rejected — ~604 LOC combined; single-file would drift MANIFEST mirrors |
| D — `sdd-kit/upgrade.sh` alone (~281) | Deferred — approval-checkbox / report PT strings are runtime contracts adjacent to specs-wave-2; higher risk than bootstrap chrome |
| E — EN gate/glossary quotes in existing `translate-*` artifacts | Rejected — not substantive residual-PT slices (stubs exhausted by #119–#121) |
| F — `bootstrap-sdd.sh` hub+template (~110) | **Chosen** — within budget; substantive residual PT; path-disjoint under primary ownership; kit checksum path clear; preserves documented hub↔template divergence |

**Rationale:** Fits ≤4 files / ≤350–400 LOC; continues kit-scripts series after waves 1–2; whole-file G-PT completable; corrects earlier Non-goals that overstated bootstrap ownership via freeze mentions.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese strings at the same paths. Forbidden: parallel `*.en.sh`, `*-pt.sh`, or language-suffixed siblings.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Preserve hub↔template logic divergence

**Chosen:** Translate strings in each file independently. Do **not** sync profile-detection algorithms in this wave.

**Rationale:** Same pattern as kit-scripts wave-1 (`sdd-upgrade-diff`). Behavior sync is a separate change if desired.

### D4: Bootstrap stderr remains source-of-truth

**Chosen:** Translate HYBRID / GitNexus operator messages in the scripts. Do not edit specs-wave-2 artifacts here. Specs that cite bootstrap contracts MUST continue to point at the script paths rather than re-embedding deny-listed Portuguese tokens.

**Rationale:** Matches PR #105 freeze note; avoids double-owning `openspec/specs/sdd-install-kit/spec.md`.

### D5: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that both listed script paths MUST be English after substitution. Do not invent a new `sdd-bootstrap-i18n` capability.

**Rationale:** Same pattern as prior `translate-*` ADDED slice requirements.

### D6: G-MANIFEST checksum regeneration is part of apply

**Chosen:** After editing `sdd-kit/templates/scripts/bootstrap-sdd.sh`, apply MUST run `bash sdd-kit/gen-manifest-checksums.sh` before declaring gates green. Do not hand-edit unrelated MANIFEST fields.

**Rationale:** Kit integrity aborts on sha256 drift; WAVES.md G-MANIFEST is mandatory when templates are touched.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Accidental hub↔template behavior sync | Explicit non-goal; tasks forbid porting HYBRID detection either way |
| Specs-wave-2 apply embeds old PT bootstrap quotes | Specs-wave-2 already treats script as SoT; this wave translates SoT; coordinate via primary-path ownership (no double edit of the spec) |
| G-MANIFEST fail if checksums skipped | Task + gate require `gen-manifest-checksums.sh` |
| Parallel propose factory races | Owned-set includes open PR primaries; these paths absent as primary on #84/#93–#123 |
| Operators relying on Portuguese WARN chrome | EN glossary forms; G-SMOKE advisory |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR (artifacts only under `openspec/changes/translate-kit-scripts-wave-3/`).
2. Separate `/opsx:apply translate-kit-scripts-wave-3` after propose merge (or when artifacts are on apply base).
3. Apply substitutes both scripts in place; regenerates MANIFEST checksums; runs wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up candidates: `upgrade.sh` (contract-aware); `install-ui-module.sh` after budget strategy; over-budget whole-file splits; guide G-PT strategy.

## Open Questions

None — primary ownership of bootstrap is clear under Files modified / `--files` rules; logic divergence is intentional AS-IS.
