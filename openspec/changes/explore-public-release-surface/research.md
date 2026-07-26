# Research — Superfície pública no lançamento (visibilidade + changelog)

| Campo | Valor |
|-------|-------|
| **Data** | 2026-07-26 (actualizado 2026-07-26 — metodologia i18n segura) |
| **Change** | `explore-public-release-surface` (tipo E — exploração) |
| **Estado** | **Pronto para propose** — metodologia de migração segura cristalizada; implementação só via changes separados |
| **Gatilho** | Operador pede propose de policy EN / waves (lançamento público ou preparação) |
| **Objectivo** | Registar decisões de explore sobre (1) o que visitantes vêem vs docs/processo interno, (2) changelog de produto visível, e (3) **como traduzir sem bugs, perda de contexto, termos errados ou overflow de tokens** |
| **Não fazer nesta fase explore** | Não aplicar traduções em massa, não criar `CHANGELOG.md`, não split de repos, nem `.gitignore` de specs |
| **Fontes** | Explore 2026-07-26; `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` roadmap §11; `doc/sistema-sdd-pedro.md`; design discovery D1/D10; inventário LOC 2026-07-26 |

## Resumo executivo

Num repo GitHub **público**, **não é possível** ter pastas versionadas e invisíveis a visitantes. Esconder `openspec/` / `doc/` via `.gitignore` quebra o hub SDD (agents, gates, OpenSpec).

**Desenvolvimento futuro (quando for público de facto):**

1. **Preferir** policy EN + waves de tradução (roadmap discovery §11 passo ④) — superfície amigável sem fingir invisibilidade.
2. **Opcional** `CHANGELOG.md` EN na raiz (fino) apontando ao changelog canónico do guia §14 (hoje só existe lá; **não** há `CHANGELOG.md` na raiz).
3. **Só se necessário** split `byebyevibe` (público) + repo ops privado — não é pré-requisito.
4. **Proibido como “solução”:** gitignore de `openspec/specs/`, `openspec/changes/`, ou `sdd-kit/` para “não mostrar português”.

Chat humano ↔ agente permanece **pt-BR** (AGENTS.md). Specs normativas muitas já estão em EN.

## Problema explorado

| Pedido | Interpretação |
|--------|----------------|
| Specs/pastas no repo mas “não visíveis” | Evitar que terceiros vejam conteúdo pt-BR e o trilho de desenvolvimento |
| Changelog das modificações principais | Superfície estável de “o que mudou” no projecto |

## Decisão registada (adiada)

| ID | Item | Decisão | Quando reabrir |
|----|------|---------|----------------|
| F1 | Esconder pastas no git público | **Não implementar** (impossível sem tirar do git) | — |
| F2 | Policy “artefactos novos = EN” + waves i18n **seguras** | **Pronto para propose** — ver § Metodologia i18n segura; change `add-english-docs-policy` (policy+glossário+gates); waves em changes separados | Operador pede propose / lançamento |
| F3 | `CHANGELOG.md` raiz (EN, fino) | **Adiado** — change futuro `add-root-changelog` | Lançamento / repo público |
| F4 | GitHub Releases espelhando versões kit | **Adiado** — opcional junto de F3 | Lançamento / repo público |
| F5 | Repo ops privado (guia/avaliações/archive) | **Adiado — só se dor real** após F2 | Se superfície pública ainda parecer “ruído” |
| F6 | `.gitignore` de specs/changes/docs | **Descartado** como estratégia de privacidade | Nova proposta só com justificação forte |

## Relação com o backlog de discovery

```
① README EN                    ✅
②–③ ByeByeVibe + slug          ✅ (manual no GitHub)
④ Policy EN + waves            ← F2 (este research; futuro)
   + CHANGELOG.md raiz (EN)    ← F3 (este research; futuro)
⑤ GIF                          Adiado (P5)
⑥ Landing/Discord              Não implementar
```

Inventário i18n detalhado: ver § Inventário AS-IS (abaixo). Waves de tradução: **proibidas** no change de policy — só depois dos gates existirem.

## Metodologia i18n segura (cristalizada 2026-07-26)

Problema reenquadrado: não é “traduzir para inglês”; é **migração documental controlada** que preserva executabilidade (comandos, paths, gates), semântica SDD (termos), e cabimento em sessões de agente (budget de tokens).

