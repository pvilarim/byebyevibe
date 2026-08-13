# Research — instalação mediada por agente e caminho único de aquisição

**Data:** 2026-08-07 · **Fase:** explore (nenhuma proposta ainda)
**Escopo:** para *quem* e por *qual caminho* o ByeByeVibe é instalado. Complementa [`explore-consumer-install-defects/research.md`](../explore-consumer-install-defects/research.md), que cobre *o que está quebrado*.
**Público assumido:** operadores sem conhecimento técnico, que colam a URL do repositório no prompt de um agente e pedem para instalar.

> **Sobreposição conhecida com outra sessão.** Itens marcados `[SESSÃO-MAC]` estão sendo tratados em paralelo (diagnóstico de instalação em macOS). Ver §8 para o mapa de união.

---

## 1. Decisões tomadas pelo operador nesta sessão

| # | Decisão | Consequência principal |
|---|---|---|
| D1 | **Um único caminho de instalação:** o tarball da release mais recente | O caminho "hub → destino" morre; três specs mudam (§3) |
| D2 | **O projeto recebe `sdd-kit/` inteiro**, sem `doc/` e sem `openspec/` do hub | O tarball já define essa fronteira; detecção de hub por pasta deixa de funcionar |
| D3 | **Perfil detectado, não perguntado — mas exibido** ao usuário com a evidência | Código de detecção já existe (`bootstrap-sdd.sh:300-304`) |
| D4 | **Idioma é perguntado.** A escolha não pode desaparecer | Não é garantível por script; é garantível por confirmação humana (§5) |
| D5 | **README impositivo** logo após a descrição do que é o ByeByeVibe | Bloco de instalação antes do pitch de produto |
| D6 | **Clonar o repo inteiro é permitido, mas deve ser avisado** — o repo carrega a documentação de desenvolvimento, não só o kit | Solução por rotulagem, não por prevenção |
| D7 | **Reinstalação:** perguntar ao usuário sobre comparação entre arquivos customizados e a versão nova | Avaliado e recontornado em §6 |

---

## 2. O que a decisão D1 elimina de graça

Dois dos sete defeitos do research anterior **desaparecem por simplificação**, não por conserto:

**Defeito 1 (assimetria do `--kit-root`) — deletado.** A exceção hub-mode existe apenas para servir o caminho que morre. Sem hub-mode, o `--kit-root` do preflight some junto.

**Defeito 2 (`cp: same file`) — deletado.** A receita do §1.6 já faz `cp -R .../sdd-kit ./sdd-kit`. Com o kit inteiro no destino, as três entradas do MANIFEST que copiam *para dentro* de `sdd-kit/` viram redundantes:

```yaml
- path: sdd-kit/install-ui-module.sh
- path: sdd-kit/install-probity-module.sh
- path: sdd-kit/templates/probity.config.ts   ← a que causa o cp em si mesmo
```

Elas existem para compensar o caminho B, que não entrega o kit. Deletar as três mata o defeito 2 na origem, sem precisar de guarda `src == dest`.

```
   Antes:  7 defeitos
   Após D1+D2:  5 — dois somem só de remover um caminho
```

**Sinal de projeto:** quando remover um caminho apaga bugs em vez de movê-los, o caminho estava sobrando.

**O que NÃO desaparece:** defeitos 4 e 5 (detecção de hub pelo `verify.sh`) ficam **obrigatórios**. Com o kit inteiro no destino, `sdd-kit/templates/` passa a existir em 100% das instalações, e o heurístico atual erra sempre. Isto vem primeiro no plano de execução.

---

## 3. O custo escondido de D1 — o caminho B é normativo

Matar o caminho hub → destino não é edição de documentação. Está escrito como **MUST**:

| Arquivo | Requisito |
|---|---|
| `openspec/specs/sdd-install-kit/spec.md:133` | *"§1.6 MUST document the hub→destination flow as the canonical multi-project UX"* |
| `openspec/specs/sdd-install-kit/spec.md:653` | Cenário normativo com `bash <hub>/scripts/bootstrap-sdd.sh <target> --profile APP` |
| `openspec/specs/sdd-install-narrative/spec.md:146` | A mensagem final MUST ensinar o comando do próximo projeto — que é o comando do caminho B |
| `openspec/specs/sdd-install-preflight/spec.md:66` | A exceção `--kit-root` hub-mode é requisito normativo |

Código e docs afetados: `scripts/bootstrap-sdd.sh` (linhas 102, 294, 336, 346) · `scripts/preflight-sdd.sh:43` · `sdd-kit/README.md:64` · `doc/byebyevibe-guide.md` (124-127, 328).

