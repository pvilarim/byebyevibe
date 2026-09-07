# Evaluation: Pi — terminal coding agent harness (host adapter candidate)

| Field | Value |
|-------|--------|
| **Date** | 2026-09-03 |
| **Evaluator** | Chat research session (Cloud Agent) — operator request to keep on radar, no install |
| **Candidate** | [Pi](https://github.com/earendil-works/pi) (`@earendil-works/pi-coding-agent`, MIT) · [pi.dev](https://pi.dev) |
| **Decision** | **Deferred** — optional third harness host; no kit payload or install now |
| **Scope** | Harness layer (agent runtime) — not a replacement for OpenSpec, GitNexus, or Graphify |

## Executive summary

Pi is a **minimal terminal coding harness**: unified multi-provider LLM API (`pi-ai`), agent runtime (`pi-agent-core`), and interactive CLI (`pi-coding-agent`). It competes with **Claude Code**, **Cursor agent**, and **Codex CLI** — not with the ByeByeVibe **control plane** (OpenSpec + graphs + `sdd-kit` + `sdd-gates`).

**Deferred** as radar-only: the stack already targets **Cursor** and **Claude Code** as primary hosts. Pi would matter only as a **third host** for terminal-first operators or headless/RPC automation — via a future **pi package + guide section**, not by bundling Pi into `sdd-kit`. **Pi does not make the SDD stack more intelligent**; it only changes *how* the agent loop runs. Intelligence stays in OpenSpec (intent), GitNexus (code impact), and Graphify (knowledge).

**Not installing now** — operator decision (2026-09-03).

## Problem it tried to solve

Two questions from the research session:

1. **How does Pi differ from the ByeByeVibe harness?** — Pi is the motor; ByeByeVibe is the OS/process between motor and repo.
2. **Would integrating Pi add intelligence or work inside Cursor/Claude Code?** — No to both. Integration is harness **choice**, not cognition; Pi is an **alternative** host, not an add-on inside existing IDEs.

Candidate gap (only if pursued later):

- **Terminal-first operators** who refuse Cursor/Claude Code but want the same `openspec/` discipline.
- **Heterogeneous teams** — shared git artifacts, different harnesses per developer.
- **Headless fan-out** — Pi's `print`/RPC/JSON modes (same niche as Deer Workflow's `PiAgent`, which this repo already references in a discarded evaluation).

## What was analyzed