```
┌──────────────────────────────────────────────────────────────┐
│  CAMADA 1 — POLICY (1 change, 0 tradução em massa)           │
│  glossário · regras · inventário · script de gates · limits  │
└────────────────────────────┬─────────────────────────────────┘
                             │ gates verdes
                             ▼
┌──────────────────────────────────────────────────────────────┐
│  CAMADA 2 — WAVES (N changes; 1 wave = 1 apply = 1 PR)       │
│  fatia pequena · traduz · verifica · commit · handoff        │
└──────────────────────────────────────────────────────────────┘
```

### Princípios (MUST)

1. **Policy antes de traduzir.** Sem glossário + gates + limite de wave, proibido abrir apply de tradução.
2. **Uma wave = uma sessão apply.** Não empilhar o guia inteiro (~2.8k linhas) numa sessão.
3. **Congelar invariantes.** Paths, change-ids, slash commands, fences de código/shell, nomes de ficheiros, pins de versão, campos MANIFEST — **nunca** “traduzir”.
4. **Glossário obrigatório.** Termos de domínio (OpenSpec, explore/propose/apply/archive, gate, skill, worktree, ByeByeVibe, sdd-kit, R1–R11, …) têm forma canónica EN; proibido inventar sinónimos por wave.
5. **Traduzir significado, não palavra-a-palavra.** Ambiguidades → nota em `design.md` da wave ou `[NEEDS VERIFICATION]`, não “chute elegante”.
6. **Chat humano permanece pt-BR** (AGENTS.md). Policy de artefactos ≠ idioma da conversa.
7. **Espelhos em sync.** `.cursor/skills/` e `.claude/skills/` (e commands) traduzem-se na **mesma wave**; nunca só um lado.
8. **Templates do kit = checksums.** Qualquer edição em `sdd-kit/templates/` → `bash sdd-kit/gen-manifest-checksums.sh` na mesma wave.
9. **Fail-closed nas waves.** Gates falham → wave não fecha; não avançar para wave N+1.
10. **Não bloquear features** à espera de 100% EN — legado pt-BR convive até a wave respectiva.

### O que NÃO traduzir (freeze list)

| Categoria | Exemplos | Porque |
|-----------|----------|--------|
| Paths / globs | `openspec/changes/`, `sdd-kit/install.sh` | Quebra install e agentes |
| Change-ids / branches | `add-english-docs-policy` | Links e `openspec validate` |
| Slash / skills | `/opsx:apply`, `openspec-explore` | Descoberta de skills |
| Shell / CI | `npx openspec validate`, `bash scripts/…` | Executabilidade |
| Pins / versões | `@fission-ai/openspec@1.3.1` | Supply chain |
| Identifiers de código | `enforceTdd`, `MANIFEST.yaml` keys | Runtime |
| Anchors estáveis já EN | headings RFC em specs | Links internos |
| Marca | ByeByeVibe, OpenSpec, GitNexus, Graphify | SEO + identidade |

### Glossário (seed — expandir no propose/policy)

| pt-BR (legado) | EN canónico | Notas |
|----------------|-------------|-------|
| mudança / change OpenSpec | change | id kebab-case intacto |
| propor / proposta | propose / proposal | |
| aplicar | apply | |
| explorar | explore | |
| arquivar | archive | |
| porta / gate | gate | comando de verificação |
| habilidade | skill | path `.cursor/skills/` |
| sessão / handoff | session / Session Handoff | |
| worktree | worktree | não traduzir |
| perfil APP / DOCS_SPECS | APP / DOCS_SPECS profile | |
| kit de instalação | install kit / sdd-kit | path `sdd-kit/` intacto |
| guia canónico | canonical guide | ficheiro pode manter path legado até wave do rename |
| avaliação | evaluation | `doc/avaliacoes/` path até wave |
| correcção manual | manual fix (out of kit) | do research OSS |
| falha fechada / aberta | fail-closed / fail-open | |

### Limites de wave (anti token-overflow)

Inventário LOC (2026-07-26):

