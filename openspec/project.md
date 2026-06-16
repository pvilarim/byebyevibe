# Project: spec-pedro — Repositório de Especificações e Documentação

## Purpose

Repositório de specs, documentação técnica e cursos do Pedro Vilarim. Serve como base de conhecimento (via Graphify) e centro de especificações (via OpenSpec) para projectos de desenvolvimento assistido por IA — em especial o multi-agent bot e outros sistemas SDD. O sucesso é medido pela capacidade de qualquer agente de IA navegar, entender e propor mudanças fundamentadas neste repositório sem intervenção humana desnecessária.

## Stack

- **Runtime**: Node.js 22.x, Python 3.13
- **Framework UI**: Next.js 16+ (App Router), Tailwind CSS v3.4, shadcn/ui
- **Backend**: Next.js Server Actions + Supabase
- **Database**: Supabase (Postgres + pgvector + Auth)
- **LLM**: Anthropic Claude (primário)
- **Bundler**: Turbopack (dev) / Webpack (legacy)
- **Linguagem**: TypeScript 5.9+ (strict), Python 3.13+
- **Validação**: Zod (TS), Pydantic v2 (Python)
- **Ícones**: lucide-react
- **Testes**: Vitest (TS unit), pytest (Python)
- **IDEs**: Cursor ≥ 1.0, VS Code 1.109+ com Claude Code CLI ≥ 2.1.140
- **Ferramentas SDD**: OpenSpec 1.3.1, GitNexus 1.6.5, Graphify 0.8.5

## Architecture

- Repositório monorepo com `doc/` para especificações/cursos e `openspec/` para controlo de mudanças
- Documentação de curso em `doc/curso/` — transcrições enriched de aulas do Workshop IA 5/2026
- Código de produção vive em projectos separados; **este repo é perfil DOCS_SPECS** (sem app na raiz)
- `AGENTS.md` é o entry point universal (formato [agents.md](https://agents.md/), guia v1.2)
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
- Português (pt-BR) na comunicação; inglês em variáveis, commits e documentação técnica

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
- **Guia de instalação SDD:** `doc/sistema-sdd-pedro.md` **v1.2.0** — instalação §2; actualização §2.9
- **Integração Cline (futuro):** `doc/cline-integracao-sdd.md` — avaliação e roadmap; não implementado
- Comportamento de agentes: `AGENTS.md` (não duplicar regras aqui)

## Non-goals

- Não hosteamos LLM próprio — usar Claude via Anthropic API
- Não implementamos auth do zero — Supabase Auth
- Não usamos vector DB externo — Supabase pgvector
- Não duplicamos regras entre AGENTS.md e openspec/project.md — sempre apontar, nunca copiar
