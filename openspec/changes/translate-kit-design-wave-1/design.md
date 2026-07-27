# Design — translate-kit-design-wave-1 (kit design module-install mirrors PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Hub `translate-design-wave-1` owns `doc/design/002|003|004` and explicitly deferred `sdd-kit/templates/doc/design/` as a checksum-aware later wave (G-MANIFEST).
- Kit W2c/W2d own Cursor rules templates + proposal scaffold; open apply PR #78 touches kit rules templates — path-disjoint from `sdd-kit/templates/doc/design/`.
- Open propose-factory PRs (#84–#104) own avaliacoes leftovers, commands, curso aulas 01–04, curso scripts AGENTS, and residual specs — none own kit design mirrors.
- Inventory for this surface: kit `002`+`003`+`004` ~385 LOC / 3 files (**this wave**); kit `000` ~310 (later); kit `001` ~592 (over budget — must split later).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the three listed kit design template files with glossary-canonical English **in-place**.
- Update `sdd-kit/MANIFEST.yaml` checksums via `bash sdd-kit/gen-manifest-checksums.sh` after template edits.
- Preserve install/detect/apply procedure semantics, scenario labels (`C1-UI`, `G2`), script paths, and relative links.
- Map common PT vocabulary via glossary (`ficheiro`→file, `secção`/`seção`→section, `requisito`→requirement, `avaliação`→evaluation where prose, `canónico`→canonical, `próximo`→next) without inventing synonym drift.
- Pass `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md` (includes G-MANIFEST when templates touched).

**Non-Goals:**

- Hub `doc/design/002|003|004` (owned by `translate-design-wave-1`).
- Hub/kit `doc/design/000-*`, `doc/design/001-*`.
- Kit Cursor rules templates (W2c/W2d).
- Canonical guide, skills/commands, hub infra, evaluations, course aulas.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Path renames; changing what `--apply` does or does not do — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; kit templates in-scope; G-MANIFEST
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes; one kit-template apply at a time
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-design-wave-1/` — hub sibling pattern; deferred kit mirrors
- AS-IS: the three `sdd-kit/templates/doc/design/` files listed in the proposal
- `scripts/verify-i18n-wave.sh`, `sdd-kit/gen-manifest-checksums.sh`, `sdd-kit/verify.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown kit templates; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = three kit module-install / adapter mirrors (kit-design wave-1)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths; guide still needs section strategy |
| B — Kit `000` alone (~310) | Deferred — valid alternate; factory prefers mirroring hub wave-1 cluster |
| C — Kit `001` alone (~592) | Rejected — exceeds ≤350–400 LOC; needs split |
| D — Bundle with hub `doc/design/002|003|004` | Rejected — hub already owned by `translate-design-wave-1` |
| E — Kit `002`+`003`+`004` as `translate-kit-design-wave-1` | **Chosen** — 3 files / ~385 LOC; dense residual PT; whole-file G-PT; disjoint from owned set; G-MANIFEST in-scope |

**Rationale:** Same coherent optional-module install cluster as hub design-wave-1, now on the payload mirrors consumers receive via `sdd-kit/`.

### D2: In-place substitution + mandatory checksum refresh

**Chosen:** Edit the three kit template paths in place. Run `bash sdd-kit/gen-manifest-checksums.sh` in the same apply. Forbidden: `*.en.md` / `*-pt.md` siblings; editing hub `doc/design/` in this change.

**Rationale:** `sdd-docs-language` dual-file prohibition; AGENTS.md kit checksum maintenance rule; G-MANIFEST fail-closed when templates change.

### D3: Preserve procedure semantics and scenario labels

**Chosen:** Translate prose/headings/tables to English. Keep `C1-UI`, `G2`, script invocations, `--detect` / `--apply` / `--yes`, matrix row meanings, and “what apply does not do” lists semantically identical. Prefer glossary alignment with hub design-wave-1 wording when that apply has landed; if not, EN meaning-parity with current PT kit text is sufficient.

**Rationale:** Consumer repos install from kit templates; procedure parity matters more than byte-identical prose with hub during parallel apply.

### D4: Spec delta = lasting EN requirement for this kit slice

**Chosen:** ADDED requirement under `sdd-docs-language` that these three kit design template files MUST be English after substitution, with MANIFEST checksum integrity after template edits. Do not invent a new capability in this language wave.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

### D5: Apply sequencing vs open kit apply PR #78

**Chosen:** Propose is parallel-safe (OpenSpec artifacts only). Apply SHOULD avoid overlapping another in-flight apply that edits `sdd-kit/templates/` + `MANIFEST.yaml` (CURSOR-AUTOMATIONS §5). Paths for #78 are kit rules, not design docs — still serialize MANIFEST writes if both apply PRs land close together.

**Rationale:** Checksum file is shared even when template subtrees differ.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of install steps / “does not” lists | Tasks require procedure parity; freeze script paths and flags |
| G-PT false positives on brand/tool names or path segments | Freeze/allowlist; quoted historical PT only when clearly cited |
| Broken relative links after heading renames | Prefer careful heading translation; G-LINK on touched files |
| MANIFEST drift / install abort | Mandatory `gen-manifest-checksums.sh` + G-MANIFEST / `verify.sh` |
| Concurrent kit-template apply with PR #78 | Document serialize-apply guidance; propose remains parallel-OK |
| Hub/kit temporary wording drift | Accept during parallel applies; optional follow-up sync after both archives |

## Migration Plan

1. Apply: rewrite the three kit template files EN in-place; freeze paths/scripts/pins/flags; keep procedure semantics.
2. Checksums: `bash sdd-kit/gen-manifest-checksums.sh`.
3. Gate: `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md`.
4. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-design-wave-1 --strict`.
5. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- sdd-kit/templates/doc/design/002-ui-module-install.md sdd-kit/templates/doc/design/003-ui-stack-adapters.md sdd-kit/templates/doc/design/004-probity-module-install.md sdd-kit/MANIFEST.yaml`.

## Open Questions

- None blocking propose. Follow-up kit-design candidates: kit `000` (~310); kit `001` (split ≤400 LOC). Hub design-wave-1 apply+archive preferred before treating hub/kit wording sync as a hard gate.
