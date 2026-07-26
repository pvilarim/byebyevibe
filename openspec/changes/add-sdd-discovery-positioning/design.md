# Design — Discovery e posicionamento do SDD Kit

## Context

- Explore 2026-07-26: README raiz ausente; público *vibe coding* não encontra o kit; concorrentes (Spec Kit ~124k★, OpenSpec ~63k★, BMAD ~51k★, GSD ~65k★) dominam discovery com hero + demo + topics.
- Perfil do hub: **DOCS_SPECS** — este change é documentação/specs/kit README; sem código de aplicação.
- Viés duplo pedido pelo Pedro: (A) divulgar melhor; (B) usar a análise como partida para melhorar o produto — P0/P1 neste change; P2+ como backlog explícito.
- Research persistente: `openspec/changes/add-sdd-discovery-positioning/research.md` (promover a `doc/avaliacoes/` no apply).

## Goals / Non-Goals

**Goals:**

- Tornar o hub encontrável e compreensível em ≤30s para quem chega de *vibe coding*.
- Ancorar a narrativa “from vibe coding to agentic engineering” em artefactos versionados (avaliação + README + kit README + quickstart).
- Expor diferenciais reais (triplo stack, kit versionado, gates, session locks) sem prometer app scaffold.
- Registar backlog de produto P5–P10 para changes futuros.
- Spec normativa para não regredir (README raiz MUST existir).

**Non-Goals:**

- Boilerplate de app (Camada B) — permanente non-goal deste ciclo.
- GIF, GitHub Pages, Discord, rename do repo — follow-up / decisão humana.
- Alterar `install.sh` / MANIFEST payloads / fluxo `/opsx` (salvo menções documentais).
- Traduzir o guia inteiro para EN ou o README inteiro para pt-BR.
- Actualizar stars em CI — valores datados na avaliação bastam.

## Knowledge sources consulted (R8)

- `openspec/changes/add-sdd-discovery-positioning/research.md`
- `sdd-kit/README.md`, `doc/sistema-sdd-pedro.md`, `openspec/project.md`
- `doc/avaliacoes/README.md` + TEMPLATE de avaliações
- READMEs públicos: Spec Kit, OpenSpec (padrão de demo `/opsx`)
- GitHub API 2026-07-26 (stars/topics) — ver research §5
- `openspec/changes/explore-oss-coverage-gaps/research.md` — complementar (tooling gaps)

## Decisions

### D1: EN no README raiz; pt-BR na avaliação e no guia

- **Escolha:** Discovery GitHub = inglês; profundidade operacional = pt-BR (já dominante no guia).
- **Alternativa:** README bilíngue completo → rejeitada (duplicação e drift).
- **Mitigação:** link explícito “Guia completo (pt-BR)” no README.

### D2: Tom “from vibe → agentic”, não “stop vibe coding”

- **Escolha:** upgrade path empático.
- **Alternativa:** tom adversarial (“end of vibe coding”) → aliena o público-alvo da busca.

### D3: Avaliação em `doc/avaliacoes/` como documento de partida

- **Escolha:** `2026-07-26-sdd-discovery-positioning.md` espelha o `research.md` (pode ser cópia editorial + estado **Adoptado** para superfícies P0/P1 e **Adiado** para P5–P10).
- **Alternativa:** só `research.md` no change → perde-se após archive na prática de navegação humana; avaliações já são a fonte 6.

### D4: README curto; guia ganha só um quickstart

- **Escolha:** README ≤ ~200 linhas; nova subsecção curta no guia (ex. §2.0b ou bloco sob §2.0) “First contact / vibe coder”.
- **Alternativa:** reescrever §1–2 do guia → fora de R4.

### D5: Kit README ganha intro, não perde ops

- **Escolha:** prepend 1 secção “What this is / who it's for” + tabela amigável de cenários; resto intacto.
- **Alternativa:** README de marketing separado em `sdd-kit/DISCOVERY.md` → mais um ficheiro; preferir um único entry point.

### D6: Topics/About = acção manual

- **Escolha:** checklist no README ou na avaliação com `[AÇÃO MANUAL NECESSÁRIA]`; agente não altera settings GitHub.
- **Alternativa:** GitHub CLI write → indisponível / fora de política (gh read-only).

### D7: Backlog de produto no design + avaliação, não em tasks deste change

