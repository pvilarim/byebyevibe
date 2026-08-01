# Research — skill guidance for novice operators (explore merge)

**Explore session:** 2026-08-01 · **Status:** merged into proposal `add-skill-guidance`
**Scope question:** should ByeByeVibe teach/detect/suggest user-created skills, and how to keep that safe for operators with little or no AI-assisted-development experience?

## Context

- The kit already ships skills as a delivery mechanism (`openspec-help` under `.claude/skills/` and `.cursor/skills/`) and a post-install tip (`print_day1_operate_tip`, `sdd-kit/install.sh:372`) that points to `/opsx:help` → `/opsx:onboard`.
- `scripts/sdd-metrics.sh` already implements an advisory cadence pattern: stamp file `.sdd/metrics-last-run`, nudge at N=5 archives or T=30 days (§2.17), mode C, exit codes only.
- Spec `sdd-operator-onboarding` forbids always-on tutorial rules and forced end-of-install menus (non-goals requirement).

## Decisions

### D1 — Skills are procedural memory; three kinds with different lifecycles

| Kind | Example | Origin | Lives |
|------|---------|--------|-------|
| Workflow | `openspec-help` | sdd-kit (already shipped) | per project |
| Project/stack | "tests run with `pnpm test --filter X`" | constitution + repetition across changes | per project |
| Domain | residential feasibility study method for Recife-PE | the business / expert interview | transcends the project (org library — out of scope v1/v2) |

### D2 — Corrected premise: do not ask users to write skills before development

Skills written on day 0 of a new project are speculative (documentation analog of speculative abstraction). Good skills crystallize from repetition. Day 1 teaches the habit; the system detects and suggests later. Exception: kit-shipped workflow skills and (v2) stack seed skills derived from `project.md` — templates with project-specific slots, never generic stack essays (the model already knows the stack generically).

### D3 — Token model: progressive disclosure, deferred not eliminated

Every installed skill charges its frontmatter description to **every** session (~30–80 tokens well-written; 200–400 when bloated). Bodies load only on trigger; dense data belongs in `references/` (loads only when consulted). Skills beat always-on rules / giant CLAUDE.md on cost, but 50 bloated skills ≈ 15k fixed tokens/session.

### D4 — Three detection points, ordered by cost and availability

1. **Conversation** (explore/propose sessions) — agent-side recognition of domain-density signals; available from day 1; text-only to build.
2. **Archive** — one confidence question per closed change ("did anything here repeat a procedure from a previous change?"); rule of three (1st = normal, 2nd = note, 3rd = extract).
3. **Cadence** (v2) — ride the existing N=5/T=30 stamp pattern; deterministic script decides *when* to look, agent decides *what* it sees across the last N archives (mechanical text similarity is too weak for "same procedure written differently").

Conversational signals catalog: user cites local law/norm/table; user states company-specific numbers or thresholds; **user corrects the agent about a domain fact (gold signal — witnessed knowledge gap)**; user says "as I already explained" / re-pastes the same reference; user narrates a step-by-step method of their own.

### D5 — Novice-first design inverts the pedagogy

Target operators cannot self-diagnose "I am being repetitive". Therefore: detection runs agent-side; the day-1 doc section exists for depth, but the real teaching mechanism is a well-formed suggestion at the right moment. Suggestion message has three fixed parts — what the skill **will** do / what it will **not** do (no self-updating) / user decides. Offer, never impose; at most one suggestion per session (anti-noise cap).

### D6 — Domain skills: litmus test and anatomy

Litmus test: *"would a competent generalist with internet access still get this wrong or do it differently than wanted?"* Persona alone ("act as an urban planner") ≈ zero value; value lives in local/volatile knowledge, proprietary methodology, and output format. Name skills after the task (`viabilidade-residencial-recife`), not the persona. Volatile-data skills need a "verified on YYYY-MM" marker — stale data delivered with confidence is worse than no skill.

### D7 — Skill inflation is a real risk; trigger degradation arrives before token pain

Two failure modes: (a) fixed token cost grows per session; (b) overlapping descriptions degrade trigger precision — wrong skill fires (loads a useless body) or none fires, and the novice concludes "skills don't work". (b) is the fatal one for this audience. Skills need the same lifecycle as code: **create → measure → prune**.

### D8 — Hygiene at creation (cheapest lever; v1)

- **Search before create:** extend an existing skill by default; new sibling skills are the exception.
- **Description diet:** 1–2 sentences saying *when to trigger*, never the content; knowledge goes in the body, dense data in `references/`.
- **Agent-routed creation:** the day-1 doc tells novices to ask the agent to create skills in the correct format rather than hand-writing SKILL.md.

### D9 — v2 tooling (annotated, not built in v1)

- **M5 "skill load" metric** in `sdd-metrics.sh` (bash-countable: skill count, estimated description tokens at chars/4, over-limit descriptions; advisory thresholds ~30 skills / ~4k tokens — guesses to calibrate, not science).
- **Usage telemetry:** Claude Code `PostToolUse` hook on the Skill tool appending to `.sdd/skill-usage.log`; without it pruning is guesswork.
- **Bidirectional `/opsx:harvest`:** same cadence ceremony proposes new skills (repetition across archives) *and* pruning/merging (skills never fired in 60 days, overlapping descriptions).
- **Stack seed skills** derived from `project.md` at constitution time (single source of truth: project.md declares, skills operationalize).

### D10 — Dual surface: Claude Code and Cursor are both first-class

Creation, calibration, and monitoring guidance MUST ship for both `.claude/` and `.cursor/` mirrors (kit already dual-ships skills/commands). Known asymmetry: the v2 usage-telemetry hook is a Claude Code mechanism; Cursor has no equivalent hook surface today, so v2 design must define a per-surface telemetry strategy with a documented degradation path for Cursor (e.g., cadence-time agent self-report) instead of assuming parity.

## Non-goals (carried into proposal)

Always-on skill-suggestion rule; forced "write your skills first" step before development; generic stack-knowledge skills; org-level domain-skill library (v3 / separate initiative); building v2 tooling inside v1.

## Open questions for design (v2)

- Threshold calibration for M5 (skill count / token budget) — advisory numbers are initial guesses.
- Cursor-side telemetry mechanism (no PostToolUse equivalent).
- Whether `/opsx:harvest` is a kit skill or an extension of `sdd-metrics.sh` (leaning: separate skill; metrics stays pure bash).
