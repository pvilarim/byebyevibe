# Research — Superfície pública no lançamento (visibilidade + changelog)

| Campo | Valor |
|-------|-------|
| **Data** | 2026-07-26 (actualizado 2026-07-26 — EN default + substituição total de pt-BR) |
| **Change** | `explore-public-release-surface` (tipo E — exploração) |
| **Estado** | **Pronto para propose** — EN = idioma canónico do repo; pt-BR nos artefactos = legado a **substituir** (não bilíngue permanente); migração só via policy+waves |
| **Gatilho** | Operador pede propose de policy EN / waves (lançamento público ou preparação) |
| **Objectivo** | Registar decisões de explore sobre (1) superfície pública, (2) changelog, e (3) **migração segura para inglês como default**, com substituição de todo o português versionado — sem bugs, perda de contexto, termos errados ou overflow de tokens |
| **Não fazer nesta fase explore** | Não aplicar traduções em massa, não criar `CHANGELOG.md`, não split de repos, nem `.gitignore` de specs |
| **Fontes** | Explore 2026-07-26; `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` roadmap §11; `doc/sistema-sdd-pedro.md`; design discovery D1/D10; inventário LOC 2026-07-26; decisão humana: EN = default, substituir todos os termos PT |

## Resumo executivo

Num repo GitHub **público**, **não é possível** ter pastas versionadas e invisíveis a visitantes. Esconder `openspec/` / `doc/` via `.gitignore` quebra o hub SDD (agents, gates, OpenSpec).

**Decisão linguística (2026-07-26):**

| Camada | Idioma |
|--------|--------|
| **Default / canónico do repositório** | **English** — todos os artefactos versionados novos e migrados |
| **pt-BR em ficheiros do repo** | **Legado a eliminar** — substituir in-place por waves até residual ≈ 0 nas superfícies in-scope |
| **Conversa Pedro ↔ agente** | Pode continuar em **pt-BR** (velocidade humana) — isso **não** autoriza escrever artefactos em PT |

**Desenvolvimento futuro:**

1. Policy EN-default + waves de **substituição** (não “camada EN em cima do PT”).
2. Opcional `CHANGELOG.md` EN na raiz (F3).
3. Split ops privado só se dor real após migração.
4. **Proibido:** gitignore de specs/docs para “esconder português”; dual-file `*.en.md` permanente.

## Problema explorado

| Pedido | Interpretação |
|--------|----------------|
| Specs/pastas no repo mas “não visíveis” | Evitar que terceiros vejam conteúdo pt-BR e o trilho de desenvolvimento |
| Changelog das modificações principais | Superfície estável de “o que mudou” no projecto |

## Decisão registada (adiada)

| ID | Item | Decisão | Quando reabrir |
|----|------|---------|----------------|
| F1 | Esconder pastas no git público | **Não implementar** (impossível sem tirar do git) | — |
| F2 | Policy **EN = default** + waves de **substituição total** de pt-BR (seguras) | **Pronto para propose** — ver § Metodologia i18n segura; `add-english-docs-policy` + waves até residual PT ≈ 0 | Operador pede propose / lançamento |
| F7 | Conversa chat pt-BR vs artefactos EN | **Adoptado** — chat MAY pt-BR; **MUST NOT** criar/editar docs/skills/specs/templates em PT após policy | — |
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

Problema reenquadrado: **English é o idioma default/canónico do repositório.** O pt-BR nos ficheiros versionados é legado a **substituir** (in-place), não a manter em paralelo. Continua migração controlada (executabilidade + glossário + budget de tokens), mas o **Definition of Done** é residual PT ≈ 0 nas superfícies in-scope.

```
┌──────────────────────────────────────────────────────────────┐
│  CAMADA 1 — POLICY (1 change, 0 substituição em massa)       │
│  EN=default · glossário · inventário PT · gates · wave limits│
└────────────────────────────┬─────────────────────────────────┘
                             │ gates verdes
                             ▼
┌──────────────────────────────────────────────────────────────┐
│  CAMADA 2 — WAVES (N changes; 1 wave = 1 apply = 1 PR)       │
│  fatia · SUBSTITUIR pt→EN no mesmo path · verificar · commit │
└────────────────────────────┬─────────────────────────────────┘
                             │ todas as waves in-scope
                             ▼
┌──────────────────────────────────────────────────────────────┐
│  DoD GLOBAL — scanner PT residual fail-closed (in-scope)     │
└──────────────────────────────────────────────────────────────┘
```

### Princípios (MUST)

