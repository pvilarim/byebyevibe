# Research — SDD Kit positioning and discovery (vibe coding → agentic engineering)

| Field | Value |
|-------|-------|
| **Date** | 2026-07-26 |
| **Change** | `add-sdd-discovery-positioning` (type D — feature; research anchored in explore) |
| **Objective** | Document market/SEO/competition analysis and derive (1) discovery surface and (2) product improvement backlog aligned with audiences searching for *vibe coding kits* |
| **Sources** | Explore 2026-07-26; GitHub API (stars/topics); Spec Kit / OpenSpec / BMAD READMEs; `sdd-kit/README.md`; `doc/sistema-sdd-pedro.md`; `openspec/project.md`; `openspec/changes/explore-oss-coverage-gaps/research.md` |

## 1. AS-IS diagnosis

| Surface | State | Effect |
|------------|--------|--------|
| Root `README.md` on the hub | **Missing** | Repo invisible in GitHub searches by description/README |
| `sdd-kit/README.md` | Operational (C1/C2/G2/G4) | Serves operators; **does not** serve discovery or vibe-coding beginners |
| `doc/sistema-sdd-pedro.md` | Deep guide v1.6.1 | Excellent post-adoption; high friction as first contact |
| Repo About / topics | Not optimized for `vibe-coding` / `spec-driven-development` | Loses traffic from the hottest topic in the agentic ecosystem |

**Audience paradox:** people searching for *vibe coding* want `prompt → app → ship`. This repo delivers agent governance (`explore → propose → apply → archive` + graphs + gates). The market hook that works (Spec Kit, OpenSpec, GSD, best-practice repos) is:

> **"Vibe coding until the first PR. After that, agentic engineering."**

Attract with the pain; sell the cure (operationalized SDD) — **without** pretending to be a Next.js boilerplate.

## 2. Proposed positioning

**Canonical phrase (EN, discovery):**

> The missing operating system between your coding agent and a maintainable repo.  
> Specs, graphs, gates, and session discipline — packaged so vibe coders don't invent process from scratch.

**Short tagline:**

> From vibe coding to shippable AI engineering.

**Anti-positioning (required in the hero):**

> Not another Next.js / full-stack starter. The control plane your starter is missing.

**Public name (working):** "SDD Install Kit" / "SDD Kit" — aggressive rebrand is out of scope for this change (human decision).

## 3. Keywords and GitHub SEO

### 3.1 High-traffic topics (GitHub API, ~2026-07-26)

| Term | Why it matters |
|-------|-----------------|
| `vibe-coding` / `vibecoding` | Massive topic; repos 10k–100k★ |
| `spec-driven-development` / `sdd` | "Upgrade from vibe" intent |
| `context-engineering` | Serious agent / TLC language |
| `agentic-coding` / `agentic-engineering` | "beyond chat" |
| `claude-code` / `cursor` | Day-to-day tools |
| `agent-skills` | SKILL.md format |
| `agents-md` / AGENTS.md mention | Multi-agent standard |
| `mcp` | Extensibility |
| `prd` / `specification` | Spec Kit / OpenSpec SEO |

### 3.2 Queries the audience types

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

### 3.3 Suggested About (≤160 chars)

> Spec-driven toolkit for Cursor & Claude Code: OpenSpec + GitNexus + Graphify, AGENTS.md, CI gates, TDD enforce. Upgrade vibe coding to agentic engineering.

## 4. Semantic network — features ↔ associated projects

