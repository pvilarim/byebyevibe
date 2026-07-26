# Design — English docs policy (Layer 1 / Camada 1)

## Context

- Explore `explore-public-release-surface` (2026-07-26) crystallized **EN = canonical default** of the repository; pt-BR in versioned files is legacy to **replace**, not maintain bilingually.
- Decision IDs: **F2** (policy + waves), **F7** (chat MAY pt-BR; artifacts MUST EN). F3 (root CHANGELOG) and path renames remain separate changes.
- AS-IS inventory (order of magnitude): guide ~2847 LOC, mirrored skills ~2922, evaluations ~523, AGENTS/rules ~300, `doc/curso/` large — all unsafe as a single apply session.
- `openspec/project.md` Conventions still say “Português (pt-BR) na comunicação” without distinguishing chat vs versioned artifacts — agents can misread that as permission to write docs in PT.
- No `doc/i18n/` directory or `verify-i18n-wave.sh` exists yet; waves MUST NOT start until gates exist (research principle 4).

## Goals / Non-Goals

**Goals:**

- Normative capability `sdd-docs-language` encoding EN-default, F7, in-place substitution, wave budgets, freeze list, in-scope/out-of-scope surfaces, and DoD (residual PT ≈ 0 in-scope).
- Ship glossary + wave inventory + proposal template so later `translate-*-wave-N` changes are mechanical.
- Ship `scripts/verify-i18n-wave.sh` with gates G-INV, G-GLOSS, G-PT, G-LINK, G-MIRROR, G-MANIFEST, G-OPENSPEC and a global `--dod` / G-DoD mode.
- Minimal pointer updates in `AGENTS.md`, `openspec/project.md`, `openspec/infra.md` (no mass rewrite).

**Non-Goals:**

- Substituting Portuguese prose in the guide, skills, evaluations, or course in this change.
- Root `CHANGELOG.md` (F3 / `add-root-changelog`).
- Renaming PT-named paths (`doc/sistema-sdd-pedro.md`, `doc/avaliacoes/`).
- Rewriting `openspec/changes/archive/**`.
- Dual-file `*.en.md` / `*-pt.md` strategy.
- Making i18n verification a blocking step of `sdd-gates` CI in this change (script is mode C for waves; CI optional later).
- Distributing the script via `sdd-kit` MANIFEST bump (hub-first; kit payload can follow if consumers adopt the same policy).

## Knowledge sources consulted (R8)

- `openspec/changes/explore-public-release-surface/research.md` — Metodologia i18n segura; escopo Camada 1; inventário; gates; F2/F7
- `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` — roadmap discovery (P11/P12) [NEEDS VERIFICATION if section ids drift]
- `openspec/project.md` — Conventions (language line to clarify)
- `AGENTS.md` — Comunicação; R2/R3/R7/R10
- `openspec/infra.md` — R10; assume ✅
- `scripts/verify-task-patterns.sh`, `scripts/verify-infra.sh` — bash gate style
- `openspec/specs/sdd-workspace-manifest/spec.md` — infra registration pattern
- `openspec/specs/sdd-task-patterns/spec.md` — Gate/Pattern for tasks.md

## Decisions

### D1: Two-layer rollout — policy now, waves later

| Option | Verdict |
|--------|---------|
| A — Policy + first wave in one change | Rejected — mega-PR; token overflow; violates “policy before substitute” |
| B — Policy-only change (Camada 1) | **Chosen** |
| C — Soft “prefer EN” without DoD | Rejected — leaves permanent PT |

**Rationale:** research architecture Camada 1 → Camada 2 → G-DoD. This change is Camada 1 only.

### D2: Substitution in-place (not dual-file)

**Chosen:** Option A from research — EN replaces PT at the same path. Dual-file permanent EN/PT is **forbidden**.

**Rationale:** single source of truth for agents and install kit; dual-file doubles maintenance and invites drift between mirrors.

Path names with Portuguese (`sistema-sdd-pedro.md`, `avaliacoes/`) MAY keep the path until a separate rename change; **content** becomes EN in waves.

### D3: F7 — chat language decoupled from repo language

**Chosen:** Human↔agent chat **MAY** be pt-BR; any new/edited versioned artifact after policy **MUST** be EN.

**Rationale:** preserves operator speed without authorizing PT commits. Pointers go in `AGENTS.md` Comunicação and `openspec/project.md` Conventions.

### D4: Wave budget (anti token-overflow)

Normative limits (from research):

| Limit | Value |
|-------|-------|
| LOC substituted per wave | ≤ 350–400 |
| Files touched | ≤ 4 (or 1 logical skill × Cursor + Claude mirrors = 2) |
| Skills | 1 logical skill per wave (both mirrors same wave) |
| Slice DoD | Zero residual PT prose in files touched by the wave |
| Session | 1 apply session; stop + Session Handoff if approaching limit |

### D5: In-scope / out-of-scope surfaces

