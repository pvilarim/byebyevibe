## Context

Translation waves (`translate-*-wave-N`) are intentionally small (≤4 files / ≤350–400 LOC). That creates a long propose→apply→archive queue. Cursor Cloud Agents and Automations can run many of those sessions without a local IDE session, but the SDD rules (one phase per chat, Session Handoff, R7 human approval before apply, wave budgets) still apply.

Sources: `doc/i18n/WAVES.md`, `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`, `.cursor/rules/015-session-phases.mdc`, `doc/sistema-sdd-pedro.md` §3.3, Cursor docs for Automations / Cloud Agents (product URLs in the guide).

## Goals / Non-Goals

**Goals:**
- Give operators a single English playbook at a stable path Automations can read
- Clarify merge vs propose parallelism (manual merge is **not** a blocker for generating disjoint proposes)
- Provide copy-paste Automation prompts and Session Handoff stubs for propose-factory and apply-on-merge patterns

**Non-Goals:**
- Building a custom orchestrator script in-repo
- Auto-merge bots or bypassing human PR review
- Changing i18n budgets or gate scripts
- Pinning Cursor product UI beyond “read current docs if UI drifts”

## Decisions

### D1 — Guide lives under `doc/i18n/CURSOR-AUTOMATIONS.md`

**Chosen:** Same folder as WAVES / GLOSSARY / template so i18n operators find it; Automations prompt: `Read and follow doc/i18n/CURSOR-AUTOMATIONS.md`.

**Alternatives:** Guide-only section in `doc/sistema-sdd-pedro.md` (too heavy; guide is still largely PT / next waves); kit template only (hub operators need it before kit install).

### D2 — Document three launch modes, not one mega-pipeline

**Chosen:** (1) Parallel Cloud Agents for disjoint **proposes**, (2) Cursor Automation “propose factory” (one wave per run), (3) Automation or chained agent for **apply** after propose PR is approved/merged. Explicitly forbid propose+apply in one Automation run unless the run only emits a Session Handoff for apply.

**Rationale:** Matches `015-session-phases` and R7.

### D3 — Manual merge semantics

**Chosen:** State clearly:
- **Propose of disjoint waves:** no merge dependency — open many propose PRs in parallel.
- **Apply of a wave:** needs that wave’s propose merged (or equivalent approved artifacts on the base branch the apply agent uses).
- **Dependent apply** (e.g. W2d after W2c): needs prior apply(+archive) complete; manual merge is a **throughput** bottleneck, not a **propose** blocker.
- Optional later: GitHub auto-merge / queue — out of scope; document as operator choice.

### D4 — Spec delta vs new capability

**Chosen:** ADDED requirement on existing `sdd-docs-language` (inventory artifact), not a new capability.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Cursor Automations UI/triggers change | Guide cites product URLs; local SDD constraints are normative |
| Automation runs propose+apply in one shot | Prompt MUST say one phase only; stop with Session Handoff |
| Parallel proposes touch same files | Inventory slices must be disjoint; factory does one wave per run |
| Apply before propose merge → conflict/missing change | Apply prompt checks `openspec/changes/<id>/` exists on base |
| Guide in EN only (F7) | Chat MAY stay pt-BR; versioned guide MUST be EN |

## Migration Plan

1. Land guide + WAVES pointer + spec delta via this change’s apply
2. Operators paste Automation prompts from the guide at cursor.com/automations
3. No rollback beyond reverting the three files; no runtime dependency

## Open Questions

- Whether hub adopts GitHub auto-merge for `docs(sdd): propose translate-*` only — deferred to a future change if desired
- Whether a webhook from `sdd-gates` green should trigger apply Automation — optional pattern documented, not enabled by this change
