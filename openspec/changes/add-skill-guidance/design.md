## Context

ByeByeVibe targets operators with little or no AI-assisted-development experience. Skills are the control plane's most token-efficient memory mechanism (description always loaded, body on trigger, dense data in `references/`), but nothing today teaches novices when a skill helps, detects that a user is repeatedly teaching the agent the same domain facts, or protects against skill inflation. Explore merge `explore-skill-guidance` (D1–D10) settled the concepts; this design settles ownership and placement.

Current state relevant to placement:

- Kit-owned content precedent: `/opsx:help` ships as skill `openspec-help` + command mirrors under `sdd-kit/templates/` with MANIFEST checksums and gates (`sdd-kit/MANIFEST.yaml:275-287`).
- The `opsx` command wrappers (`.claude/commands/opsx/*.md`, `.cursor/commands/opsx-*.md`) already carry ByeByeVibe additions (Session Handoff blocks, §12.10 enriched tasks) — they are the accepted customization surface for phase workflows.
- Upstream OpenSpec-managed skills (`openspec-explore`, `openspec-propose`, `openspec-archive-change`) must not be patched (`sdd-operator-onboarding` non-goals precedent): `openspec update` overwrites them.
- Constraint: no always-on rule whose purpose is injecting guidance into every session (`sdd-operator-onboarding` non-goals).

## Goals / Non-Goals

**Goals:**

- Single plain-language source of truth for skill guidance, narrated by `/opsx:help`.
- Agent-side conversational detection active during explore/propose without patching upstream skills or adding always-on rules.
- Standard three-part suggestion message (will / won't / user decides) with a one-per-session cap.
- Archive-time repetition question (rule of three).
- Creation hygiene applied automatically when the agent creates a skill for the user.
- Everything shipped dual-surface (`.claude/` + `.cursor/`) via kit templates + MANIFEST.

**Non-Goals:**

- v2 tooling: M5 skill-load metric, usage telemetry hook, `/opsx:harvest`, stack seed skills (annotated only).
- Org-level domain-skill library (v3 / separate initiative).
- Mechanical enforcement of the suggestion cap or description budgets (instructional in v1).
- Patching `openspec-explore` / `openspec-propose` / `openspec-archive-change` skill bodies.

## Decisions

### 1. Content home: new section in `doc/sdd-operator-day1.md`

Full signal catalog, litmus test, skill/spec/project.md boundary, standard message template, hygiene checklist, and lifecycle framing (create → measure → prune) live in one day-1 doc section. `/opsx:help` narrates it (already the pattern for every other day-1 topic).

*Alternative considered:* separate `doc/skill-guide.md` — rejected: fragments the day-1 map and adds a second doc for `/opsx:help` to narrate; the audience is the same novice operator.

### 2. Operational vehicle: kit-owned skill `skill-guidance` (mirrors the `openspec-help` pattern)

A new kit skill at `sdd-kit/templates/.claude/skills/skill-guidance/SKILL.md` + `.cursor/skills/skill-guidance/SKILL.md` holds the agent-facing procedure: recognize signals → emit the standard message (≤1/session) → on acceptance, create the skill via the hygiene checklist (search-before-create → extend; description diet; task naming; `references/` for dense data; staleness marker for volatile data). Its frontmatter description is tuned to trigger on domain-density moments (user corrects a domain fact, cites local regulation, states company thresholds, re-explains prior material).

*Alternatives considered:* (a) always-on rule in `.cursor/rules/` — rejected: violates non-goals, charges every session; (b) patching upstream explore/propose skills — rejected: `openspec update` overwrites, ownership collision; (c) day-1 doc alone — rejected: passive text a novice never reads is not a detection mechanism.

### 3. Activation: thin clauses in the `opsx` command wrappers

Explore and propose wrappers gain a short block (≤8 lines): the signal list in one line each, plus "when you notice these, follow skill `skill-guidance` / day-1 doc §skills; at most one suggestion per session; offer, never impose." The archive wrapper gains one confidence question line ("did anything in this change repeat a procedure or explanation from a previous change? rule of three"). Precedent: Session Handoff and §12.10 blocks already live in these wrappers. Clauses stay thin so re-applying them after an upstream wrapper regeneration is cheap; the full content lives in the skill + doc (Decision 1–2), giving two independent activation paths (wrapper clause and skill trigger).

### 4. Suggestion cap and hygiene are instructional in v1

The one-per-session cap and description-diet rules are stated in the skill and message template, not enforced by code. Mechanical enforcement (usage logs, metrics, thresholds) is exactly the v2 scope and depends on telemetry that Cursor cannot provide today (no `PostToolUse` equivalent) — deferring keeps v1 text-only and dual-surface symmetric.

### 5. Delivery and integrity

New templates registered in `sdd-kit/MANIFEST.yaml` with grep-able gates (pattern of `MANIFEST.yaml:275-287`); checksums regenerated via `bash sdd-kit/gen-manifest-checksums.sh`. Hub gets the same content applied directly (`.claude/`, `.cursor/`, `doc/`). Evaluation stub under `doc/avaliacoes/` records the insertion (methodology R5) and the ownership note: if upstream OpenSpec later ships native skill-suggestion, the kit skill yields (same posture as the `/opsx:help` vs future upstream `help` note).

## Risks / Trade-offs

- [Upstream regeneration wipes wrapper clauses] → clauses are thin and duplicated as kit templates; MANIFEST gates (grep) detect the drift; skill-trigger path still works meanwhile.
- [Suggestion fatigue for novices] → one-per-session cap + offer-only posture stated in both the skill and the wrapper clause.
- [Guidance skill mis-triggers on ordinary technical talk] → description tuned to *user-taught* domain knowledge (corrections, local norms, proprietary thresholds), not general technical vocabulary; refined during apply and evaluable later.
- [Stale domain skills asserting outdated data] → staleness marker required at creation; monitoring deferred to v2 (accepted gap, documented).
- [Instructional cap is not enforceable] → accepted for v1; v2 telemetry makes it measurable before making it mechanical.

## Migration Plan

Docs/templates only — no scripts, hooks, or binaries. Deploy = merge + run `bash sdd-kit/gen-manifest-checksums.sh`. Rollback = revert commit. Pilot: waived candidate (metodologia Phase 2 exception, same class as the `/opsx:help` change).

## Open Questions

- Exact frontmatter description wording for `skill-guidance` trigger precision — tune during apply; candidates recorded in the evaluation stub.
- Whether the archive confidence question should also appear in the upstream-managed `openspec-archive-change` skill's kit mirror or only in the wrapper — resolve during apply by inspecting which surface the operator actually sees at archive time.
