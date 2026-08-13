# Research — defeitos de instalação em repositório consumidor (v1.14.0)

**Data:** 2026-08-07 · **Fase:** explore (nenhuma proposta ainda)
**Origem:** relatório de instalação real do operador — ByeByeVibe sdd-kit v1.14.0, cenário C1, perfil APP, alvo `c:\apps\immersivehomes`, Windows/Git Bash.
**Natureza da evidência:** primeira execução observada do caminho de instalação contra um repositório que não é o hub. Tudo abaixo foi confirmado por leitura do código no hub, com número de linha.

**Relação com [`explore-python-onboarding-ux/research.md`](../explore-python-onboarding-ux/research.md):** aquele documento, §13 item 11, registra que os achados foram todos obtidos por leitura e que "§4.1 e §12 teriam sido encontrados instantaneamente por execução". Este documento é essa execução. Ela produziu sete defeitos. Ver §8 abaixo para o impacto na base instalada assumida lá (três instalações, todas pré-1.14.0 — agora quatro, uma delas na versão atual).

---

## 1. Achado principal — nenhum caminho documentado instala v1.14.0 corretamente em perfil APP

O guia §1.6 define o caminho canônico multi-projeto como hub-mode:

```bash
bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>
```

Cruzando os dois defeitos bloqueantes com o perfil:

| Caminho | APP | DOCS_SPECS |
|---|---|---|
| **Hub-mode** (canônico, §1.6) | ❌ payload zero (defeito 1) | ❌ payload zero (defeito 1) |
| Kit copiado para dentro do repo | ❌ morre em 40/45 (defeito 2) | ✅ funciona |

O operador não encontrou "três defeitos contornáveis". Encontrou que a única forma de instalar APP no v1.14.0 é a combinação exata que ele improvisou — copiar `sdd-kit/` para o repo **e** rodar o `install.sh` do hub com `--repo`. Essa combinação não está documentada em lugar nenhum.

---

## 2. Defeito 1 — hub-mode: a assimetria do `--kit-root`

**Severidade: bloqueante. Atinge os dois perfis. Falha em silêncio (exit 0).**

O bootstrap resolve `--kit-root` para o preflight **dele**:

`scripts/bootstrap-sdd.sh:104-107`
```bash
PREFLIGHT_ARGS=(--all --repo-root "$REPO")
if [[ ! -f "$REPO/sdd-kit/install.sh" && -f "$SOURCE_ROOT/sdd-kit/install.sh" ]]; then
  PREFLIGHT_ARGS+=(--kit-root "$SOURCE_ROOT")     # ← hub-mode resolvido aqui
fi
```

E o `install.sh` roda o **seu próprio** preflight, sem repassar nada disso:

`sdd-kit/install.sh:228`
```bash
SDD_PYTHON_LINE="$(bash "$PREFLIGHT_SCRIPT" --repo --repo-root "$REPO_ROOT" --profile "$PROFILE")"
#                                            ↑ sem --kit-root
```

`scripts/preflight-sdd.sh:343-349` então grava `FAIL: sdd-kit/ missing under repo root`.

```
bootstrap-sdd.sh <target>
   │
   ├─ fase 0 ─── preflight --all --kit-root <hub> ──────────── PASS ✅
   │
   └─ fase kit ─ install.sh --repo <target>
                     │
                     └─ fase 0 ─ preflight --repo (sem kit-root) ─ FAIL ❌
                                            │
                                            └─ exit 1
                                                 │
   WARN: sdd-kit/install.sh failed  ◀────────────┘   (bootstrap segue e sai 0)
```

### Dois agravantes não presentes no relatório

1. **O bootstrap sai com código 0.** `scripts/bootstrap-sdd.sh:309-311` trata a falha do install como `WARN` e prossegue até imprimir "Done. Manual steps". É a mesma classe de falha que o 1.14.0 nasceu para eliminar — *nada foi instalado e o script declara conclusão*. Em CI, ou com um operador que não lê o scroll inteiro, passa despercebido.

2. **A spec já exige o conserto, mas só para metade dos callers.** `openspec/specs/sdd-install-preflight/spec.md:66` diz: *"when the caller provides a source kit root (e.g. a `--kit-root <path>` flag passed by `bootstrap-sdd.sh` hub-mode resolution)"*. O exemplo entre parênteses virou a implementação inteira. O `install.sh` também é um caller, e o texto normativo não o obriga a nada.

### Forma do conserto

