# Tool insertion methodology for the SDD system

| Field | Value |
|-------|-------|
| **Date** | 2026-07-25 |
| **Change** | `explore-oss-coverage-gaps` (type E — exploration artifact) |
| **Objective** | Define standardized criteria and steps to insert each tool recommended in `research.md` into the SDD system without creating incompatibilities, overlap, or friction in the explore→propose→apply flow |
| **Base** | Extends the existing rite: `doc/avaliacoes/TEMPLATE.md` + UI module precedent (`add-sdd-ui-development-module`) + R7/R10/R11 from `AGENTS.md` |

## Principles

1. **One tool = one OpenSpec change** (R7). Nothing enters the kit without its own propose → apply → archive.
2. **Out-of-band by default.** New automation goes to CI/PR/scheduled whenever possible — the interactive explore→propose→apply pipeline **does not gain new steps** for the user. Only what must intercept edits enters "in-band" (within the session) (sole case: Probity (G2)), and always disableable via globs/uninstall.
3. **Reuse existing discovery mechanisms** (SDD guide §4.2): AGENTS.md declares, hooks intercept, skill descriptions auto-invoke. No new discovery mechanism.
4. **Reversibility required.** Without a documented uninstall plan, the tool does not enter the MANIFEST.

---

## Phase 0 — Pre-verification (before propose)

Answers the question: *what to verify before implementing to avoid incompatibilities, bugs, and overlap?*

### 0.1 Checks on the existing system

| # | Verification | How | Blocks if |
|---|-------------|------|-------------|
| V1 | Already installed or evaluated? | `openspec/infra.md` (R10) + index `doc/avaliacoes/` | Discarded without a new re-evaluation condition |
| V2 | Contact-surface matrix | Map which surface the tool occupies: git hooks · PreToolUse hooks · MCP servers · skills · scripts · CI workflows · artifact templates | Surface already occupied by an equivalent component (e.g. a 3rd git-hook manager) |
| V3 | Artifact/name collision | Files the tool creates/reads vs existing (precedent: `design.md` vs `DESIGN.md` in the UI module) | Collision without disambiguation mitigation |
| V4 | Repo profile | Applies to APP, DOCS_SPECS, or both? | — (defines flag in install.sh) |
| V5 | Hook stacking | If using PreToolUse: measure cumulative latency with GitNexus + Graphify active | Latency makes apply impractical |

### 0.2 Checks on the tool

| # | Verification | Acceptance criterion |
|---|-------------|----------------------|
| F1 | Security | Advisories consulted (rule 050); version **pinned** on install; tokens with least scope possible (e.g. github-mcp with `--toolsets issues` and read-only where applicable) |
| F2 | License | Compatible with internal use; record if AGPL (affects modified redistribution only) |
| F3 | Living governance | Release in the last 6 months + identifiable maintainers (criterion 5 of research) |
| F4 | Reversibility | Versionable declarative config + clean uninstall path |
| F5 | Operability | Toggle on/off · dry-run · readable logs — at least 2 of 3 |

### 0.3 Prior research for ease of use

- Minimum functional config documented (copy from official docs, do not invent)
- Integration reports with Claude Code/Cursor (hooks, MCP) — how others solved it
- Cost per operation: LLM tokens (Probity (G2), reviews) and CI minutes (scanners) — budget before enabling by default
- Known failure modes (recurring open issues) and how the system behaves if the tool fails (fail-open vs fail-closed — CI gates must be fail-closed; in-band conveniences, fail-open)

**Phase 0 output:** evaluation filled in `doc/avaliacoes/<date>-<name>.md` (TEMPLATE.md), with decision "Under evaluation" → "Adopted" only after Phase 2.

---

## Phase 1 — Propose

- `/opsx:propose add-<tool>` — proposal, design, and tasks.
- `design.md` must contain: activation-mode decision (see Phase 3), task-type matrix (see Phase 4), rollback plan, and source citations (R8) — including `research.md` and the Phase 0 evaluation.
- Spec delta only if the tool creates a new normative requirement (e.g. "every PR MUST pass OSV-Scanner").

## Phase 2 — Pilot (controlled apply)

