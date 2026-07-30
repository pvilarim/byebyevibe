## Context

- `add-sdd-metrics-script` (G4) introduces `scripts/sdd-metrics.sh` in **mode C**: on-demand M1–M4 report; R3 N/A; DevLake out of scope; §2.17 covers *when to run* and *how to read*, but **not** *how to act* or *when to remind*.
- Exploration (explore chat 2026-07-26): recommendation = interpretation playbook + event-driven cadence on `/opsx:archive` + 30d stale stamp; defer always-on skill and CI cron.
- Methodology (`metodologia-insercao.md`): out-of-band by default; anti-pattern = always-on rule for an on-demand tool; Phase 5 = continuous operation/re-evaluation tied to G4.
- `sdd-session-handoff`: phase skills already emit Session Handoff; archive is the natural moment (complete SDD cycle).
- Local runtime already uses `.sdd/runtime/` (gitignored) — precedent for stamp in `.sdd/`. **Note:** current `.gitignore` covers only `.sdd/runtime/`; this change MUST add ignore for `.sdd/metrics-last-run` (or broader `.sdd/`).

**Apply prerequisite:** `scripts/sdd-metrics.sh` and base §2.17 present in the hub (apply of `add-sdd-metrics-script`).

## Goals / Non-Goals

**Goals:**

- Normative playbook: map M1–M4 → concrete SDD process improvement actions (1 insight → 1 adjustment).
- Cadence: advisory nudge when ≥ **5** archives since the last run **or** ≥ **30** days without a run.
- Stamp `.sdd/metrics-last-run` updated on each successful script run (exit 0).
- Nudge only in the **archive** Session Handoff (and docs); mode C preserved — suggests, does not execute, does not block.

**Non-Goals:**

- Always-on `.mdc` rule or dedicated skill that suggests metrics in every chat.
- CI/cron job that auto-runs the script or opens issues (future phase only if nudge fails).
- Making metrics a `sdd-gates` gate or mandatory apply/archive step.
- Per-tool counters (Probity, OSV) — still future Phase 5.
- Apache DevLake.

## Knowledge sources consulted (R8)

- Explore session + recommendation: playbook + archive nudge + 30d stale
- `openspec/changes/add-sdd-metrics-script/{proposal,design}.md` — G4 mode C, §2.17, R3 N/A
- `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` §4.1 mode C, always-on anti-pattern, Phase 5
- `openspec/specs/sdd-session-handoff/spec.md` — mandatory Session Handoff
- `.claude/skills/openspec-archive-change/SKILL.md` — nudge insertion point
- `doc/sistema-sdd-pedro.md` §2.17 (G4 base) · §3.3 session coordination
- `.gitignore` / `.sdd/runtime/` — local stamp precedent

## Decisions

### D1: Playbook before any reminder mechanism

**Choice:** extend §2.17 with an “Interpret → act” section (M* → action table).

**Rationale:** without a playbook, nudge only produces dead reports. Docs-first; zero runtime risk.

### D2: Event-driven cadence (archives) + calendar staleness

| Signal | Default | Behavior |
|--------|---------|----------|
| Archives since last-run | ≥ 5 | Nudge in archive handoff |
| Stamp age | ≥ 30 days | Same nudge |
| No stamp (never ran) | — | Nudge after ≥ 5 archives **or** on the first archive opportunity if the operator never ran (treat “no file” as infinite stale) |

**Discarded alternative:** monthly cron only — disconnected from SDD cycles; more operational friction (CI/issue).

### D3: Stamp `.sdd/metrics-last-run` (not git)

**Format (proposal):** text file with ISO date `YYYY-MM-DD` on the first line (optional: second line = ISO datetime). Written by `sdd-metrics.sh` itself on the exit 0 path.

**Discarded alternative:** commit artifact in the repo — pollutes git; metrics are local/operator-scoped.

**Confirm:** `.sdd/` already gitignored in hub/kit.

### D4: Where “should nudge?” logic lives

**Choice:** small bash function/helper — preference:

1. Extend `sdd-metrics.sh` with subcommand or `--check-cadence` flag (exit 0 = quiet; exit 1 = nudge recommended; stdout = short message), **or**
2. Sibling script `scripts/sdd-metrics-cadence.sh` (check only).

**Apply preference:** **(1)** `--check-cadence` flag on the same script — less MANIFEST surface; R3 remains N/A.

Defaults N=5 and T=30 as constants at the top of the script (documented in the guide).

### D5: Nudge only in the archive skill (not propose/apply/explore)

**Choice:** update `## Session Handoff` in `openspec-archive-change` (`.claude/` + `.cursor/`): after successful archive, run `bash scripts/sdd-metrics.sh --check-cadence`; if exit ≠ 0, include advisory block in the handoff (command + §2.17 playbook link).

**Do not** alter explore/propose/apply handoffs (avoids noise).

### D6: R3 remains N/A

No new `sdd-metrics-review` skill. Discovery continues via AGENTS.md + guide; cadence = extension of the existing archive skill (always-loaded only when doing archive).

### D7: Pilot

Same class as G4 (local bash, no new binary/hook/LLM) → **pilot exception** applicable; validation = run `--check-cadence` + confirm handoff text in mental dry-run / gate grep.

### D8: Apply dependency

If `add-sdd-metrics-script` is not yet merged/applied in the hub, **pause** apply of this change until the script and base §2.17 exist.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Nudge ignored → metrics still dead | Playbook makes the “why” clear; re-evaluate monthly CI issue only if abandonment evidence |
| Counting “archives since last-run” imprecise | Count dirs in `openspec/changes/archive/` with folder date > stamp date (deterministic) |
| False nudge in repos with many historical archives and no stamp | No stamp: nudge only if there are ≥ N archives **with date ≥ (today − T days)** *or* single “never ran — baseline?” message on first post-install archive (document choice at apply: prefer “never ran ⇒ nudge if archives_in_last_T_days ≥ 1” for smooth onboarding) |
| Pollute Session Handoff (>15 lines) | Nudge ≤ 5 lines; core handoff intact |
| Operator runs metrics in another clone without shared stamp | Acceptable — stamp is per worktree/machine (like `.sdd/runtime/`) |

**Onboarding decision (no stamp):** if file absent **and** there is ≥ 1 archive with date prefix in the last T days → nudge “baseline recommended”; otherwise silence (fresh/inactive repo).

## Migration Plan

1. Merge/apply `add-sdd-metrics-script` in the hub (prerequisite).
2. Apply this change: playbook §2.17 → `--check-cadence` flag + stamp → archive skill → AGENTS 1–3 lines → spec deltas → kit checksums if template script changes.
3. C2 consumers: `upgrade.sh` receives updated script.
4. Rollback: revert archive skill + remove flag/stamp write; playbook docs may remain (harmless).

## Open Questions

| Question | Proposed resolution |
|----------|---------------------|
| N and T configurable via env? | Not in this change — constants in script; optional env in future |
| Mirror skill Claude only or Cursor too? | Both (kit/skills parity) |
| Bump kit 1.6.0 → 1.6.1 or 1.7.0? | **Patch 1.6.1** if G4 already released 1.6.0; otherwise include in same minor if joint apply |
| Count only archives in period T or all since stamp? | **Since stamp** (event-driven); T only for stamp age / onboarding |
