# Evaluation: code-review-graph — local code intelligence graph (MCP/CLI)

| Field | Value |
|-------|--------|
| **Date** | 2026-08-02 |
| **Evaluator** | Explore session `/opsx:explore` (Cloud Agent, Claude Code) |
| **Candidate** | [code-review-graph](https://github.com/tirth8205/code-review-graph) (MIT, Python 3.10+) — site `code-review-graph.com` |
| **Decision** | Discarded |
| **Scope** | sdd-kit candidate (code-graph layer for target repos) |

## Executive summary

`code-review-graph` builds a local Tree-sitter → SQLite code graph and serves it to AI agents via MCP (30 tools: blast radius, semantic search, flow detection), advertising ~65x median token reduction on reviews. **Discarded**: its entire core duplicates GitNexus — already installed (1.6.9) and named in the Task Classification pipelines (B/C/D) of `AGENTS.md` — while missing GitNexus features that matter for this project's declared stack. The only piece the SDD stack lacks (a GitHub Action with risk-scored sticky PR comments) is deferred to the G7 re-evaluation (Jan/2027).

## Problem it tried to solve

Token-efficient code context for agents: give Cursor/Claude Code a queryable structural map instead of raw file reads. This gap is already covered in the SDD stack by GitNexus (code graph) + Graphify (concept graph).

## What was analyzed

- README of [tirth8205/code-review-graph](https://github.com/tirth8205/code-review-graph) (architecture, MCP tools, CLI, benchmarks, limitations). Official site returned HTTP 403 via proxy.
- npm tarball `gitnexus@1.6.9` (installed version = `latest`): dependency-declared grammars, vendored optional grammars, `dist/mcp/tools.js` (17 MCP tools extracted from code, not docs), `dist/cli/index.js` (22 CLI commands).
- Prior decisions: `2026-07-25-oss-coverage-gaps-tooling.md` (overlap criterion; pre-commit/Lefthook discarded on the same grounds), `metodologia-insercao.md`.

### Verified facts (source: package code, not marketing)

- **GitNexus 1.6.9 languages (14):** TS, JS, Python, Java, C#, Go, Rust, PHP, Ruby, C/C++ as direct grammar dependencies; Kotlin, Swift, Dart vendored as optional grammars compiled at install (node-gyp — may silently fail without a build toolchain). PDG/control-flow (`pdg_query`) is TS/JS-only today.
- **GitNexus MCP tools (17):** `query`, `context`, `impact`, `trace`, `detect_changes`, `cypher`, `rename`, `check`, `explain`, `pdg_query`, `route_map`, `tool_map`, `shape_check`, `api_impact`, `group_list`, `group_sync`, `list_repos`. Embeddings run locally (ONNX), no API calls.
- **code-review-graph:** Tree-sitter → SQLite, ~30+ languages (incl. PHP/Laravel semantic edges, Elixir, Terraform, SQL, shell, Vue/Svelte, notebooks), `detect-changes --brief` with risk score, multi-IDE auto-install (`code-review-graph install` writes MCP config for Cursor, Claude Code, and ~13 others), GitHub Action with sticky PR comment + optional merge gate. Author-admitted limitations: impact recall 1.0 is circular (measured against its own graph), search MRR 0.35, flow detection 33% recall outside Python/PHP.
- Third-party star counts (27.9k via aggregator) could not be confirmed at the source; divergent forks exist (juspay ReScript variant, n24q02m) — fragmented ecosystem signal.

## Fit with the SDD stack

| Tool | Relation |
|------|----------|
| OpenSpec | Neutral — no interaction with change artifacts |
| GitNexus | **Frontal overlap** — replicates the core (`query`, `context`, `impact`, `detect_changes`). Lacks GitNexus's API-contract block (`route_map`/`api_impact`/`shape_check`, relevant to the declared Next.js + Server Actions stack) and coordinated `rename`. For the declared stack (TS 5.9, Node 22, Python 3.13), GitNexus is functionally superior, not merely equivalent |
| Graphify | Neutral — different layer (concepts, not code) |
| AGENTS.md / sdd-kit | Adopting both would mean two graphs of the same code, two index processes, two MCP tool sets competing for agent context; pipelines B/C/D cite GitNexus by name |

## Risks by workflow phase

| Phase | Risk | Notes |
|-------|------|-------|
| Explore | Tool-choice ambiguity | Two graph MCPs answering the same questions differently |
| Propose | None specific | — |
| Apply | Double index staleness | Two indexes to refresh after edits (`analyze --force` + `update`) |
| Archive | None specific | — |

## Expected vs observed gains

| Advertised gain | Assessment |
|-----------------|------------|
| ~65x median token reduction | Ground truth is graph-derived (circular, author-admitted); GitNexus already delivers the same class of savings |
| 30+ language coverage | Real gap vs GitNexus's 14, but irrelevant for the declared stack; only SQL (Supabase migrations) and shell (`scripts/*.sh`) touch this project's periphery |
| Multi-IDE auto-install | More mature than GitNexus's, but not worth a duplicate graph |
| GitHub Action risk-scored PR review | **The one genuine differentiator** — competes with PR-Agent phase 2 in gap G7 |

## Alternatives already in the stack

GitNexus 1.6.9 (code graph, blast radius, call chains, API contracts, coordinated rename — all via MCP in Cursor and Claude Code) + Graphify (concept graph) + `correctness-review` skill (G7 phase 1).

## Decision and re-evaluation conditions

**Decision:** Discarded (core overlap with GitNexus, same criterion that discarded pre-commit/Lefthook in G1).

**Conditions to reopen:**

- G7 re-evaluation (Jan/2027): compare its GitHub Action (risk-scored sticky comment + merge gate) against PR-Agent phase 2 as a CI step inside `sdd-gates.yml` — the Action can be evaluated standalone, without adopting the graph.
- A target repo for the sdd-kit lands outside GitNexus's 14 languages (e.g. Elixir, Terraform-heavy, Laravel where its semantic edges beat GitNexus's PHP support).
- GitNexus stagnates or is abandoned — then this becomes a *replacement* evaluation, not an addition.

## References

- https://github.com/tirth8205/code-review-graph
- Forks: https://github.com/juspay/code-review-graph-rescript · https://github.com/n24q02m/better-code-review-graph
- GitNexus: https://github.com/abhigyanpatwari/GitNexus (npm `gitnexus@1.6.9`)
- Prior overlap precedent: [`2026-07-25-oss-coverage-gaps-tooling.md`](./2026-07-25-oss-coverage-gaps-tooling.md) (G1, G7)
