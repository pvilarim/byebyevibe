# Evaluation: Tooling guidance — external-tool resolution cascade (CLI → MCP → manual)

| Field | Value |
|-------|--------|
| **Date** | 2026-08-01 |
| **Evaluator** | apply session for `add-tooling-guidance` (explore merge `explore-tooling-guidance`, D1–D12) |
| **Candidate** | `sdd-tooling-guidance` skill + R10 cascade + `verify-infra.sh` gap-check + day-1 §8 + `doc/tooling-install.md` (v1 guidance text + advisory script extension) |
| **Decision** | Adopted |
| **Scope** | C1 install (kit templates) + hub surfaces |

## Executive summary

Operators leaving vibe-code had no guidance on how the agent reaches external tools (CLI vs MCP vs manual narration), and nothing detected a missing integration or remembered a refused one. v1 adopts a normative resolution cascade (override → CLI → MCP → suggest → manual) anchored in R10, a static gap-check in `verify-infra.sh` (report absence, never infer need), a security-hardened offer-only suggestion message under the shared skill/tooling cap, and durable `declined` refusals in `openspec/infra.md`.

## Problem it tried to solve

- Agent silently narrates manual dashboard steps session after session — no loop closes the gap.
- MCPs suggested/installed without stating security surface (credentials, third-party server, prompt injection) or permanent per-session context cost.
- Declined integrations get re-suggested because nothing records the refusal.

## What was analyzed

- `openspec/changes/explore-tooling-guidance/research.md` (D1–D12)
- Archived change `2026-08-01-add-skill-guidance` (delivery pattern mirrored: dual-surface skill, day-1 section, archive question, kit templates)
- `doc/design/002-ui-module-install.md` (per-tool install-doc precedent)
- Specs `sdd-skill-guidance`, `sdd-workspace-manifest`, `sdd-operator-onboarding`, `sdd-install-kit`

## Fit with the SDD stack

| Tool | Relation |
|------|----------|
| OpenSpec | New capability spec `sdd-tooling-guidance`; deltas on `sdd-skill-guidance` (shared cap), `sdd-workspace-manifest` (R10 cascade, `declined`, gap-check), `sdd-operator-onboarding` (day-1 §8), `sdd-install-kit` (templates) |
| GitNexus | Unaffected — cascade governs external tools, not the code index |
| Graphify | Unaffected |
| AGENTS.md / sdd-kit | R10 gains the cascade sentence; kit ships both skill mirrors, `doc/tooling-install.md`, extended `verify-infra.sh` (MANIFEST + checksums) |

## Risks by workflow phase

| Phase | Risk | Notes |
|-------|------|-------|
| Explore | Suggestion fatigue with two mechanisms live | Shared one-per-session cap (strongest signal wins); static check does most detection silently |
| Propose | — | Cap note added to skill-suggestion sections only |
| Apply | Manual-paste false positives read as nagging | Paste caveat documented; static check primary; `declined` suppression |
| Archive | Extra confidence question adds friction | Non-blocking, same register as existing questions |

## Expected vs observed gains

| Advertised gain | Assessment |
|-----------------|------------|
| Cascade closes its own detection loop (second manual fall arms the suggestion) | Adopted as designed — no separate counter needed |
| Durable refusals stop re-suggestion | `declined` status + commented `.env.example` key convention; suppressed by gap-check |
| Security posture stated at suggestion time | Mandatory three-part message: never-install-unprompted, data scope, key location, trusted sources, MCP context cost |
| Install instructions survive drift | Official-link + verify-command + "verified on YYYY-MM" pattern in `doc/tooling-install.md` |

## Alternatives already in the stack

R10 already forced manifest reads before install actions, and preflight already stamped "MCP names (advisory)" — but neither stated a resolution order, detected repeated manual narration, nor recorded refusals. `sdd-skill-guidance` proved the suggestion pattern but covers knowledge gaps, not integration gaps.

## Decision and re-evaluation conditions

**Decision:** Adopted (v1 — guidance text + advisory report-only script extension; pilot waived).

**Deferred to v2** (reopen via a new OpenSpec change if v1 proves insufficient):

- Stack-inference gap analysis ("you use Supabase but have no Supabase tooling")
- Durable per-tool preference column in `infra.md`
- Per-tool usage telemetry (inherits the Cursor degradation problem from skills v2)
- Preflight-time gap WARNs

## References

- `openspec/changes/explore-tooling-guidance/research.md` (D1–D12)
- `openspec/changes/add-tooling-guidance/` (proposal, design, specs, tasks)
- `doc/tooling-install.md` · `doc/sdd-operator-day1.md` §8 · `openspec/infra.md` (Agent rule: `declined`)
