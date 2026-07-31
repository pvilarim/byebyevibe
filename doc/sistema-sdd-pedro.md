# AI-Assisted Development System

**GitNexus + Graphify + OpenSpec, integrated in Cursor and VS Code + Claude Code**

> **Canonical install guide (v1.6.1)** — use in any Git repository, manually or via an AI agent. Payloads in `sdd-kit/`; procedure in this document.

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
- **Guide version:** 1.6.1 — see [Guide changelog](#changelog-do-guia).
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
| **Procedure** | `doc/sistema-sdd-pedro.md` | How to install/upgrade; scenarios C1–C3 |
| **Versioned payload** | `sdd-kit/templates/` + `MANIFEST.yaml` | Copyable files, shell gates |
| **Normative requirements** | `openspec/specs/sdd-*` | What MUST exist after install |
| **Workspace state** | `openspec/infra.md`, `project.md` | What is ✅ in this repo |

#### Install scenarios

| Code | Situation | Entry command |
|--------|----------|-------------------|
| **C1** | Greenfield install (first-time SDD) | `bootstrap-sdd.sh` → `bash sdd-kit/install.sh --profile APP\|DOCS_SPECS\|HYBRID` |
| **C2** | SDD upgrade (new guide/kit version) | `bash sdd-kit/upgrade.sh --from X --to Y --dry-run` → approval → `--apply` |
| **C2b** | Outdated CLIs only | §2.9.4 — **without** touching curated kit |
| **C3** | Domain spec propagation | Reference in `openspec/specs/<domain>/` — **do not** run `install.sh` |
| **C1-UI** | Optional UI module (post-C1) | `bash sdd-kit/install-ui-module.sh --detect` → `--apply [--yes]` — see §2.11 |

**Golden rule:** C3 (product normative content) ≠ C2 (SDD infra). Publishing a billing spec in the hub **does not** require reinstall in APP repos.

#### Repository profiles

| Profile | What changes in `install.sh` |
|--------|---------------------------|
| **APP** | Commands §12.2a; rules TS/Supabase |
| **DOCS_SPECS** | Commands §12.2b; `verify-task-patterns.sh` |
| **HYBRID** | APP commands + optional rules |

#### Hub vs consumer

- **Hub (e.g. spec-pedro, DOCS_SPECS):** commit the full `sdd-kit/` to distribute C2 upgrades.
- **APP consumer:** may keep only expanded files (`scripts/`, `.cursor/rules/`); copy `sdd-kit/` on upgrade as needed.

Exact commands: `sdd-kit/README.md`.

---

## 2. Installation step by step (question 1)

### 2.0b First contact / vibe coder (quickstart)

Coming from *vibe coding* and want the minimum path **without** reading the entire guide?

1. Read the hero and demo in [`README.md`](../README.md) at the hub root (EN) — public brand **ByeByeVibe**; positioning “from vibe coding to shippable AI engineering”; **not** an app boilerplate (payload remains in `sdd-kit/`).
2. Preview what the kit would install (without writing files):

```bash
bash sdd-kit/install.sh --profile DOCS_SPECS --dry-run
# or, in an application repo: --profile APP
```

3. If it makes sense, follow the full install: §2.1 → CLIs → `install.sh` (without `--dry-run`) → checklist §2.8.
4. Friendly map C1/C2/C3/G*: [`sdd-kit/README.md`](../sdd-kit/README.md). Market analysis / backlog: [`doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`](../doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md).

This block **does not** replace procedure §2.1–§2.8 — it only reduces friction on first contact.

### 2.1 Order matters

Install in this specific order. **Do not reverse** — each step assumes the previous one is done:

```
1. OpenSpec    → 2. GitNexus    → 3. Graphify    → 3b. sdd-kit/install.sh    → 4. Curate AGENTS.md    → 5. Configure IDEs
```

Why: OpenSpec generates the `openspec/` skeleton, GitNexus indexes code and creates the initial `AGENTS.md`, Graphify adds non-code context. If you reverse the order, later tools may overwrite files created earlier.

### 2.0 AI-assisted installation (prompt)

Paste this prompt at the target repository root (replace `REPO_ROOT` and the profile):

```
Install the SDD system (OpenSpec + GitNexus + Graphify) in this repository following
strictly the guide in doc/sistema-sdd-pedro.md v1.4.0 and the install kit in sdd-kit/.

Repository profile: [APP | DOCS_SPECS | HYBRID]

Order:
1. bash scripts/bootstrap-sdd.sh  (or manual CLIs §2.2–2.4)
2. bash sdd-kit/install.sh --profile <PROFILE> [--dry-run first]
3. Edit openspec/project.md (Purpose, Stack — do NOT replace with template)
4. Merge AGENTS.md if it already existed (templates: sdd-kit/templates/AGENTS.core.md + commands)
5. bash sdd-kit/verify.sh + checklist §2.8

Do NOT extract scripts from markdown §12 — use sdd-kit/templates/.
Do NOT paste full <!-- gitnexus:start --> blocks into AGENTS.md.

Deliver: checklist §2.8 + output of sdd-kit/verify.sh.
```

### 2.2 Step 1 — OpenSpec (intent)

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
| Full SDD guide (installation) | `doc/sistema-sdd-pedro.md` |
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

### 2.8 Post-installation verification (checklist)

Use after every installation (human or AI):

- [ ] `openspec/project.md` edited with Purpose, Stack, Cross-references
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
| sdd-kit verify | `bash sdd-kit/verify.sh` | Report-only (`continue-on-error`) — includes `verify-infra.sh`, which checks for knowledge CLIs missing on the runner |

**How to read the output:** in the Actions tab (or PR check), the red step indicates which gate failed. `OpenSpec validate` lists `✗ change/<id>` — reproduce locally with `npx openspec validate <id> --strict` and fix the artifact. `Task patterns` lists `FAIL missing: <path>` — fix the `Pattern:` in `tasks.md`. The `sdd-kit verify` step may show a warning without blocking (expected: GitNexus/Graphify are not on the runner).

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
grep -E 'sistema-sdd-pedro\.md|Guia de instalação SDD' openspec/project.md || true

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
| Guide version in repo | `openspec/project.md` → Cross-references (`doc/sistema-sdd-pedro.md` **vX.Y.Z**) |
| Target version | Header of this document or changelog §14 |
| Profile | APP / DOCS_SPECS / HYBRID (§2.5.2) — infer from `package.json`, Commands in `AGENTS.md` |

If `openspec/project.md` does not reference guide version, assume **unknown** and treat merge as **conservative** (keep local text; only add new sections from template).

#### 2.9.3 AI-assisted upgrade (prompt)

Paste at target repo root (replace `TARGET_VERSION` and confirm guide path):

```
Upgrade the existing SDD installation in this repository to guide
doc/sistema-sdd-pedro.md TARGET_VERSION (e.g. v1.2.0).

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

## 5. Documentos e referências cruzadas (questão 3.2)

### 5.1 Hierarquia de documentos

Há quatro níveis. Cada um aponta para o seguinte. **As referências cruzadas são o que faz o sistema funcionar como um todo.**

```
Nível 1 — Constitution (raramente muda)
├── AGENTS.md                        ← entry point universal
├── openspec/project.md              ← stack + convenções + decisões
└── CLAUDE.md                        ← apenas referencia AGENTS.md
└── .cursor/rules/000-base.mdc       ← apenas referencia AGENTS.md

Nível 2 — Specs vigentes (muda com cada feature)
└── openspec/specs/<capability>/spec.md

Nível 3 — Mudanças em curso (efémero, vira spec quando archive)
└── openspec/changes/<change-id>/
    ├── proposal.md
    ├── design.md
    ├── tasks.md
    └── specs/

Nível 4 — Conhecimento (regenerável, mas referenciado)
├── graphify-out/GRAPH_REPORT.md     ← linkado de AGENTS.md
├── graphify-out/graph.json          ← consumido via MCP
└── .gitnexus/lbug                   ← consumido via MCP
```

### 5.2 Referências cruzadas obrigatórias

Cada ficheiro deve referenciar explicitamente os outros relevantes. Sem isto, o agente não sabe que existem.

**`AGENTS.md` deve conter** (templates completos em 12.2a / 12.2b):

- Secções obrigatórias: Contexto (aponta `project.md`), **Commands**, Fontes 1–7, **Contexto sob demanda**, Protocolo A–E, R1–R9, Workflow, **Integrações** (resumo), Segurança.
- Ver §2.5 e anti-padrões §2.5.1.

```markdown
## Fontes de conhecimento (por prioridade)

1. `./openspec/specs/` — requisitos actuais
2. `./openspec/changes/` — propostas e arquivo
3. `./graphify-out/GRAPH_REPORT.md` — knowledge graph
4. GitNexus via MCP — estrutura de código, impact
5. Graphify via MCP ou CLI `graphify query` — conceitos
6. Docs externos citados em `openspec/project.md`
7. Web search (último recurso)

## Contexto sob demanda

Ver tabela em §2.5.3 do guia de instalação (adaptar paths).
```

**`openspec/project.md` deve conter**:

```markdown
## Cross-references

- Code structure is indexed in `.gitnexus/` — use GitNexus MCP tools to navigate
- Knowledge base (theory, docs, vault) is in `graphify-out/` — see GRAPH_REPORT.md
- Active changes are in `openspec/changes/` — always check before starting new work
```

**`openspec/changes/<id>/design.md` deve, sempre que aplicável, citar**:

```markdown
## Knowledge sources consulted

- Graphify: <conceito1> → <conceito2> via shortest_path (graph.json:node:xyz)
- GitNexus: impact analysis on AuthService showed 12 downstream dependents
- Previous spec: openspec/specs/auth-session/spec.md
- Previous archived change: openspec/changes/archive/2026-03-15-add-jwt/
```

**`openspec/changes/<id>/tasks.md` deve seguir** o template **§12.10** (pattern pointers, gates). Decisões e alternativas ficam em `design.md` (§12.3) — não duplicar rationale nas tasks.

### 5.3 O que NÃO duplicar

Não copies stack ou convenções do `project.md` para o `AGENTS.md`. Aponta. A duplicação é a origem de drift — daqui a três meses tens duas versões da mesma regra em desacordo.

### 5.4 Quando regenerar referências

| Evento | Acção |
|---|---|
| Mudaste muito código | `gitnexus analyze` |
| Adicionaste docs/papers ao vault | `graphify . --update` |
| Acabaste uma feature | `/opsx:archive` (actualiza specs) |
| Onboarding novo dev/agente | Apenas garantir que abre o repo, AGENTS.md carrega tudo |
| Hook automático | `graphify hook install` faz rebuild em cada commit |

### 5.5 Avaliações de integração e aperfeiçoamento

Registo histórico de ferramentas e ideias **pesquisadas** para evoluir o stack SDD — adoptadas ou descartadas.

| Artefacto | Papel |
|-----------|--------|
| `doc/avaliacoes/README.md` | Índice e estados de decisão |
| `doc/avaliacoes/TEMPLATE.md` | Modelo para novas avaliações |
| `doc/avaliacoes/<data>-<slug>.md` | Avaliação individual |

**Regra:** candidatos descartados aqui **não** entram no `sdd-kit` sem nova proposta OpenSpec. Exemplo: [Headroom](https://github.com/chopratejas/headroom) — compressão de contexto — **descartado** em 2026-03-26 (`doc/avaliacoes/2026-03-26-headroom-context-compression.md`).

### 5.6 Referências cruzadas — módulo de desenvolvimento de UI

| Tema | Documento | Guia SDD |
|------|-----------|----------|
| Instalação C1-UI | `doc/design/002-ui-module-install.md` | §2.11 |
| Pipeline completa (shadcn default) | `doc/design/001-pipeline-open-design-shadcn-impeccable.md` | §2.11 passo 2 |
| Impeccable isolado | `doc/design/000-impeccable-design-system-guia.md` | §2.11 |
| Stacks sem shadcn | `doc/design/003-ui-stack-adapters.md` | §2.11 |
| Script add-on | `sdd-kit/install-ui-module.sh` | §2.11 passo 3 |
| Avaliação agregada | `doc/avaliacoes/2026-06-27-sdd-ui-development-module.md` | §5.5 |
| Spec normativa | `openspec/specs/sdd-ui-module/spec.md` | após archive |
| Estado workspace | `openspec/infra.md` — UI Development Module | §2.11.1 |

**Regra §5.3:** este guia **aponta** para `doc/design/*`; não copiar matrizes, prompts ou fluxos A–D do `001`.

---

## 6. Dimensão de research (questão 3.3)

### 6.1 Quanto research é apropriado por tipo de tarefa

| Tipo | Tempo de research | Output esperado | Sinal de excesso |
|---|---|---|---|
| **A** | 0 | nenhum | qualquer research |
| **B** | < 5 min | impact check do GitNexus (1 query) | leste mais de 3 ficheiros |
| **C** | 15-30 min | AS-IS document de 1 página | mais de 500 linhas de notes |
| **D** | 1-3 horas | `knowledge.md` (≤ 1 página) + `codebase.md` (≤ 1 página) | mais de 5 god-nodes referenciados, mais de 10 ficheiros lidos |
| **E** | 2-8 horas | `research.md` com recomendação clara, alternativas, e riscos | research sem conclusão acionável |

### 6.2 Anti-padrões de research

- **Boil-the-ocean**: ler tudo o que é tangencialmente relevante. *Solução*: definir 3 perguntas concretas antes de começar; parar quando respondidas.
- **Confirmation bias**: research conduzido para validar uma decisão já tomada. *Solução*: forçar listagem de pelo menos 2 alternativas, mesmo que descartadas.
- **Research-without-output**: 2 horas a ler, zero linhas escritas. *Solução*: começar a escrever `research.md` em 30 min mesmo com lacunas.

### 6.3 Hierarquia de fontes — confiabilidade decrescente

```
1. Specs vigentes (openspec/specs/)              ← Verdade do projecto
2. Specs arquivados (openspec/changes/archive/)  ← Verdade histórica decidida
3. Knowledge graph do teu vault (Graphify)       ← Verdade tua, curada
4. GitNexus (código actual)                      ← Verdade do que está running
5. Docs externos referenciados no project.md     ← Verdade de upstream
6. Web search                                    ← Suspeito até prova em contrário
7. Memória do LLM sem fonte                      ← Não fiável, sempre verificar
```

Regra: **uma afirmação no `research.md` ou `design.md` que não pode ser ancorada num dos níveis 1-5 deve ser flagged como `[ASSUMPTION]` para validação humana**.

### 6.4 Evitar fontes duvidosas

Para web search (quando inevitável, como Tipo E novo):

- Prefere domínios primários: docs oficiais, ArXiv, sites do projecto open-source, GitHub do projecto, RFC.
- Rejeita: SEO content farms (medium spam, generic tutorials sem autor identificável), respostas StackOverflow sem confirmação cruzada, posts > 2 anos para ferramentas em mudança rápida.
- Confirma cada claim em **pelo menos duas fontes independentes** se for usado para decisão arquitectural.
- Para papers: prefere versões publicadas em conferências peer-reviewed; preprints ArXiv precisam de leitura crítica.

Template para validar uma fonte antes de a adicionar ao Graphify:

```
- [ ] Autor identificado e credível no domínio?
- [ ] Data publicação < 2 anos (para tech rápida) ou clássico estabelecido?
- [ ] Conteúdo é primário (não citação de citação)?
- [ ] Pode ser validado experimentalmente neste projecto?
- [ ] Aceitar para Graphify? Sim/Não/Com nota de cautela
```

### 6.5 Anti-alucinação no research

- Graphify tagga cada edge como `EXTRACTED`, `INFERRED` ou `AMBIGUOUS` — usar isto. No `research.md`, ao citar uma relação, marcar de qual tipo veio.
- GitNexus retorna staleness — se index é antigo, reindexar antes de confiar no impact.
- LLM deve ser instruído (via AGENTS.md) a recusar afirmações sem fonte: "If you cannot point to a source in this repo's knowledge graph, write `[NEEDS VERIFICATION]` instead of guessing."

---

## 7. Protocolos por tarefa (questão 3.4)

### 7.1 Protocolos transversais (aplicam a todos os tipos)

**Token efficiency**
- `CLAUDE.md` ≤ 200 linhas. Detalhes vão para `@imported.md` files que são carregados sob demanda.
- Cursor rules: cada `.mdc` ≤ 500 linhas; total `alwaysApply: true` ≤ 2000 tokens.
- Usa subagents para exploração: o subagent vê o ruído, retorna apenas a síntese ao agente principal.
- Skills (`.claude/skills/<name>/SKILL.md`) carregam só a descrição; o corpo só é carregado quando invocado — usar isto para playbooks longos.

**Anti-alucinação**
- AGENTS.md tem cláusula: "If unsure, ASK before assuming. If the user provides an unfamiliar term, search the knowledge graph BEFORE answering."
- Para chamadas a APIs externas: o agente deve sempre verificar via GitNexus se a API/função existe no repo antes de a usar; se não existir, declarar `[ASSUMPTION]`.
- Para nomes de bibliotecas: verificar em `package.json`/`pyproject.toml` antes de assumir versão.

**Simplicidade**
- Princípio "smallest reasonable change" — qualquer task que toque > 5 ficheiros precisa de OpenSpec proposal.
- Recusar abstracções antecipadas. Se design.md propõe uma factory/adapter/wrapper "para flexibilidade futura", rejeitar e pedir caso concreto.

**Escalabilidade**
- Specs arquivados são fonte primária para próximas features — não re-explicar conceitos já decididos.
- Graphify hook automático em cada commit garante que o knowledge graph não fica stale.
- Convenções de nomenclatura consistentes facilitam queries futuras (ex: change-id sempre `verb-noun-modifier`).

**Segurança**
- Claude Code: hooks `PreToolUse` para bloquear `rm -rf`, `git push --force`, `sudo`, comandos a paths fora do repo. Template em 12.4.
- Permissões: `permissions.allow` enumera Bash safe; `permissions.deny` lista hard blocks. Nunca `Bash(*)` em allow.
- Segredos: NUNCA em `CLAUDE.md`, `AGENTS.md`, `project.md` ou qualquer ficheiro em git. Sempre em `.env` (gitignored) ou variáveis de ambiente.
- Graphify: por design, código local não sai da máquina (tree-sitter local); apenas docs/PDFs/imagens vão para o LLM via skill (a tua sessão IDE). Validar isto se trabalhares com IP sensível.
- GitNexus: 100% local.
- OpenSpec: 100% local (sem API keys).

**Auditoria**
- Todos os specs vivem no git — `git log openspec/specs/` mostra evolução de requisitos.
- Mensagens de commit referem o change-id: `feat(auth): implement add-jwt change`.
- `openspec/changes/archive/` mantém histórico de proposals, designs e tasks que levaram a cada feature — fonte primária para post-mortems.
- Hook PreToolUse pode loggar todas as tool calls para `.claude/logs/` (template em 12.4).
- GitNexus expõe `detect_changes()` para auditar drift entre código e o último index.

### 7.2 Protocolos específicos por tipo

**Tipo A — Trivial**
- Recusar se ambíguo. Pedir confirmação se a mudança parecer ter implicação.
- Não criar OpenSpec change.
- Commit directo. Mensagem: `chore: <descrição curta>`.

**Tipo B — Bug fix**
- Sempre `gitnexus impact <target>` antes de patch.
- Sempre adicionar teste que falha *antes* da fix.
- Verificar que o teste passa após.
- Commit: `fix(<scope>): <descrição> (closes #<issue> se houver)`.

**Tipo C — Refactor**
- OpenSpec proposal obrigatório.
- `design.md` deve incluir secção "Behavioral parity" — listar invariantes que devem permanecer iguais.
- `tasks.md` com **Pattern** (ficheiro AS-IS a espelhar) e **Gate** (comando determinístico) por task de código — ver §12.10.
- Testes existentes devem passar sem mudanças (excepto importação se ficheiros se moveram).
- Sem novo comportamento adicionado num refactor — caso contrário é Tipo D.

**Tipo D — Feature com base teórica**
- Dois research docs obrigatórios: `knowledge.md` e `codebase.md`.
- `design.md` cita explicitamente nodes do Graphify e impact do GitNexus.
- `tasks.md` com **Pattern** + **Gate** obrigatórios em tasks que tocam código — ver §12.10.
- Pelo menos uma alternativa rejeitada documentada.
- Testes para o caso teórico central, não só para o código.

**Tipo E — Exploração**
- Output é documento, não código. Recusar PRs de código directos a partir de Tipo E.
- `research.md` arquivado em `openspec/changes/explore-<topic>/` mesmo se não levar a implementação.
- Conclusão em formato "Recommendation: <action> because <reason>. Alternatives considered: <list>. Risks: <list>."

---

## 8. Regras gerais do sistema (questão 4)

### 8.1 Onde vivem as regras

**Princípio**: regras universais num único sítio canónico, com aliases para cada ferramenta.

```
AGENTS.md (raiz)                      ← FONTE DE VERDADE para regras universais
  ↑
  ├─ CLAUDE.md                        ← apenas: "Strictly follow ./AGENTS.md"
  ├─ .cursor/rules/000-base.mdc       ← apenas: "Strictly follow ./AGENTS.md"
  └─ openspec/AGENTS.md               ← gerado por OpenSpec, NÃO editar manualmente
                                        (contém apenas instruções sobre OpenSpec)

openspec/project.md                   ← FONTE DE VERDADE para stack + convenções
                                        do projecto específico

.cursor/rules/*.mdc                   ← regras com glob scoping
                                        (ex: regras específicas para *.tsx)

.claude/agents/*.md                   ← personas de subagents
.claude/skills/*/SKILL.md             ← playbooks invocáveis
.claude/hooks/*                       ← guardrails determinísticos
.claude/settings.json                 ← permissões
```

### 8.2 As nove regras universais (em AGENTS.md)

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

### 8.3 Hierarquia de precedência

Quando regras competem:

```
1. Hooks (PreToolUse)              ← Determinístico, não negociável
2. permissions.deny                ← Bloqueia mesmo se model "quer"
3. AGENTS.md universal rules       ← Aplicado a todos
4. openspec/project.md             ← Específico do projecto
5. .cursor/rules/*.mdc (glob match)← Específico de ficheiros/contexto
6. Slash commands (skills)         ← On-demand
7. User prompt                     ← Mais flexível
```

User prompt nunca anula um hook. Se um hook bloqueia, o user tem de reconfigurar o hook conscientemente, não bypass via prompt.

---

## 9. Configuração Cursor (questão 5)

### 9.1 Estrutura final de ficheiros

```
projecto/
├── AGENTS.md                                 ← curado, fonte de verdade
├── .cursor/
│   ├── rules/
│   │   ├── 000-base.mdc                      ← alwaysApply, aponta para AGENTS.md
│   │   ├── 010-typescript.mdc                ← auto-attach: globs: ["**/*.ts", "**/*.tsx"]
│   │   ├── 020-python.mdc                    ← auto-attach: globs: ["**/*.py"]
│   │   ├── 030-supabase.mdc                  ← auto-attach: globs: ["**/migrations/**", "**/db/**"]
│   │   ├── 040-n8n.mdc                       ← auto-attach: globs: ["**/n8n/**"]
│   │   └── 050-security.mdc                  ← alwaysApply, guardrails
│   ├── commands/                             ← gerados por OpenSpec, não editar
│   │   ├── opsx-propose.md
│   │   ├── opsx-apply.md
│   │   └── opsx-archive.md
│   ├── skills/                               ← gerados por GitNexus + Graphify
│   │   ├── gitnexus-exploring/
│   │   ├── gitnexus-impact/
│   │   └── graphify/
│   └── mcp.json                              ← gitnexus + (opcional) graphify
```

### 9.2 Regras a criar

**`.cursor/rules/000-base.mdc`** — sempre aplicada, redirecciona para AGENTS.md:

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

**`.cursor/rules/050-security.mdc`** — sempre aplicada, hard limits:

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

(Adicionar templates equivalentes para Python, Supabase, n8n nas restantes regras — anexo 12.5)

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

Em Windows, prefixar com `cmd /c`:
```json
{
  "command": "cmd",
  "args": ["/c", "npx", "-y", "gitnexus@latest", "mcp"]
}
```

### 9.4 Verificação

Em Cursor, abre Composer e digita:
- `@rules` deve mostrar as 6 .mdc carregadas (3 always + 3 attached conforme ficheiro aberto).
- `/rules` mostra qual o estado.
- Testar: `/opsx:propose teste-instalação` — deve criar pasta `openspec/changes/teste-instalacao/`.

---

## 10. Configuração VS Code + Claude Code (questão 5)

### 10.1 Pré-requisitos

- VS Code 1.109+
- Extension "Claude Code" (publisher: anthropic) — verificar publisher cuidadosamente, há knock-offs.
- Claude Code CLI ≥ 2.1.140 (a extensão inclui CLI mas é melhor garantir versão recente: `claude install`).

### 10.2 Estrutura final

```
projecto/
├── AGENTS.md                            ← mesmo ficheiro do Cursor
├── CLAUDE.md                            ← curto, aponta para AGENTS.md
├── .claude/
│   ├── settings.json                    ← permissões
│   ├── commands/                        ← gerados por OpenSpec
│   ├── skills/                          ← gerados por GitNexus + Graphify
│   │   ├── gitnexus-exploring/
│   │   ├── gitnexus-impact/
│   │   ├── gitnexus-refactor/
│   │   └── graphify/
│   ├── agents/                          ← subagents customizados
│   │   ├── graphify-researcher.md
│   │   ├── codebase-researcher.md
│   │   └── security-reviewer.md
│   └── hooks/                           ← guardrails determinísticos
│       ├── block-dangerous.sh
│       ├── session-start.sh
│       └── post-edit-typecheck.sh
```

### 10.3 `CLAUDE.md` (raiz)

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

### 10.5 Hook crítico — `.claude/hooks/block-dangerous.sh`

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

Registrar em `.claude/settings.json`:

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

### 10.7 Verificação

```bash
# Listar configurações activas
claude /context
claude /agents
claude /hooks
claude mcp list

# Testar subagent
# No Claude Code:
> Use the codebase-researcher agent to map the auth flow
```

---

## 11. Protocolos de código (questão 7)

### 11.1 Princípios não-negociáveis

Estes vão para `openspec/project.md` na secção "Coding standards":

1. **Replicabilidade**: cada solução é testável de forma reproduzível. Sem testes, sem merge.
2. **Legibilidade > esperteza**: código claro com 2 funções é melhor que one-liner enigmático.
3. **Self-documenting names**: variáveis e funções comunicam intenção. Comentários explicam *porquê*, não *o quê*.
4. **Comments document decisions, not mechanics**: `// retries 3x because n8n webhook timeout is 10s` é útil. `// increment i` é ruído.
5. **Modularização por capability, não por type**: pasta `auth/` com `auth.service.ts`, `auth.controller.ts`, `auth.types.ts`, em vez de pastas globais `services/`, `controllers/`, `types/`.
6. **No silent failures**: erros são propagados ou registados explicitamente, nunca engolidos.
7. **Input validation at boundaries**: cada entrada externa (API, webhook, CSV, env) é validada por schema (Zod, Pydantic) no primeiro ponto de contacto.
8. **Tracing built-in**: para o multi-agent bot do Pedro, cada agent step deve loggar (correlation ID, agent name, input hash, output hash, duration, errors).

### 11.2 Estrutura de comentários

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

Comentários inline (raros):

```typescript
// Reset retries when we hit a 429 — Supabase rate limit window is 60s,
// not 5s like other endpoints. See infra/rate-limits.md.
if (response.status === 429) {
  await sleep(60_000);
  retries = 0;
}
```

### 11.3 Estrutura modular para o multi-agent bot

```
src/
├── agents/                          ← capability: cada agent é módulo isolado
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

Cada pasta capability tem:
- Um único entry point (`index.ts` que re-exporta apenas a API pública)
- `README.md` explicando propósito, dependências, e como testar
- Testes co-locados (`*.test.ts`)

### 11.4 Rastreabilidade de dados

Para o pipeline multi-agent, cada peça de dado que flui entre etapas carrega:

```typescript
type TraceContext = {
  correlationId: string;          // ID único de toda a request
  agentChain: string[];           // ["orchestrator", "retrieval", "synthesis"]
  step: number;
  parentSpanId: string | null;
  spanId: string;
  startedAt: ISOTimestamp;
};

type AgentInput<T> = {
  trace: TraceContext;
  payload: T;
  schemaVersion: string;          // e.g. "v1.2.0" — para detectar drift
};
```

Toda função que processa dados entre agents recebe e propaga este contexto. Logger interno escreve cada step em formato estruturado para Supabase (`agent_traces` table) ou logger compatível.

### 11.5 Prevenção de bugs

- **Tests are first-class**: cada bug fix começa com teste que falha. Cada feature inclui testes para casos felizes, edge cases, e error paths.
- **Property-based testing** para lógica pura (fast-check em TS, hypothesis em Python).
- **Contract tests** nas fronteiras (cada agent declara o seu contrato Zod; outros agents validam contra esse contrato).
- **Type safety end-to-end**: TS strict + Zod runtime; Pydantic em Python.

### 11.6 Prevenção de ataques

| Vector | Defesa | Onde implementar |
|---|---|---|
| SQL injection | Parameterised queries via Supabase client; nunca string concat | `infra/supabase/client.ts` |
| Prompt injection | Sanitize all external strings antes de meter em prompts a LLMs; usar role separation | `agents/*/prompt.ts` |
| SSRF (Tavily, web fetch) | Allowlist de domínios; reject IPs privados e localhost | `infra/web/fetch.ts` |
| Webhook spoofing | HMAC verification em todos os webhooks | `infra/n8n/webhook.handler.ts` |
| Secret leakage | Hooks PreToolUse bloqueiam leitura de `.env`; logger redacta padrões `sk-*`, `api_key=*` | `.claude/hooks/`, `core/tracing/logger.ts` |
| Dependency injection | Audit `pnpm audit` / `pip-audit` em CI; reject deps com vulns críticas | `.github/workflows/audit.yml` |
| XSS (se houver UI) | Sanitização em render; CSP headers; React por defeito escapa, JSX dangerouslySetInnerHTML proibido sem review | Configuração frontend |
| Rate limiting | Tokens bucket por user/agent na entrada de cada API; backoff exponencial | `core/rate-limit.ts` |

### 11.7 Documentação por módulo

Cada capability tem `README.md`:

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

## 12. Anexos: templates completos

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

### 12.2 Núcleo comum `AGENTS.md` (todas as instalações)

Bloco partilhado — colar e completar Commands conforme 12.2a ou 12.2b.

```markdown
# AGENTS.md — Instruções Universais para Agentes de IA

> Canónico para Cursor, Claude Code, Codex, etc. `CLAUDE.md` e `.cursor/rules/` apenas apontam aqui.
> Padrão: https://agents.md/

## Contexto do projecto

Ver `./openspec/project.md` (stack, convenções, constraints). **Não duplicar** stack aqui.

## Commands

[PREENCHER: tabela do perfil 12.2a APP ou 12.2b DOCS_SPECS]

## Fontes de conhecimento (por prioridade)

1. `./openspec/specs/`  2. `./openspec/changes/`  3. `./graphify-out/GRAPH_REPORT.md`
4. GitNexus MCP  5. Graphify MCP ou `graphify query`  6. Docs em `project.md`  7. Web (último recurso)

Nunca afirmar factos sem fonte 1–6. Tipo D/E: Graphify + GitNexus antes de código.

## Contexto sob demanda

| Situação | Ficheiro |
|----------|----------|
| Constituição | `openspec/project.md` |
| Specs | `openspec/specs/` |
| Change activo | `openspec/changes/<id>/` |
| Grafo | `graphify-out/GRAPH_REPORT.md` |
| Infra instalada | `openspec/infra.md` |
| Guia SDD | `doc/sistema-sdd-pedro.md` |
| Actualização SDD | `doc/sistema-sdd-pedro.md` §2.9 |
| TS / Py / DB | `.cursor/rules/010-*.mdc`, `020-*.mdc`, `030-*.mdc` |

## Protocolo de tarefas (A–E)

| Tipo | Pipeline |
|------|----------|
| A Trivial | Edição directa |
| B Bug | GitNexus impact → patch → teste |
| C Refactor | GitNexus AS-IS → `/opsx:propose` → implementar |
| D Feature | Graphify ∥ GitNexus → propose → implementar |
| E Exploração | Graphify → `research.md` |

Se ambíguo, PERGUNTAR. Nunca assumir Tipo A.

## Regras R1–R11

R1 classificar · R2 specs>graphify>gitnexus · R3 `[NEEDS VERIFICATION]` · R4 mudança mínima ·
R5 refactor sem comportamento novo · R6 teste antes do fix · R7 spec antes de código (C/D/E) ·
R8 citar fontes · R9 commits com scope/change-id · R10 infra conhecida (`openspec/infra.md`) ·
R11 coordenação local (`sdd-session-check` antes de apply; `sdd-session-release` ao fim)

## Workflow

`/opsx:propose` · `/opsx:apply` · `/opsx:archive` · `/opsx:explore` · `graphify update .` · `npx gitnexus analyze --force`

## Integrações (resumo)

**GitNexus:** impact antes de editar símbolos; `detect_changes` antes de commit. Skills: `.claude/skills/gitnexus/`.

**Graphify:** ler `GRAPH_REPORT.md` antes de grep em perguntas de arquitectura; `graphify update .` após mudanças de código.

## Testing

[PREENCHER: npm test / pytest / openspec validate / N/A para docs-only]

## PR e commits

Conventional Commits; referenciar change-id OpenSpec quando aplicável. Não commitar `graphify-out/`, `.gitnexus/`.

## Segurança

Sem segredos em git; validar inputs; queries parametrizadas; não ler `.env`.

## Comunicação

[Adaptar: pt-BR, directo, sem preâmbulo]
```

### 12.2a Commands — perfil APP

```markdown
| Comando | Uso |
|---------|-----|
| `npm run dev` / `pnpm dev` | Desenvolvimento (não `npm run build` em sessão agente) |
| `npm test` / `pnpm test` | Testes |
| `npm run lint` | Lint |
| `npx openspec list` | Changes OpenSpec |
| `npx gitnexus analyze --force` | Reindexar código |
| `graphify update .` | Actualizar grafo |
```

### 12.2b Commands — perfil DOCS_SPECS

```markdown
| Comando | Uso |
|---------|-----|
| `npx openspec list` | Changes activos |
| `npx openspec new change "<id>"` | Novo change (CLI) |
| `/opsx:propose` | Proposta (Cursor/Claude) |
| `npx gitnexus status` | Estado do index |
| `npx gitnexus analyze --force` | Reindexar |
| `graphify update .` | Grafo AST |
| `graphify query "<pergunta>"` | Busca no grafo |
| `bash scripts/sdd-session-status.sh` | Sessões SDD activas (worktree local) |

Nota: não há `npm run dev` na raiz deste perfil.
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

### 12.5 Templates `.cursor/rules/*.mdc` adicionais

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

### 12.6 Comando de instalação one-shot

> **v1.3.0:** O script completo vive em `scripts/bootstrap-sdd.sh` (repo) e `sdd-kit/templates/scripts/bootstrap-sdd.sh` (kit). Após CLIs, delega payloads a `sdd-kit/install.sh`. **Não** copiar blocos bash deste anexo — usar `sdd-kit/templates/`.

Resumo da ordem:

```bash
bash scripts/bootstrap-sdd.sh          # CLIs globais + openspec init
bash sdd-kit/install.sh --profile DOCS_SPECS [--dry-run]
bash sdd-kit/verify.sh
```

Ver `sdd-kit/README.md` para perfis e cenários C1–C3.

### 12.7 Template `AGENTS.md` aninhado (subpasta)

Exemplo para `doc/curso/scripts/AGENTS.md` ou `packages/foo/AGENTS.md`:

```markdown
# AGENTS.md — [nome da pasta]

Instruções locais; o canónico na raiz é `../../AGENTS.md`.

## Commands

| Comando | Uso |
|---------|-----|
| `python script.py` | [descrever] |

## Regras locais

- [Regra específica desta pasta]
- Herdar segurança e protocolo A–E do `AGENTS.md` raiz
```

### 12.8 Template `UPGRADE_REPORT.md` (actualização SDD)

Guardar em `openspec/changes/upgrade-sdd-<versão>/UPGRADE_REPORT.md` **antes** de editar ficheiros curados.

```markdown
# Relatório de actualização SDD

| Campo | Valor |
|-------|--------|
| Repositório | [nome/caminho] |
| Perfil | APP / DOCS_SPECS / HYBRID |
| Versão guia (antes) | vX.Y.Z ou desconhecida |
| Versão guia (alvo) | vA.B.C |
| Data | YYYY-MM-DD |
| Branch | chore/upgrade-sdd-vA.B.C |

## Versões das ferramentas

| Ferramenta | Antes | Depois |
|------------|-------|--------|
| OpenSpec | | |
| GitNexus | | |
| Graphify | | |

## Resumo executivo

- [ ] Actualização aprovada pelo utilizador
- Breaking changes do guia aplicáveis: [sim/não — listar]

## Matriz de ficheiros

| Ficheiro | Existe | Linhas (antes) | Classificação | Acção proposta | Aprovado |
|----------|--------|----------------|---------------|----------------|----------|
| AGENTS.md | sim/não | | MERGE | Sincronizar 12.2; manter Commands | [ ] |
| openspec/project.md | | | MERGE | Actualizar Cross-references; manter Purpose/Stack | [ ] |
| CLAUDE.md | | | MERGE | Template §10.3 | [ ] |
| .cursor/rules/000-base.mdc | | | APPLY/MERGE | | [ ] |
| .cursor/rules/050-security.mdc | | | APPLY/MERGE | | [ ] |
| .cursor/rules/010-typescript.mdc | | | SKIP/KEEP | | [ ] |
| .cursor/rules/020-python.mdc | | | SKIP/KEEP | | [ ] |
| .cursor/rules/030-supabase.mdc | | | SKIP/KEEP | | [ ] |
| .cursor/rules/graphify.mdc | | | MERGE/KEEP | | [ ] |

Classificações: `KEEP_LOCAL` · `MERGE` · `APPLY_TEMPLATE` · `NEW` · `SKIP`

## Diffs relevantes (resumo)

### AGENTS.md
- Secções só no local: …
- Secções só no template: …
- Conflitos: …

### openspec/project.md
- …

## Ficheiros gerados (não curados)

| Caminho | Acção |
|---------|--------|
| `.cursor/commands/opsx-*` | `openspec update` |
| `openspec/AGENTS.md` | regenerado — ignorar para canónico |

## Pós-actualização

- [ ] §2.9.4 executado
- [ ] §2.9.7 checklist
- [ ] IDE reiniciada
- [ ] `/opsx:propose` testado
```

### 12.9 Script de diff (`scripts/sdd-upgrade-diff.sh`)

### 12.9 Script de diff (`scripts/sdd-upgrade-diff.sh`)

> **v1.3.0:** Fonte canónica de templates = `sdd-kit/templates/`. O script lê a lista de ficheiros de `sdd-kit/MANIFEST.yaml` quando presente.

Inventaria ficheiros curados e, com directorio de staging, mostra `diff -u`:

```bash
# Só inventário (lê MANIFEST.yaml)
./scripts/sdd-upgrade-diff.sh

# Diff contra templates do kit (recomendado)
./scripts/sdd-upgrade-diff.sh sdd-kit/templates/

# Staging local para revisão
./scripts/sdd-upgrade-diff.sh openspec/changes/upgrade-sdd-v1.3.0/sdd-staging/
```

Estrutura do kit (`sdd-kit/templates/` espelha paths do repo):

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

**Não** extrair scripts do markdown deste guia — copiar de `sdd-kit/templates/` ou correr `sdd-kit/install.sh`.

### 12.10 Template `openspec/changes/<id>/tasks.md` (patterns e gates)

Tasks atómicas com sub-bullets estruturados. **Decisões** vivem em `design.md` (§12.3); **passos verificáveis** vivem aqui.

#### Modelo de 3 níveis de ancoragem

| Nível | Quando usar | Formato |
|-------|-------------|---------|
| **1 — Pointer** (default) | Já existe implementação clara no repo | `Pattern: path/relativo.ext` |
| **2 — Esqueleto** | Padrão não óbvio | ≤15 linhas (interface + 1 teste) + pointer |
| **3 — Boilerplate** | SQL migration, Zod base, hook template | Snippet completo + tag `boilerplate-only` |

**Regra:** snippets com mais de 15 linhas **não** ficam em `tasks.md` — mover para skill (`.cursor/skills/` / `.claude/skills/`) ou referenciar change arquivado.

#### Formato de task (checkbox + sub-bullets)

```markdown
## 2. Implementação

- [ ] 2.3 Criar `SubscriptionRepository`
  - **Pattern:** `src/infra/stripe/customer.repo.ts`
  - **Invariants:** R-BILL-003 (`openspec/specs/billing/spec.md`)
  - **Gate:** `npm test -- subscription.repo`
  - **Proibido:** criar `BaseRepository` (já existe em `src/core/`)

- [ ] 2.4 Actualizar guia §12.10
  - **Pattern:** `doc/sistema-sdd-pedro.md` §12.3
  - **Gate:** `grep -q '12.10' doc/sistema-sdd-pedro.md`
```

| Sub-bullet | Obrigatório | Notas |
|------------|-------------|-------|
| **Pattern** | Recomendado em código; opcional em docs | Path **relativo ao repo actual** |
| **Gate** | **Sim** em qualquer task verificável | Comando shell; exit 0 = pronto |
| **Invariants** | Se spec aplicável | ID de requisito OpenSpec |
| **Proibido** | Opcional | Anti-patterns (R4) |
| **Skill** | Cross-repo ou pattern longo | Ver abaixo |

#### Perfil DOCS_SPECS — fronteira de repo (regra normativa)

Em repositórios **DOCS_SPECS** (sem app na raiz — §2.5.2):

1. **`Pattern:`** deve apontar **apenas** para ficheiros **deste repo** (`doc/`, `scripts/`, `openspec/`, etc.).
2. **Implementação de código APP** (Next.js, `src/`, APIs) → **OpenSpec change no repo APP**, não tasks de código APP neste hub de specs.
3. **Specs aqui, código lá:** este repo define *o quê* (`openspec/specs/`); o repo APP implementa *como* com GitNexus local.
4. `scripts/verify-task-patterns.sh` falha se detectar `Pattern: repo:path` em perfil DOCS_SPECS.

Exemplo **válido** (DOCS_SPECS):

```markdown
- [ ] 1.2 Melhorar `enrich-transcripts.py`
  - **Pattern:** `doc/curso/scripts/extract-lessons-batch.py`
  - **Gate:** `python -m py_compile doc/curso/scripts/enrich-transcripts.py`
```

Exemplo **inválido** (DOCS_SPECS — mover change para repo APP):

```markdown
- [ ] 2.1 Criar `SubscriptionRepository`
  - **Pattern:** `multi-agent-bot:src/infra/stripe/customer.repo.ts`  ← PROIBIDO neste perfil
```

#### Patterns cross-repo — usar Skills (não tasks)

Quando o padrão canónico vive noutro repositório ou é demasiado longo para uma task:

1. Criar ou actualizar skill: `.cursor/skills/<domínio>-pattern/SKILL.md`
2. Na task, referenciar: `- **Skill:** supabase-repo-pattern`
3. Na skill: descrever estrutura + path canónico no repo APP (texto, não copy-paste massivo)
4. Após archive de change bem-sucedido: considerar **promover** pattern estável para skill (checklist archive)

```markdown
- [ ] 3.1 Implementar gateway Stripe no repo APP
  - **Skill:** stripe-billing-pattern
  - **Gate:** _(correr no repo APP)_ `npm test -- billing.gateway`
```

> Hub DOCS_SPECS pode ter a **spec** e o **design**; a **task de código APP** vive no change do repo APP com skill partilhada ou pointer local GitNexus.

#### Verificação

```bash
bash scripts/verify-task-patterns.sh   # paths Pattern: existem; DOCS_SPECS sem repo:path
```

---

## 13. Alinhamento workshop ↔ agents.md

| Tema (Workshop IA 5/2026, Aula 01) | Onde no guia |
|-----------------------------------|--------------|
| [agents.md](https://agents.md/) como padrão | §2.5, 12.2 |
| `AGENTS.md` curto; on-demand loading | §2.5.3, 12.2 |
| Não pedir à IA para gerar `AGENTS.md` | §2.5.1 |
| Exemplos reais > regras abstritas | §7, §11 |
| Context rot; janela nova por tarefa | §3, §7 |
| Skills lazy vs rules estáticas | §4.2, §8.1 |
| Legado: AS-IS antes de instrumentar | §2.5.3, §2.0 prompt |
| `CLAUDE.md` aponta para `AGENTS.md` | §10.3 |

---

## Changelog do guia

### 1.6.1 (2026-07-26)

- **Cadência + playbook (G4 extensão)** — §2.17: “Interpretar → actuar” (M1–M4 → 1 insight → 1 ajuste); limiares N=5 archives / T=30 dias; stamp `.sdd/metrics-last-run`; flag `--check-cadence`; nudge advisory no Session Handoff de `/opsx:archive` (change `add-sdd-metrics-cadence-nudge`).
- **`sdd-kit/`** — Script/template `sdd-metrics.sh` actualizado; MANIFEST **1.6.0 → 1.6.1**.
- **Discovery / first contact** — §2.0b quickstart vibe coder → `README.md` raiz (**ByeByeVibe**) + `install.sh --dry-run`; avaliação `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (change `add-sdd-discovery-positioning`; rename público `rename-byebyevibe-public-name`). Sem bump de MANIFEST (só docs).

### 1.6.0 (2026-07-26)

- **Métricas SDD (G4)** — Script local sob demanda `scripts/sdd-metrics.sh` (modo C): volume, lead time propose→archive, rework pós-archive; **sem** Apache DevLake (change `add-sdd-metrics-script`).
- **§2.17** — Operação humana das métricas: quando correr, leitura M1–M4, proxies, troubleshooting, rollback.
- **`sdd-kit/`** — Template `scripts/sdd-metrics.sh`; MANIFEST **1.5.0 → 1.6.0**.
- **Probity (G2)** — Módulo opcional APP/HYBRID `@nizos/probity@1.10.0` com `enforceTdd` (change `add-probity-tdd-module`). TDD Guard superseded por Probity (2026-07).
- **§2.16** — Operação humana Probity: install plugin, piloto, Cursor hooks, desligar, troubleshooting, rollback.
- **`sdd-kit/`** — `install-probity-module.sh`, template `probity.config.ts`, `doc/design/004-probity-module-install.md`.
- **Supply chain (G8)** — OSV-Scanner bloqueante no `sdd-gates.yml` (quando lockfile presente) + template `renovate.json` conservador para perfis APP/HYBRID (change `add-supply-chain-gates`).
- **§2.13** — Operação humana supply chain: OSV no Actions, instalar app Renovate, preset, automerge patches (opt-in), troubleshooting, rollback.
- **Renumerado** — §2.13 correctness-review → §2.14; §2.14 github-mcp → §2.15; Probity → §2.16.
- **`sdd-kit/`** — `templates/renovate.json`; OSV em `templates/.github/workflows/sdd-gates.yml`.

### 1.5.0 (2026-07-26)

- **GitHub Issues MCP (G5)** — `github-mcp-server` como MCP passivo (modo D) + campo `**Issue:**` no template de `proposal.md` para rastreabilidade issue → change → PR (change `add-github-mcp-issue-traceability`).
- **§2.15** — Operação humana do github-mcp: instalação (endpoint remoto OAuth + binário local), escopo mínimo `--toolsets issues`, matriz A–E, troubleshooting, rollback.
- **`sdd-kit/`** — Template `openspec/changes/_template/proposal.md`; MANIFEST 1.4.0 → 1.5.0.

### 1.4.0 (2026-07-25)

- **CI Gates (G1)** — `.github/workflows/sdd-gates.yml`: enforcement fail-closed dos gates SDD em `push`/`pull_request` (`openspec validate --all --strict` bloqueante; `verify-task-patterns.sh` bloqueante; `sdd-kit/verify.sh` report-only). Só orquestra comandos existentes — zero dependência nova (change `add-sdd-ci-gates-workflow`).
- **§2.12** — Operação humana dos gates de CI: leitura de output, desbloqueio de merge, troubleshooting, `[AÇÃO MANUAL]` branch protection.
- **`sdd-kit/`** — Template `templates/.github/workflows/sdd-gates.yml` (COPY, perfis APP/DOCS_SPECS/HYBRID); check do workflow em `verify.sh`; MANIFEST 1.3.2 → 1.4.0.

### 1.3.2 (2026-07-06)

- **`scripts/bootstrap-sdd.sh`** — GitNexus agora é opcional: falha em install/setup/analyze já não aborta o bootstrap (Graphify + `sdd-kit/install.sh` continuam). Corrigido também line-endings CRLF que quebravam o parse do bash.
- **`scripts/sdd-session-check.sh`** — Removido probe `flock -n` redundante que colidia com o próprio holder da sessão (register corre antes de check, rule `016`); detecção de conflito continua via scan dos session-files. Corrigido gap em que uma sessão com heartbeat expirado mas PID ainda vivo (operação longa sem heartbeat) não era detectada como conflito — agora só sessões provadamente stale (heartbeat velho **e** PID morto) são ignoradas.
- **`sdd-kit/templates/AGENTS.core.md`** — Removidas linhas duplicadas (Módulo UI / Pipeline design) na tabela "Contexto sob demanda".

### 1.3.1 (2026-06-27)

- **C1-UI** — Módulo de desenvolvimento de UI opcional pós-C1: `sdd-kit/install-ui-module.sh`, `doc/design/002-*`, `003-*`.
- **§2.11 / §2.11.1** — Procedimento e checklist do módulo UI (ponteiros, sem duplicar pipeline).
- **§5.6** — Tabela de referências cruzadas ao módulo UI.
- **§1.6** — Cenário C1-UI na tabela de instalação.
- **`doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`** — Avaliação agregada Impeccable + OD + Pencil (**Adopted**).

### 1.3.0 (2026-06-17)

- **`sdd-kit/`** — Install kit versionado: `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `templates/`.
- **§1.6** — Organização em quatro camadas; cenários C1 / C2 / C2b / C3; perfis APP / DOCS_SPECS / HYBRID; hub vs consumidor.
- **§2.0 / §2.9.5** — Instalação e upgrade usam `sdd-kit/templates/` em vez de extrair markdown §12.
- **§12.6 / §12.9** — Scripts inteiros deprecados no guia; ponteiro para `sdd-kit/templates/`.
- **`scripts/sdd-upgrade-diff.sh`** — Inventário lê paths de `sdd-kit/MANIFEST.yaml`.
- **Session coordination** — Entrada no changelog; rules `015`/`016` e scripts `sdd-session-*` no MANIFEST.
- **`openspec/infra.md`** — Secção Install Kit.

### 1.2.1 (2026-06-16)

- **§12.10** — Template `tasks.md` com Pattern, Gate, modelo 3 níveis, regra DOCS_SPECS (specs aqui, código APP no repo APP), patterns cross-repo via Skills.
- **§5.2 / §7.2** — Referências cruzadas a tasks enriquecidas.
- **`scripts/verify-task-patterns.sh`** — validação de paths em `Pattern:`.

### 1.2.0 (2026-06-15)

- **§2.9** — Actualização de instalação existente (detecção, prompt IA, ferramentas, merge, checklist).
- **§2.9.5** — Matriz de comparação ficheiros curados vs templates (KEEP_LOCAL / MERGE / APPLY_TEMPLATE / NEW / SKIP).
- **§12.8** — Template `UPGRADE_REPORT.md` para aprovação humana antes de editar ficheiros.
- **§12.9** + `scripts/sdd-upgrade-diff.sh` — inventário e diff contra staging.
- Tabela "Como usar" distingue instalação vs actualização (humano e agente).

### 1.1.0 (2026-05-25)

- Guia explicitamente como **artefacto de instalação** reutilizável (humano + IA).
- §2.0 prompt de instalação assistida; §2.8 checklist de verificação.
- Formato alvo `AGENTS.md`: Commands, on-demand, integrações resumidas (agents.md).
- §2.5.1 anti-padrões; §2.5.2 perfis APP / DOCS_SPECS / HYBRID.
- Templates 12.2a / 12.2b / 12.7; `graphify update` em vez de `graphify .`.
- `openspec init --tools`; bootstrap actualizado.

### 1.0.0 (2026-05)

- Versão inicial: OpenSpec + GitNexus + Graphify, Cursor, Claude Code.

---

## Apêndice — Disclaimer técnico final

Este sistema combina três projectos open source em rápida evolução. Os comandos básicos (`openspec init`, `gitnexus analyze`, `graphify .`) são estáveis. Flags exóticas, formato exacto de subagents, e detalhes de hooks podem mudar em releases mensais. Antes de automatizar processos críticos em produção:

1. Confirmar versões com `<ferramenta> --version`
2. Ler CHANGELOG da release mais recente
3. Testar em branch separada antes de PR

Se algo falhar na configuração, a ordem habitual de debug é:
1. `gitnexus status` e `claude mcp list` — MCPs estão registados?
2. `cat ~/.cursor/mcp.json` — sintaxe correcta?
3. Restart Cursor/VS Code após qualquer mudança de configuração (skills são carregadas no arranque da sessão).
4. Logs: `.claude/logs/` se hooks de logging estiverem configurados.

---

*Guia v1.2.0 — Junho 2026. Ferramentas de referência: OpenSpec 1.3.1+, GitNexus 1.6+, Graphify 0.8.5+, Claude Code 2.1.140+, Cursor `.mdc`, VS Code 1.109+. Confirmar com `--version` antes de automatizar.*
