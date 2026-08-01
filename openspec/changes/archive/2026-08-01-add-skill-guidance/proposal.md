**Issue:** —

## Why

ByeByeVibe targets operators with little or no AI-assisted-development experience, yet the control plane's most token-efficient memory mechanism — skills — has no guidance surface: novices don't know when a skill helps (procedural, recurring, project- or domain-specific knowledge the model gets wrong) versus when it is pure cost (generic knowledge, naked personas), the system never detects that a user is repeatedly teaching the agent the same domain facts, and unguided skill creation risks inflation (fixed per-session description cost plus trigger-precision degradation from overlapping skills — the failure mode that makes novices abandon the mechanism). Closing explore merge `explore-skill-guidance` (2026-08-01, D1–D10).

## What Changes

**v1 (this change — text-only, no new tooling):**

- **Day-1 doc skill section:** new section in `doc/sdd-operator-day1.md` — when a skill helps and when it doesn't (litmus test in plain language), skill vs spec vs `project.md` boundary, agent-routed creation for novices, and the create → measure → prune lifecycle framing.
- **Conversational detection clause:** explore/propose kit surfaces gain instructions to recognize domain-density signals (user cites local law/norm/table; states company-specific thresholds; **corrects the agent on a domain fact** — gold signal; re-explains or re-pastes prior material; narrates a proprietary step-by-step method) and respond with the standard suggestion message.
- **Standard suggestion message:** fixed three-part format — what the skill **will** do / what it will **not** do (no self-updating; stale-data warning) / user decides. Offer, never impose; at most one suggestion per session.
- **Archive confidence question:** one line in the archive workflow — "did anything in this change repeat a procedure from a previous change?" (rule of three).
- **Creation hygiene rules:** search-before-create (extend existing skills by default), description diet (1–2 trigger-focused sentences; knowledge in body; dense data in `references/`), task-named not persona-named, "verified on YYYY-MM" marker for volatile domain data.
- **Dual surface:** all guidance text ships as both `.claude/` and `.cursor/` mirrors via `sdd-kit/templates/` + MANIFEST (kit already dual-ships skills/commands).
- **Evaluation stub** under `doc/avaliacoes/` (insertion methodology R5) indexed in `doc/avaliacoes/README.md`.

**v2 (annotated follow-up — NOT built here):** M5 skill-load metric in `sdd-metrics.sh` (count, estimated description tokens, advisory thresholds); usage telemetry (Claude Code `PostToolUse` hook logging to `.sdd/skill-usage.log`; Cursor lacks an equivalent hook — per-surface design with documented degradation path required); bidirectional `/opsx:harvest` riding the existing N=5/T=30 cadence (propose new skills from cross-archive repetition *and* prune/merge unused or overlapping ones); stack seed skills derived from `project.md`.

**v3 / out of scope:** organizational domain-skill library (skills that transcend a single project).

## Capabilities

### New Capabilities

- `sdd-skill-guidance`: novice-facing skill lifecycle guidance — when-to-create pedagogy, agent-side conversational detection signals, standard three-part suggestion message with anti-noise cap, archive confidence question, creation hygiene (search-before-create, description diet, references pattern, staleness marker), dual Claude Code + Cursor delivery, and v2 non-goals recorded as deferred requirements.

### Modified Capabilities

- `sdd-operator-onboarding`: day-1 doc gains the skill-guidance section; `/opsx:help` narrates it.
- `sdd-install-kit`: ship the new/updated guidance templates (both IDE surfaces) via `sdd-kit/templates/` + MANIFEST checksums.

## Impact

- **New:** skill-guidance section in `doc/sdd-operator-day1.md`; detection/suggestion clauses in kit explore/propose surfaces; archive confidence question; `doc/avaliacoes/` evaluation stub; spec `sdd-skill-guidance`
- **Modified:** `sdd-kit/templates/` (`.claude/` + `.cursor/` mirrors), `sdd-kit/MANIFEST.yaml` + checksums; day-1 doc; deltas on `sdd-operator-onboarding`, `sdd-install-kit`
- **Non-goals (v1):** always-on suggestion rule; forced "write skills first" pre-development step; generic stack-knowledge skills; any v2 tooling (M5 metric, usage hook, `/opsx:harvest`, seed skills); org skill library; more than one suggestion per session
- **Risks:** suggestion fatigue (mitigated by cap + offer-only posture); stale domain skills asserting outdated data (mitigated by staleness marker + will/won't message; monitoring lands in v2)
- **Checksums:** run `bash sdd-kit/gen-manifest-checksums.sh` when templates change
- **Pilot:** waived candidate (docs + inert guidance text — no new binary/hook in v1; metodologia Phase 2 exception)
- **Sources:** `openspec/changes/explore-skill-guidance/research.md` (D1–D10); `sdd-kit/install.sh` `print_day1_operate_tip`; `scripts/sdd-metrics.sh` §2.17 cadence pattern; specs `sdd-operator-onboarding`, `sdd-install-kit`
