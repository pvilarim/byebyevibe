**Issue:** —

## Why

The Type E explore already judged the Astra orchestration plan as a **possibility**, not a runtime to build. Without an evaluation index row and a short guide name for the role, later agents will re-open Deer Workflow / G6 / LifeOS under a new brand ("Astra orchestrator") or wait for GPT-6. This propose records that verdict so the next apply can write the note and the pointer — nothing else.

## What Changes

- **S1 — Evaluation note:** add `doc/avaliacoes/2026-09-05-astra-orchestrator.md` (TEMPLATE shape) plus an index row in `doc/avaliacoes/README.md`, pointing at `openspec/changes/explore-astra-orchestrator/research.md`. Decision: **Discarded** as a new hub runtime; the orchestrator **role already ships** as the agent in the current `/opsx:*` chair; official GPT-6 / Astra product claims stay `[NEEDS VERIFICATION]` / **Deferred**.
- **S2 — Protocol pointer:** add a short paragraph in `doc/byebyevibe-guide.md` §3.4 (and the kit template copy) naming **orchestrator = agent of this phase**. Sync `sdd-kit/templates/doc/byebyevibe-guide.md` and regenerate MANIFEST checksums. **Do not** bump kit/`guide_version` in this change.
- Preserve the explore conclusions in `research.md` (do not rewrite the verdict).
- Spec delta only on `sdd-session-handoff` (naming). **No** new capability. **No** runtime.

**Out of scope (binding):** S3 VALIDATE checklist skill; S4 executor report / event bus; TypeScript `ChangeState` / `PolicyEngine`; `/opsx:orchestrate`; one chat = all phases; Deer Workflow, LifeOS, G6, TencentDB, Graft reopen; waiting for GPT-6 / Astra GA; autonomy explore→archive in one process.

## Capabilities

### New Capabilities

—

### Modified Capabilities

- `sdd-session-handoff`: ADDED requirement that the SDD guide names the orchestrator as the agent sitting in the current phase chair (`/opsx:explore` | `propose` | `apply` | `archive`), not as a separate runtime or a process that spans phases.

## Impact

- **Apply will add:** `doc/avaliacoes/2026-09-05-astra-orchestrator.md`; one row in `doc/avaliacoes/README.md`
- **Apply will edit:** `doc/byebyevibe-guide.md` §3.4 (short pointer); `sdd-kit/templates/doc/byebyevibe-guide.md` (same bytes); `sdd-kit/MANIFEST.yaml` sha256 for the guide only
- **Apply will add delta:** `openspec/specs/sdd-session-handoff/spec.md` (archive-time)
- **Not modified:** `openspec/project.md` (Deer non-goal already forbids a code-first phase runtime); `AGENTS.md`; day-1 doc; `/opsx:*` skills; session scripts; CI workflows; any TypeScript
- **Neighbors (do not duplicate):** issue [#349](https://github.com/pvilarim/byebyevibe/issues/349) (automated PR review); draft [PR #383](https://github.com/pvilarim/byebyevibe/pull/383) (Pi harness); explore [PR #384](https://github.com/pvilarim/byebyevibe/pull/384) (this change's research)
- **Pilot:** waived (docs-only; no new binary, hook, or service)
- **Sources:** `research.md` (this change); `openspec/project.md` Non-goals; `openspec/infra.md`; specs `sdd-session-handoff`, `sdd-session-coordination`, `sdd-ci-gates`; `doc/byebyevibe-guide.md` §3–§4 / §5.5; evaluations Deer / LifeOS / G6
