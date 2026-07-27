# Design — translate-kit-scripts-wave-5 (install-ui-module.sh PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Propose-factory owned-set = union of **primary** paths in active `openspec/changes/translate-*/` on base **and** open GitHub translate propose PRs (#84, #93–#125): prefer What Changes / Impact **Files modified** / `--files` gates; exclude Non-goals and freeze-checklist mentions (false ownership).
- Kit-scripts waves 1–4 (PRs #122 / #123 / #124 / #125) own `sdd-upgrade-diff.sh`, `verify-infra.sh`, `bootstrap-sdd.sh` hub+template pairs, and `sdd-kit/upgrade.sh`. Wave-4 explicitly deferred `install-ui-module.sh` hub+template as over combined budget.
- AS-IS: `sdd-kit/install-ui-module.sh` (~302 LOC) is mostly English CLI chrome (`usage`, `--detect` / `--dry-run` / `--apply` / `--yes`, Impeccable prompts) with residual Portuguese concentrated in the embedded `openspec/infra.md` UI Development Module section written by `update_infra_md`: table headers `Componente` / `Estado` / `Verificar com`; cell chrome `sob demanda — ver doc/design/002`; deny-listed `na sessão` on the Figma MCP row.
- Twin: `sdd-kit/templates/install-ui-module.sh` is byte-identical today and listed in `sdd-kit/MANIFEST.yaml` as `source:` for the hub path. Combined hub+template (~604 LOC) exceeds ≤350–400; this wave owns hub only.
- Soft coordination: `translate-infra-wave-1` owns live `openspec/infra.md` EN chrome (`Component` / `Status` / `Verify with`). Apply MUST emit the same header forms from this script so UI-module installs do not reintroduce Portuguese headers.
- `sdd-kit/install-ui-module.sh` is **not** under `sdd-kit/templates/`; G-MANIFEST is N/A for this wave.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese comments and operator-facing / embedded-infra strings in `sdd-kit/install-ui-module.sh` with glossary-canonical English **in-place** (whole-file G-PT / Slice DoD).
- Align embedded UI-module table headers and on-demand / in-session cell wording with infra-wave-1 EN chrome.
- Keep `--detect` / `--dry-run` / `--apply` / `--yes` / stack detection / Impeccable install control flow unchanged.
- Pass `bash scripts/verify-i18n-wave.sh --files sdd-kit/install-ui-module.sh`.

**Non-Goals:**

- Editing `sdd-kit/templates/install-ui-module.sh` (follow-up kit-scripts wave).
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
- `doc/i18n/WAVES.md` — budgets; kit operator scripts in-scope per factory precedent
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- AS-IS: `sdd-kit/install-ui-module.sh` (G-PT currently fails on embedded Figma/`sessão` line)
- Soft chrome alignment: `openspec/changes/translate-infra-wave-1/` (`Component` / `Status` / `Verify with`)
- Prior kit-scripts propose: PR #125 (deferred install-ui-module); PR #122–#124 patterns
- `scripts/verify-i18n-wave.sh`
- Open translate PR primary path lists #84 / #93–#125
- Graphify / GitNexus — SKIP / shell operator strings; no application symbol rename
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = `sdd-kit/install-ui-module.sh` alone (~302 LOC / 1 file)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — design `001` / aula-05 / over-budget research | Rejected — over ≤350–400 LOC |
| C — `install-ui-module.sh` hub+template together | Rejected — ~604 LOC combined |
| D — EN gate/glossary quotes in existing `translate-*` artifacts | Rejected — not substantive residual-PT slices (stubs exhausted by #119–#121) |
| E — Template twin alone first | Rejected — operators run hub path; MANIFEST source sync is a follow-up wave |
| F — `sdd-kit/install-ui-module.sh` alone (~302) | **Chosen** — within budget; substantive residual PT; path-disjoint; deferred by wave-4 |

**Rationale:** Fits ≤4 files / ≤350–400 LOC; continues kit-scripts series; whole-file G-PT completable; matches factory follow-up after #125.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese strings at the same path. Forbidden: parallel `*.en.sh`, `*-pt.sh`, or language-suffixed siblings.

**Rationale:** Normative `sdd-docs-language` / WAVES.md.

### D3: Align embedded infra chrome with infra-wave-1

**Chosen:** Replace `| Componente | Estado | Verificar com |` with `| Component | Status | Verify with |`; replace `sob demanda — ver doc/design/002` with English such as `on demand — see doc/design/002`; replace `` `mcp_get_tools` na sessão `` with `` `mcp_get_tools` in session `` (or equivalent glossary-canonical wording). Do **not** edit live `openspec/infra.md` in this wave.

**Rationale:** Soft coordination avoids reintroducing PT headers after UI-module `--apply`. Live infra body remains owned by infra-wave-1.

### D4: Defer template twin (MANIFEST source)

**Chosen:** Leave `sdd-kit/templates/install-ui-module.sh` for a follow-up propose (`translate-kit-scripts-wave-6` or equivalent). Document temporary hub↔template drift as an accepted risk until that wave. G-MANIFEST stays N/A here.

**Rationale:** Combined LOC over budget; factory precedent allows hub-only when twin pairing would overflow (wave-4 deferred this explicitly).

### D5: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `sdd-kit/install-ui-module.sh` MUST be English after substitution, including embedded infra UI-module table chrome. Do not invent a new capability.

**Rationale:** Same pattern as prior `translate-*` ADDED slice requirements.

### D6: G-MANIFEST N/A

**Chosen:** No `sdd-kit/templates/` edit → skip checksum regeneration.

**Rationale:** WAVES.md G-MANIFEST applies when templates are touched; hub script lives at kit root.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Hub↔template drift until twin wave | Explicit non-goal + follow-up candidate; identical today so drift starts only after this apply |
| Reintroducing PT into infra.md if script stays PT while infra-wave-1 lands EN | This wave emits EN chrome aligned with infra-wave-1 |
| Accidental detect/apply/impeccable behavior change | Tasks forbid control-flow edits; only string/comment language |
| Parallel propose factory races | Owned-set includes open PR primaries; `sdd-kit/install-ui-module.sh` absent as primary on #84/#93–#125 |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR (artifacts only under `openspec/changes/translate-kit-scripts-wave-5/`).
2. Separate `/opsx:apply translate-kit-scripts-wave-5` after propose merge (or when artifacts are on apply base).
3. Apply substitutes `sdd-kit/install-ui-module.sh` in place; runs wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up candidates: `sdd-kit/templates/install-ui-module.sh` (G-MANIFEST); over-budget whole-file splits; guide G-PT strategy.

## Open Questions

None blocking propose. Exact EN phrasing for `sob demanda` / `na sessão` may be adjusted at apply as long as G-PT passes and headers match infra-wave-1 forms.
