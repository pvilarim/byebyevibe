---
name: openspec-archive-change
description: Archive a completed change in the experimental workflow. Use when the user wants to finalize and archive a change after implementation is complete.
license: MIT
compatibility: Requires openspec CLI.
metadata:
  author: openspec
  version: "1.0"
  generatedBy: "1.3.1"
---

Archive a completed change in the experimental workflow.

**Input**: Optionally specify a change name. If omitted, check if it can be inferred from conversation context. If vague or ambiguous you MUST prompt for available changes.

**Steps**

1. **If no change name provided, prompt for selection**

   Run `openspec list --json` to get available changes. Use the **AskUserQuestion tool** to let the user select.

   Show only active changes (not already archived).
   Include the schema used for each change if available.

   **IMPORTANT**: Do NOT guess or auto-select a change. Always let the user choose.

2. **Check artifact completion status**

   Run `openspec status --change "<name>" --json` to check artifact completion.

   Parse the JSON to understand:
   - `schemaName`: The workflow being used
   - `artifacts`: List of artifacts with their status (`done` or other)

   **If any artifacts are not `done`:**
   - Display warning listing incomplete artifacts
   - Use **AskUserQuestion tool** to confirm user wants to proceed
   - Proceed if user confirms

3. **Check task completion status**

   Read the tasks file (typically `tasks.md`) to check for incomplete tasks.

   Count tasks marked with `- [ ]` (incomplete) vs `- [x]` (complete).

   **If incomplete tasks found:**
   - Display warning showing count of incomplete tasks
   - Use **AskUserQuestion tool** to confirm user wants to proceed
   - Proceed if user confirms

   **If no tasks file exists:** Proceed without task-related warning.

4. **Assess delta spec sync state**

   Check for delta specs at `openspec/changes/<name>/specs/`. If none exist, proceed without sync prompt.

   **If delta specs exist:**
   - Compare each delta spec with its corresponding main spec at `openspec/specs/<capability>/spec.md`
   - Determine what changes would be applied (adds, modifications, removals, renames)
   - Show a combined summary before prompting

   **Prompt options:**
   - If changes needed: "Sync now (recommended)", "Archive without syncing"
   - If already synced: "Archive now", "Sync anyway", "Cancel"

   If user chooses sync, use Task tool (subagent_type: "general-purpose", prompt: "Use Skill tool to invoke openspec-sync-specs for change '<name>'. Delta spec analysis: <include the analyzed delta spec summary>"). Proceed to archive regardless of choice.

4b. **Consolidated closing assessment (§12.10)**

   Before archiving, run a single consolidated closing assessment: **self-assess** the three items below against evidence from the change — do NOT ask the operator three separate questions.

   1. **Reusable pattern** — did the change establish a procedure or template used more than once or likely to recur? Evidence: the change's own `tasks.md`/`design.md`. Promotion targets: a reusable skill (`.claude/skills/<domain>-pattern/SKILL.md`) or a note in `openspec/project.md` Cross-references.
   2. **Repetition (rule of three)** — did anything repeat a procedure or explanation from a previous change? Evidence: scan `openspec/changes/archive/` directory names and, when suggestive, skim matching `proposal.md` files. Rule of three: 1st normal, 2nd note it, 3rd extract a skill (see `sdd-skill-guidance`).
   3. **Tooling gap** — was anything done manually that a configured integration would have done (manual narration for an unconfigured tool during this change's sessions)? Suppress this item for integrations marked `declined` in `openspec/infra.md` (see `sdd-tooling-guidance`; how-to in `doc/tooling-install.md`).

   **Always print** the compact per-item verdict in the archive summary (step 6), e.g.:

   ```
   Reusable pattern: no · Repetition: no · Tooling gap: no
   ```

   **Only when ≥1 item has a positive signal**, present ONE consolidated prompt using the **AskUserQuestion tool** with `multiSelect: true`, listing only the positively-signaled items plus a "none of these / proceed" option.

   The assessment never blocks the archive — proceed regardless of the operator's answer (or absence of a prompt).

5. **Perform the archive**

   Create the archive directory if it doesn't exist:
   ```bash
   mkdir -p openspec/changes/archive
   ```

   Generate target name using current date: `YYYY-MM-DD-<change-name>`

   **Check if target already exists:**
   - If yes: Fail with error, suggest renaming existing archive or using different date
   - If no: Move the change directory to archive

   ```bash
   mv openspec/changes/<name> openspec/changes/archive/YYYY-MM-DD-<name>
   ```

6. **Display summary**

   Show archive completion summary including:
   - Change name
   - Schema that was used
   - Archive location
   - Whether specs were synced (if applicable)
   - Closing assessment verdict (reusable pattern / repetition / tooling gap)
   - Note about any warnings (incomplete artifacts/tasks)

**Output On Success**

```
## Archive Complete

**Change:** <change-name>
**Schema:** <schema-name>
**Archived to:** openspec/changes/archive/YYYY-MM-DD-<name>/
**Specs:** ✓ Synced to main specs (or "No delta specs" or "Sync skipped")
**Closing assessment:** Reusable pattern: no · Repetition: no · Tooling gap: no

All artifacts complete. All tasks complete.
```

**Guardrails**
- Always prompt for change selection if not provided
- Use artifact graph (openspec status --json) for completion checking
- Don't block archive on warnings - just inform and confirm
- Preserve .openspec.yaml when moving to archive (it moves with the directory)
- Show clear summary of what happened
- If sync is requested, use openspec-sync-specs approach (agent-driven)
- If delta specs exist, always run the sync assessment and show the combined summary before prompting

---

## Session Handoff

Archive complete. **Suggestion: open a new chat** for the next task (clean context).

### Metrics cadence nudge (advisory)

After a successful archive, if `scripts/sdd-metrics.sh` exists:

```bash
bash scripts/sdd-metrics.sh --check-cadence
```

- Exit **1** → include in the handoff ≤5 lines suggesting `bash scripts/sdd-metrics.sh` + playbook in `doc/sistema-sdd-pedro.md` §2.17 (1 insight → 1 adjustment).
- Exit **0** → omit the metrics block.
- Script missing or unexpected failure → **SKIP** (never fail archive; never auto-run the full report).

Paste into the first message of the new chat (if applicable):

---
/opsx:explore <topic>   # or /opsx:propose <description> (after /opsx:archive)

Infra: openspec/infra.md (assume ✅ — do not reinstall)
---
