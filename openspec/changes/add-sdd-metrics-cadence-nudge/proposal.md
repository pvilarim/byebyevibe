## Why

The `sdd-metrics.sh` script (G4, mode C) already materializes SDD effectiveness measurement, but **passive discovery ≠ habit**: without an interpretation playbook and without cadence, the report does not close the loop “numbers → improve the framework”. The exploration concluded that the main gap is (1) how to act on M1–M4 and (2) a periodic reminder anchored in SDD cycles (archives), with calendar staleness only as a safety net — without an always-on rule or a mandatory pipeline step.

**Objective:** formalize playbook + cadence nudge (event-driven on archive + 30d stamp), keeping mode C opt-in.

**Prerequisite:** apply/archive of `add-sdd-metrics-script` (script + §2.17 + `sdd-metrics` spec in the hub). This change **extends** G4; it does not replace it.

## What Changes

- **Interpretation playbook** in `doc/sistema-sdd-pedro.md` §2.17: table “if M1/M2/M3/M4 then → 1 concrete SDD process adjustment”; minimal ritual (1 insight → 1 change).
- **Local stamp** `.sdd/metrics-last-run` (gitignored): written when the operator runs `sdd-metrics.sh` (or an explicit flag); used only to compute staleness.
- **Advisory nudge in the `/opsx:archive` Session Handoff**: if ≥ N archives since the last run **or** ≥ 30 days without a run → suggest `bash scripts/sdd-metrics.sh` + pointer to the playbook; **never** auto-execute; **never** block archive.
- **Documented thresholds** (defaults: N=5 archives, T=30 days) — adjustable via constants in helper/docs, without a CI gate.
- **Non-goals:** always-on rule; skill that suggests metrics in every chat; cron/CI scheduled spam; making metrics a mandatory apply/archive step; Apache DevLake.

## Capabilities

### New Capabilities

- _(none — extension of G4 / existing handoffs)_

### Modified Capabilities

- `sdd-metrics`: normative interpretation playbook; last-run stamp; cadence thresholds; report/command remains mode C opt-in.
- `sdd-session-handoff`: post-archive Session Handoff MUST include a metrics nudge when cadence thresholds are met (advisory, non-blocking).

## Impact

- Modified: `doc/sistema-sdd-pedro.md` §2.17 (playbook + cadence)
- Modified: `scripts/sdd-metrics.sh` (+ kit template) — write stamp to `.sdd/metrics-last-run` after successful run
- New (small): helper or shared logic for “should nudge?” (archives since stamp / stamp age) — prefer minimal bash reused by the archive skill
- Modified: `openspec-archive-change` skills (`.claude/` + `.cursor/`) — Session Handoff section with conditional nudge
- Modified (light): `AGENTS.md` / template — 1–3 lines about cadence + playbook (no new always-on skill; R3 remains N/A for metrics as a tool)
- Possible: `.gitignore` already covers `.sdd/` — confirm; no secrets in the stamp
- Specs: deltas in `openspec/specs/sdd-metrics/` and `sdd-session-handoff/`
- **Merge dependency:** `add-sdd-metrics-script` applied in the hub before this apply
- **Issue:** —
