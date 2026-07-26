# Design — translate-kit-wave-2b (W2b kit CLAUDE + openspec/infra templates)

## Context

- Prerequisite W2 (`translate-kit-wave-2`) substituted kit README + AGENTS.* templates and is **apply-complete / merged** (PR #73) and **archived** (`openspec/changes/archive/2026-07-26-translate-kit-wave-2/`). Main spec now includes the W2 AGENTS/README English requirement.
- W2 design **D1** deferred `sdd-kit/templates/CLAUDE.md` + `sdd-kit/templates/openspec/infra.md` to this change-id.
- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- AS-IS LOC: CLAUDE template **22** + infra template **114** = **136 LOC / 2 files** (within ≤350–400 LOC and ≤4 files).
- Kit `.cursor/rules/*.mdc` copies: **~8 files / ~151 LOC** — adding any 3+ rules would breach ≤4 files with CLAUDE+infra; coherence favors deferring **all** kit rules to a later wave.
- Hub patterns: hub `CLAUDE.md` is fully English (W1). Hub live `openspec/infra.md` still has residual Portuguese (fails G-PT today) — use it as **structure / marker** pattern only; kit template MUST become G-PT-clean EN, not a copy of hub residual PT.
- Touching `sdd-kit/templates/` requires `bash sdd-kit/gen-manifest-checksums.sh` (G-MANIFEST).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the two W2b files with glossary-canonical English **in-place**.
- Preserve freeze-list tokens, `verify-infra.sh` HTML markers (tag names), pins, and fenced shell commands.
- Update MANIFEST checksums after template edits; pass `verify-i18n-wave.sh` including **G-MANIFEST**.
- Align kit CLAUDE language with hub W1 English so Claude Code lookup entry points install EN by default.

**Non-Goals:**

- Kit `.cursor/rules/*.mdc` copies (→ later kit-rules / WRu wave).
- `_template/proposal.md`, kit `doc/design/*`.
- Rewriting live hub `CLAUDE.md` (already EN) or hub `openspec/infra.md` residual PT (separate change).
- Guide, skills, evaluations, course, dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Semantic changes to `verify-infra.sh` / install/upgrade — language only.
- Path renames; changing MANIFEST `gate:` beyond checksum regeneration.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — wave budgets, W2 order, G-MANIFEST
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, freeze list (+ archived W2 requirement)
- `openspec/changes/archive/2026-07-26-translate-kit-wave-2/` — D1 deferral precedent
- Hub `CLAUDE.md` — EN language pattern for kit CLAUDE
- Hub `openspec/infra.md` — structure + HTML marker pattern (residual PT noted)
- AS-IS targets: `sdd-kit/templates/CLAUDE.md`, `sdd-kit/templates/openspec/infra.md`
- `scripts/verify-i18n-wave.sh`, `sdd-kit/gen-manifest-checksums.sh`
- `openspec/infra.md` — R10; assume ✅ (no reinstall)
- Graphify / GitNexus — SKIP / `[NEEDS VERIFICATION]` (docs/templates only; blast radius is install payloads)

## Decisions

### D1: Scope = CLAUDE + infra templates (2 files); defer kit rules

| Option | Verdict |
|--------|---------|
| A — CLAUDE + infra + as many kit rules as fit ≤4 files | Rejected — arbitrary rule split; remaining rules still need another wave |
| B — CLAUDE + infra only | **Chosen** — 136 LOC / 2 files; matches W2 D1 deferral; leaves clear follow-up for kit rules |
| C — Kit rules only first | Rejected — breaks the named W2b follow-up and leaves Claude/infra PT in C1 installs |

**Rationale:** Normative budgets + coherent deferred slice from W2. Follow-up change-id suggestion: `translate-kit-wave-2c` (or WRu) for kit `.cursor/rules/*.mdc`.

### D2: In-place substitution — no dual-file

**Chosen:** Replace PT prose at the same paths. Forbidden: `*.en.md`, `*-pt.md` siblings.

**Rationale:** `sdd-docs-language` dual-file prohibition; install copies these exact sources.

### D3: Freeze `verify-infra.sh` HTML markers; translate inner filler only

**Chosen:** Keep marker tags byte-identical (`<!-- openspec-version -->` / `<!-- /openspec-version -->`, `<!-- mcp-list -->` / `<!-- /mcp-list -->`, `<!-- env-list -->` / `<!-- /env-list -->`, kit-version/status markers, etc.). Translate Portuguese **inside** marker bodies and surrounding prose (e.g. `outros MCPs` → `other MCPs`; `_(sem .env.example no repo)_` → `_(no .env.example in repo)_`; `[AÇÃO MANUAL]` → `[MANUAL ACTION]`).

**Rationale:** Markers are code identifiers (freeze list). Inner filler is agent-facing and subject to G-PT.

### D4: Hub CLAUDE = language pattern; hub infra = structure only

**Chosen:** Copy EN section titles and wording from hub `CLAUDE.md` where the template mirrors it. For infra, keep hub section order and tables, but **do not** propagate hub residual Portuguese — kit must pass G-PT independently.

**Rationale:** Hub infra still fails G-PT; kit install payload must meet slice DoD without waiting for a hub-infra residual wave.

### D5: G-MANIFEST is mandatory apply work, not a third “content” file

**Chosen:** After editing either template, run `bash sdd-kit/gen-manifest-checksums.sh`. Count mechanical `MANIFEST.yaml` checksum updates outside the ≤4 LOC-substitution budget. `--files` list for verify remains the two content paths; G-MANIFEST triggers from templates in that list.

**Rationale:** Same as W2 D5; kit integrity.

### D6: Spec delta = lasting W2b kit CLAUDE/infra EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that these two kit paths MUST be English. Avoid encoding “wave-2b” as permanent numbered clutter beyond acceptance scenarios.

**Rationale:** Same pattern as W2 / W1 slices.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Broken `verify-infra.sh` marker parsing | Tasks freeze marker tags; gate greps for key open/close comments |
| Stale MANIFEST checksums | Explicit checksum task + G-MANIFEST via `verify-i18n-wave.sh` |
| Operators copy hub infra residual PT into kit | Design D4 + tasks note: kit must be G-PT-clean EN |
| G-PT false positives (codes resembling PT) | Keep codes/paths in backticks/fences; allowlist per glossary |
| Kit rules still PT after W2b | Explicit deferral in proposal/design/tasks; Session Handoff for follow-up |

## Migration Plan

1. Apply: rewrite two files EN in-place; translate marker-body filler; freeze marker tags/fences/pins.
2. Checksums: `bash sdd-kit/gen-manifest-checksums.sh`.
3. Gate: `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/CLAUDE.md,sdd-kit/templates/openspec/infra.md`.
4. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-wave-2b --strict`.
5. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
6. Follow-up propose: kit `.cursor/rules/*.mdc` PT→EN (budget-split as needed).

**Rollback:** `git checkout -- sdd-kit/templates/CLAUDE.md sdd-kit/templates/openspec/infra.md sdd-kit/MANIFEST.yaml` (content-only; no path moves).

## Open Questions

- None blocking propose. Hub infra residual PT is noted as a separate surface; not a blocker for kit template EN.
