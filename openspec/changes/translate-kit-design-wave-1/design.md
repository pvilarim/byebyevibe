# Design — translate-kit-design-wave-1 (kit design module-install mirrors PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Hub `translate-design-wave-1` owns `doc/design/002|003|004` and explicitly deferred kit mirrors under `sdd-kit/templates/doc/design/` as a checksum-aware follow-up (G-MANIFEST).
- Owned set (base + open translate PRs) covers kit Cursor rules W2c/W2d, hub infra, skills, commands, avaliacoes, hub design 000/002–004, curso aulas 01–04 + scripts AGENTS, specs waves 1–2. None own kit design templates `002|003|004`.
- Kit design inventory: `000` ~310 LOC (deferred), `001` ~592 LOC (over budget — split later), `002`+`003`+`004` ~385 LOC / 3 files (**this wave**).
- Canonical guide remains blocked for mid-file G-PT; factory prefers completable whole-file slices.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the three listed kit design templates with glossary-canonical English **in-place**.
- Regenerate `sdd-kit/MANIFEST.yaml` checksums after template edits (G-MANIFEST).
- Preserve install/detect/apply procedure semantics, scenario labels (`C1-UI`, `G2`), script paths, and relative links.
- Prefer aligning with hub EN from `translate-design-wave-1` when available on the apply base.
- Pass `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md`.

**Non-Goals:**

- Hub `doc/design/002|003|004` (owned by `translate-design-wave-1`).
- Kit `000` / `001` design templates.
- Canonical guide, skills/commands, kit Cursor rules, hub infra, evaluations.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Path renames; changing what `--apply` does or does not do — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; kit templates in-scope; G-MANIFEST
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes; serialize kit-template applies
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-design-wave-1/` — hub sibling slice; deferred kit mirrors
- AS-IS: the three `sdd-kit/templates/doc/design/` files listed in the proposal
- `scripts/verify-i18n-wave.sh`, `sdd-kit/gen-manifest-checksums.sh`, `sdd-kit/verify.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown kit templates; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = three kit module-install / adapter templates (kit-design wave-1)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — Kit `000` alone (~310) | Deferred — valid alternate; factory prefers mirroring hub design-wave-1 cluster first |
| C — Kit `001` alone (~592) | Rejected — exceeds ≤350–400 LOC; needs split |
| D — Bundle hub + kit `002|003|004` in one change | Rejected — hub already owned by `translate-design-wave-1`; would double-own |
| E — Active explore `research.md` PT theme wave | Deferred — lower install-kit leverage than consumer-facing templates |
| F — Kit `002`+`003`+`004` as `translate-kit-design-wave-1` | **Chosen** — 3 files / ~385 LOC; dense residual PT; whole-file G-PT; disjoint from owned set; G-MANIFEST in-scope |

**Rationale:** Same coherent optional-module cluster as hub design-wave-1; consumer installs get EN after kit apply; fits budgets.

### D2: In-place substitution + mandatory checksum regen

**Chosen:** Edit the three kit template paths in place. Forbidden: `*.en.md` / `*-pt.md` siblings. After edits: `bash sdd-kit/gen-manifest-checksums.sh` then `bash sdd-kit/verify.sh`.

**Rationale:** `sdd-docs-language` dual-file prohibition; AGENTS.md / kit integrity require MANIFEST `sha256:` updates whenever `sdd-kit/templates/` change.

### D3: Soft apply prerequisite vs hub design-wave-1; serialize kit-template applies

**Chosen:** Propose may land in parallel (disjoint paths). Apply SHOULD prefer hub `translate-design-wave-1` apply-complete (copy hub EN → kit mirrors when texts are intended twins). If hub EN is unavailable, translate kit PT AS-IS with glossary + procedure parity from hub propose/design. Do **not** parallelize this wave’s apply with another in-flight `sdd-kit/templates/` + `MANIFEST.yaml` apply (e.g. kit W2c/W2d PR #78).

**Rationale:** CURSOR-AUTOMATIONS §5 kit checksums guidance; avoids twin-text drift and checksum races.

### D4: Preserve procedure semantics and scenario labels

**Chosen:** Translate prose/headings/tables to English. Keep `C1-UI`, `G2`, script invocations, `--detect` / `--apply` / `--yes`, matrix row meanings, and “what apply does not do” lists semantically identical.

**Rationale:** Agents and operators must still execute the same install steps after language migration.

### D5: Spec delta = lasting EN requirement for this kit slice

**Chosen:** ADDED requirement under `sdd-docs-language` that these three kit design template files MUST be English after substitution and that template edits update MANIFEST checksums. Do not invent a new `sdd-kit-design-docs` capability in this language wave.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of install steps / “does not” lists | Tasks require procedure parity; freeze script paths and flags |
| Stale MANIFEST checksums | Mandatory `gen-manifest-checksums.sh` + G-MANIFEST / `sdd-kit/verify.sh` |
| Concurrent kit-template apply race (PR #78) | Soft gate: serialize applies that touch `sdd-kit/templates/` |
| Hub/kit text drift if hub apply lands later | Prefer hub-first apply order; if kit applies first, hub EN still authoritative for later alignment |
| G-PT false positives on brand/tool names or path segments | Freeze/allowlist; quoted historical PT only when clearly cited |
| LOC near upper budget (~385) | Cap at these three files; do not add kit `000`/`001` |

## Migration Plan

1. Soft check: hub `translate-design-wave-1` apply status; if EN hub files exist, use as primary source for kit mirrors.
2. Apply: rewrite the three kit templates EN in-place; freeze paths/scripts/pins/flags; keep procedure semantics.
3. Checksums: `bash sdd-kit/gen-manifest-checksums.sh` then `bash sdd-kit/verify.sh`.
4. Gate: `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md`.
5. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-design-wave-1 --strict`.
6. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- sdd-kit/templates/doc/design/002-ui-module-install.md sdd-kit/templates/doc/design/003-ui-stack-adapters.md sdd-kit/templates/doc/design/004-probity-module-install.md sdd-kit/MANIFEST.yaml`.

## Open Questions

- None blocking propose. Follow-up kit-design candidates: `000` (~310, own wave); `001` (split into ≤400 LOC section waves). Hub design `001` split and guide G-PT strategy remain separate. Active explore `research.md` theme wave remains optional.
