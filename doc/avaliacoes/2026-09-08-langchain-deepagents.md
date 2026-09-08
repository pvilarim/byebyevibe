# Evaluation: LangChain Deep Agents — agent harness (host adapter candidate)

| Field | Value |
|-------|--------|
| **Date** | 2026-09-08 |
| **Evaluator** | Chat research session (Cloud Agent) — operator questions on API coordination and Graphify/GitNexus overlap |
| **Candidate** | [Deep Agents](https://github.com/langchain-ai/deepagents) (`deepagents` PyPI · [deepagents.js](https://github.com/langchain-ai/deepagentsjs)) · [Deep Agents Code](https://docs.langchain.com/deepagents-code) (`dcode` CLI) |
| **Decision** | **Deferred** — optional harness host / programmatic runtime; no kit payload or install now |
| **Scope** | Harness layer (agent runtime on LangGraph) — not a replacement for OpenSpec, GitNexus, or Graphify |

## Executive summary

Deep Agents is LangChain's **batteries-included agent harness**: sub-agents, virtual filesystem, context management, skills (`SKILL.md`), shell/sandbox, human-in-the-loop, and **native MCP support**, built on LangGraph. It runs as a **Python/JS library or terminal CLI** (`dcode`) and calls LLMs via **provider APIs** (OpenAI, Anthropic, Google, OpenRouter, local Ollama/vLLM, etc.) — it does **not** require locally installed IDE agents (Cursor, Claude Desktop, etc.).

**Deferred** as radar-only: the stack already targets **Cursor** and **Claude Code** as primary interactive hosts. Deep Agents would matter as an **optional programmatic or terminal harness** for headless pipelines, custom apps, or multi-model orchestration — **not** by bundling it into `sdd-kit`. **Deep Agents does not make the SDD stack more intelligent**; it changes *how* an agent loop runs. Cognition stays in OpenSpec (intent), GitNexus (code impact), and Graphify (knowledge).

Unlike Pi (also deferred), Deep Agents **supports MCP natively**, so GitNexus and Graphify can be wired in without abandoning the MCP path — but it still does **not** duplicate their indexing or query semantics.

## Problem it tried to solve

Three questions from the research session:

1. **Must operators use locally installed agents, or can Deep Agents coordinate via different provider APIs?** — API-based. Configure `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, etc.; main agent and each sub-agent can use different `provider:model` strings (e.g. main `anthropic:claude-sonnet-4-6`, sub-agent `openai:gpt-5.5`). No separate "installed agent" per provider.
2. **Does Deep Agents overlap Graphify or GitNexus features?** — **No** at the index/graph layer. Partial surface overlap only (filesystem read/grep, skills, memory files).
3. **Can Deep Agents execute or consume Graphify/GitNexus?** — **Yes**, via MCP tools, sandbox shell (`gitnexus analyze`, `graphify update .` / `graphify query`), or passive reads of `graphify-out/GRAPH_REPORT.md` — but it does not build or maintain those graphs itself.

Candidate gap (only if pursued later):

- **Headless multi-step pipelines** with explicit sub-agent delegation and LangSmith tracing.
- **Multi-provider routing** in one process (e.g. Anthropic planner + OpenAI coder sub-agent).
- **Custom APP services** embedding an agent runtime while keeping ByeByeVibe repo artifacts.

## What was analyzed

- [Deep Agents `README.md`](https://github.com/langchain-ai/deepagents) — principles (model-agnostic, sub-agents, MCP, skills, production on LangGraph).
- [Deep Agents overview](https://docs.langchain.com/oss/python/deepagents/overview) — capabilities, filesystem, MCP, skills, memory.
- [Subagents](https://docs.langchain.com/oss/python/deepagents/subagents) — per-subagent `model` override, isolated context, `CompiledSubAgent`.
- [Models](https://docs.langchain.com/oss/python/deepagents/models) — `provider:model` format, `init_chat_model`, provider profiles.
- [Deep Agents Code configuration](https://docs.langchain.com/deepagents-code/configuration) — credential resolution (`~/.deepagents/.env`, `DEEPAGENTS_CODE_*` prefix).
- ByeByeVibe hub: `doc/byebyevibe-guide.md` §2.3–2.4 (GitNexus, Graphify roles), `AGENTS.md` knowledge-source priority, `.claude/skills/gitnexus/gitnexus-guide/SKILL.md`.
- Prior art: [`2026-09-03-pi-coding-agent-harness.md`](./2026-09-03-pi-coding-agent-harness.md) (harness vs control plane); [`2026-08-13-deer-workflow.md`](./2026-08-13-deer-workflow.md) (discarded pipeline runtime).

### Verified facts

- **Layer:** Deep Agents = harness (LLM + agent loop + default tools + sub-agents). ByeByeVibe = repo-scoped control plane on top of a chosen harness.
- **API coordination:** Single runtime process; credentials via env vars or `~/.deepagents/.env`; sub-agents accept optional `model` override per dict spec.
- **Not local-agent orchestration:** Does not connect to or manage Cursor/Claude Code/Cloud Agent instances as peers.
- **MCP:** First-class — `tools=` accepts MCP server tools alongside custom functions ([overview — Tools and MCP](https://docs.langchain.com/oss/python/deepagents/overview)).
- **Skills:** Progressive disclosure from `SKILL.md` paths — conceptually similar to Cursor/Claude skills, not to Graphify index building.
- **Filesystem:** Virtual FS with `read_file`, `grep`, `glob`, etc. — **not** call-graph or blast-radius analysis.
- **Deep Agents Code (`dcode`):** Terminal coding agent (Claude Code–like) using the same provider credential model; separate install path from Python library.
- **ByeByeVibe today:** GitNexus MCP (`query`, `impact`, `detect_changes`, …) and Graphify MCP/CLI documented in guide; no Deep Agents integration.

### Not verified

- Pin-compatible `deepagents` version for consumer APP repos at evaluation time. `[NEEDS VERIFICATION]`
- Production LangSmith cost/latency vs Cursor for equivalent SDD apply sessions. `[NEEDS VERIFICATION]`
- Whether a maintained community adapter wraps OpenSpec `/opsx:*` phases for Deep Agents. `[NEEDS VERIFICATION]`
- Supply-chain posture of `npx`/PyPI transitive deps for pinned installs (same class of risk as OpenSpec `npx --yes` — F-SEC-3).

## Architecture comparison

```
┌─────────────────────────────────────────────────────────┐
│  ByeByeVibe (control plane — repo-scoped)               │
│  OpenSpec · GitNexus · Graphify · sdd-kit · sdd-gates   │
├─────────────────────────────────────────────────────────┤
│  Harness (operator choice — one per session)            │
│  Cursor │ Claude Code │ Deep Agents │ Pi │ …            │
├─────────────────────────────────────────────────────────┤
│  LLM providers (OpenAI, Anthropic, local, …)            │
└─────────────────────────────────────────────────────────┘
```

| Dimension | Deep Agents | GitNexus | Graphify |
|-----------|---------------|----------|----------|
| Primary role | Agent runtime / orchestration | Code graph + impact | Knowledge/concept graph |
| Index build | ❌ | `gitnexus analyze` | `graphify update .` / `extract` |
| Call chains / blast radius | ❌ (consume via MCP) | ✅ native | ❌ |
| Team docs / concepts | ❌ (consume via MCP/GRAPH_REPORT) | ❌ | ✅ native |
| Sub-agents / delegation | ✅ native | ❌ | ❌ |
| MCP client | ✅ native | ✅ server | ✅ server (optional) |
| OpenSpec lifecycle | ❌ | ❌ | ❌ |

## Graphify / GitNexus — overlap vs integration

### What Deep Agents does **not** replace

| Capability | Owner |
|------------|-------|
| Call graph, processes, `impact` depth, `detect_changes` | GitNexus |
| Concept communities, `GRAPH_REPORT.md`, semantic doc graph | Graphify |
| Change proposals, tasks, archive, `sdd-gates` | OpenSpec + ByeByeVibe |

### Partial surface overlap (not substitutes)

| Deep Agents feature | Similar to | Limit |
|---------------------|------------|-------|
| Skills (`SKILL.md`) | Cursor/Claude skills | Instructions only; no graph build |
| Filesystem `grep`/`read_file` | Agent reading repo | No symbol-level impact |
| Memory (`AGENTS.md` param) | Project constitution | Not spec workflow |
| Sub-agents | Delegation | Not graph queries |

### Integration paths (if Deep Agents is the harness)

| Path | Fit | Notes |
|------|-----|-------|
| **MCP** — GitNexus + Graphify tools on `create_deep_agent(tools=…)` | **Best** | Same tools as Cursor; requires MCP config in runtime |
| **Shell** — `gitnexus analyze`, `graphify update .`, `graphify query` | **OK** | Fragile stdout parsing; index staleness manual |
| **Filesystem** — read `graphify-out/GRAPH_REPORT.md` | **Passive** | No dynamic `impact` / `query_graph` |

Example pattern (illustrative — not kit-shipped):

```python
from deepagents import create_deep_agent

research_subagent = {
    "name": "researcher",
    "description": "Query Graphify for team concepts before coding",
    "system_prompt": "Use graph tools for concept lookup; cite sources.",
    "model": "openai:gpt-5.5",
}

agent = create_deep_agent(
    model="anthropic:claude-sonnet-4-6",
    subagents=[research_subagent],
    tools=[...],  # GitNexus + Graphify MCP tools when configured
)
```

## Fit with the SDD stack

| Tool | Relation |
|------|----------|
| OpenSpec | **Complementary.** No change lifecycle in Deep Agents; `openspec/` artifacts remain authoritative. Future adapter would invoke CLI/validate — not replace OpenSpec. |
| GitNexus | **Complementary.** No index overlap. **Consumer** via MCP (preferred) or CLI shell. |
| Graphify | **Complementary.** Same as GitNexus. |
| AGENTS.md / sdd-kit | **Compatible read-only.** Memory param can load `AGENTS.md`; full fit needs host adapter for `/opsx:*` and R11 session scripts — same guard as Pi/LifeOS. |
| Cursor / Claude Code | **Siblings, not parents.** Deep Agents does not enhance IDE agents; pick one harness per session. |
| Pi (deferred) | **Sibling harness.** Deep Agents is heavier (MCP, sub-agents, LangGraph); Pi is minimal terminal-first. |
| `sdd-gates` | **Harness-agnostic.** CI unchanged. |

## Risks by workflow phase

| Phase | Risk | Severity | Notes |
|-------|------|----------|-------|
| Explore | Operator assumes Deep Agents replaces Graphify | Medium | Education — read graphs via MCP, not built-in |
| Propose | No `/opsx:propose` — ad-hoc work without R7 | High | Same gap as Pi without adapter |
| Apply | Sub-agent edits without `gitnexus impact` | Medium | Mitigation: MCP `impact` tool in system prompt |
| Archive | No slash archive — skip validation | Medium | Manual `openspec validate` |
| Transversal | False expectation: multi-API = multi installed agents | Low | Clarify API keys vs IDE agents |
| Transversal | Second constitutional layer if bundled prompts rival `AGENTS.md` | High | LifeOS discard criterion |
| Transversal | LangChain telemetry / LangSmith defaults | Medium | Operator must configure opt-out per org policy |

## Expected vs observed gains

| Claimed / hoped gain | Assessment |
|----------------------|------------|
| Coordinate OpenAI + Anthropic in one agent | **True** — per-agent/sub-agent `model` + env keys |
| Replace locally installed Cursor/Claude agents | **Misleading** — replaces the *harness*, not IDE integration |
| Replace GitNexus or Graphify | **False** — consumer only |
| Execute Graphify/GitNexus | **True** — MCP, CLI, or artifact reads |
| Makes ByeByeVibe smarter | **False** — same LLM + structured artifacts/graphs |
| Production tracing | **Plausible** — LangSmith integration upstream |
| Kit-default host | **False fit now** — Cursor/Claude Code remain primary |

## Alternatives already in the stack

- **Cursor + Claude Code** — full `/opsx:*`, rules, MCP GitNexus/Graphify, hooks; no Deep Agents required for current operators.
- **Pi (deferred)** — lighter terminal harness; CLI-first, anti-MCP; Deep Agents is the MCP-friendly alternative in the same layer.
- **Deer Workflow (discarded)** — custom graph runtime; Deep Agents sub-agents solve a narrower delegation need without replacing OpenSpec phase state.

## Decision and re-evaluation conditions

**Decision:** **Deferred** — record research; **no install**, no `sdd-kit` payload, no guide §Deep Agents in this cycle.

**Rationale:**

1. Primary hosts remain Cursor and Claude Code — marginal gain for integrated Deep Agents support now.
2. Does not improve graph quality, spec fidelity, or gate enforcement — only runtime/orchestration ergonomics.
3. Meaningful SDD integration (MCP wiring, phase adapter, credential docs) is optional-module scope.
4. **Do not discard** — unlike Graft/code-review-graph, Deep Agents does not occupy GitNexus/Graphify index layers; it is harness-only (same class as Pi).

**Conditions to reopen** (new `/opsx:explore` or operator request):

- Operator builds an **APP/HYBRID service** that needs LangGraph-based agent runtime with GitNexus/Graphify MCP attached.
- **Headless multi-provider pipeline** is required (explicit sub-agent model routing) under SDD artifacts.
- A **maintained adapter** appears wrapping OpenSpec CLI + session scripts without constitutional collision.
- Team standardizes on **Deep Agents Code (`dcode`)** as terminal host and needs parity with `/opsx:*`.

**Out of scope for reopening:**

- Replacing GitNexus or Graphify with Deep Agents filesystem/skills.
- Bundling `deepagents` into `sdd-kit/MANIFEST.yaml` without OpenSpec change.
- Expecting Deep Agents to orchestrate Cursor Cloud Agents or IDE instances via API.

## References

- https://github.com/langchain-ai/deepagents
- https://docs.langchain.com/oss/python/deepagents/overview
- https://docs.langchain.com/oss/python/deepagents/subagents
- https://docs.langchain.com/oss/python/deepagents/models
- https://docs.langchain.com/deepagents-code
- Hub: `doc/byebyevibe-guide.md` §2.3–2.4 · `AGENTS.md` (knowledge sources)
- Prior: [`2026-09-03-pi-coding-agent-harness.md`](./2026-09-03-pi-coding-agent-harness.md) · [`2026-08-17-nanonets-graft.md`](./2026-08-17-nanonets-graft.md) (graph replacement discard criterion)