| Superfície | ~LOC | Risco se 1 sessão |
|------------|------|-------------------|
| `doc/sistema-sdd-pedro.md` | ~2847 | **Crítico** — overflow + perda de contexto |
| Skills (espelhos) | ~2922 total | Crítico se batch único |
| Avaliações | ~523 | Médio |
| `AGENTS.md` + rules | ~300 | Baixo–médio |
| `sdd-kit/templates/*.md` | 11 ficheiros | Médio + checksums |

**Orçamento por wave (normativo proposto):**

| Limite | Valor sugerido | Motivo |
|--------|----------------|--------|
| Linhas fonte a traduzir | **≤ 350–400** | Cabe input + glossário + diff + gates |
| Ficheiros tocados | **≤ 4** (ou 1 skill × 2 espelhos = 2) | Review humano viável |
| Secções do guia | **1 secção `##` grande** ou **2–3 pequenas** | “Contexto sob demanda” (~693 linhas) = **≥2 waves** |
| Skills | **1 skill lógica** (Cursor + Claude mirror na mesma wave) | Evitar drift de espelho |
| Duração | 1 apply session; se aproximar do limite → **parar, commit parcial se gates OK, Session Handoff** | |

**Ordem de waves sugerida (após policy):**

```
W0  Policy change (sem tradução em massa)
W1  AGENTS.md + openspec/project.md + CLAUDE.md (ponteiros curtos)
W2  sdd-kit/README.md (já misto) + templates AGENTS.* do kit
W3+ Guia canónico por secção (install → pipelines → regras → anexos)
WSk Skills /opsx:* (explore, propose, apply, archive) uma a uma
WAv Avaliações / TEMPLATE (baixa prioridade pública)
WCh CHANGELOG.md raiz (F3 — change próprio ou última wave pública)
```

### Gates de verificação (por wave)

Script proposto: `scripts/verify-i18n-wave.sh` (criado no **policy** change; usado em cada wave).

| Gate | O que verifica | Falha se |
|------|----------------|----------|
| G-INV | Freeze: paths/comandos/`opsx`/pins presentes no diff de saída iguais ao AS-IS | Comando ou path “traduzido” |
| G-GLOSS | Termos do glossário: proibidos sinónimos inventados; lista deny de PT em ficheiros marcados EN | Termo fora do bank |
| G-LINK | Links markdown relativos resolvem | Link partido |
| G-MIRROR | Pares `.cursor/skills/X` ↔ `.claude/skills/X` diff-equivalentes em substância | Só um lado mudou |
| G-MANIFEST | Se `sdd-kit/templates/` tocado → checksums regenerados e `verify.sh` OK | SHA desactualizado |
| G-OPENSPEC | `openspec validate --all --strict` | Spec partida |
| G-SMOKE | Checklist humano curto: 3 procedimentos críticos ainda executáveis a partir do texto EN | Pedro marca fail |

**Review humano obrigatório** em waves que tocam: install (§2), R1–R11, session coordination, MANIFEST/install scripts docs.

### Estratégia de ficheiros (evitar drift e bugs)

| Opção | Prós | Contras | Decisão explore |
|-------|------|---------|-----------------|
| A — EN substitui PT no mesmo path | Uma fonte de verdade | Pedro perde PT no ficheiro | **Preferida para superfícies públicas** após wave verde |
| B — ficheiros paralelos `*.en.md` | Rollback fácil | Drift duplo; agentes leem o errado | **Rejeitada** como default |
| C — PT em `arquivo` / branch | Histórico | Extra processo | Só se wave falhar e precisar rollback pontual |

Chat pt-BR + artefactos EN resolve a dor do Pedro **sem** dual-file. Guia: path pode permanecer `doc/sistema-sdd-pedro.md` (nome legado) até wave opcional de rename de path — **rename de path é change separado** (quebra links).

### Riscos e mitigações

| Risco | Mitigação |
|-------|-----------|
| Overflow de tokens / compactação a meio | Limite ≤400 linhas; handoff mid-wave |
| Termo inconsistente entre waves | Glossário no policy; G-GLOSS |
| Comando “ajudado” pelo LLM | G-INV + diff review; proibir reescrita de fences |
| Espelho Cursor≠Claude | G-MIRROR |
| Checksums kit | G-MANIFEST |
| Perda de nuance pt-BR | Traduzir intenção; `[NEEDS VERIFICATION]` se ambíguo; review humano em waves críticas |
| Mega-PR irrevisável | 1 wave = 1 PR; policy ≠ waves |
| Spec normativa reescrita por engano | Specs já EN: **fora** das waves salvo delta explícito |

