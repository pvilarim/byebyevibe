# Avaliação: Posicionamento e descoberta do SDD Kit (vibe coding → agentic engineering)

| Campo | Valor |
|-------|--------|
| **Data** | 2026-07-26 |
| **Avaliador** | Sessão explore→propose `add-sdd-discovery-positioning` |
| **Candidato** | Superfícies de discovery do hub SDD (README raiz, About/topics, first-contact) — análise de mercado/SEO/concorrência |
| **Decisão** | **Misto** — P1–P4 + **P10 (ByeByeVibe)** **Adoptado** (docs); rename GitHub slug = `[AÇÃO MANUAL]`; P5 / fame gaps **Adiado** ou **Não implementar**; app scaffold **Non-goal** |
| **Escopo** | Documentação + specs de discovery (perfil DOCS_SPECS); sem código de aplicação |
| **Change** | [`add-sdd-discovery-positioning`](../../openspec/changes/add-sdd-discovery-positioning/proposal.md) |
| **Research fonte** | [`openspec/changes/add-sdd-discovery-positioning/research.md`](../../openspec/changes/add-sdd-discovery-positioning/research.md) |

## Resumo executivo

O hub SDD era invisível em discovery GitHub (sem `README.md` na raiz; kit README só operacional). A análise 2026-07-26 mapeou posicionamento “from vibe coding to agentic engineering”, SEO (topics/About), concorrência (Spec Kit / OpenSpec / BMAD / GSD vs vibe boilerplates) e backlog de produto. **Adoptamos** superfícies P1–P4 (README EN, avaliação, quickstart, mapa amigável) e, em follow-up (`rename-byebyevibe-public-name`), o **nome público ByeByeVibe** (P10 docs; path `sdd-kit/` inalterado). **Não** implementamos Landing, Discord, one-liner fame, app scaffold, BMAD multi-persona nem brand GitHub. GIF/i18n ficam no roadmap (`research.md` §11). Rename do slug GitHub → `byebyevibe` permanece `[AÇÃO MANUAL]`.

## Problema que tentava resolver

Invisibilidade de discovery + fricção de first-contact para quem chega de *vibe coding*, sem diluir o diferencial (control plane / install kit — não boilerplate de app).

## O que foi analisado

- Explore 2026-07-26; GitHub API (stars/topics)
- READMEs públicos: Spec Kit, OpenSpec, BMAD-METHOD, GSD
- AS-IS: `sdd-kit/README.md`, `doc/sistema-sdd-pedro.md`, `openspec/project.md`
- Complementar: `openspec/changes/explore-oss-coverage-gaps/research.md`

## Encaixe no stack SDD

| Ferramenta | Relação |
|------------|---------|
| OpenSpec | Fluxo `/opsx:*` é o demo narrativo do README; nós **consumimos** o CLI |
| GitNexus | Diferencial “code graph” vs Spec Kit / BMAD / GSD |
| Graphify | Diferencial “knowledge graph” no evenamento de discovery |
| AGENTS.md / sdd-kit | Anti-overwrite + payload versionado C1/C2 = pitch defensável |

## Diagnóstico AS-IS (pré-apply)

| Superfície | Estado pré-apply | Efeito |
|------------|------------------|--------|
| `README.md` na raiz | **Ausente** | Repo invisível em buscas GitHub |
| `sdd-kit/README.md` | Só operacional | Não serve newcomers vibe coding |
| Guia canónico | Profundo (v1.6.1) | Fricção alta como primeiro contacto |
| About / topics | Não alinhados a `vibe-coding` / SDD | Perde tráfego de topic quente |

**Gancho de mercado (sem fingir boilerplate):**

> Vibe coding até o primeiro PR. Depois disto, agentic engineering.

## Posicionamento adoptado

| Elemento | Copy |
|----------|------|
| Tagline | From vibe coding to shippable AI engineering. |
| Frase canónica | The missing operating system between your coding agent and a maintainable repo. |
| Anti-posicionamento | Not another Next.js starter — the SDD control plane (OpenSpec + graphs + gates) your repo is missing. |
| Nome público (P10) | **ByeByeVibe** (Adoptado — docs); path/payload continua `sdd-kit/` |
| Working title legado | “SDD Install Kit” / “SDD Kit” (substituído no discovery; comandos `sdd-kit/` intactos) |