**Implicação para o proposal:** deltas em **três capacidades** (`sdd-install-kit`, `sdd-install-narrative`, `sdd-install-preflight`), mais texto novo para a mensagem didática de fim de instalação — que hoje ensina o caminho que vai morrer.

---

## 4. O vetor real de instalação — evidência

O usuário cola a URL no prompt. O agente abre o repositório. O que ele encontra, em ordem:

### 4.1 O primeiro comando do README é o errado

`README.md`, seção "Get started (30 seconds)":

```bash
bash sdd-kit/install.sh --profile APP --dry-run
```

E o texto de ajuda do próprio `install.sh` (`sdd-kit/install.sh:159`):

> *"Does NOT run openspec init or install global CLIs — **use scripts/bootstrap-sdd.sh first**."*

O README manda rodar exatamente a ferramenta que se declara errada como ponto de entrada.

### 4.2 O repositório é ~18× maior que a coisa a instalar

```
   O QUE INSTALA          O QUE O AGENTE ENCONTRA
   ─────────────          ───────────────────────────────────
   sdd-kit/               doc/          3.3 MB    41 arquivos
   434 KB                 openspec/     4.5 MB   662 arquivos
   55 arquivos            graphify-out/  13 MB
                          ───────────────────────────────────
                          ~21 MB de história de desenvolvimento
```

Os 662 arquivos em `openspec/` são as specs e mudanças **do próprio ByeByeVibe**.

### 4.3 O `AGENTS.md` da raiz sequestra o agente

O `AGENTS.md` do hub é o manual de desenvolvimento do ByeByeVibe e instrui:

> **Knowledge sources (by priority):** 1. `./openspec/specs/` · 2. `./openspec/changes/` · 3. `./graphify-out/GRAPH_REPORT.md` …
> **NEVER** assert a fact that cannot be anchored to one of sources 1–6.

Um agente que abre o repositório para instalar conclui que seu trabalho é desenvolver o ByeByeVibe seguindo o protocolo do ByeByeVibe. O padrão `agents.md` funcionou — apontado para a pessoa errada.

O mesmo arquivo carrega referência desatualizada: *"SDD install guide (v1.7.0)"*, com o kit em 1.14.0.

### 4.4 Versão: metade resolvida

**Resolvida:** existe URL sem versão — `releases/latest/download/byebyevibe-kit.tar.gz`. O agente nunca precisa saber a versão; o GitHub resolve server-side em um redirect, sem autenticação. Bem construído.

**Não resolvida:** nada aponta o agente para essa URL primeiro. Ela está no §1.6 de um guia de ~3200 linhas em pt-BR.

---

## 5. D4 — como garantir a pergunta de idioma

### 5.1 O limite

```
   usuário  ──fala──▶  agente  ──executa──▶  install.sh
      ▲                                            │
      └────────── quem consegue perguntar? ────────┘
                        SÓ o agente.
```

O `install.sh` não alcança o usuário. **Não existe mecanismo em shell que force o comportamento de quem o invoca.** O garantível é outro enunciado:

> Nenhuma instalação válida existe sem uma escolha declarada — e o usuário vê o que foi decidido em nome dele.

### 5.2 Onde a escolha desaparece hoje — três pontos independentes

```
   ①  A PERGUNTA NUNCA É FEITA
       install.sh:57-77 — pergunta só se [[ -t 0 ]]; senão "en" em silêncio
                        ▼
   ②  O BOOTSTRAP SÓ REPASSA UM TERÇO
       bootstrap-sdd.sh:306-308 — passa --chat-lang; nunca --docs-lang/--code-lang
                        ▼
   ③  A ESCOLHA NÃO É GRAVADA
       destino é openspec/project.md, que não existe (defeito 7)
       install.sh:104 → WARN → return 0 → escolha descartada
```

Três falhas independentes, cada uma suficiente sozinha.

### 5.3 Quatro camadas, e só a última fecha

| | Mecanismo | Onde falha |
|---|---|---|
| **M1** | Sem `--chat-lang`, aborta (remove o default silencioso) | O agente satisfaz o erro escolhendo `en` sozinho — é o que agentes fazem com mensagens de erro |
| **M2** | "Não escolhido" vira estado representável (`undeclared` ≠ `en`); `verify.sh` reprova nele | Impede o silêncio, não a invenção |
| **M3** | O `INSTALL.md` do tarball instrui: pergunte antes, não escolha pelo usuário | Continua sendo instrução, não trava |
| **M4** | **O usuário vê o que foi decidido em nome dele** | Nenhuma — o revisor é humano |

