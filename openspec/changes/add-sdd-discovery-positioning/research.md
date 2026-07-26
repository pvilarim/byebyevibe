# Research — Posicionamento e descoberta do SDD Kit (vibe coding → agentic engineering)

| Campo | Valor |
|-------|-------|
| **Data** | 2026-07-26 |
| **Change** | `add-sdd-discovery-positioning` (tipo D — feature; research ancorado em explore) |
| **Objectivo** | Documentar análise de mercado/SEO/concorrência e derivar (1) superfície de divulgação e (2) backlog de melhorias de produto alinhadas ao público que busca *vibe coding kits* |
| **Fontes** | Explore 2026-07-26; GitHub API (stars/topics); READMEs Spec Kit / OpenSpec / BMAD; `sdd-kit/README.md`; `doc/sistema-sdd-pedro.md`; `openspec/project.md`; `openspec/changes/explore-oss-coverage-gaps/research.md` |

## 1. Diagnóstico AS-IS

| Superfície | Estado | Efeito |
|------------|--------|--------|
| `README.md` na raiz do hub | **Ausente** | Repo invisível em buscas GitHub por descrição/README |
| `sdd-kit/README.md` | Operacional (C1/C2/G2/G4) | Serve operadores; **não** serve discovery nem iniciantes vibe coding |
| `doc/sistema-sdd-pedro.md` | Guia profundo v1.6.1 | Excelente pós-adopção; fricção alta como primeiro contacto |
| About / topics do repo | Não optimizados para `vibe-coding` / `spec-driven-development` | Perde tráfego do topic mais quente do ecossistema agentic |

**Paradoxo do público:** quem busca *vibe coding* quer `prompt → app → ship`. Este repo entrega governação de agentes (`explore → propose → apply → archive` + graphs + gates). O gancho de mercado que funciona (Spec Kit, OpenSpec, GSD, best-practice repos) é:

> **“Vibe coding até o primeiro PR. Depois disto, agentic engineering.”**

Atrair com a dor; vender a cura (SDD operacionalizado) — **sem** fingir ser boilerplate Next.js.

## 2. Posicionamento proposto

**Frase canónica (EN, discovery):**

> The missing operating system between your coding agent and a maintainable repo.  
> Specs, graphs, gates, and session discipline — packaged so vibe coders don't invent process from scratch.

**Tagline curta:**

> From vibe coding to shippable AI engineering.

**Anti-posicionamento (obrigatório no hero):**

> Not another Next.js / full-stack starter. The control plane your starter is missing.

**Nome público (working):** “SDD Install Kit” / “SDD Kit” — rebrand agressivo fica fora de escopo deste change (decisão humana).

## 3. Termos-chave e SEO GitHub

### 3.1 Topics de alto tráfego (API GitHub, ~2026-07-26)

| Termo | Por que importa |
|-------|-----------------|
| `vibe-coding` / `vibecoding` | Topic massivo; repos 10k–100k★ |
| `spec-driven-development` / `sdd` | Intenção “upgrade do vibe” |
| `context-engineering` | Linguagem TLC / agentes sérios |
| `agentic-coding` / `agentic-engineering` | “além do chat” |
| `claude-code` / `cursor` | Ferramenta do dia a dia |
| `agent-skills` | Formato SKILL.md |
| `agents-md` / menção a AGENTS.md | Standard multi-agente |
| `mcp` | Extensibilidade |
| `prd` / `specification` | Spec Kit / OpenSpec SEO |

### 3.2 Queries que o público digita

```
vibe coding starter kit
vibe coding template cursor
from vibe coding to / stop vibe coding
spec driven development cursor
AGENTS.md template
claude code best practices
openspec install
cursor rules + specs
AI coding agent workflow
context engineering repo
```

### 3.3 About sugerido (≤160 chars)

> Spec-driven toolkit for Cursor & Claude Code: OpenSpec + GitNexus + Graphify, AGENTS.md, CI gates, TDD enforce. Upgrade vibe coding to agentic engineering.

## 4. Rede semântica — features ↔ projectos associados

