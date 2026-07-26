# Design — translate-kit-wave-2 (W2 kit README + AGENTS.* templates)

## Context

- Prerequisite W1c (`translate-agents-rules-wave-1c`) substituted remaining hub Cursor stack rules and is **apply-complete / merged** on `master` (PR #71). Archive of W1c may still be pending — does not block this propose; language work is independent of archive promotion.
- Layer-1 policy `add-english-docs-policy` archived — capability `sdd-docs-language`, glossary, wave inventory, and `scripts/verify-i18n-wave.sh` are live.
- `doc/i18n/WAVES.md` lists W2 as: `sdd-kit/README.md` + kit `AGENTS.*` / infra templates (+ checksums). Full surface exceeds ≤4 files:
  - README (112) + AGENTS.core (121) + commands DOCS_SPECS (13) + commands APP (10) + CLAUDE (22) + infra (114) ≈ **392 LOC / 6 files**.
- **This change (W2):** four-file AGENTS-facing slice = **256 LOC / 4 files** (within ≤350–400 LOC and ≤4 files).
- AS-IS: hub `AGENTS.md` already English (W1); kit `AGENTS.core.md` and command fragments remain Portuguese; `sdd-kit/README.md` is mixed EN/PT. Fresh consumer installs still get PT AGENTS payload.
- `install.sh` injects profile commands between `<!-- SDD_KIT_COMMANDS_START -->` / `<!-- SDD_KIT_COMMANDS_END -->` from `AGENTS.commands.<PROFILE>.md` — markers MUST stay byte-stable.
- Touching `sdd-kit/templates/` requires `bash sdd-kit/gen-manifest-checksums.sh` (G-MANIFEST / kit integrity).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in the four W2 files with glossary-canonical English **in-place**.
- Preserve freeze-list tokens, HTML command markers, profile/scenario codes, and fenced shell commands.
- Update MANIFEST checksums after template edits; pass `verify-i18n-wave.sh` including **G-MANIFEST**.
- Align kit AGENTS payload language with hub W1 English so C1 installs are EN by default.

**Non-Goals:**

- `sdd-kit/templates/CLAUDE.md`, `sdd-kit/templates/openspec/infra.md` (→ `translate-kit-wave-2b`).
- Kit `.cursor/rules/*.mdc` copies, `_template/proposal.md`, kit `doc/design/*`.
- Rewriting live hub `AGENTS.md` / `CLAUDE.md` / `openspec/infra.md` (already migrated or separate).
- Guide, skills, evaluations, course, dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Semantic changes to install/upgrade/verify scripts — language only.
- Path renames; changing MANIFEST `gate:` strings beyond checksum regeneration.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — wave budgets, W2 order, G-MANIFEST
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, freeze list
- `openspec/changes/translate-agents-rules-wave-1c/` — budget-split precedent
- `openspec/changes/translate-kit-wave-2/knowledge.md` — researcher summary
- `openspec/infra.md` — R10; assume ✅ (no reinstall)
- AS-IS targets: `sdd-kit/README.md`, `templates/AGENTS.core.md`, `templates/AGENTS.commands.*.md`
- `sdd-kit/install.sh` — commands injection between HTML markers
- `scripts/verify-i18n-wave.sh` — gates including G-MANIFEST → `sdd-kit/verify.sh`
- Graphify `GRAPH_REPORT.md` — unavailable (`[NEEDS VERIFICATION]` / SKIP)
- GitNexus MCP — unavailable (`[NEEDS VERIFICATION]` / SKIP); blast radius is docs/templates only

## Decisions

### D1: Scope = README + AGENTS.* (4 files); defer CLAUDE + infra

| Option | Verdict |
|--------|---------|
| A — All six kit files in one wave | Rejected — exceeds ≤4-file budget |
| B — README + AGENTS.core + both `AGENTS.commands.*` | **Chosen** — 4 files, 256 LOC; keeps install injection surface coherent |
| C — README + AGENTS.core + CLAUDE + infra | Rejected — splits commands from core; commands stay PT for C1 |

**Rationale:** Normative wave budgets; AGENTS commands are injected into core — must migrate together. Follow-up change-id: `translate-kit-wave-2b`.

### D2: In-place substitution — no dual-file

**Chosen:** Replace PT prose at the same paths. Forbidden: `*.en.md`, `*-pt.md` siblings.

**Rationale:** `sdd-docs-language` dual-file prohibition; install copies these exact sources.

### D3: Freeze HTML markers and install placeholders carefully

**Chosen:** Keep `<!-- SDD_KIT_COMMANDS_START -->` / `<!-- SDD_KIT_COMMANDS_END -->` byte-identical. Translate Portuguese `[PREENCHER:…]` filler text to English `[FILL:…]` (same bracket convention) so G-PT passes without changing marker-driven AWK injection.

**Rationale:** Markers are code identifiers (freeze list). Placeholder prose is agent-facing and subject to G-PT.

### D4: Align AGENTS.core section headings with hub W1 English

**Chosen:** Prefer the same English section titles already used in hub `AGENTS.md` (e.g. Project context, Knowledge sources, Universal rules, Communication) where the template mirrors that structure — glossary-canonical, no synonym drift.

**Rationale:** G-GLOSS + consumer familiarity with hub W1 wording; template is the install source for `AGENTS.md`.

### D5: G-MANIFEST is mandatory apply work, not a fifth “content” file

**Chosen:** After editing any `sdd-kit/templates/` file, run `bash sdd-kit/gen-manifest-checksums.sh`. Count mechanical `MANIFEST.yaml` checksum updates outside the ≤4 LOC-substitution budget (no prose rewrite of MANIFEST). `--files` list for verify remains the four content paths; G-MANIFEST triggers from templates in that list.

**Rationale:** Kit integrity (D3 / install abort on sha mismatch); wave budget measures substituted prose, not checksum bytes.

### D6: Spec delta = lasting W2 kit AGENTS/README EN requirement

**Chosen:** ADDED requirement under `sdd-docs-language` that these four kit paths MUST be English. Avoid encoding “wave-2” as permanent numbered clutter beyond acceptance scenarios.

**Rationale:** Same pattern as W1 / W1b / W1c; wave IDs live in change-id / `WAVES.md`.

### D7: README — finish mixed EN/PT; keep scenario table codes

**Chosen:** Translate remaining Portuguese sections (scenarios table, quick commands prose, structure, CI gate, review skills, hub vs consumer) to English. Keep ByeByeVibe branding, scenario codes, and fenced bash blocks byte-stable.

**Rationale:** README is already partially EN; complete slice DoD without rewriting executable fences.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Broken AGENTS commands injection | Tasks freeze markers; gate greps for both HTML comments |
| Stale MANIFEST checksums | Explicit checksum task + G-MANIFEST via `verify-i18n-wave.sh` |
| G-PT false positives (codes resembling PT) | Keep codes/paths in backticks/fences; allowlist per glossary |
| Hub AGENTS already EN vs template drift until apply | Apply soon after propose; Session Handoff |
| Operators expect infra/CLAUDE in same W2 | Explicit deferral to wave-2b in proposal/design/tasks |
| `wc -l AGENTS.md ≤ 150` MANIFEST gate | Keep translated core ≤150 lines (currently 121) |

## Migration Plan

1. Apply: rewrite four files EN in-place; translate `[PREENCHER]` → `[FILL]`; freeze markers/fences.
2. Checksums: `bash sdd-kit/gen-manifest-checksums.sh`.
3. Gate: `bash scripts/verify-i18n-wave.sh --files sdd-kit/README.md,sdd-kit/templates/AGENTS.core.md,sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md,sdd-kit/templates/AGENTS.commands.APP.md`.
4. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-wave-2 --strict`.
5. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
6. Follow-up propose: `translate-kit-wave-2b` (CLAUDE + infra templates; then kit rules as needed).

**Rollback:** `git checkout -- sdd-kit/README.md sdd-kit/templates/AGENTS.core.md sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md sdd-kit/templates/AGENTS.commands.APP.md sdd-kit/MANIFEST.yaml` (content-only; no path moves).

## Open Questions

- None blocking propose. W1c archive pending is noted; not a blocker for W2 apply. Wave-2b scope confirmed as CLAUDE + infra (± later kit rules).