O `install.sh` já conhece a raiz do kit — `KIT_DIR` em `sdd-kit/install.sh:6`. Pode derivar `--kit-root "$(dirname "$KIT_DIR")"` sozinho quando `$REPO_ROOT/sdd-kit` não existir. Sem flag nova, sem alteração no bootstrap. A spec precisa passar a dizer "todo caller", não "o bootstrap".

Aberto separadamente: o `WARN` do bootstrap deveria ser fatal. Um payload que não foi copiado não é uma advertência.

---

## 3. Defeito 2 — `cp: same file`: uma entrada do MANIFEST causa três defeitos

**Severidade: bloqueante. Apenas perfil APP.**

`sdd-kit/MANIFEST.yaml:253-258`
```yaml
- path: sdd-kit/templates/probity.config.ts     # destino DENTRO do repo
  source: templates/probity.config.ts           # origem DENTRO do kit
  profiles: [APP, HYBRID]                       # ← DOCS_SPECS escapa
```

Quando `KIT_DIR == REPO_ROOT/sdd-kit`, origem e destino são o mesmo arquivo. `sdd-kit/install.sh:310` faz `cp` puro sob `set -euo pipefail` → o script morre dentro do loop. É a entrada 40 de 45, então perdem-se as últimas 5 entradas **e** o `inject_language_policy`, que roda depois do loop (`sdd-kit/install.sh:436`). Confere com o relatado: sem skills, sem language policy.

Esta entrada é também a **única** coisa que cria o diretório `sdd-kit/templates/` num repositório consumidor — e esse diretório é o heurístico que o `verify.sh` usa para decidir "isto é o hub". Daí os defeitos 4 e 5.

---

## 4. Defeitos 4 e 5 — o `verify.sh` confunde todo consumidor APP com o hub

```
MANIFEST instala  sdd-kit/templates/probity.config.ts   (perfil APP)
        │
        └──▶ o diretório sdd-kit/templates/ passa a existir no consumidor
                    │
                    ├──▶ verify.sh:64  → "sou hub, cobro o template do workflow"
                    │         test -f sdd-kit/templates/.github/workflows/sdd-gates.yml
                    │         ↳ o MANIFEST nunca instala esse arquivo  →  FAIL bloqueante ❌
                    │
                    └──▶ verify.sh:125 → "sou hub, pulo a checagem de idioma"
                              ↳ INFO: hub distribution repo — skipped       →  buraco silencioso
```

**Defeito 4 — `sdd-kit/verify.sh:64-66`.** Numa instalação hub-mode limpa em APP, o `verify.sh` **falha e sai 1**. O operador não viu porque copiou o kit inteiro para dentro do repo, e o kit inteiro carrega `templates/.github/workflows/sdd-gates.yml`. O workaround mascarou um bug bloqueante.

**Defeito 5 — `sdd-kit/verify.sh:125-126`.** A nota do operador — *"este repo se auto-identifica como hub; efeito colateral de manter o kit completo; benigno"* — está errada em dois pontos:

- Não é efeito colateral de uma escolha do operador. Acontece em **toda** instalação APP, inclusive hub-mode puro.
- Não é benigno. É a única verificação automática da política de idioma no `project.md`, e ela nunca roda em nenhum consumidor APP existente.

---

## 5. Defeito 7 — a política de idioma nunca materializa, e as duas redes de segurança falham

**Severidade: alta. Provavelmente o mais grave da lista.** Estava escondido dentro de uma nota de rodapé do relatório ("escrevi o `project.md` porque não veio pronto").

Confirmado: `sdd-kit/templates/openspec/` contém exatamente dois arquivos — `infra.md` e `changes/_template/proposal.md`. **Não existe template de `project.md`.** O OpenSpec 1.3.1 não o gera em modo não-interativo, que é como o bootstrap o invoca (`scripts/bootstrap-sdd.sh:246`).

```
openspec init (não-interativo)  ──▶ sem project.md
        │
        ▼
install.sh:104  inject_language_policy()
        │  if [[ ! -f "$project_md" ]]
        │     WARN "openspec/project.md missing" ; return 0     ← não-fatal, meio do scroll
        ▼
verify.sh:125   "hub distribution repo — Language policy skipped"  ← defeito 5
        │
        ▼
  a capacidade sdd-language-policy inteira não existe no repo,
  e os dois mecanismos independentes que deveriam detectar isso
  falham em silêncio — um por não bloquear, outro por não rodar
```

