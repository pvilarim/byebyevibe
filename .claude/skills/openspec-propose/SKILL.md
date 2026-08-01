---
name: openspec-propose
description: Propose a new change with all artifacts generated in one step. Use when the user wants to quickly describe what they want to build and get a complete proposal with design, specs, and tasks ready for implementation.
license: MIT
compatibility: Requires openspec CLI.
metadata:
  author: openspec
  version: "1.0"
  generatedBy: "1.3.1"
---

Propose a new change - create the change and generate all artifacts in one step.

I'll create a change with artifacts:
- proposal.md (what & why)
- design.md (how)
- tasks.md (implementation steps)

When ready to implement, run /opsx:apply

---

**Input**: The user's request should include a change name (kebab-case) OR a description of what they want to build.

**Steps**

0. **Read workspace infrastructure**

   Read `openspec/infra.md` before proposing installation of MCP servers, CLIs, plugins, or skills. Items marked ✅ must be used directly — do not reinstall or web-search setup guides.

1. **If no clear input provided, ask what they want to build**

   Use the **AskUserQuestion tool** (open-ended, no preset options) to ask:
   > "What change do you want to work on? Describe what you want to build or fix."

   From their description, derive a kebab-case name (e.g., "add user authentication" → `add-user-auth`).

   **IMPORTANT**: Do NOT proceed without understanding what the user wants to build.

2. **Create the change directory**
   ```bash
   openspec new change "<name>"
   ```
   This creates a scaffolded change at `openspec/changes/<name>/` with `.openspec.yaml`.

3. **Get the artifact build order**
   ```bash
   openspec status --change "<name>" --json
   ```
   Parse the JSON to get:
   - `applyRequires`: array of artifact IDs needed before implementation (e.g., `["tasks"]`)
   - `artifacts`: list of all artifacts with their status and dependencies

4. **Create artifacts in sequence until apply-ready**

   Use the **TodoWrite tool** to track progress through the artifacts.

   Loop through artifacts in dependency order (artifacts with no pending dependencies first):

   a. **For each artifact that is `ready` (dependencies satisfied)**:
      - Get instructions:
        ```bash
        openspec instructions <artifact-id> --change "<name>" --json
        ```
      - The instructions JSON includes:
        - `context`: Project background (constraints for you - do NOT include in output)
        - `rules`: Artifact-specific rules (constraints for you - do NOT include in output)
        - `template`: The structure to use for your output file
        - `instruction`: Schema-specific guidance for this artifact type
        - `outputPath`: Where to write the artifact
        - `dependencies`: Completed artifacts to read for context
      - Read any completed dependency files for context
      - Create the artifact file using `template` as the structure
      - Apply `context` and `rules` as constraints - but do NOT copy them into the file
      - Show brief progress: "Created <artifact-id>"

   b. **Continue until all `applyRequires` artifacts are complete**
      - After creating each artifact, re-run `openspec status --change "<name>" --json`
      - Check if every artifact ID in `applyRequires` has `status: "done"` in the artifacts array
      - Stop when all `applyRequires` artifacts are done

   c. **If an artifact requires user input** (unclear context):
      - Use **AskUserQuestion tool** to clarify
      - Then continue with creation

5. **Show final status**
   ```bash
   openspec status --change "<name>"
   ```

**Output**

After completing all artifacts, summarize:
- Change name and location
- List of artifacts created with brief descriptions
- What's ready: "All artifacts created! Ready for implementation."
- Prompt: "Run `/opsx:apply` or ask me to implement to start working on the tasks."

**Artifact Creation Guidelines**

- Follow the `instruction` field from `openspec instructions` for each artifact type
- The schema defines what each artifact should contain - follow it
- Read dependency artifacts for context before creating new ones
- Use `template` as the structure for your output file - fill in its sections
- **IMPORTANT**: `context` and `rules` are constraints for YOU, not content for the file
  - Do NOT copy `<context>`, `<rules>`, `<project_context>` blocks into the artifact
  - These guide what you write, but should never appear in the output

**Guardrails**
- Create ALL artifacts needed for implementation (as defined by schema's `apply.requires`)
- Always read dependency artifacts before creating a new one
- If context is critically unclear, ask the user - but prefer making reasonable decisions to keep momentum
- If a change with that name already exists, ask if user wants to continue it or create a new one
- Verify each artifact file exists after writing before proceeding to next

## Enriched tasks (§12.10)

When creating `tasks.md`, follow `doc/byebyevibe-guide.md` §12.10:

- **Gate** (required): deterministic shell command per verifiable task; exit 0 = done
- **Pattern** (recommended for code): repo-relative path to existing file; confirm it exists before finalize
- **Skill** (cross-repo or long patterns): `- **Skill:** <name>` instead of `repo:path` in tasks
- Max **15 lines** of code per task; longer patterns → skill or archived change reference
- **DOCS_SPECS profile:** `Pattern` only within this repo; APP implementation belongs in the APP repo's OpenSpec change — not code tasks here
- If `scripts/verify-task-patterns.sh` exists, run it before completing propose

---

## Skill suggestion (domain-density detection)

During the conversation, watch for domain-density signals: the user cites a local law, norm, or technical table; states company-specific numbers or thresholds; **corrects you on a domain fact** (gold signal); re-explains or re-pastes previously provided material; or narrates a proprietary step-by-step method.

On recognition, offer the standard three-part message (never create a skill unprompted):

1. **Will:** "If we save this as a skill, future sessions recall it automatically whenever <topic> comes up."
2. **Won't:** "It does not update itself — if the law/number/method changes, you must ask to update it, or it will keep asserting stale data."
3. **Decide:** "Want me to create it? (yes / no / later)"

Cap: at most **one suggestion per session, shared across proactive mechanisms** — skill and tooling suggestions (`sdd-tooling-guidance`) draw from the same single slot, strongest signal wins; offer only, the user decides. If accepted, load the `sdd-skill-guidance` skill for creation hygiene (search-before-create, description diet, task-based naming, "verified on YYYY-MM" marker).

---

## Session Handoff

This phase is complete. **Suggestion: open a new chat** for the next phase (clean context).

Paste into the first message of the new chat:

---
/opsx:apply <change-id>

Change: openspec/changes/<change-id>/
Read: proposal.md, design.md, tasks.md, specs/
Infra: openspec/infra.md (assume ✅ — do not reinstall)
---