```
VIBE CODING (pain/entry)
        │ "from vibe →"
        ▼
┌───────────────────────────────────────┐
│  THIS KIT (OS / control plane)        │
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

| Cluster | Our features | Publicly associate with |
|---------|-----------------|-------------------------|
| Spec / SDD | `/opsx:*`, `openspec/` | OpenSpec, Spec Kit, GSD |
| Context | Single AGENTS.md | agents.md, Context7 |
| Code intelligence | GitNexus impact | GitNexus |
| Knowledge | Graphify GRAPH_REPORT | graph RAG / Understand-Anything (adjacent) |
| Quality | sdd-gates, Probity | CI fail-closed, TDD |
| Design/UI | C1-UI | open-design, DESIGN.md (optional module) |
| Anti-chaos | session coordination | rare differentiator |

## 5. Competition — how they sell; gaps

Stars ≈ 2026-07-26 via GitHub API (order of magnitude).

### 5.1 Layer A — SDD frameworks (neighbors)

| Project | ★ | Pitch / hack | They offer; we don't | We offer; they don't |
|----------|---|--------------|------------------------|---------------------------|
| github/spec-kit | ~124k | "Define before build"; slash `/speckit.*`; GitHub brand | Distribution, polish, 20+ agents, site | Triple OpenSpec+GitNexus+Graphify; AGENTS.md anti-overwrite; profiles; versioned C1/C2 kit; Probity; metrics; session locks |
| Fission-AI/OpenSpec | ~63k | "most loved"; fluid/brownfield; demo `/opsx` | The specs CLI (we **consume** it) | Graphs+CI+install kit+guide orchestration |
| BMAD-METHOD | ~51k | Agile AI team; 12+ personas | Multi-persona theatre | Less ceremony; brownfield; CI/TDD; dual-graph |
| gsd-build/get-shit-done | ~65k | Meta-prompting Claude Code | Long autonomy | Multi-IDE; Graphify+GitNexus; supply-chain |
| gotalab/cc-sdd | ~3.5k | Specs → autonomous impl | Multi-CLI harness | Upgrade path; profiles; metrics |

### 5.2 Layer B — vibe templates (same search, different product)

| Project | ★ | Pitch | Note |
|----------|---|-------|------|
| di-sukharev/vibe | ~0.5k | Bun/Hono/React template | App scaffold |
| humanstack/vibe-coding-template | ~0.2k | Next+FastAPI+Supabase | Boilerplate |
| kenrogers/vibe-coders-starter-kit | ~1 | TDD + Clerk/Convex | App + skills |
| VoloBuilds/create-volo-app | ~0.1k | Full-stack 30s | Scaffolding |

**Insight:** `vibe coding template` → Layer B. `spec-driven` / `from vibe coding to` → Layer A. The ideal README **appears in both**, with two-line disambiguation.

### 5.3 Compact matrix

```
                 Spec    Multi-agent  Code graph  Knowledge  Install kit  CI/TDD
