# Day-1 operator guide — ByeByeVibe control plane

Short tutorial for the first operating day after C1 install. Source of truth narrated by `/opsx:help`. Artifacts are English (F7); chat may follow `chat_language`.

Canonical install guide (depth): [`doc/byebyevibe-guide.md`](./byebyevibe-guide.md).

---

## 0. Layers: OpenSpec ⊂ ByeByeVibe · Onboard vs Help

ByeByeVibe **composes** OpenSpec; it does not replace it. OpenSpec owns the change schema (`proposal` → `specs` → `design` → `tasks`) and upstream workflows. ByeByeVibe adds the control plane: Graphify, GitNexus, Session Handoff, kit skills, gates, and this day-1 map.

**Install scope:** the CLIs (OpenSpec, GitNexus, Graphify) install **once per machine** and every project reuses them. Each project receives its own payload copy plus its own generated state (`openspec/`, `graphify-out/`, `.gitnexus/`). One command from the hub clone installs into any new project folder — full scope model in guide [§1.6](./byebyevibe-guide.md).

| Command | Origin | Role |
|---------|--------|------|
| `/opsx:help` | ByeByeVibe / sdd-kit | Map this control plane (files, phases, confidence, handoff) |
| `/opsx:onboard` | Upstream OpenSpec | Learn-by-doing a full change cycle |

Both are **first-class**. Suggested order: **help first** (this map), then **onboard** (practice). Help MUST NOT hide, replace, or fork onboard.

---

## 1. Memory over chat

Chat is ephemeral. Durable memory lives in the repo:

- Active work: [`openspec/changes/<id>/`](../openspec/changes/)
- Agreed behavior: [`openspec/specs/`](../openspec/specs/)
- Closed work: [`openspec/changes/archive/`](../openspec/changes/archive/)
- Constitution: [`openspec/project.md`](../openspec/project.md)
- Knowledge / code graphs: Graphify + GitNexus (below)

One session = one phase (`explore` | `propose` | `apply` | `archive`). Prefer a new chat + Session Handoff when changing phase — do not rely on prior chat history.

---

## 2. Clickable map

### Operator vocabulary → real paths

| You might say… | Actual location |
|----------------|-----------------|
| “roadmap” | Active [`openspec/changes/`](../openspec/changes/) + canonical [`openspec/specs/`](../openspec/specs/) |
| “milestones” | Numbered `##` sections in that change’s `tasks.md` |

Do **not** invent a product file named `roadmap.md` as an SDD runtime artifact.

### OpenSpec

| Path | What it is |
|------|------------|
| [`openspec/project.md`](../openspec/project.md) | Constitution (purpose, stack, non-goals, language policy) |
| [`openspec/specs/`](../openspec/specs/) | Current required behavior by capability |
| [`openspec/changes/`](../openspec/changes/) | Active proposals |
| [`openspec/changes/archive/`](../openspec/changes/archive/) | Closed changes |
| [`openspec/infra.md`](../openspec/infra.md) | Installed infra (R10 — assume ✅; do not reinstall) |

### Graphify

| Path / command | What it is |
|----------------|------------|
| [`graphify-out/GRAPH_REPORT.md`](../graphify-out/GRAPH_REPORT.md) | Knowledge-graph summary (often regenerable / gitignored) |
| `graphify update .` | Refresh the AST graph after doc/code edits |

### GitNexus

| Path / command | What it is |
|----------------|------------|
| `.gitnexus/` | Local code index — **do not hand-edit** |
| `npx gitnexus status` | Index health |
| GitNexus MCP | Impact / context / detect_changes before edits |

### Templates (Pattern / Gate)

| Pointer | What it is |
|---------|------------|
| Guide [§12.3](./byebyevibe-guide.md) | `design.md` template |
| Guide [§12.10](./byebyevibe-guide.md) | `tasks.md` Pattern + Gate |
| [`openspec/changes/_template/`](../openspec/changes/_template/) | In-repo proposal template (when shipped) |

---

## 3. explore — think without shipping

**Plain meaning:** Think together without committing implementation. Clarify the problem, options, and unknowns.

**Produces:** Clarity; optionally `research.md` under the change folder.