1. **EN = idioma default do repo.** Artefactos novos (proposal, design, specs, skills, guide, evaluations, rules prose, kit templates) **MUST** ser escritos em inglês após a policy.
2. **Substituição, não bilinguismo.** Waves **substituem** prosa pt-BR pelo EN canónico no **mesmo path**. Dual-file `*.en.md` / `*-pt.md` permanente = **proibido**.
3. **Meta: substituir todos os termos PT** nas superfícies in-scope. Excepções permanentes só com decisão humana explícita no spec.
4. **Policy antes de substituir.** Sem glossário + gates + limite de wave + inventário PT, proibido apply de migração.
5. **Uma wave = uma sessão apply.** Não empilhar o guia inteiro (~2.8k linhas) numa sessão.
6. **Congelar invariantes.** Paths, change-ids, slash commands, fences de código/shell, nomes de ficheiros, pins, keys MANIFEST — **nunca** “traduzir”.
7. **Glossário obrigatório.** Forma canónica EN; proibido inventar sinónimos por wave.
8. **Traduzir significado, não palavra-a-palavra.** Ambíguo → `[NEEDS VERIFICATION]`.
9. **Chat ≠ repo (F7).** Conversa Pedro ↔ agente **MAY** pt-BR; commits/artefactos **MUST** EN após policy.
10. **Espelhos em sync.** `.cursor/skills/` ↔ `.claude/skills/` (e commands) na **mesma wave**.
11. **Templates do kit = checksums.** `sdd-kit/templates/` → `gen-manifest-checksums.sh` na wave.
12. **Fail-closed.** Wave só fecha com gates verdes; sem N+1 antecipado.
13. **Features não esperam 100% EN** — PT legado só até à sua wave; ficheiro migrado fica EN-only.

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
| Linhas fonte a **substituir** | **≤ 350–400** | Cabe input + glossário + diff + gates |
| Ficheiros tocados | **≤ 4** (ou 1 skill × 2 espelhos = 2) | Review humano viável |
| Secções do guia | **1 secção `##` grande** ou **2–3 pequenas** | “Contexto sob demanda” (~693 linhas) = **≥2 waves** |
| Skills | **1 skill lógica** (Cursor + Claude mirror na mesma wave) | Evitar drift de espelho |
| Critério de fecho da wave | **Zero prosa PT residual** nos ficheiros da wave (deny-list) | Substituição completa da fatia |
| Duração | 1 apply session; se aproximar do limite → **parar, commit parcial se gates OK, Session Handoff** | |

**Ordem de waves sugerida (após policy):**

```
W0  Policy (EN=default, inventário, gates) — sem substituição em massa
W1  AGENTS.md + openspec/project.md + CLAUDE.md + rules prose (.mdc)
W2  sdd-kit/README.md + templates AGENTS.* / infra do kit (+ checksums)
W3+ Canonical guide por secção (install → pipelines → regras → anexos)
WSk Skills /opsx:* e reviews — uma skill lógica por wave (×2 mirrors)
WRu Remaining rules / commands mirrors
WAv Evaluations + TEMPLATE (substituir PT)
WCu doc/curso/ — in-scope por defeito (meta “todos os termos PT”);
    waves próprias; excepção só com decisão humana no propose
WAr openspec/changes/archive/** — FORA (histórico imutável);
    changes activos ainda PT → wave do tema ou wave active-changes
WCh CHANGELOG.md raiz (F3 — change próprio)
WDoD Scanner global PT residual fail-closed nas in-scope
```

### Gates de verificação (por wave)

Script proposto: `scripts/verify-i18n-wave.sh` (criado no **policy** change; usado em cada wave).

| Gate | O que verifica | Falha se |
|------|----------------|----------|
| G-INV | Freeze: paths/comandos/`opsx`/pins no output = AS-IS | Comando ou path “traduzido” |
| G-GLOSS | Forma canónica do glossário; sem sinónimos inventados | Termo fora do bank |
| G-PT | Deny-list de prosa PT nos ficheiros da wave (após migração) | Residual `não`, `ficheiro`, `também`, … (allowlist: nomes próprios, cites) |
| G-LINK | Links markdown relativos resolvem | Link partido |
| G-MIRROR | Pares `.cursor` ↔ `.claude` equivalentes | Só um lado mudou |
| G-MANIFEST | Templates tocados → checksums + `verify.sh` | SHA desactualizado |
| G-OPENSPEC | `openspec validate --all --strict` | Spec partida |
| G-SMOKE | 3 procedimentos críticos executáveis a partir do texto EN | Pedro marca fail |
| G-DoD | (fecho global) scanner PT residual em todas as in-scope | Qualquer prosa PT restante |

**Review humano obrigatório** em waves: install (§2), R1–R11, session coordination, MANIFEST/install docs.

### Estratégia de ficheiros

| Opção | Decisão |
|-------|---------|
| A — EN **substitui** PT no mesmo path | **Obrigatória** — única fonte de verdade |
| B — dual-file `*.en.md` | **Rejeitada** |
| C — snapshot PT em branch/tag antes da wave | Opcional só para rollback de emergência |

Paths com nome em PT (`doc/sistema-sdd-pedro.md`, `doc/avaliacoes/`) podem **manter o path** até wave de rename separada (quebra links) — o **conteúdo** já é EN. Rename de path ≠ obrigação da policy; é change próprio se desejado.

### Superfícies in-scope vs excepções

