# Research — OSS tools for SDD system gaps

| Field | Value |
|-------|-------|
| **Date** | 2026-07-25 |
| **Change** | `explore-oss-coverage-gaps` (type E — exploration) |
| **Objective** | For each gap identified in SDD system coverage (OpenSpec + GitNexus + Graphify), identify open-source projects on GitHub that fill the role and decide: **add to sdd-kit** vs **manual fix / point fix** vs **do not adopt now** |
| **Criteria** | 1. Installation complexity · 2. Compatibility with the existing system · 3. Functional overlap · 4. Fit with explore/propose/apply flow · 5. Reliability and community recognition |
| **Sources** | Web search 2026-07 (GitHub repos, npm registry, LFX Insights, ASF); specs and docs in this repo (`AGENTS.md`, `openspec/infra.md`, `doc/sistema-sdd-pedro.md`) |

## Executive summary — decision matrix

| # | Gap | Candidate tool | Recommended decision |
|---|-----|----------------|----------------------|
| G1 | Gate enforcement in CI | GitHub Actions (native) | **Manual fix** — workflow calling existing commands |
| G2 | Verification loop via tests | Probity (`@nizos/probity`) | **Add to kit** as optional module (APP/HYBRID profiles) — change `add-probity-tdd-module` |
| G3 | Runtime/production feedback | GlitchTip / Sentry + MCP | **Do not add to kit core** — document as on-demand module |
| G4 | Framework effectiveness metrics | Apache DevLake | **Manual fix** — script `sdd-metrics.sh`; DevLake only at team scale |
| G5 | Issue traceability | github-mcp-server (official) | **Hybrid** — MCP in `infra.md` + Issue field in proposal template |
| G6 | Distributed multi-agent coordination | Vibe Kanban / Claude Squad | **Do not adopt now** — high overlap + maintenance risk |
| G7 | Correctness review | PR-Agent | **Hybrid** — local skill first; PR-Agent as optional CI |
| G8 | Supply chain / dependencies | Renovate + OSV-Scanner | **Add to kit** — config templates by profile |

**Principle applied:** the sdd-kit is a minimal, versioned payload (MANIFEST 1.3.2). Only what (a) is installable by script without external infra, (b) does not duplicate an existing component, (c) has reliable maintenance enters the kit. Heavy infra (DevLake, Sentry) and orphaned projects (Vibe Kanban) stay out.

---

## Evaluation scale

- **C1 — Installation complexity:** 🟢 low (config/binary) · 🟡 medium (service/hooks) · 🔴 high (platform/infra)
- **C2 — Compatibility:** 🟢 fits existing mechanisms (MCP, hooks, scripts) · 🟡 requires adaptation · 🔴 conflicts
- **C3 — Overlap:** 🟢 zero overlap · 🟡 partial overlap · 🔴 duplicates a system component
- **C4 — Fit with explore/propose/apply flow:** 🟢 fits without friction · 🟡 requires new convention · 🔴 competing own flow
- **C5 — Community:** 🟢 established project, stable maintainers, broad adoption · 🟡 active but niche or governance in transition · 🔴 orphaned/stagnant

---

## G1 — Automated gate enforcement (CI)

**Problem:** all gates (openspec validate, A–E classification, R1–R11) depend on local discipline; nothing prevents merge without a pipeline.

**Candidates evaluated:**

| Tool | C1 | C2 | C3 | C4 | C5 |
|------|----|----|----|----|-----|
| GitHub Actions (own workflow) | 🟢 | 🟢 | 🟢 | 🟢 | 🟢 native GitHub |
| pre-commit (Python framework) | 🟢 | 🟡 | 🔴 | 🟡 | 🟢 12.3k ★, mature ecosystem |
| Lefthook (Go, parallel) | 🟢 | 🟡 | 🔴 | 🟡 | 🟡 4.3k ★, MIT, active |

