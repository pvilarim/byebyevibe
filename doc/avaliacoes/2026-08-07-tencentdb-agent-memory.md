# Evaluation: TencentDB Agent Memory — cross-session memory layer for agents

| Field | Value |
|-------|--------|
| **Date** | 2026-08-07 |
| **Evaluator** | Explore session `/opsx:explore` (Cloud Agent, Claude Code) |
| **Candidate** | [TencentDB-Agent-Memory](https://github.com/TencentCloud/TencentDB-Agent-Memory) (MIT, Node.js ≥ 22.16) |
| **Decision** | Discarded |
| **Scope** | Optional runtime layer (agent memory) — sdd-kit candidate, rejected |

## Executive summary

TencentDB Agent Memory (TDAM) gives agents persistent cross-session memory: an LLM distills conversations into a four-tier pipeline (raw → atomic facts → scenario blocks → user persona), stores it in local SQLite + sqlite-vec, and recalls it via hybrid BM25 + embedding + RRF retrieval. **Discarded** — the conflict is architectural, not configurable. TDAM answers context loss by *inferring* memory with an LLM; the SDD stack answers the same problem by *materializing* memory as reviewed, versioned artifacts. Two of its four memory assets also duplicate layers already installed (Code-Graph ↔ GitNexus, LLM-Wiki ↔ Graphify + `openspec/specs/`), triggering the same overlap criterion that discarded `code-review-graph` five days earlier.

## Problem it tried to solve

Context loss between agent sessions, and token cost in long tool-heavy agentic loops. Specifically: operator preferences and project facts that must be re-explained in every new chat.

## What was analyzed

- Repository `main` branch README (architecture, storage, integrations, benchmarks, security flags) and rendered GitHub landing page (`feat/server_team` branch, team-hub components).
- `openclaw.plugin.json` and `hermes-plugin/` presence on `main` (integration surface).
- Prior decisions: [`2026-03-26-headroom-context-compression.md`](./2026-03-26-headroom-context-compression.md) (provenance / auto-generated blocks), [`2026-08-02-code-review-graph.md`](./2026-08-02-code-review-graph.md) (overlap criterion), [`2026-07-25-oss-coverage-gaps-tooling.md`](./2026-07-25-oss-coverage-gaps-tooling.md) (per-project vs kit payload, G3 precedent).
- Normative constraints: `AGENTS.md` R2/R3/R8/R10, `openspec/specs/sdd-session-handoff/spec.md`, `openspec/specs/sdd-skill-guidance/`, `openspec/project.md` (profile, stack, non-goals).

### Verified facts

- **Two distinct products under one repo.** `main` ships an npm plugin for OpenClaw (`@tencentdb-agent-memory/memory-tencentdb`) plus an HTTP gateway sidecar for Hermes (`:8420`). The team hub (MemoryCore + MemoryHub on `:8125` + **MemoryProxy**) lives on the `feat/server_team` feature branch, not a release.
- **Storage:** SQLite + sqlite-vec by default (local, zero external API). Tencent Cloud Vector Database (TCVDB) optional. Persona and scenario tiers are written as human-readable Markdown under `~/.openclaw/memory-tdai/`; drill-down to ground truth is preserved (no irreversible compression).
- **Requires an external LLM** for L1/L2/L3 extraction and persona generation. Accepts OpenAI-compatible endpoints; falls back to Tencent Cloud LKE when unspecified.
- **Agent tools exposed:** `tdai_memory_search`, `tdai_conversation_search`. **No MCP server.**
- **Claude Code / Cursor support** is claimed in the repository description but no first-class integration was found on `main` — the plausible path is MemoryProxy on the feature branch, i.e. a proxy intercepting LLM traffic. `[NEEDS VERIFICATION]`
- **Benchmarks (upstream, with OpenClaw):** −61.38% token usage and +51.52% relative pass rate on WideSearch over continuous 50-task sessions; PersonaMem accuracy 48% → 76%.
- Star count reported by the rendered page (~16.7k) could not be confirmed at the API (HTTP 403 through the egress proxy). `[NEEDS VERIFICATION]`

## Fit with the SDD stack

| Tool | Relation |
|------|----------|
| OpenSpec | **Adversarial** — memory recalled from L1/L2/L3 is LLM-inferred and enters the agent's context indistinguishable from `specs/` or `changes/` content. R3 requires marking `[NEEDS VERIFICATION]` when no source exists; TDAM provides no provenance channel, so the rule becomes unenforceable. Same failure mechanism as Headroom, aggravated: there the agent acted as if it had seen everything having seen part; here it acts as if it had a source when it has a statistical inference |
| GitNexus | **Frontal overlap** — the Code-Graph asset replicates the installed code graph (1.6.9), cited by name in the B/C/D pipelines. Identical criterion to the `code-review-graph` discard (2026-08-02) |
| Graphify | **Frontal overlap** — the LLM-Wiki asset replicates the concept graph, which is deterministic (AST, no LLM) where TDAM's is generative |
| AGENTS.md / sdd-kit | **Policy conflict** — the Skill asset auto-generates skills, while `sdd-skill-guidance` is normatively **offer-only, never create unprompted**. LLM-written persona and skill files reproduce the auto-generated-block anti-pattern (guide §2.5.1) that reproved `headroom learn --apply` |
| `sdd-session-handoff` | **Adversarial** — the spec mandates a fresh chat per phase and requires the agent to refuse `/opsx:apply` in a chat opened with `/opsx:explore`. Cross-session implicit memory reintroduces from below the coupling the spec forbids from above, and without phase boundaries |

Only **Chat Memory** maps to an uncovered gap.

## Risks by workflow phase

| Phase | Risk | Severity | Notes |
|-------|------|----------|-------|
| Explore | Recalled persona narrows the option space before the model sees it | **High** | Same class of harm as compressing explore output: a prior decision resurfaces as a premise instead of a candidate |
| Propose | `design.md` alternatives shaped by unversioned inference; R8 source citation points at nothing citable | **High** | Violates the spirit of verifiable sources (R2, R3) |
| Apply | Stale memory contradicts current `specs/` with no precedence rule | **Medium–high** | Priority order in R2 has no slot for "agent memory" |
| Archive | Low context volume | **Low** | Minimal gain |

**Common mechanism:** memory without provenance is indistinguishable from evidence, so every rule that depends on source ranking (R2) or source absence (R3) silently degrades.

## Expected vs observed gains

| Advertised gain | Assessment |
|-----------------|------------|
| −61.38% tokens, +51.52% relative pass rate (WideSearch, 50-task sessions) | Plausible for long tool-heavy agentic loops. **Not transferable to this repo** — DOCS_SPECS profile, spec authoring, no such loops. Expected gain here ≈ 0 |
| PersonaMem 48% → 76% | Measures the thing the stack deliberately does *not* automate — operator preference capture is human-gated via `sdd-skill-guidance` |
| Fully local, zero external API | Real for storage; **false for extraction** — L1/L2/L3 require an external LLM, defaulting to Tencent Cloud LKE |
| Reversible drill-down to ground truth | Genuine design strength, and better than Headroom's CCR. Does not fix provenance: the agent still cannot tell inference from source at recall time |
| Symbolic short-term memory (Mermaid + `refs/*.md`) | The most interesting idea in the project, and the most portable — worth borrowing as a *pattern* without adopting the runtime |
| Claude Code / CodeBuddy support | Not evidenced on `main`; the apparent path is a traffic-intercepting proxy, which adds a secrets/supply-chain surface over prompts containing repository content |

## Alternatives already in the stack

1. **Artifacts as memory** — `openspec/specs/` and `changes/` carry decisions across sessions in git, diffable and reviewable.
2. **Deterministic graphs** — Graphify (concepts) and GitNexus (code) answer recall questions from AST, not inference.
3. **Curated operator preference** — `sdd-skill-guidance`: the agent offers, the human decides, the result is a versioned skill.
4. **Explicit phase handoff** — `sdd-session-handoff` treats a clean context as the mechanism, not the defect.
5. **Semantic compression by subagent** — `graphify-researcher` / `codebase-researcher` return synthesis with cited sources.

## Decision and re-evaluation conditions

**Decision:** **Discarded** for `sdd-kit`, `openspec/infra.md`, and the normative SDD pipeline.

Personal opt-in outside the explore/propose/apply phases is not forbidden, but is neither documented nor supported by the kit.

**Conditions to reopen:**

- First-class Claude Code **or** Cursor integration on `main` — via MCP, not via a proxy intercepting LLM traffic.
- A recall mode that **marks provenance** on injected content, so R2 ranking and R3 gap-marking stay enforceable.
- A genuine cross-session memory need in an APP/HYBRID target repo running long agentic loops — evaluated as a per-project module (G3 precedent: production infra, not kit payload), never as kit payload for this DOCS_SPECS hub.
- Scope restricted to **Chat Memory**. Code-Graph and LLM-Wiki stay out permanently by overlap with GitNexus and Graphify; the Skill asset stays out by conflict with `sdd-skill-guidance`.
- Independent of adoption: the **symbolic short-term memory** pattern (task state as Mermaid, verbose logs offloaded to `refs/*.md` behind node-id pointers) may be evaluated on its own as an SDD task-pattern, with no runtime dependency.

## Final positioning

```
OpenSpec + GitNexus + Graphify  →  memory as reviewed, versioned artifacts
TencentDB Agent Memory          →  discarded; memory as LLM inference, no provenance
```

## References

- Repository: https://github.com/TencentCloud/TencentDB-Agent-Memory
- `README_CN.md`: https://github.com/TencentCloud/TencentDB-Agent-Memory/blob/main/README_CN.md
- `openclaw.plugin.json`: https://github.com/TencentCloud/TencentDB-Agent-Memory/blob/main/openclaw.plugin.json
- Team-hub branch: https://github.com/TencentCloud/TencentDB-Agent-Memory/tree/feat/server_team/MemoryCore/openclaw-plugin
- Provenance precedent: [`2026-03-26-headroom-context-compression.md`](./2026-03-26-headroom-context-compression.md)
- Overlap precedent: [`2026-08-02-code-review-graph.md`](./2026-08-02-code-review-graph.md)
- Per-project vs kit payload precedent (G3): [`2026-07-25-oss-coverage-gaps-tooling.md`](./2026-07-25-oss-coverage-gaps-tooling.md)
- Index: [README.md](./README.md)