## Termos-chave e SEO GitHub

Topics de alto tráfego: `vibe-coding`, `spec-driven-development`, `context-engineering`, `agentic-coding`, `claude-code`, `cursor`, `agent-skills`, `agents-md`, `mcp`, `prd`.

### [AÇÃO MANUAL NECESSÁRIA] — Rename repo + About + topics no GitHub

O agente **não** altera Settings do repositório. Operador humano deve aplicar:

1. **Rename do repositório:** Settings → General → Repository name: `gitnexus-graphify-openspec` → **`byebyevibe`**
2. **Remote local:** `git remote set-url origin git@github.com:pvilarim/byebyevibe.git` (ou HTTPS equivalente)
3. **About** e **Topics** (abaixo)
4. **Homepage** (opcional): `https://pedrocodeart.netlify.app/`

**About sugerido (≤160 chars):**

> ByeByeVibe — from vibe coding to shippable AI engineering. SDD control plane (OpenSpec + graphs + gates) for Cursor & Claude Code. Not a Next.js starter.

**Topics (mínimo):**

- `vibe-coding`
- `spec-driven-development`
- `context-engineering`
- `claude-code`
- `cursor`

Opcionais: `agentic-coding`, `agent-skills`, `openspec`, `mcp`, `agents-md`.

**Onde:** GitHub → Settings do repo → General → Description / Topics / Rename.

## Rede semântica (features ↔ projectos)

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

## Concorrência — compare table (stars ≈ 2026-07-26, ordem de grandeza)

### Camada A — frameworks SDD (vizinhos)

