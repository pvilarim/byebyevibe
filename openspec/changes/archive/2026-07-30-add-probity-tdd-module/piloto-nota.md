# Pilot note — Probity (G2)

| Field | Value |
|-------|-------|
| **Date** | 2026-07-26 |
| **Change** | `add-probity-tdd-module` |
| **Apply environment** | Cloud Agent — DOCS_SPECS hub (`gitnexus-graphify-openspec`) |
| **Status** | **PILOT PENDING** (did not fail — blocked by missing APP worktree) |

## Context

Phase 2 (`metodologia-insercao.md`) requires a pilot in an **APP worktree** with Vitest or pytest, C1 + GitNexus + Graphify active, **before** promoting Probity as default-ready in consumer repos.

This hub is **DOCS_SPECS** profile (no production test runner). This apply's cloud environment **does not** have an APP worktree available (`git worktree list` = master only).

## Criteria (design.md — unchanged)

| Criterion | Threshold |
|----------|-----------|
| PreToolUse extra p95 latency | < 8s (N≥30 edits, 3 hooks) |
| Type C false positives | < 15% (N≥5 sessions) |
| Type B R6 compliance | 100% (N≥3 sessions) |
| Cursor IDE hooks | Write/Edit fire **OR** document "Claude Code only" |

## What this apply does / does not do

| Does | Does not |
|-----|---------|
| sdd-kit scaffolding (script, `probity.config.ts` template, doc 004) | Activate Probity in this hub |
| 6-point contract registration + TDD Guard → Probity migration | Measure p95 / false positives in a real session |
| MANIFEST entries `profiles: [APP, HYBRID]` with pilot-pending note | Declare pilot green / "Adopted" without restriction |

## Next step (APP operator)

```bash
# In an APP worktree with Vitest or pytest:
bash sdd-kit/install-probity-module.sh --detect
bash sdd-kit/install-probity-module.sh --apply --yes
/plugin marketplace add nizos/probity
/plugin install probity@probity
# Measure criteria above; update this note + G2 evaluation → Adopted
```

If criteria fail → G2 status **"Deferred"**; rollback with `--uninstall`; do not promote default activation in consumers.