**Does not:** Write feature code, mark apply tasks done, or skip ahead to implement in the same chat.

**Not always required:** Types A (trivial) and B (known bug) often skip explore. Types C/D/E usually start here or with propose after a short explore.

### Explore prompt craft

Structure the human prompt with:

1. **Situation / scenario** — where we are
2. **Problem** — what hurts
3. **Inputs** — what the agent may read or assume
4. **Outputs** — what “done exploring” looks like (decision, comparison, research.md)
5. **Unknowns** — questions the agent should ask
6. **Out of scope** — including **no implementation in explore**

Distinguish:

- **Feature I/O** — product inputs/outputs you are designing (prompt craft above)
- **Control-plane I/O** — OpenSpec / GitNexus / Graphify tool boxes in guide [§4.3](./byebyevibe-guide.md)

### Confidence (explore)

Copy-paste:

1. Did we name inputs, outputs, unknowns, and out-of-scope (no implement)?
2. Is there a clear decision or open question list — not a half-written feature?
3. Would a new chat know whether to `/opsx:propose` next?
4. **Meta:** What must a new agent read, without this chat, to continue?

**Objective check:** `research.md` exists when explore ran; otherwise a short written decision in chat is enough to hand off — then capture it in propose artifacts.

---

## 4. propose — agree the playbook

**Plain meaning:** Agree why, what behavior, how (when needed), and the executable checklist — before writing product code.

**Produces:** `proposal.md`, `specs/**` deltas, often `design.md`, always `tasks.md` (and `research.md` only if explore ran).

**Does not:** Ship the feature implementation (that is apply).

### Artifact glossary

| Artifact | Plain language | When |
|----------|----------------|------|
| `proposal.md` | Why / what (human agreement) | Always in propose |
| `specs/**` | Required behavior (`WHEN` / `THEN`) | Always for listed capabilities |
| `design.md` | How and why this technical option | When trade-offs, cross-cutting concerns, new deps, security/perf, or ambiguity; may be light when the change is obvious |
| `tasks.md` | Executable checklist (Pattern + Gate) | Always before apply |
| `research.md` | Explore notes | Only if explore ran |

Templates: guide [§12.3](./byebyevibe-guide.md) (`design.md`), [§12.10](./byebyevibe-guide.md) (`tasks.md`).

### Confidence (propose)

1. Does `proposal.md` state why, scope, and non-goals?
2. Do specs encode behavior that apply can verify?
3. Is `design.md` present when trade-offs exist (or explicitly light when obvious)?
4. **Meta:** What must a new agent read, without this chat, to continue?

**Objective check:**

```bash
OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate <change-id> --strict
```

---

## 5. apply — execute the checklist

**Plain meaning:** Implement tasks, run Gates, mark `[x]` only on success. Keep scope honest — if design must change, pause and update artifacts.

**Produces:** Code/docs changes + completed tasks + passing Gates.

**Does not:** Silently redesign scope; skip Pattern/Gate; mix explore→apply in the same thread.

Before editing (local machines): `sdd-session-register` + `sdd-session-check`; on finish/pause: `sdd-session-release` (R11). Cloud/ephemeral runners are exempt.

### Confidence (apply)

1. Did each task with a **Gate** exit 0 before `[x]`?
2. Did we follow **Pattern** files instead of inventing structure?
3. Is Session Handoff ready if we pause mid-checklist?
4. **Meta:** What must a new agent read, without this chat, to continue?

**Objective check:** per-task Gate commands in `tasks.md`; overall `openspec validate <change-id> --strict` still green.

---

## 6. archive — promote truth and close

**Plain meaning:** Merge capability deltas into canonical `openspec/specs/`, move the change under `openspec/changes/archive/`, leave future notes where the next operator can find them.

**Produces:** Updated specs + archive path; change no longer “active”.

**Does not:** Leave WIP as the source of truth in `openspec/changes/<id>/`.

### Confidence (archive)

1. Are all tasks complete (or explicitly deferred with a follow-up change)?
2. Do archived specs match what was applied?
3. Is the archive folder path correct under `openspec/changes/archive/`?
4. Did anything in this change repeat a procedure or explanation from a previous change? (rule of three: 1st normal, 2nd note it, 3rd extract a skill — see §7)
5. Was anything in this change done manually that a configured integration would have done? (repeated manual steps for the same tool are the signal — see §8)
6. **Meta:** What must a new agent read, without this chat, to continue?