**Analysis:** pre-commit and Lefthook are git hook managers — but the system **already has** local hooks (`graphify hook install`, GitNexus PreToolUse). Adding a third hook manager creates duplication (C3 🔴). Moreover, local hooks are bypassable with `--no-verify`; literature converges on enforcement belonging in CI. What is missing is not a tool — it is a **CI workflow** that runs commands already in the repo: `npx openspec validate`, `bash sdd-kit/verify.sh`, `bash scripts/verify-infra.sh`.

**Recommendation: manual fix.** Create `.github/workflows/sdd-gates.yml` (~30 lines) and add the template to `sdd-kit/templates/`. No new dependency.

---

## G2 — Verification loop via tests

**Problem:** R6 (failing test first) is a rule without enforcement; task completion is self-declared by the agent.

**Primary candidate: [Probity](https://github.com/nizos/probity)** (`@nizos/probity@1.10.0`)

> **Historical note:** the original candidate was [TDD Guard](https://github.com/nizos/tdd-guard); the maintainer declared it **superseded** by Probity (2026-07). New projects MUST adopt Probity; do not re-propose TDD Guard.

| Criterion | Evaluation |
|-----------|------------|
| C1 installation | 🟡 Claude Code plugin + `probity.config.ts` + `@nizos/probity@1.10.0` (no per test-runner reporters — reads transcript) |
| C2 compatibility | 🟢 same PreToolUse as GitNexus/Graphify; Vitest + pytest — stack in `openspec/project.md` |
| C3 overlap | 🟢 no component validates TDD today; **materializes R6** via `enforceTdd()` |
| C4 flow | 🟢 acts only in apply phase (blocks Write/Edit without failing test); irrelevant in explore/propose |
| C5 community | 🟢 maintainer nizos (same as TDD Guard); MIT; v1.10.0 npm (Jul/2026); active |

**Limitations:** Claude Code / Codex / official Copilot CLI; Cursor via third-party hooks — validate in pilot. LLM latency per edit; disable via globs / uninstall (not TDD Guard session toggle).

**Recommendation: add to kit** as **optional** module, analogous to C1-UI: `sdd-kit/install-probity-module.sh`, enabled in APP/HYBRID profiles with tests (SKIP DOCS_SPECS). Change: `add-probity-tdd-module`.

---

## G3 — Runtime/production feedback

**Problem:** no path for production errors to feed Graphify or generate type B changes.

**Candidates evaluated:**

| Tool | C1 | C2 | C3 | C4 | C5 |
|------|----|----|----|----|-----|
| [GlitchTip](https://glitchtip.com/) (light self-hosted) | 🟡 4 containers, 512 MB RAM | 🟢 Sentry-compatible SDKs; built-in MCP (beta) | 🟢 | 🟡 | 🟡 MIT, active (v6 Feb/2026), smaller community; MCP marked beta |
| Sentry self-hosted | 🔴 40+ containers, 16 GB RAM | 🟢 | 🟢 | 🟡 | 🟢 market reference, but BSL 1.1 license |
| Sentry SaaS + [official MCP](https://mcp.sentry.dev) | 🟢 DSN + MCP only | 🟢 mature first-party MCP | 🟢 | 🟢 | 🟢 |

**Analysis:** flow fit is good — an errors MCP lets the agent consult real stack traces when classifying type B tasks, and feed `research.md` in type E. But error tracking is **production-project infra**, not kit payload: it requires a server (or SaaS account), DSN per app, and does not apply to DOCS_SPECS repos. Same category as Figma MCP in the UI module: "manual / on demand".

**Recommendation: do not add to kit core.** Document in the SDD guide (§ optional integrations): Sentry SaaS + official MCP if the project already uses Sentry; GlitchTip for self-host with minimal budget (identical SDKs, migration = swap DSN). Convention to register: type B changes cite the error tracker issue in `proposal.md`.

---

## G4 — Framework effectiveness metrics

**Problem:** no data on rework, propose→archive time, changes fixed post-archive — impossible to calibrate pipeline overhead.

**Primary candidate: [Apache DevLake](https://devlake.apache.org/)**

| Criterion | Evaluation |
|-----------|------------|
| C1 installation | 🔴 full platform: MySQL + Grafana + workers; setup and ongoing maintenance |
| C2 compatibility | 🟡 measures DORA (deployment frequency, lead time, CFR, MTTR) — does not measure SDD-specific metrics (rejected proposals, rework by change-id) |
| C3 overlap | 🟢 zero |
| C4 flow | 🔴 external dashboards, outside opsx flow |
| C5 community | 🟢 Apache Top-Level Project (graduated Oct/2025), 3.1k ★, 200 contributors, Slack 1.6k members, continuous releases — ASF governance is the gold standard for sustainability |

**Analysis:** DevLake is reliable and mature, but solves a bigger problem than ours: DORA for teams/organizations. The metrics that matter for SDD are derivable from data **already in git and in `openspec/changes/archive/`**: number of changes per period, time between first change commit and archive, post-archive `fix:` commits referencing archived change-id (rework proxy — viable because R9 requires change-id in commits).

**Recommendation: manual fix.** Script `scripts/sdd-metrics.sh` (git log + archive parsing) generating a markdown report. Re-evaluate DevLake if/when production repos have CI/CD and a team large enough for DORA to make sense.

---

## G5 — Issue/backlog traceability

**Problem:** changes are born from prompts; the request → issue → change → PR chain does not exist.

**Primary candidate: [github-mcp-server](https://github.com/github/github-mcp-server)** (official GitHub)

| Criterion | Evaluation |
|-----------|------------|
| C1 installation | 🟢 remote endpoint hosted by GitHub (`api.githubcopilot.com/mcp/`) or local binary/Docker; `--toolsets issues` limits surface |
| C2 compatibility | 🟢 MCP is the system's standard mechanism (GitNexus and Graphify already operate via MCP); register in `~/.cursor/mcp.json` and `openspec/infra.md` |
| C3 overlap | 🟡 light — in cloud agents read-only `gh` CLI already exists; locally there is no equivalent |
| C4 flow | 🟢 propose links change ↔ issue; explore can read issue context |
| C5 community | 🟢 maintained by GitHub itself, v1.7.0 (Jul/2026), already supports stateless MCP spec of 28/Jul/2026 — first-party maintenance guaranteed |

**Recommendation: hybrid.** (a) Add github-mcp-server to `infra.md` and MCP config (trivial install, first-party maintenance); (b) manual fix in process: `**Issue:**` field in sdd-kit `proposal.md` template, filled when a source issue exists. For those not using GitHub Issues, the field stays `—`.

---

## G6 — Distributed multi-agent coordination

**Problem:** session locks (R11) are local per worktree; cloud agents and multiple machines are outside scope.

**Candidates evaluated:**

| Tool | C1 | C2 | C3 | C4 | C5 |
|------|----|----|----|----|-----|
| [Vibe Kanban](https://github.com/BloopAI/vibe-kanban) | 🟢 `npx vibe-kanban` | 🟡 uses git worktrees (same model as guide §3.3) | 🔴 duplicates `sdd-session-*` scripts and OpenSpec task board | 🔴 own kanban competing with opsx flow | 🔴 **BloopAI shut down Apr/2026**; Apache 2.0, community fork without consolidated governance |
| Claude Squad | 🟢 | 🟡 | 🔴 same | 🟡 | 🟡 niche, terminal-first |

**Analysis:** the technical model (isolated worktree per agent) is exactly what the SDD guide already prescribes for safe parallelism — the difference is orchestration UI, which **competes** with the opsx flow instead of serving it. With the category leader orphaned (C5 🔴), adopting now means assuming fork maintenance.

**Recommendation: do not adopt now.** Point fix when the need is real: extend `sdd-session-*` with a simple remote backend (e.g. session registry via remote repo refs), keeping the current mechanism as fallback. Re-evaluate the orchestrator ecosystem in ~6 months (category consolidating post-Vibe Kanban).

---

## G7 — Correctness review

**Problem:** `simplify-review` (complexity) and `security-reviewer` (security) exist, but no review hunts logical bugs/edge cases — the most valuable category for AI-generated code.

**Primary candidate: [PR-Agent](https://github.com/qodo-ai/pr-agent)** (The-PR-Agent, ex-Qodo)

| Criterion | Evaluation |
|-----------|------------|
| C1 installation | 🟢 GitHub Action + API key (Anthropic supported); also CLI/Docker self-hosted |
| C2 compatibility | 🟢 acts on PR, outside local loop; uses Claude as model (aligns with project LLM stack) |
| C3 overlap | 🟡 partial with existing review skills — but those are local on-demand and do not cover correctness; PR-Agent `/review` does |
| C4 flow | 🟢 post-apply, pre-merge; does not touch explore/propose |
| C5 community | 🟡 12.1k ★, 240 contributors, v0.39.0 (Jul/2026), Apache 2.0 — but transferred to community org Apr/2026 and labeled "legacy community project" by Qodo; new governance, configuration issues open for months |

**Recommendation: hybrid, in two phases.** Phase 1 (immediate, no dependency): create local skill `correctness-review` following existing skills pattern (`.claude/skills/` + `.cursor/skills/` mirror), invoked post-apply like `simplify-review` — consistent with the system and zero risk. Phase 2 (optional, per repo): PR-Agent workflow template in sdd-kit for those who want automatic review on every PR; governance transition recommends version pin and semiannual re-evaluation.

---

## G8 — Supply chain and dependencies

**Problem:** "check advisories" is a rule without tooling; no automated updates or CI scanning.

**Candidates (complementary, not alternatives):**

| Tool | C1 | C2 | C3 | C4 | C5 |
|------|----|----|----|----|-----|
| [Renovate](https://github.com/renovatebot/renovate) (updates) | 🟢 `renovate.json` + free GitHub-hosted app (Mend) or self-host | 🟢 orthogonal to SDD | 🟢 | 🟢 update PRs enter flow as type A/B tasks | 🟢 22k ★, 440+ contributors, maintained by Mend, 62k app installs, daily releases |
| [OSV-Scanner](https://github.com/google/osv-scanner) (scanning) | 🟢 GitHub Action step | 🟢 | 🟢 | 🟢 PR gate | 🟢 10.7k ★, Google, Apache 2.0, 1600+ repos using Action, SLSA 3, v2.4.0 (Jun/2026) |

**Analysis:** established 2026 literature pair: Renovate keeps dependencies current via PRs; OSV-Scanner is the vulnerability gate with highest accuracy in benchmarks (native ecosystem version matching). Zero overlap with the system and with each other. Note: Renovate is AGPL-3.0 — irrelevant for tool use (only affects those redistributing modified Renovate).

**Recommendation: add to kit.** Templates `renovate.json` (conservative preset: grouping, schedule, automerge patches only with green CI) and workflow `osv-scanner.yml` in `sdd-kit/templates/`, activated by profile in `install.sh` (full APP; DOCS_SPECS OSV-Scanner only if lockfile present).

---

## Summary — kit vs manual fix

```
                          ADD TO KIT              MANUAL FIX               DO NOT ADOPT NOW
                          ┌──────────────────┐      ┌────────────────────┐     ┌─────────────────┐
                          │ G2 Probity       │      │ G1 CI workflow     │     │ G6 Vibe Kanban  │
                          │    (APP module)  │      │    sdd-gates.yml   │     │    (orphaned)   │
                          │ G8 Renovate +    │      │ G4 sdd-metrics.sh  │     │ G4 DevLake      │
                          │    OSV-Scanner   │      │ G5 Issue field in  │     │    (overkill)   │
                          │ G5 github-mcp    │      │    proposal.md     │     │ G3 Sentry       │
                          │    (infra.md)    │      │ G7 skill           │     │    self-hosted  │
                          └──────────────────┘      │    correctness-    │     │    (heavy)      │
                                                    │    review          │     └─────────────────┘
                          G3 GlitchTip/Sentry MCP   └────────────────────┘
                          → document as on-demand
                            module (like Figma MCP)
```

**Suggested implementation order** (lowest effort / highest return first):

1. **G1** — workflow `sdd-gates.yml` (orchestrates existing commands only)
2. **G7 phase 1** — skill `correctness-review` (pattern already established by existing skills)
3. **G5** — github-mcp-server in `infra.md` + Issue field in proposal template
4. **G8** — Renovate + OSV-Scanner templates in sdd-kit
5. **G2** — Probity module (requires APP pilot with GitNexus/Graphify hooks before default activation; change `add-probity-tdd-module`)
6. **G4** — `scripts/sdd-metrics.sh`
7. **G3/G6** — documentation only (on-demand modules / future re-evaluation)

Each item 1–6 is a candidate for its own OpenSpec change (type C/D as appropriate).

## Cross-cutting risks

- **Hook stacking (G2):** Probity, GitNexus, and Graphify share PreToolUse; validate accumulated latency and execution order in APP pilot before default activation.
- **Governance in transition (G7):** PR-Agent changed ownership Apr/2026; version pin mandatory and re-evaluation on next kit upgrade.
- **LLM cost (G2, G7):** Probity and PR-Agent consume model calls per validation/review — budget before enabling by default.
- **Repo profile:** nothing from G2/G8-Renovate applies to this repo (DOCS_SPECS); modules serve production repos consuming sdd-kit.

## Sources consulted

- Gaps: prior session analysis of `AGENTS.md`, `openspec/infra.md`, `doc/sistema-sdd-pedro.md` §3–§5, `doc/avaliacoes/`
- Probity: [github.com/nizos/probity](https://github.com/nizos/probity) (MIT, `@nizos/probity@1.10.0`); legacy TDD Guard superseded: [github.com/nizos/tdd-guard](https://github.com/nizos/tdd-guard)
- PR-Agent: [github.com/qodo-ai/pr-agent](https://github.com/qodo-ai/pr-agent) (12.1k ★, v0.39.0 Jul/2026); Qodo community transfer announcement (Apr/2026)
- Apache DevLake: [devlake.apache.org](https://devlake.apache.org/) (Apache TLP Oct/2025, 3.1k ★, 200 contributors)
- Renovate: [github.com/renovatebot/renovate](https://github.com/renovatebot/renovate) (22k ★, Mend, 62k GitHub app installs)
- OSV-Scanner: [github.com/google/osv-scanner](https://github.com/google/osv-scanner) (10.7k ★, Google, 1600+ repos on Action, v2.4.0 Jun/2026)
- github-mcp-server: [github.com/github/github-mcp-server](https://github.com/github/github-mcp-server) (official, v1.7.0, stateless MCP spec Jul/2026)
- GlitchTip vs Sentry: 2026 self-hosting comparisons (glitchtip.com; ossalt.com; selfhosting.sh)
- Vibe Kanban: [vibe-kb.com](https://vibe-kb.com/) (Apache 2.0; BloopAI closed Apr/2026, community maintenance)
- Hooks/CI enforcement: 2026 pre-commit vs Lefthook comparisons; consensus that enforcement belongs in CI (`--no-verify` bypasses local hooks)

## Session Handoff

This explore phase is complete. To implement any item, open a new chat with:

---
/opsx:propose <item from implementation order — e.g. "add-sdd-ci-gates-workflow">

Change base: openspec/changes/explore-oss-coverage-gaps/ (read research.md)
Infra: openspec/infra.md (assume ✅ — do not reinstall)
---
