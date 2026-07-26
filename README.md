# ByeByeVibe

**From vibe coding to shippable AI engineering.**

> **Not another Next.js starter — the SDD control plane**  
> **(OpenSpec + graphs + gates) your repo is missing.**

**ByeByeVibe** is the public name of this project. The install payload lives in `sdd-kit/`.

The missing operating system between your coding agent and a maintainable repo — specs, code & knowledge graphs, CI gates, and session discipline, packaged so you don't invent process from scratch.

## Get started (30 seconds)

```bash
# Preview what the kit would install (no writes)
bash sdd-kit/install.sh --profile DOCS_SPECS --dry-run

# Or for an application repo:
bash sdd-kit/install.sh --profile APP --dry-run
```

Profiles: `APP` · `DOCS_SPECS` · `HYBRID` — see [`sdd-kit/README.md`](./sdd-kit/README.md).

Full procedure (pt-BR): [`doc/sistema-sdd-pedro.md`](./doc/sistema-sdd-pedro.md) · first-contact §2.0b.

## The problem

Coding agents forget context, hallucinate APIs, and overwrite each other's `AGENTS.md`. Chat-only “vibe coding” ships fast — until the repo becomes unmaintainable. Spec-driven development fixes that **if** the workflow, graphs, and gates are installed and governed.

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

Same discipline in Cursor or Claude Code. Optional: after a few archives, run `bash scripts/sdd-metrics.sh` to **calibrate** lead time and rework — see below.

## What's included

| Capability | What you get |
|------------|----------------|
| **OpenSpec** | Spec-driven changes: `/opsx:explore` → `propose` → `apply` → `archive` |
| **GitNexus** | Code graph — impact analysis before you edit symbols |
| **Graphify** | Knowledge graph — concepts & architecture without grepping blind |
| **AGENTS.md** | Single curated agent entry point ([agents.md](https://agents.md/)) — anti-overwrite install order |
| **CI gates** | `sdd-gates` — `openspec validate`, task patterns, OSV when lockfile present |
| **UI module (optional)** | C1-UI — Impeccable / shadcn / design pipeline |
| **Probity (optional)** | G2 — TDD enforce for APP/HYBRID |
| **SDD metrics** | G4 — `sdd-metrics.sh`: volume, lead time, rework + cadence nudge |

### Calibrate as you go

Built-in **SDD retrospectives** — `sdd-metrics.sh` turns your archive history into volume, lead-time, and rework signals. After every few shipped changes, a gentle cadence nudge asks you to run the report and make **one** process adjustment. The more you ship through the loop, the more signal you have to calibrate *your* workflow — not magic, measurable. (No ML / self-learning claims.)

Details (pt-BR): guide §2.17.

## Not another starter kit

| You might be looking for… | This kit is… |
|---------------------------|--------------|
| Next.js / auth / DB boilerplate | **No** — bring your own app stack |
| “Prompt → full app in 30s” | **No** — we upgrade how agents work *in* your repo |
| Specs + graphs + gates + install/upgrade | **Yes** — the control plane |

If you need a Camada B vibe *template*, use one — then install this kit on top.

## Who it's for

- Solo / small teams on **Cursor** or **Claude Code** leaving chaotic vibe coding
- Brownfield repos that need agent discipline without a second orchestration framework
- Hubs that distribute SDD payloads (`sdd-kit/`) to many consumer repos

## Compare (summary)

Stars are order-of-magnitude (~2026-07-26). Full table: [`doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`](./doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md).

| | Spec Kit | OpenSpec | BMAD | **ByeByeVibe** |
|--|----------|----------|------|----------------|
| Spec workflow | ●●●● | ●●●● (CLI we use) | ●●● | ●●●● |
| Code + knowledge graphs | ○ | ○ | ○ | ●●●● |
| Versioned install/upgrade kit | ●●● | ●● | ●●● | ●●●● |
| CI / TDD / metrics | ●● | ● | ●● | ●●●● |

We **compose** OpenSpec; we don't replace it.

## Stack & companions

- [OpenSpec](https://github.com/Fission-AI/OpenSpec) · GitNexus · Graphify · [agents.md](https://agents.md/)
- Install kit: [`sdd-kit/`](./sdd-kit/) · Constitution: [`openspec/project.md`](./openspec/project.md)

## Docs

| Doc | Language | Role |
|-----|----------|------|
| This README | EN | Discovery / first contact |
| [`doc/sistema-sdd-pedro.md`](./doc/sistema-sdd-pedro.md) | pt-BR | Canonical install & operations guide |
| [`sdd-kit/README.md`](./sdd-kit/README.md) | pt-BR (+ EN intro) | Kit scenarios & commands |
| [`doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`](./doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md) | pt-BR | Market / SEO / backlog decisions |

## [AÇÃO MANUAL NECESSÁRIA] — GitHub rename, About & topics

Settings are not in git. After merge, the operator should:

1. **Rename repo** (Settings → General → Repository name): `gitnexus-graphify-openspec` → **`byebyevibe`**
2. Update local remotes: `git remote set-url origin git@github.com:pvilarim/byebyevibe.git` (or HTTPS)
3. Set **About** and **Topics** (below)
4. Optional **Homepage**: `https://pedrocodeart.netlify.app/`

**About:**

> ByeByeVibe — from vibe coding to shippable AI engineering. SDD control plane (OpenSpec + graphs + gates) for Cursor & Claude Code. Not a Next.js starter.

**Topics:** `vibe-coding` · `spec-driven-development` · `context-engineering` · `claude-code` · `cursor`

Full checklist: [evaluation doc](./doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md).

## Maintainer

Pedro Vilarim — [LinkedIn](https://www.linkedin.com/in/pedrovilarim/) · [Portfolio](https://pedrocodeart.netlify.app/)