M2 aplica diretamente a lição do defeito 7: as duas redes de segurança falharam porque ambas tratavam **ausência de resposta como permissão**.

### 5.4 O bloco de confirmação — resolve D3 e D4 juntos

```
┌─ Antes de escrever qualquer arquivo ────────────────────────────┐
│  Vou instalar com estas decisões:                               │
│                                                                 │
│    Projeto        c:\apps\meu-projeto                           │
│    Perfil         APP                                           │
│                   ↳ porque encontrei package.json aqui          │
│    Idioma         pt-BR                                         │
│                   ↳ porque você escolheu                        │
│    Versão do kit  1.15.0  (a mais recente publicada)            │
│                                                                 │
│  Está certo? Se algo estiver errado, pare agora.                │
└─────────────────────────────────────────────────────────────────┘
                          ── instala ──
┌─ No fim ────────────────────────────────────────────────────────┐
│  Instalado ✅   Perfil APP · idioma pt-BR · kit 1.15.0           │
│  Para mudar o idioma depois:  <comando>                         │
└─────────────────────────────────────────────────────────────────┘
```

O que faz M4 funcionar não é o bloco — é o **"porque"**. "Idioma pt-BR" o usuário ignora; "porque **você escolheu**" faz quem nunca foi perguntado parar e reagir.

A última linha (como mudar depois) tira a pressão de acertar na hora: se a escolha for reversível e documentada, um erro do agente vira aborrecimento, não dano.

### 5.5 Decisão de UX ainda aberta — três eixos ou um?

Hoje são três perguntas: `chat_language`, `docs_language`, `code_language`.

| Opção | A favor | Contra |
|---|---|---|
| Uma pergunta, três eixos derivados | Uma decisão para o usuário | Perde "conversar em pt-BR, código em inglês" |
| **Uma pergunta + modo avançado por flags** | Simples por padrão, completo se pedir | Mais um caminho para manter |
| Manter três | Nada muda | Três perguntas para quem não entende nenhuma |

**Recomendação:** a segunda, com código fixado em inglês por padrão — o que quase todo mundo quer e ninguém pensa em pedir.

---

## 6. D7 — avaliação da comparação de arquivos customizados na reinstalação

### 6.1 A superfície real são quatro arquivos

Únicas entradas `merge: MERGE` do MANIFEST inteiro:

| Arquivo | Natureza | Editado na prática? |
|---|---|---|
| `AGENTS.md` | prosa | **sim, sempre** |
| `CLAUDE.md` | prosa, 3 linhas | raramente |
| `openspec/infra.md` | prosa / tabela de estado | pelos scripts |
| `scripts/sdd-upgrade-diff.sh` | **executável** ⚠ | não deveria |

Todo o resto é `COPY`. E `upgrade.sh --apply` já aplica **apenas** entradas `COPY` (`sdd-kit/upgrade.sh:295`), nunca essas quatro.

### 6.2 Instinto certo, pergunta errada

A formulação *"quer que os agentes comparem seus arquivos com os da versão nova?"* pergunta sobre o **mecanismo**, não sobre o **resultado**. Um usuário sem repertório responde "sim" porque soa diligente, sem saber o que autoriza. E a resposta "não" não tem semântica definida — fica na versão velha? sobrescreve?

### 6.3 Contraproposta — classificar primeiro, perguntar só o necessário

```
   Para cada arquivo MERGE: compara sha256 do disco
   com o sha256 da versão ORIGINALMENTE instalada

   ┌──────────────────────────────────────────────────┐
   │ idêntico ao original                             │
   │ → nunca foi editado → sobrescreve, sem pergunta  │
   ├──────────────────────────────────────────────────┤
   │ diferente, e é PROSA                             │
   │ → mostra o que mudou na versão nova, o que você  │
   │   escreveu, propõe a junção → você aprova        │
   ├──────────────────────────────────────────────────┤
   │ diferente, e é EXECUTÁVEL                        │
   │ → nunca funde por julgamento. Substitui,         │
   │   guarda .bak, avisa                             │
   └──────────────────────────────────────────────────┘
```

Na prática quase todo usuário terá editado **um** arquivo (`AGENTS.md`). A pergunta deixa de ser abstrata e vira: *"você editou o AGENTS.md; a versão nova mudou estas 3 linhas; junto assim, pode ser?"* — respondível por um leigo.

### 6.4 O pré-requisito que não existe hoje