Spec Kit         ●●●●    ●●           ○           ○          ●●●          ●●
OpenSpec         ●●●●    ●●           ○           ○          ●●           ●
BMAD             ●●●     ●●●●         ○           ○          ●●●          ●●
GSD              ●●●     ●●●          ○           ○          ●●           ●
Vibe boilerplates ○      ○            ○           ○          ●●●● (app)   ●
THIS KIT         ●●●●    ●●           ●●●●        ●●●●       ●●●●         ●●●●
```

### 5.4 Defensible differentiators (anchorable)

1. Documented composite stack (OpenSpec + GitNexus + Graphify) + install order + `AGENTS.md` anti-overwrite
2. Versioned payload (`MANIFEST.yaml`, C2 upgrade)
3. APP / DOCS_SPECS / HYBRID profiles
4. Real gates (validate + OSV + Probity) — not just prompts
5. Session coordination (worktree locks)

### 5.5 What's missing to compete on discovery (not on method)

| Discovery gap | Severity | Notes |
|-------------------|------------|-------|
| Missing root README | Critical | This change |
| No narrative demo like OpenSpec | High | Copy `/opsx` dialogue pattern |
| No GIF / site / Discord | Medium | Follow-up; do not block |
| Topics/About not aligned | High | `[MANUAL ACTION]` in GitHub Settings |
| C1/G4 jargon on first contact | Medium | "Friendly name → code" map |
| Repo name `gitnexus-graphify-openspec` | Medium | Weak SEO vs "sdd-kit"; rename = human decision |

## 6. Dual bias — discovery + product improvements

### 6.1 This change (discovery + canonical documentation)

- Persistent document in `doc/avaliacoes/` (this analysis)
- Root `README.md` (EN-first, hero + demo + compare + CTA)
- Positioning intro in `sdd-kit/README.md` (without removing ops)
- Pointers in guide / AGENTS / project / evaluations index
- Normative spec for discovery surfaces
- `[MANUAL ACTION]` checklist for About + topics on GitHub

### 6.2 Product backlog derived from the analysis (outside or partial in this change)

| ID | Improvement | Gap origin | Priority | Scope / decision (2026-07-26) |
|----|----------|---------------|------------|------------------------------|
| P1 | README + topics + evaluation | Invisibility | P0 | **This change** (apply) |
| P2 | Quickstart "vibe coder in 5 min" in guide (short §) | Long-guide friction | P0 | **This change** (apply) |
| P3 | Friendly C1/C2/G2 → human names map in README/kit | Jargon | P1 | **This change** (apply) |
| P4 | Updatable "compare table" template (dated stars) | Competition shifts | P1 | **This change** (apply; in evaluation) |
| P5 | Demo GIF / asciinema of opsx flow | OpenSpec/Spec Kit polish | — | **Explore before implementing** — see §6.3 |
| P6 | `npx` / famous one-liner bootstrap | Spec Kit `uv tool install` | — | **Do not implement** (current `install.sh --dry-run` CTA suffices; supply-chain risk) |
| P7 | Docs page (GitHub Pages / landing) | Spec Kit site | — | **Do not implement** |
| P8 | Discord community | OpenSpec/BMAD | — | **Do not implement** |
| P9 | "App starter" module (auth/DB/deploy) | Layer B | — | **Do not implement** (permanent non-goal) |
| P10 | Rename / public project name | SEO / identity | — | **After README** — dedicated explore→propose→apply (§11); **not** in this change |
| — | Multi-persona theatre (BMAD) | BMAD-METHOD | — | **Do not implement** (local skills/subagents suffice; avoids a second orchestrator) |
| — | Full hub English translation | Global discovery + policy | — | **After stable name** — policy + waves (§11); **not** in this change |

**Product principle:** improve the kit for beginners **without** diluting the differentiator (control plane). Any feature that turns us into "yet another vibe template" is rejected.

### 6.3 Product decision — competition gaps (explore 2026-07-26)

**Human confirmation:** Landing, Discord, one-liner fame, app scaffold, BMAD multi-persona, and GitHub brand — **do not implement**. They remain off the active roadmap.

**On the roadmap (outside this apply), fixed order — see §11:** new public name (P10) → full EN translation + policy → explore GIF (P5).

**P5 (1b GIF / asciinema):** **do not implement yet.** Requires **dedicated exploration** (`/opsx:explore`) on *how* to integrate, before any propose/apply. Prefer **after** README and, ideally, stable name (§11). Open questions:

| # | Integration question |
|---|------------------------|
| E1 | Format: GIF vs asciinema vs SVG terminal vs short video — git size vs fidelity trade-off |
| E2 | Where the asset lives: `docs/media/`, GitHub release, or external link only |
| E3 | What to record: only `/opsx:propose→archive` or also `install.sh --dry-run` |
| E4 | How to avoid drift when slash commands / skills change (re-recording pipeline? text-first in README?) |
| E5 | README relationship: "Demo (TBD)" placeholder vs text-only section until explore closes |
| E6 | Recording tools license and whether they enter `openspec/infra.md` (R10) |

**Suggested change (future, after explore):** e.g. `explore-sdd-demo-asciinema` → only then `/opsx:propose` if integration is clear.

**Note:** P1–P4 (README, quickstart, friendly map, evaluation) **remain** in scope for `add-sdd-discovery-positioning` — they are documentary discovery, not the "fame" gaps above.

## 7. Recommended root README structure

1. Hero (tagline + anti-boilerplate + CTA `install.sh --dry-run`)
2. Problem (agent forgets / hallucinates / overwrites AGENTS.md)
3. Text demo (`/opsx:explore → propose → apply → archive`)
4. What's included (table: specs / code graph / knowledge / gates / UI / Probity / **SDD metrics + cadence**)
5. Not another starter kit
6. 30-second install + profiles
7. Who it's for
8. Compare (summary; detail in evaluation)
9. Stack & companions (links OpenSpec, GitNexus, Graphify, agents.md)
10. Docs (guide pt-BR, kit README)
11. **Calibrate as you go** (optional short section or merged into 4) — see §12; honest tone, no ML

Language: **EN on root README** (GitHub discovery). Evaluation and guide in this apply may remain **pt-BR** until the i18n wave (research §11 step ④).

## 8. Risks

| Risk | Mitigation |
|-------|-----------|
| Attract users who only want boilerplate and churn | Explicit anti-positioning in the hero |
| "Stop vibe coding" tone alienates | Prefer "from vibe coding to…" |
| Outdated stars in README | Dated + "order of magnitude"; detail only in `doc/avaliacoes/` |
| Duplicating the guide in README | README ≤ ~150–200 lines; deep dive in guide |
| Promising rename / i18n / GIF in this change | Non-goals + roadmap §11 / D10 |

## 9. Decisions to confirm on apply (defaults from this propose)

| Question | Default adopted in this change |
|---------|-------------------------------|
| Primary audience | Solo / small team on Cursor or Claude Code, leaving chaotic vibe |
| Root README language | EN-first |
| Tone aggressiveness | "From vibe → agentic", not "stop vibe" |
| Public name | Working title "SDD Kit" in this apply; **real rename = steps ②–③ of §11** (not in this change) |
| App scaffold | Permanent non-goal |
| P5 GIF/asciinema | **Not in this apply** — integration explore after README (§6.3, §11 step ⑤) |
| P6–P8, BMAD, Landing, Discord, GitHub brand | **Do not implement** (decision 2026-07-26) |
| Full EN translation | **Not in this apply** — after stable name (§11 steps ④) |

## 10. References

- Explore session 2026-07-26 (chat); this file is persistent memory
- `sdd-kit/README.md` — operational AS-IS
- `doc/sistema-sdd-pedro.md` — canonical procedure
- `openspec/changes/explore-oss-coverage-gaps/research.md` — tooling gaps (complementary, not a substitute)
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

## 12. SDD Metrics (G4) como gancho de README — explore pré-apply (2026-07-26)

Pergunta humana: a ferramenta de análise periódica (`scripts/sdd-metrics.sh` + cadência) pode ser divulgada no README como forma de o sistema “aprender” e ficar mais adaptável quanto mais se usa?

### 12.1 O que a ferramenta é (AS-IS, ancorado)

| Peça | Função |
|------|--------|
| `bash scripts/sdd-metrics.sh` | Relatório markdown **modo C** (sob demanda): M1 volume, M2 lead time propose→archive, M3 rework `fix` pós-archive, M4 resumo |
| Fontes | Só `git` + `openspec/changes/` / `archive/` — sem rede, sem DevLake |
| Playbook §2.17 | **Interpretar → actuar:** 1 insight → 1 ajuste de *processo* (WIP, escopo, gates, R9) |
| `--check-cadence` | Advisory: nudge se ≥**5** archives desde last-run **ou** ≥**30** dias (stamp `.sdd/metrics-last-run`) |
| Session Handoff `/opsx:archive` | Pode sugerir correr métricas; **nunca** auto-executa o relatório; **não** bloqueia archive |
| Spec | `openspec/specs/sdd-metrics/` — não é gate CI; sem skill always-on |

### 12.2 O que **não** é

| Claim enganoso | Realidade |
|----------------|-----------|
| “O sistema aprende sozinho / ML / personaliza o agente” | Zero modelo; zero escrita automática em `AGENTS.md` ou specs a partir do relatório |
| “Quanto mais usas, o kit adapta-se a ti automaticamente” | Quem adapta és **tu** (ou o time), com 1 ajuste consciente no processo |
| “Dashboard vivo / telemetria contínua” | Modo C + nudge pontual; stamp local gitignored |
| “Métricas perfeitas” | Proxies explícitos (M2/M3 dependem de R9 e de commits) |

### 12.3 O ganho prático real (honestidade + valor)

```
usar o loop (/opsx)  →  archives acumulam  →  cadência pede retrospectiva
        →  relatório M1–M4  →  1 insight → 1 ajuste no teu SDD
        →  próximo ciclo com menos rework / escopo mais curto / menos WIP
