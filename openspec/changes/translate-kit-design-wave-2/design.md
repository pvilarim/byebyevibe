# Design — translate-kit-design-wave-2 (kit Impeccable design-system reference PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Hub `translate-design-wave-2` owns `doc/design/000-impeccable-design-system-guia.md` and deferred kit mirrors under `sdd-kit/templates/doc/design/` as a checksum-aware follow-up (G-MANIFEST).
- Kit-design wave-1 (open DRAFT PR #106) owns kit `002|003|004` and explicitly deferred kit `000` (~310 LOC) as the next wave.
- Owned set (base + open translate PRs after kit-design-wave-1) covers kit Cursor rules W2c/W2d, hub infra, skills, commands, avaliacoes, hub design 000/002–004, kit design 002–004, curso aulas 01–04 + scripts AGENTS, specs waves 1–2. None own kit design template `000`.
- Kit design inventory remaining: `000` ~310 LOC (**this wave**), `001` ~592 LOC (over budget — split later).
- Canonical guide remains blocked for mid-file G-PT; factory prefers completable whole-file slices.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md` with glossary-canonical English **in-place**.
- Regenerate `sdd-kit/MANIFEST.yaml` checksums after template edits (G-MANIFEST).
- Preserve reference/adaptation status meaning, DOCS_SPECS vs APP-target applicability, shadcn-default stance, adoption checklist semantics, and relative links.
- Prefer aligning with hub EN from `translate-design-wave-2` when available on the apply base.
- Pass `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`.

**Non-Goals:**

- Hub `doc/design/000` (owned by `translate-design-wave-2`).
- Kit `002|003|004` (owned by `translate-kit-design-wave-1` / PR #106).
- Kit/hub `001` (over LOC — split later).
- Canonical guide, skills/commands, kit Cursor rules, hub infra, evaluations.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Path renames; changing Impeccable adoption recommendations or installing Impeccable on this hub — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; kit templates in-scope; G-MANIFEST
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes; serialize kit-template applies
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-design-wave-2/` — hub sibling slice; deferred kit mirrors
- Open PR #106 `translate-kit-design-wave-1` — prior kit-design propose pattern; deferred kit `000`
- AS-IS: `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`
- `scripts/verify-i18n-wave.sh`, `sdd-kit/gen-manifest-checksums.sh`, `sdd-kit/verify.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown kit template; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = kit Impeccable reference guide alone (kit-design wave-2)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — Kit `000` alone (~310) | **Chosen** — 1 file / ~310 LOC; dense residual PT; whole-file G-PT; disjoint from owned set; explicitly deferred by kit-design-wave-1 |
| C — Kit `001` alone (~592) | Rejected — exceeds ≤350–400 LOC; needs split |
| D — Bundle hub + kit `000` in one change | Rejected — hub already owned by `translate-design-wave-2`; would double-own |
| E — Active explore `research.md` PT theme wave | Deferred — lower install-kit leverage than consumer-facing templates |
| F — WAVE-PROPOSAL-TEMPLATE stub polish only | Deferred — tiny residual; prefer high-leverage kit mirror first |

**Rationale:** Same coherent Impeccable reference twin as hub design-wave-2; consumer installs get EN after kit apply; fits budgets.

### D2: In-place substitution + mandatory checksum regen

**Chosen:** Edit the kit template path in place. Forbidden: `*.en.md` / `*-pt.md` siblings. After edits: `bash sdd-kit/gen-manifest-checksums.sh` then `bash sdd-kit/verify.sh`.

**Rationale:** `sdd-docs-language` dual-file prohibition; AGENTS.md / kit integrity require MANIFEST `sha256:` updates whenever `sdd-kit/templates/` change.

### D3: Soft apply prerequisite vs hub design-wave-2; serialize kit-template applies

**Chosen:** Propose may land in parallel (disjoint paths). Apply SHOULD prefer hub `translate-design-wave-2` apply-complete (copy hub EN → kit mirror when texts are intended twins). If hub EN is unavailable, translate kit PT AS-IS with glossary + reference/adaptation parity from hub propose/design. Do **not** parallelize this wave’s apply with another in-flight `sdd-kit/templates/` + `MANIFEST.yaml` apply (e.g. kit-design-wave-1 PR #106 apply; kit W2c/W2d PR #78).

**Rationale:** CURSOR-AUTOMATIONS §5 kit checksums guidance; avoids twin-text drift and checksum races.

### D4: Preserve reference status and DOCS_SPECS applicability

**Chosen:** Translate prose/headings/tables to English. Keep import origin, `[if applicable]` / DOCS_SPECS hub notes, shadcn-default Fase 2 stance, relative links to kit `001`/`002`/`003`/canonical guide, and adoption checklist meaning semantically identical. Status label may move from Portuguese marker text to an English equivalent (e.g. `[REFERENCE — NEEDS ADAPTATION]`) so G-PT passes while meaning stays.

**Rationale:** Agents must still treat this as an APP-target reference doc distributed via the kit, not an install instruction for the DOCS_SPECS hub.

### D5: Spec delta = lasting EN requirement for this kit slice

**Chosen:** ADDED requirement under `sdd-docs-language` that this kit design template file MUST be English after substitution and that template edits update MANIFEST checksums. Do not invent a new `sdd-kit-design-docs` capability in this language wave.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of adoption checklist / applicability notes | Tasks require procedure/status parity; freeze paths and profile labels |
| Stale MANIFEST checksums | Mandatory `gen-manifest-checksums.sh` + G-MANIFEST / `sdd-kit/verify.sh` |
| Concurrent kit-template apply race (PR #106 / #78) | Soft gate: serialize applies that touch `sdd-kit/templates/` |
| Hub/kit text drift if hub apply lands later | Prefer hub-first apply order; if kit applies first, hub EN still authoritative for later alignment |
| G-PT false positives on brand/tool names or path segments | Freeze/allowlist; quoted historical PT only when clearly cited |
| Status marker PT tokens fail G-PT if left as-is | Translate marker to EN equivalent in apply; keep meaning |

## Migration Plan

1. Soft check: hub `translate-design-wave-2` apply status; if EN hub file exists, use as primary source for the kit mirror.
2. Apply: rewrite the kit template EN in-place; freeze paths/pins/flags; keep reference/adaptation and DOCS_SPECS semantics.
3. Checksums: `bash sdd-kit/gen-manifest-checksums.sh` then `bash sdd-kit/verify.sh`.
4. Gate: `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`.
5. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-design-wave-2 --strict`.
6. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.

**Rollback:** `git checkout -- sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md sdd-kit/MANIFEST.yaml`.

## Open Questions

- None blocking propose. Follow-up kit-design candidates: `001` (split into ≤400 LOC section waves). Hub design `001` split and guide G-PT strategy remain separate. Active explore `research.md` theme wave remains optional.