O `upgrade.sh` compara o arquivo no disco com o sha256 do MANIFEST **novo**. Isso colapsa três estados distintos:

| Estado real | O que o upgrade.sh vê |
|---|---|
| intocado, versão velha | "diferente" |
| editado pelo usuário | "diferente" |
| editado **e** versão velha | "diferente" |

Sem a linha de base — o sha256 da versão **originalmente instalada** — a comparação é adivinhação.

**D2 é o que torna D7 implementável.** Com o kit inteiro no projeto e versionado no git, o `sdd-kit/MANIFEST.yaml` antigo está no histórico e o sha256 original é recuperável. Isso não existia antes desta sessão.

**Degradação honesta:** sem histórico disponível (repo sem git, kit não commitado), não inventar. Dizer: *"não consigo saber se você editou este arquivo — aqui está a diferença, decida você"*.

### 6.5 Riscos

1. **Fundir script por julgamento de IA.** `sdd-upgrade-diff.sh` é `MERGE` **e** executável — e é o script que conduz o upgrade. O [research de Python §11](../explore-python-onboarding-ux/research.md) já registrou que uma cópia defeituosa dele sobrevive a um upgrade bem-sucedido. **Regra inegociável: executável nunca é fundido por julgamento; substitui com backup.**
2. **Decisões sem registro.** A sessão de comparação precisa deixar um relatório do que foi decidido por arquivo.
3. **Semântica do "não".** Se o usuário recusa a comparação, o comportamento precisa estar definido e dito — provavelmente "mantém tudo como está e lista o que ficou para trás".

### 6.6 O que D7 resolve sem querer

O research de Python encerrou com: *"como o MANIFEST expressa 'preserve edições locais, mas esta versão é obrigatória'?"*

**D7 responde: não expressa.** Um humano decide no momento do upgrade, com o agente apresentando a evidência. Melhor que inventar uma quarta categoria de merge, porque a decisão depende do conteúdo da mudança — e nenhuma categoria estática sabe disso de antemão.

---

## 7. O caminho C2 (versão já instalada) — existe; falta documentar

Correção ao levantamento anterior: D1 não deixa o upgrade sem caminho. Reconstruindo a partir do código:

```
   1. busca o tarball da última release        ← mesma receita do C1,
   2. GUARDA o MANIFEST antigo (linha de base)    mas para diretório temporário
   3. substitui sdd-kit/ pelo novo
   4. bash sdd-kit/upgrade.sh --from X --to Y --dry-run
   5. lê UPGRADE_REPORT.md, aprova
   6. --apply   (só entradas COPY)
   7. os 4 arquivos MERGE → o fluxo do §6
```

Duas lacunas, ambas de documentação:

- A receita do §1.6 diz textualmente *"Do **not** use this for C2"*. Precisa passar a: use, em diretório temporário, sem o passo de instalação.
- O passo 2 não existe hoje. Sem guardar o MANIFEST antigo antes de substituir, perde-se a linha de base de que o §6.4 depende.

---

## 8. Mapa de sobreposição com a sessão paralela

Para a união posterior. Nada aqui deve ser proposto sem cruzar com o resultado de lá.

| Item | Estado nesta sessão | Sessão paralela | Ação na união |
|---|---|---|---|
| **macOS: `sha256sum` ausente na receita §1.6** | Severidade **subiu para bloqueante** com D1 — antes era "um dos dois caminhos falha", agora é "o único caminho falha em metade das plataformas" | `[SESSÃO-MAC]` diagnóstico enviado, aguardando resposta | Verificar se lá já há correção proposta; se sim, **esta sessão só reclassifica a severidade** |
| **Verificação do resultado contra o MANIFEST (pós-instalação)** | Observado: `kit-integrity` é hoje hub-only por depender de `sdd-kit/templates/`; com D2 ele passa a rodar em todo consumidor — ganho acidental a confirmar | `[SESSÃO-MAC]` tratando | Confirmar se o ganho é desejado ou vira ruído |
| **Detectar que o kit já está instalado** | Confirmado que não existe detecção; com D2 vira trivial (`sdd-kit/MANIFEST.yaml` presente → C2) | `[SESSÃO-MAC]` tratando | Unir com o fluxo do §7 |
| **Windows: garantir Git Bash e não PowerShell** | Levantado, não investigado. A receita exige Git Bash; agentes no Windows usam PowerShell por padrão | `[SESSÃO-MAC]` tratando | Provável requisito para o `INSTALL.md` do tarball |
| **`flock` ausente em Windows e macOS** | Não tocado aqui | Registrado em `explore-python-onboarding-ux` §6 | Independente — não conflita |
| **#364 (reduzir dependência de Python no install)** | Não tocado aqui | Pré-requisito registrado em `explore-python-onboarding-ux` §1 | Verificar se D1/D2 mudam o desenho de #364 (o `INSTALL.md` no tarball pode reduzir a superfície) |
| **`merge: MERGE` preserva script defeituoso** | Respondido por D7 (§6.6) | Pergunta aberta em `explore-python-onboarding-ux` §11 | **Esta sessão fecha a pergunta daquela** |
| **Base instalada** | Quarta instalação (Windows, 1.14.0, payload incompleto) | Três instalações pré-1.14.0 assumidas lá | Atualizar o cabeçalho de lá para quatro |