> **Approved exception (2026-07-25):** the pilot is **waived** when insertion does not install a new binary or hook — i.e. only orchestrates commands already present in the repo (e.g. G1 `sdd-gates.yml`) or adds inert documentation/config template. In those cases, Phase 1 → Phase 3 direct. Any tool with hook, binary, service, or LLM consumption keeps pilot mandatory.

- Apply with R11 (register/check/release) in a **pilot worktree or repo**, never directly across all repos.
- **Quantified success criteria BEFORE the pilot.** Examples: Probity (G2) — extra latency p95 < Xs per edit and < Y% false blocks; correctness-review — at least 1 valid finding every N reviews; Renovate — manageable PR volume with the conservative preset.
- Validation window defined (e.g. N changes or N PRs processed by the tool).
- Failed criteria → decision reverts to "Deferred" with re-evaluation conditions; artifacts removed (rollback tested for free).

## Phase 3 — Registration (6-point contract)

Answers the question: *how to register instructions so the user knows how to use the tool in the flow?*

Every approved tool registers at **6 points** — neither more (context rot), nor less (agent does not discover):

| # | Where | What | For whom |
|---|------|-------|-----------|
| R1 | `openspec/infra.md` | Row: pinned version + status + "verify with" | Agent (R10) |
| R2 | `AGENTS.md` | ≤10 lines in Integrations + row in "On-demand context" + command in Commands table | Agent (always in context) |
| R3 | Skill (`.claude/skills/` + mirror `.cursor/skills/`) or rule `.mdc` | Operational detail; description states **when to auto-invoke**; rule only if always-on | Agent (lazy load) |
| R4 | `doc/sistema-sdd-pedro.md` §new | Human operation: when to trigger, how to read output, how to disable, troubleshooting | Human |
| R5 | `doc/avaliacoes/<date>-<name>.md` | "Adopted" decision + re-evaluation conditions | History |
| R6 | `sdd-kit/` | Config template + install/uninstall in module script + MANIFEST bump + check in `verify.sh` | Reproduction |

Mandatory post-registration: `graphify update .` + `npx gitnexus analyze --force` — without this the knowledge graph does not know the tool and agents cannot find it in sources 3–5.

Anti-patterns (inherited from guide §2.5.1): do not paste tool-generated blocks into canonical AGENTS.md; do not duplicate the skill in the guide; do not create an always-on rule for an on-demand tool.

---

## Phase 4 — Activation and flow integration

### 4.1 Activation modes (question 3)

Three modes, all already present in the system — no tool creates a fourth:

| Mode | Description | Existing precedent |
|------|-----------|---------------------|
| **A — Automatic out-of-band** | CI/PR/scheduled; runs outside the agent session | (new, but industry pattern) |
| **B — Automatic in-band** | Hook intercepts actions during the session | PreToolUse GitNexus/Graphify |
| **C — On demand** | User or agent invokes skill/command | `simplify-review`, `security-reviewer`, `/opsx:*` |
| **D — Passive (MCP)** | Available; agent consults when relevant | GitNexus MCP, Graphify MCP |

Matrix for research tools:

| Tool | Mode | Who triggers | At which stage |
|------------|------|-------------|--------------|
| `sdd-gates.yml` (G1) | A | push/PR (automatic) | Post-apply, pre-merge |
| OSV-Scanner (G8) | A | PR (automatic) | Pre-merge |
| Renovate (G8) | A | Scheduled (bot) | Outside pipeline; generated PRs enter as type A/B tasks |
| Probity (G2) | B | Hook (automatic) | During apply; **disable** via globs/uninstall on type A and docs |
| `correctness-review` (G7) | C | User (or agent, by diff trigger) | Post-apply, before commit — same position as `simplify-review` |
| `sdd-metrics.sh` (G4) | C | User (periodic/retrospective) | Outside pipeline |
| github-mcp-server (G5) | D | Agent consults | Explore (read issues) and propose (link change ↔ issue) |

**Direct answer:** only Probity (G2) is automatic within the session. CI/bots are automatic outside it. Reviews and metrics are user commands. MCP is passive. The user only "triggers" manually two things: post-apply reviews and metrics.

### 4.2 Pipeline impact and selectivity (question 4)