| Surface | Scope |
|---------|-------|
| Guide, AGENTS, rules, skills, commands, kit templates/READMEs | In |
| `doc/avaliacoes/`, `doc/design/` | In |
| `doc/curso/` | **In by default** (own waves; exception only via human decision in a later propose) |
| `openspec/specs/` | In only for residual PT (majority already EN) |
| Active `openspec/changes/<id>/` still in PT | In (theme wave or active-changes wave) |
| `openspec/changes/archive/` | **Out** — immutable history |
| Quotes, proper names, URLs, freeze-list tokens | Allowlist — not “terms to translate” |

### D6: Freeze list (never “translate”)

Paths/globs, change-ids, slash commands/skills names, shell/CI fences, package pins, code identifiers, MANIFEST keys, stable EN anchors, brand names (ByeByeVibe, OpenSpec, GitNexus, Graphify).

G-INV fails the wave if these change unintentionally.

### D7: Verification script architecture

```bash
bash scripts/verify-i18n-wave.sh [--files f1,f2,...] [--dod] [--help]
```

| Gate | Role |
|------|------|
| G-INV | Freeze tokens present / not rewritten in touched files (heuristic + denylist of “translated” command forms) |
| G-GLOSS | Terms used match `doc/i18n/GLOSSARY.md` canonical EN forms (spot-check / key phrases) |
| G-PT | Deny-list of common PT prose tokens in wave files (allowlist for proper nouns / cited PT) |
| G-LINK | Relative markdown links resolve for touched files |
| G-MIRROR | If a `.cursor/skills|commands` path is in `--files`, matching `.claude/` twin must be listed and content-equivalent (or both absent) |
| G-MANIFEST | If any `sdd-kit/templates/` path touched → `sha256` fields present and `bash sdd-kit/verify.sh` does not fail integrity for those entries (or checksum script dry-check) |
| G-OPENSPEC | `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict` |
| G-DoD (`--dod`) | Scan all in-scope globs from `WAVES.md` for residual PT; fail-closed |

**Implementation notes (apply):**

- Bash + standard Unix tools only (parity with `verify-task-patterns.sh`); no network.
- G-PT / G-DoD use a curated deny-list of high-signal PT tokens (e.g. common function words and SDD vocabulary still in PT) — false positives documented; allowlist file or section in GLOSSARY for exceptions.
- G-SMOKE (human marks 3 critical procedures executable from EN text) is **advisory** for waves — not automated in the script in Camada 1; document in WAVES.md / WAVE-PROPOSAL-TEMPLATE.
- Exit 0 = all requested gates pass; non-zero = fail-closed for the wave.

**Alternative rejected:** LLM-as-judge in CI — non-deterministic, violates R3.

### D8: Artifact layout under `doc/i18n/`

| File | Purpose |
|------|---------|
| `GLOSSARY.md` | pt-BR (legacy) → EN canonical; expandable; seed from research |
| `WAVES.md` | Inventory LOC, suggested order W0…WDoD, in-scope table, how to run gates |
| `WAVE-PROPOSAL-TEMPLATE.md` | Copy-paste skeleton for `translate-<surface>-wave-N` proposals |

### D9: Pointers only in AGENTS / project / infra — not guide rewrite

Updating the entire guide Comunicação section is a later wave. This change adds **short** EN-capable pointers (≤ ~15 lines each file) so agents discover the policy immediately after archive.

### D10: Spec language and this change’s own artifacts

Capability specs remain English (existing hub convention). Proposal/design/tasks for **this** change are written in English to instantiate the policy being adopted. Historical explore research stays PT (archive/explore surface — not rewritten here).

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT false positives (brand, quotes, code comments) | Allowlist in GLOSSARY / WAVES; human override documented per wave |
| G-INV too weak (LLM rewrites a fence subtly) | Review checklist in WAVE-PROPOSAL-TEMPLATE; freeze examples in GLOSSARY |
| Agents start translating before policy archive | Explicit non-goal + WAVES.md “W0 first”; propose skills remain phase-separated |
| DoD ≈ 0 never reached if curso deferred | Curso is in-scope by default; exception requires human decision recorded in a change |
| Script scope creep into CI | Non-goal: not blocking in `sdd-gates` this change |
| Glossary drift across waves | G-GLOSS; expand glossary **in the same wave** that introduces a new term |
| Mega-wave temptation | Hard budgets in spec + template |

## Migration Plan

1. Apply this change (Camada 1) → archive → promote `sdd-docs-language` spec.
2. Subsequent chats: `/opsx:propose translate-…` per `WAVES.md` order (W1 AGENTS/project/rules → kit → guide sections → skills → evaluations → curso → active changes → G-DoD).
3. Rollback of policy: revert the change commit(s); no data migration. Rollback of a future wave: git revert that wave’s PR (optional pre-wave tag — research option C).

## Open Questions

- Exact PT deny-list tokens for G-PT/G-DoD — finalize at apply from research seed + sample scan of `doc/sistema-sdd-pedro.md` (document list in script or `doc/i18n/`).
- Whether to add `verify-i18n-wave.sh` to `sdd-kit` in a follow-up (out of scope here).
- Optional later: advisory CI job (report-only) for G-DoD — separate change if desired.
