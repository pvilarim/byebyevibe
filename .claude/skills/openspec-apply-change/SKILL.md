---
name: openspec-apply-change
description: Implement tasks from an OpenSpec change. Use when the user wants to start implementing, continue implementation, or work through tasks.
license: MIT
compatibility: Requires openspec CLI.
metadata:
  author: openspec
  version: "1.0"
  generatedBy: "1.3.1"
---

Implement tasks from an OpenSpec change.

**Input**: Optionally specify a change name. If omitted, check if it can be inferred from conversation context. If vague or ambiguous you MUST prompt for available changes.

**Steps**

1. **Select the change**

   If a name is provided, use it. Otherwise:
   - Infer from conversation context if the user mentioned a change
   - Auto-select if only one active change exists
   - If ambiguous, run `openspec list --json` to get available changes and use the **AskUserQuestion tool** to let the user select

   Always announce: "Using change: <name>" and how to override (e.g., `/opsx:apply <other>`).

2. **Check status to understand the schema**
   ```bash
   openspec status --change "<name>" --json
   ```
   Parse the JSON to understand:
   - `schemaName`: The workflow being used (e.g., "spec-driven")
   - Which artifact contains the tasks (typically "tasks" for spec-driven, check status for others)

3. **Get apply instructions**

   ```bash
   openspec instructions apply --change "<name>" --json
   ```

   This returns:
   - `contextFiles`: artifact ID -> array of concrete file paths (varies by schema - could be proposal/specs/design/tasks or spec/tests/implementation/docs)
   - Progress (total, complete, remaining)
   - Task list with status
   - Dynamic instruction based on current state

   **Handle states:**
   - If `state: "blocked"` (missing artifacts): show message, suggest using openspec-continue-change
   - If `state: "all_done"`: congratulate, suggest archive
   - Otherwise: proceed to implementation

4. **Read context files**

   Read every file path listed under `contextFiles` from the apply instructions output.
   Also read `openspec/infra.md` — assume ✅ items are installed; do not reinstall or web-search setup guides.
   The files depend on the schema being used:
   - **spec-driven**: proposal, specs, design, tasks
   - Other schemas: follow the contextFiles from CLI output

5. **Show current progress**

   Display:
   - Schema being used
   - Progress: "N/M tasks complete"
   - Remaining tasks overview
   - Dynamic instruction from CLI

6. **Implement tasks (loop until done or blocked)**

   For each pending task:
   - Show which task is being worked on
   - Make the code changes required
   - Keep changes minimal and focused
   - Mark task complete in the tasks file: `- [ ]` → `- [x]`
   - Continue to next task

   **Pause if:**
   - Task is unclear → ask for clarification
   - Implementation reveals a design issue → suggest updating artifacts
   - Error or blocker encountered → report and wait for guidance
   - User interrupts

7. **On completion or pause, show status**

   Display:
   - Tasks completed this session
   - Overall progress: "N/M tasks complete"
   - If all done: suggest archive
   - If paused: explain why and wait for guidance

8. **Suggest simplify-review when diff is large (non-blocking)**

   After implementation changes exist in the working tree, run:

   ```bash
   git diff --stat
   ```

   If **either** threshold is met:
   - Total changed lines (insertions + deletions) **> ~80**, or
   - **> 4** files changed

   Then **suggest** invoking the `simplify-review` skill (see `AGENTS.md` → Post-implementation reviews). Example message:

   > Large diff (+X/-Y, N files). Want to run `simplify-review` before commit? (optional — does not block archive.)

   Rules:
   - **Never** auto-invoke without user consent
   - **Never** block commit, PR, or `/opsx:archive`
   - Skip suggestion for Type A trivial work or when user already declined in this session
   - If the change touches auth/API/payments/sensitive data, also mention `security-reviewer` (same optional pattern)

**Output During Implementation**

```
## Implementing: <change-name> (schema: <schema-name>)

Working on task 3/7: <task description>
[...implementation happening...]
✓ Task complete

Working on task 4/7: <task description>
[...implementation happening...]
✓ Task complete
```

**Output On Completion**

```
## Implementation Complete

**Change:** <change-name>
**Schema:** <schema-name>
**Progress:** 7/7 tasks complete ✓

### Completed This Session
- [x] Task 1
- [x] Task 2
...

All tasks complete! Ready to archive this change.

[If diff > ~80 lines or > 4 files: optional simplify-review suggestion here]
```

**Output On Pause (Issue Encountered)**

```
## Implementation Paused

**Change:** <change-name>
**Schema:** <schema-name>
**Progress:** 4/7 tasks complete

### Issue Encountered
<description of the issue>

**Options:**
1. <option 1>
2. <option 2>
3. Other approach

What would you like to do?
```

**Guardrails**
- Keep going through tasks until done or blocked
- Always read context files before starting (from the apply instructions output)
- If task is ambiguous, pause and ask before implementing
- If implementation reveals issues, pause and suggest artifact updates
- Keep code changes minimal and scoped to each task
- Update task checkbox immediately after completing each task
- Pause on errors, blockers, or unclear requirements - don't guess
- Use contextFiles from CLI output, don't assume specific file names

## Session coordination (apply)

Before editing files:

```bash
bash scripts/sdd-session-register.sh --phase apply --change-id "<id>"
bash scripts/sdd-session-check.sh --phase apply --change-id "<id>"
```

If exit ≠ 0: **stop** and inform the user (another active apply in the same worktree).

When finishing or pausing (including Session Handoff):

```bash
bash scripts/sdd-session-release.sh
```

## Task execution (§12.10)

- Read `doc/sistema-sdd-pedro.md` §12.10 when executing enriched tasks
- Before the **first task that modifies code**: run GitNexus impact (or read the `Pattern` file in full)
- For each task with `- **Gate:**`: run the gate command; mark `- [x]` only on exit 0
- If a `Pattern` path does not exist: **pause**, report broken pointer, suggest updating `tasks.md`
- **DOCS_SPECS:** do not implement APP `src/` code in this repo — pause and recommend an OpenSpec change in the APP repo

## Tooling cascade (CLI → MCP → manual)

When a task needs to act on an external tool (GitHub, Figma, SaaS API), resolve in this order:

1. Session operator override ("use MCP first") — honored without debate, this session only
2. Configured CLI (default)
3. Configured MCP (fallback, or primary where only MCP delivers the capability)
4. Suggest configuring — offer-only, under the shared one-per-session cap (skill + tooling)
5. Manual instructions (last resort)

Falling to manual narration for the **same tool a second time** in one session arms the suggestion. Check `openspec/infra.md` first — `declined` = do not re-suggest. Full guidance: `sdd-tooling-guidance` skill.

---

## Session Handoff

This phase finished or was paused. **Suggestion: open a new chat** to continue (clean context).

Paste in the first message of the new chat:

---
/opsx:archive <change-id>          # if all tasks complete
# or /opsx:apply <change-id>       # if paused due to blocker

Change: openspec/changes/<change-id>/
Read: tasks.md (progress), pending artifacts
Infra: openspec/infra.md (assume ✅ — do not reinstall)
Release lock: bash scripts/sdd-session-release.sh  # if apply paused
---

**Fluid Workflow Integration**

This skill supports the "actions on a change" model:

- **Can be invoked anytime**: Before all artifacts are done (if tasks exist), after partial implementation, interleaved with other actions
- **Allows artifact updates**: If implementation reveals design issues, suggest updating artifacts - not phase-locked, work fluidly
