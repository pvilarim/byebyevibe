# Design — SDD metrics script (G4: sdd-metrics.sh)

## Context

- Type E research `explore-oss-coverage-gaps` (2026-07-25), gap **G4**: no framework effectiveness data (rework, propose→archive time, post-archive fixes).
- Apache DevLake candidate: C1 🔴, C4 🔴 — measures organizational DORA, **not** SDD metrics per change-id. Decision: **Deferred**; prefer manual fix.
- `metodologia-insercao.md` §4.1: `sdd-metrics.sh` = mode **C** (on demand); §Phase 5 links adoption metrics to this script.
- `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G4 **Deferred** (DevLake); note "manual fix (`sdd-metrics.sh`) preferred".
- Structural precedent: `add-sdd-ci-gates-workflow` (G1) — pilot exception, 6-point registration, kit distribution without external binary/hook.
- Data already in the repo: `openspec/changes/archive/YYYY-MM-DD-<id>/`, Conventional Commits with change-id (R9), active changes in `openspec/changes/<id>/`.

### Phase 0 checks (summary)

| # | Check | Result |
|---|-------|--------|
| V1 | Already evaluated? | Yes — G4 evaluation Deferred (DevLake); this change adopts the recommended manual fix |
| V2 | Surface | Scripts (mode C) — no hook, MCP, CI step, or PreToolUse |
| V3 | Collision | No `sdd-metrics.sh` exists; name aligned with `sdd-session-*` / `sdd-upgrade-diff.sh` |
| V4 | Profile | APP, DOCS_SPECS, HYBRID — useful in all (local archive + git) |
| V5 | Hooks | N/A — no PreToolUse |
| F1 | Security | Bash + `git` only; no network, no tokens, no eval of MANIFEST `gate:` |
| F2 | License | Kit-owned script (same licensing as hub) |
| F3 | Governance | N/A — local artifact; DevLake remains deferred with re-evaluation condition |
| F4 | Reversibility | Remove script + MANIFEST entry disables; no residual state |
| F5 | Operability | Manual invocation; `--help`; readable markdown output (2/3) |

## Goals / Non-Goals

**Goals:**

- Script `scripts/sdd-metrics.sh` that prints a markdown report with the three metric families from G4 research.
- Distribution via `sdd-kit/templates/scripts/` + MANIFEST bump **1.5.0 → 1.6.0**.
- Full registration in the 6 points (R3 = N/A).
- Pilot dispensable (Phase 2 exception — no external binary/hook/service/LLM).
- Deterministic proxies anchored in git + filesystem (no LLM, no mandatory GitHub API).

**Non-Goals:**

- Adopt Apache DevLake, Grafana, MySQL, or any DORA stack.
- Make the script a CI gate (mode A) — remains on demand (mode C).
- Always-on skill or rule (R3 N/A).
- Per-tool counters (Probity, OSV, reviews) — future extension when Phase 5 methodology requires it.
- Calendar precision of "propose session" vs "first commit" — accept documented proxy.
- Web dashboard or history persistence beyond stdout/optional file.

## Knowledge sources consulted (R8)

- `openspec/changes/explore-oss-coverage-gaps/research.md` §G4 — DevLake deferred; script `sdd-metrics.sh`
- `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` — Phases 0–3, mode C, 6-point contract, Phase 5 metrics
- `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` — G4 Deferred; DevLake re-evaluation condition
- `openspec/changes/archive/2026-07-26-add-sdd-ci-gates-workflow/{proposal,design,tasks}.md` — G1 precedent / pilot exception
- `scripts/sdd-session-status.sh`, `scripts/sdd-upgrade-diff.sh` — kit bash style
- `sdd-kit/MANIFEST.yaml` v1.5.0 — pattern for `scripts/*` entry + documentary `gate:`
- `AGENTS.md` R9 — change-id in commits (rework proxy basis)
- `openspec/infra.md` — R10; do not reinstall infra

## Decisions

### D1: Mode C — on demand (not CI)

| Criterion | Mode C (chosen) | Mode A (CI scheduled) |
|-----------|-----------------|------------------------|
| Research alignment | ✅ matrix §4.1 | ❌ "outside pipeline" but CI adds noise |
| CI cost | ✅ zero | minutes + artifact to maintain |
| Audience | Human in retrospective | Bot |

**Rationale:** methodology and evaluation place metrics as a user command (periodic/retrospective), not a pipeline step.

### D2: Data sources — git + local filesystem only

**Choice:** read `openspec/changes/` (active), `openspec/changes/archive/` (archived), and `git log` / `git log --grep`.

**Discarded alternative:** GitHub API / `gh` for PR lead time — useful but outside the minimum; would fail in repos without GitHub or cloud agents without auth.

### D3: Metric definitions (proxies)

| Metric | Operational definition | Output |
|--------|------------------------|--------|
| **M1 — Volume** | Count of dirs in `openspec/changes/<id>/` (excl. `archive/`, `_template`) and in `openspec/changes/archive/YYYY-MM-DD-<id>/`; optional `--since YYYY-MM-DD` filter on archive date (or mtime/`git log` for active) | Table: active / archived in period |
| **M2 — Lead time propose→archive** | For each archive `YYYY-MM-DD-<change-id>`: `t_end` = dir prefix date; `t_start` = date of **first** commit whose subject/body contains the `change-id` (fallback: date of first commit that added `openspec/changes/<id>/proposal.md` if traceable in history); lead = `t_end - t_start` in days | List per change + median/p50 and mean |
| **M3 — Post-archive rework** | Commits **after** `t_end` whose subject matches `^fix(\|:)` **and** mentions the archived `change-id` (R9) | Count per change-id + total |
| **M4 — Post-archive activity** | Subset of M3 **or** post-`t_end` commits touching paths under the archived dir (if still referenced); report M3 as primary proxy for "changes fixed post-archive" | Dedicated report section |

**Honesty notes (document in report and guide §2.17):**

- M2 is a proxy: the real "propose" may precede the first commit (chat-only); or the change-id may only appear in the archive commit.
- M3 depends on R9 discipline; commits without change-id do not count (undercount).
- Archive date in the dir name is the canonical source of `t_end` (OpenSpec convention of this hub).

### D4: CLI interface

```bash
bash scripts/sdd-metrics.sh [--since YYYY-MM-DD] [--output PATH] [--help]
```

| Flag | Behavior |
|------|----------|
| (default) | Markdown report on stdout; considers entire archive |
| `--since` | Filters archives with folder date ≥ date; rework commits also limited to period when applicable |
| `--output PATH` | Besides stdout, writes the same markdown to `PATH` |
| `--help` | Usage and metric definitions (one screen) |

Exit codes: `0` = report generated (including empty archive); `2` = invalid usage; no network dependency.

### D5: Implementation — pure bash + git

**Choice:** bash (`set -euo pipefail`) + `git` only — parity with `sdd-session-*` / `verify-*.sh`. No mandatory Python/jq.

**Discarded alternative:** Python for parsing — acceptable in the stack, but increases surface; bash suffices for grep/awk of dir names and `git log --format`.

Sketch structure (apply fills in):

```bash
#!/usr/bin/env bash
# sdd-metrics.sh — SDD effectiveness report (G4), mode C
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# parse flags → list archives → compute M1–M4 → emit markdown
```

### D6: Kit distribution + MANIFEST bump

| Item | Value |
|------|-------|
| Path | `scripts/sdd-metrics.sh` |
| Source | `templates/scripts/sdd-metrics.sh` |
| merge | `COPY` |
| profiles | `[APP, DOCS_SPECS, HYBRID]` |
| gate (documentary) | `test -x scripts/sdd-metrics.sh` |
| version | **1.5.0 → 1.6.0** (new capability) |
| guide_version | align **1.6.0** if guide changelog rises in the same apply |

Run `bash sdd-kit/gen-manifest-checksums.sh` after creating the template.

### D7: R3 N/A — discovery via AGENTS.md

Same as G1/G8: ≤10 lines in Commands + Integrations; no skill. Anti-pattern: always-on rule for an on-demand tool.

### D8: Pilot dispensable

Phase 2 exception criteria: no new binary, hook, service, or LLM. Local bash script = same class as `sdd-session-status.sh`. Apply validation: run the script in the hub and confirm exit 0 + markdown with M1–M4 sections.

### D9: G4 evaluation — Adopted / Deferred split

| Candidate | Decision after this change |
|-----------|----------------------------|
| `sdd-metrics.sh` (manual fix) | **Adopted** — change `add-sdd-metrics-script` |
| Apache DevLake | **Deferred** (unchanged) — re-evaluate if team/DORA justifies |

## A–E matrix

| Task type | sdd-metrics.sh |
|-----------|----------------|
| A–E (during session) | Do not invoke — outside pipeline |
| Retrospective / calibration | User runs periodically |

No interactive step in explore/propose/apply/archive.

## Registration — 6-point contract (Phase 3)

| # | Where | Content |
|---|-------|---------|
| R1 | `openspec/infra.md` + template | Metrics line: script + `bash scripts/sdd-metrics.sh` |
| R2 | `AGENTS.md` + `AGENTS.core.md` | Commands + ≤10 lines Integrations / On-demand context (mode C, proxies, no DevLake) |
| R3 | — | **N/A** |
| R4 | `doc/sistema-sdd-pedro.md` **§2.17** | When to run, read output, proxies, troubleshooting, rollback |
| R5 | `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` | G4 script → Adopted; DevLake Deferred |
| R6 | `sdd-kit/` | Template script + MANIFEST 1.6.0 + checksums + verify if needed |

Post-registration: `graphify update .` + `npx gitnexus analyze --force` (best-effort; graphify may be ❌).

## Rollback

| Component | Rollback |
|-----------|----------|
| Script | Remove `scripts/sdd-metrics.sh` + kit template |
| MANIFEST | Remove entry; revert bump 1.6.0 → 1.5.0; regenerate checksums |
| Docs | Revert R1/R2/R4/R5 |

No state in `.sdd/`; no hooks; no services.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Imprecise M2 proxy (propose without early commit) | Document in report and §2.17; accept as order of magnitude |
| Inconsistent R9 → M3 undercount | Mention R9 dependency in `--help` and guide |
| Archive names without date prefix | Skip with WARN; hub convention is `YYYY-MM-DD-<id>` |
| Performance in huge monorepos | `git log --grep` per change-id; acceptable for typical SDD archive N |
| Temptation to adopt DevLake early | Evaluation keeps Deferred; explicit re-evaluation condition |

## Migration Plan

1. Apply creates script + template + MANIFEST + docs + specs.
2. C2 consumers: `upgrade.sh --dry-run` → `--apply` receives the script.
3. Operator: run `bash scripts/sdd-metrics.sh` in a retrospective.
4. No data migration.

## Open Questions

| Question | Proposed resolution |
|----------|---------------------|
| Guide section? | **§2.17** (§2.14–2.16 occupied) |
| Minor vs patch bump? | **Minor** 1.5.0 → 1.6.0 (new capability) |
| Include active changes in lead time? | No — M2 archived only (complete lead); active only in M1 |
| Optional `gh` for PR lead time? | Out of scope in this change |
