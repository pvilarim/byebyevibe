**Issue:** —

## Why

O hub SDD (`gitnexus-graphify-openspec`) **não tem `README.md` na raiz** e o `sdd-kit/README.md` é só operacional — o kit é invisível para quem pesquisa *vibe coding* / *spec-driven* no GitHub, apesar de ter diferenciais reais (OpenSpec + GitNexus + Graphify, gates, perfis, session locks). A exploração 2026-07-26 mapeou posicionamento, SEO e concorrência: precisamos (1) documentar essa análise como partida persistente e (2) materializar superfícies de discovery + um viés de produto que melhore o first-contact **sem** transformar o kit num boilerplate de app.

## What Changes

- **Documento canónico de análise** em `doc/avaliacoes/` (promovido a partir de `research.md` deste change) + linha no índice de avaliações — base para divulgação e para backlog de melhorias.
- **`README.md` na raiz (EN-first):** hero “From vibe coding to agentic engineering”, anti-boilerplate, demo `/opsx`, tabela do que inclui (incl. **SDD metrics / calibrate-as-you-go** — `research.md` §12; sem claim ML), compare resumido, CTA `install.sh --dry-run`, links ao guia pt-BR.
- **`sdd-kit/README.md`:** intro de posicionamento + mapa amigável C1/C2/G* → nomes humanos; manter secções operacionais.
- **Quickstart short-path** no guia (`doc/sistema-sdd-pedro.md`): secção curta “vibe coder em ~5 min” apontando ao README/kit (sem duplicar o guia).
- **Cross-refs:** `AGENTS.md`, `openspec/project.md`, `doc/avaliacoes/README.md`.
- **Checklist `[AÇÃO MANUAL NECESSÁRIA]`** para About + topics GitHub (não automatizável neste repo).
- **Specs:** nova capability `sdd-discovery-positioning`; delta em `sdd-install-kit` se o README do kit passar a exigir framing de discovery.
- **Backlog de produto (decisão 2026-07-26):** Landing/Discord/one-liner/BMAD/brand GitHub/scaffold — **não implementar**. **P5 (GIF)** — pending `/opsx:explore` após README (idealmente após nome). **P10 (nome) + tradução EN** — roadmap pós-README (`research.md` §11, `design.md` D10); **não** neste change.

## Capabilities

### New Capabilities

- `sdd-discovery-positioning`: Superfícies públicas de descoberta e posicionamento do SDD Kit (README raiz, avaliação de mercado, quickstart de first-contact, topics/About checklist); viés “from vibe coding to agentic engineering”; proíbe fingir app-scaffold.

### Modified Capabilities

- `sdd-install-kit`: `sdd-kit/README.md` MUST incluir framing de posicionamento/discovery para newcomers (além do conteúdo operacional C1–C3/G*).

## Impact

- Novos: `README.md` (raiz), `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`
- Modificados: `sdd-kit/README.md`, `doc/avaliacoes/README.md`, `doc/sistema-sdd-pedro.md` (secção quickstart + changelog), `AGENTS.md` / template se necessário, `openspec/project.md` (cross-ref)
- Specs: `openspec/specs/sdd-discovery-positioning/` (após archive); delta `sdd-install-kit`
- Dependências novas: nenhuma
- **Non-goals:** app starter/boilerplate; Discord; landing/Pages; one-liner fame; GIF/asciinema neste change (pending explore pós-README); rename/rebrand neste change (roadmap §11); tradução completa EN neste change (roadmap §11); adoptar BMAD multi-persona; perseguir “brand GitHub”; alterar fluxo `/opsx` ou MANIFEST de payloads (salvo menção documental)
- **Roadmap pós-apply (não escopo):** ver `research.md` §11 — README → nome → policy/waves EN → explore GIF; chat humano permanece pt-BR.
- **Issue:** — (API de issues indisponível nesta sessão; sem duplicata óbvia no histórico de changes)
- Fontes: `openspec/changes/add-sdd-discovery-positioning/research.md`
