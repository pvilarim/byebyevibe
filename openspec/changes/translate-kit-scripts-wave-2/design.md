# Design — translate-kit-scripts-wave-2 (verify-infra PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Propose-factory owned-set = union of primary paths in active `openspec/changes/translate-*/` on base **and** open GitHub translate propose PRs (#84, #93–#122), excluding Non-goals bullets.
- Kit-scripts wave-1 (PR #122) owns `sdd-upgrade-diff.sh` hub+template. Markdown kit surfaces, specs, curso 01–04, skills/commands, and many active-change artifacts are already owned. Whole-file over-budget residuals remain: canonical guide (~2848), design `001` hub+template (~593 each), `doc/curso/aula-05-*.md` (~504), `explore-adversarial-sdd-review/research.md` (~460), `add-sdd-discovery-positioning/research.md` (~405), `install-ui-module.sh` hub+template (~604 combined), `sdd-metrics.sh` (~467 each).
- AS-IS: hub `scripts/verify-infra.sh` and kit template `sdd-kit/templates/scripts/verify-infra.sh` are **byte-identical** (~181 LOC each, ~362 combined). Residual Portuguese includes deny-list token `verificação` in the timestamp sed, plus chrome matchers / operator strings (`Última verificação`, `ausente`, `sem .env.example no repo`, `| Variável | Presente | Verificar com |`, `## Regra agentes`) that rewrite hub `openspec/infra.md`.
- Kit template `sdd-kit/templates/openspec/infra.md` is already English (`Last verified`, `Variable | Present | Verify with`, `## Agent rule`). Hub live `openspec/infra.md` remains Portuguese and is owned by `translate-infra-wave-1` (apply soft prerequisite for this wave).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese comments, operator-facing messages, and infra.md chrome matchers/rewrites in both script paths with glossary-canonical English **in-place** (whole-file G-PT / Slice DoD).
- Align matcher strings to the kit EN manifesto labels (same forms as `sdd-kit/templates/openspec/infra.md`).
- Preserve control flow, exit codes, HTML comment marker **names**, env var **names**, and hub↔template identity.
- Regenerate `sdd-kit/MANIFEST.yaml` checksums after the template edit (G-MANIFEST).
- Pass `bash scripts/verify-i18n-wave.sh --files scripts/verify-infra.sh,sdd-kit/templates/scripts/verify-infra.sh`.

**Non-Goals:**

- Editing `openspec/infra.md` (owned by `translate-infra-wave-1`).
- Translating `install-ui-module.sh`, `sdd-metrics.sh`, `upgrade.sh`, or `bootstrap-sdd.sh` in this wave.
- Canonical guide / design `001` / aula-05 / over-budget research files.
- Rewriting `openspec/changes/archive/`.
- Dual-file `*.en.md` / `*-pt.md` (or `*.en.sh` siblings).
- Global G-DoD (`--dod`).
- Changing which checks run or how ✅/❌ is computed — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; kit templates in-scope; G-MANIFEST when `sdd-kit/templates/` touched
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory §4.1; parallel disjoint proposes; apply soft gates
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- AS-IS: `scripts/verify-infra.sh`, `sdd-kit/templates/scripts/verify-infra.sh`, `sdd-kit/MANIFEST.yaml` entry (`merge: MERGE` / path `scripts/verify-infra.sh`)
- EN chrome reference: `sdd-kit/templates/openspec/infra.md`
- Hub PT chrome owner: `openspec/changes/translate-infra-wave-1/proposal.md`
- `scripts/verify-i18n-wave.sh` (confirmed G-PT fail on both paths via `verificação`)
- Open translate PR path lists #84 / #93–#122 (no primary ownership of these two scripts; #122 Non-goals deferred verify-infra)
- Graphify / GitNexus — SKIP / docs+shell operator strings; no application symbol rename
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = verify-infra hub + kit template (2 files, ~362 LOC)

| Option | Verdict |
|--------|---------|
| A — Guide mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — design `001` / aula-05 / over-budget research | Rejected — over ≤350–400 LOC |
| C — `install-ui-module.sh` hub+template | Rejected — ~604 LOC combined; single-file would drift MANIFEST mirrors |
| D — `sdd-metrics.sh` hub+template | Rejected — ~467 LOC each (over budget); weak deny-list hits today |
| E — EN gate/glossary quotes in existing `translate-*` artifacts | Rejected — not substantive residual-PT slices (stubs exhausted by #119–#121) |
| F — `verify-infra.sh` hub+template (~362) | **Chosen** — within budget; substantive residual PT + chrome coupling documented; path-disjoint from infra-wave-1; kit checksum path clear |

**Rationale:** Fits ≤4 files / ≤350–400 LOC; continues kit-scripts series after wave-1; whole-file G-PT completable; soft apply-after infra keeps runtime chrome consistent.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese strings at the same paths. Forbidden: parallel `*.en.sh`, `*-pt.sh`, or language-suffixed siblings.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Soft apply-after `translate-infra-wave-1`

**Chosen:** Propose may land in parallel (disjoint paths). Apply SHOULD run after hub `openspec/infra.md` uses EN chrome (`Last verified`, env table, `## Agent rule`), otherwise timestamp/env-table rewrites stop matching until infra apply.

**Rationale:** Script matchers today are PT because hub infra.md is PT. Kit EN manifesto is the target contract. Document in Session Handoff; do not expand this wave’s file list to own `openspec/infra.md`.

### D4: Chrome vocabulary = kit EN manifesto forms

**Chosen:** Use the exact English labels already present in `sdd-kit/templates/openspec/infra.md` (`Last verified:`, `| Variable | Present | Verify with |`, `## Agent rule`). Do not invent synonyms (`Last verification`, `Agent rules`, etc.).

**Rationale:** G-GLOSS / consistency with W2b kit infra EN; avoids matcher drift across consumer installs that already ship the kit template.

### D5: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that both listed script paths MUST be English after substitution. Do not invent a new `sdd-verify-infra-i18n` capability.

**Rationale:** Same pattern as prior `translate-*` ADDED slice requirements.

### D6: G-MANIFEST checksum regeneration is part of apply

**Chosen:** After editing `sdd-kit/templates/scripts/verify-infra.sh`, apply MUST run `bash sdd-kit/gen-manifest-checksums.sh` before declaring gates green. Do not hand-edit unrelated MANIFEST fields.

**Rationale:** Kit integrity aborts on sha256 drift; WAVES.md G-MANIFEST is mandatory when templates are touched.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Apply before infra-wave-1 breaks timestamp/env rewrite against PT hub chrome | Soft prerequisite in proposal + Session Handoff; apply agent checks infra chrome first |
| Accidental edit of `openspec/infra.md` in this wave | Explicit non-goal; owned by infra-wave-1 |
| G-MANIFEST fail if checksums skipped | Task + gate require `gen-manifest-checksums.sh` |
| Parallel propose factory races | Owned-set includes open PR primaries; these paths absent as primary on #84/#93–#122 |
| Operators relying on Portuguese `ausente` / PT chrome strings | EN glossary forms; G-SMOKE advisory |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR (artifacts only under `openspec/changes/translate-kit-scripts-wave-2/`).
2. Prefer `/opsx:apply translate-infra-wave-1` first (separate session) so hub infra chrome is EN.
3. Separate `/opsx:apply translate-kit-scripts-wave-2` after propose merge (or when artifacts are on apply base).
4. Apply substitutes both scripts in place; regenerates MANIFEST checksums; runs wave gates.
5. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
6. Follow-up candidates: `install-ui-module.sh` after budget strategy; over-budget whole-file splits; guide G-PT strategy.

## Open Questions

None — soft apply ordering is documented; chrome target forms are anchored to the kit EN manifesto.
