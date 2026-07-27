# Design — translate-kit-design-wave-2 (kit Impeccable design guide mirror PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Hub `translate-design-wave-2` owns `doc/design/000-impeccable-design-system-guia.md`.
- Remote factory branches already claim `translate-kit-design-wave-1` for kit `002|003|004` and many claim `translate-specs-wave-2` for `sdd-install-kit` — those paths are **owned** for this run (skip even without merged PRs).
- Kit mirror `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md` (~310 LOC) remains Portuguese, is currently byte-identical to the hub PT file, and was deferred by kit-design-wave-1 non-goals.
- Canonical guide and aula-05 / design `001` remain deferred (mid-file G-PT / over LOC).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the kit `000` Impeccable reference mirror with glossary-canonical English **in-place**.
- Prefer wording alignment with hub EN after design-wave-2 apply when available; otherwise glossary-map from AS-IS PT.
- Regenerate MANIFEST checksums after the template edit.
- Pass `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md` and `bash sdd-kit/verify.sh`.

**Non-Goals:**

- Hub `doc/design/000-*` (design-wave-2).
- Kit/hub `001-*`, kit `002|003|004` (kit-design-wave-1).
- Specs install-kit / guide / curso / skills / commands.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD.
- Changing Impeccable adoption recommendations — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md`, `WAVES.md`, `WAVE-PROPOSAL-TEMPLATE.md`, `CURSOR-AUTOMATIONS.md`
- `openspec/specs/sdd-docs-language/spec.md`
- `openspec/changes/translate-design-wave-2/` — hub `000` propose pattern
- Remote `translate-kit-design-wave-1` proposals — deferral of kit `000`/`001`
- Owned-set scan: open translate PRs #78/#84/#93–#104 + remote `translate-*` change ids on factory branches
- AS-IS: `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`
- Graphify / GitNexus — SKIP / docs-only
- GitHub Issues — **Issue:** —

## Decisions

### D1: Scope = kit Impeccable guide mirror only

| Option | Verdict |
|--------|---------|
| A — `translate-specs-wave-2` (install-kit) | Rejected — already claimed on many factory branches |
| B — kit `002|003|004` | Rejected — owned by `translate-kit-design-wave-1` |
| C — kit `000` alone (~310) | **Chosen** — within budget; deferred by kit-design-wave-1; disjoint |
| D — kit/hub `001` (~592) | Rejected — over LOC; needs split |
| E — Guide W3 mid-file | Rejected — whole-file G-PT |

### D2: In-place + checksums; no dual-file

Edit the kit template path in place; run `gen-manifest-checksums.sh`. Forbidden: `*.en.md` / `*-pt.md`.

### D3: Soft hub alignment

Prefer copying/adapting hub EN after design-wave-2 apply; do not block propose or invent a hard dependency. If hub still PT at apply time, translate kit AS-IS with glossary forms matching design-wave-2 tasks.

### D4: Spec delta under `sdd-docs-language`

ADDED requirement that this kit mirror MUST be English after substitution. No new capability id.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Hub/kit drift | Soft prerequisite + glossary mapping parity with design-wave-2 |
| MANIFEST conflict with concurrent kit apply | Serialize apply vs other kit-template applies (CURSOR-AUTOMATIONS §5) |
| G-PT on status/applicability markers | Translate markers to EN equivalents as in hub wave-2 |
| Parallel factory race on same id | Pre-push owned-set scan showed no remote `translate-kit-design-wave-2` |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR (artifacts only).
2. Separate `/opsx:apply translate-kit-design-wave-2`.
3. Apply EN rewrite + checksum regen + wave gates.
4. Archive later (separate session).
5. Follow-ups: kit/hub `001` split waves; guide G-PT strategy; aula-05 split.