**Objective check:** change appears under `openspec/changes/archive/`; `npx openspec list` no longer shows it as active.

---

## 7. Skills — memory beyond specs

Skills are procedural memory the agent recalls automatically: a short trigger description charged to every session, with the full content loaded only when the topic comes up. They complement — never replace — the other memory layers:

| Layer | Holds | Example |
|-------|-------|---------|
| Skill | How-to / procedural knowledge | "feasibility studies for Recife-PE follow these steps…" |
| `openspec/specs/` | Required behavior (`WHEN` / `THEN`) | "the report MUST include zoning limits" |
| [`openspec/project.md`](../openspec/project.md) | Constitution (purpose, stack, non-goals) | "artifacts are English; chat follows `chat_language`" |

**When a skill helps — litmus test:** *would a competent generalist with internet access still get this wrong or do it differently than you want?* If yes (local law or norm, company thresholds, proprietary method, required output format), a skill pays for itself. If no (generic stack knowledge, "act as X" personas), it is pure token cost — skip it.

**You do NOT need to write skills before starting development.** Good skills crystallize from repetition, not speculation. Work normally; when you notice yourself teaching the agent the same thing again — or the agent offers to save it — that is the moment.

**Ask the agent to create it.** Never hand-write `SKILL.md`: say "create a skill for <topic>" and the agent produces the correct format, checks for an existing skill to extend first, and keeps the trigger description lean. If the skill contains volatile data (regulation values, market figures), it gets a "verified on YYYY-MM" marker — skills do not update themselves, so stale data must be corrected by you.

**Lifecycle — create → measure → prune:** the rule of three governs extraction (1st time normal, 2nd time note it, 3rd time extract a skill — the archive confidence question in §6 asks exactly this). Skills that never fire or overlap a sibling should be merged or deleted, like dead code.

Depth for agents: the `sdd-skill-guidance` skill (detection signals, standard suggestion message, creation hygiene).

---

## 8. Tooling — CLI → MCP → manual

When the agent needs to act on an external tool (GitHub, Figma, a SaaS dashboard), it resolves the action in a fixed order — the **cascade**:

1. **Your override** — say "use MCP first" and the agent obeys, for that session only (a new session returns to the default).
2. **Configured CLI** — the default: no permanent context cost, scriptable, works in CI.
3. **Configured MCP** — the fallback, **or the primary path when only MCP delivers the capability** (e.g. structured design context from Figma). The pedagogy: **key → CLI → MCP, unless only MCP delivers the capability** — decided per tool, not by dogma.
4. **Suggestion** — if nothing is configured, the agent may *offer* to help you set it up (at most one proactive suggestion per session, shared with skill suggestions).
5. **Manual instructions** — last resort: the agent narrates the dashboard steps for you.

**Why CLI over MCP by default?** An active MCP charges its tool schemas to *every* session, whether used or not — for occasional use, a CLI + API key is cheaper. MCPs earn their cost when they deliver something a CLI cannot.

**The agent never installs or configures anything unprompted** — no MCP, CLI, or key, no exceptions. Suggestions are offers; you run the steps. A "no" is recorded as `declined` in [`openspec/infra.md`](../openspec/infra.md) and never re-suggested.

Where things live: integration **status** in [`openspec/infra.md`](../openspec/infra.md) (kept by `bash scripts/verify-infra.sh`, which also reports an advisory tooling gap-check); per-tool **install how-to** in [`doc/tooling-install.md`](./tooling-install.md). Depth for agents: the `sdd-tooling-guidance` skill.

---

## 9. Next step — Session Handoff example

After this map, practice a full cycle with upstream onboard (optional but recommended):

```text
/opsx:onboard
```

Or start a small real change:

```text
/opsx:propose <short description>

Change: openspec/changes/<id>/   # after propose creates it
Read: proposal.md, design.md, tasks.md, specs/
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```

When finishing help narration, the agent MAY offer a Session Handoff block pointing to `/opsx:onboard` or `/opsx:propose` — still naming both help and onboard as complementary surfaces.
