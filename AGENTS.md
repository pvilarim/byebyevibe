# AGENTS.md — Universal Instructions for AI Agents

> Canonical file for Cursor, Claude Code, Codex, etc. `CLAUDE.md` and `.cursor/rules/` only point here.
> Standard: https://agents.md/

## Project context

See `./openspec/project.md` (stack, conventions, constraints). **Do not duplicate** the stack here.

## Commands

| Command | Use |
|---------|-----|
| `npx openspec list` | Active OpenSpec changes |
| `npx openspec new change "<id>"` | Create change (CLI) |
| `npx openspec validate <id>` | Validate change |
| `/opsx:propose` · `/opsx:apply` · `/opsx:archive` | Workflow Cursor/Claude |
| `/opsx:help` | Day-1 operator tutorial (ByeByeVibe control plane) |
| `npx gitnexus status` | Code index status |
| `npx gitnexus analyze --force` | Reindex after changes |
| `graphify update .` | Update graph (AST, no LLM) |
| `graphify query "<pergunta>"` | Search the knowledge graph |
| `python doc/curso/scripts/enrich-transcripts.py` | Re-enrich course transcripts |
| `bash scripts/sdd-session-status.sh` | Active SDD sessions in the local worktree |
| `bash scripts/sdd-metrics.sh` | On-demand SDD metrics (G4, mode C) — volume, lead time, rework |
| `bash scripts/verify-i18n-wave.sh` | Per-wave i18n gates / global DoD (`doc/i18n/`) |
| `bash sdd-kit/install-probity-module.sh --detect` | Probity G2 — detect test runner / applicability |
| `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict` | Local CI gate (same command as workflow `sdd-gates`) |

Note: there is no `npm run dev` at the root — specs and documentation repo (DOCS_SPECS profile).

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
| Workshop and transcripts | `doc/curso/aula-*.md` |
| SDD install guide (v1.6.1) | `doc/sistema-sdd-pedro.md` |
| GitHub Issues MCP (human operation) | `doc/sistema-sdd-pedro.md` §2.15 |
| UI module (C1-UI) | `doc/sistema-sdd-pedro.md` §2.11 · `doc/design/002-ui-module-install.md` |
| Probity module (G2) | `doc/sistema-sdd-pedro.md` §2.16 · `doc/design/004-probity-module-install.md` |
| SDD metrics (G4, mode C) | `doc/sistema-sdd-pedro.md` §2.17 · `bash scripts/sdd-metrics.sh` |
| Docs language / i18n (EN default, waves) | `doc/i18n/GLOSSARY.md` · `doc/i18n/WAVES.md` · `bash scripts/verify-i18n-wave.sh` |
| Install kit (SDD payload) | `sdd-kit/` |
| SDD upgrade (repo already installed) | `doc/sistema-sdd-pedro.md` §2.9 |
| CDP scripts / transcripts | `doc/curso/scripts/AGENTS.md` |
| TypeScript (when applicable) | `.cursor/rules/010-typescript.mdc` |
| Python | `.cursor/rules/020-python.mdc` |
| Supabase | `.cursor/rules/030-supabase.mdc` |
| Legacy / AS-IS | Ask for patterns **without creating files**; then document in `AGENTS.md` |
| Atomic tasks (Pattern, Gate) | `doc/sistema-sdd-pedro.md` §12.10 |
| Installed infra (MCP, CLIs, skills) | `openspec/infra.md` |
| Install kit (versioned payload) | `sdd-kit/` |
| CI gates (sdd-gates, operation) | `doc/sistema-sdd-pedro.md` §2.12 · `.github/workflows/sdd-gates.yml` |
| Supply chain (Renovate + OSV) | `doc/sistema-sdd-pedro.md` §2.13 |
| Integration evaluations / discarded tools | `doc/avaliacoes/` |
| Discovery / root README (EN) + vibe→agentic positioning | Public brand **ByeByeVibe** · `README.md` · `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (payload `sdd-kit/`) |
| Inserting new SDD tools (methodology + gaps) | `openspec/changes/explore-oss-coverage-gaps/` |
| Impeccable + shadcn — adoption guide | `doc/design/000-impeccable-design-system-guia.md` |
| Pipeline OD / Pencil / Figma → shadcn → Impeccable | `doc/design/001-pipeline-open-design-shadcn-impeccable.md` |
| UI module install (C1-UI) | `doc/design/002-ui-module-install.md` |
| UI stack adapters (no shadcn) | `doc/design/003-ui-stack-adapters.md` |

## Related documentation (design system)

| Document | Topic |
|----------|-------|
| [`doc/design/000-impeccable-design-system-guia.md`](./doc/design/000-impeccable-design-system-guia.md) | Impeccable + shadcn — adoption guide |
| [`doc/design/001-pipeline-open-design-shadcn-impeccable.md`](./doc/design/001-pipeline-open-design-shadcn-impeccable.md) | Pipeline OD / Pencil / Figma → shadcn → Impeccable |
| [`doc/design/002-ui-module-install.md`](./doc/design/002-ui-module-install.md) | C1-UI install (`install-ui-module.sh`) |
| [`doc/design/003-ui-stack-adapters.md`](./doc/design/003-ui-stack-adapters.md) | Adapters tailwind-custom / other |

> Integrated into the canonical guide `doc/sistema-sdd-pedro.md` §2.11 (v1.4.0).

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

**GitNexus** — Public repo **ByeByeVibe** (target slug `byebyevibe`; legacy index may remain `gitnexus-graphify-openspec` until reindex). Before editing symbols: `gitnexus_impact`. Before commit: `gitnexus_detect_changes`. Detail: `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md`.

**Graphify** — Read `graphify-out/GRAPH_REPORT.md` before grepping architecture questions. After editing code: `graphify update .`. Detail: `.cursor/rules/graphify.mdc`.

**github-mcp-server** — Passive MCP (mode D) for GitHub Issues context. Consult on types **B**, **D**, and **E** (optional on **C** if there is an issue); never on type **A**. In `/opsx:propose`, read the source issue when `**Issue:**` is filled; on B/D without an explicit issue, check open issues to avoid duplicates. Fill `**Issue:**` in `proposal.md` (URL, `#123`, or `—`). Cloud agents: read-only `gh` CLI covers ad-hoc queries — local MCP is for interactive sessions. Human operation: guide §2.15.

