# Design — translate-kit-scripts-wave-1 (sdd-upgrade-diff PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Propose-factory owned-set = union of primary paths in active `openspec/changes/translate-*/` on base **and** open GitHub translate propose PRs (#84, #93–#121), excluding Non-goals bullets.
- Markdown kit surfaces (rules W2c/W2d, design 000/002–004 hub+templates, specs, curso 01–04, skills/commands, many active-change artifacts) are already owned. Whole-file over-budget residuals remain: canonical guide (~2848), design `001` hub+template (~593 each), `doc/curso/aula-05-*.md` (~504), `explore-adversarial-sdd-review/research.md` (~460), `add-sdd-discovery-positioning/research.md` (~405).
- AS-IS: hub `scripts/sdd-upgrade-diff.sh` (~135 LOC) and kit template `sdd-kit/templates/scripts/sdd-upgrade-diff.sh` (~152 LOC) still emit Portuguese comments/operator messages (`ficheiro(s)`, `inventário`, `não`, `apenas`, …) and fail `bash scripts/verify-i18n-wave.sh --files …` G-PT today.
- Hub and template are **not** byte-identical: template parses MANIFEST `source:` into `CURATED_DESTS`/`CURATED_SOURCES`; hub still uses path-only `CURATED_FILES`. MANIFEST lists `merge: MERGE` for this path.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese comments and operator-facing `echo`/stderr strings in both script paths with glossary-canonical English **in-place** (whole-file G-PT).
- Preserve per-file control flow, exit codes, variable names, and the existing hub↔template logic divergence.
- Regenerate `sdd-kit/MANIFEST.yaml` checksums after the template edit (G-MANIFEST).
- Pass `bash scripts/verify-i18n-wave.sh --files scripts/sdd-upgrade-diff.sh,sdd-kit/templates/scripts/sdd-upgrade-diff.sh`.

**Non-Goals:**

- Porting template `source:` parsing into the hub script (behavior sync — separate change if desired).
- Translating `sdd-kit/upgrade.sh`, `bootstrap-sdd.sh`, `install-ui-module.sh` (hub+template over budget), or `verify-infra.sh` (coupled to infra-wave-1).
- Canonical guide / design `001` / aula-05 / over-budget research files.
- Rewriting `openspec/changes/archive/`.
- Dual-file `*.en.md` / `*-pt.md` (or `*.en.sh` siblings).
- Global G-DoD (`--dod`).
- Changing upgrade/diff semantics — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; kit templates in-scope; G-MANIFEST when `sdd-kit/templates/` touched
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- AS-IS: `scripts/sdd-upgrade-diff.sh`, `sdd-kit/templates/scripts/sdd-upgrade-diff.sh`, `sdd-kit/MANIFEST.yaml` entry (`merge: MERGE`)
- `scripts/verify-i18n-wave.sh` (confirmed G-PT fail on both paths)
- Open translate PR path lists #84 / #93–#121 (no primary ownership of these two scripts)
- Graphify / GitNexus — SKIP / docs+shell operator strings; no application symbol rename
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = upgrade-diff hub + kit template (2 files, ~287 LOC)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — design `001` hub+template | Rejected — ~593 LOC each / over budget |
| C — aula-05 alone (~504) | Rejected — over ≤350–400 LOC |
| D — `install-ui-module.sh` hub+template | Rejected — ~604 LOC combined; single-file would drift mirrors |
| E — `sdd-upgrade-diff.sh` hub+template (~287) | **Chosen** — within budget; substantive residual PT; disjoint; kit-template checksum path clear |
| F — EN gate/glossary quotes inside existing `translate-*/tasks.md` | Rejected — not substantive residual-PT slices |

**Rationale:** Fits ≤4 files / ≤350–400 LOC; prior kit script language work already treats operator-facing shell under `sdd-kit/templates/scripts/` as substitutable (e.g. bootstrap in related waves); whole-file G-PT completable.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese comments/strings at the same paths. Forbidden: parallel `*.en.sh`, `*-pt.sh`, or language-suffixed siblings.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Do not sync hub↔template logic in this wave

**Chosen:** Translate each file independently. Keep hub `CURATED_FILES` path-only parser and template `CURATED_DESTS`/`CURATED_SOURCES` `source:`-aware parser as they are today.

**Rationale:** Language waves must not silently change C2 upgrade behavior; `merge: MERGE` exists specifically because local hub customizations may diverge. Behavior unification is a separate type B/C change if product wants it.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that both listed script paths MUST be English after substitution. Do not invent a new `sdd-upgrade-diff-i18n` capability.

**Rationale:** Same pattern as prior `translate-*` ADDED slice requirements.

### D5: G-MANIFEST checksum regeneration is part of apply

**Chosen:** After editing `sdd-kit/templates/scripts/sdd-upgrade-diff.sh`, apply MUST run `bash sdd-kit/gen-manifest-checksums.sh` before declaring gates green. Do not hand-edit unrelated MANIFEST fields.

**Rationale:** Kit integrity aborts on sha256 drift; WAVES.md G-MANIFEST is mandatory when templates are touched.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Accidental hub↔template logic merge | Explicit non-goal; tasks forbid porting `source:` parser in this wave |
| Operators relying on Portuguese echo strings | EN glossary forms; G-SMOKE advisory for inventory/diff flows |
| G-MANIFEST fail if checksums skipped | Task + gate require `gen-manifest-checksums.sh` |
| Parallel propose factory races | Owned-set includes open PR primaries; these paths absent as primary on #84/#93–#121 |
| Pre-existing hub `sdd-kit/verify.sh` noise | Apply re-runs checksums + verify after template edit; do not expand scope into unrelated kit failures |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR (artifacts only under `openspec/changes/translate-kit-scripts-wave-1/`).
2. Separate `/opsx:apply translate-kit-scripts-wave-1` after propose merge (or when artifacts are on apply base).
3. Apply substitutes both scripts in place; regenerates MANIFEST checksums; runs wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up candidates: `install-ui-module.sh` after budget strategy; over-budget whole-file splits; guide G-PT strategy; optional hub↔template parser unification.

## Open Questions

- None blocking propose. Optional later: dedicated change to align hub parser with template `source:` support (behavior, not language).
