# Pipeline de design — prototipagem → shadcn/ui → Impeccable

> **shadcn/ui = caminho default (Fase 2).** Opt-out e stacks alternativas: [`003-ui-stack-adapters.md`](./003-ui-stack-adapters.md). Procedimento C1-UI: [`002-ui-module-install.md`](./002-ui-module-install.md).
>
> **Importação e estado de adaptação**
>
> - **Origem:** repositório [pvilarim/topocnc-art](https://github.com/pvilarim/topocnc-art), branch `import/site-metal-p5`, importado em 2026-06-27 para **spec-pedro** (`gitnexus-graphify-openspec`).
> - **Status:** `[REFERÊNCIA — REQUER ADAPTAÇÃO]` — pipeline conceitual validado no projeto de origem; caminhos e exemplos de rotas reflectem um monorepo APP com site público e configurador 3D.
> - **Próximo passo:** incorporar este pipeline no guia canónico [`doc/sistema-sdd-pedro.md`](../sistema-sdd-pedro.md) (§ futuro: design system / UI) e propagar via `sdd-kit/` para instalação SDD em **qualquer** repositório alvo (perfis APP, HYBRID ou DOCS_SPECS com app).
> - Secções **[se aplicável]** referem-se a configurador 3D, CNC ou rotas `/app` — omitir em projectos sem esse domínio.

Documento de referência para o fluxo de trabalho de **prototipagem visual** até **integração e manutenção** no código de produção (shadcn/ui + Impeccable).

**Status:** `[PLANEJADO]` — pipeline conceitual; ferramentas ainda não instaladas no repo alvo (exceto Pencil/Figma MCP no ambiente local do desenvolvedor, se configurados).

**Complementa:** [`000-impeccable-design-system-guia.md`](./000-impeccable-design-system-guia.md) (detalhes do Impeccable isolado).

---

## 1. Visão geral

Quatro camadas com responsabilidades distintas:

| Camada | Ferramenta(s) | Papel | Onde vive |
|--------|---------------|-------|-----------|
| **1 · Exploração** | [Open Design](https://github.com/nexu-io/open-design) | POC amplo — várias direções de marca, decks, motion | App/desktop OD (fora do repo) |
| **1b · Prototipagem no repo** | [Pencil](https://www.pencil.dev) **ou** Figma + MCP | Wireframe/alta fidelidade alinhada a shadcn ou marca existente | `.pen` no repo **ou** arquivo Figma (cloud) |
| **2 · Fundação** | **shadcn/ui** + Tailwind | Componentes React e tokens CSS no código real | `components/ui/`, `globals.css` |
| **3 · Qualidade** | [Impeccable](https://github.com/pbakaus/impeccable) | Aperfeiçoamento, consistência e guardrails para agentes | `.cursor/skills/impeccable`, `DESIGN.md` no repo |

> **Caminhos:** em monorepo, prefixar com `apps/web/` (ex.: `apps/web/components/ui/`). Em Next.js na raiz, usar `app/`, `components/ui/` directamente.

### Analogia

```
Open Design     = laboratório (explorar direções)
Pencil          = ateliê no repo (prototipar com shadcn, versionado em Git)
Figma + MCP     = importar marca/UI já desenhada por designer
shadcn/ui       = implementação (componentes + tokens)
Impeccable      = coach + lint de design no código de produção
```

### Pipeline completo (três entradas na Fase 1)

```mermaid
flowchart TB
  subgraph fase1a [Fase 1a — Explorar opcional]
    OD[Open Design]
    OD --> ODout[DESIGN.md + screenshots / HTML]
  end

  subgraph fase1b [Fase 1b — Prototipar escolha A ou B]
    PC[Pencil .pen no repo]
    FG[Figma + MCP no Cursor]
  end

  ODout --> PC
  ODout --> FG
  ODout --> F2

  PC --> F2
  FG --> F2

  subgraph fase2 [Fase 2 — Design system]
    F2[Extrair tokens e regras]
    F2 --> G[DESIGN.md canônico no repo]
    G --> H[globals.css + tailwind.config.ts]
    H --> I[Variantes shadcn]
  end

  subgraph fase3 [Fase 3 — Integração]
    I --> J[Páginas Next.js]
    J --> K[Impeccable polish/audit]
    K --> L[detect no CI]
    L --> M[Produção]
  end
```

---

## 2. Por que este pipeline

| Problema | Solução no pipeline |
|----------|---------------------|
| Commitar código antes de validar identidade visual | Fase 1 (OD / Pencil / Figma) gera POC sem produção prematura |
| Artefato de POC não roda direto no Next.js | Fase 2 traduz decisões para tokens shadcn |
| Agente “esquece” a marca entre sessões | `DESIGN.md` + Impeccable persistem contexto |
| Visual genérico de IA em produção | Impeccable detecta e bloqueia anti-padrões |
| Design fora do repo envelhece | Pencil (`.pen` no Git) ou Figma como fonte explícita com data de sync |
| Configurador 3D ≠ site marketing **[se aplicável]** | Escopo explícito — pipeline só para **site público** |

---

## 3. Fase 1 — Prototipagem (três ferramentas, dois caminhos principais)

A Fase 1 divide-se em:

- **1a · Open Design** (opcional) — explorar direção de marca em escala
- **1b · Pencil ou Figma** — prototipar a interface que será implementada (escolher **um** como caminho principal de wireframe/alta)

### 3.0 — Qual ferramenta usar? (decisão rápida)

| Situação | Ferramenta recomendada |
|----------|------------------------|
| Redesign amplo; comparar 2–3 identidades visuais | **Open Design** → depois Pencil ou Figma |
| Já sabe a direção; quer wireframe no repo com shadcn | **Pencil** |
| Já existe arquivo Figma de marca/UI; designer usa Figma | **Figma + MCP** |
| Pitch deck, vídeo, motion, 150 `DESIGN.md` prontos | **Open Design** |
| Colaboração designer (fora do IDE) + handoff estruturado | **Figma + MCP** |
| POC versionado em Git, mesmo workspace do Cursor | **Pencil** |
| Só ajuste incremental numa página existente | Pular Fase 1a; **Pencil** ou direto Fase 2 |

### Matriz comparativa

| Critério | Open Design | Pencil | Figma + MCP |
|----------|-------------|--------|-------------|
| Onde vive o design | Fora do repo | `.pen` no repo | Arquivo Figma (cloud) |
| Alinhamento shadcn | Indireto | **Nativo** | Via variáveis / Dev Mode |
| Explorar muitas direções | **⭐⭐⭐** | ⭐⭐ | ⭐ |
| Versionamento Git do design | ❌ | **⭐⭐⭐** | ❌ (só export) |
| Designer não-dev no fluxo | ⭐ | ⭐ | **⭐⭐⭐** |
| Integração Cursor/MCP | ⭐⭐ (`od mcp`) | **⭐⭐⭐** | **⭐⭐⭐** |
| Decks / vídeo / motion | **⭐⭐⭐** | ❌ | ⭐⭐ |
| Curva de setup | Média | Baixa (já instalado) | Média (conta Figma + MCP) |

### Combinações recomendadas

| Combo | Quando usar |
|-------|-------------|
| **OD → Pencil** | Padrão recomendado: OD escolhe marca; Pencil refina landing/galeria no repo com shadcn |
| **Figma → Pencil** | Marca já no Figma; colar/adaptar frames no Pencil; implementar no Cursor |
| **Figma → direto Fase 2** | UI simples; MCP extrai tokens; sem wireframe intermediário |
| **OD → Figma** | OD gera direção; designer formaliza no Figma antes do código |
| **OD + Pencil + Figma** | Só com papéis claros — evitar três fontes de verdade simultâneas |

---

## 3.1 — Fase 1a: Open Design (exploração)

### Objetivo

Validar **direção de marca**, hierarquia, tipografia, cor e tom **antes** de comprometer o repo — especialmente quando ainda não há consenso visual.

### Quando usar

- Redesign de home, galeria ou página de produto **sem** identidade definida
- Comparar 2–3 direções (ex.: industrial minimal vs editorial warm)
- Pitch deck, landing de campanha, motion (HyperFrames)
- Testar um dos 150 `DESIGN.md` prontos (Linear, Stripe, `warm-editorial`, …)

### Quando **não** usar

- Direção visual já aprovada em Figma ou Pencil → ir direto à Fase 1b ou Fase 2
- Configurador `/app`, admin, canvas WebGL **[se aplicável]**

### Setup

```bash
# App desktop: https://open-design.ai
# Ou MCP no Cursor:
od mcp install cursor
```

### Entregáveis → próxima fase

| Entregável | Destino |
|------------|---------|
| `DESIGN.md` aprovado | Base do contrato no repo (Fase 2) |
| Screenshots / HTML | Referência para Pencil ou implementação |
| Anti-referências | Seção do `DESIGN.md` canônico |

Documentação: https://github.com/nexu-io/open-design

---

## 3.2 — Fase 1b (opção A): Pencil

### O que é

[Pencil](https://www.pencil.dev) é um canvas de design **dentro do IDE** (extensão Cursor/VS Code). Arquivos `.pen` (JSON) vivem no repositório, versionados em Git. MCP local expõe o canvas ao agente — alinhado a **shadcn** como design system de referência.

### Objetivo

Prototipar **wireframes ou alta fidelidade** de páginas do site público **no monorepo**, com vocabulário próximo de `components/ui/`, antes de codificar em Next.js.

### Quando usar Pencil

| Cenário | Por quê Pencil |
|---------|----------------|
| POC de home, galeria, produto **no repo** | `.pen` commitável; agente implementa no mesmo workspace |
| Stack já é shadcn + Tailwind | Pencil suporta shadcn como sistema de referência |
| Fluxo solo ou pequena equipe dev | Sem dependência de conta Figma |
| Iteração rápida com agente no Cursor | MCP lê/altera `.pen` e gera React |
| Veio do Open Design com direção aprovada | Traduz `DESIGN.md` em layout concreto antes do código |
| Quer evitar “link Figma desatualizado” | Fonte de design versionada junto ao código |

### Quando **não** usar Pencil

| Cenário | Usar em vez disso |
|---------|-------------------|
| Designer principal trabalha só em Figma | **Figma + MCP** |
| Precisa de deck PPTX ou vídeo MP4 | **Open Design** |
| Explorar 10+ direções de marca rapidamente | **Open Design** primeiro |
| Configurador 3D `/app` **[se aplicável]** | Skills paramétricas do domínio |

### Setup (referência)

1. Extensão **Pencil** no Cursor (Extensions → “Pencil”).
2. Ativar conta / login conforme docs Pencil.
3. Criar arquivo ex.: `design/site-publico.pen` na raiz ou em `app/design/`.
4. Verificar MCP: **Settings → Tools & MCP** → Pencil listado (servidor local ao abrir o `.pen`).
5. Opcional: selecionar design system **shadcn** no Pencil.

Documentação: https://docs.pencil.dev

### Estrutura sugerida no repo

```
design/
  site-home.pen           # POC home
  site-gallery.pen        # POC galeria
  README.md               # [opcional] notas de handoff — só se necessário
```

> **Nota:** pastas `design/` criar na adoção do pipeline no **projeto APP alvo** — não existem neste hub DOCS_SPECS.

### Fluxo na prática

1. Abrir `.pen` no Cursor.
2. Desenhar seções (hero, grid galeria, card produto) com componentes shadcn de referência.
3. Se veio do OD: aplicar paleta/tipo do `DESIGN.md` aprovado.
4. No chat: *“Implemente design/site-home.pen em app/[locale]/page.tsx com @/components/ui/*”*.
5. Passar para Fase 2 (tokens) e Fase 3 (Impeccable).

### Entregáveis → Fase 2

| Entregável | Uso |
|------------|-----|
| `design/*.pen` aprovado | Referência visual para implementação |
| Screenshots exportados | PR / documentação |
| Notas de tokens extraídos | `globals.css`, `DESIGN.md` |

---

## 3.3 — Fase 1b (opção B): Figma + MCP

### O que é

**Figma** como ferramenta de design (cloud); **MCP no Cursor** permite ao agente ler estrutura, screenshots, variáveis e — com skills como `figma-use` — editar nós via Plugin API. Open Design também oferece plugin [`od-figma-migration`](https://github.com/nexu-io/open-design/tree/main/plugins/_official/scenarios/od-figma-migration) para pipeline Figma → tokens → artefato HTML.

### Objetivo

Usar **marca ou UI já existente no Figma** como fonte de verdade visual, importando layout e tokens para o projeto alvo sem redesenhar do zero.

### Quando usar Figma + MCP

| Cenário | Por quê Figma |
|---------|---------------|
| **Já existe** arquivo Figma de marca ou UI | Fonte canônica do designer |
| Designer trabalha fora do IDE | Colaboração padrão da indústria |
| Variáveis/tokens no Figma (cores, tipo, espaçamento) | MCP extrai para `globals.css` |
| Dev Mode / componentes Figma documentados | Handoff estruturado para shadcn |
| Importar frames de referência (moodboard) | Screenshots + metadata via MCP |
| Migração Figma → React via Open Design | Plugin `od-figma-migration` |

### Quando **não** usar Figma + MCP

| Cenário | Usar em vez disso |
|---------|-------------------|
| Não há Figma nem designer Figma | **Pencil** ou **Open Design** |
| Só dev solo; quer tudo no repo | **Pencil** |
| Exploração rápida sem arquivo Figma | **Open Design** |
| POC deve ser commitável em Git sem export manual | **Pencil** |

### Setup (referência)

1. Conta Figma com arquivo do projeto.
2. MCP Figma configurado no Cursor (**Settings → Tools & MCP**).
3. Compartilhar link do arquivo ou node ID com o agente.
4. Para escrita no Figma: carregar skill `figma-use` antes de `use_figma`.

### Fluxo na prática

**Caminho A — Figma → código direto**

1. Agente lê variáveis e layout via MCP (screenshot + metadata).
2. Traduz para `globals.css` + páginas shadcn (Fase 2).
3. Impeccable polish (Fase 3).

**Caminho B — Figma → Pencil → código** (recomendado se quiser `.pen` no repo)

1. Designer mantém Figma como fonte de marca.
2. Colar/adaptar frames relevantes no Pencil.
3. Implementar do `.pen` no Next.js.

**Caminho C — Figma → Open Design → código**

1. Plugin `od-figma-migration` no Open Design (`figma-extract` → `token-map` → artefato).
2. Aprovar HTML/`DESIGN.md`; seguir Fase 2.

### Entregáveis → Fase 2

| Entregável | Uso |
|------------|-----|
| URL do arquivo Figma + node IDs | Referência persistente |
| Variáveis exportadas / documentadas | `globals.css` |
| Screenshots de frames aprovados | Implementação layout |
| Data da última sync Figma → repo | Evitar drift |

### Risco específico

> Figma vive **fora** do repo. Registrar no `DESIGN.md` a **data e versão** do frame aprovado; sem isso, código e design divergem silenciosamente.

---

## 3.4 — Schema `DESIGN.md` (comum às três entradas)

Independente de OD, Pencil ou Figma, o contrato canônico no repo deve cobrir:

1. Color · 2. Typography · 3. Spacing · 4. Layout · 5. Components · 6. Motion · 7. Voice · 8. Brand · 9. Anti-patterns

Open Design usa 9 seções nativas. Ao vir do Pencil ou Figma, redigir ou completar manualmente na Fase 2.

---

## 4. Phase 2 — Turn POC into design system (shadcn)

### Objective

Translate Phase 1 visual decisions into deterministic **tokens and components** for Next.js.

### Principle

> No prototyping artifact ships to production as-is (OD HTML, Pencil canvas, Figma frames).  
> What ships: **CSS tokens**, **shadcn variants**, and a **canonical `DESIGN.md`**.

### POC source → Phase 2 action

| Phase 1 source | Phase 2 action |
|----------------|----------------|
| Open Design (`DESIGN.md` + screenshots) | Extract tokens; do not copy HTML |
| Pencil (`.pen`) | Agent implements with `@/components/ui/*`; extract tokens from approved layout |
| Figma (variables + frames) | MCP → HSL in `globals.css`; map shadcn components |

### Where to save in the target project

| Artifact | Suggested path | Role |
|----------|----------------|------|
| CSS tokens | `app/globals.css` | `--primary`, `--radius`, … |
| Tailwind theme | `tailwind.config.ts` | `colors`, `fontFamily`, `borderRadius` |
| Brand contract | `DESIGN.md` (app root) | Impeccable + agents |
| Product context | `PRODUCT.md` | Audience, tone, anti-references |
| Pencil prototypes | `design/*.pen` | Versioned reference (not deployed) |
| Components | `components/ui/*` | CVA variants |

> In a monorepo: prefix paths above with `apps/web/`.

### Translation checklist

- [ ] Extract colors to HSL in `globals.css`
- [ ] Map shadcn semantic tokens (`--primary`, `--muted`, …)
- [ ] Set `--radius` and fonts
- [ ] Adjust `button`, `card`, `badge` variants if needed
- [ ] Draft/update canonical `DESIGN.md` in the repo
- [ ] If Figma: note approved version/frame in `DESIGN.md`
- [ ] **Do not** copy OD HTML or raw Figma export into `page.tsx`

### Agent prompt (Phase 2)

```
Read doc/design/001-pipeline-open-design-shadcn-impeccable.md.
POC source: [Open Design | Pencil design/site-home.pen | Figma URL].
Translate to:
1. app/globals.css (HSL tokens)
2. Minimal adjustments in components/ui/* if needed
3. Root DESIGN.md aligned with shadcn
Reimplement with @/components/ui/* — no HTML/PNG as the final page.
Scope: public site only; do not touch app/[locale]/app or lib/parametric [if applicable].
```

---

## 5. Phase 3 — Integration and refinement with Impeccable

### Objective

Keep pages **aligned** with `DESIGN.md` and **free of visual regressions**.

### Setup

```bash
npx impeccable install
# In Cursor:
/impeccable init
/impeccable document
```

Details: [`000-impeccable-design-system-guia.md`](./000-impeccable-design-system-guia.md)

### Commands by stage

| Stage | Command |
|-------|---------|
| After implementation | `/impeccable polish landing` |
| Hierarchy | `/impeccable typeset` |
| Color / contrast | `/impeccable colorize` |
| Spacing | `/impeccable layout` |
| Before merge | `/impeccable audit` + `npx impeccable detect` |

### Detector scope (`ignoreFiles`)

```json
{
  "detector": {
    "ignoreFiles": [
      "components/parametric-panel/**",
      "lib/parametric/**",
      "app/**/app/**",
      "app/**/admin/**",
      "app/**/dashboard/**",
      "components/three/**",
      "design/**"
    ]
  }
}
```

> Adjust `apps/web/` prefix in a monorepo. `parametric` / `three` entries are **[if applicable]**.

> `design/**` ignores `.pen` files in the detector — prototypes are not production code.

---

## 6. Tool roles (summary)

| Question | Open Design | Pencil | Figma MCP | shadcn | Impeccable |
|----------|-------------|--------|-----------|--------|------------|
| Explore brand directions | ✅ | ⚠️ | ⚠️ | ❌ | ❌ |
| POC in repo (Git) | ❌ | ✅ | ❌ | ❌ | ❌ |
| Brand already in Figma | ⚠️ import | paste | ✅ | ❌ | ❌ |
| Aligned with shadcn | Indirect | ✅ | Via tokens | ✅ | Reads existing |
| Production code | ❌ | ❌ | ❌ | ✅ | Guides |
| CI guardrails | ❌ | ❌ | ❌ | ❌ | ✅ |

---

## 7. Scope in the target project

### Within the pipeline

| Surface | Phase 1 | Phase 2 | Phase 3 |
|---------|---------|---------|---------|
| Home | OD / Pencil / Figma | `page.tsx` + tokens | polish / audit |
| Gallery | same | `gallery/` | polish / audit |
| Product | same | `product/[id]/` | polish / audit |
| FAQ, About, Contact | Pencil or Figma | existing pages | clarify / layout |
| Cart / checkout | same | UI components | harden / audit |

### Outside the pipeline **[if applicable]**

| Surface | Use |
|---------|-----|
| Configurator `/app` | domain parametric skills |
| Admin / dashboard | shadcn; Impeccable optional (product mode) |
| WebGL canvas | parametric skills |

---

## 8. Recommended workflows

### Flow A — Broad exploration (recommended for redesign)

1. Product brief.
2. **Open Design** — 2–3 directions + `DESIGN.md`.
3. Human approval.
4. **Pencil** — `design/site-*.pen` with shadcn.
5. Phase 2 — tokens + Next.js implementation.
6. Phase 3 — Impeccable + CI.

### Flow B — Solo dev, direction already clear (no OD)

1. Brief.
2. **Pencil** — wireframe/high-fidelity in the repo.
3. Agent implements → Phase 2 tokens → Phase 3 Impeccable.

### Flow C — Brand in Figma (designer + dev)

1. Designer keeps Figma up to date.
2. **Figma MCP** — agent extracts variables and layout.
3. Optional: adapt in **Pencil** for versioned `.pen`.
4. Phase 2 + 3.

### Flow D — Incremental (no redesign)

1. Skip Phase 1a.
2. **Pencil** only in the changed section (e.g. hero) **or** direct token patch.
3. `/impeccable polish` on the area.

---

## 9. Ready-made agent prompts

### Choose Phase 1 tool

```
Read doc/design/001-pipeline-open-design-shadcn-impeccable.md §3.0.
Do we have brand Figma? [yes/no]. Broad redesign or targeted tweak?
Recommend: Open Design, Pencil, or Figma MCP and justify in 3 lines.
```

### Pencil → implementation

```
Implement design/site-home.pen in app/[locale]/page.tsx.
Use only @/components/ui/* and globals.css tokens.
i18n via messages/ — no hardcoded PT strings in the view.
Then: /impeccable polish landing.
```

### Figma MCP → tokens

```
Figma file: [URL]. Extract color and typography variables to app/globals.css (shadcn HSL).
Update DESIGN.md with reference to frame [name] and sync date.
Do not copy PNG/SVG export as the page layout.
```

### Open Design → Pencil

```
Approved direction in Open Design [attach DESIGN.md].
Create equivalent wireframe in design/site-gallery.pen (shadcn).
Do not implement Next.js yet.
```

### Full pipeline

```
Follow doc/design/001-pipeline-open-design-shadcn-impeccable.md.
Current phase: [1a OD | 1b Pencil | 1b Figma | 2 shadcn | 3 Impeccable].
Scope: public site only.
```

---

## 10. Risks and mitigations

| Risk | Mitigation |
|------|------------|
| Three sources of truth (OD + Pencil + Figma) | Choose **one** canonical source per project; OD for exploration only |
| OD HTML / Figma export in `page.tsx` | Reimplement with shadcn |
| Figma drift | Date + frame ID in `DESIGN.md` |
| `.pen` out of sync with code | Commit `.pen` with the UI PR |
| Impeccable vs parametric skills **[if applicable]** | `ignoreFiles` for `/app`, `lib/parametric`, `design/**` |
| Pencil MCP offline | Open `.pen` before calling the agent |

---

## 11. License and cost

| Tool | License | Cost |
|------|---------|------|
| Open Design | Apache 2.0 | Free; optional BYOK or AMR |
| Pencil | See [pencil.dev](https://www.pencil.dev) | Extension; plan per vendor |
| Figma | Proprietary | Figma plan per usage |
| Figma MCP (Cursor) | Per plugin | Included in Cursor workflow |
| shadcn/ui | MIT | Already in APP project |
| Impeccable | Apache 2.0 | Free |

---

## 12. Related documents

| Document | Content |
|----------|---------|
| [000-impeccable-design-system-guia.md](./000-impeccable-design-system-guia.md) | Impeccable standalone |
| `AGENTS.md` | Agent routing |
| `doc/sistema-sdd-pedro.md` | Canonical SDD guide — **future home for this pipeline** |
| `openspec/project.md` | Project constitution |
| [Open Design](https://github.com/nexu-io/open-design) | Skills, `od-figma-migration` |
| [Pencil docs](https://docs.pencil.dev) | Installation, MCP |
| [Impeccable](https://github.com/pbakaus/impeccable) | Commands, detector |

---

## 13. History

| Date | Note |
|------|------|
| 2026-06-26 | Document created in source repo — OD → shadcn → Impeccable pipeline |
| 2026-06-26 | Phase 1b: Pencil and Figma MCP — when to use each, flows A–D, comparison matrix |
| 2026-06-27 | Imported to spec-pedro; generalized for SDD stack; SDD guide integration pending |
