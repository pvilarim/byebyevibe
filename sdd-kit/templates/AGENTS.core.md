# AGENTS.md — Universal Instructions for AI Agents

> Canonical file for Cursor, Claude Code, Codex, etc. `CLAUDE.md` and `.cursor/rules/` only point here.
> Standard: https://agents.md/

## Project context

See `./openspec/project.md` (stack, conventions, constraints). **Do not duplicate** the stack here.

## Commands

<!-- SDD_KIT_COMMANDS_START -->
[FILL: profile table — see sdd-kit/templates/AGENTS.commands.APP.md or AGENTS.commands.DOCS_SPECS.md]
<!-- SDD_KIT_COMMANDS_END -->

## Knowledge sources (by priority)

1. `./openspec/specs/` — current requirements by capability
2. `./openspec/changes/` — active proposals and archive
3. `./graphify-out/GRAPH_REPORT.md` — knowledge graph summary
4. GitNexus via MCP — code structure, call chains, blast radius
5. Graphify via MCP or `graphify query` — concepts and relations
6. External docs (only if cited in `./openspec/project.md`)
7. Web search (last resort, with critical scrutiny)

**NEVER** assert a fact that cannot be anchored to one of sources 1–6.
For type D/E work, **ALWAYS** consult Graphify and GitNexus before writing code.

## On-demand context

| Situation | Load |
|----------|------|
| Constitution (stack, non-goals) | `openspec/project.md` |
| Specs by capability | `openspec/specs/` |
| Change in progress | `openspec/changes/<id>/` |
| Theory / relations between concepts | `graphify-out/GRAPH_REPORT.md` |
| SDD install guide | `doc/sistema-sdd-pedro.md` |
| UI module (C1-UI) | `doc/sistema-sdd-pedro.md` §2.11 · `doc/design/002-ui-module-install.md` |
| Design pipeline / shadcn | `doc/design/001-pipeline-open-design-shadcn-impeccable.md` |
| SDD upgrade (repo already installed) | `doc/sistema-sdd-pedro.md` §2.9 |
| Install kit (versioned payload) | `sdd-kit/` |
| Installed infra (MCP, CLIs, skills) | `openspec/infra.md` |
| CI gates (sdd-gates, operation) | `doc/sistema-sdd-pedro.md` §2.12 · `.github/workflows/sdd-gates.yml` |
| Supply chain (Renovate + OSV) | `doc/sistema-sdd-pedro.md` §2.13 |
| GitHub Issues MCP (human operation) | `doc/sistema-sdd-pedro.md` §2.15 |
| SDD metrics (G4, mode C) | `doc/sistema-sdd-pedro.md` §2.17 · `bash scripts/sdd-metrics.sh` |
| TypeScript (when applicable) | `.cursor/rules/010-typescript.mdc` |
| Python | `.cursor/rules/020-python.mdc` |
| Supabase | `.cursor/rules/030-supabase.mdc` |

## Task Classification Protocol

Before **any** work, classify (A–E):

| Type | Signal | Pipeline |
|------|--------|----------|
| A — Trivial | One line, no semantic risk | Direct edit |
| B — Bug fix | Reproducible error, known cause | GitNexus impact → patch → test |
| C — Refactor | Restructure without new behavior | GitNexus AS-IS → `/opsx:propose` → implement |
| D — Feature | New behavior grounded in the knowledge base | Graphify ∥ GitNexus → propose → implement |
| E — Exploration | Investigate, compare, decide | Graphify → `research.md` |

If ambiguous between two types, **ASK**. **NEVER** assume Type A by default.

## Universal rules (R1–R11)

- **R1** — Classify the task (A–E) before acting
- **R2** — Priority: specs > archive > Graphify > GitNexus > docs > web
- **R3** — No hallucinations: mark `[NEEDS VERIFICATION]` if no source
- **R4** — Smallest reasonable change; no speculative abstractions
- **R5** — Refactors without new behavior
- **R6** — Bug: failing test first, then fix
- **R7** — Type C/D/E tasks: reviewed OpenSpec proposal before code
- **R8** — Cite sources in design.md, research.md, commits
- **R9** — Commits with scope or OpenSpec change-id
- **R10** — Known infra: read `openspec/infra.md` before installing MCP/CLIs/skills; ✅ = use directly
- **R11** — Local coordination: before apply, `sdd-session-register` + `sdd-session-check`; at end/pause, `sdd-session-release` (§3.3 SDD guide)

