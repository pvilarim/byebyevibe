# Evaluation: OSS tools for SDD coverage gaps

| Field | Value |
|-------|--------|
| **Date** | 2026-07-25 |
| **Evaluator** | Explore session `explore-oss-coverage-gaps` (Cloud Agent) |
| **Candidate** | 8 gaps × OSS candidates — detail in [`openspec/changes/explore-oss-coverage-gaps/research.md`](../../openspec/changes/explore-oss-coverage-gaps/research.md) |
| **Decision** | Mixed — see per-item table |
| **Scope** | sdd-kit extension + targeted stack corrections |

## Executive summary

Type E research identified 8 gaps in SDD system coverage for AI-assisted development and evaluated OSS candidates against 5 criteria (installation, compatibility, overlap, fit with explore→propose→apply flow, reliability/community). Standardized insertion methodology defined in [`metodologia-insercao.md`](../../openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md) (6 phases; pilot dispensable for insertions without new binary/hook — exception approved 2026-07-25).

## Decisions by item

| Gap | Candidate | Decision | Note |
|-----|-----------|----------|------|
| G1 CI enforcement | GitHub Actions (custom workflow) | **Adopted** — change [`add-sdd-ci-gates-workflow`](../../openspec/changes/archive/2026-07-26-add-sdd-ci-gates-workflow/proposal.md) (2026-07-25) | pre-commit/Lefthook **discarded** — overlap with graphify/gitnexus hooks. Workflow `.github/workflows/sdd-gates.yml` + template in sdd-kit v1.4.0 |
| G2 Test verification | [Probity](https://github.com/nizos/probity) (`@nizos/probity@1.10.0`) | **Adopted — change [`add-probity-tdd-module`](../../openspec/changes/add-probity-tdd-module/proposal.md), pilot pending** | TDD Guard **superseded** by Probity (2026-07). APP pilot mandatory (p95/hooks) — see `piloto-nota.md` |
| G3 Runtime feedback | GlitchTip / Sentry + MCP | **Deferred** — on-demand module | Per-project production infra, not kit payload |
| G4 Framework metrics | `sdd-metrics.sh` (manual fix) | **Adopted** — change [`add-sdd-metrics-script`](../../openspec/changes/add-sdd-metrics-script/proposal.md) | Local mode C script (git + archive). **Apache DevLake remains Deferred** — does not measure SDD metrics by change-id; re-evaluate if team/DORA justifies |
| G5 Issue traceability | [github-mcp-server](https://github.com/github/github-mcp-server) | **Adopted** — change [`add-github-mcp-issue-traceability`](../../openspec/changes/archive/2026-07-26-add-github-mcp-issue-traceability/proposal.md) | Passive MCP (mode D) + `**Issue:**` field in proposal template. Re-evaluation: if AGENTS.md instruction exceeds 10 lines → dedicated skill; if project migrates off GitHub Issues → evaluate Linear/Jira MCP |
| G6 Distributed multi-agent | Vibe Kanban / Claude Squad | **Discarded** | Lead project orphaned (BloopAI closed 04/2026); overlap with `sdd-session-*` |
| G7 Correctness review | [PR-Agent](https://github.com/qodo-ai/pr-agent) | **Adopted** — local skill created, change [`add-correctness-review-skill`](../../openspec/changes/add-correctness-review-skill/proposal.md) | Phase 1: local skill `correctness-review` (`.claude/skills/` + `.cursor/skills/`). PR-Agent optional (Phase 2, separate change). Re-evaluation: conversion to autonomous subagent (pilot mandatory), PR-Agent phase 2 adoption (Jan/2027). |
| G8 Supply chain | [Renovate](https://github.com/renovatebot/renovate) + [OSV-Scanner](https://github.com/google/osv-scanner) | **Adopted** — change [`add-supply-chain-gates`](../../openspec/changes/add-supply-chain-gates/proposal.md) | Templates by profile in sdd-kit; OSV in `sdd-gates.yml`; Renovate AGPL-3.0 (tool use OK). Re-evaluate workflow composition when PR-Agent G7 phase 2 enters CI. |

## Re-evaluation conditions (discarded/deferred items)

- **CI gates G1 (adopted):** re-evaluate `sdd-gates` workflow composition when OSV-Scanner/Renovate (G8) or PR-Agent (G7) enter CI — new steps go *inside* this workflow or as parallel jobs, decision in the respective change.

- **Vibe Kanban (G6):** re-evaluate in ~6 months (2027-01) — multi-agent orchestrator category consolidating; or if real multi-machine coordination need arises.
- **DevLake (G4):** remains **Deferred**. Manual fix `sdd-metrics.sh` was **Adopted** (`add-sdd-metrics-script`). Re-evaluate DevLake only if production repos gain CI/CD + team scale that justifies DORA.
- **GlitchTip/Sentry (G3):** activate on demand per production project; convention to cite tracker issue in type B proposals already adopted via `**Issue:**` field (change `add-github-mcp-issue-traceability`).
- **github-mcp-server (G5):** re-evaluate if AGENTS.md instruction exceeds 10 lines (promote to skill) or if the project migrates off GitHub Issues to another tracker.

## References

- Full research (sources, community metrics, criteria matrix): `openspec/changes/explore-oss-coverage-gaps/research.md`
- Insertion methodology (phases, registration at 6 points, activation matrix): `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`
- PR: [#21](https://github.com/pvilarim/gitnexus-graphify-openspec/pull/21)