| Superfície | In-scope (substituir PT) | Notas |
|------------|--------------------------|-------|
| Guide, AGENTS, rules, skills, commands, kit templates/READMEs | **Sim** | Core |
| `doc/avaliacoes/`, `doc/design/` | **Sim** | |
| `doc/curso/` | **Sim por defeito** | Volume alto — waves próprias; Pedro pode marcar excepção no propose |
| `openspec/specs/` | Só residual PT | Maioria já EN |
| `openspec/changes/<activo>/` | **Sim** se ainda PT | |
| `openspec/changes/archive/` | **Não** | Histórico; não reescrever |
| Quotes / nomes próprios / URLs | Allowlist | Não são “termos a traduzir” |

### Riscos e mitigações

| Risco | Mitigação |
|-------|-----------|
| Overflow de tokens | ≤400 LOC; handoff mid-wave |
| Termo inconsistente | Glossário; G-GLOSS |
| Comando “ajudado” pelo LLM | G-INV; não reescrever fences |
| Residual PT esquecido | G-PT por wave + G-DoD global |
| Espelho Cursor≠Claude | G-MIRROR |
| Checksums kit | G-MANIFEST |
| Perda de nuance | Intenção; `[NEEDS VERIFICATION]`; review humano |
| Mega-PR | 1 wave = 1 PR; policy ≠ waves |
| Spec já EN reescrita | Fora das waves salvo delta explícito |
| “EN default” vs chat pt-BR | F7 explícito em AGENTS.md Comunicação |

### Escopo do change `add-english-docs-policy` (Camada 1)

**Inclui:**

- Spec `sdd-docs-language` — **EN = default do repo**; novos artefactos MUST EN; chat MAY pt-BR; waves MUST substituir (não dual-file); limites + gates; DoD residual PT ≈ 0 in-scope
- `doc/i18n/GLOSSARY.md` — bank canónico
- `doc/i18n/WAVES.md` (ou equivalente) — inventário PT + ordem + in-scope/excepções
- `scripts/verify-i18n-wave.sh` (+ modo DoD global) — G-INV, G-GLOSS, G-PT, G-LINK, G-MIRROR, G-MANIFEST, G-OPENSPEC
- Ponteiros AGENTS.md / `openspec/project.md` (secção Comunicação: chat vs artefactos)
- Template de proposal `translate-*-wave-N` (substituição, não “add English layer”)

**Não inclui:**

- Substituição em massa do guia / skills / avaliações / curso
- `CHANGELOG.md` raiz (F3)
- Rename de paths PT (`sistema-sdd-pedro.md` → `…`)
- Reescrever `openspec/changes/archive/`
- Dual-file `*.en.md`

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
| `doc/curso/` | grande | Média (volume) | **In-scope** — waves próprias; excepção só se Pedro marcar no propose |
| `openspec/changes/archive/` | — | — | **Fora** — histórico |

## Changelog — AS-IS (2026-07-26)

| Superfície | Estado |
|------------|--------|
| `doc/sistema-sdd-pedro.md` § Changelog do guia | ✅ canónico (v1.6.1 …) — pt-BR |
| `sdd-kit/MANIFEST.yaml` `version` | ✅ alinhado ao guia |
| `CHANGELOG.md` na raiz | ❌ inexistente |
| GitHub Releases como changelog de produto | não adoptado como processo |

## Non-goals deste explore

- Implementar substituição em massa, `CHANGELOG.md`, ou split de repos nesta sessão
- Alterar MANIFEST / install paths
- Dual-file `*.en.md`
- Reescrever `openspec/changes/archive/`
- Rename de paths com nome PT (change separado se desejado)

## Próximo passo

Explore **concluído** para F2 (EN=default + substituição total segura). Abrir **novo chat** (fase propose):

```
/opsx:propose add-english-docs-policy

Escopo = Camada 1 (policy), NÃO substituição em massa:
- Spec sdd-docs-language: EN = default/canónico do repo;
  novos artefactos MUST EN; chat MAY pt-BR (F7);
  waves MUST substituir PT→EN in-place (proibido dual-file);
  DoD = residual PT ≈ 0 nas superfícies in-scope
- doc/i18n/GLOSSARY.md + doc/i18n/WAVES.md (inventário + ordem + excepções)
- scripts/verify-i18n-wave.sh (G-INV, G-GLOSS, G-PT, G-LINK, G-MIRROR,
  G-MANIFEST, G-OPENSPEC + modo G-DoD global)
- Limite por wave: ≤350–400 LOC, ≤4 ficheiros, 1 skill×2 mirrors,
  zero prosa PT residual na fatia
- Template translate-*-wave-N (substituição, não “camada EN”)
- In-scope inclui doc/curso/ por defeito; archive/ FORA
- Non-goals deste change: migrar guia/skills/curso agora;
  CHANGELOG raiz (F3); rename de paths

Ler: openspec/changes/explore-public-release-surface/research.md
     (Metodologia i18n segura — EN default + substituição)
Avaliação: doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md (P11/P12)
Discovery: openspec/changes/add-sdd-discovery-positioning/research.md §11
Infra: openspec/infra.md (assumir ✅)
```

Depois do archive da policy: waves `/opsx:propose translate-…` — uma fatia por chat até G-DoD verde.

F3 (`add-root-changelog`) continua change próprio.

Um change por fatia (policy vs wave vs changelog); não mega-PR.