`sdd-language-policy` é uma spec normativa deste projeto. Em toda instalação APP de v1.14.0 ela é vácuo.

---

## 6. Defeitos 3 e 6 — o hub nunca instala nele mesmo

**Defeito 3 (relatado pelo operador) — `_template` reprova no gate bloqueante.**
`sdd-kit/MANIFEST.yaml:195-200` instala `openspec/changes/_template/proposal.md` e nada mais. Sem `specs/`, o `openspec validate --all --strict` reprova com *"Change must have at least one delta"*. O gate é fail-closed: `.github/workflows/sdd-gates.yml:39`. CI vermelha no primeiro push, out of the box.

Por que o CI do hub é verde? Porque **`openspec/changes/_template/` não existe no hub** — verificado: o hub tem apenas os `explore-*` e `archive/`. O template é distribuído mas nunca executado onde é testado.

Workaround aplicado pelo operador no repo dele: criou `openspec/changes/_template/specs/example-capability/spec.md` com um delta placeholder normativo.

**Defeito 6 — ponteiros para um documento que o instalador nunca entrega.**
`doc/byebyevibe-guide.md` **não está no MANIFEST**. Os únicos docs instalados são `doc/design/000-004`, `doc/sdd-operator-day1.md` e `doc/tooling-install.md`. As referências `guia §2.x` em `sdd-kit/templates/AGENTS.core.md` (4 ocorrências) — e as quatro linhas de ponteiros que o próprio `install.sh` imprime ao final — apontam para o vazio em todo repositório consumidor.

Isto não é pendência do operador resolver copiando o guia. É o kit apontando para um arquivo que ele decidiu não distribuir.

---

## 7. Causa raiz — é uma só

```
┌──────────────────────────────────────────────────────────────┐
│  Defeitos  1 · 2 · 3 · 4 · 5 · 6 · 7                         │
│                                                              │
│  Todos encontrados por um operador em ~40 minutos de uso.    │
│  Nenhum encontrado pelo CI em 369 PRs.                       │
│                                                              │
│  Motivo único:  o hub valida a si mesmo.                     │
│                 ninguém nunca roda o instalador contra       │
│                 um repositório que não é o hub.              │
└──────────────────────────────────────────────────────────────┘
```

O `sdd-gates.yml` roda `validate --all --strict`, `verify-task-patterns.sh`, `verify.sh` e `verify-release-readiness.sh` — todos no hub: com `sdd-kit/` completo, com `templates/` presente, sem `_template/`, com `project.md` escrito à mão. Cada uma dessas condições é o inverso do que um consumidor tem.

### A proposta estrutural

Não é "consertar sete bugs". É **um smoke test de instalação consumidora no CI**: um job que cria um repositório temporário vazio, roda hub-mode, e afirma —

- 45/45 entradas do MANIFEST aplicadas
- `sdd-kit/verify.sh` exit 0
- `openspec validate --all --strict` exit 0
- `openspec/project.md` presente e com o bloco de language policy

Esse único teste pega os defeitos 1, 2, 3, 4, 5 e 7. Sem ele, os sete consertos viram sete PRs cuja correção ninguém consegue verificar.

---

## 8. Impacto sobre o research de Python onboarding

`explore-python-onboarding-ux/research.md` assume, no cabeçalho, **três instalações, todas anteriores à 1.14.0**, e decide em §15 segurar a proposta até chegar o diagnóstico do macOS.

Esta é a **quarta** instalação, é **1.14.0**, é Windows/Git Bash, e é a primeira que produziu observação em vez de inferência. Dois efeitos:

1. A base instalada muda de "três, todas antigas" para "quatro, uma delas na versão atual e com payload incompleto".
2. §11 daquele documento ("a ferramenta que atualiza está ela própria quebrada") ganha um caso concreto: o repo `immersivehomes` roda 1.14.0 com skills e language policy ausentes, e vai precisar de reparo — não de upgrade.

Recomendado: anexar referência cruzada nos dois sentidos quando qualquer um dos dois virar proposta.

---

## 9. Segunda questão do operador — a mensagem dos módulos opcionais

Texto atual, `sdd-kit/install.sh:478-492`:

```
Complementos opcionais (ponteiros apenas — não instalados agora):
  · UI (C1-UI)     → guia §2.11 · sdd-kit/install-ui-module
  · Probity (G2)   → guia §2.16 · sdd-kit/install-probity-module
  · CI gates       → guia §2.12 · proteção de branch (manual)
  · Métricas (G4)  → guia §2.17 · scripts/sdd-metrics
```