```
VIBE CODING (dor/entrada)
        │ "from vibe →"
        ▼
┌───────────────────────────────────────┐
│  ESTE KIT (OS / control plane)        │
│  install + AGENTS.md + gates          │
└───────────────┬───────────────────────┘
     ┌──────────┼──────────┬────────────┐
     ▼          ▼          ▼            ▼
 OpenSpec   GitNexus   Graphify     Probity
 /opsx:*    code graph knowledge    enforceTdd
     │          │          │            │
     └──────────┴────┬─────┴────────────┘
                     ▼
              CI sdd-gates · session locks · metrics G4
```

| Cluster | Features nossas | Associar publicamente a |
|---------|-----------------|-------------------------|
| Spec / SDD | `/opsx:*`, `openspec/` | OpenSpec, Spec Kit, GSD |
| Context | AGENTS.md único | agents.md, Context7 |
| Code intelligence | GitNexus impact | GitNexus |
| Knowledge | Graphify GRAPH_REPORT | graph RAG / Understand-Anything (adjacente) |
| Quality | sdd-gates, Probity | CI fail-closed, TDD |
| Design/UI | C1-UI | open-design, DESIGN.md (módulo opcional) |
| Anti-caos | session coordination | diferencial raro |

## 5. Concorrência — como se vendem; gaps

Stars ≈ 2026-07-26 via GitHub API (ordem de grandeza).

### 5.1 Camada A — frameworks SDD (vizinhos)

| Projecto | ★ | Pitch / hack | Eles oferecem; nós não | Nós oferecemos; eles não |
|----------|---|--------------|------------------------|---------------------------|
| github/spec-kit | ~124k | “Define before build”; slash `/speckit.*`; brand GitHub | Distribuição, polish, 20+ agents, site | Triplo OpenSpec+GitNexus+Graphify; AGENTS.md anti-overwrite; perfis; kit C1/C2 versionado; Probity; métricas; session locks |
| Fission-AI/OpenSpec | ~63k | “most loved”; fluid/brownfield; demo `/opsx` | O CLI de specs (nós **consumimos**) | Orquestração graphs+CI+install kit+guia |
| BMAD-METHOD | ~51k | Agile AI team; 12+ personas | Multi-persona theatre | Menos cerimónia; brownfield; CI/TDD; dual-graph |
| gsd-build/get-shit-done | ~65k | Meta-prompting Claude Code | Autonomia longa | Multi-IDE; Graphify+GitNexus; supply-chain |
| gotalab/cc-sdd | ~3.5k | Specs → autonomous impl | Harness multi-CLI | Upgrade path; profiles; métricas |

### 5.2 Camada B — vibe templates (mesma busca, produto diferente)

| Projecto | ★ | Pitch | Nota |
|----------|---|-------|------|
| di-sukharev/vibe | ~0.5k | Bun/Hono/React template | App scaffold |
| humanstack/vibe-coding-template | ~0.2k | Next+FastAPI+Supabase | Boilerplate |
| kenrogers/vibe-coders-starter-kit | ~1 | TDD + Clerk/Convex | App + skills |
| VoloBuilds/create-volo-app | ~0.1k | Full-stack 30s | Scaffolding |

**Insight:** `vibe coding template` → Camada B. `spec-driven` / `from vibe coding to` → Camada A. O README ideal **aparece nas duas**, com disambiguação em 2 linhas.

### 5.3 Matriz compacta

```
                 Spec    Multi-agent  Code graph  Knowledge  Install kit  CI/TDD
Spec Kit         ●●●●    ●●           ○           ○          ●●●          ●●
OpenSpec         ●●●●    ●●           ○           ○          ●●           ●
BMAD             ●●●     ●●●●         ○           ○          ●●●          ●●
GSD              ●●●     ●●●          ○           ○          ●●           ●
Vibe boilerplates ○      ○            ○           ○          ●●●● (app)   ●
ESTE KIT         ●●●●    ●●           ●●●●        ●●●●       ●●●●         ●●●●
```

### 5.4 Diferenciais defensáveis (ancoráveis)

