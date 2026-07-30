# Design — translate-kit-scripts-wave-6 (templates/install-ui-module.sh PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Propose-factory owned-set = union of **primary** paths in active `openspec/changes/translate-*/` on base **and** open GitHub translate propose PRs (#84, #93–#126): prefer What Changes / Impact **Files modified** / `--files` gates; exclude Non-goals and freeze-checklist mentions (false ownership).
- Kit-scripts wave-5 (DRAFT PR #126) owns hub `sdd-kit/install-ui-module.sh` and lists `sdd-kit/templates/install-ui-module.sh` as a Non-goal / follow-up — not primary ownership.
- AS-IS: `sdd-kit/templates/install-ui-module.sh` (~302 LOC) is byte-identical to the hub twin; residual Portuguese is concentrated in the embedded `openspec/infra.md` UI Development Module section written by `update_infra_md`: table headers `Componente` / `Estado` / `Verificar com`; cell chrome `sob demanda — ver doc/design/002`; deny-listed `na sessão` on the Figma MCP row.
- MANIFEST: `sdd-kit/MANIFEST.yaml` maps hub `sdd-kit/install-ui-module.sh` with `source: templates/install-ui-module.sh`. Editing the template requires `bash sdd-kit/gen-manifest-checksums.sh` (G-MANIFEST).
- Soft coordination: `translate-infra-wave-1` owns live `openspec/infra.md` EN chrome; wave-5 will emit the same forms from the hub script. This wave MUST emit identical EN chrome from the template so install/upgrade paths stay consistent.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese comments and operator-facing / embedded-infra strings in `sdd-kit/templates/install-ui-module.sh` with glossary-canonical English **in-place** (whole-file G-PT / Slice DoD).
- Align embedded UI-module table headers and on-demand / in-session cell wording with infra-wave-1 / kit-scripts wave-5 EN chrome.
- Refresh MANIFEST checksums for the touched template source.
- Keep `--detect` / `--dry-run` / `--apply` / `--yes` / stack detection / Impeccable install control flow unchanged.
- Pass `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/install-ui-module.sh` (including G-MANIFEST).

**Non-Goals:**

- Editing hub `sdd-kit/install-ui-module.sh` (owned by kit-scripts wave-5 / PR #126).
- Editing live `openspec/infra.md` (owned by `translate-infra-wave-1`).
- Kit-scripts waves 1–4 primary paths.
- `sdd-metrics.sh` hub+template (over budget).
- Canonical guide / design `001` / aula-05 / over-budget research.
- Rewriting `openspec/changes/archive/`.
- Dual-file `*.en.sh` / `*-pt.sh` siblings.
- Global G-DoD (`--dod`).
- Changing detect/apply/impeccable semantics — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist (`sessão` → session)
- `doc/i18n/WAVES.md` — budgets; kit templates in-scope; G-MANIFEST when `sdd-kit/templates/` touched
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- AS-IS: `sdd-kit/templates/install-ui-module.sh` (G-PT fails on embedded Figma/`sessão` line)
- Soft chrome alignment: `openspec/changes/translate-infra-wave-1/`; kit-scripts wave-5 propose (PR #126)
- Prior kit-scripts propose patterns: PRs #122–#126
- `scripts/verify-i18n-wave.sh`; `sdd-kit/gen-manifest-checksums.sh`; `sdd-kit/MANIFEST.yaml`
- Open translate PR primary path lists #84 / #93–#126
- Graphify / GitNexus — SKIP / shell operator strings; no application symbol rename
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = `sdd-kit/templates/install-ui-module.sh` alone (~302 LOC / 1 file)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — design `001` / aula-05 / over-budget research | Rejected — over ≤350–400 LOC |
| C — Hub+template together | Rejected — ~604 LOC; hub already owned by wave-5 |
| D — EN gate/glossary quotes in existing `translate-*` artifacts | Rejected — not substantive residual-PT slices (stubs exhausted by #119–#121) |
| E — Other unowned budget-OK kit scripts | Rejected — waves 1–5 already claim remaining script residual primaries |
| F — `sdd-kit/templates/install-ui-module.sh` alone (~302) | **Chosen** — within budget; substantive residual PT; path-disjoint; explicit wave-5 follow-up |

**Rationale:** Completes the deferred MANIFEST twin; fits budgets; whole-file G-PT completable; G-MANIFEST in-scope.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese strings at the same path. Forbidden: parallel `*.en.sh`, `*-pt.sh`, or language-suffixed siblings.

**Rationale:** Normative `sdd-docs-language` / WAVES.md.

### D3: Align embedded infra chrome with infra-wave-1 / wave-5

**Chosen:** Replace `| Componente | Estado | Verificar com |` with `| Component | Status | Verify with |`; replace `sob demanda — ver doc/design/002` with English such as `on demand — see doc/design/002`; replace `` `mcp_get_tools` na sessão `` with `` `mcp_get_tools` in session `` (or equivalent glossary-canonical wording). Do **not** edit hub script or live `openspec/infra.md` in this wave.

**Rationale:** Soft coordination avoids reintroducing PT headers via MANIFEST-sourced installs. Hub remains wave-5’s apply surface.

### D4: G-MANIFEST required

**Chosen:** After editing the template, run `bash sdd-kit/gen-manifest-checksums.sh` and include `sdd-kit/MANIFEST.yaml` checksum updates in the apply commit. Wave gate `--files` lists the template path; G-MANIFEST fires because the path is under `sdd-kit/templates/`.

**Rationale:** WAVES.md / kit integrity — install/upgrade abort on stale `sha256:`.

### D5: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `sdd-kit/templates/install-ui-module.sh` MUST be English after substitution, including embedded infra UI-module table chrome, and that MANIFEST checksums MUST be refreshed when this template is edited. Do not invent a new capability.

**Rationale:** Same pattern as prior `translate-*` ADDED slice requirements.

### D6: Soft ordering vs wave-5 apply

**Chosen:** Propose in parallel (disjoint primary paths). Apply either order; temporary hub↔template drift is accepted until both applies land. Prefer matching EN chrome strings so the eventual byte-equivalent twin is restored.

**Rationale:** CURSOR-AUTOMATIONS.md §2 — parallel disjoint proposes allowed; apply soft-gate is per-wave merge, not a propose blocker.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Hub↔template drift while wave-5 unapplied | Explicit non-goal on hub; both waves document identical EN chrome target |
| Stale MANIFEST sha256 after template edit | Task + gate require `gen-manifest-checksums.sh` / G-MANIFEST |
| Accidental detect/apply/impeccable behavior change | Tasks forbid control-flow edits; only string/comment language |
| Parallel propose factory races | Owned-set includes open PR primaries; template path absent as primary on #84/#93–#126 |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR (artifacts only under `openspec/changes/translate-kit-scripts-wave-6/`).
2. Separate `/opsx:apply translate-kit-scripts-wave-6` after propose merge (or when artifacts are on apply base).
3. Apply substitutes `sdd-kit/templates/install-ui-module.sh` in place; runs `gen-manifest-checksums.sh`; runs wave gates including G-MANIFEST.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up candidates after this wave: over-budget whole-file splits; guide G-PT strategy; remaining residual only if new scope appears.

## Open Questions

None blocking propose. Exact EN phrasing for `sob demanda` / `na sessão` may be adjusted at apply as long as G-PT passes and headers match infra-wave-1 / wave-5 forms.