Dois problemas — e o segundo é maior que o primeiro:

1. Diz o nome e a sigla; não diz o que faz nem para quem serve. "Probity (G2)" não significa nada para quem nunca leu a spec.
2. **Os ponteiros apontam para um arquivo que não existe no repo** (defeito 6). E o conteúdo bom já existe: a tabela *"Optional add-ons at a glance"* em `doc/byebyevibe-guide.md:636-641` tem exatamente a estrutura "instale se… / pule se…". Ela simplesmente nunca chega ao operador.

### Decisão 1 — onde o conteúdo mora

| Opção | Prós | Contras |
|---|---|---|
| (a) inline no `install.sh` | autossuficiente; sobrevive ao scroll | output longo; duplica o guia |
| (b) `doc/optional-modules.md` no MANIFEST + uma linha por módulo no teaser | fica no repo; teaser curto | mais um arquivo para manter em sincronia |
| (c) `--explain` em cada script de módulo | chega no momento da decisão; `--detect` já é o 1º passo documentado | só quem já sabe que o módulo existe roda |

**Recomendação: (b) + (c).** Uma frase por módulo no fim do install (o que fica na tela), um doc local para quem quiser ler, e o `--detect` de cada módulo imprimindo a explicação completa junto do veredito de aplicabilidade — porque aí a explicação chega no instante em que a pessoa está decidindo.

### Decisão 2 — como o texto soa

Aplicando a fórmula pedida pelo operador ("Se você precisa de…, instale…, e tenha…") e o princípio de `explore-python-onboarding-ux/research.md` §10 (*dizer o que funciona, não só o que falta*):

```
┌─ Complementos opcionais ────────────────────────────────────────┐
│                                                                 │
│  MÓDULO DE UI                                                   │
│  Se o seu projeto tem tela — site, app, painel — e você não     │
│  quer que a IA invente um botão diferente em cada página,       │
│  instale o módulo de UI, e tenha um padrão visual escrito que   │
│  a IA lê antes de mexer no visual.                              │
│  Pule se: este repo não tem front-end.                          │
│    bash sdd-kit/install-ui-module.sh --detect                   │
│                                                                 │
│  PROBITY — teste antes do código                                │
│  Se você quer garantir que a IA escreva o teste primeiro (e     │
│  não um "teste" depois que tudo já está pronto e passando),     │
│  instale o Probity, e tenha um bloqueio automático: a IA não    │
│  consegue escrever o código sem um teste falhando antes.        │
│  Pule se: este projeto ainda não roda testes.                   │
│    bash sdd-kit/install-probity-module.sh --detect              │
│                                                                 │
│  TRAVAS DE CI                                                   │
│  Se o código vai para o GitHub e outra pessoa vai mexer nele,   │
│  ligue a proteção de branch, e tenha o merge barrado quando     │
│  spec ou tarefa estiverem fora do padrão.                       │
│  O robô já foi instalado; falta ligar a proteção no GitHub.     │
│  Pule se: só existe na sua máquina, sem remote.                 │
│                                                                 │
│  MÉTRICAS                                                       │
│  Se você já fechou umas cinco mudanças e quer saber onde o      │
│  tempo está indo, rode o relatório, e tenha tempo por mudança   │
│  e quanto virou retrabalho.                                     │
│  Pule no primeiro dia: sem histórico não há o que medir.        │
│    bash scripts/sdd-metrics.sh                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Observação de projeto:** "travas de CI" muda de natureza nessa redação. Não é um módulo a instalar — é um passo manual no GitHub que o texto atual esconde atrás de `§2.12 · proteção de branch (manual)`. Vale a mensagem detectar `git remote -v` vazio e dizer isso explicitamente, em vez de listar como opção genérica. Conecta com a pendência registrada pelo operador (repo local, sem remote, gates inertes).

---

## 10. Decomposição proposta

```
  P0 ──▶  fix-consumer-install-path                   defeitos 1, 2
          + smoke test de instalação consumidora      ← o gate que faltava
          Sem isto, nenhuma instalação APP funciona.

  P0 ──▶  fix-consumer-verify-detection               defeitos 4, 5
          Trocar o heurístico "sdd-kit/templates/ existe" por marcador
          explícito. Pré-requisito do smoke test acima — senão o teste
          falha pelo motivo errado.

  P1 ──▶  fix-shipped-template-validates              defeito 3
          _template com delta placeholder + o hub passando a validar
          aquilo que distribui.

  P1 ──▶  add-project-md-template                     defeito 7
          Template de project.md no MANIFEST; WARN do installer vira
          FAIL; verify volta a checar idioma no consumidor.

  P2 ──▶  fix-dangling-doc-pointers                   defeito 6
          + explain-optional-modules                  §9 acima
          Mesma raiz (ponteiros para doc não instalado), mesmo PR.