## Workflow

- `/opsx:propose <description>` — new change
- `/opsx:apply` — implement tasks of the current change
- `/opsx:archive` — finalize and archive
- `/opsx:explore <topic>` — type E tasks
- `graphify update .` — update graph after code/docs changes
- `npx gitnexus analyze --force` — update code graph

## Integrations

**GitNexus** — Before editing symbols: `gitnexus_impact`. Before commit: `gitnexus_detect_changes`. Skills: `.claude/skills/gitnexus/`.

**Graphify** — Read `graphify-out/GRAPH_REPORT.md` before grepping architecture questions. After editing code: `graphify update .`.

**github-mcp-server** — Passive MCP (mode D) for GitHub Issues context. Consult on types **B**, **D**, and **E** (optional on **C** if there is an issue); never on type **A**. In `/opsx:propose`, read the source issue when `**Issue:**` is filled; on B/D without an explicit issue, check open issues to avoid duplicates. Fill `**Issue:**` in `proposal.md` (URL, `#123`, or `—`). Cloud agents: read-only `gh` CLI covers ad-hoc queries — local MCP is for interactive sessions. Human operation: guide §2.15.

**Supply chain (Renovate + OSV-Scanner)** — Automatic gates independent of the A–E task in progress. Renovate PR: patch = type **A**; minor/major = type **B/C** (human review). Red OSV in CI = type **B** — fix the dependency before merge or `/opsx:archive`. Operation: guide §2.13.

**CI Gates (sdd-gates)** — Workflow `.github/workflows/sdd-gates.yml` runs on `push`/`pull_request`, fail-closed: `openspec validate --all --strict` (blocking), `verify-task-patterns.sh` (blocking), **OSV-Scanner** (blocking when a lockfile is present), `sdd-kit/verify.sh` (report-only). Before push: run `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict` locally. Operation: guide §2.12.

**Probity (G2)** — Optional APP/HYBRID module: `bash sdd-kit/install-probity-module.sh --detect` → `--apply [--yes]`; pin `@nizos/probity@1.10.0`. A–E matrix: off on A (globs); on for B/C/D via `enforceTdd`. DOCS_SPECS without tests: SKIP. Operation: guide §2.16.

**SDD Metrics (G4)** — Local on-demand script (mode C): `bash scripts/sdd-metrics.sh [--since YYYY-MM-DD] [--output PATH]`. Markdown report (volume, lead time propose→archive, rework `fix` post-archive). Cadence: advisory nudge in the Session Handoff of `/opsx:archive` via `--check-cadence` (N=5 / T=30); Interpret→act playbook in §2.17. git+archive proxies; **do not** adopt Apache DevLake. No always-on skill/rule (R3 N/A).

## Testing

[FILL: npm test / pytest / openspec validate / N/A for docs-only]

## PR and commits

Conventional Commits; reference the OpenSpec change-id when applicable.
**Do not commit:** `graphify-out/`, `.gitnexus/`, `AGENTS.tools-generated.md`

## Security

**NEVER:** secrets in git-tracked files; `rm -rf` outside the repo; `--no-verify` without explaining; read `.env`.

**ALWAYS:** validate inputs (Zod/Pydantic); parameterized queries; sanitize LLM prompts.

## Communication

**F7 — three language axes** (configured at install; see `openspec/project.md` Language policy):

| Axis | Value | Scope |
|------|-------|-------|
| Chat | `{{CHAT_LANG}}` | Human↔agent conversation (ephemeral; not versioned prose) |
| Docs | `{{DOCS_LANG}}` | Versioned artifacts: OpenSpec proposals, designs, specs, tasks, skills prose, rules prose, `doc/` |
| Code | `{{CODE_LANG}}` | Comments, user-facing strings, error messages; identifiers stay English/ASCII |

- Chat **MAY** use `{{CHAT_LANG}}`; chat language does **not** authorize docs or code outside the configured axes.
- Documentation artifacts **MUST** be written in `{{DOCS_LANG}}`.
- Code comments and user-facing strings **MUST** use `{{CODE_LANG}}`.
- Glossary / i18n waves (when `docs_language` is `en`): `doc/i18n/`.
