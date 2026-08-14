# ByeByeVibe

**From vibe coding to shippable AI engineering.**

**ByeByeVibe** is the public name of this project. The install payload lives in [`sdd-kit/`](./sdd-kit/).

An **installable toolkit for AI-assisted development** on **Cursor** and **Claude Code** — the missing operating system between your coding agent and a maintainable repo. Specs, code & knowledge graphs, CI gates, and session discipline, packaged so you don't invent process from scratch.

[OpenSpec](https://github.com/Fission-AI/OpenSpec) · [GitNexus](https://github.com/abhigyanpatwari/GitNexus) · [Graphify](https://github.com/Graphify-Labs/graphify) — see [Core tools](#core-tools) for what each one does.

*Vibe coding until the first PR. After that, agentic engineering.*

## Why install this

- **Durable memory** — specs and decisions live in `openspec/`, not in chat history
- **Impact before edits** — GitNexus maps your code so agents check blast radius first
- **Team knowledge reused** — Graphify surfaces architecture and past decisions without blind grepping
- **Enforced quality** — CI `sdd-gates` validates specs and task patterns (fail-closed)
- **Versioned control plane** — `sdd-kit/` installs and upgrades rules, scripts, and gates with `MANIFEST.yaml`
- **Gap-aware** — notices when you keep re-teaching the same facts (offers a skill) or narrating manual steps (offers a CLI/MCP integration) — offer-only, never creates or installs anything unprompted

> **Not another Next.js starter — the SDD control plane**  
> **(OpenSpec + graphs + gates) your repo is missing.**

## Get started (30 seconds)

```bash
# Preview what the kit would install (no writes)
bash sdd-kit/install.sh --profile DOCS_SPECS --dry-run

# Or for an application repo:
bash sdd-kit/install.sh --profile APP --dry-run
```

Profiles: `APP` · `DOCS_SPECS` — see [`sdd-kit/README.md`](./sdd-kit/README.md).

## The problem

Coding agents forget context, hallucinate APIs, and overwrite each other's `AGENTS.md`. Chat-only “vibe coding” ships fast — until the repo becomes unmaintainable. Spec-driven development fixes that **if** the workflow, graphs, and gates are installed and governed.

## Core tools

| Tool | What it is | Without it |
|------|------------|------------|
| **OpenSpec** | Playbook for a change — think, agree, implement, archive (`/opsx:*`) | Chat turns into code; nobody remembers why |
| **GitNexus** | Map of your repo's code + impact analysis | The AI edits by vibe and breaks the neighborhood |
| **Graphify** | Knowledge graph — concepts, architecture, relations | The AI reinvents decisions you wrote last month |
| **`sdd-kit/`** | Versioned install payload (rules, scripts, workflows, gates) | Every repo invents the process from scratch |
| **CI `sdd-gates`** | Fail-closed validation (`openspec validate`, task patterns, OSV) | Specs become decoration |
| **Session locks** | Safe parallelism across git worktrees | Concurrent agents overwrite each other |
| **AGENTS.md** | Single curated agent entry point ([agents.md](https://agents.md/)) | Install order fights and overwrites agent config |

Full didactic install path: guide [§2.1](./doc/byebyevibe-guide.md#21-order-matters) · first-contact [§2.0b](./doc/byebyevibe-guide.md#20b-first-contact--vibe-coder-quickstart).

## User-friendly OpenSpec

Discipline without ceremony — friendly onboarding, not theatre.

| Entry | When to use |
|-------|-------------|
| **`/opsx:help`** | Day-1 operator map after install — files, phases, confidence (`doc/sdd-operator-day1.md`) |
| **`/opsx:onboard`** | Learn by doing one full OpenSpec cycle (upstream; we don't fork it) |
| **`/opsx:explore`** | Think before you build — research only, no code |
| **`/opsx:propose` → `apply` → `archive`** | Spec-driven change lifecycle |

Suggested order: **help** (map) → **onboard** (practice) → real changes.

C1 install uses plain-language banners (What / Why / Without it) so operators understand each step — see guide §2.1–2.4.

## Demo — `/opsx` loop (text)

```
You:  /opsx:explore "should we add rate limiting?"
Agent: researches → writes research.md (no code yet)

You:  /opsx:propose add-api-rate-limit
Agent: proposal → design → specs → tasks (you review)

You:  /opsx:apply
Agent: implements tasks · marks checkboxes · runs gates

You:  /opsx:archive
Agent: promotes specs · archives the change
```

Same discipline in Cursor or Claude Code.

## Optional modules

Install the core stack first (C1). Add these only when you need them:

| Module | Code | What you get |
|--------|------|----------------|
| **UI / design system** | C1-UI | Impeccable + shadcn + design pipeline — guide §2.11 |
| **Probity (TDD enforce)** | G2 | `@nizos/probity` for APP — guide §2.16 |
| **Post-apply reviews** | skills | `correctness-review` · `simplify-review` — on-demand, manual install |
| **SDD metrics** | G4 | `sdd-metrics.sh` — volume, lead time, rework — guide §2.17 |

## Calibrate as you go

Built-in **SDD retrospectives** — `sdd-metrics.sh` turns your archive history into volume, lead-time, and rework signals. After every few shipped changes, a gentle cadence nudge asks you to run the report and make **one** process adjustment. The more you ship through the loop, the more signal you have to calibrate *your* workflow — measurable, not magic. (No ML claims.)

The same posture covers memory and integrations: re-teach the agent the same domain facts and it offers to save a skill; watch it fall back to manual steps for the same external tool twice and it offers a CLI/MCP integration — `bash scripts/verify-infra.sh` reports which integrations are configured, missing, or declined. Everything is offer-only: nothing is created or installed without your decision.

```bash
bash scripts/sdd-metrics.sh
```

Details (pt-BR): guide §2.17.

## Not another starter kit

| You might be looking for… | This kit is… |
|---------------------------|--------------|
| Next.js / auth / DB boilerplate | **No** — bring your own app stack |
| “Prompt → full app in 30s” | **No** — we upgrade how agents work *in* your repo |
| Specs + graphs + gates + install/upgrade | **Yes** — the control plane |

If you need a vibe *template*, use one — then install this kit on top.

## Who it's for

- Solo / small teams on **Cursor** or **Claude Code** leaving chaotic vibe coding for **agentic engineering**
- Brownfield repos that need agent discipline without a second orchestration framework
- Hubs that distribute SDD payloads (`sdd-kit/`) to many consumer repos

## Stack & companions

We **compose** OpenSpec; we don't replace it.

- [OpenSpec](https://github.com/Fission-AI/OpenSpec) · [GitNexus](https://github.com/abhigyanpatwari/GitNexus) · [Graphify](https://github.com/Graphify-Labs/graphify) · [agents.md](https://agents.md/)
- Install kit: [`sdd-kit/`](./sdd-kit/) · Constitution: [`openspec/project.md`](./openspec/project.md)

## Docs

| Doc | Language | Role |
|-----|----------|------|
| This README | EN | Discovery / first contact |
| [`doc/byebyevibe-guide.md`](./doc/byebyevibe-guide.md) | pt-BR | Canonical install & operations guide |
| [`doc/sdd-operator-day1.md`](./doc/sdd-operator-day1.md) | EN | Day-1 operator map (`/opsx:help`) |
| [`sdd-kit/README.md`](./sdd-kit/README.md) | EN | Kit scenarios & commands |
| [`doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`](./doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md) | EN | Market / SEO / backlog decisions |

## Maintainer

Pedro Vilarim — [LinkedIn](https://www.linkedin.com/in/pedrovilarim/) · [Portfolio](https://pedrocodeart.netlify.app/)
