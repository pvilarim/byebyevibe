# Evaluation: Headroom — context compression for agents

| Field | Value |
|-------|--------|
| **Date** | 2026-03-26 |
| **Evaluator** | Evaluation session (Pedro Vilarim + agent) |
| **Candidate** | [Headroom](https://github.com/chopratejas/headroom) (`headroom-ai`) |
| **Decision** | **Discarded** — do not integrate into `sdd-kit` or the normative SDD pipeline |
| **Scope** | Optional compression layer (proxy / MCP / library) over tool outputs and conversation history |

## Executive summary

Headroom compresses tool outputs, logs, RAG, and history **before** they reach the LLM, with reversible compression (CCR) and integration with Cursor/Claude via proxy or MCP. It was evaluated as a possible “layer 4” of the SDD stack to save tokens. **Conclusion: gains do not justify the risks** compared to patterns already adopted (subagents with synthesis, short `AGENTS.md`, deterministic Gates, OpenSpec artifacts). **Deployment discarded.**

## Problem it tried to solve

- Reduce token cost in long sessions with many tool calls (GitNexus, Graphify, grep, verify scripts)
- Mitigate “context rot” without relying only on handoff between phases
- Complement efficiency already described in `doc/sistema-sdd-pedro.md` §7.1 (subagents, short rules)

## What was analyzed

- README and official documentation (architecture, CCR, limitations)
- Fit with `/opsx:explore`, `/opsx:propose`, `/opsx:apply` workflows
- OpenSpec skills and `AGENTS.md` rules (sources 1–6, A–E classification, Gates §12.10)
- Potential conflicts with `AGENTS.md` governance (`headroom learn`, auto-generated blocks)

## Fit with the SDD stack

| Tool | Relation |
|------|----------|
| **OpenSpec** | Normative artifacts (`proposal`, `design`, `tasks`, `specs`) must not be compressed; risk of incomplete trade-offs in propose |
| **GitNexus** | Outputs from `query` / `impact` are candidates for aggressive compression — **exactly** where blast radius and alternative callers matter |
| **Graphify** | Broad queries in explore lose alternatives if sampled before synthesis |
| **AGENTS.md / sdd-kit** | `headroom learn --apply` conflicts with manual curation and the anti-pattern of auto-generated blocks (§2.5.1 SDD guide) |

## Risks by workflow phase

| Phase | Risk | Severity | Notes |
|-------|------|----------|-------|
| **Explore** | Hiding possibilities the model never saw | **High** | Statistical sample ≠ solution space; CCR only helps if the model knows *what* to retrieve |
| **Propose** | `design.md` with incomplete alternatives | **High** | Premature decisions; violates spirit of verifiable sources (R2, R3) |
| **Apply** | Incorrect patch, gate misread, ignored impact | **Medium–high** | Test/Gate logs and first `impact` must not be compressed |
| **Archive** | Low context volume | **Low** | Minimal gain |

**Common mechanism:** the agent acts as if it had seen everything when it worked from a partial view. CCR keeps originals in local cache but **does not guarantee** the model calls `headroom_retrieve` in time.

## Expected vs observed gains

| Advertised gain | Assessment |
|-----------------|------------|
| 60–95% fewer tokens in tool outputs | Real on voluminous JSON/logs; **redundant** with subagents → `knowledge.md` / `codebase.md` in explore |
| Same answers (benchmarks) | Valid on closed tasks; **not transferable** to alternative discovery or normative specs |
| `headroom wrap cursor` | Possible local opt-in; **does not** justify entry in the shared kit |
| Output token shaping | Risk in apply/propose; off by default — marginal gain vs risk |

## Alternatives already in the stack (preferred)

1. **Semantic compression:** subagents (`graphify-researcher`, `codebase-researcher`) return synthesis, not raw noise
2. **On-demand context:** `AGENTS.md` ≤150 lines + file table by situation
3. **Handoff between phases:** new chat propose → apply with git artifacts as source
4. **Deterministic Gates:** exit 0 in `tasks.md` — do not delegate “ready” to the model’s judgment over compressed output
5. **Headroom native passthrough** for code and user messages — partial overlap with protections the SDD already requires by other means

## Decision

**Deployment discarded** for Headroom as part of the SDD system (C1/C2, `sdd-kit`, `openspec/infra.md`, mandatory rules).

**Personal opt-in** (local proxy for voluminous CI logs only, outside explore/propose/Gates) is not forbidden, but **is not documented or supported** by the kit.

### Conditions to reopen evaluation

- Upstream-documented “SDD-safe” mode: per-phase whitelist (never compress Gates, impact, `contextFiles`, specs)
- Evidence from a pilot repo that CCR + shell gates maintain 100% pass rate in apply with compression active
- New OpenSpec proposal (`add-headroom-optional-layer`) with normative guardrails spec — **not** automatic install

## Final positioning

```
OpenSpec + GitNexus + Graphify  →  governs WHAT and WITH WHAT EVIDENCE
Headroom                        →  discarded; not a normative SDD layer
```

## References

- Repository: https://github.com/chopratejas/headroom
- Docs: https://headroom-docs.vercel.app/
- Internal discussion: session 2026-03-26 (explore / propose / apply)
- Index: [README.md](./README.md)