### Escopo do change `add-english-docs-policy` (Camada 1)

**Inclui:**

- Spec (ex. `sdd-docs-language`) — policy novos artefactos = EN; chat = pt-BR; waves MUST respeitar limites e gates
- `doc/i18n/GLOSSARY.md` (ou path equivalente) — bank canónico
- Inventário inicial de superfícies + ordem de waves (pode viver na avaliação ou `doc/i18n/WAVES.md`)
- `scripts/verify-i18n-wave.sh` + menção em AGENTS.md Commands
- Ponteiros em `openspec/project.md` / AGENTS.md
- Template curto de proposal para `translate-*-wave-N`

**Não inclui:**

- Tradução em massa do guia / skills / avaliações
- `CHANGELOG.md` raiz (F3 — change `add-root-changelog`)
- Tornar repo público / rename paths
- i18n de runtime de app (N/A — DOCS_SPECS)

## Inventário AS-IS (ordem de grandeza)

| Path | ~LOC / N | Prioridade pública | Notas |
|------|----------|--------------------|-------|
| `README.md` | ~129 | — | Já EN |
| `doc/sistema-sdd-pedro.md` | ~2847 | Alta | Waves por secção; § “Contexto sob demanda” ~693 → multi-wave |
| Skills espelhadas | ~2922 | Alta (opsx) | 1 skill/wave |
| `sdd-kit/templates/*.md` | 11 files | Alta (consumidores) | + checksums |
| `AGENTS.md` / rules | ~300 | Alta | W1 |
| `doc/avaliacoes/` | ~523 | Média | Depois do guia core |
| `openspec/specs/` | — | Baixa | Maioria já EN — não reescrever |
| `doc/curso/` | grande | Baixa / fora | Workshop pt-BR; **fora** do lançamento salvo decisão humana |

## Changelog — AS-IS (2026-07-26)

| Superfície | Estado |
|------------|--------|
| `doc/sistema-sdd-pedro.md` § Changelog do guia | ✅ canónico (v1.6.1 …) — pt-BR |
| `sdd-kit/MANIFEST.yaml` `version` | ✅ alinhado ao guia |
| `CHANGELOG.md` na raiz | ❌ inexistente |
| GitHub Releases como changelog de produto | não adoptado como processo |

## Non-goals deste explore

- Implementar tradução em massa, `CHANGELOG.md`, ou split de repos nesta sessão
- Alterar MANIFEST / install paths
- Dual-file `*.en.md` como default
- Traduzir `doc/curso/` no lançamento (salvo decisão humana explícita)

## Próximo passo

Explore **concluído** para F2 (metodologia segura). Abrir **novo chat** (fase propose):

```
/opsx:propose add-english-docs-policy

Escopo = Camada 1 (policy), NÃO tradução em massa:
- Spec sdd-docs-language (novos artefactos EN; chat pt-BR; waves com limites)
- doc/i18n/GLOSSARY.md + inventário/ordem de waves
- scripts/verify-i18n-wave.sh (G-INV, G-GLOSS, G-LINK, G-MIRROR, G-MANIFEST, G-OPENSPEC)
- Limite por wave: ≤350–400 LOC fonte, ≤4 ficheiros, 1 skill×2 mirrors
- Template de change translate-*-wave-N
- Non-goals: traduzir guia/skills neste change; CHANGELOG raiz (F3); dual-file *.en.md

Ler: openspec/changes/explore-public-release-surface/research.md
     (secção Metodologia i18n segura + Inventário AS-IS)
Avaliação: doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md (P11/P12)
Discovery roadmap: openspec/changes/add-sdd-discovery-positioning/research.md §11
Infra: openspec/infra.md (assumir ✅)
```

Depois do archive da policy: waves em chats `/opsx:propose translate-…` separados — um por fatia.

F3 (`add-root-changelog`) continua change próprio, opcionalmente após W1 ou no fim das waves públicas.

Um change por fatia (policy vs wave vs changelog); não mega-PR.