1. Stack composto documentado (OpenSpec + GitNexus + Graphify) + ordem de install + anti-overwrite `AGENTS.md`
2. Payload versionado (`MANIFEST.yaml`, upgrade C2)
3. Perfis APP / DOCS_SPECS / HYBRID
4. Gates reais (validate + OSV + Probity) — não só prompts
5. Session coordination (worktree locks)

### 5.5 O que falta para competir em discovery (não em método)

| Gap de divulgação | Severidade | Notas |
|-------------------|------------|-------|
| README raiz ausente | Crítica | Este change |
| Sem demo narrativa tipo OpenSpec | Alta | Copiar padrão diálogo `/opsx` |
| Sem GIF / site / Discord | Média | Follow-up; não bloquear |
| Topics/About não alinhados | Alta | `[AÇÃO MANUAL]` no GitHub Settings |
| Jargão C1/G4 no first contact | Média | Mapa “nome amigável → código” |
| Nome do repo `gitnexus-graphify-openspec` | Média | SEO fraco vs “sdd-kit”; rename = decisão humana |

## 6. Viés duplo — divulgação + melhorias de produto

### 6.1 Este change (descoberta + documentação canónica)

- Documento persistente em `doc/avaliacoes/` (esta análise)
- `README.md` raiz (EN-first, hero + demo + compare + CTA)
- Intro de posicionamento em `sdd-kit/README.md` (sem remover ops)
- Ponteiros no guia / AGENTS / project / índice de avaliações
- Spec normativa de superfícies de discovery
- Checklist `[AÇÃO MANUAL]` para About + topics no GitHub

### 6.2 Backlog de produto derivado da análise (fora ou parcial deste change)

| ID | Melhoria | Origem do gap | Prioridade | Escopo / decisão (2026-07-26) |
|----|----------|---------------|------------|------------------------------|
| P1 | README + topics + avaliação | Invisibilidade | P0 | **Este change** (apply) |
| P2 | Quickstart “vibe coder em 5 min” no guia (§ curto) | Fricção do guia longo | P0 | **Este change** (apply) |
| P3 | Mapa amigável C1/C2/G2 → nomes humanos no README/kit | Jargão | P1 | **Este change** (apply) |
| P4 | Template de “compare table” actualizável (stars datados) | Concorrência muda | P1 | **Este change** (apply; na avaliação) |
| P5 | Demo GIF / asciinema do fluxo opsx | OpenSpec/Spec Kit polish | — | **Explorar antes de implementar** — ver §6.3 |
| P6 | `npx` / one-liner bootstrap “famoso” | Spec Kit `uv tool install` | — | **Não implementar** (CTA actual `install.sh --dry-run` basta; risco supply-chain) |
| P7 | Página docs (GitHub Pages / landing) | Spec Kit site | — | **Não implementar** |
| P8 | Comunidade Discord | OpenSpec/BMAD | — | **Não implementar** |
| P9 | Módulo “app starter” (auth/DB/deploy) | Camada B | — | **Não implementar** (non-goal permanente) |
| P10 | Rename / nome público do projecto | SEO / identidade | — | **Depois do README** — explore→propose→apply dedicados (§11); **não** neste change |
| — | Multi-persona theatre (BMAD) | BMAD-METHOD | — | **Não implementar** (skills/subagentes locais bastam; evita 2º orquestrador) |
| — | Tradução completa do hub para inglês | Descoberta global + policy | — | **Depois do nome estável** — policy + waves (§11); **não** neste change |

**Princípio de produto:** melhorar o kit para o iniciante **sem** diluir o diferencial (control plane). Qualquer feature que nos transforme em “mais um vibe template” é rejeitada.

### 6.3 Decisão de produto — gaps de concorrência (explore 2026-07-26)

**Confirmação humana:** Landing, Discord, one-liner fame, app scaffold, BMAD multi-persona e brand GitHub — **não implementar**. Permanecem fora do roadmap activo.

**No roadmap (fora deste apply), com ordem fixa — ver §11:** novo nome público (P10) → tradução EN completa + policy → explore GIF (P5).

