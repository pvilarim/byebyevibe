# AI-Assisted Development System

**GitNexus + Graphify + OpenSpec, integrated in Cursor and VS Code + Claude Code**

> **Canonical install guide (v1.11.0)** — use in any Git repository, manually or via an AI agent. Payloads in `sdd-kit/`; procedure in this document.

## How to use this document

| Mode | Action |
|------|--------|
| **First contact / vibe coder** | §2.0b → root [`README.md`](../README.md) (**ByeByeVibe**) + `bash sdd-kit/install.sh --profile X --dry-run` |
| **Human — new install (C1)** | §2.1 → CLIs → `bash sdd-kit/install.sh --profile X` → §2.8 → §2.12 → §2.13 (APP/HYBRID) |
| **Human — upgrade (C2)** | §2.9 + `bash sdd-kit/upgrade.sh --dry-run` → §12.8 → `--apply` |
| **Human — CLIs only (C2b)** | §2.9.4 — without touching `sdd-kit/templates/` |
| **Spec propagation (C3)** | git/reference in `openspec/specs/` — **without** `install.sh` |
| **AI agent — install** | Prompt §2.0; use `sdd-kit/install.sh`, **do not** extract §12 |
| **AI agent — upgrade** | §2.9.2 + `sdd-kit/upgrade.sh --dry-run` + §12.8 before editing |
| **Pilot / test** | `bash sdd-kit/verify.sh` + checklist §2.8 or §2.9.7 |
| **SDD metrics (G4)** | `bash scripts/sdd-metrics.sh` — §2.17 (mode C; no DevLake) |

