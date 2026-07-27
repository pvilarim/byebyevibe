# Design — translate-kit-design-wave-1 (kit design 002|003|004 mirrors PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Hub `translate-design-wave-1` (merged propose) owns `doc/design/002|003|004` and listed kit `sdd-kit/templates/doc/design/` mirrors as a **non-goal** / checksum-aware later wave.
- Active translate ownership on current base includes kit W2c/W2d (Cursor rules + proposal scaffold), hub infra, skills, avaliacoes-wave-1, design-wave-1/2. None own kit design `002|003|004` templates.
- Open translate propose PRs (#84, #93–#104) cover commands, curso aulas 01–04 + scripts AGENTS, specs residual, avaliacoes-wave-2 — none claim these three kit design paths.
- Kit apply PR #78 may still touch `sdd-kit/MANIFEST.yaml` for W2c/W2d — **propose** of OpenSpec-only artifacts is parallel-safe; **apply** of this wave must serialize MANIFEST writes.
- Canonical guide and `aula-05` remain deferred (mid-file G-PT / over LOC). Kit `000` (~310) and `001` (~592) design mirrors deferred to later kit-design waves.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the three listed kit design templates with glossary-canonical English **in-place**.
- Prefer content parity with hub `doc/design/002|003|004` after hub design-wave-1 apply; otherwise map PT→EN via glossary with identical procedure semantics.
- Preserve install/detect/apply procedure semantics, scenario labels (`C1-UI`, `G2`), script paths, and relative links.
- Regenerate MANIFEST checksums (G-MANIFEST) after template edits.
- Pass `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md`.

**Non-Goals:**

- Hub `doc/design/002|003|004` (owned by `translate-design-wave-1`).
- Kit `sdd-kit/templates/doc/design/000-*`, `001-*`.
- Canonical guide, skills/commands, kit Cursor rules / `_template/proposal.md`, hub infra, evaluations, curso.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Path renames; changing what `--apply` does or does not do — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; kit templates in-scope; G-MANIFEST
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes; kit checksum serialization on apply
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-design-wave-1/` — hub sibling slice; deferred kit mirrors
- `openspec/changes/translate-kit-wave-2d/` — kit template + checksum task pattern
- AS-IS: the three `sdd-kit/templates/doc/design/{002,003,004}-*.md` files
- `scripts/verify-i18n-wave.sh`, `sdd-kit/gen-manifest-checksums.sh`, `sdd-kit/verify.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown kit templates; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = kit design mirrors of hub design-wave-1 (002|003|004)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — `doc/curso/aula-05` whole file (~504) | Rejected — exceeds ≤350–400 LOC; needs split |
| C — Kit `000` alone (~310) | Deferred — valid alternate; this run closes the hub-deferred 002|003|004 mirror cluster |
| D — Kit `001` alone (~592) | Rejected — over LOC |
| E — Kit `002`+`003`+`004` as `translate-kit-design-wave-1` | **Chosen** — 3 files / ~385 LOC; whole-file G-PT; G-MANIFEST; disjoint from owned set; matches hub design-wave-1 non-goal |

**Rationale:** Design-wave-1 explicitly parked these checksum-aware mirrors; they are the next completable whole-file kit design residual within budget.

### D2: Soft hub apply prerequisite; hard MANIFEST serialization on apply

**Chosen:** Propose proceeds without waiting for hub design-wave-1 apply merge. Apply **SHOULD** prefer hub EN landing first (copy/align). Apply **MUST** avoid concurrent writes to `sdd-kit/MANIFEST.yaml` with other kit-template applies (e.g. open PR #78).

**Rationale:** CURSOR-AUTOMATIONS §2 / §5 — disjoint proposes parallel OK; kit checksum applies serialize.

### D3: In-place substitution — no dual-file; checksums required

**Chosen:** Edit the three kit template paths in place. Forbidden: `*.en.md` / `*-pt.md` siblings. After edits run `bash sdd-kit/gen-manifest-checksums.sh` then `bash sdd-kit/verify.sh`.

**Rationale:** `sdd-docs-language` dual-file prohibition; MANIFEST integrity for consumer installs.

### D4: Spec delta = lasting EN requirement for this kit slice

**Chosen:** ADDED requirement under `sdd-docs-language` that these three kit design template files MUST be English after substitution. Do not invent a new capability in this language wave.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Hub/kit wording drift | Soft prereq: apply after design-wave-1; tasks allow align-from-hub or glossary PT→EN |
| MANIFEST conflict with PR #78 / other kit applies | Document serialize-on-apply; propose does not touch MANIFEST |
| Semantic drift of install steps | Freeze scripts/flags/pins; procedure parity gates |
| G-PT false positives | Freeze/allowlist; quoted historical PT only when clearly cited |
| LOC near upper budget (~385) | Cap at these three files; do not add `000`/`001` |

## Migration Plan

1. Soft check: if hub `doc/design/002|003|004` already EN, prefer aligning kit mirrors to hub.
2. Apply: rewrite the three kit templates EN in-place; freeze paths/scripts/pins/flags; keep procedure semantics.
3. Checksums: `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`.
4. Gate: `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md`.
5. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-design-wave-1 --strict`.
6. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- sdd-kit/templates/doc/design/002-ui-module-install.md sdd-kit/templates/doc/design/003-ui-stack-adapters.md sdd-kit/templates/doc/design/004-probity-module-install.md sdd-kit/MANIFEST.yaml`.

## Open Questions

- None blocking propose. Follow-up: kit `000` (~310); kit `001` (split ≤400 LOC); guide whole-file G-PT strategy; `aula-05` split waves.