**P5 (1b GIF / asciinema):** **não implementar ainda.** Precisa de **exploração dedicada** (`/opsx:explore`) sobre *como* integrar, antes de qualquer propose/apply. Preferir **depois** do README e, idealmente, do nome estável (§11). Questões em aberto:

| # | Pergunta de integração |
|---|------------------------|
| E1 | Formato: GIF vs asciinema vs SVG terminal vs vídeo curto — trade-off tamanho git vs fidelidade |
| E2 | Onde vive o asset: `docs/media/`, GitHub release, ou só link externo |
| E3 | O que gravar: só `/opsx:propose→archive` ou também `install.sh --dry-run` |
| E4 | Como evitar drift quando slash commands / skills mudarem (pipeline de regravação? texto-primeiro no README?) |
| E5 | Relação com o README: placeholder “Demo (TBD)” vs secção só texto até a explore fechar |
| E6 | Licença/ferramentas de gravação e se entram no `openspec/infra.md` (R10) |

**Change sugerido (futuro, após explore):** ex. `explore-sdd-demo-asciinema` → só então `/opsx:propose` se a integração for clara.

**Nota:** P1–P4 (README, quickstart, mapa amigável, avaliação) **continuam** no escopo de `add-sdd-discovery-positioning` — são discovery documental, não os gaps de “fame” acima.

## 7. Estrutura recomendada do README raiz

1. Hero (tagline + anti-boilerplate + CTA `install.sh --dry-run`)
2. Problem (agente esquece / alucina / sobrescreve AGENTS.md)
3. Demo texto (`/opsx:explore → propose → apply → archive`)
4. What's included (tabela: specs / code graph / knowledge / gates / UI / Probity)
5. Not another starter kit
6. 30-second install + perfis
7. Who it's for
8. Compare (resumo; detalhe na avaliação)
9. Stack & companions (links OpenSpec, GitNexus, Graphify, agents.md)
10. Docs (guia pt-BR, kit README)

Idioma: **EN no README raiz** (descoberta GitHub). Avaliação e guia neste apply podem permanecer **pt-BR** até à wave de i18n (research §11 passo ④).

## 8. Riscos

| Risco | Mitigação |
|-------|-----------|
| Atrair utilizadores que querem só boilerplate e abandonam | Anti-posicionamento explícito no hero |
| Tom “stop vibe coding” alienar | Preferir “from vibe coding to…” |
| Stars desatualizados no README | Datados + “ordem de grandeza”; detalhe só em `doc/avaliacoes/` |
| Duplicar o guia no README | README ≤ ~150–200 linhas; deep dive no guia |
| Prometer rename / i18n / GIF neste change | Non-goals + roadmap §11 / D10 |

## 9. Decisões a confirmar no apply (defaults deste propose)

| Questão | Default adoptado neste change |
|---------|-------------------------------|
| Audiência primária | Solo / small team em Cursor ou Claude Code, a sair do vibe caótico |
| Idioma README raiz | EN-first |
| Agressividade do tom | “From vibe → agentic”, não “stop vibe” |
| Nome público | Working title “SDD Kit” neste apply; **rename real = passo ②–③ do §11** (não neste change) |
| App scaffold | Non-goal permanente |
| P5 GIF/asciinema | **Não neste apply** — explore de integração após README (§6.3, §11 passo ⑤) |
| P6–P8, BMAD, Landing, Discord, brand GitHub | **Não implementar** (decisão 2026-07-26) |
| Tradução completa EN | **Não neste apply** — após nome estável (§11 passos ④) |

## 10. Referências

- Explore sessão 2026-07-26 (chat); este ficheiro é a memória persistente
- `sdd-kit/README.md` — AS-IS operacional
- `doc/sistema-sdd-pedro.md` — procedimento canónico
- `openspec/changes/explore-oss-coverage-gaps/research.md` — gaps de tooling (complementar, não substitui)
- GitHub: `github/spec-kit`, `Fission-AI/OpenSpec`, `bmad-code-org/BMAD-METHOD`, `gsd-build/get-shit-done`, topic `vibe-coding`
- agents.md — https://agents.md/