- [Pi monorepo `README.md`](https://github.com/earendil-works/pi) — package map, permissions, supply-chain posture.
- [`packages/coding-agent/README.md`](https://github.com/earendil-works/pi/tree/main/packages/coding-agent) — defaults, philosophy, CLI modes, context files.
- [Pi documentation](https://pi.dev/docs/latest) — quickstart, extensions, skills, sessions, compaction, programmatic usage.
- ByeByeVibe hub: `README.md`, `doc/byebyevibe-guide.md` §2.1 / §4 (stack responsibilities), `openspec/project.md` (profile, non-goals).
- Prior art in this repo: [`2026-08-13-deer-workflow.md`](./2026-08-13-deer-workflow.md) (`PiAgent` as replaceable backend); [`2026-08-11-lifeos.md`](./2026-08-11-lifeos.md) (constitutional-layer discard criterion); course mention in `doc/curso/aula-01-shared-files.md` (pi.dev link).

### Verified facts

- **Layer:** Pi = harness (LLM + agent loop + default tools `read`/`write`/`edit`/`bash`). ByeByeVibe = repo-scoped control plane on top of a chosen harness.
- **Philosophy (explicit):** minimal core; **no built-in MCP**, sub-agents, plan mode, permission popups, or background bash — extend via TypeScript extensions, skills, prompt templates, and pi packages. [Rationale blog posts linked from upstream README.]
- **Context files:** Pi discovers `AGENTS.md` and `CLAUDE.md` — partial SDD constitution already flows without formal integration.
- **Multi-provider:** subscriptions (Anthropic, OpenAI/Codex, GitHub Copilot) and many API-key providers; model catalog maintained upstream.
- **Modes:** interactive TUI, print/JSON, RPC (stdin/stdout JSONL), SDK embed — relevant only for optional headless scopes.
- **Sandbox:** no built-in permission system; container patterns documented (Gondolin, Docker, OpenShell).
- **ByeByeVibe today:** `sdd-kit/install.sh` ships `.cursor/` and `.claude/` surfaces (commands, rules, skills); **no Pi-specific payload**. Primary hosts documented in `doc/byebyevibe-guide.md` are Cursor and Claude Code.

### Not verified

- Pi `src/` implementation, extension API stability, and release cadence at pin time. `[NEEDS VERIFICATION]`
- Whether a community pi package already wraps OpenSpec slash workflows. `[NEEDS VERIFICATION]`
- Token/cost comparison Pi vs Claude Code for equivalent SDD apply sessions. `[NEEDS VERIFICATION]`

## Architecture comparison

```
┌─────────────────────────────────────────────────────────┐
│  ByeByeVibe (control plane — repo-scoped)               │
│  OpenSpec · GitNexus · Graphify · sdd-kit · sdd-gates   │
├─────────────────────────────────────────────────────────┤
│  Harness (operator choice — one per session)            │
│  Cursor │ Claude Code │ Pi │ Codex │ …                  │
├─────────────────────────────────────────────────────────┤
│  LLM providers                                          │
└─────────────────────────────────────────────────────────┘
```

| Dimension | Pi | ByeByeVibe (today) |
|-----------|----|--------------------|
| Agent loop | Native | Delegated to Cursor / Claude Code |
| Spec workflow | Not built-in | OpenSpec `/opsx:*` |
| Code graph | Not built-in | GitNexus (MCP + CLI) |
| Knowledge graph | Not built-in | Graphify (MCP + CLI) |
| CI gates | Not built-in | `sdd-gates` |
| Durable memory | Sessions + context files | Git artifacts (`openspec/`) |
| "Smarter" reasoning | No — same LLM underneath | No extra LLM — graphs + specs structure work |

## Integration direction (if reopened)

**Correct vector:** ByeByeVibe **recognizes Pi as a supported host** (guide §Pi + optional pi package), **not** embedding Pi in `sdd-kit` or merging into Pi upstream.

| Approach | Verdict |
|----------|---------|
| Add Pi as third host (pi package, CLI wrappers for openspec/gitnexus/graphify) | Aligned |
| Bundle Pi inside `sdd-kit` | Rejected — wrong layer, governance churn |
| Run Pi inside Cursor/Claude Code | Nonsensical — competing harnesses, not composable |
| Expect MCP parity on Pi | Conflicts with Pi philosophy — use **CLI path** (already preferred for occasional tools in `sdd-tooling-guidance`) |

### Partial overlap today (no install)

| Capability | Cursor / Claude Code | Pi (unintegrated) |
|------------|----------------------|-------------------|
| `AGENTS.md` rules | ✅ | ✅ (context file) |
| `/opsx:*` commands | ✅ | ❌ manual |
| `.cursor/rules` globs | ✅ | ❌ |
| PreToolUse GitNexus hooks | ✅ (Claude Code) | ❌ |
| MCP GitNexus / Graphify | ✅ | ❌ (anti-MCP by design) |
| `sdd-session-*` locks | ✅ documented | scripts work; no IDE wiring |

## Fit with the SDD stack

| Tool | Relation |
|------|----------|
| OpenSpec | **Complementary.** Pi has no change lifecycle; repo artifacts remain authoritative. Future pi package would wrap `npx openspec` / validate — not replace OpenSpec. |
| GitNexus | **Complementary.** No overlap with Pi core. Access via CLI (preferred on Pi) or optional MCP extension — not kit-default. |
| Graphify | **Complementary.** Same as GitNexus. |
| AGENTS.md / sdd-kit | **Compatible read-only today.** Pi loads `AGENTS.md`. Full fit needs host-specific adapter (slash commands, phase reminders) without a second constitutional layer — same guard as LifeOS discard. |
| Cursor / Claude Code | **Siblings, not parents.** Pi does not enhance them; operators pick one harness per session. |
| `sdd-gates` | **Harness-agnostic.** CI unchanged regardless of host. |

## Risks by workflow phase

| Phase | Risk | Severity | Notes |
|-------|------|----------|-------|
| Explore | Operator skips Graphify because Pi has no MCP hook | Medium | Mitigation: CLI `graphify query` in pi package |
| Propose | No `/opsx:propose` — ad-hoc coding without R7 gate | High | Main gap without adapter |
| Apply | No PreToolUse impact enrichment | Medium | Manual `gitnexus impact` or extension |
| Archive | No slash command — easy to skip archive | Medium | |
| Transversal | False expectation that Pi adds "intelligence" | Low | Education / guide wording |
| Transversal | Two constitutional layers if pi package ships rival prompts | High | Same criterion as LifeOS discard |

## Expected vs observed gains

| Claimed / hoped gain | Assessment |
|--------------------|------------|
| Pi makes ByeByeVibe smarter | **False.** Cognition = LLM + structured artifacts/graphs; Pi is transport. |
| Works inside Cursor and Claude Code | **False.** Alternative host only. Those IDEs remain the primary surfaces. |
| Same repo, different harnesses | **True** — core value of deferred integration |
| Terminal-first + multi-provider | **True** — Pi's native strengths |
| Headless apply / RPC automation | **Plausible niche** — overlaps Deer Workflow deferred i18n runner, not daily interactive SDD |
| CLI-first tool access fits Pi anti-MCP stance | **True** — aligns with `sdd-tooling-guidance` CLI-before-MCP |

## Alternatives already in the stack

- **Cursor + Claude Code** — full `/opsx:*`, rules, MCP, hooks; no Pi required for current operators.
- **`AGENTS.md` alone on Pi** — partial discipline today for experiments; not endorsed as production path.
- **Deer Workflow `PiAgent`** — headless Pi as a node runtime; discarded as SDD pipeline but documents Pi as substitutable motor ([`2026-08-13-deer-workflow.md`](./2026-08-13-deer-workflow.md)).

## Decision and re-evaluation conditions

**Decision:** **Deferred** — keep on radar; **no install**, no `sdd-kit` payload, no guide §Pi in this cycle.

**Rationale:**

1. Current team/host standard is Cursor and Claude Code — marginal gain for integrated Pi support now.
2. Pi does not improve spec fidelity, graph quality, or gate enforcement — only host ergonomics.
3. Meaningful integration is non-trivial (pi package, guide section, CLI wiring) — optional-module scope, not a one-line install.

**Conditions to reopen** (new `/opsx:explore` or operator request):

- One or more operators **standardize on Pi** as primary harness and need parity with `/opsx:*` without switching IDE.
- A **bounded headless scope** needs Pi RPC/print (e.g. mechanical fan-out) under SDD artifacts — revisit overlap with Deer Workflow deferred i18n runner.
- A **maintained pi package** appears that wraps OpenSpec + CLIs without constitutional collision — evaluate adopt vs document-only.
- Pi ships stable **extension patterns** for phase gates or tool hooks that map cleanly to R7/R11 without forking upstream.

**Out of scope for reopening:**

- Replacing Cursor/Claude Code as kit-default hosts.
- Bundling Pi binary or npm package inside `sdd-kit/MANIFEST.yaml`.
- Expecting Pi to replace GitNexus/Graphify MCP paths without CLI adapters.

## References

- https://github.com/earendil-works/pi
- https://pi.dev/docs/latest
- https://mariozechner.at/posts/2025-11-30-pi-coding-agent/ (philosophy — linked from upstream README)
- Hub: `doc/byebyevibe-guide.md` §2.1, §4 · `README.md` (control plane positioning)
- Prior: [`2026-08-13-deer-workflow.md`](./2026-08-13-deer-workflow.md) · [`2026-08-11-lifeos.md`](./2026-08-11-lifeos.md)