- Tasks deste change cobrem só P1–P4.
- P5 (GIF), P10 (nome), tradução EN e fame gaps: ver D9 + **D10** (roadmap §11 no research) — **não** misturar no apply.

### D8: Sem bump de MANIFEST obrigatório

- Só README do kit muda (não é template checksumado como payload de install, excepto se `sdd-kit/README.md` estiver no MANIFEST).
- Verificar no apply: se `README.md` do kit estiver no MANIFEST, correr `gen-manifest-checksums.sh`; senão, não bump de versão só por copy.

### D9: Gaps de concorrência — escopo fechado excepto demo visual (2026-07-26)

Decisão humana pós-explore de trade-offs:

| Item | Decisão |
|------|---------|
| Landing / GitHub Pages | **Não implementar** |
| Discord | **Não implementar** |
| One-liner fame (`npx` viral) | **Não implementar** (manter CTA `install.sh --dry-run`) |
| App scaffold (auth/DB/deploy) | **Não implementar** |
| BMAD multi-persona | **Não implementar** |
| Brand GitHub (Spec Kit) | **Não implementável / não perseguir** como estratégia |
| Rename / novo nome público (P10) | **Não neste change** — **sim no roadmap** após README (research §11); explore→propose próprios |
| Tradução completa EN | **Não neste change** — **sim no roadmap** após nome estável (research §11) |
| GIF / asciinema (P5) | **Não neste change** — explore de integração (E1–E6) **depois** do README e, idealmente, do nome estável |

No apply de `add-sdd-discovery-positioning`: demo do fluxo permanece **em texto** no README (como OpenSpec); sem asset binário; na avaliação canónica registar P5 como **Adiado — pending explore**; P10/i18n como **Adiado — roadmap §11**.

### D10: Roadmap de sequência — README → nome → EN → GIF (2026-07-26)

Registo pré-apply (pedido humano). Fonte canónica detalhada: `research.md` §11.

**Ordem obrigatória de administração (backlog OpenSpec, não mega-PR):**

1. **Apply** `add-sdd-discovery-positioning` (P1–P4) — working title ok  
2. **Explore→propose→apply** nome público / rebrand (P10)  
3. **Propose** policy “artefactos novos = EN; chat = pt-BR” + **waves** de tradução  
4. **Explore** GIF/asciinema (P5) → propose só se integração clara  
5. Landing/Discord/one-liner/scaffold/BMAD/brand — fora (D9)

**Razões condensadas:** discovery imediata sem bloquear em rename/i18n; nome antes de traduzir evita double work; GIF depois de narrativa/marca estáveis; chat pt-BR permanente para velocidade do Pedro.

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| Atrair utilizadores errados (querem só Next.js starter) | Anti-posicionamento no hero (D2 + research §2) |
| Stars desactualizados | Só na avaliação com data; README usa “order of magnitude” ou omite números |
| Drift research ↔ avaliação | Task de apply: diff ou cópia consciente; Gate grep de frases-chave |
| Jargão C1/G4 permanece no kit | Tabela amigável (P3) no topo do kit README |
| Expectativa de Discord/GIF/landing/rename/i18n neste apply | D9 + D10: fora de escopo; roadmap §11 |
| Traduzir tudo antes do rename | D10: proibido — nome estável primeiro |

## Migration Plan

1. Apply cria/actualiza ficheiros docs listados no proposal.
2. Humano aplica About + topics no GitHub (checklist).
3. Rollback: reverter commits do change; remover `README.md` raiz se necessário (estado anterior = ausente).

## Open Questions

| # | Questão | Estado |
|---|---------|--------|
| Q1 | Qual o nome público final / rename do repo? | **Adiada** — explore `explore-sdd-kit-public-name` após apply README (D10 / research §11); working title “SDD Kit” neste change |
| Q2 | Badge Discord/site no README? | **Fechada — não** (D9) |
| Q3 | Quantos concorrentes no compare do README? | Spec Kit, OpenSpec, BMAD + linha “vibe templates” |
| Q4 | Como integrar GIF/asciinema? | **Aberta — `/opsx:explore`** após README (e idealmente após nome); research §6.3 E1–E6 |
| Q5 | Inventário exacto pt-BR→EN? | **Adiada** — change `add-english-docs-policy` + waves (D10) |
