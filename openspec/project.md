# Project: spec-pedro — Repositório de Especificações e Documentação

## Purpose

Repositório de specs, documentação técnica e cursos do Pedro Vilarim. Serve como base de conhecimento (via Graphify) e centro de especificações (via OpenSpec) para projectos de desenvolvimento assistido por IA — em especial o multi-agent bot e outros sistemas SDD. O sucesso é medido pela capacidade de qualquer agente de IA navegar, entender e propor mudanças fundamentadas neste repositório sem intervenção humana desnecessária.

## Stack

- **Runtime**: Node.js 22.x, Python 3.13
- **Framework UI**: Next.js 16+ (App Router), Tailwind CSS v3.4, shadcn/ui
- **UI stack**: none (shadcn | tailwind-custom | other | none) — registado após C1-UI; ver `doc/sistema-sdd-pedro.md` §2.11
- **Backend**: Next.js Server Actions + Supabase
- **Database**: Supabase (Postgres + pgvector + Auth)
- **LLM**: Anthropic Claude (primário)
- **Bundler**: Turbopack (dev) / Webpack (legacy)
- **Linguagem**: TypeScript 5.9+ (strict), Python 3.13+
- **Validação**: Zod (TS), Pydantic v2 (Python)
- **Ícones**: lucide-react
- **Testes**: Vitest (TS unit), pytest (Python); em APP/HYBRID, Probity (G2) opcional materializa R6 via `enforceTdd` — `sdd-kit/install-probity-module.sh`
- **IDEs**: Cursor ≥ 1.0, VS Code 1.109+ com Claude Code CLI ≥ 2.1.140
- **Ferramentas SDD**: OpenSpec 1.3.1, GitNexus 1.6.5, Graphify 0.8.5

## Architecture

- Repositório monorepo com `doc/` para especificações/cursos e `openspec/` para controlo de mudanças
- Documentação de curso em `doc/curso/` — transcrições enriched de aulas do Workshop IA 5/2026
- Código de produção vive em projectos separados; **este repo é perfil DOCS_SPECS** (sem app na raiz)
- `AGENTS.md` é o entry point universal (formato [agents.md](https://agents.md/), guia v1.3)
- `graphify-out/` mantém o knowledge graph do repositório (regenerável, gitignored)
- `.gitnexus/` mantém o code graph (regenerável, gitignored)

## Conventions

- Ficheiros em kebab-case; componentes React em PascalCase; funções/variáveis em camelCase
- Commits seguem Conventional Commits: `feat(scope): desc`, `fix(scope): desc`, `chore: desc`
- Change IDs no formato `verb-noun-modifier` (ex: `add-user-validation`, `refactor-auth-service`)
- Sem exports default — usar named exports
- Imports: absolutos com `@/` para internos, relativos apenas para siblings
- `cn()` (clsx + tailwind-merge) para composição de classes Tailwind
- Sem estilos inline; usar classes Tailwind e variáveis CSS semânticas
- Componentes novos em `components/ui/` com Props tipadas e `className?: string`
- **Language (F7):** versioned artifacts MUST be English (canonical default — `sdd-docs-language`); human↔agent chat MAY remain pt-BR; variables/commits stay English. Legacy PT in files is replaced by waves (`doc/i18n/`)

## Constraints

- Secrets NUNCA em ficheiros git — usar `.env` (gitignored) ou variáveis de ambiente
- RLS habilitado em todas as tabelas Supabase
- Rate-limiting em rotas sensíveis (auth, pagamentos)
- Cookies de sessão: HttpOnly, Secure, SameSite=Strict/Lax
- Validação Zod em todas as fronteiras de entrada (API routes, Server Actions, webhooks)

## Cross-references

- Code graph: `.gitnexus/` (via MCP tools: `query`, `context`, `impact`)
- Knowledge graph: `graphify-out/GRAPH_REPORT.md` + MCP graphify
- Specs activas: `openspec/specs/`
- Mudanças em curso: `openspec/changes/`
- Documentação do curso: `doc/curso/` (5 aulas do Workshop IA 5/2026)
- **Guia de instalação SDD:** `doc/sistema-sdd-pedro.md` **v1.6.1** — instalação §2 + `sdd-kit/install.sh`; actualização §2.9 + `sdd-kit/upgrade.sh`; módulo UI §2.11 + `sdd-kit/install-ui-module.sh`; gates de CI §2.12; Probity (G2) §2.16 + `sdd-kit/install-probity-module.sh`; métricas SDD (G4) §2.17 + `scripts/sdd-metrics.sh` (playbook + cadência `--check-cadence`)
- **Install kit:** `sdd-kit/` (MANIFEST v1.6.1) — payloads versionados para C1/C2/C1-UI/G2/G4 + workflow `sdd-gates`
- **Módulo UI (design system):** `doc/design/` — `002-ui-module-install.md`, `001-pipeline-open-design-shadcn-impeccable.md`
- **Avaliações de integração (histórico):** `doc/avaliacoes/` — ferramentas pesquisadas para o stack SDD
- **Discovery / posicionamento (hub):** marca pública **ByeByeVibe** — `README.md` (EN) — from vibe coding to shippable AI engineering; payload em `sdd-kit/`; análise e backlog em `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`; first-contact no guia §2.0b
- Comportamento de agentes: `AGENTS.md` (não duplicar regras aqui)

## Non-goals

- Não hosteamos LLM próprio — usar Claude via Anthropic API
- Não implementamos auth do zero — Supabase Auth
- Não usamos vector DB externo — Supabase pgvector
- Não duplicamos regras entre AGENTS.md e openspec/project.md — sempre apontar, nunca copiar
- Não integramos Headroom nem compressão automática de contexto no pipeline SDD — avaliado e descartado (ver `doc/avaliacoes/2026-03-26-headroom-context-compression.md`)
