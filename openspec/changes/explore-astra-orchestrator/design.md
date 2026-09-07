## Context

`research.md` (2026-09-05, Type E) mapped the operator upload `BYEBYEVIBE_ASTRA_ORCHESTRATION_PLAN` onto the existing control plane. Verdict to preserve:

- ByeByeVibe **already is** the control plane.
- **Orchestrator** = whoever sits in **this** phase chair (`/opsx:explore` | `propose` | `apply` | `archive`), not a new process.
- Plan §8–§21 (ChangeState, PolicyEngine, events, one process explore→archive) **competes** with `tasks.md` and is forbidden by `openspec/project.md` Non-goals (Deer Workflow, LifeOS, G6).
- Viable **today** with current Cursor models (Grok 4.6, Composer, Claude, GPT-5.x, Gemini). Graphify/GitNexus gaps on a cold VM are **environment**, not missing IQ.
- Full explore→archive autonomy in one process stays **forbidden** (handoff + R7), even with a stronger model.
- Official GPT-6 / Astra product capabilities: `[NEEDS VERIFICATION]` — this change does not wait for a launch.

This propose is the smallest registration of that verdict (spikes S1 + S2 only). Schema is spec-driven, so the contract is a naming delta — not a runtime capability.

**AS-IS anchors:** `openspec/project.md` Non-goals; `openspec/specs/sdd-session-handoff`; `openspec/specs/sdd-session-coordination`; `openspec/specs/sdd-ci-gates`; guide §3.4 / §5.5; `doc/avaliacoes/` (Deer, LifeOS, Graft, G6); README "without a second orchestration framework". Graphify `GRAPH_REPORT.md` and a GitNexus index were **absent** on this VM (same as the explore) — `[NEEDS VERIFICATION]` for live god nodes / clusters.

## Goals / Non-Goals

**Goals:**

- Index the possibility so future agents do not re-evaluate Deer/G6 under the Astra brand (S1).
- Name the role in the canonical guide so operators and agents share one sentence: orchestrator = agent of this phase (S2).
- Keep phase state in durable artifacts; VALIDATE remains evidence (`openspec validate`, `sdd-gates`), not a chat assertion.

**Non-Goals:**

- Any TypeScript / YAML runtime, `workflow.ts`, PolicyEngine, event bus, or `ChangeState` machine.
- S3 (new VALIDATE phase skill) and S4 (executor report convention / JSON event stub).
- `/opsx:orchestrate`, collapsing `.cursor/rules/015-session-phases.mdc`, or one chat = all phases.
- Waiting for GPT-6 / Astra GA; claiming official product capabilities.
- New `openspec/project.md` Non-goal (Deer already covers code-first pipeline runtimes).
- Edits to `AGENTS.md`, day-1, `/opsx:*` skills, or kit version bump.

## Decisions

### D1 — S1 is an evaluation note, not a new capability

Apply writes `doc/avaliacoes/2026-09-05-astra-orchestrator.md` from `TEMPLATE.md` and adds one index row. The note **points at** `research.md` instead of duplicating §1–§8. Decision line MUST split:

| Slice | State |
|-------|--------|
| New hub runtime (ChangeState / PolicyEngine / events / single-process explore→archive) | **Discarded** (same class as Deer Workflow) |
| Orchestrator role = current-phase `/opsx:*` agent | **Already shipping** (documented here; S2 names it) |
| Official GPT-6 / Astra product facts | **Deferred** / `[NEEDS VERIFICATION]` until official docs |

*Alternatives:* archive-only (no `doc/avaliacoes/` row) — rejected: agents read the index before proposing stack tools (`doc/avaliacoes/README.md`). A new spec capability for one note — rejected: over-weight for index hygiene.

### D2 — S2 is a short §3.4 pointer, not a mega-skill

After the §3.4 pipeline diagram, apply adds a short paragraph (about four sentences): the orchestrator is the agent in **this** phase; the versioned artifact is memory; a human or Cursor Automation is the scheduler between phases; gates are VALIDATE with evidence. Link the S1 note. Sync `sdd-kit/templates/doc/byebyevibe-guide.md` (COPY payload) and run `bash sdd-kit/gen-manifest-checksums.sh`. **Do not** change `version:` / `guide_version:` (stay 1.15.1 until a release cut).

*Alternatives:* day-1 or `AGENTS.md` Integrations — rejected as extra surfaces for one naming sentence. `/opsx:orchestrate` — rejected (research §6.3). Editing only the hub guide and not the template — rejected (C2 would overwrite or drift).

### D3 — Spec delta is ADDED naming only on `sdd-session-handoff`

No new capability. Existing "one session = one phase" and "artifacts are session memory" stay unchanged. The ADDED requirement makes the **name** of the role normative in the guide so a later edit cannot quietly reintroduce a second program counter.

*Alternatives:* MODIFIED on the pipeline-documentation requirement — rejected: that requirement is about handoff markers, not role naming. New `sdd-astra-orchestrator` capability — rejected: invents a runtime-shaped home.

### D4 — Cabe / não cabe stays documentary

Apply MUST restate in the evaluation note (not as code):

| Fits today | Does not fit |
|------------|--------------|
| Model = tech lead of **this** phase | TypeScript runtime owning phase state |
| Versioned artifact = memory | `workflow.ts` / chat as source of truth |
| Human or Cursor Automation = scheduler | One chat = all phases |
| Gates = VALIDATE with evidence | "Done" without evidence |

### D5 — Neighbors stay out of this change

Issue #349 is VALIDATE-adjacent PR review, not an orchestrator. Draft PR #383 is a host-layer harness. Do not fold either into S1/S2.

## Risks / Trade-offs

- **[Risk] Guide checksum / C2 drift** → Mitigation: edit hub guide and kit template together; regenerate only the guide sha256; no version bump.
- **[Risk] Agents treat S1 as permission to build a runtime** → Mitigation: Discarded line is the first table row; Non-goals bind apply; spec scenario forbids a second program counter.
- **[Risk] Dual PR with #384** → Mitigation: this change **keeps** `research.md`; merging this PR supersedes the research-only draft or they share the same file.
- **[Trade-off] No Graphify/GitNexus live blast radius** → Same environment gap as the explore; file-level radius is docs + one spec. Re-check on a machine with an index before any future runtime proposal (which this change forbids anyway).

## Migration Plan

1. Apply S1 (note + index), then S2 (guide + template + checksums), then validate.
2. Rollback: delete the note, revert the index row and guide/template/checksum bytes.
3. No consumer runtime migration.

## Open Questions

- Official Astra / GPT-6 name, API, GA, Cursor default — `[NEEDS VERIFICATION]` (research §7). Not a blocker.
- Whether #349 should later own a VALIDATE spike (S3) — product choice; **out of this change**.
- Live Graphify god nodes / GitNexus clusters — `[NEEDS VERIFICATION]` on a built index.
