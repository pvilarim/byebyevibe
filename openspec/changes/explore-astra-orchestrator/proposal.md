# Proposal — possibility: Astra-class orchestrator on the ByeByeVibe protocol

> **Status:** exploratory possibility (Type E capture). **Not** a commitment to implement a runtime, skill, or kit payload.
> **Issue:** —
> **Feeds:** optional later `/opsx:propose` — pick **one** spike from `research.md` §6.3 (S1–S4). Do not apply product code from this change.

## Why this exists

Pedro asked to **register research** on whether an orchestrator agent (plan name: Astra) can command ByeByeVibe, and whether that can happen with models already in Cursor — without waiting for GPT-6 public launch.

The research (`research.md`) crystallized a scoped possibility: **yes as a role on the existing protocol; no as a new orchestration runtime.** This proposal records that framing so a future propose session does not restart from zero or reopen discarded runtimes under a new brand.

## What we are considering (possibility)

Treat a strong current Cursor model (Composer, Grok, Claude, GPT-5.x, Gemini, or a future Astra-class model) as:

```
principal agent  =  orchestrator of THIS phase only
ByeByeVibe       =  protocol, artifacts, gates, locks
Graphify         =  "what is related?"
GitNexus         =  "what will break?"
executor         =  same or later run, scoped to tasks.md
human/Automation =  outer scheduler (Session Handoff)
```

## What we are not considering

- A code-first `ChangeState` / PolicyEngine / event bus in this hub (`openspec/project.md` Non-goals; Deer Workflow discarded)
- Collapsing `explore → propose → apply → archive` into one chat or one Cloud Agent run (`sdd-session-handoff`)
- A second constitution, inferred cross-session memory, or a third graph (LifeOS / TencentDB / Graft)
- A G6-style orchestration UI (Vibe Kanban discarded)
- Claiming GPT-6 / Astra product capabilities before official docs (plan §20.1; `[NEEDS VERIFICATION]`)

## Scope if a later propose is opened

**In scope (pick one spike — see research §6.3):**

- **S1 (smallest):** `doc/avaliacoes/` evaluation + index row, decision **Deferred / possibility**
- **S2:** short protocol pointer (guide / day-1 / `AGENTS.md` Integrations) naming the per-phase orchestrator role
- **S3:** tighten VALIDATE-before-archive wording in existing apply/archive skills if a real gap is shown
- **S4:** optional structured executor report convention (still artifact-backed)

**Out of scope for any first propose:** runtime, new `/opsx:orchestrate` mega-skill, autonomy levels 2–4 as default, kit MANIFEST payload, APP consumer harness.

## Impact

- **Now:** one Type E change directory; no operator workflow change.
- **If S1 only:** agents checking `doc/avaliacoes/` will see Astra mapped onto Deer/G6, not as a greenfield idea.
- **If S2–S4:** docs/skill wording only; kit checksums if templates are touched.

## Recommendation

Keep this change as **explore artifacts**. Open a new chat with `/opsx:propose` only if Pedro wants S1 (index hygiene) or S2 (name the role). Do not wait for GPT-6. Do not start `/opsx:apply` for a runtime.
