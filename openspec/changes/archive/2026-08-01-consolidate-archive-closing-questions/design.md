# Design — consolidate-archive-closing-questions

## Context

Step 4b of the archive skill was assembled by accretion: three separate changes (`sdd-task-patterns`, `add-skill-guidance`, `add-tooling-guidance`) each added an archive-time question, and the skill text implements them as three sequential "ask the operator" blocks. Combined with the step 2–4 confirmations, an archive can fire 5–6 interactive prompts. The system already has an anti-noise principle for proactive suggestions (shared one-per-session cap, offer-only — `sdd-skill-guidance` / `sdd-tooling-guidance`), but the archive questions were spec'd as unconditional prompts outside that principle. The design evaluations for both guidance capabilities prescribed "one line in the existing confidence list; never blocks" — the target state of this change.

Four mirrors carry the 4b text (`.claude/skills/openspec-archive-change/SKILL.md`, `.claude/commands/opsx/archive.md`, `.cursor/skills/openspec-archive-change/SKILL.md`, `.cursor/commands/opsx-archive.md`). The archive skill itself is **not** kit-managed (no `sdd-kit` template exists for it); the kit only references the archive question inside `sdd-kit/templates/{.claude,.cursor}/skills/sdd-skill-guidance/SKILL.md`.

## Goals / Non-Goals

**Goals:**

- Reduce archive closing interaction to at most one prompt, and to zero on a clean archive.
- Preserve the harvest value of the three questions by making the agent answer them with evidence instead of asking reflexive yes/no questions.
- Keep specs truthful: update the three requirements to describe the consolidated behavior.
- Keep both IDE surfaces working with documented asymmetry (no `AskUserQuestion` on Cursor).

**Non-Goals:**

- Merging the step 2/3 confirmations (incomplete artifacts / incomplete tasks) — possible follow-up, not required here.
- Changing `doc/sdd-operator-day1.md` §6 (operator self-check list; different register, no agent friction).
- Any telemetry or metrics for assessment accuracy (v2 territory per existing deferred non-goals).

## Decisions

### D1 — Agent-evaluated assessment, not operator interrogation

The agent self-assesses the three items using evidence available at archive time:

- **Reusable pattern**: did the change introduce a procedure/template used more than once or likely to recur? (source: the change's own tasks/design)
- **Repetition (rule of three)**: scan `openspec/changes/archive/` directory names and, when suggestive, skim matching `proposal.md` files for prior changes covering similar ground.
- **Tooling gap**: did the agent narrate manual steps for an unconfigured tool during this change's sessions? (source: session recall; `openspec/infra.md` `declined` rows suppress the item)

*Why over alternatives*: the agent has better evidence than the operator at the end of a long session; an always-asked question answered "no" by reflex yields less signal than a rare targeted one. Alternative (keep three prompts, merge into one multi-select always shown) rejected: still ceremony on every clean archive.

### D2 — Always-printed verdict, conditional single prompt

The assessment renders as three fixed lines in the archive summary (e.g. `Padrão reutilizável: não · Repetição: não · Gap de tooling: não` — English on English-language surfaces). Only when ≥1 item is positive does the agent present **one** consolidated prompt listing only the positive items plus a "none of these / proceed" option.

*Why*: the printed verdict keeps the spec language ("surfaces", "reminds") satisfiable with a minimal delta, and lets the operator override a false negative by replying in chat. Prompt-only-on-signal extends the existing anti-noise cap philosophy to archive time.

### D3 — Surface asymmetry: AskUserQuestion (multiSelect) on Claude Code, plain text on Cursor

Claude Code mirrors instruct `AskUserQuestion` with `multiSelect: true`; Cursor mirrors instruct a single plain-text chat question. Precedent: `sdd-tooling-guidance` "Dual-surface delivery with documented asymmetry".

### D4 — Three spec deltas, all MODIFIED

`sdd-skill-guidance` ("Archive-time repetition question"), `sdd-tooling-guidance` ("Archive-time manual-work question"), and `sdd-task-patterns` ("Post-archive pattern promotion checklist") are each rewritten to require: agent-evaluated item inside a consolidated closing assessment; always-printed verdict; single conditional prompt; non-blocking. `sdd-task-patterns` could arguably stay ("reminds the operator" is compatible with a printed line), but a delta keeps the three requirements in one consistent register.

### D5 — Kit touch limited to sdd-skill-guidance templates + checksums

Only the sentence "At archive time, the workflow asks: …" in `sdd-kit/templates/{.claude,.cursor}/skills/sdd-skill-guidance/SKILL.md` (and the installed repo copies `.claude/skills/sdd-skill-guidance/SKILL.md`, `.cursor/skills/sdd-skill-guidance/SKILL.md`) changes to describe the assessment. Checksums regenerate via `bash sdd-kit/gen-manifest-checksums.sh`. The archive skill mirrors are repo-local (not kit-managed), so no new kit entries are added.

## Risks / Trade-offs

- [Agent false negative — misses a repetition the operator would remember] → always-printed verdict is visible and contestable in chat; evidence instruction (archive scan) raises the floor; the questions were advisory and non-blocking before, so the worst case matches the previous "reflexive no".
- [Spec-wording strictness — "surfaces the question" read as "must prompt"] → the three deltas rewrite the requirements explicitly; `openspec validate --all --strict` in CI confirms delta shape.
- [Mirror drift — 4 archive copies + 2 guidance copies + 2 kit templates edited by hand] → tasks enumerate every file with per-file gates (`grep` for the new wording, absence of the old three-block wording); CI `sdd-gates` runs strict validation.
- [Cursor prompt has no structured multi-select] → accepted; plain-text question with the same option list, per documented asymmetry precedent.

## Migration Plan

Text-only change; no deploy steps. Rollback = revert the commit. Kit consumers pick up the guidance-template change on next `sdd-kit/upgrade.sh`; the archive behavior change reaches installed repos only through this repo (hub) since archive mirrors are not kit-shipped.

## Open Questions

- None blocking. Follow-up candidate recorded in proposal: merge step 2/3 confirmations into one combined summary prompt.
