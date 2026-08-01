# Consolidate archive closing questions

## Why

The archive workflow (step 4b of `openspec-archive-change`) fires three sequential, near-identical closing questions on every archive — pattern promotion, repetition (rule of three), and manual-work/tooling gap — on top of the confirmation prompts from steps 2–4. Operators experience this as the agent "asking the same question over and over"; reflexive "no" answers destroy the signal value the questions were designed to harvest. The original design evaluations anticipated exactly this failure mode ("question becomes ceremony", `doc/avaliacoes/2026-08-01-skill-guidance.md`; "extra confidence question adds friction", `doc/avaliacoes/2026-08-01-tooling-guidance.md`) and prescribed "one line in the existing confidence list, never blocks" — the skill implementation drifted into three interactive prompts. This change restores the evaluated intent and aligns archive-time behavior with the existing anti-noise principle (one proactive suggestion per session, offer-only, strongest signal wins).

## What Changes

- Rewrite step 4b of the archive skill/command in all four mirrors (`.claude/skills/openspec-archive-change/SKILL.md`, `.claude/commands/opsx/archive.md`, `.cursor/skills/openspec-archive-change/SKILL.md`, `.cursor/commands/opsx-archive.md`) to a **consolidated closing assessment**:
  - The agent **self-assesses** the three items (reusable pattern, repetition per rule of three, tooling gap) against evidence from the change it just implemented (e.g. grep `openspec/changes/archive/` for similar prior changes, recall of manual narration in-session).
  - The agent **always prints** a compact per-item verdict in the archive summary (satisfies "surfaces the question" / "reminds the operator").
  - **Only when ≥1 item has a positive signal**, the agent presents **one** consolidated prompt (AskUserQuestion with multiSelect on Claude Code; plain-text chat question on Cursor — documented surface asymmetry).
  - The assessment never blocks the archive.
- Update the archive-time question requirements in `sdd-skill-guidance` and `sdd-tooling-guidance` specs from "workflow surfaces a confidence question" to "workflow surfaces an agent-evaluated assessment, prompting only on positive signal".
- Update the pattern-promotion checklist requirement in `sdd-task-patterns` to the same consolidated-assessment register.
- Update the kit templates `sdd-kit/templates/{.claude,.cursor}/skills/sdd-skill-guidance/SKILL.md` (the "At archive time, the workflow asks…" sentence) and regenerate `sdd-kit/MANIFEST.yaml` checksums.

Out of scope: merging the step 2/3 confirmation prompts (incomplete artifacts / incomplete tasks) into one — noted as a possible follow-up; `doc/sdd-operator-day1.md` §6 stays unchanged (operator self-check copy-paste list, different register, no agent friction).

## Capabilities

### New Capabilities

_None._

### Modified Capabilities

- `sdd-skill-guidance`: "Archive-time repetition question" becomes an agent-evaluated item inside a consolidated closing assessment — always-printed verdict, single conditional prompt, non-blocking.
- `sdd-tooling-guidance`: "Archive-time manual-work question" becomes an agent-evaluated item inside the same consolidated assessment — same register, non-blocking.
- `sdd-task-patterns`: "Post-archive pattern promotion checklist" becomes an agent-evaluated item inside the same consolidated assessment — printed reminder preserved, prompt only on positive signal.

## Impact

- **Files**: 4 archive skill/command mirrors; 3 spec deltas; 2 kit templates (`sdd-kit/templates/{.claude,.cursor}/skills/sdd-skill-guidance/SKILL.md`); `sdd-kit/MANIFEST.yaml` checksums (via `bash sdd-kit/gen-manifest-checksums.sh`).
- **Behavior**: archive drops from up to 5–6 interactive prompts to at most 2 (change selection when ambiguous + one conditional closing prompt); clean archives complete with zero closing prompts.
- **No code/APIs affected** (DOCS_SPECS repo — skill text, specs, and kit templates only).
- **Risk**: agent false negatives on the self-assessment; mitigated by the always-printed verdict (operator can override) and by the evidence-gathering instruction (archive folder scan).