**Supply chain (Renovate + OSV-Scanner)** — Automatic gates independent of the A–E task in progress. Renovate PR: patch = type **A**; minor/major = type **B/C** (human review). Red OSV in CI = type **B** — fix the dependency before merge or `/opsx:archive`. Operation: guide §2.13.

**sdd-kit — checksum maintenance** — When editing any file under `sdd-kit/templates/`, run `bash sdd-kit/gen-manifest-checksums.sh` before committing to update the `sha256:` fields in the MANIFEST. Without this step, `install.sh` and `upgrade.sh --apply` will abort with an integrity error in consumer repos.

**CI Gates (sdd-gates)** — Workflow `.github/workflows/sdd-gates.yml` runs on `push`/`pull_request`, fail-closed: `openspec validate --all --strict` (blocking), `verify-task-patterns.sh` (blocking), **OSV-Scanner** (blocking when a lockfile is present), `sdd-kit/verify.sh` (report-only). Before push: run `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict` locally. Operation: guide §2.12.

**Probity (G2)** — Optional APP/HYBRID module: `bash sdd-kit/install-probity-module.sh --detect` → `--apply [--yes]`; pin `@nizos/probity@1.10.0`. A–E matrix: off on A (globs); on for B/C/D via `enforceTdd`. DOCS_SPECS without tests: SKIP. Operation: guide §2.16.

**SDD Metrics (G4)** — Local on-demand script (mode C): `bash scripts/sdd-metrics.sh [--since YYYY-MM-DD] [--output PATH]`. Markdown report (volume, lead time propose→archive, rework `fix` post-archive). Cadence: advisory nudge in the Session Handoff of `/opsx:archive` via `--check-cadence` (N=5 / T=30); Interpret→act playbook in §2.17. git+archive proxies; **do not** adopt Apache DevLake. No always-on skill/rule (R3 N/A).

## Testing

- Python scripts: validate manually or with tests when changing `doc/curso/scripts/*.py`
- OpenSpec: `npx openspec validate <change-id>` when applicable
- There is no `npm test` suite at the root of this repo

## PR and commits

- Conventional Commits: `feat(scope): desc`, `docs(sdd): …`, `fix(scope): …`
- Reference the change-id when relevant: `docs(sdd): guia v1.1 (update-sdd-install-guide-agents-format)`
- **Do not commit:** `graphify-out/`, `.gitnexus/`, `AGENTS.tools-generated.md`

## Post-implementation reviews (on-demand)

Skills invocable after code is written — **never** always-on, **never** block commit.

| Skill / agent | When to invoke | Do not invoke |
|---------------|----------------|---------------|
| `correctness-review` | Post-apply: Type B (always); Type C/D (diff > ~80 lines or > 4 files); explicit correctness request | Type A; Type E; during `/opsx:propose` |
| `simplify-review` | Post-apply or pre-PR: diff > ~80 lines or > 4 files; Type B/C/D; explicit simplicity request | Type A; during `/opsx:propose`; scope still under debate |
| `security-reviewer` | Auth, API routes, payments, sensitive data, webhooks | — |

Suggested order: implementation → tests (R6/Probity `enforceTdd`) → `correctness-review` (B/C/D) → `simplify-review` (optional) → `security-reviewer` (if applicable) → commit.

Skill detail: `.claude/skills/correctness-review/SKILL.md` · `.claude/skills/simplify-review/SKILL.md` (mirrors under `.cursor/skills/`).

## Subagents (Claude Code)

- `graphify-researcher` — theoretical research → `knowledge.md`
- `codebase-researcher` — AS-IS code → `codebase.md`
- `security-reviewer` — security audit

Type D: launch researchers **in parallel**.

## Security

**NEVER:** secrets in git-tracked files; `rm -rf` outside the repo; `--no-verify` without explaining; read `.env`.

**ALWAYS:** validate inputs (Zod/Pydantic); parameterized queries; sanitize LLM prompts.

## Communication

**F7 — chat vs artifacts:** human↔agent chat **MAY** use pt-BR; versioned repository artifacts (proposals, designs, specs, tasks, skills, guide prose, evaluations, kit templates) **MUST** be English after `sdd-docs-language` policy. Chat language does **not** authorize PT commits. Glossary / waves: `doc/i18n/`.

When replying to Pedro: pt-BR in chat; lead with the answer; direct evaluations; no unnecessary preamble.