- **`AGENTS.md` pattern:** aligned with [agents.md](https://agents.md/) + TLC workshop (Context Engineering, on-demand loading).
- **Guide version:** 1.11.0 — see [Guide changelog](#changelog-do-guia).
- **Versioned payload:** `sdd-kit/MANIFEST.yaml` — see §1.6 and `sdd-kit/README.md`.
- **Does not replace** `openspec/project.md` (project constitution) or specs in `openspec/specs/`.

---

## Honest upfront note on real friction

First things first: the three tools generate or modify `AGENTS.md`/`CLAUDE.md` when installed. Without explicit governance this creates conflicts — one tool overwrites what another wrote. This guide solves that with **a single `AGENTS.md` curated by you**, with all three tools installed using flags that prevent overwrite. See sections 4 and 9 for details.

Second friction: the ecosystem moves fast. Versions in this document are from May 2026. Basic commands are stable; exotic flags may change — confirm with `--help` before automating.

---

## Table of contents

1. [Prerequisites](#1-prerequisites-question-6) — includes §1.6 (organization and scenarios C1–C3)
2. [Installation step by step](#2-passo-a-passo-de-instalação-questão-1) — includes §2.0 (AI), §2.0b (first contact / vibe coder), §2.5 (AGENTS.md), §2.8 (verification), §2.9 (upgrade), §2.12 (CI gates), §2.13 (supply chain), §2.16 (Probity), §2.17 (SDD metrics)
3. [Task classification and pipelines](#3-classificação-de-tarefas-e-pipelines-questões-2-3-31)
4. [Master table: tool × responsibility × I/O](#4-tabela-mestre-questão-3)
5. [Documents and cross-references](#5-documentos-e-referências-cruzadas-questão-32) — includes §5.5 (integration evaluations)
6. [Research dimension and dubious-source prevention](#6-dimensão-de-research-questão-33)
7. [Protocols per task: tokens, hallucinations, security, audit](#7-protocolos-por-tarefa-questão-34)
8. [General system rules and where they live](#8-regras-gerais-do-sistema-questão-4)
9. [Cursor configuration](#9-configuração-cursor-questão-5)
10. [VS Code + Claude Code configuration](#10-configuração-vs-code--claude-code-questão-5)
11. [Code protocols](#11-protocolos-de-código-questão-7)
12. [Annexes: complete templates](#12-anexos-templates-completos)
13. [Workshop alignment ↔ agents.md](#13-alinhamento-workshop--agentsmd)
14. [Guide changelog](#changelog-do-guia)

---

## 1. Prerequisites (question 6)

### 1.1 Operating system and runtimes

| Component | Minimum version | Notes |
|---|---|---|
| OS | macOS 13+, Ubuntu 22.04+, Windows 11 + WSL2 | Native Windows works but WSL2 avoids 80% of issues |
| Node.js | 20.19.0+ | Required for OpenSpec and GitNexus |
| Python | 3.10+ | Required for Graphify |
| Git | 2.40+ | Required for auto-rebuild hooks |
| Build tools | `python3 make g++` (Linux), Xcode CLT (macOS) | GitNexus needs these for tree-sitter; you can skip with `GITNEXUS_SKIP_OPTIONAL_GRAMMARS=1` |

### 1.2 Recommended install tools

Automated check of the tables above (phase 0 — before C1):

```bash
# Prefer expanded script after install; kit template works on hub / pre-expand
bash scripts/preflight-sdd.sh --all
# or: bash sdd-kit/templates/scripts/preflight-sdd.sh --all
```

Exit non-zero on FAIL (missing Git/Node≥20.19/npm/Python≥3.10, missing `sdd-kit/`, unwritable repo). WARN (uv, build tools, IDE, github-mcp) does not abort. Bootstrap runs this automatically unless `--skip-preflight`.

```bash
# uv for Python (faster than pip, manages PATH automatically)
curl -LsSf https://astral.sh/uv/install.sh | sh

# pnpm for Node (optional but recommended)
npm install -g pnpm
```

### 1.3 IDEs

- **Cursor** ≥ 1.0 (the current version already supports `.cursor/rules/*.mdc` with YAML frontmatter)
- **VS Code** ≥ 1.109 (Feb 2026 — native reading of `CLAUDE.md`, `.claude/rules`, `.claude/agents`, `.claude/skills`)
- **Claude Code CLI** ≥ 2.1.140 (May 2026 — VS Code extension is a shell over the CLI)

### 1.4 Subscription

Claude Pro/Max OR Anthropic API key. Without this, Claude Code does not work. OpenSpec, GitNexus, and Graphify are open source and free — you only pay for the LLM engine behind them.

### 1.5 Minimum prior knowledge

- Know how to edit JSON and YAML
- Comfortable in the terminal (you will use `cd`, `npm`, `pip`, `git` often)
- Understand MCP at a high level (the protocol that connects tools to the agent)

### 1.6 Project organization and install types

The SDD stack is organized in **four layers** — do not confuse procedure with payload:

| Layer | Artifact | Role |
|--------|-----------|-------|
| **Procedure** | `doc/byebyevibe-guide.md` | How to install/upgrade; scenarios C1–C3 |
| **Versioned payload** | `sdd-kit/templates/` + `MANIFEST.yaml` | Copyable files, shell gates |
| **Normative requirements** | `openspec/specs/sdd-*` | What MUST exist after install |
| **Workspace state** | `openspec/infra.md`, `project.md` | What is ✅ in this repo |

#### Install scope

Not everything installs per project — the stack splits across three **install scopes**:

| Scope | Installed by | Example artifacts |
|-------|--------------|-------------------|
| **Machine — once** | `bootstrap-sdd.sh` package installs | OpenSpec CLI, GitNexus CLI, Graphify CLI (`uv tool install graphifyy`), MCP config (`~/.cursor/mcp.json`) |
| **Repo — copied payload** | `sdd-kit/install.sh` per project | `AGENTS.md`, `CLAUDE.md`, `.cursor/rules/`, skills, `scripts/`, CI workflow |
| **Repo — generated state** | Each project's own tools | `openspec/` (specs + changes), `graphify-out/`, `.gitnexus/` — born inside each project, never shared between projects |

**Hub → destination flow (canonical multi-project UX):** keep **one hub clone per machine**; install into any target project with one command:

```bash
bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>
```

Per-project reinstallation covers **only the repo-copied payload** — machine-level CLIs are **not reinstalled per project** (bootstrap skips package installs already present; CLI refresh is scenario C2b, §2.9.4).

> This table is the canonical scope model. Other surfaces (kit README, day-1 doc, banners) summarize it in at most three sentences and link here — they do not duplicate it.

#### Install scenarios

| Code | Situation | Entry command |
|--------|----------|-------------------|
| **C1** | Greenfield install (first-time SDD) | `bootstrap-sdd.sh` → `bash sdd-kit/install.sh --profile APP\|DOCS_SPECS` (`HYBRID` deprecated alias — see below) |
| **C2** | SDD upgrade (new guide/kit version) | `bash sdd-kit/upgrade.sh --from X --to Y --dry-run` → approval → `--apply` |
| **C2b** | Outdated CLIs only | §2.9.4 — **without** touching curated kit |
| **C3** | Domain spec propagation | Reference in `openspec/specs/<domain>/` — **do not** run `install.sh` |
| **C1-UI** | Optional UI module (post-C1) | `bash sdd-kit/install-ui-module.sh --detect` → `--apply [--yes]` — see §2.11 |

**Golden rule:** C3 (product normative content) ≠ C2 (SDD infra). Publishing a billing spec in the hub **does not** require reinstall in APP repos.

#### Repository profiles

Every install answers one plain question: **will this repository hold application code?**

- **Yes → `APP`.** Command table §12.2a; TS/Supabase rule files.
- **No, docs/specs only → `DOCS_SPECS`.** Command table §12.2b.

Whichever you answer, three things stay true:

1. **Every profile installs the complete framework.** OpenSpec, GitNexus, Graphify, session coordination, and skills are not profile-gated — profiles only adjust the `AGENTS.md` command table and a few stack-specific rule files (e.g. the TS/Supabase rules that ship with APP).
2. **This hub's `doc/` and `openspec/` content is ByeByeVibe's own development history.** The target project never receives it, never needs it, and grows its own `openspec/` state from day one (specs, changes, `project.md`) — regardless of which profile you picked.
3. **This question is independent of the language question.** The three language axes (`chat_language`, `docs_language`, `code_language` — §2.1.1) are a separate install step; answering APP or DOCS_SPECS here does not set or imply any language.

**`HYBRID` is deprecated (kit 1.9.0).** It used to name repositories mixing `package.json` with `openspec/`, but the one file that ever distinguished it from APP — `scripts/verify-task-patterns.sh` — now ships to every profile, so HYBRID's payload is byte-identical to APP's. `--profile HYBRID` still works everywhere it used to (`install.sh`, `upgrade.sh`, `bootstrap-sdd.sh`): it prints a one-line deprecation notice and proceeds as APP. Answer APP or DOCS_SPECS directly for new installs.

| Profile | `--profile` | Commands table | Notes |
|---------|-------------|-----------------|-------|
| **APP** | `APP` | §12.2a | TS/Supabase rule files |
| **DOCS_SPECS** | `DOCS_SPECS` | §12.2b | — |
| ~~HYBRID~~ | `HYBRID` | (→ APP) | Deprecated alias since kit 1.9.0 — normalizes to APP with a deprecation notice |

#### Hub vs consumer

- **Hub (e.g. spec-pedro, DOCS_SPECS):** commit the full `sdd-kit/` to distribute C2 upgrades.
- **APP consumer:** may keep only expanded files (`scripts/`, `.cursor/rules/`); copy `sdd-kit/` on upgrade as needed.

Exact commands: `sdd-kit/README.md`.

#### Minimal install-fetch footprint (C1)

For a genuine greenfield install (C1 — no `sdd-kit/` yet in the target repo), fetching the **whole hub repository is not required**. The minimal install-fetch footprint — the exact set of paths `sdd-kit/install.sh` and the `scripts/bootstrap-sdd.sh`/`scripts/preflight-sdd.sh` orchestrators read during C1 — is exactly:

- `sdd-kit/` (whole subtree — every `MANIFEST.yaml` entry sources from `templates/...` inside it)
- `scripts/bootstrap-sdd.sh`
- `scripts/preflight-sdd.sh`

No other repository path — including hub-only `doc/`, hub-only `openspec/` (this hub's own specs/changes history), or root `.cursor/`/`.claude/` (this hub's own IDE config) — is read by `install.sh` or by the bootstrap/preflight scripts during C1.

#### Lightweight fetch recipe (no full clone, C1 greenfield only)

> Applies **only** when `sdd-kit/` is not already present in the target repository (C1). Do **not** use this for C2 (upgrade — use `sdd-kit/upgrade.sh --dry-run`/`--apply`) or C3 (spec propagation — must not run `install.sh`/`upgrade.sh`).

Fetch just the minimal footprint above with a partial clone + non-cone sparse-checkout (git ≥2.40, already a hard prerequisite — §1.1), copy it into the target repo root, then discard the temporary clone:

```bash
TMPDIR=$(mktemp -d)
git clone --filter=blob:none --depth 1 --no-checkout --sparse <hub-repo-url> "$TMPDIR"
git -C "$TMPDIR" sparse-checkout set --no-cone /sdd-kit/ /scripts/bootstrap-sdd.sh /scripts/preflight-sdd.sh
git -C "$TMPDIR" checkout
cp -R "$TMPDIR"/sdd-kit ./sdd-kit
mkdir -p ./scripts
cp "$TMPDIR"/scripts/bootstrap-sdd.sh "$TMPDIR"/scripts/preflight-sdd.sh ./scripts/
rm -rf "$TMPDIR"
```

Fallback (only if the remote rejects `--filter=blob:none`, e.g. `uploadpack.allowFilter` disabled): drop `--filter=blob:none` and keep the rest (`--depth 1 --no-checkout --sparse` + the same `sparse-checkout set --no-cone`) — still no full history, still no unrelated top-level directories.

Nothing is written to the target repo until the final `cp` step, so it is safe to rerun from scratch if interrupted. After the copy, the existing documented command runs unmodified: `bash scripts/bootstrap-sdd.sh --profile <PROFILE>`.

---

## 2. Installation step by step (question 1)

### 2.0b First contact / vibe coder (quickstart)

Coming from *vibe coding* and want the minimum path **without** reading the entire guide?

1. Read the hero and demo in [`README.md`](../README.md) at the hub root (EN) — public brand **ByeByeVibe**; positioning “from vibe coding to shippable AI engineering”; **not** an app boilerplate (payload remains in `sdd-kit/`).
2. After install, run **`/opsx:help`** for the day-1 operator map (`doc/sdd-operator-day1.md`) — complements upstream `/opsx:onboard`.
3. Preview what the kit would install (without writing files):

```bash
bash sdd-kit/install.sh --profile DOCS_SPECS --dry-run
# or, in an application repo: --profile APP
```

4. If it makes sense, follow the full install: §2.1 → CLIs → `install.sh` (without `--dry-run`) → checklist §2.8.
5. Friendly map C1/C2/C3/G*: [`sdd-kit/README.md`](../sdd-kit/README.md). Market analysis / backlog: [`doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`](../doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md).

This block **does not** replace procedure §2.1–§2.8 — it only reduces friction on first contact.

### 2.1.1 Language setup (install-time)

C1 install captures **three independent language axes** before templates are applied. v1 allowed values: `en` and `pt-BR` only. Defaults when skipped or omitted: `en` / `en` / `en`.

| Axis | Key | Scope |
|------|-----|-------|
| Chat | `chat_language` | Agent replies to the operator (not versioned) |
| Docs | `docs_language` | OpenSpec artifacts, skills/rules prose, `doc/` |
| Code | `code_language` | Comments, UI strings, error messages; identifiers stay English/ASCII |

**Interactive (TTY):** `bash sdd-kit/install.sh --profile <PROFILE>` prompts three numbered menus when no language flags are passed.

**Non-interactive / CI:** pass all three flags:

```bash
bash sdd-kit/install.sh --profile DOCS_SPECS \
  --chat-lang pt-BR --docs-lang en --code-lang en
```

**Persistence:** `openspec/project.md` → `## Language policy` table (source of truth); `AGENTS.md` → `## Communication` (operational instructions). Chat language does **not** authorize docs or code in a different configured language.

**Dry-run:** `install.sh --dry-run` prints the planned language policy without writing files.

**Hub distribution repo:** grandfathered — existing hub `AGENTS.md` / `openspec/project.md` are not regenerated by this change; hub EN migration waves (`doc/i18n/`, `verify-i18n-wave.sh`) remain hub-scoped.

### 2.1 Order matters

Install in this specific order. **Do not reverse** — each step assumes the previous one is done.

**Phase 0 + three pillars + kit (control plane):**

```
0. Preflight → Intent (OpenSpec) → Code graph (GitNexus) → Knowledge graph (Graphify) → payloads (sdd-kit)
```

```
0. Preflight (scripts/preflight-sdd.sh --all) → 1. OpenSpec → 2. GitNexus → 3. Graphify → 3b. sdd-kit/install.sh → 4. Curate AGENTS.md → 5. Configure IDEs
```

**Why this order (simple):** phase 0 catches missing host/repo prerequisites before CLI installs. Later tools assume earlier artifacts exist. Reversing risks overwrite of `AGENTS.md` / the `openspec/` skeleton. OpenSpec creates the playbook skeleton; GitNexus maps code after that skeleton exists; Graphify adds what the team already knows without fighting the code index; **sdd-kit** is the **toolbox** that wires the control plane into *this* repo — without it, every repo invents the process from scratch.

**Scenario:** You ask “add login.” Without OpenSpec, the AI already opens files. Without GitNexus, it edits the wrong place. Without Graphify, it ignores the auth decision you wrote last month. With all three (+ kit), it agrees on a plan, checks impact, and reuses what the team already knows.

Full responsibilities matrix → [§4](#4-master-table-question-3).

### 2.0 AI-assisted installation (prompt)

Paste this prompt at the target repository root (replace `REPO_ROOT` and the profile):

```
Install the SDD system (OpenSpec + GitNexus + Graphify) in this repository following
strictly the guide in doc/byebyevibe-guide.md v1.9.0 and the install kit in sdd-kit/.

Repository profile: [APP | DOCS_SPECS] — if unset, ask the operator "Will this repository
hold application code?" (yes → APP; no, docs/specs only → DOCS_SPECS) using the canonical
dialog copy in guide §1.6 "Repository profiles" (every profile installs the complete
framework; this hub's docs/specs are its own development history and are never copied to
the target project; the profile question is separate from the language question). Do not
offer `HYBRID` as a dialog option — it is a deprecated alias of APP (kit 1.9.0).

Acquiring the SDD system files (skip if `sdd-kit/` already exists in this repo):
- **Default — genuine greenfield target:** use the lightweight fetch recipe (guide §1.6 "Lightweight fetch recipe") — a partial clone + sparse-checkout that pulls only `sdd-kit/` + `scripts/bootstrap-sdd.sh` + `scripts/preflight-sdd.sh`, no full hub clone.
- **Only if the operator explicitly wants the persistent multi-project hub→destination workflow:** clone the full hub once per machine and reuse it across projects (guide §1.6 "Hub → destination flow").

Narrative (dual S↔T — mandatory):
- Before EACH install step, explain the S layer in simple language:
  What it is, Why now, Without it…, You’ll get (see guide §2.1–2.4).
- Expand the T layer (exact commands, paths, flags, version pins) on demand,
  or when the next shell action needs those exact invocations.
- When you introduce a technical term, add a short T→S analogy or scenario
  (term → plain-language picture).

Order:
0. Phase 0 — bash scripts/preflight-sdd.sh --all
   (or rely on bootstrap; use --skip-preflight only for legacy/CI)
1. bash scripts/bootstrap-sdd.sh  (or manual CLIs §2.2–2.4)
   Prefer --quiet for CI/agents when didactic TTY banners are noise.
   Pass --profile APP|DOCS_SPECS to skip auto-detection (bootstrap validates
   the value and forwards it to sdd-kit/install.sh; --profile HYBRID still
   works as a deprecated alias of APP).
2. bash sdd-kit/install.sh --profile <PROFILE> [--dry-run first]
3. Edit openspec/project.md (Purpose, Stack — do NOT replace with template)
4. Merge AGENTS.md if it already existed (templates: sdd-kit/templates/AGENTS.core.md + commands)
5. bash sdd-kit/verify.sh + checklist §2.8

Do NOT extract scripts from markdown §12 — use sdd-kit/templates/.
Do NOT paste full <!-- gitnexus:start --> blocks into AGENTS.md.
Do NOT auto-install optional add-ons (UI, Probity, CI enablement, Metrics) — point only.

Deliver: checklist §2.8 + output of sdd-kit/verify.sh.
```

### 2.2 Step 1 — OpenSpec (intent)

| | |
|--|--|
| **What** | The **playbook** for a change: think → agree → do → keep a record |
| **Why now** | First: creates the `openspec/` skeleton other steps assume |
| **Without it** | Without it, chat turns into code and nobody remembers why |
| **You’ll get** | Slash commands `/opsx:*`, `openspec/`, change folders |

Scenario: the decision survives the chat.

```bash
# Global install
npm install -g @fission-ai/openspec@latest

# Verification
openspec --version          # Expect 1.3.1 or higher

# Initialize in the project
cd ~/projects/meu-repo   # target repo root
openspec init --tools "cursor,claude"

# Non-interactive mode: generates opsx commands in .cursor/ and .claude/
# Add other tools comma-separated if needed (see openspec init --help)
```

What this creates:
```
openspec/
├── project.md              # Edit manually: stack, conventions, architectural decisions
├── AGENTS.md               # GENERATED — DO NOT EDIT (regenerated by openspec update)
├── specs/                  # Empty initially; grows with archive
└── changes/                # Empty initially; grows with propose
.claude/commands/opsx-*.md  # OpenSpec slash commands for Claude Code
.cursor/commands/opsx-*.md  # OpenSpec slash commands for Cursor
```

**Required action after init**: edit `openspec/project.md`. This file is the project Constitution. Without it written well, OpenSpec does not deliver real benefit. See template in annex 12.1.

### 2.3 Step 2 — GitNexus (code)

| | |
|--|--|
| **What** | The **map of your repo’s code** |
| **Why now** | Second: indexes code and seeds `AGENTS.md` after the skeleton exists |
| **Without it** | Without it, the AI edits by vibe and breaks the neighborhood |
| **You’ll get** | Local code graph + impact / MCP tools |

Scenario: impact before the edit.

```bash
# Global install
npm install -g gitnexus

# Verification
gitnexus --version          # Expect 1.4.8 or higher

# One-time MCP setup (configures ~/.cursor/mcp.json and claude-code)
gitnexus setup

# Index the repo (run from repo root)
cd ~/projects/multi-agent-bot
gitnexus analyze

# To reindex after significant changes:
gitnexus analyze --force

# To generate LLM-powered wiki:
gitnexus wiki
```

What this creates:
```
.gitnexus/                   # Local database (gitignored)
~/.gitnexus/registry.json    # Global registry of indexed repos
~/.cursor/mcp.json           # GitNexus registered as MCP server
~/.cursor/skills/            # GitNexus skills for Cursor
~/.claude/skills/            # GitNexus skills for Claude Code
~/.claude/hooks/             # PreToolUse hooks that enrich grep/glob with graph
AGENTS.md                    # CREATED or MODIFIED — watch for conflict (see §4)
CLAUDE.md                    # CREATED or MODIFIED — watch for conflict
```

**Attention**: if you already have a curated `AGENTS.md`, **rename it first** (`AGENTS.tools-generated.md`), run `gitnexus analyze`, then apply template **12.2** — **do not** copy the full `<!-- gitnexus:start -->` block into the canonical file (see §2.5.1). Operational detail lives in skills under `.claude/skills/gitnexus/`.

### 2.4 Step 3 — Graphify (knowledge)

| | |
|--|--|
| **What** | The **map of what the team already knows** (docs, decisions, ideas) |
| **Why now** | Third: adds non-code context without fighting the code index |
| **Without it** | Without it, the AI reinvents what the team already wrote |
| **You’ll get** | `graphify-out/` + `GRAPH_REPORT.md` |

Scenario: docs/concepts before reinventing.

> **Bootstrap posture:** in `bootstrap-sdd.sh` the Graphify phase is WARN-and-continue — any failure (uv install, `uv tool install`, `graphify install`/`hook`/`update`) emits a WARN and bootstrap proceeds to `sdd-kit/install.sh`, same tolerance as GitNexus. If the phase warned, install manually with the commands below.

```bash
# Install via uv (recommended — puts CLI on PATH automatically)
uv tool install graphifyy

# Verification
graphify --version          # Expect 0.8.4 or higher

# Install skill in Claude Code
graphify install            # auto-detects platform; macOS/Linux

# Install skill in Cursor
graphify install --platform cursor

# Install skill in VS Code (Claude Code extension)
graphify vscode install

# Install git hook for automatic rebuild on commits
graphify hook install

# Build initial graph — from repo root
cd ~/projects/meu-repo
graphify update .           # AST + structure (no LLM API key)

# With API key (ANTHROPIC/GEMINI/etc.) for full semantics:
# graphify extract . --max-workers 4

# Obsidian vault or external folder (optional):
# graphify extract /path/to/vault --out graphify-out-vault
```

What this creates:
```
graphify-out/
├── graph.json              # Serialized graph
├── GRAPH_REPORT.md         # Human- and LLM-readable summary
├── graph.html              # Interactive browser visualization
└── .graphify_root          # Pointer to project root
~/.claude/skills/graphify/  # SKILL.md installed
~/.cursor/skills/graphify/  # SKILL.md installed
AGENTS.md                   # MODIFIED — watch for conflict (see §4)
```

**Same attention as GitNexus**: in the canonical `AGENTS.md`, summarize Graphify in 2–3 lines (read `GRAPH_REPORT.md`, `graphify update .` after code). Detail in `CLAUDE.md` / `.cursor/rules/graphify.mdc` if installed.

### 2.5 Step 4 — Curate the single `AGENTS.md`

This is the critical step. Tools generate or modify `AGENTS.md`/`CLAUDE.md` — the canonical file is **curated by you**, using template **12.2a** (app) or **12.2b** (docs/specs).

```bash
# 1. Preserve automatic output
mv AGENTS.md AGENTS.tools-generated.md 2>/dev/null || true
echo "AGENTS.tools-generated.md" >> .gitignore
echo "CLAUDE.tools-generated.md" >> .gitignore

# 2. Create AGENTS.md from annex 12.2a or 12.2b (do NOT ask the AI to invent it)
$EDITOR AGENTS.md

# 3. Minimal CLAUDE.md: point to ./AGENTS.md (template §10.3)
```

**The canonical `AGENTS.md` MUST contain (target format v1.1):**

| Section | Content |
|---------|---------|
| Context | Points to `./openspec/project.md` — **do not** duplicate stack |
| **Commands** | Table of real commands for this repo (dev, test, openspec, gitnexus, graphify) |
| Knowledge sources | Order 1–7 (§5.2) |
| **On-demand context** | Situation → file table (§2.5.3) |
| Protocol A–E + R1–R9 | §3 and §8.2 |
| OpenSpec workflow | `/opsx:*`, graphify update, gitnexus analyze |
| **Integrations** | GitNexus + Graphify in ≤10 lines each; bridge to skills |
| Security + communication | §7 |

**Target:** ~100–150 lines. If `gitnexus analyze` or `graphify install` inject long blocks again, **remove** them and keep only the summary under Integrations.

#### 2.5.1 Anti-patterns (do not adopt in the canonical `AGENTS.md`)

| Anti-pattern | Why | Instead |
|--------------|-----|---------|
| Ask the AI to generate the initial `AGENTS.md` | Huge, generic file; context rot | Template 12.2 + iterative human editing |
| Paste the full `<!-- gitnexus:start -->` block | Duplicates skills; +40 lines always in context | §2.5 Integrations + lazy-loaded skills |
| Duplicate stack from `openspec/project.md` | Drift within months | Point to `project.md` |
| YAML AAIF (`agent.name`, `compliance`) | Overhead; unused by Cursor/Claude | Free Markdown ([agents.md](https://agents.md/)) |
| Move everything into `AGENTS.md` and delete `.mdc` | Cursor loses glob auto-attach | `AGENTS.md` + `.cursor/rules/*.mdc` |
| `AGENTS.md` > 200 lines without reason | Confuses the model; token cost | Split into referenced docs + Skills |

#### 2.5.2 Repository profiles

| Profile | Signals | Template Commands | Nested `AGENTS.md` |
|---------|---------|-------------------|---------------------|
| **APP** | `package.json`, `npm run dev`, Next app/etc. | `dev`, `test`, `lint`, `build` (note: do not run build in agent sessions if agents.md says so) | Per package in monorepos |
| **DOCS_SPECS** | `openspec/`, `doc/`, no app at root | `openspec list`, `gitnexus status`, `graphify update .` | `doc/**/scripts/`, folders with their own tooling |
| **HYBRID** | App + `openspec/` + `doc/` | Combine both tables under Commands | Both |

#### 2.5.3 On-demand context (map in `AGENTS.md`)

Include a table like this (adapt paths to the repo):

```markdown
## On-demand context

| Situation | Load |
|-----------|------|
| Stack, conventions, non-goals | `openspec/project.md` |
| Requirements by capability | `openspec/specs/` |
| Change in progress | `openspec/changes/<id>/` |
| Concept relations / theory | `graphify-out/GRAPH_REPORT.md` |
| Legacy: understand codebase | Ask for AS-IS patterns **without creating files**; then document |
| TS/Python/DB conventions (open file) | `.cursor/rules/010-*.mdc`, etc. |
| Full SDD guide (installation) | `doc/byebyevibe-guide.md` |
```

#### 2.5.4 Nested `AGENTS.md` ([agents.md](https://agents.md/))

Create `AGENTS.md` in subfolders with their own logic (scripts, packages). The agent uses the file **closest** to the file being edited. See template **12.7**.

### 2.6 Step 5 — Verify MCP configuration

```bash
# Cursor: verify both MCP servers are registered
cat ~/.cursor/mcp.json
# Should show gitnexus and (if you used graphify mcp) graphify

# Claude Code: list active MCPs
claude mcp list
# Should show gitnexus

# Test GitNexus
gitnexus status              # Should show the repo indexed

# Test Graphify
ls graphify-out/             # Should have graph.json and GRAPH_REPORT.md
```

### 2.7 Step 6 — End-to-end sanity check

Open Claude Code or Cursor and try:

```
/opsx:propose add input validation to the /users endpoint
```

You should see the agent create `openspec/changes/add-user-input-validation/` with `proposal.md`, `design.md`, `tasks.md`, and `specs/`. If the agent also consults GitNexus/Graphify during the propose phase (reads existing code and context), all three stacks are integrated.

If something fails: run `gitnexus status`, verify `mcp.json` is correct, and re-read AGENTS.md.

**Day-1 operate (optional):** after the sanity check, run `/opsx:help` to walk the control-plane map (`doc/sdd-operator-day1.md`), then optionally `/opsx:onboard` (upstream OpenSpec) to practice a full cycle. See evaluation `doc/avaliacoes/2026-08-01-sdd-operator-onboarding.md`.

### 2.8 Post-installation verification (checklist)

Use after every installation (human or AI):

- [ ] `openspec/project.md` edited with Purpose, Stack, Cross-references
- [ ] `openspec/project.md` has **Language policy** table (`chat_language`, `docs_language`, `code_language`) and `AGENTS.md` **Communication** reflects the same three axes (see §2.1.1)
- [ ] `AGENTS.md` exists, ≤150 lines, **without** duplicated `<!-- gitnexus:start -->` block
- [ ] `AGENTS.tools-generated.md` and `CLAUDE.tools-generated.md` in `.gitignore`
- [ ] `CLAUDE.md` points to `./AGENTS.md` (≤25 useful lines)
- [ ] `.cursor/rules/000-base.mdc` and `050-security.mdc` present
- [ ] `npx openspec list` runs without error
- [ ] `npx gitnexus status` → index up-to-date
- [ ] `graphify-out/GRAPH_REPORT.md` exists (after `graphify update .`)
- [ ] `/opsx:propose` (or `npx openspec new change test`) creates a change
- [ ] IDE restarted (slash commands and skills)
- [ ] APP/DOCS_SPECS profile reflected in the `AGENTS.md` Commands table
- [ ] `openspec/infra.md` exists with SDD Stack and MCP Servers sections
- [ ] `.cursor/rules/015-session-phases.mdc` present (alwaysApply)
- [ ] `.cursor/rules/016-session-coordination.mdc` present (alwaysApply)
- [ ] `scripts/sdd-session-check.sh` and `scripts/sdd-session-status.sh` executable
- [ ] `.sdd/runtime/` in `.gitignore`
- [ ] `openspec/infra.md` Session Coordination section present
- [ ] `bash scripts/verify-infra.sh` completes without error (or document ❌ pending items)
- [ ] `.github/workflows/sdd-gates.yml` present (see §2.12 to configure branch protection manually)
- [ ] `renovate.json` present if APP/HYBRID profile (see §2.13 to install the Renovate app)
- [ ] *(optional, soft)* `/opsx:help` (or `doc/sdd-operator-day1.md`) — day-1 map; non-blocking; `verify.sh` MUST NOT fail solely for skipping it
- [ ] *(optional, soft)* Phase-0 Preflight run — `openspec/infra.md` `## Preflight (last run)` stamped (or `bash scripts/preflight-sdd.sh --all`); non-blocking; `verify.sh` MAY WARN if timestamp is still `—`

### Optional add-ons at a glance

Pointers only — **not** part of core C1. No menu; run later if they fit. `install.sh` may remind these exist; it does **not** install them.

| Add-on | Install if… | Skip if… | Pointer |
|--------|-------------|----------|---------|
| UI module (C1-UI) | You have a frontend (`app/`) and want a design-system path | Docs/API-only repo | §2.11 · `bash sdd-kit/install-ui-module.sh` |
| Probity (G2) | APP/HYBRID with tests and you want TDD enforced for B/C/D | DOCS_SPECS / no test runner | §2.16 · `bash sdd-kit/install-probity-module.sh` |
| CI gates | You want merge blocked when specs/tasks fail | Local-only exploration (workflow may still ship in kit) | §2.12 · branch protection manual |
| SDD metrics (G4) | After a few archives, to calibrate lead time/rework | First-day install | §2.17 · `bash scripts/sdd-metrics.sh` on demand |

### 2.11 UI development module (C1-UI, optional)

**Prerequisite:** C1 complete (checklist §2.8 above).

**Profiles:** APP and HYBRID with a frontend (`app/` or `apps/web/`). DOCS_SPECS without an app: `--detect` reports `SKIP`; reference docs are distributed via the kit.

| Step | Action |
|-------|--------|
| 1 | `bash sdd-kit/install-ui-module.sh --detect` |
| 2 | Read `doc/design/002-ui-module-install.md` §1 (shadcn decision — recommended + opt-out) |
| 3 | `bash sdd-kit/install-ui-module.sh --apply [--yes]` |
| 4 | Checklist §2.11.1 |

**What the module includes:**

- Documentation `doc/design/000`–`003` (pipeline, installation, adapters)
- Update to `openspec/infra.md` (UI Development Module section)
- Impeccable (`npx impeccable install`) **only** with `--yes` and Node 24+

**What it does not include:** Open Design, Pencil, Figma MCP (install on demand — see `002` §5).

**Operational detail:** [`doc/design/001-pipeline-open-design-shadcn-impeccable.md`](design/001-pipeline-open-design-shadcn-impeccable.md) — **do not** duplicate flows A–D in this guide (§5.3).

#### 2.11.1 UI module verification checklist

After C1-UI (`--apply`):

- [ ] `bash sdd-kit/install-ui-module.sh --detect` reports the correct `UI stack`
- [ ] `doc/design/002-ui-module-install.md` and `003-ui-stack-adapters.md` present
- [ ] `openspec/infra.md` — **UI Development Module** section updated
- [ ] `UI stack:` in `openspec/project.md` reflects the decision (shadcn | tailwind-custom | other | none)
- [ ] Node 24+ confirmed before Impeccable (gate M3)
- [ ] `DESIGN.md` at repo root (if Impeccable installed) — distinct from `openspec/changes/<id>/design.md`
- [ ] `npx gitnexus analyze --force` if `components/ui/` was changed
- [ ] `graphify update .` to index `doc/design/*`
- [ ] `.cursor/skills/impeccable/` present (if Impeccable applied) — separate from SDD skills

### 2.12 CI gates (sdd-gates) — operation

Fail-closed enforcement of SDD gates on the server (gap G1 — `add-sdd-ci-gates-workflow`). The `.github/workflows/sdd-gates.yml` workflow **only orchestrates existing commands**; there is no associated skill or rule (type A — automatic out-of-band; registration contract R3 = N/A).

**When it runs:** `push` to `main`/`master` and any `pull_request`.

**Steps and policy:**

| Step | Command | Policy |
|-------|---------|----------|
| OpenSpec validate | `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict --no-interactive` | **Blocking** (fail-closed) |
| Task patterns | `bash scripts/verify-task-patterns.sh` | Blocking (SKIP if absent — APP profile) |
| OSV-Scanner | `google/osv-scanner-action` (SHA-pinned) | Blocking (SKIP if no lockfile at repo root) |
| Release readiness | `bash scripts/verify-release-readiness.sh` | **Blocking** (fail-closed) — version-sync + kit-integrity + hub scripts↔templates parity; independent of `verify-infra.sh`, never affected by missing knowledge CLIs |
| sdd-kit verify | `bash sdd-kit/verify.sh` | Report-only (`continue-on-error`) — includes `verify-infra.sh` (knowledge CLIs missing on the runner) and re-runs `verify-release-readiness.sh` internally for the local one-shot summary; that re-run does not affect this step's report-only status |

**How to read the output:** in the Actions tab (or PR check), the red step indicates which gate failed. `OpenSpec validate` lists `✗ change/<id>` — reproduce locally with `npx openspec validate <id> --strict` and fix the artifact. `Task patterns` lists `FAIL missing: <path>` — fix the `Pattern:` in `tasks.md`. `Release readiness` lists `FAIL: <file> <label> declares X but MANIFEST <field> is Y` for a version-sync mismatch, or `FAIL: sha256 mismatch: <path>` for a stale template checksum — reproduce locally with `bash scripts/verify-release-readiness.sh`. The `sdd-kit verify` step may show a warning without blocking (expected: GitNexus/Graphify are not on the runner).

**Unblock merge:** fix the failed artifact and push — the check re-runs. **Do not** work around by editing the workflow in the same PR; if the gate is wrong, open a dedicated change.

**Troubleshooting:**

| Symptom | Likely cause | Action |
|---------|----------------|-------|
| `✗ change/<id>` in validate | Delta missing `## ADDED/MODIFIED/... Requirements` or requirement without `#### Scenario:` | Fix the delta; run `openspec validate <id> --strict` locally |
| `FAIL missing:` in task patterns | `Pattern:` path does not exist | Update `tasks.md` |
| Green workflow but merge not blocked | Branch protection not configured | See manual action below |
| `notarget`/404 on npx | Pinned version diverges from `min_openspec` | Align with `sdd-kit/MANIFEST.yaml` |

`[MANUAL ACTION REQUIRED]` **Branch protection** — the workflow reports the check, but merge is only actually blocked with active branch protection: GitHub → Settings → Branches → Add rule for `main`/`master` → "Require status checks to pass" → select **SDD Gates**. Confirm on a test PR before relying on the gate.

**Rollback:** deleting `.github/workflows/sdd-gates.yml` disables the gate immediately (no residual state).

### 2.13 Supply chain (Renovate + OSV-Scanner) — operation

Automatic supply-chain gates (gap G8 — `add-supply-chain-gates`). They run **independently** of the A–E task in progress in the SDD session.

**OSV-Scanner (CI):**

- **When it runs:** in the `SDD Gates` job, after `openspec validate` and `task patterns`, before `sdd-kit verify` (report-only).
- **Condition:** runs only if a supported lockfile exists at the repo root (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `poetry.lock`, `Pipfile.lock`, `Cargo.lock`, `go.sum`, `Gemfile.lock`, `composer.lock`).
- **SKIP:** no lockfile → log `SKIP: no lockfile at repo root — OSV-Scanner not applicable` (DOCS_SPECS hub without deps).
- **Policy:** fail-closed — vulnerability in the lockfile blocks merge.

**How to read an OSV failure in Actions:**

1. Open the `SDD Gates` check on the PR → red `OSV-Scanner (blocking)` step.
2. Expand logs — lists package, version, and advisory ID (OSV).
3. Update the dependency or apply a documented override (last resort).

**Renovate (automated updates):**

`[MANUAL ACTION REQUIRED]` **Install the GitHub Renovate app** — APP/HYBRID profiles only:

1. Go to [github.com/apps/renovate](https://github.com/apps/renovate) → Install.
2. Select the repository (or organization).
3. Confirm `renovate.json` exists at the repo root (copied by `sdd-kit/install.sh` on APP/HYBRID).
4. Wait for Renovate's initial onboarding PR.

**Conservative preset** (`sdd-kit/templates/renovate.json`):

- Schedule: Monday before 9am (America/Sao_Paulo).
- Limits: 5 concurrent PRs, 2/hour.
- Grouping of non-major minor/patch updates.
- Automerge **patches only** — requires `requiredStatusChecks: ["SDD Gates"]` + active branch protection (opt-in).
- Majors and minors: **no** automerge — human review required.

**Agent classification (AGENTS.md):**

| Source | Type | Action |
|--------|------|-------|
| Renovate patch | A | Quick review; merge if CI green |
| Renovate minor/major | B/C | Review breaking behaviour |
| Red OSV on PR | B | Fix deps before merge/archive |

**Troubleshooting:**

| Symptom | Likely cause | Action |
|---------|----------------|-------|
| OSV blocks legitimate merge | Advisory on transitive dep or false positive | Update dep; temporary override (pin/ignore) — see below |
| Renovate does not open PRs | App not installed or `renovate.json` missing | Install app; `install.sh --profile APP` |
| Automerge does not work | Branch protection without automerge or wrong check | Configure "SDD Gates" as required check + automerge on GitHub |
| Renovate PR spam | Preset too aggressive | Adjust `prConcurrentLimit` / `schedule` in `renovate.json` |

**OSV override (last resort):** prefer fixing the dependency. If unavoidable, document the reason in the PR and use a mechanism supported by OSV-Scanner (e.g. `osv-scanner.toml` with a temporary ignore). Do not disable the workflow step to work around.

**APP pilot checklist** (Renovate PR volume):

- [ ] After 2 weeks of operation, confirm ≤5 PRs/week on average
- [ ] Patch automerge does not break CI
- [ ] Majors always get human review

**Rollback:**

| Component | Action |
|------------|-------|
| OSV | Remove `OSV-Scanner` step from `sdd-gates.yml` (hub + template) |
| Renovate | Remove `renovate.json` + uninstall GitHub app |

### 2.14 Post-apply reviews — correctness-review

On-demand skill that detects logic bugs, unhandled edge cases, contract violations, and silent errors in AI-generated code. Positioned in the pipeline **after tests (R6/Probity `enforceTdd`)** and **before `simplify-review`**.

#### When to invoke

| Task type | Invoke? | Trigger |
|----------------|----------|---------|
| **B — Bug fix** | ✅ Always | Diff > 0 lines of logic |
| **C — Refactor** | ✅ Yes | Diff > ~80 lines or > 4 files |
| **D — Feature** | ✅ Always | Diff with new logic |
| **A — Trivial** | ❌ No | — |
| **E — Exploration** | ❌ No | — (no generated code) |

**Pipeline position:**

```
/opsx:apply  →  [implementation]  →  tests (R6/Probity enforceTdd)
  →  correctness-review (B/C/D)
  →  simplify-review (optional, C/D)
  →  security-reviewer (if auth/API/payments)
  →  commit (R9)  →  CI gates  →  /opsx:archive
```

#### How to read the output

The skill produces findings with 5 tags:

| Tag | Meaning |
|-----|-----------|
| `logic:` | Wrong logic branch; incorrect result for valid input |
| `edge:` | Extreme input not handled (null, empty, overflow, unicode) |
| `contract:` | Pre/post-condition or API invariant violation |
| `race:` | Race condition (shared mutable state, async without lock) |
| `silent:` | Silent error — swallowed exception, wrong value without alert |

**Verdicts:**

| Verdict | Action |
|----------|-------|
| `CORRECT` | No findings — ship |
| `RISKY` | ≥1 actionable finding — review before commit |
| `INSUFFICIENT SCOPE` | Diff too small or no logic — ignore |

#### How not to invoke

- **Never** configure as a hook or `alwaysApply` rule.
- **Never** block commit automatically based on this skill.
- Do not invoke on type A or E tasks.

#### Troubleshooting

| Symptom | Cause | Action |
|---------|-------|-------|
| Findings about complexity/style | Wrong scope | Use `simplify-review` for those; `correctness-review` only hunts bugs |
| Security findings | Wrong scope | Use `security-reviewer` |
| Too many false positives | Model speculating without evidence | Ask for `[show evidence in code]`; discard findings without a concrete location |

**Skill files:** `.claude/skills/correctness-review/SKILL.md` (mirror at `.cursor/skills/correctness-review/SKILL.md`).

**Rollback:** `rm -r .claude/skills/correctness-review/ .cursor/skills/correctness-review/` + revert `AGENTS.md` and `openspec/infra.md`.

### 2.15 GitHub Issues MCP (github-mcp-server) — operation

Passive MCP (mode D — gap G5, change `add-github-mcp-issue-traceability`) to link OpenSpec changes to GitHub Issues. The agent consults when relevant in explore/propose; it does **not** intercept edits or add a step to the interactive flow.

#### Installation

**Primary option — remote endpoint (OAuth, no committed token):**

1. Cursor → Settings → MCP → Add server
2. URL: `https://api.githubcopilot.com/mcp/`
3. Authenticate via OAuth when prompted
4. Limit toolsets to **issues** where the client allows

**Alternative — local binary (air-gapped):**

```bash
# Official Docker image — pin by digest in production
docker pull ghcr.io/github/github-mcp-server:v1.7.0
```

Configure in `~/.cursor/mcp.json` (gitignored) with `--toolsets issues`. **NEVER** commit tokens or `GITHUB_PERSONAL_ACCESS_TOKEN` in the repo.

#### Verify

```bash
# In the agent session
mcp_get_tools   # should list github-mcp-server tools

# Or inspect local config
cat ~/.cursor/mcp.json   # confirm github-mcp-server entry
```

Update `openspec/infra.md` to ✅ when confirmed.

#### When the agent should consult (A–E matrix)

| Type | Consult? | When |
|------|------------|--------|
| **A — Trivial** | ❌ No | — |
| **B — Bug fix** | ✅ Yes | Change framing — source issue, acceptance criteria |
| **C — Refactor** | ⬜ Optional | If change references an issue |
| **D — Feature** | ✅ Yes | During `/opsx:propose` — user story, criteria, dependencies |
| **E — Exploration** | ✅ Yes | During research — duplicates, prior bug context |

**`**Issue:**` field in `proposal.md`:** full URL, `#123`, or `—` (no issue). Accepted values are not validated by a CI gate.

**Cloud agents:** read-only `gh` CLI already covers ad-hoc queries on ephemeral runners; github-mcp is for local interactive sessions.

#### Troubleshooting

| Symptom | Likely cause | Action |
|---------|----------------|-------|
| MCP missing from `mcp_get_tools` | Server not configured or auth failed | Review `~/.cursor/mcp.json`; retry OAuth |
| PR/repo/code tools visible | Excessive scope | Limit to `--toolsets issues` |
| Agent does not consult issues | Type A or MCP unavailable | Mode D is fail-open — flow continues without context |
| Token exposed in repo | Config committed by mistake | Revoke token; move to `~/.cursor/mcp.json` |

#### Disable / rollback

1. Remove `github-mcp-server` entry from `~/.cursor/mcp.json`
2. Revert `openspec/infra.md`, `AGENTS.md`, and template `proposal.md` via a removal change
3. Bump MANIFEST + recalculate checksums

No CI impact — github-mcp is not in `sdd-gates.yml`.

### 2.16 Probity module (G2) — operation

Optional post-C1 module that materializes R6 (`enforceTdd`) via a PreToolUse hook. G2 candidate; **TDD Guard superseded by Probity (2026-07)** — do not re-propose TDD Guard.

**Profiles:** APP/HYBRID with Vitest, Jest, or pytest. DOCS_SPECS without a test runner: SKIP.

#### Installation

```bash
bash sdd-kit/install-probity-module.sh --detect
bash sdd-kit/install-probity-module.sh --apply --yes
```

Then, in Claude Code:

```text
/plugin marketplace add nizos/probity
/plugin install probity@probity
# Restart session
```

Pin: `@nizos/probity@1.10.0`. Detailed doc: `doc/design/004-probity-module-install.md`.

Suggested PreToolUse hook order: **GitNexus → Graphify → Probity**.

#### Pilot (required)

Before enabling as default on an APP repo, validate criteria in `openspec/changes/add-probity-tdd-module/design.md` (p95 < 8s, type C false positives < 15%, R6 type B 100%, Cursor hooks). Hub status note: `openspec/changes/add-probity-tdd-module/piloto-nota.md`.

#### Cursor IDE

Probity documents Claude Code / Codex / Copilot CLI. Cursor third-party hooks: [docs](https://cursor.com/docs/reference/third-party-hooks). Validate in the pilot; if Write/Edit does not fire, use Claude Code as primary and document the limitation.

#### A–E matrix

| Type | Probity |
|------|---------|
| A | off (globs exclude docs; do not edit prod) |
| B / C / D | on (`enforceTdd`) |
| E | n/a |

#### Disable

| Method | Command / action |
|--------|-----------------|
| Globs | Already excludes `doc/**`, `openspec/**`, `sdd-kit/**` |
| Plugin | `/plugin uninstall probity@probity` |
| Repo | `bash sdd-kit/install-probity-module.sh --uninstall` |

#### Troubleshooting

| Symptom | Cause | Action |
|---------|-------|-------|
| Block on doc edit | Wrong glob | Confirm exclusions in `probity.config.ts` |
| High latency per edit | 3 hooks + LLM validator | Restrict `files`; measure p95; abort if > 8s |
| No config → everything blocked | Probity fail-closed | Restore template; `--apply` |
| Cursor does not fire hook | No native support | Claude Code; see pilot outcome |

#### Lint opt-in

`requireCommand` lint-before-commit is **not** in the default template (repos vary). Add manually if `npm run lint` is stable.

#### Rollback

```bash
bash sdd-kit/install-probity-module.sh --uninstall
/plugin uninstall probity@probity
# Revert Probity section in openspec/infra.md if needed
```

### 2.17 SDD metrics (sdd-metrics.sh) — operation

Local on-demand script (**mode C**) that generates a markdown effectiveness report for the SDD framework from `git` + `openspec/changes/` / `openspec/changes/archive/`. Materializes gap **G4** without adopting Apache DevLake (heavy DORA; does not measure per change-id metrics).

**Profiles:** APP, DOCS_SPECS, HYBRID — useful where OpenSpec archive + git history exist.

#### When to run

| Situation | Action |
|----------|--------|
| Retrospective / SDD overhead calibration | `bash scripts/sdd-metrics.sh` |
| Time window | `bash scripts/sdd-metrics.sh --since YYYY-MM-DD` |
| Save artifact | `bash scripts/sdd-metrics.sh --output path/report.md` |
| Check if cadence warrants nudge | `bash scripts/sdd-metrics.sh --check-cadence` |
| During explore/propose/apply | **Do not** run report — outside pipeline |
| Post-archive (Session Handoff) | `--check-cadence` only (advisory); **never** auto-run full report |

Not a CI gate (`sdd-gates`). No dedicated skill/rule (R3 N/A) — discover via `AGENTS.md` Commands. Cadence = nudge in archive handoff, not a mandatory step.

#### How to read the report (M1–M4)

| Section | Meaning |
|--------|-------------|
| **M1 Volume** | Active vs archived changes (in period) |
| **M2 Lead time** | Days between first commit mentioning change-id (propose proxy) and archive dir prefix date; includes mean and median |
| **M3 Rework** | `fix:` / `fix(...):` commits **after** archive date that still mention change-id (R9) |
| **M4 Post-archive activity** | Summary using M3 as primary proxy for post-archive fixes |

#### Interpret → act

After reading the report, map signals to **one** concrete SDD process adjustment. Minimum ritual: **1 insight → 1 adjustment** (or explicitly record “no change”).

| Signal | Suggested process action |
|-------|----------------------------|
| **M1** — many active / few archives | Review WIP: close or archive stalled changes; avoid propose without apply capacity |
| **M1** — stable low volume | OK if team pace is intentional; do not optimize prematurely |
| **M2** — high or rising lead time | Shorten change scope; reinforce explore→propose→apply handoffs; cut scope creep |
| **M2** — very low lead time + high M3 | Premature archives? Tighten task/spec gates before `/opsx:archive` |
| **M3** — recurring post-archive `fix` rework | Investigate weak specs, missing R9, or archive before validation; **do not** adopt Apache DevLake |
| **M4** (via M3) — corrective post-archive activity | Treat as prior-cycle debt; one archive playbook change (checklist, Pattern/Gate) |

**Apache DevLake remains out of scope** — the playbook acts on the SDD *process* (handoffs, scope, R9), not DORA dashboards.

#### Cadence and nudge (N=5, T=30)

| Threshold | Default | Effect |
|--------|---------|--------|
| Archives since last-run | **N = 5** | Nudge in `/opsx:archive` Session Handoff |
| Stamp age | **T = 30** days | Same nudge |
| No stamp (never run) | ≥ 1 archive in last T days | Baseline nudge (soft onboarding) |

- Local stamp: `.sdd/metrics-last-run` (gitignored) — written automatically after report exits 0 (ISO `YYYY-MM-DD`).
- Check: `bash scripts/sdd-metrics.sh --check-cadence` — exit **0** = silent; exit **1** = nudge recommended (short stdout); does **not** generate the report.
- In archive handoff: if exit 1, suggest `bash scripts/sdd-metrics.sh` + this playbook; **never** auto-run report; **never** fail archive if script is missing.

#### Proxies and limits (honesty)

- **M2** — real propose may predate first commit (chat-only) or change-id may only appear on archive commit.
- **M3** — depends on R9 discipline; commits without change-id **do not** count (under-count).
- Canonical **t_end** = `YYYY-MM-DD` prefix of `openspec/changes/archive/YYYY-MM-DD-<id>/`.
- Archive dirs without that prefix are skipped with `WARN` on stderr.

#### Troubleshooting

| Symptom | Cause | Action |
|---------|-------|-------|
| Exit 2 | Invalid flag or malformed `--since` | `bash scripts/sdd-metrics.sh --help` |
| Exit 1 with `--check-cadence` | Cadence hit (N archives / T days / baseline) | Run `bash scripts/sdd-metrics.sh` and apply playbook |
| M2 all `n/a` | Git history without change-id mention | Confirm R9; old archives may lack anchor |
| M3 always 0 | Few `fix:` with change-id | Expected if no rework; or reinforce R9 |
| WARN skip archive | Name without `YYYY-MM-DD-` | Rename to hub OpenSpec convention |

#### Rollback

```bash
rm -f scripts/sdd-metrics.sh
rm -f .sdd/metrics-last-run
# In consumer repos: remove MANIFEST entry / revert kit upgrade
# Revert SDD Metrics section in openspec/infra.md if needed
```

Local stamp in `.sdd/metrics-last-run` (gitignored); no hooks; no services. **Apache DevLake remains out of scope** — re-evaluate only if team/DORA justifies (see `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`).

### 2.9 Upgrading an existing installation

Use when the repository **already has** OpenSpec, GitNexus, and/or Graphify configured and the goal is to **upgrade** to a new guide or tool version — **do not** repeat §2 as a greenfield install.

#### 2.9.1 When to use and what not to do

| Situation | Action |
|----------|--------|
| First time in repo | §2.1 → §2.8 (new installation) |
| New guide version (`v1.1` → `v1.2`, etc.) | §2.9 |
| Only outdated CLIs, curated files OK | §2.9.4 (tools) + partial §2.9.7 |
| `openspec/` missing | New installation (§2) |

**Never during upgrade:**

- Run `openspec init` again (may duplicate or conflict harness).
- Replace `AGENTS.md` / `openspec/project.md` with output from `gitnexus analyze`, `graphify install`, or `openspec update`.
- Apply §12 templates over local content **without** a diff report (§12.8).
- `git push --force` on the upgrade branch.

#### 2.9.2 Detecting installed version

Before upgrading, record in the report (§12.8):

```bash
# Guide version referenced in repo (if any)
grep -E 'byebyevibe-guide\.md|Guia de instalação SDD' openspec/project.md || true

# Tool versions
openspec --version 2>/dev/null || npx openspec --version
gitnexus --version
graphify --version

# SDD installation signals
test -d openspec && echo "openspec: OK"
test -f AGENTS.md && wc -l AGENTS.md
test -d .cursor/rules && ls .cursor/rules/*.mdc 2>/dev/null | wc -l
```

| Field | Where to read |
|-------|----------|
| Guide version in repo | `openspec/project.md` → Cross-references (`doc/byebyevibe-guide.md` **vX.Y.Z**) |
| Target version | Header of this document or changelog §14 |
| Profile | APP / DOCS_SPECS / HYBRID (§2.5.2) — infer from `package.json`, Commands in `AGENTS.md` |

If `openspec/project.md` does not reference guide version, assume **unknown** and treat merge as **conservative** (keep local text; only add new sections from template).

#### 2.9.3 AI-assisted upgrade (prompt)

Paste at target repo root (replace `TARGET_VERSION` and confirm guide path):

```
Upgrade the existing SDD installation in this repository to guide
doc/byebyevibe-guide.md TARGET_VERSION (e.g. v1.2.0).

This is NOT a new installation — follow §2.9 of the guide strictly.

Mandatory order:
1. Create branch `chore/upgrade-sdd-TARGET_VERSION`.
2. §2.9.2 — record current version (project.md, tool --version).
3. §2.9.5 — extract guide templates into
   `openspec/changes/upgrade-sdd-TARGET_VERSION/sdd-staging/` (matrix files).
4. Run `./scripts/sdd-upgrade-diff.sh openspec/changes/upgrade-sdd-TARGET_VERSION/sdd-staging/`
5. Fill `openspec/changes/upgrade-sdd-TARGET_VERSION/UPGRADE_REPORT.md` (template §12.8)
   with per-file classification: KEEP_LOCAL | MERGE | APPLY_TEMPLATE | NEW | SKIP.
6. STOP and present report to user. Do not edit curated files until explicit approval
   (or instruction "apply MERGE/APPLY_TEMPLATE").
7. After approval: §2.9.4 (update CLIs and generated harness).
8. Apply only approved lines/files in report; preserve Purpose, Stack, Commands
   and repo-specific rules.
9. Update reference in `openspec/project.md` to TARGET_VERSION.
10. §2.9.7 checklist + commit `chore(sdd): upgrade to guia vX.Y.Z`.

Merge rules (§2.9.6):
- AGENTS.md: keep Commands and local "On-demand context" table entries;
  sync normative sections (A–E, R1–R9, Integrations) with template 12.2.
- openspec/project.md: NEVER replace Purpose/Stack/Architecture; only update
  Cross-references and new sections from template 12.1.
- .cursor/rules/*.mdc: APPLY_TEMPLATE only for 000-base and 050-security if guide
  indicates breaking change; 010/020/030 — MERGE or KEEP_LOCAL.
- CLAUDE.md: keep ≤25 lines; template §10.3.

Deliver: UPGRADE_REPORT.md + list of changed files + summary diff.
```

#### 2.9.4 Tool upgrade (without touching curated files)

Run **after** staging/diff and **before** approved merge on curated files (or in parallel if report is ready):

```bash
# 1. Global CLIs
npm install -g @fission-ai/openspec@latest
npm install -g gitnexus
uv tool upgrade graphifyy 2>/dev/null || uv tool install graphifyy

# 2. Preserve canonical AGENTS.md
cp AGENTS.md /tmp/AGENTS.md.backup 2>/dev/null || true
cp CLAUDE.md /tmp/CLAUDE.md.backup 2>/dev/null || true

# 3. OpenSpec harness (regenerates .cursor/commands, .claude/commands, generated openspec/AGENTS.md)
cd REPO_ROOT
openspec update

# 4. Restore canonicals if tools overwrote them
if grep -q 'gitnexus:start' AGENTS.md 2>/dev/null; then
  mv AGENTS.md AGENTS.tools-generated.md
  cp /tmp/AGENTS.md.backup AGENTS.md
fi

# 5. GitNexus + Graphify
gitnexus setup          # idempotent; updates global MCP/skills
gitnexus analyze --force
graphify install
graphify install --platform cursor
graphify hook install
graphify update .

# 6. Confirm versions
openspec --version && gitnexus --version && graphify --version
```

**Generated** files (safe to overwrite with `openspec update`):

| Path | Notes |
|---------|--------|
| `.cursor/commands/opsx-*.md` | Cursor slash commands |
| `.claude/commands/opsx-*.md` | Claude Code slash commands |
| `openspec/AGENTS.md` | Generated by OpenSpec — **not** root `AGENTS.md` |

#### 2.9.5 Comparison matrix (existing vs template)

For each **curated** file, compare repo with `sdd-kit/templates/` (deterministic source). Use optional staging + script:

```bash
# Option A: direct diff against kit templates (recommended v1.3+)
chmod +x scripts/sdd-upgrade-diff.sh
./scripts/sdd-upgrade-diff.sh sdd-kit/templates/

# Option B: local staging for human review
mkdir -p openspec/changes/upgrade-sdd-v1.3.0/sdd-staging
cp -r sdd-kit/templates/* openspec/changes/upgrade-sdd-v1.3.0/sdd-staging/
./scripts/sdd-upgrade-diff.sh openspec/changes/upgrade-sdd-v1.3.0/sdd-staging/
```

| Repo file | Template (source) | Merge type | What to compare |
|------------------|------------------|---------------|----------------|
| `AGENTS.md` | `sdd-kit/templates/AGENTS.core.md` + commands | MERGE | Normative sections vs local Commands/context; ≤150 lines; no `gitnexus:start` |
| `openspec/project.md` | §12.1 | Conservative MERGE | Purpose, Stack, Architecture, Constraints — **keep local**; Cross-references and guide version — **update** |
| `CLAUDE.md` | §10.3 | MERGE | Delegation to `AGENTS.md`; do not duplicate long blocks |
| `.cursor/rules/000-base.mdc` | §9.2 | APPLY or MERGE | Point to `AGENTS.md`; `/opsx:propose` reference |
| `.cursor/rules/050-security.mdc` | §9.2 | APPLY or MERGE | Guardrails; align if guide added new rule |
| `.cursor/rules/010-typescript.mdc` | §9.2 | KEEP or MERGE | Optional; only if repo uses TS |
| `.cursor/rules/020-python.mdc` | §12.5 | KEEP or MERGE | Optional |
| `.cursor/rules/030-supabase.mdc` | §12.5 | KEEP or MERGE | Optional |
| `.cursor/rules/graphify.mdc` | §4 / Graphify integration | MERGE | `graphify update` summary; do not duplicate skill |
| `doc/**/AGENTS.md` (nested) | §12.7 | KEEP_LOCAL | Preserve; only update if guide changed nested format |

**Classifications** (use in `UPGRADE_REPORT.md`):

| Tag | Meaning |
|-----|-------------|
| `KEEP_LOCAL` | Keep current file; no change |
| `MERGE` | Manual merge: template provides new sections; repo keeps specifics |
| `APPLY_TEMPLATE` | Replace with template (only 000-base / 050-security when guide changelog mandates) |
| `NEW` | File missing in repo; create from template |
| `SKIP` | Not applicable to this profile (e.g. 030-supabase without Supabase) |

#### 2.9.6 Per-file merge rules

**`AGENTS.md`**

1. Start from **local** file (not template).
2. From template 12.2, sync: Knowledge sources, A–E protocol, R1–R9, Workflow, Integrations (summary), Security.
3. **Do not** delete Commands table rows or extra "On-demand context" entries.
4. If after merge >150 lines, move detail to `doc/` or skills — do not inflate canonical.

**`openspec/project.md`**

1. Preserve entirely: Purpose, Stack, Architecture, Conventions, Constraints, Non-goals.
2. Update: `Guia de instalação SDD` line in Cross-references to target version.
3. If template 12.1 has **new** section (e.g. field missing in v1.0), **append** with `[FILL IN]` placeholder — do not invent content.

**`.cursor/rules/*.mdc`**

1. `000-base` and `050-security`: line-by-line diff; apply guide security changes.
2. Per-glob rules (`010`, `020`, `030`): update only if project uses that stack; otherwise `SKIP`.

**`CLAUDE.md`**

1. Maximum ~25 useful lines; must point to `./AGENTS.md`.
2. If GitNexus injected long block, move to `CLAUDE.tools-generated.md` and restore template §10.3.

#### 2.9.7 Post-upgrade checklist

Repeat §2.8 and add:

- [ ] `UPGRADE_REPORT.md` archived in `openspec/changes/upgrade-sdd-*/` (or committed in change)
- [ ] Guide version in `openspec/project.md` updated (e.g. **v1.2.0**)
- [ ] `AGENTS.md` without regression (local Commands intact; no `gitnexus:start`)
- [ ] `.bak.*` backups from `--apply` or isolation branch allow rollback
      `git restore --source=HEAD~1 <file>` for per-file rollback; `git reset --hard HEAD~1` to revert whole commit
- [ ] `openspec update` applied; `/opsx:*` slash commands work after IDE restart
- [ ] `gitnexus analyze --force` and `graphify update .` executed
- [ ] Guide changelog §14 read for target version **breaking changes**

---

## 3. Task classification and pipelines (questions 2, 3, 3.1)

### 3.1 There is not *one* pipeline. There are five.

Your intuition in the earlier conversation was correct: forcing all work through the same flow is overkill for some and insufficient for others. Define five work types, each with its own pipeline:

#### Type A — Trivial (no spec, no research)
**Detection**: short prompt, obvious change, no architectural implication.
Ex: "fix this typo", "rename this variable to `userEmail`", "update package version in `package.json`".
**Pipeline**: direct → implement → test
**Tools involved**: none of the three (Claude Code edits directly).

#### Type B — Defined bug fix
**Detection**: reproducible error, known file/function, unambiguous cause.
Ex: "endpoint X returns 500 when Y; it should return 400".
**Pipeline**: light framing → **GitNexus (blast radius)** → patch → test
**Tools involved**: GitNexus only (ensure the fix does not break downstream).
**OpenSpec/Graphify**: no.

#### Type C — Refactor of existing module
**Detection**: "refactor", "extract", "move", "rename global symbol", "consolidate".
Ex: "extract auth logic into a dedicated service".
**Pipeline**: framing → **GitNexus (AS-IS)** → **OpenSpec (proposal + design)** → implement
**Tools involved**: GitNexus + OpenSpec.
**Graphify**: optional, only if refactor involves theoretical decisions.

#### Type D — New feature grounded in theory (Pedro's central case)
**Detection**: "implement X based on Y framework/theory/concept", "new Z module", reference to internal docs or papers.
Ex: "implement KBS concept-association system in RAG", "add solar analysis based on Ladybug principles".
**Pipeline**: framing → **Graphify (theory research) + GitNexus (AS-IS) in parallel** → human review gate → **OpenSpec (informed propose)** → human review gate → implement
**Tools involved**: all three.
**Human gates**: two — after research, and after spec.

#### Type E — Exploration / R&D
**Detection**: "investigate", "explore", "compare X vs Y", "feasibility of…".
Ex: "what is the best approach to integrate Blender MCP in our pipeline?".
**Pipeline**: framing → **Graphify (search what already exists and was documented)** → produce `research.md` in `openspec/changes/explore-<topic>/`
**Tools involved**: Graphify main; OpenSpec only to archive the study.
**Output**: document, not code. Decision to implement is a separate Type C or D task.

### 3.2 Automatic detection vs explicit declaration

**Recommendation: use explicit declaration.** Automatic detection from a generic prompt is tempting but error-prone — a prompt like "help with the auth system" can be Type A (typo) or Type D (deep refactor) depending on context in your head that the agent does not have.

`AGENTS.md` should include a block that teaches the agent to **ask first**:

```markdown
## Task Type Detection Protocol

Before starting ANY work, classify the task using this decision tree:

1. Is the change literally one line, with no semantic risk? → Type A. Proceed.
2. Is the change a localized bug fix with a known root cause? → Type B. Run GitNexus impact check first.
3. Does the change restructure existing code without new behavior? → Type C. Open OpenSpec proposal.
4. Does the change introduce new behavior grounded in our knowledge base, theory, or external research? → Type D. Run Graphify + GitNexus research first.
5. Is the request to investigate/compare/decide, not to implement? → Type E. Graphify research only, no code.

If unsure between two types, ASK the user which type before proceeding.
NEVER skip classification. NEVER assume Type A by default.
```

### 3.3 Parallel tasks and context isolation

When there is parallelism (Type D), the two research threads should run in **isolated subagents** to avoid context contamination:

- **Claude Code**: create `.claude/agents/graphify-researcher.md` and `.claude/agents/codebase-researcher.md`. Each subagent has its own context, returns only the summary, and does not pollute the main agent.
- **Cursor**: use the built-in Explore agent for one side, and direct prompt in Composer for the other — or open two git worktrees and two sessions.

Synthesis happens *after* both subagents finish, in the main agent, based on the two `.md` files produced.

#### Sequential vs parallel apply (same machine)

The parallelism risk is not Git merge — it is **two agents editing the same working tree** (shared dirty status, last-write-wins).

| Mode | When to use | How |
|------|-------------|------|
| **Sequential (default)** | One change at a time in the same folder | `/opsx:apply` in one chat; next apply only after `sdd-session-release` |
| **Safe parallel** | Two changes at once | `git worktree add ../repo-wt-b -b feat/b` + second IDE session in worktree folder |

**Coordination scripts** (local locks per worktree root):

```bash
# Start of apply (skill /opsx:apply)
bash scripts/sdd-session-register.sh --phase apply --change-id "<id>"
bash scripts/sdd-session-check.sh --phase apply --change-id "<id>"

# During long apply (optional)
bash scripts/sdd-session-heartbeat.sh

# End or pause (Session Handoff)
bash scripts/sdd-session-release.sh

# Human/agent inspection
bash scripts/sdd-session-status.sh
```

- Exclusive lock: `flock` on `.sdd/runtime/apply.lock` (gitignored).
- Presence: `.sdd/runtime/sessions/<uuid>.json` with 5 min heartbeat TTL.
- If `sdd-session-check` fails: another apply active in the **same** worktree — stop or switch to separate worktree.
- Explore/propose read-only: check returns exit 0 (advisory); apply is hard block.
- Always-on rule: `.cursor/rules/016-session-coordination.mdc` · R11 in `AGENTS.md`.

### 3.4 Full visual pipeline

```
                                 User PROMPT
                                          │
                                          ▼
                          ┌────────────────────────────────┐
                          │  Type classification (A-E)     │
                          │  (ask if ambiguous)            │
                          └────────────────────────────────┘
                                          │
        ┌─────────────┬───────────────────┼───────────────────┬─────────────┐
        ▼             ▼                   ▼                   ▼             ▼
     Type A        Type B              Type C              Type D         Type E
   direct      GitNexus only      GitNexus + OS      Graphify ∥ GitNexus  Graphify
        │             │                   │                   │             │
        │             ▼                   ▼                   ▼             ▼
        │       impact check         AS-IS doc         knowledge.md +   research.md
        │             │                   │             codebase.md         │
        │             │                   │                   │             ▼
        │             │                   │              ⊕ human gate   archive
        │             │                   │                   │             in
        │             │                   │           ⊕ new chat + handoff   openspec/
        │             │             /opsx:propose       ⊕ new chat + handoff
        │             │                   │                   │
        │             │             ⊕ human gate         /opsx:apply
        │             │                   │           ⊕ new chat + handoff
        │             │                   │                   │
        ▼             ▼            /opsx:apply                ▼
     edit          patch                  │            /opsx:archive
       ↓            ↓                     ▼           ⊕ new chat + handoff
     tests         tests           /opsx:archive              │
                                          │                   ▼
                                          ▼             /graphify --update
                                  /graphify --update           (loop)
                                       (loop)
```

The `/graphify --update` feedback arrow is what makes the system **cumulative**: each archived spec enters the knowledge graph and becomes available for future tasks.

---

## 4. Master table (question 3)

### 4.1 Responsibilities

| Aspect | OpenSpec | GitNexus | Graphify |
|---|---|---|---|
| **Domain** | Intent and decisions | Code structure | Multimodal knowledge |
| **Question answered** | "What and why?" | "How is the code organized; what breaks if I change X?" | "What do I already know, decide, or write about Y?" |
| **Main input** | Human prompt + current state | Source code (TS, Py, Go, Rust, Java, C/C++, Ruby, C#, Kotlin, Scala, PHP, Swift) | Any folder: code, docs, PDFs, images, videos, SQL, Obsidian, papers |
| **Main output** | `openspec/changes/<id>/{proposal,design,tasks}.md` + `specs/` | Queryable knowledge graph (KuzuDB) + MCP tools | `graph.json` + `GRAPH_REPORT.md` + `graph.html` + MCP |
| **Persistence** | Git (plain Markdown) | Local `.gitnexus/` (gitignored), regenerable | Local `graphify-out/` (gitignored), regenerable |
| **Automatic trigger** | Slash commands (`/opsx:propose`, `/opsx:apply`, `/opsx:archive`) | PreToolUse hook (enriches grep/glob) + direct MCP queries | PreToolUse hook (reads graph before file-read) + MCP queries |
| **When NOT to use** | Type A task (trivial) | Type E task (pure research) | Code-only tasks with no theoretical implication |
| **Problem signal** | Specs go stale (no archive) | Stale index (lots of code changed without reanalyze) | Graph has no nodes for relevant topic |

### 4.2 Agent detection

How does the agent "know" which tool to use? Three combined mechanisms:

1. **AGENTS.md** explicitly declares when each tool is consulted — see template annex 12.2.
2. **Pre-tool hooks** (Claude Code) intercept commands and enrich automatically. Ex: before any `grep`, GitNexus hook injects related call-chain context.
3. **Skill descriptions** — each skill has a description telling the agent when to self-invoke. Ex: Graphify skill says "use when investigating concepts, theory, or cross-domain relationships".

The combination avoids writing "now call GitNexus" explicitly in every prompt.

### 4.3 Detailed inputs and outputs

```
┌──────────────────────────────────────────────────────────────────────────┐
│ OpenSpec                                                                 │
├──────────────────────────────────────────────────────────────────────────┤
│ INPUTS                                                                   │
│   • Human prompt in /opsx:propose                                       │
│   • openspec/project.md (Constitution — always read)                     │
│   • openspec/specs/*.md (current specs)                                  │
│   • openspec/config.yaml (rules + context)                               │
│   • Optionally: knowledge.md and codebase.md from research phases       │
│                                                                          │
│ OUTPUTS                                                                  │
│   • openspec/changes/<change-id>/proposal.md   (why, scope)              │
│   • openspec/changes/<change-id>/design.md     (technical decisions)     │
│   • openspec/changes/<change-id>/tasks.md      (checklist)               │
│   • openspec/changes/<change-id>/specs/        (delta specs ADDED/MOD)   │
│   • After archive: openspec/specs/ updated + changes/archive/           │
└──────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────┐
│ GitNexus                                                                 │
├──────────────────────────────────────────────────────────────────────────┤
│ INPUTS                                                                   │
│   • Repository source code                                               │
│   • Toolchain configs (tsconfig, go.mod, etc.)                           │
│                                                                          │
│ OUTPUTS (via MCP, not as files)                                          │
│   • query(text)         — semantic + textual search                        │
│   • context(symbol)     — function/class summary + neighborhood          │
│   • impact(target)      — upstream/downstream blast radius               │
│   • detect_changes()    — diff vs index, surfaces what changed           │
│   • rename(old, new)    — propose safe rename (always dry_run=true)      │
│   • cypher(query)       — raw graph query                                │
│                                                                          │
│ COMPLEMENTARY OUTPUTS (files)                                            │
│   • gitnexus wiki  → wiki/index.md + pages per module                    │
└──────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────┐
│ Graphify                                                                 │
├──────────────────────────────────────────────────────────────────────────┤
│ INPUTS                                                                   │
│   • Any folder (code, docs, vault, PDFs, images, videos)               │
│   • URLs (papers via arxiv, YouTube videos)                              │
│                                                                          │
│ OUTPUTS                                                                  │
│   • graphify-out/graph.json         — serialized graph                   │
│   • graphify-out/GRAPH_REPORT.md    — god-nodes + surprises summary      │
│   • graphify-out/graph.html         — interactive viz                      │
│   • Optionally: --wiki produces markdown wiki + index.md                 │
│                                                                          │
│ OUTPUTS via MCP                                                          │
│   • query_graph(text)          — semantic search on graph                │
│   • get_node(id)               — node detail                               │
│   • get_neighbors(id)          — neighborhood                            │
│   • shortest_path(a, b)        — relation between two concepts           │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Documents and cross-references (question 3.2)

### 5.1 Document hierarchy

There are four levels. Each points to the next. **Cross-references are what make the system work as a whole.**

```
Level 1 — Constitution (rarely changes)
├── AGENTS.md                        ← universal entry point
├── openspec/project.md              ← stack + conventions + decisions
└── CLAUDE.md                        ← only references AGENTS.md
└── .cursor/rules/000-base.mdc       ← only references AGENTS.md

Level 2 — Current specs (changes with each feature)
└── openspec/specs/<capability>/spec.md

Level 3 — Active changes (ephemeral, becomes spec on archive)
└── openspec/changes/<change-id>/
    ├── proposal.md
    ├── design.md
    ├── tasks.md
    └── specs/

Level 4 — Knowledge (regenerable, but referenced)
├── graphify-out/GRAPH_REPORT.md     ← linked from AGENTS.md
├── graphify-out/graph.json          ← consumed via MCP
└── .gitnexus/lbug                   ← consumed via MCP
```

### 5.2 Mandatory cross-references

Each file must explicitly reference the other relevant ones. Without this, the agent does not know they exist.

**`AGENTS.md` must contain** (full templates in 12.2a / 12.2b):

- Mandatory sections: Context (points to `project.md`), **Commands**, Sources 1–7, **On-demand context**, Protocol A–E, R1–R9, Workflow, **Integrations** (summary), Security.
- See §2.5 and anti-patterns §2.5.1.

```markdown
## Knowledge sources (by priority)

1. `./openspec/specs/` — current requirements
2. `./openspec/changes/` — proposals and archive
3. `./graphify-out/GRAPH_REPORT.md` — knowledge graph
4. GitNexus via MCP — code structure, impact
5. Graphify via MCP or CLI `graphify query` — concepts
6. External docs cited in `openspec/project.md`
7. Web search (last resort)

## On-demand context

See table in §2.5.3 of the install guide (adapt paths).
```

**`openspec/project.md` must contain**:

```markdown
## Cross-references

- Code structure is indexed in `.gitnexus/` — use GitNexus MCP tools to navigate
- Knowledge base (theory, docs, vault) is in `graphify-out/` — see GRAPH_REPORT.md
- Active changes are in `openspec/changes/` — always check before starting new work
```

**`openspec/changes/<id>/design.md` must, when applicable, cite**:

```markdown
## Knowledge sources consulted

- Graphify: <concept1> → <concept2> via shortest_path (graph.json:node:xyz)
- GitNexus: impact analysis on AuthService showed 12 downstream dependents
- Previous spec: openspec/specs/auth-session/spec.md
- Previous archived change: openspec/changes/archive/2026-03-15-add-jwt/
```

**`openspec/changes/<id>/tasks.md` must follow** the **§12.10** template (pattern pointers, gates). Decisions and alternatives go in `design.md` (§12.3) — do not duplicate rationale in tasks.

### 5.3 What NOT to duplicate

Do not copy stack or conventions from `project.md` into `AGENTS.md`. Point to them. Duplication is the origin of drift — in three months you have two versions of the same rule in conflict.

### 5.4 When to regenerate references

| Event | Action |
|---|---|
| You changed a lot of code | `gitnexus analyze` |
| You added docs/papers to the vault | `graphify . --update` |
| You finished a feature | `/opsx:archive` (updates specs) |
| New dev/agent onboarding | Just ensure they open the repo, AGENTS.md loads everything |
| Automatic hook | `graphify hook install` rebuilds on each commit |

### 5.5 Integration evaluations and improvement

Historical record of tools and ideas **researched** to evolve the SDD stack — adopted or discarded.

| Artifact | Role |
|-----------|--------|
| `doc/avaliacoes/README.md` | Index and decision states |
| `doc/avaliacoes/TEMPLATE.md` | Template for new evaluations |
| `doc/avaliacoes/<date>-<slug>.md` | Individual evaluation |

**Rule:** candidates discarded here **do not** enter `sdd-kit` without a new OpenSpec proposal. Example: [Headroom](https://github.com/chopratejas/headroom) — context compression — **discarded** on 2026-03-26 (`doc/avaliacoes/2026-03-26-headroom-context-compression.md`).

### 5.6 Cross-references — UI development module

| Topic | Document | SDD Guide |
|------|-----------|----------|
| C1-UI installation | `doc/design/002-ui-module-install.md` | §2.11 |
| Full pipeline (shadcn default) | `doc/design/001-pipeline-open-design-shadcn-impeccable.md` | §2.11 step 2 |
| Impeccable standalone | `doc/design/000-impeccable-design-system-guia.md` | §2.11 |
| Stacks without shadcn | `doc/design/003-ui-stack-adapters.md` | §2.11 |
| Add-on script | `sdd-kit/install-ui-module.sh` | §2.11 step 3 |
| Aggregate evaluation | `doc/avaliacoes/2026-06-27-sdd-ui-development-module.md` | §5.5 |
| Normative spec | `openspec/specs/sdd-ui-module/spec.md` | after archive |
| Workspace state | `openspec/infra.md` — UI Development Module | §2.11.1 |

**Rule §5.3:** this guide **points** to `doc/design/*`; do not copy matrices, prompts, or A–D flows from `001`.

---

## 6. Research dimension (question 3.3)

### 6.1 How much research is appropriate per task type

| Type | Research time | Expected output | Signal of excess |
|---|---|---|---|
| **A** | 0 | none | any research |
| **B** | < 5 min | GitNexus impact check (1 query) | read more than 3 files |
| **C** | 15-30 min | 1-page AS-IS document | more than 500 lines of notes |
| **D** | 1-3 hours | `knowledge.md` (≤ 1 page) + `codebase.md` (≤ 1 page) | more than 5 god-nodes referenced, more than 10 files read |
| **E** | 2-8 hours | `research.md` with clear recommendation, alternatives, and risks | research with no actionable conclusion |

### 6.2 Research anti-patterns

- **Boil-the-ocean**: reading everything tangentially relevant. *Solution*: define 3 concrete questions before starting; stop when answered.
- **Confirmation bias**: research conducted to validate an already-made decision. *Solution*: force listing of at least 2 alternatives, even if discarded.
- **Research-without-output**: 2 hours reading, zero lines written. *Solution*: start writing `research.md` in 30 min even with gaps.

### 6.3 Source hierarchy — decreasing reliability

```
1. Current specs (openspec/specs/)              ← Project truth
2. Archived specs (openspec/changes/archive/)  ← Decided historical truth
3. Your vault knowledge graph (Graphify)       ← Your curated truth
4. GitNexus (current code)                      ← Truth of what is running
5. External docs referenced in project.md     ← Upstream truth
6. Web search                                    ← Suspect until proven otherwise
7. LLM memory without source                      ← Unreliable, always verify
```

Rule: **a statement in `research.md` or `design.md` that cannot be anchored to one of levels 1-5 must be flagged as `[ASSUMPTION]` for human validation**.

### 6.4 Avoid dubious sources

For web search (when inevitable, as in new Type E):

- Prefer primary domains: official docs, ArXiv, open-source project sites, project GitHub, RFC.
- Reject: SEO content farms (medium spam, generic tutorials without identifiable author), StackOverflow answers without cross-confirmation, posts > 2 years old for rapidly changing tools.
- Confirm each claim in **at least two independent sources** if used for architectural decision.
- For papers: prefer peer-reviewed conference publications; ArXiv preprints require critical reading.

Template to validate a source before adding to Graphify:

```
- [ ] Author identified and credible in the domain?
- [ ] Publication date < 2 years (for fast tech) or established classic?
- [ ] Content is primary (not citation of citation)?
- [ ] Can be validated experimentally in this project?
- [ ] Accept for Graphify? Yes/No/With caution note
```

### 6.5 Anti-hallucination in research

- Graphify tags each edge as `EXTRACTED`, `INFERRED` or `AMBIGUOUS` — use this. In `research.md`, when citing a relationship, mark which type it came from.
- GitNexus returns staleness — if index is old, reindex before trusting impact.
- LLM must be instructed (via AGENTS.md) to refuse claims without source: "If you cannot point to a source in this repo's knowledge graph, write `[NEEDS VERIFICATION]` instead of guessing."

---

## 7. Task protocols (question 3.4)

### 7.1 Cross-cutting protocols (apply to all types)

**Token efficiency**
- `CLAUDE.md` ≤ 200 lines. Details go to `@imported.md` files loaded on demand.
- Cursor rules: each `.mdc` ≤ 500 lines; total `alwaysApply: true` ≤ 2000 tokens.
- Use subagents for exploration: the subagent sees the noise, returns only the synthesis to the main agent.
- Skills (`.claude/skills/<name>/SKILL.md`) load only the description; the body loads only when invoked — use this for long playbooks.

**Anti-hallucination**
- AGENTS.md has a clause: "If unsure, ASK before assuming. If the user provides an unfamiliar term, search the knowledge graph BEFORE answering."
- For external API calls: the agent must always verify via GitNexus whether the API/function exists in the repo before using it; if not, declare `[ASSUMPTION]`.
- For library names: verify in `package.json`/`pyproject.toml` before assuming version.

**Simplicity**
- "Smallest reasonable change" principle — any task touching > 5 files needs an OpenSpec proposal.
- Reject premature abstractions. If design.md proposes a factory/adapter/wrapper "for future flexibility", reject and ask for a concrete case.

**Scalability**
- Archived specs are the primary source for future features — do not re-explain concepts already decided.
- Graphify automatic hook on each commit ensures the knowledge graph does not go stale.
- Consistent naming conventions ease future queries (e.g. change-id always `verb-noun-modifier`).

**Security**
- Claude Code: `PreToolUse` hooks to block `rm -rf`, `git push --force`, `sudo`, commands to paths outside the repo. Template in 12.4.
- Permissions: `permissions.allow` enumerates safe Bash; `permissions.deny` lists hard blocks. Never `Bash(*)` in allow.
- Secrets: NEVER in `CLAUDE.md`, `AGENTS.md`, `project.md`, or any file in git. Always in `.env` (gitignored) or environment variables.
- Graphify: by design, local code does not leave the machine (local tree-sitter); only docs/PDFs/images go to the LLM via skill (your IDE session). Validate this if working with sensitive IP.
- GitNexus: 100% local.
- OpenSpec: 100% local (no API keys).

**Audit**
- All specs live in git — `git log openspec/specs/` shows requirements evolution.
- Commit messages reference the change-id: `feat(auth): implement add-jwt change`.
- `openspec/changes/archive/` keeps history of proposals, designs, and tasks that led to each feature — primary source for post-mortems.
- PreToolUse hook can log all tool calls to `.claude/logs/` (template in 12.4).
- GitNexus exposes `detect_changes()` to audit drift between code and the last index.

### 7.2 Type-specific protocols

**Type A — Trivial**
- Refuse if ambiguous. Ask for confirmation if the change seems to have implications.
- Do not create OpenSpec change.
- Direct commit. Message: `chore: <short description>`.

**Type B — Bug fix**
- Always `gitnexus impact <target>` before patch.
- Always add a test that fails *before* the fix.
- Verify the test passes after.
- Commit: `fix(<scope>): <description> (closes #<issue> if any)`.

**Type C — Refactor**
- OpenSpec proposal required.
- `design.md` must include a "Behavioral parity" section — list invariants that must remain the same.
- `tasks.md` with **Pattern** (AS-IS file to mirror) and **Gate** (deterministic command) per code task — see §12.10.
- Existing tests must pass without changes (except imports if files moved).
- No new behavior added in a refactor — otherwise it is Type D.

**Type D — Feature grounded in theory**
- Two research docs required: `knowledge.md` and `codebase.md`.
- `design.md` explicitly cites Graphify nodes and GitNexus impact.
- `tasks.md` with mandatory **Pattern** + **Gate** on tasks that touch code — see §12.10.
- At least one rejected alternative documented.
- Tests for the central theoretical case, not only for the code.

**Type E — Exploration**
- Output is a document, not code. Refuse direct code PRs from Type E.
- `research.md` archived in `openspec/changes/explore-<topic>/` even if it does not lead to implementation.
- Conclusion in format "Recommendation: <action> because <reason>. Alternatives considered: <list>. Risks: <list>."

---

## 8. System-wide rules (question 4)

### 8.1 Where rules live

**Principle**: universal rules in a single canonical place, with aliases for each tool.

```
AGENTS.md (root)                      ← SOURCE OF TRUTH for universal rules
  ↑
  ├─ CLAUDE.md                        ← only: "Strictly follow ./AGENTS.md"
  ├─ .cursor/rules/000-base.mdc       ← only: "Strictly follow ./AGENTS.md"
  └─ openspec/AGENTS.md               ← generated by OpenSpec, do NOT edit manually
                                        (contains only OpenSpec instructions)

openspec/project.md                   ← SOURCE OF TRUTH for stack + conventions
                                        of the specific project

.cursor/rules/*.mdc                   ← rules with glob scoping
                                        (e.g. rules specific to *.tsx)

.claude/agents/*.md                   ← subagent personas
.claude/skills/*/SKILL.md             ← invocable playbooks
.claude/hooks/*                       ← deterministic guardrails
.claude/settings.json                 ← permissions
```

### 8.2 The nine universal rules (in AGENTS.md)

```markdown
# Universal rules for AI agents working in this repo

## R1 — Task Type Detection
Before any work, classify the task (A through E — see "Task Type Detection
Protocol" below). If ambiguous, ASK.

## R2 — Knowledge Source Priority
Consult sources in this order: specs > archived changes > Graphify > GitNexus
> external docs > web. Web is last resort.

## R3 — No Hallucinations
If a fact cannot be anchored to one of the sources in R2, mark it
`[NEEDS VERIFICATION]` instead of asserting it. NEVER invent library names,
API signatures, or file paths.

## R4 — Smallest Reasonable Change
Prefer the minimal change that solves the problem. No speculative
abstractions, factories, or wrappers without a concrete second use case
in the codebase TODAY.

## R5 — Behavioral Parity in Refactors
Refactors do NOT introduce new behavior. If you find yourself wanting to,
stop and create a new OpenSpec proposal.

## R6 — Test Before Fix
Bugs require a failing test first, then the fix.

## R7 — Spec Before Code (for non-trivial work)
For tasks of type C, D, and E, the OpenSpec proposal must be reviewed and
approved BEFORE any code is written.

## R8 — Source Anchoring
Every non-trivial claim in design.md, research.md, or commit messages
must cite a source: spec ID, archived change ID, Graphify node, GitNexus
function name, or external URL.

## R9 — Auditability
Every commit references either an OpenSpec change-id (`feat(auth):
implement add-jwt`) or a fix issue (`fix(api): handle null x (closes
#42)`). No `wip`, `misc`, or unscoped commits.
```

### 8.3 Precedence hierarchy

When rules compete:

```
1. Hooks (PreToolUse)              ← Deterministic, non-negotiable
2. permissions.deny                ← Blocks even if model "wants"
3. AGENTS.md universal rules       ← Applied to all
4. openspec/project.md             ← Project-specific
5. .cursor/rules/*.mdc (glob match)← File/context-specific
6. Slash commands (skills)         ← On-demand
7. User prompt                     ← Most flexible
```

User prompt never overrides a hook. If a hook blocks, the user must reconfigure the hook consciously, not bypass via prompt.

---

## 9. Cursor configuration (question 5)

### 9.1 Final file structure

```
project/
├── AGENTS.md                                 ← curated, source of truth
├── .cursor/
│   ├── rules/
│   │   ├── 000-base.mdc                      ← alwaysApply, points to AGENTS.md
│   │   ├── 010-typescript.mdc                ← auto-attach: globs: ["**/*.ts", "**/*.tsx"]
│   │   ├── 020-python.mdc                    ← auto-attach: globs: ["**/*.py"]
│   │   ├── 030-supabase.mdc                  ← auto-attach: globs: ["**/migrations/**", "**/db/**"]
│   │   ├── 040-n8n.mdc                       ← auto-attach: globs: ["**/n8n/**"]
│   │   └── 050-security.mdc                  ← alwaysApply, guardrails
│   ├── commands/                             ← generated by OpenSpec, do not edit
│   │   ├── opsx-propose.md
│   │   ├── opsx-apply.md
│   │   └── opsx-archive.md
│   ├── skills/                               ← generated by GitNexus + Graphify
│   │   ├── gitnexus-exploring/
│   │   ├── gitnexus-impact/
│   │   └── graphify/
│   └── mcp.json                              ← gitnexus + (optional) graphify
```

### 9.2 Rules to create

**`.cursor/rules/000-base.mdc`** — always applied, redirects to AGENTS.md:

```markdown
---
description: Base rules for this project (alwaysApply)
alwaysApply: true
---

# Base rules

Strictly follow the rules and conventions in `./AGENTS.md` at the repo root.

Additionally:
- Project constitution is in `./openspec/project.md`
- Active specs are in `./openspec/specs/`
- Knowledge base is in `./graphify-out/GRAPH_REPORT.md`
- Code structure is queryable via GitNexus MCP tools

For any non-trivial task (type C/D/E), invoke `/opsx:propose <description>`
before writing code.
```

**`.cursor/rules/050-security.mdc`** — always applied, hard limits:

```markdown
---
description: Security guardrails (alwaysApply)
alwaysApply: true
---

# Security rules

NEVER:
- Write secrets, API keys, tokens, or passwords to any file in this repo
- Run `rm -rf` on paths outside the current repo
- Execute `git push --force` or `git push --force-with-lease` without explicit user approval
- Disable hooks with `--no-verify` without explaining why
- Add dependencies without checking their security advisories first

ALWAYS:
- Read .env.example to understand expected env vars; never read .env
- Sanitize all user inputs in API routes (Zod, valibot, or equivalent)
- Use parameterised queries for any DB access; no string concatenation
- Add input validation as the FIRST line in any route handler
```

**`.cursor/rules/010-typescript.mdc`** — auto-attach a TS files:

```markdown
---
description: TypeScript conventions
globs:
  - "**/*.ts"
  - "**/*.tsx"
alwaysApply: false
---

# TypeScript rules for this project

- Strict mode is on. No `any` without comment explaining why.
- No default exports (use named exports).
- Imports: absolute paths from `@/` for internal, relative only for siblings.
- Async/await over .then chains.
- Errors: use Result types or typed exceptions; never silent failures.
- Schemas: Zod for runtime validation at all I/O boundaries.
```

(Add equivalent templates for Python, Supabase, n8n in the remaining rules — annex 12.5)

### 9.3 MCP config (`~/.cursor/mcp.json` global)

```json
{
  "mcpServers": {
    "gitnexus": {
      "command": "npx",
      "args": ["-y", "gitnexus@latest", "mcp"]
    },
    "graphify": {
      "command": "python",
      "args": ["-m", "graphify.serve", "graphify-out/graph.json"]
    }
  }
}
```

On Windows, prefix with `cmd /c`:
```json
{
  "command": "cmd",
  "args": ["/c", "npx", "-y", "gitnexus@latest", "mcp"]
}
```

### 9.4 Verification

In Cursor, open Composer and type:
- `@rules` should show the 6 `.mdc` files loaded (3 always + 3 attached depending on open file).
- `/rules` shows the state.
- Test: `/opsx:propose teste-instalacao` — should create folder `openspec/changes/teste-instalacao/`.

---

## 10. VS Code + Claude Code configuration (question 5)

### 10.1 Prerequisites

- VS Code 1.109+
- Extension "Claude Code" (publisher: anthropic) — verify publisher carefully, there are knock-offs.
- Claude Code CLI ≥ 2.1.140 (the extension includes CLI but better ensure a recent version: `claude install`).

### 10.2 Final structure

```
project/
├── AGENTS.md                            ← same file as Cursor
├── CLAUDE.md                            ← short, points to AGENTS.md
├── .claude/
│   ├── settings.json                    ← permissions
│   ├── commands/                        ← generated by OpenSpec
│   ├── skills/                          ← generated by GitNexus + Graphify
│   │   ├── gitnexus-exploring/
│   │   ├── gitnexus-impact/
│   │   ├── gitnexus-refactor/
│   │   └── graphify/
│   ├── agents/                          ← custom subagents
│   │   ├── graphify-researcher.md
│   │   ├── codebase-researcher.md
│   │   └── security-reviewer.md
│   └── hooks/                           ← deterministic guardrails
│       ├── block-dangerous.sh
│       ├── session-start.sh
│       └── post-edit-typecheck.sh
```

### 10.3 `CLAUDE.md` (root)

```markdown
# CLAUDE.md — entry point for Claude Code

Strictly follow the rules and conventions in `./AGENTS.md`.

This file exists for compatibility with Claude Code's lookup order; the
source of truth is AGENTS.md to keep behavior consistent across tools
(Cursor, Codex, etc.).

## Quick context

- Stack and conventions: `./openspec/project.md`
- Active specs: `./openspec/specs/`
- Active proposals: `./openspec/changes/`
- Knowledge graph: `./graphify-out/GRAPH_REPORT.md`
- Code graph: via GitNexus MCP (`gitnexus_query`, `gitnexus_impact`, etc.)

## Task type protocol

See "Task Type Detection Protocol" in AGENTS.md. Always classify before
acting.
```

### 10.4 `.claude/settings.json`

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(pnpm *)",
      "Bash(npx gitnexus *)",
      "Bash(graphify *)",
      "Bash(openspec *)",
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(git branch *)",
      "Bash(git checkout *)",
      "WebSearch",
      "WebFetch(domain:docs.anthropic.com)",
      "WebFetch(domain:supabase.com)",
      "WebFetch(domain:n8n.io)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(git push --force*)",
      "Bash(cat .env)",
      "Bash(curl * | bash)",
      "Bash(curl * | sh)"
    ]
  }
}
```

### 10.5 Critical hook — `.claude/hooks/block-dangerous.sh`

```bash
#!/bin/bash
COMMAND=$(jq -r '.tool_input.command' 2>/dev/null)

# Block dangerous patterns even if they slip past permissions
PATTERNS=(
  'rm -rf /'
  'rm -rf ~'
  '> /dev/sda'
  'mkfs'
  'dd if='
  ':(){:|:&};:'
)

for p in "${PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -q "$p"; then
    jq -n --arg reason "Dangerous command blocked: $p" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $reason
      }
    }'
    exit 2
  fi
done

exit 0
```

Register in `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous.sh"
          }
        ]
      }
    ]
  }
}
```

### 10.6 Subagents

`.claude/agents/graphify-researcher.md`:

```markdown
---
name: graphify-researcher
description: Use to research theory, concepts, and prior knowledge from the
  Graphify knowledge graph. Invoke for type D and E tasks before writing
  any spec or code. Returns a compact knowledge.md summary.
tools: Read, mcp__graphify__query_graph, mcp__graphify__get_node,
  mcp__graphify__shortest_path
model: opus
---

You are a research librarian for this project's knowledge graph.

Your job:
1. Read the user's research question.
2. Query the Graphify graph (graphify-out/graph.json) for relevant concepts.
3. Find shortest paths between key concepts and trace what connects them.
4. Identify god-nodes that the question touches.
5. Return a `knowledge.md` document (≤1 page) with:
   - Key concepts found (with graph node IDs)
   - Relationships between them (cite edge types)
   - Prior decisions or specs that touch these concepts
   - Gaps where the graph has nothing (mark `[KNOWLEDGE GAP]`)
   - Recommendation: is enough known to proceed, or do we need more research?

NEVER write code. NEVER speculate about what is not in the graph.
If the graph has no relevant nodes, say so explicitly.
```

`.claude/agents/codebase-researcher.md`:

```markdown
---
name: codebase-researcher
description: Use to research how the current code is structured for a
  given area. Invoke for type C and D tasks. Returns a compact
  codebase.md AS-IS document.
tools: Read, Grep, Glob, mcp__gitnexus__query, mcp__gitnexus__context,
  mcp__gitnexus__impact
model: sonnet
---

You are a codebase archaeologist.

Your job:
1. Read the user's question about an area of the codebase.
2. Use GitNexus MCP tools to find the relevant entry points.
3. Trace call chains, identify clusters, and map dependencies.
4. Run impact analysis for any symbols that will change.
5. Return a `codebase.md` document (≤1 page) with:
   - Entry points (files + functions)
   - Key call chains relevant to the question
   - Blast radius for proposed changes
   - Patterns already used in this area (cite specific files)
   - Risk areas (tight coupling, missing tests, etc.)

NEVER write code. NEVER speculate. Cite exact file:line references.
```

### 10.7 Verification

```bash
# List active configuration
claude /context
claude /agents
claude /hooks
claude mcp list

# Test subagent
# In Claude Code:
> Use the codebase-researcher agent to map the auth flow
```

---

## 11. Code protocols (question 7)

### 11.1 Non-negotiable principles

These go in `openspec/project.md` in the "Coding standards" section:

1. **Replicability**: each solution is reproducibly testable. No tests, no merge.
2. **Readability > cleverness**: clear code with 2 functions is better than a cryptic one-liner.
3. **Self-documenting names**: variables and functions communicate intent. Comments explain *why*, not *what*.
4. **Comments document decisions, not mechanics**: `// retries 3x because n8n webhook timeout is 10s` is useful. `// increment i` is noise.
5. **Modularization by capability, not by type**: `auth/` folder with `auth.service.ts`, `auth.controller.ts`, `auth.types.ts`, instead of global `services/`, `controllers/`, `types/` folders.
6. **No silent failures**: errors are propagated or logged explicitly, never swallowed.
7. **Input validation at boundaries**: every external input (API, webhook, CSV, env) is validated by schema (Zod, Pydantic) at the first point of contact.
8. **Tracing built-in**: for Pedro's multi-agent bot, each agent step must log (correlation ID, agent name, input hash, output hash, duration, errors).

### 11.2 Comment structure

```typescript
/**
 * AssociationEngine — implements KBS-style bisociative association between concepts.
 *
 * Why this exists: standard cosine similarity treats all related concepts the same.
 * KBS framework (see openspec/specs/kbs-association/spec.md) distinguishes routine
 * similarity from bisociative leaps. This engine encodes the distinction.
 *
 * Sources:
 * - openspec/specs/kbs-association/spec.md (R-KBS-001)
 * - Graphify nodes: bisociation, koestler-frame, simonton-chance
 *
 * Threading: NOT thread-safe. Wrap in lock if calling concurrently.
 */
export class AssociationEngine {
  // ...
}
```

Inline comments (rare):

```typescript
// Reset retries when we hit a 429 — Supabase rate limit window is 60s,
// not 5s like other endpoints. See infra/rate-limits.md.
if (response.status === 429) {
  await sleep(60_000);
  retries = 0;
}
```

### 11.3 Modular structure for the multi-agent bot

```
src/
├── agents/                          ← capability: each agent is an isolated module
│   ├── orchestrator/
│   │   ├── orchestrator.service.ts
│   │   ├── orchestrator.types.ts
│   │   ├── orchestrator.test.ts
│   │   └── README.md                ← purpose, inputs, outputs, dependencies
│   ├── retrieval/
│   ├── synthesis/
│   └── validation/
├── infra/                           ← capability: integration with externals
│   ├── supabase/
│   │   ├── client.ts
│   │   ├── schemas.ts               ← Zod schemas mirroring DB schema
│   │   ├── migrations/
│   │   └── README.md
│   ├── n8n/
│   └── tavily/
├── core/                            ← shared, framework-agnostic
│   ├── tracing/
│   │   ├── correlation.ts
│   │   ├── logger.ts
│   │   └── errors.ts
│   └── validation/
└── lib/                             ← pure utility, no I/O
    ├── id.ts
    └── time.ts
```

Each capability folder has:
- A single entry point (`index.ts` that re-exports only the public API)
- `README.md` explaining purpose, dependencies, and how to test
- Co-located tests (`*.test.ts`)

### 11.4 Data traceability

For the multi-agent pipeline, each piece of data flowing between stages carries:

```typescript
type TraceContext = {
  correlationId: string;          // unique ID for the entire request
  agentChain: string[];           // ["orchestrator", "retrieval", "synthesis"]
  step: number;
  parentSpanId: string | null;
  spanId: string;
  startedAt: ISOTimestamp;
};

type AgentInput<T> = {
  trace: TraceContext;
  payload: T;
  schemaVersion: string;          // e.g. "v1.2.0" — to detect drift
};
```

Every function that processes data between agents receives and propagates this context. Internal logger writes each step in structured format to Supabase (`agent_traces` table) or compatible logger.

### 11.5 Bug prevention

- **Tests are first-class**: each bug fix starts with a failing test. Each feature includes tests for happy paths, edge cases, and error paths.
- **Property-based testing** for pure logic (fast-check in TS, hypothesis in Python).
- **Contract tests** at boundaries (each agent declares its Zod contract; other agents validate against that contract).
- **Type safety end-to-end**: TS strict + Zod runtime; Pydantic in Python.

### 11.6 Attack prevention

| Vector | Defense | Where to implement |
|---|---|---|
| SQL injection | Parameterised queries via Supabase client; never string concat | `infra/supabase/client.ts` |
| Prompt injection | Sanitize all external strings before putting them in LLM prompts; use role separation | `agents/*/prompt.ts` |
| SSRF (Tavily, web fetch) | Domain allowlist; reject private IPs and localhost | `infra/web/fetch.ts` |
| Webhook spoofing | HMAC verification on all webhooks | `infra/n8n/webhook.handler.ts` |
| Secret leakage | PreToolUse hooks block reading `.env`; logger redacts patterns `sk-*`, `api_key=*` | `.claude/hooks/`, `core/tracing/logger.ts` |
| Dependency injection | Audit `pnpm audit` / `pip-audit` in CI; reject deps with critical vulns | `.github/workflows/audit.yml` |
| XSS (if UI exists) | Sanitization on render; CSP headers; React escapes by default, dangerouslySetInnerHTML forbidden without review | Frontend configuration |
| Rate limiting | Token bucket per user/agent at each API entry; exponential backoff | `core/rate-limit.ts` |

### 11.7 Module documentation

Each capability has `README.md`:

```markdown
# Retrieval Agent

## Purpose
Pulls candidate documents from the pgvector store given a query embedding.

## API
- `retrieve(input: RetrieveInput): Promise<RetrieveOutput>`

## Inputs
- `RetrieveInput`: schema in `retrieval.types.ts`

## Outputs
- `RetrieveOutput`: schema in `retrieval.types.ts`

## Dependencies
- `infra/supabase/client.ts` — pgvector queries
- `core/tracing/correlation.ts` — trace propagation

## Tests
- `retrieval.test.ts` (unit)
- `retrieval.integration.test.ts` (against a test Supabase instance)

## Cross-references
- Spec: `openspec/specs/retrieval/spec.md`
- Design history: `openspec/changes/archive/2026-04-08-add-retrieval/`

## Known limits
- Top-K hard-coded to 20; if you need more, this needs a new spec.
- No re-ranking yet — see `openspec/changes/archive/2026-04-22-reranking/`
  for why we deferred it.
```

---

## 12. Annexes: complete templates

### 12.1 Template `openspec/project.md`

```markdown
# Project: <project name>

## Purpose
<One paragraph: what this project does, for whom, and what success looks like.>

## Stack
- Runtime: Node.js 20.x, Python 3.11
- Frontend: Next.js 15 (App Router), Tailwind, shadcn/ui
- Backend: Next.js server actions + n8n workflows
- Database: Supabase (Postgres + pgvector)
- LLM: Anthropic Claude (primary), Gemini 2.5 Flash (cost-optimized)
- Search: Tavily
- Testing: Vitest (TS), pytest (Python), Playwright (e2e)

## Architecture
<3-5 bullets describing the high-level shape. Reference diagrams in /docs.>

## Conventions
- Module organization: by capability (auth/, retrieval/), not by type
- No default exports
- Strict TypeScript; Zod at all I/O boundaries
- Errors typed; no silent failures
- Tests co-located with code
- Correlation IDs propagated through every agent step

## Language policy

<!-- SDD_LANGUAGE_POLICY_START -->
| Axis | Key | Value |
|------|-----|-------|
| Chat | `chat_language` | en |
| Docs | `docs_language` | en |
| Code | `code_language` | en |
<!-- SDD_LANGUAGE_POLICY_END -->

Configured at C1 install (`sdd-kit/install.sh` flags or prompts). v1 allowlist: `en`, `pt-BR`. See guide §2.1.1.

## Constraints
- Multi-agent traces stored in `agent_traces` Supabase table
- All external inputs validated via Zod before any business logic
- Secrets only in env vars; never in code/specs/markdown

## Cross-references
- Code graph: `.gitnexus/` (via MCP tools)
- Knowledge graph: `graphify-out/GRAPH_REPORT.md`
- Specs: `openspec/specs/`
- Active changes: `openspec/changes/`

## Non-goals
- We do NOT build our own LLM evaluation framework — use Langfuse.
- We do NOT host our own vector DB — Supabase pgvector is the choice.
- We do NOT implement auth from scratch — Supabase Auth handles it.
```

### 12.2 Common core `AGENTS.md` (all installations)

Shared block — paste and complete Commands per 12.2a or 12.2b.

```markdown
# AGENTS.md — Universal Instructions for AI Agents

> Canonical for Cursor, Claude Code, Codex, etc. `CLAUDE.md` and `.cursor/rules/` only point here.
> Standard: https://agents.md/

## Project context

See `./openspec/project.md` (stack, conventions, constraints). **Do not duplicate** stack here.

## Commands

[FILL IN: table from profile 12.2a APP or 12.2b DOCS_SPECS]

## Knowledge sources (by priority)

1. `./openspec/specs/`  2. `./openspec/changes/`  3. `./graphify-out/GRAPH_REPORT.md`
4. GitNexus MCP  5. Graphify MCP or `graphify query`  6. Docs in `project.md`  7. Web (last resort)

Never assert facts without source 1–6. Type D/E: Graphify + GitNexus before code.

## On-demand context

| Situation | File |
|----------|----------|
| Constitution | `openspec/project.md` |
| Specs | `openspec/specs/` |
| Active change | `openspec/changes/<id>/` |
| Graph | `graphify-out/GRAPH_REPORT.md` |
| Installed infra | `openspec/infra.md` |
| SDD guide | `doc/byebyevibe-guide.md` |
| SDD upgrade | `doc/byebyevibe-guide.md` §2.9 |
| TS / Py / DB | `.cursor/rules/010-*.mdc`, `020-*.mdc`, `030-*.mdc` |

## Task protocol (A–E)

| Type | Pipeline |
|------|----------|
| A Trivial | Direct edit |
| B Bug | GitNexus impact → patch → test |
| C Refactor | GitNexus AS-IS → `/opsx:propose` → implement |
| D Feature | Graphify ∥ GitNexus → propose → implement |
| E Exploration | Graphify → `research.md` |

If ambiguous, ASK. Never assume Type A.

## Rules R1–R11

R1 classify · R2 specs>graphify>gitnexus · R3 `[NEEDS VERIFICATION]` · R4 minimal change ·
R5 refactor with no new behavior · R6 test before fix · R7 spec before code (C/D/E) ·
R8 cite sources · R9 commits with scope/change-id · R10 known infra (`openspec/infra.md`) ·
R11 local coordination (`sdd-session-check` before apply; `sdd-session-release` at end)

## Workflow

`/opsx:propose` · `/opsx:apply` · `/opsx:archive` · `/opsx:explore` · `graphify update .` · `npx gitnexus analyze --force`

## Integrations (summary)

**GitNexus:** impact before editing symbols; `detect_changes` before commit. Skills: `.claude/skills/gitnexus/`.

**Graphify:** read `GRAPH_REPORT.md` before grep on architecture questions; `graphify update .` after code changes.

## Testing

[FILL IN: npm test / pytest / openspec validate / N/A for docs-only]

## PR and commits

Conventional Commits; reference OpenSpec change-id when applicable. Do not commit `graphify-out/`, `.gitnexus/`.

## Security

No secrets in git; validate inputs; parameterized queries; do not read `.env`.

## Communication

[Adapt: pt-BR, direct, no preamble]
```

### 12.2a Commands — APP profile

```markdown
| Command | Use |
|---------|-----|
| `npm run dev` / `pnpm dev` | Development (not `npm run build` in agent session) |
| `npm test` / `pnpm test` | Tests |
| `npm run lint` | Lint |
| `npx openspec list` | OpenSpec changes |
| `npx gitnexus analyze --force` | Reindex code |
| `graphify update .` | Update graph |
```

### 12.2b Commands — DOCS_SPECS profile

```markdown
| Command | Use |
|---------|-----|
| `npx openspec list` | Active changes |
| `npx openspec new change "<id>"` | New change (CLI) |
| `/opsx:propose` | Proposal (Cursor/Claude) |
| `npx gitnexus status` | Index status |
| `npx gitnexus analyze --force` | Reindex |
| `graphify update .` | AST graph |
| `graphify query "<question>"` | Graph search |
| `bash scripts/sdd-session-status.sh` | Active SDD sessions (local worktree) |

Note: there is no `npm run dev` at the root of this profile.
```

### 12.3 Template `openspec/changes/<id>/design.md` (com cross-references)

```markdown
# Design — <change title>

## Context

<Why this change. Link to proposal.md for the user-facing motivation.>

## Knowledge sources consulted

### From Graphify
- Concept: `bisociation` (node graphify://node/bisociation-001)
- Concept: `frame-shifting` (node graphify://node/frame-shift-022)
- Shortest path: `bisociation` → `cognitive-distance` → `creativity-score`
- Relevant papers in vault: "Koestler 1964 — Act of Creation", "Simonton 1999"

### From GitNexus
- Current implementation: `src/agents/retrieval/retrieval.service.ts:42`
- Call chain: `orchestrator.run() → retrieval.retrieve() → embedding.embed()`
- Blast radius: 7 downstream consumers of `RetrieveOutput`
- Tests affected: `retrieval.test.ts`, `orchestrator.integration.test.ts`

### From OpenSpec history
- Prior spec: `openspec/specs/retrieval/spec.md` (R-RET-001 to R-RET-008)
- Archived change: `openspec/changes/archive/2026-04-08-add-retrieval/`
  (decision to use pgvector over Pinecone)

## Decisions

### D1 — Use cosine similarity as base, bisociative re-rank as second stage
Rationale: KBS framework distinguishes routine and bisociative associations.
Single-stage similarity loses this. Source: Graphify path traced above.

### D2 — Store bisociation scores in same table, new column
Rationale: avoids migration overhead; column nullable for backward compat.
Source: openspec/specs/retrieval/spec.md R-RET-003 (schema stability).

## Alternatives considered

### A1 — Use a separate embedding model for "creative" queries
Rejected: doubles infra cost; concept already covered by re-rank stage.

### A2 — Defer to a later change
Rejected: blocking 3 other features in the queue.

## Open questions

- [Q1] Threshold for bisociation classification — value TBD via experimentation.
  Will be encoded as env var until empirically settled.

## Risks

- R1 — Bisociation scoring is novel; may need iteration. Mitigation: feature
  flag, rollback plan.
- R2 — Performance: re-rank adds ~50ms p99. Mitigation: cache hot queries.
```

### 12.4 Template hooks Claude Code

`.claude/hooks/session-start.sh`:

```bash
#!/bin/bash
# Loads project context summary at session start.

if [ -f "$PWD/openspec/project.md" ]; then
  echo "📄 Project: $(grep -m1 '^# Project' openspec/project.md | sed 's/# Project: //')"
fi

# Active changes
ACTIVE=$(ls openspec/changes/ 2>/dev/null | grep -v '^archive$' | wc -l | tr -d ' ')
if [ "$ACTIVE" -gt 0 ]; then
  echo "🚧 Active OpenSpec changes: $ACTIVE"
  ls openspec/changes/ 2>/dev/null | grep -v '^archive$' | sed 's/^/   - /'
fi

# Graphify freshness
if [ -f "graphify-out/.graphify_root" ]; then
  AGE=$(find graphify-out/graph.json -mtime +7 2>/dev/null | wc -l | tr -d ' ')
  if [ "$AGE" -gt 0 ]; then
    echo "⚠️  Graphify index is >7 days old. Consider: /graphify . --update"
  fi
fi

# GitNexus freshness
if command -v gitnexus &>/dev/null && [ -d ".gitnexus" ]; then
  STATUS=$(gitnexus status 2>/dev/null | grep -E 'stale|outdated')
  if [ -n "$STATUS" ]; then
    echo "⚠️  GitNexus index may be stale. Consider: gitnexus analyze"
  fi
fi

exit 0
```

`.claude/hooks/post-edit-typecheck.sh`:

```bash
#!/bin/bash
# Runs typecheck after Claude edits a TS file.

FILE=$(jq -r '.tool_input.file_path' 2>/dev/null)

if [[ "$FILE" == *.ts || "$FILE" == *.tsx ]]; then
  if [ -f "tsconfig.json" ]; then
    if ! pnpm tsc --noEmit --pretty false 2>&1 | head -20; then
      echo "❌ Type errors introduced — Claude should review."
    fi
  fi
fi

exit 0
```

Registar em `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [{"type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh"}]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{"type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/post-edit-typecheck.sh"}]
      }
    ]
  }
}
```

### 12.5 Additional `.cursor/rules/*.mdc` templates

`.cursor/rules/020-python.mdc`:

```markdown
---
description: Python conventions
globs:
  - "**/*.py"
alwaysApply: false
---

# Python conventions

- Python 3.11+; use type hints everywhere
- Pydantic v2 for all I/O schemas
- Async via `asyncio`; no `time.sleep` in async code
- Errors: custom exception hierarchy in `core/errors.py`; never bare `except:`
- Logging: structured (structlog), never print()
- Tests: pytest with `pytest-asyncio`; co-located in `tests/` adjacent to module
- Imports: absolute; ordered (stdlib, third-party, internal)
- No mutable default arguments
```

`.cursor/rules/030-supabase.mdc`:

```markdown
---
description: Supabase + Postgres conventions
globs:
  - "**/migrations/**"
  - "**/db/**"
  - "**/infra/supabase/**"
alwaysApply: false
---

# Supabase / Postgres rules

- All migrations are reversible (up + down)
- Migration names: `YYYYMMDDHHMM_<verb>_<noun>.sql`
- RLS enabled on every table; default deny
- Columns: snake_case
- Tables: plural, snake_case (users, agent_traces)
- pgvector: index is `ivfflat` with `lists = sqrt(rows)`
- Schemas mirrored in TypeScript via `infra/supabase/schemas.ts` (Zod)
- NEVER: raw string SQL with interpolation; use parameterized queries
```

`.cursor/rules/040-n8n.mdc`:

```markdown
---
description: n8n workflow conventions
globs:
  - "**/n8n/**"
  - "**/*.workflow.json"
alwaysApply: false
---

# n8n rules

- Workflow files versioned in repo; exported as JSON
- One workflow per feature; cross-workflow calls via webhook with HMAC
- Always include `Set` node with correlation_id as first step
- Error workflow set on every workflow (centralized error handler)
- Credentials never inline; use n8n credentials store with env-var refs
```

### 12.6 One-shot install command

> **v1.3.0:** The full script lives in `scripts/bootstrap-sdd.sh` (repo) and `sdd-kit/templates/scripts/bootstrap-sdd.sh` (kit). After CLIs, it delegates payloads to `sdd-kit/install.sh`. **Do not** copy bash blocks from this annex — use `sdd-kit/templates/`.

Order summary:

```bash
bash scripts/bootstrap-sdd.sh          # global CLIs + openspec init
bash sdd-kit/install.sh --profile DOCS_SPECS [--dry-run]
bash sdd-kit/verify.sh
```

See `sdd-kit/README.md` for profiles and C1–C3 scenarios.

### 12.7 Nested `AGENTS.md` template (subfolder)

Example for `doc/curso/scripts/AGENTS.md` or `packages/foo/AGENTS.md`:

```markdown
# AGENTS.md — [folder name]

Local instructions; the canonical file at the root is `../../AGENTS.md`.

## Commands

| Command | Use |
|---------|-----|
| `python script.py` | [describe] |

## Local rules

- [Folder-specific rule]
- Inherit security and A–E protocol from root `AGENTS.md`
```

### 12.8 Template `UPGRADE_REPORT.md` (SDD upgrade)

Save in `openspec/changes/upgrade-sdd-<version>/UPGRADE_REPORT.md` **before** editing curated files.

```markdown
# SDD upgrade report

| Field | Value |
|-------|--------|
| Repository | [name/path] |
| Profile | APP / DOCS_SPECS / HYBRID |
| Guide version (before) | vX.Y.Z or unknown |
| Guide version (target) | vA.B.C |
| Date | YYYY-MM-DD |
| Branch | chore/upgrade-sdd-vA.B.C |

## Tool versions

| Tool | Before | After |
|------------|-------|--------|
| OpenSpec | | |
| GitNexus | | |
| Graphify | | |

## Executive summary

- [ ] Upgrade approved by user
- Applicable guide breaking changes: [yes/no — list]

## File matrix

| File | Exists | Lines (before) | Classification | Proposed action | Approved |
|----------|--------|----------------|---------------|----------------|----------|
| AGENTS.md | yes/no | | MERGE | Sync 12.2; keep Commands | [ ] |
| openspec/project.md | | | MERGE | Update Cross-references; keep Purpose/Stack | [ ] |
| CLAUDE.md | | | MERGE | Template §10.3 | [ ] |
| .cursor/rules/000-base.mdc | | | APPLY/MERGE | | [ ] |
| .cursor/rules/050-security.mdc | | | APPLY/MERGE | | [ ] |
| .cursor/rules/010-typescript.mdc | | | SKIP/KEEP | | [ ] |
| .cursor/rules/020-python.mdc | | | SKIP/KEEP | | [ ] |
| .cursor/rules/030-supabase.mdc | | | SKIP/KEEP | | [ ] |
| .cursor/rules/graphify.mdc | | | MERGE/KEEP | | [ ] |

Classifications: `KEEP_LOCAL` · `MERGE` · `APPLY_TEMPLATE` · `NEW` · `SKIP`

## Relevant diffs (summary)

### AGENTS.md
- Sections only in local: …
- Sections only in template: …
- Conflicts: …

### openspec/project.md
- …

## Generated files (not curated)

| Path | Action |
|---------|--------|
| `.cursor/commands/opsx-*` | `openspec update` |
| `openspec/AGENTS.md` | regenerated — ignore for canonical |

## Post-upgrade

- [ ] §2.9.4 executed
- [ ] §2.9.7 checklist
- [ ] IDE restarted
- [ ] `/opsx:propose` tested
```

### 12.9 Diff script (`scripts/sdd-upgrade-diff.sh`)

> **v1.3.0:** Canonical template source = `sdd-kit/templates/`. The script reads the file list from `sdd-kit/MANIFEST.yaml` when present.

Inventories curated files and, with a staging directory, shows `diff -u`:

```bash
# Inventory only (reads MANIFEST.yaml)
./scripts/sdd-upgrade-diff.sh

# Diff against kit templates (recommended)
./scripts/sdd-upgrade-diff.sh sdd-kit/templates/

# Local staging for review
./scripts/sdd-upgrade-diff.sh openspec/changes/upgrade-sdd-v1.3.0/sdd-staging/
```

Kit structure (`sdd-kit/templates/` mirrors repo paths):

```
sdd-kit/templates/
├── AGENTS.core.md
├── AGENTS.commands.APP.md
├── AGENTS.commands.DOCS_SPECS.md
├── CLAUDE.md
├── scripts/
├── openspec/infra.md
└── .cursor/rules/
```

**Do not** extract scripts from this guide's markdown — copy from `sdd-kit/templates/` or run `sdd-kit/install.sh`.

### 12.10 Template `openspec/changes/<id>/tasks.md` (patterns and gates)

Atomic tasks with structured sub-bullets. **Decisions** live in `design.md` (§12.3); **verifiable steps** live here.

#### 3-level anchoring model

| Level | When to use | Format |
|-------|-------------|---------|
| **1 — Pointer** (default) | Clear implementation already exists in the repo | `Pattern: relative/path.ext` |
| **2 — Skeleton** | Non-obvious pattern | ≤15 lines (interface + 1 test) + pointer |
| **3 — Boilerplate** | SQL migration, Zod base, hook template | Full snippet + `boilerplate-only` tag |

**Rule:** snippets longer than 15 lines **do not** stay in `tasks.md` — move to skill (`.cursor/skills/` / `.claude/skills/`) or reference an archived change.

#### Task format (checkbox + sub-bullets)

```markdown
## 2. Implementation

- [ ] 2.3 Create `SubscriptionRepository`
  - **Pattern:** `src/infra/stripe/customer.repo.ts`
  - **Invariants:** R-BILL-003 (`openspec/specs/billing/spec.md`)
  - **Gate:** `npm test -- subscription.repo`
  - **Forbidden:** create `BaseRepository` (already exists in `src/core/`)

- [ ] 2.4 Update guide §12.10
  - **Pattern:** `doc/byebyevibe-guide.md` §12.3
  - **Gate:** `grep -q '12.10' doc/byebyevibe-guide.md`
```

| Sub-bullet | Mandatory | Notes |
|------------|-------------|-------|
| **Pattern** | Recommended for code; optional for docs | Path **relative to the current repo** |
| **Gate** | **Yes** on any verifiable task | Shell command; exit 0 = done |
| **Invariants** | If spec applies | OpenSpec requirement ID |
| **Forbidden** | Optional | Anti-patterns (R4) |
| **Skill** | Cross-repo or long pattern | See below |

#### DOCS_SPECS profile — repo boundary (normative rule)

In **DOCS_SPECS** repositories (no app at root — §2.5.2):

1. **`Pattern:`** must point **only** to files **in this repo** (`doc/`, `scripts/`, `openspec/`, etc.).
2. **APP code implementation** (Next.js, `src/`, APIs) → **OpenSpec change in the APP repo**, not APP code tasks in this specs hub.
3. **Specs here, code there:** this repo defines *what* (`openspec/specs/`); the APP repo implements *how* with local GitNexus.
4. `scripts/verify-task-patterns.sh` fails if it detects `Pattern: repo:path` in DOCS_SPECS profile.

Example **valid** (DOCS_SPECS):

```markdown
- [ ] 1.2 Improve `enrich-transcripts.py`
  - **Pattern:** `doc/curso/scripts/extract-lessons-batch.py`
  - **Gate:** `python -m py_compile doc/curso/scripts/enrich-transcripts.py`
```

Example **invalid** (DOCS_SPECS — move change to APP repo):

```markdown
- [ ] 2.1 Create `SubscriptionRepository`
  - **Pattern:** `multi-agent-bot:src/infra/stripe/customer.repo.ts`  ← FORBIDDEN in this profile
```

#### Cross-repo patterns — use Skills (not tasks)

When the canonical pattern lives in another repository or is too long for a single task:

1. Create or update skill: `.cursor/skills/<domain>-pattern/SKILL.md`
2. In the task, reference: `- **Skill:** supabase-repo-pattern`
3. In the skill: describe structure + canonical path in the APP repo (text, not mass copy-paste)
4. After a successful change archive: consider **promoting** a stable pattern to a skill (archive checklist)

```markdown
- [ ] 3.1 Implement Stripe gateway in APP repo
  - **Skill:** stripe-billing-pattern
  - **Gate:** _(run in APP repo)_ `npm test -- billing.gateway`
```

> DOCS_SPECS hub can hold the **spec** and **design**; the **APP code task** lives in the APP repo change with a shared skill or local GitNexus pointer.

#### Verification

```bash
bash scripts/verify-task-patterns.sh   # Pattern: paths exist; DOCS_SPECS without repo:path
```

---

## 13. Workshop alignment ↔ agents.md

| Topic (Workshop IA 5/2026, Lesson 01) | Where in guide |
|-----------------------------------|--------------|
| [agents.md](https://agents.md/) as standard | §2.5, 12.2 |
| Short `AGENTS.md`; on-demand loading | §2.5.3, 12.2 |
| Do not ask AI to generate `AGENTS.md` | §2.5.1 |
| Real examples > abstract rules | §7, §11 |
| Context rot; new window per task | §3, §7 |
| Lazy skills vs static rules | §4.2, §8.1 |
| Legacy: AS-IS before instrumenting | §2.5.3, §2.0 prompt |
| `CLAUDE.md` points to `AGENTS.md` | §10.3 |

---

## Guide changelog

### 1.11.0 (2026-08-05)

- **Release-readiness gate (change `add-release-readiness-gate`, issue #348)** — version-sync, kit-integrity (template checksum parity), and hub scripts↔templates parity are extracted from `sdd-kit/verify.sh` into a standalone `scripts/verify-release-readiness.sh` with its own exit code. `.github/workflows/sdd-gates.yml` (hub + kit template) gains a new `Release readiness (blocking)` step that runs this script directly, with no `continue-on-error` — a version-sync mismatch or a stale template checksum now reliably fails the PR check instead of riding along inside the report-only `sdd-kit verify` step. `sdd-kit/verify.sh` calls the extracted script in place of the inlined logic; its own console output and exit-code contribution for these checks are unchanged. `verify-infra.sh`'s CLI-presence checks (GitNexus/Graphify) remain untouched and report-only — the new step never invokes them and cannot inherit their environment-dependent false positives. §2.12's step table documents the new step alongside the existing four.
- `[MANUAL ACTION REQUIRED]` — merging this change does **not** by itself block anything: the new step only actually gates merges once an operator adds `Release readiness (blocking)` (part of the `SDD Gates` check) as a required status check under GitHub Settings → Branches, the same follow-up already pending for the original gate.
- **`sdd-kit/`** — new tracked template `scripts/verify-release-readiness.sh`; `.github/workflows/sdd-gates.yml` template gains the new step; MANIFEST **1.10.0 → 1.11.0** (checksums regenerated for both).

### 1.10.0 (2026-08-05)

- **Version-sync gate (change `sync-sdd-kit-readme`)** — `sdd-kit/verify.sh` gains a fail-closed `version sync` block that compares each version string declared in prose against its authority field in `sdd-kit/MANIFEST.yaml`: the `sdd-kit/README.md` H1 against `version:`, and both guide header claims (the `Canonical install guide (vX.Y.Z)` blockquote and the `**Guide version:**` line) against `guide_version:`. Each comparison is independent; a mismatch prints a `FAIL` naming the file, the declared value and the authority value, and reddens `bash sdd-kit/verify.sh`. Degradation per file: absent file → INFO skip; claim line missing or token unparseable → WARN, exit code unchanged — so consumer repos (which receive neither the kit README nor the guide) are unaffected. Enforcement is fail-closed locally; in CI it surfaces through the existing `continue-on-error: true` verify.sh step (advisory, by operator decision).
- **`sdd-kit/README.md` currency pass** — H1 corrected from the stale `v1.6.1`; `APP/HYBRID` Probity references reduced to `APP` (they contradicted the file's own deprecation line); the dead "planned for v1.5.0" promise replaced with the current factual status; Structure block gains `gen-manifest-checksums.sh` and names `.claude/`/`.cursor/` in the `templates/` mirror; new section documents the skills and the `/opsx:help` command the kit installs automatically (vs. the manually installed review skills); CI-gate section names OSV-Scanner and `renovate.json`; Quick commands gain the hub→destination `bootstrap-sdd.sh` form and the report-only conditions of `verify-infra.sh` (1.8.2 `--write`) and `verify-task-patterns.sh` (1.9.0 profile-aware).
- **Root README congruence** — first `sdd-kit/` mention is now a link to the folder; `HYBRID` dropped from the profiles line and the Probity module row; Docs-table language cell for `sdd-kit/README.md` corrected to `EN`.
- **`sdd-kit/`** — MANIFEST **1.9.0 → 1.10.0** (`version` and `guide_version`); no template content changed, so checksums are unchanged and a C2 upgrade delivers no file diff.

### 1.9.0 (2026-08-05)

- **Simplify install profiles (change `simplify-install-profiles`)** — `scripts/verify-task-patterns.sh` now ships to **all** profiles (MANIFEST `profiles: [APP, DOCS_SPECS, HYBRID]`); it gains profile-aware exit semantics — fail-closed in DOCS_SPECS (unchanged), **report-only** in APP/UNKNOWN (broken local `Pattern:` paths print WARN, exit 0, summary names the mode) — so the C2 upgrade cannot redden existing APP consumers' CI. Profile detection hardened: `openspec/project.md` marker → AGENTS.md `12.2b`/`12.2a` command-table markers → legacy string greps (pre-1.9.0) → UNKNOWN (report-only). `sdd-gates.yml`'s task-patterns SKIP message no longer names DOCS_SPECS/HYBRID as the only profiles.
- **`HYBRID` retired as a deprecated alias of APP** — `install.sh`, `upgrade.sh`, and `bootstrap-sdd.sh` still accept `--profile HYBRID`, print a one-line deprecation notice, and proceed as APP; invalid values still abort. The bootstrap ambiguous-HYBRID warning and the preflight HYBRID hint are removed — `package.json` + `openspec/` coexistence is the normal post-install state of every APP repo and no longer produces a profile-hint WARN.
- **§1.6 profile block rewritten** around the lay question "Will this repository hold application code?" (yes → APP; no, docs/specs only → DOCS_SPECS), with three mandatory statements: every profile installs the complete framework; the hub's `doc/`/`openspec/` content is ByeByeVibe's own development history and is never copied to target projects; the profile question is independent of the language axes. `sdd-kit/README.md`'s profiles table reduced to APP/DOCS_SPECS + a deprecation line linking to §1.6. `install.sh` usage/help and the §2.0 AI-assisted install prompt gain the same lay-language decision copy (en + pt-BR).
- **`sdd-kit/`** — templates mirrored (`bootstrap-sdd.sh`, `preflight-sdd.sh`, `verify-task-patterns.sh`, `.github/workflows/sdd-gates.yml`), checksums regenerated; MANIFEST **1.8.2 → 1.9.0**.

### 1.8.2 (2026-08-05)

- **verify-infra in ephemeral environments (change `fix-verify-infra-ephemeral-env`)** — `scripts/verify-infra.sh` now gates manifest writes on interactivity: `openspec/infra.md` markers are updated only when stdout is a TTY or the new `--write` flag is passed (operator cron/scripted runs, bootstrap post-install). Non-interactive runs without `--write` (CI runners, remote agent sandboxes) are **report-only**: findings printed with a notice naming `--write`, file left byte-identical, exit 0 (advisory — the posture CI already imposed externally via its restore step). OpenSpec/GitNexus presence checks switch from bare `npx` (registry fall-through; resolves to the abandoned `openspec@0.0.0`, triggers `gitnexus` downloads) to `PATH` lookup (`command -v`), matching the Graphify check; detail (`openspec --version`, `gitnexus status` index freshness) is collected by direct invocation only when the binary is present. "Verify with" column for the OpenSpec/GitNexus rows in `openspec/infra.md` (live + template) updated from `npx …` to direct invocations (`openspec list`, `gitnexus status`) to match what the check now measures.
- **`sdd-kit/`** — templates `scripts/verify-infra.sh` and `openspec/infra.md` mirrored; MANIFEST **1.8.1 → 1.8.2** (checksums regenerated for the two changed templates).

### 1.8.1 (2026-08-05)

- **Lightweight install-fetch (change `add-lightweight-install-fetch`)** — §1.6 gains the **minimal install-fetch footprint** statement (`sdd-kit/` + `scripts/bootstrap-sdd.sh` + `scripts/preflight-sdd.sh`; no other hub path is read by `install.sh`/bootstrap/preflight during C1) and a **lightweight fetch recipe** (partial clone + non-cone `sparse-checkout`, no full hub clone) scoped to genuine C1 greenfield installs only. §2.0 AI-assisted install prompt now names the lightweight fetch as the default acquisition method, reserving a full hub clone for the persistent multi-project hub→destination workflow. `sdd-kit/README.md` gains a one-line pointer (no duplication). No script changes — `install.sh`/`bootstrap-sdd.sh`/`preflight-sdd.sh` already resolve correctly against the minimal footprint.
- **`sdd-kit/`** — no template content changed; MANIFEST **1.8.0 → 1.8.1** (docs-only release, checksums unchanged).

### 1.8.0 (2026-08-03)

- **Install scope UX (change `clarify-install-scope-ux`)** — §1.6 gains the canonical **install-scope table** (machine-once / repo-copied / repo-generated) and the **hub → destination** one-command flow (`bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>`); other surfaces summarize and link, never duplicate.
- **`scripts/bootstrap-sdd.sh`** — hub-mode resolution (preflight and `sdd-kit/install.sh --repo <target>` fall back to the script's own source repo when the target lacks them; target-local copies win); idempotent guard on package-manager installs (`command -v` skip notices with detected version; `min_openspec` staleness WARN pointing to C2b); third `Scope:` banner line per tool (en + pt-BR); didactic completion message (per-project state locations + next-project command) after the unconditional manual-steps block.
- **`scripts/preflight-sdd.sh`** — new `--kit-root <path>` flag: hub-resolved `sdd-kit/` satisfies the repo gate for greenfield targets; the gate still FAILs when neither target nor source carries a kit.
- **`sdd-kit/README.md`** — scenarios table gains a **Scope** column (C1 = machine + repo; C2b = machine; C2/C3/C1-UI/G2/G4 = repo) + one-line first-contact scope note linking to §1.6.
- **`doc/sdd-operator-day1.md`** — §0 gains the machine-once vs per-project scope passage (no section renumbering; `/opsx:help` skill untouched).
- **`sdd-kit/`** — templates mirrored (`bootstrap-sdd.sh`, `preflight-sdd.sh`, `sdd-operator-day1.md`), checksums regenerated; MANIFEST **1.7.0 → 1.8.0**. Also fixes the pre-existing guide header 1.6.1 vs MANIFEST 1.7.0 mismatch.

### 1.7.0 (2026-08-01)

- **Rename-only release** — Guide file renamed to `doc/byebyevibe-guide.md` from the legacy author-named path (project-named per EN docs policy; change `rename-guide-file`). Redirect stub kept at the old path; archives and pre-rename spec requirements cite the old name — both refer to this document. Content unchanged beyond path self-references.
- **`sdd-kit/`** — All live references and template mirrors updated to the new path; MANIFEST **1.6.1 → 1.7.0**.

### 1.6.1 (2026-07-26)

- **Cadence + playbook (G4 extension)** — §2.17: "Interpret → act" (M1–M4 → 1 insight → 1 adjustment); thresholds N=5 archives / T=30 days; stamp `.sdd/metrics-last-run`; flag `--check-cadence`; advisory nudge in `/opsx:archive` Session Handoff (change `add-sdd-metrics-cadence-nudge`).
- **`sdd-kit/`** — `sdd-metrics.sh` script/template updated; MANIFEST **1.6.0 → 1.6.1**.
- **Discovery / first contact** — §2.0b vibe coder quickstart → root `README.md` (**ByeByeVibe**) + `install.sh --dry-run`; evaluation `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (change `add-sdd-discovery-positioning`; public rename `rename-byebyevibe-public-name`). No MANIFEST bump (docs only).

### 1.6.0 (2026-07-26)

- **SDD Metrics (G4)** — Local on-demand script `scripts/sdd-metrics.sh` (mode C): volume, lead time propose→archive, post-archive rework; **no** Apache DevLake (change `add-sdd-metrics-script`).
- **§2.17** — Human operation of metrics: when to run, reading M1–M4, proxies, troubleshooting, rollback.
- **`sdd-kit/`** — Template `scripts/sdd-metrics.sh`; MANIFEST **1.5.0 → 1.6.0**.
- **Probity (G2)** — Optional APP/HYBRID module `@nizos/probity@1.10.0` with `enforceTdd` (change `add-probity-tdd-module`). TDD Guard superseded by Probity (2026-07).
- **§2.16** — Human operation Probity: install plugin, pilot, Cursor hooks, disable, troubleshooting, rollback.
- **`sdd-kit/`** — `install-probity-module.sh`, template `probity.config.ts`, `doc/design/004-probity-module-install.md`.
- **Supply chain (G8)** — OSV-Scanner blocking in `sdd-gates.yml` (when lockfile present) + conservative `renovate.json` template for APP/HYBRID profiles (change `add-supply-chain-gates`).
- **§2.13** — Human operation supply chain: OSV in Actions, install Renovate app, preset, patch automerge (opt-in), troubleshooting, rollback.
- **Renumbered** — §2.13 correctness-review → §2.14; §2.14 github-mcp → §2.15; Probity → §2.16.
- **`sdd-kit/`** — `templates/renovate.json`; OSV in `templates/.github/workflows/sdd-gates.yml`.

### 1.5.0 (2026-07-26)

- **GitHub Issues MCP (G5)** — `github-mcp-server` as passive MCP (mode D) + `**Issue:**` field in `proposal.md` template for issue → change → PR traceability (change `add-github-mcp-issue-traceability`).
- **§2.15** — Human operation of github-mcp: install (remote OAuth endpoint + local binary), minimum scope `--toolsets issues`, A–E matrix, troubleshooting, rollback.
- **`sdd-kit/`** — Template `openspec/changes/_template/proposal.md`; MANIFEST 1.4.0 → 1.5.0.

### 1.4.0 (2026-07-25)

- **CI Gates (G1)** — `.github/workflows/sdd-gates.yml`: fail-closed SDD gate enforcement on `push`/`pull_request` (`openspec validate --all --strict` blocking; `verify-task-patterns.sh` blocking; `sdd-kit/verify.sh` report-only). Orchestrates existing commands only — zero new dependency (change `add-sdd-ci-gates-workflow`).
- **§2.12** — Human operation of CI gates: reading output, unblocking merge, troubleshooting, `[MANUAL ACTION]` branch protection.
- **`sdd-kit/`** — Template `templates/.github/workflows/sdd-gates.yml` (COPY, APP/DOCS_SPECS/HYBRID profiles); workflow check in `verify.sh`; MANIFEST 1.3.2 → 1.4.0.

### 1.3.2 (2026-07-06)

- **`scripts/bootstrap-sdd.sh`** — GitNexus is now optional: install/setup/analyze failure no longer aborts bootstrap (Graphify + `sdd-kit/install.sh` continue). Also fixed CRLF line endings that broke bash parsing.
- **`scripts/sdd-session-check.sh`** — Removed redundant `flock -n` probe that collided with the session holder itself (register runs before check, rule `016`); conflict detection still via session-file scan. Fixed gap where a session with expired heartbeat but live PID (long operation without heartbeat) was not detected as conflict — now only provably stale sessions (old heartbeat **and** dead PID) are ignored.
- **`sdd-kit/templates/AGENTS.core.md`** — Removed duplicate lines (UI Module / Design pipeline) in "On-demand context" table.

### 1.3.1 (2026-06-27)

- **C1-UI** — Optional post-C1 UI development module: `sdd-kit/install-ui-module.sh`, `doc/design/002-*`, `003-*`.
- **§2.11 / §2.11.1** — UI module procedure and checklist (pointers, no pipeline duplication).
- **§5.6** — Cross-reference table to UI module.
- **§1.6** — C1-UI scenario in install table.
- **`doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`** — Aggregate evaluation Impeccable + OD + Pencil (**Adopted**).

### 1.3.0 (2026-06-17)

- **`sdd-kit/`** — Versioned install kit: `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `templates/`.
- **§1.6** — Four-layer organization; scenarios C1 / C2 / C2b / C3; APP / DOCS_SPECS / HYBRID profiles; hub vs consumer.
- **§2.0 / §2.9.5** — Install and upgrade use `sdd-kit/templates/` instead of extracting markdown §12.
- **§12.6 / §12.9** — Full scripts deprecated in guide; pointer to `sdd-kit/templates/`.
- **`scripts/sdd-upgrade-diff.sh`** — Inventory reads paths from `sdd-kit/MANIFEST.yaml`.
- **Session coordination** — Changelog entry; rules `015`/`016` and `sdd-session-*` scripts in MANIFEST.
- **`openspec/infra.md`** — Install Kit section.

### 1.2.1 (2026-06-16)

- **§12.10** — `tasks.md` template with Pattern, Gate, 3-level model, DOCS_SPECS rule (specs here, APP code in APP repo), cross-repo patterns via Skills.
- **§5.2 / §7.2** — Cross-references to enriched tasks.
- **`scripts/verify-task-patterns.sh`** — validation of paths in `Pattern:`.

### 1.2.0 (2026-06-15)

- **§2.9** — Upgrade of existing install (detection, AI prompt, tools, merge, checklist).
- **§2.9.5** — Curated files vs templates comparison matrix (KEEP_LOCAL / MERGE / APPLY_TEMPLATE / NEW / SKIP).
- **§12.8** — `UPGRADE_REPORT.md` template for human approval before editing files.
- **§12.9** + `scripts/sdd-upgrade-diff.sh` — inventory and diff against staging.
- "How to use" table distinguishes install vs upgrade (human and agent).

### 1.1.0 (2026-05-25)

- Guide explicitly as reusable **install artifact** (human + AI).
- §2.0 assisted install prompt; §2.8 verification checklist.
- Target `AGENTS.md` format: Commands, on-demand, summarized integrations (agents.md).
- §2.5.1 anti-patterns; §2.5.2 APP / DOCS_SPECS / HYBRID profiles.
- Templates 12.2a / 12.2b / 12.7; `graphify update` instead of `graphify .`.
- `openspec init --tools`; bootstrap updated.

### 1.0.0 (2026-05)

- Initial version: OpenSpec + GitNexus + Graphify, Cursor, Claude Code.

---

## Appendix — Final technical disclaimer

This system combines three fast-evolving open source projects. Basic commands (`openspec init`, `gitnexus analyze`, `graphify .`) are stable. Exotic flags, exact subagent format, and hook details may change in monthly releases. Before automating critical production processes:

1. Confirm versions with `<tool> --version`
2. Read the CHANGELOG of the latest release
3. Test on a separate branch before PR

If something fails during configuration, the usual debug order is:
1. `gitnexus status` and `claude mcp list` — are MCPs registered?
2. `cat ~/.cursor/mcp.json` — correct syntax?
3. Restart Cursor/VS Code after any configuration change (skills load at session startup).
4. Logs: `.claude/logs/` if logging hooks are configured.

---

*Guide v1.2.0 — June 2026. Reference tools: OpenSpec 1.3.1+, GitNexus 1.6+, Graphify 0.8.5+, Claude Code 2.1.140+, Cursor `.mdc`, VS Code 1.109+. Confirm with `--version` before automating.*