| Projecto | ★ (ordem) | Eles oferecem; nós não | Nós oferecemos; eles não |
|----------|-----------|------------------------|---------------------------|
| [github/spec-kit](https://github.com/github/spec-kit) | ~124k | Distribuição, polish, site, brand GitHub | Triplo OpenSpec+GitNexus+Graphify; kit C1/C2; Probity; métricas; session locks |
| [Fission-AI/OpenSpec](https://github.com/Fission-AI/OpenSpec) | ~63k | O CLI de specs (nós consumimos) | Orquestração graphs+CI+install kit+guia |
| [bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD) | ~51k | Multi-persona theatre | Menos cerimónia; brownfield; CI/TDD; dual-graph |
| [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done) | ~65k | Autonomia longa | Multi-IDE; Graphify+GitNexus; supply-chain |

### Camada B — vibe templates (mesma busca, produto diferente)

App scaffolds / boilerplates (Next, Bun, FastAPI, etc.) — **non-goal permanente** deste kit. O README aparece nas duas buscas com disambiguação explícita.

### Matriz compacta

```
                 Spec    Multi-agent  Code graph  Knowledge  Install kit  CI/TDD
Spec Kit         ●●●●    ●●           ○           ○          ●●●          ●●
OpenSpec         ●●●●    ●●           ○           ○          ●●           ●
BMAD             ●●●     ●●●●         ○           ○          ●●●          ●●
GSD              ●●●     ●●●          ○           ○          ●●           ●
Vibe boilerplates ○      ○            ○           ○          ●●●● (app)   ●
ESTE KIT         ●●●●    ●●           ●●●●        ●●●●       ●●●●         ●●●●
```

**Diferenciais defensáveis:** (1) stack composto + anti-overwrite AGENTS.md; (2) payload `MANIFEST.yaml` + upgrade C2; (3) perfis APP/DOCS_SPECS/HYBRID; (4) gates reais; (5) session coordination; (6) SDD metrics G4 como retrospectives / calibrate-as-you-go (**sem** claim ML).

## G4 Metrics no pitch de discovery

`sdd-metrics.sh` + cadência + playbook §2.17 = retrospectives de processo (volume, lead time, rework). Framing permitido: “calibrate as you go”. **Proibido:** ML, self-learning agent, adaptação automática do kit. Detalhe: research §12 / design D11.

## Decisões por item (backlog de produto)

| ID | Melhoria | Decisão | Notas |
|----|----------|---------|-------|
| P1 | README + topics + avaliação | **Adoptado** | README raiz EN + esta avaliação + checklist About/topics |
| P2 | Quickstart vibe coder no guia | **Adoptado** | §2.0b em `doc/sistema-sdd-pedro.md` |
| P3 | Mapa amigável C1/C2/G* | **Adoptado** | Intro em `sdd-kit/README.md` |
| P4 | Compare table actualizável | **Adoptado** | Esta secção (stars datados) |
| P5 | Demo GIF / asciinema | **Adiado — pending explore** | Após README (idealmente após nome); E1–E6 em research §6.3 |
| P6 | One-liner `npx` fame | **Não implementar** | CTA `install.sh --dry-run` basta |
| P7 | Landing / GitHub Pages | **Não implementar** | D9 |
| P8 | Discord | **Não implementar** | D9 |
| P9 | App starter (auth/DB/deploy) | **Non-goal permanente** | Camada B |
| P10 | Rename / nome público | **Adoptado (ByeByeVibe)** | Display name + hero/Maintainer nos docs; path `sdd-kit/` intacto; slug GitHub `byebyevibe` = `[AÇÃO MANUAL]` |
| — | BMAD multi-persona | **Não implementar** | D9 |
| — | Brand GitHub | **Não implementar** | D9 |
| — | Tradução completa EN | **Adiado — roadmap §11** | Após nome estável |

### Roadmap pós-apply (research §11 / design D10)

```
① README + avaliação + quickstart   ← feito (`add-sdd-discovery-positioning`)
② Explore→propose nome público (P10) ← feito
③ Apply rename/rebrand (ByeByeVibe) ← `rename-byebyevibe-public-name` (docs); slug GitHub = manual
④ Policy EN + waves de tradução
⑤ Explore GIF/asciinema (P5)
⑥ Landing/Discord/one-liner — fora (D9)
```

## Riscos por fase do workflow

| Fase | Risco | Notas |
|------|-------|-------|
| Explore | Reabrir fame gaps já fechados (D9) | Checklist Non-goals |
| Propose | Misturar rename/i18n/GIF neste change | D10 — changes separados |
| Apply | Claim ML em metrics; omitir anti-boilerplate | Gate grep + D11 |
| Archive | Esquecer checklist About/topics | `[AÇÃO MANUAL NECESSÁRIA]` abaixo |

## Ganhos esperados vs observados

| Ganho anunciado | Avaliação |
|-----------------|-----------|
| Repo encontrável em ≤30s | **Esperado** após README + About/topics manuais |
| Newcomers entendem “não é starter” | **Esperado** via anti-posicionamento no hero |
| Operadores mantêm docs ops | **Esperado** — kit README prepend, ops intacto |
| Stars / SEO imediato | **Parcial** — depende de topics manuais + tempo |

## Alternativas já no stack

Sem README/avaliação, o guia + `sdd-kit/README.md` operacional já existiam — insuficientes para discovery GitHub. OpenSpec upstream cobre o CLI de specs; este hub orquestra graphs + kit + gates.

## Decisão e condições de reavaliação

**Decisão:** **Misto** — superfícies P1–P4 **Adoptado**; **P10 (ByeByeVibe)** **Adoptado** nos docs (slug GitHub → `byebyevibe` = `[AÇÃO MANUAL]`); P5 (GIF) **Adiado** até `/opsx:explore` de integração; i18n **Adiado** (roadmap §11); P6–P9 / BMAD / brand / Landing / Discord **Não implementar** / **Non-goal**.

**Condições para reabrir:**

- **P5:** explore fecha E1–E6 (formato, path do asset, script de gravação, drift)
- **P10 (slug GitHub):** operador completa rename → `byebyevibe` + About/topics; actualizar links absolutos remanescentes se necessário
- **i18n:** nome estável (ByeByeVibe) + policy “artefactos novos = EN”
- **Fame gaps (P6–P8):** só com nova proposta OpenSpec e confirmação humana explícita (hoje D9)

## Referências

- Research completo: `openspec/changes/add-sdd-discovery-positioning/research.md`
- Design (D9–D11): `openspec/changes/add-sdd-discovery-positioning/design.md`
- README raiz: [`README.md`](../../README.md)
- Guia: `doc/sistema-sdd-pedro.md` §2.0b
- agents.md: https://agents.md/
- PR: [#54](https://github.com/pvilarim/gitnexus-graphify-openspec/pull/54)
