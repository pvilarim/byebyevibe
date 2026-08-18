# Evaluation: NanoNets Graft — persistent codebase graph for coding agents

| Field | Value |
|-------|--------|
| **Date** | 2026-08-17 |
| **Evaluator** | Explore session `/opsx:explore` (Cloud Agent) |
| **Candidate** | [NanoNets/Graft](https://github.com/NanoNets/Graft) (`@nanonets/graft@0.10.1`, MIT, TypeScript + tree-sitter) — site `https://graft.nanonets.ai` |
| **Decision** | **Discarded** as kit payload / replacement for GitNexus or Graphify · **Deferred** as a pattern source (freshness UX, query-time structural refresh, published SWE-bench methodology) |
| **Scope** | Context-graph layer for coding agents — `sdd-kit` candidate, rejected as an addition; three UX patterns kept in backlog |

## Executive summary

Graft builds a two-tier map of a repository: a deterministic tree-sitter code graph (`graft/.graph/wiring.json`, no LLM, no key) plus an optional LLM pass (`graft build --deep`) that writes linked markdown nodes under `graft/` — one node per subsystem, with summaries, typed `[[wikilinks]]`, and (in the code graph) per-symbol crux excerpts. `graft init` wires Claude Code, Cursor, Codex, Gemini, Copilot, Kiro, Windsurf, and AdaL; Claude Code additionally gets an MCP server (six tools), a statusline, and post-edit hooks that rebuild the structural graph after every turn.

**Discarded as kit payload.** Graft occupies *both* graph layers the SDD stack already ships — GitNexus (code) and Graphify (concepts) — plus a third always-on instruction surface (`AGENTS.md` marker block, `.cursor/rules/graft.mdc`, `.claude/skills/graft/SKILL.md`). That is the same overlap criterion that discarded [code-review-graph](./2026-08-02-code-review-graph.md) (GitNexus core) and [TencentDB Agent Memory](./2026-08-07-tencentdb-agent-memory.md) (Code-Graph + LLM-Wiki). Adding Graft would mean three indexes of the same repo, three MCP/skill surfaces answering the same questions, and an LLM-written "senior explanation" that enters context without a slot in R2/R3 provenance ranking.

**Deferred as a pattern source**, without adopting the runtime: (1) query-time structural refresh (~3 ms fingerprint, rebuild only what moved, including unsaved buffers); (2) Claude Code statusline that reports graph size and staleness; (3) a SWE-bench Verified harness comparing cold agent vs graph-wired agent. Graphify already has `graph.html`; GitNexus already has `gitnexus wiki`; neither currently auto-refreshes on every query nor exposes freshness in the IDE chrome.

Graft does **not** compete with OpenSpec, session phases, CI gates, or the A–E protocol. It is not a spec-driven framework. It is a better-packaged answer to "the agent starts blind every session" — a real cost the stack already mitigates with GitNexus + Graphify + durable artifacts, just with more operator discipline (`analyze --force`, `graphify update .`) and less prompt injection.

## Problem it tried to solve

Every coding-agent session re-explores the repo from zero: grep, open, follow an import, back out. That rediscovery is repeated, discarded with the session, and unshared with the next teammate. Graft's claim: build the understanding once, keep it as files, inject or retrieve it so the agent skips exploration.

The SDD stack already names this cost. Guide §2.3–2.4: without GitNexus the agent "edits by vibe"; without Graphify it "reinvents what the team already wrote." The gap Graft actually hits is not "no map" — it is **map freshness and retrieval UX**: GitNexus/Graphify are explicit rebuilds the agent must remember; Graft refreshes the structural graph on every query and can push matching nodes into the prompt.

## What was analyzed

- Rendered GitHub README of [NanoNets/Graft](https://github.com/NanoNets/Graft) (architecture, MCP tools, CLI, agent wiring, benchmarks, SWE-bench, viz).
- npm package [`@nanonets/graft@0.10.1`](https://www.npmjs.com/package/@nanonets/graft) (deps, version history, weekly downloads).
- GitHub API metadata (created 2026-07-03, last push 2026-08-17, MIT, 3196 stars, 280 forks, 55 open issues).
- Prior overlap decisions: [`2026-08-02-code-review-graph.md`](./2026-08-02-code-review-graph.md), [`2026-08-07-tencentdb-agent-memory.md`](./2026-08-07-tencentdb-agent-memory.md), [`2026-03-26-headroom-context-compression.md`](./2026-03-26-headroom-context-compression.md), [`2026-07-25-oss-coverage-gaps-tooling.md`](./2026-07-25-oss-coverage-gaps-tooling.md).
- Insertion methodology: [`openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`](../../openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md) (V1–V5, F1–F5, C1–C5).
- Normative constraints: `AGENTS.md` R2/R3/R8/R10, guide §2.5.1 (anti-pattern: paste tool-generated blocks into canonical `AGENTS.md`), `openspec/project.md` (stack: OpenSpec 1.3.1, GitNexus 1.6.5 declared / 1.6.9 in `infra.md`, Graphify 0.8.5 declared / 0.9.31 in `infra.md`), `openspec/infra.md`.

### Verified facts (docs + registry, not a local install)

| Fact | Source |
|------|--------|
| Two-pass graph: tree-sitter Tier 1 (`graft build`, `$0`) + optional LLM `--deep` (file summaries → grouped concept nodes + per-symbol crux) | README "How the graph gets built" |
| Default `graft/` is gitignored as a local cache (like `node_modules`); teammates run `graft build`. README still also claims "commit the graph; git does the syncing" in the product pitch | README Quick start vs "What Graft does" — **internal contradiction** |
| Six MCP tools: `graft_find_code`, `graft_file_api`, `graft_trace_calls`, `graft_find_all`, `graft_repo_map`, `graft_check_freshness` | README "MCP server" |
| `graft init` writes marker-fenced sections into `AGENTS.md` / `GEMINI.md` / `.github/copilot-instructions.md`, or owned files: `.claude/skills/graft/SKILL.md`, `.cursor/rules/graft.mdc`, plus `.mcp.json`. Claude Code also gets statusline + PostToolUse hooks. Selecting `agents` also writes `~/.codex/config.toml` and `~/.codex/hooks.json` (machine-wide) | README "Agent integration" |
| Languages: full-fidelity TS/JS/Python/Go/Java; broad tree-sitter for 16 more; optional `--lsp` edges | README "Supported languages" |
| Efficiency harness: 162 runs, two repos; advertised −42% tokens, −46% tool calls, −60% latency, equal correctness vs cold Claude. Pull variant +5 pts correctness | README "Benchmark" |
| SWE-bench Verified: 50 instances, Claude Sonnet 5, 54% → 66% resolved, −23% tokens, −25% tool calls | README "SWE-bench Verified" |
| npm `0.10.1` (2026-08-13), 14 deps including `@anthropic-ai/sdk`, `openai`, `tree-sitter-*`; ~2.2k weekly downloads; 0 dependents | npm registry |
| Repo created 2026-07-03 (~45 days of history); active (push same day as this evaluation); MIT; NanoNets org | GitHub API 2026-08-17 |
| Default MCP registration: `npx -y @nanonets/graft mcp` (unpinned transitive deps) | README MCP snippet |

### Not verified

- Local install, hook latency stacked with GitNexus + Graphify + Probity (V5). `[NEEDS VERIFICATION]`
- Whether `--deep` summaries cite source hashes in a form an agent can treat as R8 provenance, or only content-hash staleness for rebuild. `[NEEDS VERIFICATION]`
- SWE-bench instance list, Docker images, and whether the 50-instance slice is a documented subset of Verified. `[NEEDS VERIFICATION]`
- `graft/` vs `graphify-out/` filename collisions (none expected; different roots) and `.mcp.json` merge behavior against an existing GitNexus entry. `[NEEDS VERIFICATION]`
- Source of the README gitignore-vs-commit contradiction — likely a product pivot not fully edited. `[NEEDS VERIFICATION]`

## Fit with the SDD stack

| Tool | Relation |
|------|----------|
| OpenSpec | **Neutral / orthogonal.** Graft has no change artifacts, no human gate, no explore→propose→apply. It does not replace or implement the pipeline. Risk is only that prompt-injected nodes are treated as if they were `specs/` |
| GitNexus | **Frontal overlap (code graph).** `graft_trace_calls` ↔ `gitnexus_impact` / `trace`; `graft_file_api` ↔ file-level `context`; `graft_find_code` / `graft_repo_map` ↔ `query` / `context`; `graft_check_freshness` ↔ stale-index warning. GitNexus still wins on depth: 17 MCP tools including `route_map` / `api_impact` / `shape_check` (declared Next.js + Server Actions stack), `pdg_query`, `rename`, `detect_changes`, local ONNX embeddings. Graft wins on query-time auto-refresh and a smaller, named tool set |
| Graphify | **Frontal overlap (concept graph).** `graft/*.md` linked nodes ↔ `graphify-out/` + `GRAPH_REPORT.md` + wiki. Graphify default is AST-only (`graphify update .`, no API cost) — the same posture Graft's Tier 1 already covers. Graft `--deep` ↔ `graphify extract` (LLM semantics) and `gitnexus wiki`. Graphify already ships `graph.html`; Graft ships `graft viz` |
| AGENTS.md / sdd-kit | **Policy conflict.** `graft init` writes a marker-fenced section into canonical `AGENTS.md` (host `agents`) and an always-on Cursor rule `.cursor/rules/graft.mdc`. Guide §2.5.1 forbids pasting tool-generated blocks into the canonical file; `metodologia-insercao.md` forbids an always-on rule for an on-demand tool. Machine-wide `~/.codex/` writes violate repo-scoped install. Default MCP via `npx -y` is the F-SEC-3 supply-chain pattern already documented for OpenSpec |

```
                    WHAT EACH LAYER ANSWERS
  ═══════════════════════════════════════════════════════════════

  Question                         ByeByeVibe              Graft
  ─────────────────────────────────────────────────────────────
  What must change (intent)?       OpenSpec artifacts      — (none)
  What will break (code)?          GitNexus impact         graft_trace_calls
  What do we already know?         Graphify + specs/       graft/*.md (--deep)
  Who reviewed it?                 R7 human gate           — (none)
  Is the map fresh?                operator runs update    query auto-refresh
  How does the agent see it?       lazy skill / MCP        push into prompt
                                                   + pull MCP
```

## Criteria (C1–C5) and Phase 0

| Criterion | Score | Notes |
|-----------|-------|-------|
| C1 Installation | 🟡 | `npm i -g` + `graft init` is easy; `--deep` needs a provider key; MCP default is `npx -y` |
| C2 Compatibility | 🔴 | Occupies MCP, PreToolUse/PostToolUse hooks, always-on Cursor rule, `AGENTS.md`, `.mcp.json` — all already taken |
| C3 Overlap | 🔴 | Duplicates GitNexus *and* Graphify (worse than code-review-graph, which only duplicated GitNexus) |
| C4 Flow fit | 🟡 | Orthogonal to opsx phases, but prompt injection competes with R2 source ranking and lazy-load skills |
| C5 Community | 🟡 | NanoNets-backed, MIT, very active, 3.2k ★ in ~45 days; still 0.x (`0.10.1`), README contradiction on whether `graft/` is committed |

| Check | Result |
|-------|--------|
| V1 already evaluated? | No prior Graft row in `doc/avaliacoes/` |
| V2 contact surface | git hooks / PostToolUse · MCP · skill · always-on rule · `AGENTS.md` · user-level Codex config |
| V3 artifact collision | `graft/` vs `graphify-out/` / `.gitnexus/` (distinct roots); `.mcp.json` merge; `.cursor/rules/graft.mdc` vs `graphify.mdc` |
| V4 profile | APP would feel the SWE-bench gains; this hub is DOCS_SPECS — expected gain ≈ 0 (same finding as TencentDB) |
| V5 hook stacking | Unmeasured; suggested PreToolUse order is already GitNexus → Graphify → Probity (guide §2.16) |
| F1 security | MIT; `npx -y` unpinned; LLM keys `GRAFT_API_KEY`; no telemetry claimed |
| F2 license | MIT — compatible |
| F3 governance | Living (push 2026-08-17); NanoNets org; 0.x API |
| F4 reversibility | `--dry-run` exists; uninstall path is "delete wiring files" — not documented as a first-class command `[NEEDS VERIFICATION]` |
| F5 operability | `--dry-run`, `--no-mcp`, `--no-hooks`, `--no-agents`, `GRAFT_NO_REFRESH=1` — toggle surface is real |

## Risks by workflow phase

| Phase | Risk | Severity | Notes |
|-------|------|----------|-------|
| Explore | Two (or three) graphs disagree; LLM nodes look like knowledge | **High** | Same class as TencentDB LLM-Wiki: inferred prose enters context without `[NEEDS VERIFICATION]`. Prompt injection also narrows the option space the way Headroom sampling did |
| Propose | `design.md` cites a Graft node instead of `specs/` or GRAPH_REPORT | **Medium** | R8 wants a citable source; `graft/*.md` is regenerable cache (gitignored in current docs) — not reviewable in the PR unless the team reverses the gitignore |
| Apply | Double/triple index staleness; hook latency; agent picks Graft over GitNexus `impact` | **High** | GitNexus still has the API-contract tools the declared stack needs. A wrong tool choice is a missed blast radius |
| Archive | Low | **Low** | Graft does not touch `openspec/changes/archive/` |

**Common mechanism:** a second constitutional map. LifeOS was discarded for a rival "done"; Graft is a rival "what the repo is." The stack already has two maps with a split of labor (code vs concepts). A third map that does both, and pushes itself into every prompt, collapses that split.

## What Graft solves that ByeByeVibe does not (honest delta)

These are real, and they are **UX and measurement**, not missing capabilities:

1. **Query-time structural refresh** — every `ask`/`grep`/`callers`/`map` stats the tree (~3 ms) and rebuilds only dirty files, including unsaved buffers. GitNexus/Graphify wait for `analyze --force` / `graphify update .` (or a commit hook).
2. **Freshness in the IDE chrome** — Claude Code statusline with graph size, % enriched, `⚠ N stale`. The SDD stack has no equivalent signal.
3. **Prompt-side retrieval (push)** — matching nodes injected into the session, plus post-edit blast-radius surfacing. ByeByeVibe is pull: the agent must follow `AGENTS.md` and load GitNexus/Graphify. Push is the advertised token/tool-call win; it is also the provenance risk.
4. **Published SWE-bench Verified comparison** (50 instances, +12 pts resolved vs cold Claude). The SDD stack has no first-party agent-correctness benchmark against a cold baseline.
5. **One-command wiring across more hosts** — Gemini, Copilot, Kiro, Windsurf, AdaL, Codex (including machine-wide Codex hooks). The kit first-classes Cursor + Claude Code.
6. **Crux excerpts** — the handful of logic lines stored next to the symbol (in `--deep` code graph). Graphify/GitNexus point at file:line; the agent still opens the file.

Everything else in Graft's pitch is already covered:

| Graft claim | Already in the stack |
|-------------|----------------------|
| Persistent code graph (tree-sitter, no embeddings required) | GitNexus `.gitnexus/` |
| Blast radius / callers | `gitnexus_impact`, `trace` |
| File API / signatures without bodies | GitNexus `context` / file queries |
| Concept / architecture nodes in markdown | Graphify `GRAPH_REPORT.md` + wiki; optional `graphify extract` |
| LLM wiki of the repo | `gitnexus wiki` |
| Interactive viz | Graphify `graph.html` |
| Multi-agent skills/rules | `graphify install`, `gitnexus setup`, sdd-kit templates |
| Git-syncable, regenerable cache | `graphify-out/` and `.gitnexus/` are gitignored, same model as current Graft quick start |

## What ByeByeVibe solves that Graft does not

Graft is not a methodology. It does not:

- hold phase state in reviewable artifacts (`tasks.md` as program counter);
- require a human gate before code (R7);
- classify work A–E or rank sources (R2/R3);
- coordinate sessions (R11) or hand off explore→propose→apply;
- enforce CI (`sdd-gates`), TDD (Probity), or supply chain (Renovate/OSV);
- install a curated constitution (`AGENTS.md` templates 12.2a/b);
- ship operator day-1, UI module, i18n waves, or SDD metrics.

Integrating Graft **into** the kit therefore cannot be "drop-in complementary." The only compatible shape is **CLI-only, no init wiring** (`graft build` + `graft ask` as an extra retrieval command) — which throws away the differentiators (statusline, hooks, prompt push, MCP). Full `graft init` is the incompatible shape.

## Expected vs observed gains

| Advertised gain | Assessment |
|-----------------|------------|
| Up to 4× cheaper / 3× faster | Upstream marketing envelope; the controlled 162-run table is −32% cost / −60% latency on two small repos. Not transferable to this DOCS_SPECS hub (no SWE-bench-like loops) |
| SWE-bench 54% → 66% | Strongest evidence Graft's *mechanism* helps a cold coding agent. Measures Graft vs *no graph*, not Graft vs GitNexus+Graphify. The interesting experiment (deferred) is cold vs GitNexus+Graphify vs Graft vs all three |
| "Real explanations, not a list of symbols" | True of `--deep`. Conflicts with Graphify's AST-only default (no API cost) and with R3: LLM prose is not a spec |
| "A real graph you can read; no embeddings" | True of markdown nodes. GitNexus embeddings are optional/local; Graphify is already files. Not a gap |
| "Grafted into git" | Contradicted by the current quick start (`graft/` gitignored). If gitignored, teammates do not share the map — same as today's `graphify-out/` |
| Multi-agent auto-init | Real packaging advantage; pays for it by mutating `AGENTS.md` and user-level Codex config |

## Alternatives already in the stack

1. **GitNexus** — code graph, blast radius, API contracts, change detection, wiki.
2. **Graphify** — concept graph, `GRAPH_REPORT.md`, optional LLM extract, `graph.html`.
3. **OpenSpec artifacts** — durable, reviewed memory across sessions (the thing Graft's pitch calls "discarded with the session").
4. **Lazy skills** — GitNexus impact/debug, Graphify rule, `/opsx:*` — on-demand, not prompt-injected.
5. **Commit hooks** — `graphify hook install`; GitNexus PreToolUse enriching grep/glob.

## Decision and re-evaluation conditions

**Decision:** **Discarded** as `sdd-kit` payload, as a GitNexus replacement, and as a Graphify replacement. **Deferred** as a pattern source only.

**Do not:** run `graft init` on the hub or consumer templates; register a Graft MCP next to GitNexus; add `.cursor/rules/graft.mdc` as always-on.

**Conditions to reopen (kit / optional module):**

- GitNexus *or* Graphify is abandoned or loses the declared stack (TS 5.9 / Python 3.13 / Next.js), *and* Graft is evaluated as a *replacement* of that one layer — never as a third graph.
- A measured APP-profile pilot shows GitNexus+Graphify losing to Graft on SWE-bench-style tasks *by a margin that survives hook-latency and tool-choice costs* (quantified success criteria before the pilot, per `metodologia-insercao.md` Phase 2). Pilot cannot be waived: Graft installs a binary, hooks, and MCP.
- Graft ships a first-class **CLI-only / no-AGENTS.md / no-always-on-rule** install that can sit behind a skill the way GitNexus already does.

**Conditions to reopen (patterns, no Graft runtime):**

- Prototype query-time freshness for GitNexus and/or Graphify (fingerprint + partial rebuild) without adding a third graph.
- Add an optional Claude Code statusline (or equivalent) that reports `.gitnexus/` / `graphify-out/` staleness.
- Publish a cold-vs-wired SWE-bench (or internal task set) for the SDD stack itself.

## References

- https://github.com/NanoNets/Graft
- https://www.npmjs.com/package/@nanonets/graft (`0.10.1`, 2026-08-13)
- https://graft.nanonets.ai
- GitNexus: npm `gitnexus@1.6.9` (installed; `openspec/infra.md`) · https://github.com/abhigyanpatwari/GitNexus
- Graphify: `graphify 0.9.31` (`openspec/infra.md`) · guide §2.4
- Overlap precedent: [`2026-08-02-code-review-graph.md`](./2026-08-02-code-review-graph.md) · [`2026-08-07-tencentdb-agent-memory.md`](./2026-08-07-tencentdb-agent-memory.md)
- Insertion methodology: `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`
- Anti-pattern: `doc/byebyevibe-guide.md` §2.5.1