**The explore→propose→apply pipeline does NOT gain new interactive steps.** What changes is what happens *after push* (CI gates) and *in parallel* (bots). The only in-band friction (Probity (G2)) is disableable and restricted to code.

Not every tool in every case — the matrix follows the existing A–E classification:

| Task type | Probity (G2) | correctness-review | sdd-gates (CI) | OSV/Renovate | github-mcp |
|----------------|-----------|-------------------|----------------|--------------|------------|
| A — Trivial | off | no | runs (passes quickly) | continuous* | no |
| B — Bug fix | **on** (materializes R6) | if diff > ~80 lines | runs | continuous* | read source issue |
| C — Refactor | on | **yes** | runs | continuous* | optional |
| D — Feature | on | **yes** | runs | continuous* | issue → proposal |
| E — Exploration | n/a (no code) | n/a | validates artifacts | continuous* | read issues in research |

\* Renovate/OSV are independent of classification — they operate on the repo, not on the task.

**How to decide when to use:** no new heuristic is created. Reuse existing ones:

- A–E classification (R1) decides Probity (G2) on/off (globs/disable module) and review depth — the same gate that already decides whether an OpenSpec proposal exists.
- The `simplify-review` trigger (diff > ~80 lines or > 4 files) extends to `correctness-review` — same table in AGENTS.md "Post-implementation reviews".
- Updated review order: implementation → tests (R6/Probity enforceTdd) → `correctness-review` → `simplify-review` (optional) → `security-reviewer` (if applicable) → commit → CI gates.

**Integration by flow type:**

- **Bug (type B):** github-mcp reads the issue in framing; Probity (G2) enforces failing-test-first (R6 ceases to be a paper rule); OSV covers the case where the bug is a dependency vulnerability.
- **Feature (type D):** github-mcp links issue → proposal in propose; Probity (G2) + correctness-review in apply; CI gates validate the change before merge.
- **Exploration (type E):** github-mcp only (issue context) — no code tool touches the flow.

---

## Phase 5 — Operation and continuous re-evaluation

- **Adoption metrics** (links to G4): is the tool being used? False-positive rate? Actual vs budgeted cost? `sdd-metrics.sh` incorporates per-tool counters when available.
- **Semiannual re-evaluation** or on kit upgrade — whichever comes first. Special attention to tools with governance in transition (PR-Agent) or niche (GlitchTip MCP beta).
- **Sunset criteria:** 2 cycles without registered use, or cost > observed value, or upstream project orphaned → removal change + evaluation updated to "Discarded" with reopening conditions.

---

## Additional approaches included (question 5 — what was missing)

Items not covered in the original 4 questions, incorporated above:

1. **Rollback/uninstall** as entry precondition in the MANIFEST (F4, contract R6, Phase 2).
2. **Pilot with quantified success criteria** before kit promotion — research → kit direct is forbidden (Phase 2).
3. **Cost budget** (LLM tokens + CI minutes) per tool, before enabling by default (0.3).
4. **Security vetting of the tool itself** — version pin, advisories, minimum token scope (F1).
5. **Sunset/re-evaluation criteria** — insertion without an exit plan is debt (Phase 5).
6. **Install order and dependencies** — e.g. G1 (CI workflow) before G8 (OSV enters that CI); G5 before G7-phase-2 (PR-Agent uses issue context).
7. **Graph updates post-install** — `graphify update .` + `gitnexus analyze`; without this the tool is invisible to agents (Phase 3).
8. **Agent vs human separation in registration** — AGENTS.md/skills instruct the agent; SDD guide instructs the human; distinct audiences with distinct documents (6-point contract).
9. **Failure behavior** — fail-closed for CI gates, fail-open for in-band conveniences (0.3).
10. **Repo profile matrix** (APP vs DOCS_SPECS) as install.sh flag, not as ad-hoc decision per install (V4).

## Session Handoff

Explore phase complete. To apply the methodology to the first tool:

---
/opsx:propose add-sdd-ci-gates-workflow

Read: openspec/changes/explore-oss-coverage-gaps/research.md (G1)
      openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md (Phases 0–3)
      doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md (recorded decisions)
Infra: openspec/infra.md (assume ✅ — do not reinstall)
Note: G1 qualifies for the pilot exception (no new binary/hook) — Phase 1 → Phase 3 direct.
---
