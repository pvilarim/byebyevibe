# Design — translate-agents-rules-wave-1 (W1 agent entry points)

## Context

- Prerequisite `add-english-docs-policy` archived as `openspec/changes/archive/2026-07-26-add-english-docs-policy/` — capability `sdd-docs-language`, glossary, wave inventory, and `scripts/verify-i18n-wave.sh` are live.
- `doc/i18n/WAVES.md` lists W1 as: `AGENTS.md` + `openspec/project.md` + `CLAUDE.md` + rules prose (`.mdc`).
- **LOC inventory (2026-07-26):** `AGENTS.md` 189 + `openspec/project.md` 72 + `CLAUDE.md` 22 = **283 LOC / 3 files** (within ≤350–400 LOC and ≤4 files). `.cursor/rules/*.mdc` = **8 files / ~151 LOC** — exceeds the ≤4-file budget; must not ship in this wave.
- AS-IS: entry points are mostly Portuguese prose; F7 English pointers already exist in `AGENTS.md` Comunicação and `openspec/project.md` Conventions (from policy Layer 1). Stack/tool names and command tables are largely EN already.
- No `.claude/rules/` mirror exists — rules are Cursor-only `.mdc` files (G-MIRROR N/A for this wave and for wave-1b rules).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `AGENTS.md`, `openspec/project.md`, and `CLAUDE.md` with glossary-canonical English **in-place**.
- Preserve freeze-list tokens, shell/CI fences, paths, change-ids, `/opsx:*`, pins, and brand names.
- Keep F7 explicit (chat MAY pt-BR; versioned artifacts MUST EN).
- Pass `bash scripts/verify-i18n-wave.sh --files AGENTS.md,openspec/project.md,CLAUDE.md`.
- Document follow-up `translate-agents-rules-wave-1b` for `.cursor/rules/*.mdc`.

**Non-Goals:**

- Guide (`doc/sistema-sdd-pedro.md`), skills, evaluations, course, `sdd-kit/templates/`, active/archived OpenSpec change bodies.
- Path renames; dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Translating `.cursor/rules/*.mdc` in this change (budget split → wave-1b).
- Semantic changes to R1–R11, task protocol, or infra assumptions — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — W1 order, budgets, gates
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves, F7, freeze list
- `openspec/changes/archive/2026-07-26-add-english-docs-policy/` — Layer 1 precedent
- `openspec/infra.md` — R10; assume ✅ (no reinstall)
- `AGENTS.md`, `openspec/project.md`, `CLAUDE.md` — AS-IS surfaces
- `scripts/verify-i18n-wave.sh` — gate commands and PT deny-list

## Decisions

### D1: Scope = three entry-point files only (budget-safe W1 slice)

| Option | Verdict |
|--------|---------|
| A — All of WAVES.md W1 including 8 rules in one change | Rejected — 11 files, ~434 LOC; violates ≤4 files |
| B — Entry points only (`AGENTS.md`, `project.md`, `CLAUDE.md`) | **Chosen** — 3 files, ~283 LOC |
| C — Rename change-id to `wave-1a` and leave `wave-1` empty | Rejected — operator requested `translate-agents-rules-wave-1`; document deferral of rules to `wave-1b` instead |

**Rationale:** Normative wave budgets in `sdd-docs-language` / `WAVES.md`. Rules need their own propose (≤4 `.mdc` files per wave).

### D2: In-place substitution — no dual-file

**Chosen:** Replace PT prose at the same path. Forbidden: `AGENTS.en.md`, `*-pt.md` siblings.

**Rationale:** Existing `sdd-docs-language` requirement; single source of truth for agents.

### D3: Glossary-canonical vocabulary; expand only if needed

**Chosen:** Use `GLOSSARY.md` forms (`change`, `propose`/`proposal`, `apply`, `explore`, `archive`, `gate`, `skill`, `Session Handoff`, `worktree`, `install kit`, `canonical guide`, `fail-closed`/`fail-open`, `wave`, DoD). Add rows in the same wave only when a new SDD term appears.

**Rationale:** Prevent synonym drift across waves (G-GLOSS).

### D4: Preserve F7 and Portuguese chat instruction for Pedro

**Chosen:** Keep (in English) the rule that replies to Pedro MAY use pt-BR in chat, while commits/artifacts MUST be EN. Do not remove the operator-speed affordance.

**Rationale:** F7 in `sdd-docs-language`; removing it would be a behavior change, not translation.

### D5: Freeze-list discipline during rewrite

**Chosen:** Do not “translate” paths (`doc/sistema-sdd-pedro.md`, `doc/avaliacoes/`), change-ids, `/opsx:*`, fenced shell commands, package pins, MANIFEST keys, or brands (ByeByeVibe, OpenSpec, GitNexus, Graphify, Probity, Impeccable).

**Rationale:** G-INV; install and agent discovery depend on byte-stable tokens.

### D6: Spec delta = lasting entry-point EN requirement (not wave-numbered clutter)

**Chosen:** ADDED requirement under `sdd-docs-language` that these three files MUST be English and retain F7. Avoid encoding “wave-1” as a permanent numbered milestone in the main spec beyond the requirement text needed for acceptance.

**Rationale:** Archive promotes deltas; wave IDs belong in `WAVES.md` / change-id, not as infinite ADDED requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT false positives (quoted PT, path segments) | Allowlist per `GLOSSARY.md`; document exceptions in apply notes if needed |
| Accidental rewrite of `/opsx:*` or fences | G-INV; tasks call out freeze checklist; prefer section-by-section edits |
| Semantic drift in R1–R11 during translation | Translate meaning faithfully; no reordering/renumbering of rules |
| CLAUDE.md version pin drift (`v1.2` vs guide `v1.6.1`) | Out of scope for i18n — leave version string as-is unless already wrong and trivial; do not expand scope |
| Rules left in PT after W1 | Explicit non-goal + Session Handoff to propose `translate-agents-rules-wave-1b` |

## Migration Plan

1. Apply: rewrite the three files EN in-place (tasks.md).
2. Gate: `bash scripts/verify-i18n-wave.sh --files AGENTS.md,openspec/project.md,CLAUDE.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-agents-rules-wave-1 --strict`.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up propose: `translate-agents-rules-wave-1b` for ≤4 rule files per slice.

**Rollback:** `git checkout -- AGENTS.md openspec/project.md CLAUDE.md` (content-only; no path moves).

## Open Questions

- None blocking propose. Wave-1b file grouping (which ≤4 rules first) deferred to that propose.