---

## 9. Forma da solução

```
┌─ 1. PORTA DE ENTRADA PARA AGENTES, NO TOPO DO README (D5) ───────────┐
│  Logo após a descrição do que é o ByeByeVibe, antes do pitch:        │
│    · para instalar, use SEMPRE a release mais recente (URL sem       │
│      versão — resolve sozinha)                                       │
│    · verifique o checksum, extraia, siga o INSTALL.md de dentro      │
│    · AVISO (D6): este repositório contém a documentação de           │
│      desenvolvimento do ByeByeVibe (~21 MB, 700+ arquivos), não      │
│      apenas o kit de instalação. Clonar é permitido; ler doc/ e      │
│      openspec/ para instalar é perda de contexto.                    │
└───────────────────────────────────────────────────────────────────────┘

┌─ 2. AVISO NO TOPO DO AGENTS.md DA RAIZ (D6) ─────────────────────────┐
│  Declarar para quem o arquivo é: desenvolvimento do ByeByeVibe,      │
│  não instalação. Agente instalando → INSTALL.md do tarball.          │
└───────────────────────────────────────────────────────────────────────┘

┌─ 3. INSTALL.md DENTRO DO TARBALL ────────────────────────────────────┐
│  Autossuficiente: comando, perfil detectado, PERGUNTA DE IDIOMA      │
│  antes de rodar, módulos opcionais explicados em linguagem simples,  │
│  verificação final. A partir da extração o agente nunca volta ao     │
│  repositório — contaminação vira arquitetonicamente improvável.      │
│  Também é onde o defeito 6 (ponteiros para "guia §2.11") morre.      │
└───────────────────────────────────────────────────────────────────────┘

┌─ 4. INSTALADOR SEM DEPENDÊNCIA DE TTY ───────────────────────────────┐
│  Perfil: detectado e EXIBIDO com a evidência (D3)                    │
│  Idioma: sem declaração → erro, não default (M1+M2)                  │
│  Bloco de confirmação antes de escrever + resumo no fim (M4)         │
└───────────────────────────────────────────────────────────────────────┘

        Gate que prova tudo: instalação real em CI, perfil APP,
        pelo caminho do tarball, ponta a ponta.
```

---

## 10. Ordem de execução proposta

```
  0 ──▶ [SESSÃO-MAC] checksum portátil          ← bloqueante para metade
                                                  dos usuários sob D1
  1 ──▶ detecção de hub por marcador explícito  ← pré-requisito de D2;
        (defeitos 4 e 5)                          senão instala certo e
                                                  reprova na conferência
  2 ──▶ D1 + D2: caminho único, kit inteiro     ← deltas em 3 specs;
        (defeitos 1 e 2 morrem junto)             deleta 3 entradas do MANIFEST

  3 ──▶ D3 + D4: perfil exibido, idioma         ← inclui template de
        garantido (defeito 7)                     project.md

  4 ──▶ D5 + D6: README e AGENTS.md rotulados   ← + INSTALL.md no tarball
        (defeitos 3 e 6)                          + módulos opcionais

  5 ──▶ D7: comparação na reinstalação          ← depende de D2 para ter
                                                  a linha de base
```

---

## 11. O que continua sem resposta

- **A receita funciona no macOS?** `[SESSÃO-MAC]`. Sob D1, é o único caminho — logo, bloqueante.
- **Uma pergunta de idioma ou três?** §5.5. Recomendação registrada, decisão não tomada.
- **O que acontece quando o usuário recusa a comparação do §6?** Semântica do "não" indefinida.
- **Como o `INSTALL.md` garante Git Bash no Windows?** `[SESSÃO-MAC]`.
- **O bloco imperativo do README prejudica a adoção humana?** Decisão de produto: o topo da página passa a servir agentes antes de servir avaliadores humanos. D5 já decidiu a favor; o risco fica registrado.