```

**Sim, há um efeito “quanto mais usas, melhor calibração”** — mas o objecto que melhora é o **processo humano + convenções do repo**, não um cérebro embutido no kit. O diferencial vs Spec Kit / OpenSpec / BMAD: quase nenhum vende **métricas de eficácia do próprio framework SDD** com playbook de acção e nudge pós-archive.

Exemplos concretos de adaptação (playbook §2.17):

- M1 alto de activos → reduzes WIP / archives pendentes  
- M2 a subir → changes mais pequenos, handoffs mais curtos  
- M3 alto → endureces gates antes de archive (menos “archive e depois fix”)

### 12.4 Como divulgar no README (copy permitida vs proibida)

**Permitido (recomendado — bullet em “What's included” ou secção curta):**

> **Built-in SDD retrospectives** — `sdd-metrics.sh` turns your archive history into volume, lead-time, and rework signals. After every few shipped changes, a gentle cadence nudge asks you to run the report and make **one** process adjustment. The more you ship through the loop, the more signal you have to calibrate *your* workflow — not magic, measurable.

Versão curta:

> **Calibrate as you go** — periodic SDD metrics (lead time, rework) + a playbook so the process improves with use.

**Proibido / evitar:**

- “AI that learns your style”  
- “Self-adapting agent OS”  
- “Automatic personalization”  
- Qualquer implicação de que o relatório reescreve rules sozinho  

### 12.5 Compatibilidade e decisão para o apply ①

| Critério | Avaliação |
|----------|-----------|
| Cabe no README deste change? | **Sim** — já é capacidade do kit (G4); não é feature nova |
| Conflito com anti-boilerplate? | Não — reforça “control plane / process OS” |
| Precisa de change novo? | Não para mencionar; só se no futuro se quiser auto-aplicar insights (isso seria explore/propose **nova** e fora do escopo actual) |
| Onde no README | Tabela “What's included” + 2–3 frases; link ao guia §2.17 (pt-BR até i18n) |

**Decisão para apply:** incluir o gancho **honesto** (§12.4). Não reivindicar aprendizado automático. Na avaliação canónica, listar G4 metrics como diferencial de divulgação (não como P5–P10).

### 12.6 Evolução futura (fora deste apply — só se explore pedir)

Auto-aplicar ajustes a partir de métricas (ex. agente propõe change “reduce WIP”) seria um salto de produto — **não** existe hoje. Tratar como ideia separada, não como texto do README.
