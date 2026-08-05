# Project: spec-pedro — Specifications and Documentation Repository

## Purpose

Repository of specs, technical documentation, and courses by Pedro Vilarim. It serves as a knowledge base (via Graphify) and a specification hub (via OpenSpec) for AI-assisted development projects — especially the multi-agent bot and other SDD systems. Success is measured by any AI agent’s ability to navigate, understand, and propose well-founded changes in this repository without unnecessary human intervention.

## Stack

- **Runtime**: Node.js 22.x, Python 3.13
- **UI Framework**: Next.js 16+ (App Router), Tailwind CSS v3.4, shadcn/ui
- **UI stack**: none (shadcn | tailwind-custom | other | none) — recorded after C1-UI; see `doc/byebyevibe-guide.md` §2.11
- **Backend**: Next.js Server Actions + Supabase
- **Database**: Supabase (Postgres + pgvector + Auth)
- **LLM**: Anthropic Claude (primary)
- **Bundler**: Turbopack (dev) / Webpack (legacy)
- **Language**: TypeScript 5.9+ (strict), Python 3.13+
- **Validation**: Zod (TS), Pydantic v2 (Python)
- **Icons**: lucide-react
- **Tests**: Vitest (TS unit), pytest (Python); in APP/HYBRID, optional Probity (G2) materializes R6 via `enforceTdd` — `sdd-kit/install-probity-module.sh`
- **IDEs**: Cursor ≥ 1.0, VS Code 1.109+ with Claude Code CLI ≥ 2.1.140
- **SDD tools**: OpenSpec 1.3.1, GitNexus 1.6.5, Graphify 0.8.5

## Architecture

- Monorepo with `doc/` for specifications/courses and `openspec/` for change control
- Course documentation under `doc/curso/` — enriched transcripts from Workshop IA 5/2026
- Production code lives in separate projects; **this repo is a DOCS_SPECS profile** (no app at the root)
- `AGENTS.md` is the universal entry point ([agents.md](https://agents.md/) format, guide v1.3)
- `graphify-out/` holds the repository knowledge graph (regenerable, gitignored)
- `.gitnexus/` holds the code graph (regenerable, gitignored)

## Conventions

- Files in kebab-case; React components in PascalCase; functions/variables in camelCase
- Commits follow Conventional Commits: `feat(scope): desc`, `fix(scope): desc`, `chore: desc`
- Change IDs in `verb-noun-modifier` form (e.g. `add-user-validation`, `refactor-auth-service`)
- No default exports — use named exports
- Imports: absolute with `@/` for internals, relative only for siblings
- `cn()` (clsx + tailwind-merge) for Tailwind class composition
- No inline styles; use Tailwind classes and semantic CSS variables
- New components under `components/ui/` with typed Props and `className?: string`
- **Language (F7):** versioned artifacts MUST be English (canonical default — `sdd-docs-language`); human↔agent chat MAY remain pt-BR; variables/commits stay English. Legacy PT in files is replaced by waves (`doc/i18n/`)

## Constraints

- Secrets NEVER in git-tracked files — use `.env` (gitignored) or environment variables
- RLS enabled on all Supabase tables
- Rate-limiting on sensitive routes (auth, payments)
- Session cookies: HttpOnly, Secure, SameSite=Strict/Lax
- Zod validation at all input boundaries (API routes, Server Actions, webhooks)

## Cross-references

- Code graph: `.gitnexus/` (via MCP tools: `query`, `context`, `impact`)
- Knowledge graph: `graphify-out/GRAPH_REPORT.md` + MCP graphify
- Active specs: `openspec/specs/`
- In-progress changes: `openspec/changes/`
- Course documentation: `doc/curso/` (5 lessons from Workshop IA 5/2026)
- Guide renamed 2026-08: `doc/sistema-sdd-pedro.md` → `doc/byebyevibe-guide.md` (kit v1.7.0); archives/pre-rename specs cite the old name.
- **SDD install guide:** `doc/byebyevibe-guide.md` **v1.9.0** — install §2 + `sdd-kit/install.sh`; upgrade §2.9 + `sdd-kit/upgrade.sh`; UI module §2.11 + `sdd-kit/install-ui-module.sh`; CI gates §2.12; Probity (G2) §2.16 + `sdd-kit/install-probity-module.sh`; SDD metrics (G4) §2.17 + `scripts/sdd-metrics.sh` (playbook + cadence `--check-cadence`)
- **Install kit:** `sdd-kit/` (MANIFEST v1.9.0) — versioned payloads for C1/C2/C1-UI/G2/G4 + workflow `sdd-gates`
- **UI module (design system):** `doc/design/` — `002-ui-module-install.md`, `001-pipeline-open-design-shadcn-impeccable.md`
- **Integration evaluations (historical):** `doc/avaliacoes/` — tools researched for the SDD stack
- **Discovery / positioning (hub):** public brand **ByeByeVibe** — `README.md` (EN) — from vibe coding to shippable AI engineering; payload in `sdd-kit/`; analysis and backlog in `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`; first-contact in guide §2.0b
- Agent behavior: `AGENTS.md` (do not duplicate rules here)

## Non-goals

- We do not host our own LLM — use Claude via Anthropic API
- We do not implement auth from scratch — Supabase Auth
- We do not use an external vector DB — Supabase pgvector
- We do not duplicate rules between AGENTS.md and openspec/project.md — always point, never copy
- We do not integrate Headroom or automatic context compression into the SDD pipeline — evaluated and discarded (see `doc/avaliacoes/2026-03-26-headroom-context-compression.md`)