## 11. Roadmap de divulgação e i18n — sequência e razões (2026-07-26)

Registo pré-apply (pedido humano): ordem das melhorias de discovery, rebrand, tradução e demo visual — e **porquê** nesta ordem. Administrar como **backlog OpenSpec** (um change por fatia), não como mega-PR.

### 11.1 Sequência canónica

```
①  APPLY   add-sdd-discovery-positioning     ← próximo
    README (EN) + avaliação + quickstart + mapa kit
    Demo = texto · About/topics = checklist manual
         │
         ▼
②  EXPLORE → PROPOSE   nome público (rebrand)
    Escolher nome · impacto repo/URLs/MANIFEST/docs
    NÃO traduzir o hub inteiro antes disto
         │
         ▼
③  APPLY   rename / rebrand (quando aprovado)
    Títulos, About, links, guia, AGENTS pointers
    [AÇÃO MANUAL] rename no GitHub se mudar o slug do repo
         │
         ▼
④  EXPLORE → PROPOSE   política EN + migração
    “Novos artefactos = EN” · inventário do que ainda é pt-BR
    Traduzir por waves (guia §, avaliações, skills…)
    Chat humano Contigo: pt-BR (velocidade) — permanente
         │
         ▼
⑤  EXPLORE   GIF/asciinema (P5) → propose só se integração fechar
         │
         ▼
⑥  Landing / Discord / one-liner fame — fora do roadmap (D9)
```

### 11.2 Changes OpenSpec sugeridos (administração)

| Ordem | Change (id sugerido) | Fase |
|------:|----------------------|------|
| 1 | `add-sdd-discovery-positioning` | **apply a seguir** |
| 2 | `explore-sdd-kit-public-name` → `rename-…` | explore → propose → apply |
| 3 | `add-english-docs-policy` | propose curto (AGENTS.md / project.md) |
| 4 | `translate-sdd-guide-en` (+ waves) | vários applies |
| 5 | `explore-sdd-demo-asciinema` | explore → ? propose |

### 11.3 Razões (porquê esta ordem)

| Passo | Razão |
|-------|--------|
| **① README antes de tudo** | Buraco crítico de discovery; desbloqueia GitHub sem depender de rename nem i18n. Working title (“SDD Kit”) basta; o nome real actualiza-se no ③. |
| **②–③ Nome antes da tradução total** | Traduzir com a marca antiga = retrabalho em massa (duas traduções). Rebrand toca URLs, About, títulos, cross-refs — change próprio com blast radius explícito. |
| **④ Tradução depois do nome** | Um (ou N) changes só de i18n, com inventário e gates. Specs em `openspec/specs/` muitas já estão em EN — não assumir rewrite total cego. |
| **⑤ GIF depois do README (e idealmente do nome)** | Narrativa e marca estáveis; evita regravar o demo. Integração (E1–E6) ainda por explorar — **não** misturar no apply ①. |
| **⑥ Fame gaps fora** | Landing/Discord/one-liner/scaffold/BMAD/brand GitHub não são necessidade do sistema (D9). |

### 11.4 Política linguística alvo (após passo ④)

| Superfície | Idioma |
|------------|--------|
| Chat Contigo (Pedro ↔ agente) | **pt-BR** (velocidade) — já em AGENTS.md |
| Artefactos **novos** (proposal, design, specs, README, guia) | **inglês** |
| Código / change-ids / paths | inglês / kebab-case (já) |
| Legado pt-BR | waves de tradução; **não** bloquear features à espera de 100% |

### 11.5 O que este apply (①) NÃO faz

- Não escolhe nem aplica o nome final do projecto
- Não traduz o guia / avaliações / skills para EN
- Não grava GIF/asciinema
- Não cria Landing, Discord, one-liner viral, scaffold, nem BMAD

Idioma neste apply: README raiz **EN**; avaliação e quickstart no guia podem permanecer **pt-BR** até à wave ④ (consistente com o hub actual).