```

A ordem entre os dois P0 não é negociável: consertar o hub-mode sem consertar a detecção do `verify.sh` produz uma instalação que copia tudo e depois reprova na verificação.

---

## 11. Questões em aberto — decidir antes de escrever qualquer proposal

**O hub-mode deve deixar o `sdd-kit/` no destino?**
Hoje não deixa: o MANIFEST copia 3 arquivos avulsos para dentro de `sdd-kit/`, nunca o kit. O resultado é um repo que não consegue rodar `upgrade.sh` e cujo `verify.sh` reclama de MANIFEST ausente (`verify.sh:34`). O guia §1.6 diz *"APP consumer: copy `sdd-kit/` on upgrade as needed"*, mas não existe comando para fazer isso. Ou o hub-mode passa a copiar o kit inteiro, ou o C2 precisa de um caminho de aquisição próprio.

**A entrada `sdd-kit/templates/probity.config.ts` deveria existir?**
Ela sozinha origina os defeitos 2, 4 e 5. A razão de ser é que `install-probity-module.sh` lê o template de `$KIT_DIR/templates` (`sdd-kit/install-probity-module.sh:9`). Se o hub-mode passar a copiar o kit inteiro (pergunta acima), essa entrada some — e três defeitos somem com ela.

**O `WARN` do bootstrap quando o install falha deveria ser fatal?**
`scripts/bootstrap-sdd.sh:309-311`. Argumento a favor: um payload não copiado não é advertência. Argumento contra: o bootstrap trata GitNexus e Graphify como opcionais e não aborta por eles — mas o kit não é opcional; é a razão do comando existir.

**Quantas instalações existem de fato, e em que versão?**
`explore-python-onboarding-ux/research.md` §16 já pergunta isso para decidir se o procedimento de reparo precisa de um ramo macOS. Esta quarta instalação acrescenta uma segunda pergunta: quantas rodam 1.14.0 com payload incompleto sem que ninguém saiba.

---

## 12. Defeito 6 — veredicto da passada adversarial (2026-08-07, sessão posterior)

A recomendação inicial da sessão posterior — "na 1.15.0, reescrever os ~15 ponteiros para alvos que o MANIFEST entrega; INSTALL.md no tarball na 1.16.0" — foi submetida a passada adversarial com dois agentes de contexto limpo (um atacando a recomendação contra o código, outro escavando o arquivo de changes e specs). **A recomendação não sobreviveu.** As três afirmações que a sustentavam são falsas:

| Afirmação | Realidade medida |
|---|---|
| "~15 referências" | **78 ocorrências em 23 ficheiros** do tarball; ~52 em ficheiros instalados pelo MANIFEST; 6 links relativos no `sdd-operator-day1.md` que 404am em todo consumidor; `install.sh:128` **gera** um ponteiro para dentro do `project.md` do consumidor |
| "reescrita mecânica" | 10-11 das 11 referências do `AGENTS.core.md` **não têm alvo entregue** (§2.9 upgrade, §2.12 CI, §2.13 supply chain, §2.17 métricas: nada os cobre; os docs entregues reenviam eles próprios para o guia — `sdd-metrics.sh` e design-doc 004 literalmente). E **10 requirement lines fixam o texto dos ponteiros** (`sdd-operator-onboarding` ×6, `sdd-install-narrative` ×2, `sdd-install-kit` ×2) — seria delta em três specs, não edição de script |
| "valor imediato" | `AGENTS.md`/`CLAUDE.md`/`infra.md` são KEEP-quando-existem — **o patch nunca chegaria às 4 instalações existentes**; beneficiava só greenfield, que receberia a solução real na release seguinte |

### O que o arquivo revelou (pesquisa histórica)

- O **design fundador do kit** (`archive/2026-06-17-add-sdd-install-kit/design.md`) decidiu que o guia **seria copiado** para consumidores APP — layout com `doc/sistema-sdd-pedro.md`, Open Question Q2 resolvida com default "copiar com mesma tag/versão MANIFEST". A intenção nunca virou requirement e morreu em silêncio.
- A não-distribuição virou **decisão normativa a 2026-08-05** (`simplify-install-profiles`, kit 1.9.0): *"never receives it, never needs it"* em `sdd-install-narrative` e `sdd-install-kit` §1.6. Ou seja: duas decisões em direcções opostas, e a segunda nunca nomeou a primeira.
- **INSTALL.md nunca foi proposto nem rejeitado** — zero ocorrências em 116 changes arquivadas. Nada é re-litigado.
- O invariante footprint↔receita do `sdd-release-flow` impede artefactos novos no tarball — mas **conteúdo dentro de `sdd-kit/` entra de graça**, sem delta no release-flow.

### Conserto decidido (substitui a decomposição P2 do §10 para o defeito 6)

**Entregar o próprio guia na 1.15.0:**

1. Espelho em `sdd-kit/templates/doc/byebyevibe-guide.md` (dentro do tarball sem mudar o footprint)
2. Uma entrada `COPY` no MANIFEST → `doc/byebyevibe-guide.md` (o padrão exacto do `sdd-operator-day1.md`)
3. Paridade hub↔template no `verify-release-readiness.sh`
4. Delta honesto nas **duas** frases "never receives it, never needs it" (`sdd-install-narrative:122`, `sdd-install-kit:~133`) — o delta deve dizer explicitamente que reverte a decisão de 2026-08-05 e restaura a intenção do design fundador, para não parecer acidente

Custo: 1 entrada de MANIFEST + 1 delta pequeno, contra ~15 reescritas + ~10 deltas do plano rejeitado. **Valida as 78 referências de uma vez** — as spec-obrigatórias passam de penduradas a satisfeitas — e, por ser `COPY`, chega às instalações existentes via upgrade. O guia tem 175 KB / 2.439 linhas: trivial num tarball que já entrega cinco docs de design.

Efeito colateral a confirmar no apply: `verify-release-readiness.sh:33-35` hoje degrada para "INFO: absent — skipped" quando o guia falta; com o guia entregue, os version-claim checks passam a correr em consumidores. Provavelmente ganho; confirmar que não vira ruído.

O INSTALL.md/guia-aparado é rebaixado a melhoria de conteúdo pós-1.15.0 — deixa de ser pré-requisito para consertar ponteiros. O racional de 2026-08-05 (operadores confundidos pelo hub cheio de specs) não é violado: um ficheiro de guia não é a história de desenvolvimento do hub.

---

## 13. Estado do repositório do operador (`c:\apps\immersivehomes`)

Registrado para que o reparo saiba do que parte. Instalado v1.14.0, C1, perfil APP, Windows.

**Verde ao final:** `sdd-kit/verify.sh` exit 0 · `openspec validate --all --strict` 1 passed / 0 failed · OpenSpec 1.3.1 · GitNexus 1.6.5 (848 nós, 891 arestas) · Graphify 0.8.5 (1474 nós, 152 comunidades, hooks git instalados) · git local (branch `main`, 2 commits).

**Escrito à mão pelo operador, não entregue pelo kit:**

| Arquivo | Motivo | Ressalva |
|---|---|---|
| `openspec/project.md` | defeito 7 — sem template, sem geração | pontos incertos marcados `[NEEDS VERIFICATION]` em Purpose, Architecture Patterns, Testing Strategy |
| `AGENTS.md` | GitNexus escreveu o arquivo inteiro antes do install → o installer pulou o MERGE (`install.sh:353-356`) | reconstruído de `AGENTS.core.md` + tabela APP; tabela Commands adaptada (o template APP assume `npm run dev`/`npm test`, inexistentes ali) |
| `openspec/changes/_template/specs/example-capability/spec.md` | defeito 3 — workaround para o gate | delta placeholder normativo |
| `CLAUDE.md` | template do kit, sem alteração | — |

**Pendências abertas do operador:** sem remote no GitHub (gates e branch protection inertes) · `doc/byebyevibe-guide.md` ausente (defeito 6) · módulos UI e Probity não instalados.

**Nota sobre o `AGENTS.md`:** o caso "GitNexus escreve o arquivo inteiro, o installer vê arquivo existente e pula" é um oitavo defeito em potencial — ordem de fases no bootstrap (GitNexus roda em `bootstrap-sdd.sh:257-260`, antes do kit em `:286`). Não investigado nesta sessão.
