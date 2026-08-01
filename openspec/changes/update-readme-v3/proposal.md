**Issue:** —

## Why

README v2 (change `update-readme-discovery-v2`, 2026-08-01) predates the two proactive gap-detection capabilities shipped the same day (`sdd-skill-guidance`, `sdd-tooling-guidance`), so the discovery surface never tells visitors the control plane notices its own memory and tooling gaps; and the "Compare (summary)" star table ages fast and duplicates the lasting evaluation doc — the operator decided (explore session 2026-08-01) to remove it.

## What Changes

- **Remove the "Compare (summary)" section** from the root README (heading, star table, intro line). The competitive evaluation doc stays linked from the Docs table — its "lasting research artifact" requirement is untouched. The "We compose OpenSpec; we don't replace it" positioning line moves to "Stack & companions".
- **Add a sixth "Gap-aware" value bullet** to "Why install this": the system notices repeated re-teaching of domain facts (offers a skill) and repeated manual narration of external-tool steps (offers a CLI/MCP integration) — offer-only wording, nothing created or installed unprompted.
- **Extend "Calibrate as you go"** with a short paragraph tying the three self-observation mechanisms together: metrics (process), skill suggestions (memory), tooling gap-check via `scripts/verify-infra.sh` (integrations). Same honest register — no ML/self-learning claims.
- **Spec delta** on `sdd-discovery-positioning`: section order drops Compare (v3); new requirement pins the gap-aware content to offer-only / no-ML framing so future edits don't oversell it.

## Capabilities

### New Capabilities

—

### Modified Capabilities

- `sdd-discovery-positioning`: the README section-order requirement no longer mandates a Compare section (evaluation doc link in Docs table becomes the required trace); ADDED requirement for gap-aware content with offer-only / no-ML constraints.

## Impact

- **Modified:** `README.md` (hub-only — not shipped in `sdd-kit/templates/`, so no MANIFEST/checksum work); delta on `openspec/specs/sdd-discovery-positioning/spec.md`
- **Non-goals:** removing or editing `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` or its index; new top-level README sections; changes to `doc/sdd-operator-day1.md` or kit surfaces; any wording that claims ML, self-learning, or auto-adaptation
- **Risks:** overselling the detection mechanisms (mitigated by the ADDED spec requirement pinning offer-only framing); spec/README divergence if Compare is removed without the delta (mitigated: delta ships in this change)
- **Pilot:** waived candidate (docs-only, hub-only)
- **Sources:** explore session 2026-08-01 (this branch); archived changes `2026-08-01-add-skill-guidance`, `2026-08-01-add-tooling-guidance`, `2026-08-01-update-readme-discovery-v2`; spec `sdd-discovery-positioning`
