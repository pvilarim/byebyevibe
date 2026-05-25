# Aula 05 — Workshop IA 5/2026 - Gravação

**URL:** https://www.techleads.club/c/workshop-ia-5-2026-gravacao/sections/1027866/lessons/3906409  
**Seção:** 1027866 | **Aula:** 3906409 | **Transcript ID:** 3915401  
**Duração aproximada:** 01:19:46

---


## Resumo

Workshop hands-on de Rodrigo Branas sobre Spec-Driven Development aplicado: modelo harness com guias (roles/skills) e sensores (tests, browser, CLI), gestão de contexto, projeto Compozy (orquestração de agentes), taskloopers para paralelismo, memória observacional vs RAG, design.md e bloqueio de código sem teste.

**Palestrante:** Rodrigo Branas

## Tópicos tratados

- Disrupção de UX/software via MCP e linguagem natural
- Harness = LLM + orquestração; guias vs sensores
- Context window, compactação e custo de tokens
- Spec-Driven na prática com skills e taskloopers
- Compozy — framework de orquestração de agentes
- Skeeper e workflows multi-agente
- Paralelismo de tarefas e produtividade
- Memória observacional vs RAG tradicional
- Bloqueio de código sem teste para agentes
- design.md / awesome-design-md
- Ferramentas: cmux, wt, muxy, tailwindsql, Reversa
- LLM local (hello world Akita on Rails)

## Links compartilhados

Lista completa: [`aula-05-shared-files.md`](./aula-05-shared-files.md)

| # | Categoria | Recurso | URL |
|---|-----------|---------|-----|
| 1 | Skills e Agentes | 😎 awesome-tech-lead | https://github.com/tech-leads-club/awesome-tech-lead |
| 2 | Spec-Driven / Design Docs | getdesign.md | http://getdesign.md/ |
| 3 | Vídeos | 📹 Dev Lab Youtube | https://www.youtube.com/@waldemarnetodevlab |
| 4 | Canais TLC | Newsletter | https://techleadsclub.substack.com/?utm_source=community&utm_medium=header |
| 5 | Canais TLC | 🗞️ Newsletter Substack | https://techleadsclub.substack.com/?utm_source=circle |
| 6 | Canais TLC | 🖼 @waldemar.devlab Instagram | https://www.instagram.com/waldemar.devlab/ |
| 7 | Outros | Compozy (GitHub) | https://github.com/compozy/compozy |
| 8 | Outros | Compozy (site oficial) | https://www.compozy.com/pt-BR |
| 9 | Outros | Skeeper (GitHub) | https://github.com/compozy/skeeper |
| 10 | Outros | branas.io | http://branas.io/ |
| 11 | Outros | Memória Observacional | https://www.linkedin.com/pulse/conhe%C3%A7a-mem%C3%B3ria-observacional-arquitetura-que-bate-at%C3%A9-mendon%C3%A7a-hupwf/ |
| 12 | Outros | Bloqueio de código sem teste para agentes | https://www.linkedin.com/pulse/voc%C3%AA-bloqueia-c%C3%B3digo-sem-teste-e-libera-agentes-de-ia-mendon%C3%A7a-wfkoe/ |
| 13 | Outros | Seu RAG acerta 34%, poderia acertar 91% | https://www.linkedin.com/pulse/seu-rag-acerta-34-poderia-acertar-91-o-llm-est%C3%A1-bom-n%C3%A3o-mendon%C3%A7a-m4vwf/ |
| 14 | Outros | Hello World de LLM local | https://akitaonrails.com/2025/04/25/hello-world-de-llm-criando-seu-proprio-chat-de-i-a-que-roda-local/ |
| 15 | Outros | Benchmarks: vale a pena misturar 2 modelos? | https://akitaonrails.com/2026/04/25/llm-benchmarks-vale-a-pena-misturar-2-modelos/ |
| 16 | Outros | Reversa (GitHub) | https://github.com/sandeco/reversa |
| 17 | Outros | cmux (Manaflow AI) | https://github.com/manaflow-ai/cmux |
| 18 | Outros | wt (Thobias Silva) | https://github.com/thobiassilva/wt |
| 19 | Outros | muxy.app | http://muxy.app/ |
| 20 | Outros | tailwindsql.com | http://tailwindsql.com/ |
| 21 | Outros | design.aioxsquad.ai | http://design.aioxsquad.ai/ |
| 22 | Outros | awesome-design-md (VoltAgent) | https://github.com/voltagent/awesome-design-md |
| 23 | Outros | bridgetime.cc/plan | https://bridgetime.cc/plan |

## Referências na fala

Cruzamento entre o que foi dito e os links da tabela acima:

- **Disrupção de UX/software via MCP e linguagem natural**
- **Harness = LLM + orquestração; guias vs sensores**
- **Context window, compactação e custo de tokens**
- **Spec-Driven na prática com skills e taskloopers** → links #1, #2
- **Compozy — framework de orquestração de agentes** → links #1, #7, #8, #12
- **Skeeper e workflows multi-agente** → links #1, #9, #12
- **Paralelismo de tarefas e produtividade**
- **Memória observacional vs RAG tradicional** → links #11
- **Bloqueio de código sem teste para agentes** → links #1, #12
- **design.md / awesome-design-md** → links #1, #2, #21, #22
- **Ferramentas: cmux, wt, muxy, tailwindsql, Reversa** → links #16, #17, #19, #20
- **LLM local (hello world Akita on Rails)** → links #14


> **Como usar:** consulte o resumo e os tópicos para contexto rápido; use a tabela numerada e a seção *Referências na fala* para cruzar o conteúdo falado com os links em [`aula-05-shared-files.md`](./aula-05-shared-files.md).

---

## Transcrição

Galera, massa demais. Bora continuar então pra última do dia. Então, hora de falar com o Branas, vai fazer 1 desenvolvimento assistindo com o Yankeh. Quem não conhece Rodrigo Branas, arquiteto de software, criador de conteúdo, 1 das grandes referências nossas aí no Brasil, já falou com várias pessoas famosas também, Ankle Bobby, Allestar Cock, Burney.
Valdemar Neto.
Valdemar Neto do canal Valdemar Neto. É isso aí cara, muito boa. E e o é apareceram nosso aqui na comunidade, está sempre em lives e tal, a gente sempre compartilhando bastante coisa.
E hoje eu convidei ele, cara, falei pra ele, cara, traz 1 1 workshop teu, mostra 1 pouco das coisas, ele também tem 1 projeto bacana que ele vai mostrar pra nós aqui que é o Compose, também deem estar lá no projeto dele, ajuda bastante, ajuda.
Vocês estão vendo aqui que a gente traz bastante coisa de cara, elevar qualidade técnica do Brasil e começa assim, da gente ter mais projetos que são referências, levar pra frente, então, sempre apoiam o que a gente tem aqui.
E pra lembrar também, depois da palestra do Branas, eu vou falar a terceira palavra pra sortear o livro. Então, se preparem, gente. Se preparem depois da palestra do Branas.
E aí acabou e aí é sabadou descansar pra amanhã, beleza? Rodrigo Branas contigo?
Eu já dei 1 hora por aí, fica tranquilo.
Beleza, obrigado Valdemar, obrigado. Valeu gente, William, Felipe. Pessoal, prazer estar com vocês, eu estive no último evento da TeleC lá em Porto Alegre, né. Quem quem quem estava naquele evento lá, foi muito show, gostei bastante, deu pra aprender muita coisa nova, falar com muita gente, né.
E hoje a gente vai falar bastante sobre spect Driven só que mais na prática, né? Então eu quero mostrar pra vocês, 1 conjunto de tanto skills quanto tasklooper, pra que a gente possa de fato implementar e ganhar mais principalmente produtividade, né? Porque eu acho que o grande desafio, né, como é que a gente lida de 1 forma mais paralela com aquilo que a gente está fazendo, né? Então, quando a gente fala em aumento de produtividade, pode ser 10 por 100, pode ser 10 x. Isso vai depender obviamente do tipo de tarefa que você faz, alguém que trabalha muito mais na sustentação de 1 RP vai ter 1 percepção sobre isso, porque trabalha muito com correção de bug, tem que ler 1 monte de log, os sistemas são todos muito distribuídos, enquanto alguém que está numa startup fazendo 1 MVP, com toda a autoridade e poder possível sobre o escopo, obviamente vai perceber que consegue produzir 10 vezes mais. Então é muito difícil da gente, é, ouvir 1 pessoa que não tem a realidade diferente da nossa, mas sim buscar qual é o melhor que a gente pode fazer, tá?
Bom, fazem aí 25 anos quando eu desenvolvo o software né e e desses aí uns 15 dando aula, principalmente de arquitetura de software, design patterns, Domengen design, Klein Architecture, vários assuntos superinteressantes.
E nos últimos 18 meses eu tenho conduzido 1 programa bem legal, de transformação com IA, né? Então, principalmente, mudando a realidade de como a gente estrutura os nossos projetos e também como é que a gente aplica técnicas Contex Harniss Engineering, speck driven e também, como o Valdemar falou agora há pouco, né?
Toda a parte de arquitetura de soluções, com IA. Então, construção de de agentes dentro de aplicações. Se a gente parar pra pensar, todo o software, acho que a gente fica 1 pouco inseguro, né? Com essa transformação toda que está acontecendo. Tudo acontece muito rápido e acho que todo mundo aqui tem 1 certo receio, né, de perder relevância, perder importância, o trabalho que a gente faz sempre foi muito especializado e sempre foi muito complexo.
E agora parece que qualquer 1 faz. Mas a realidade é 1 pouco diferente. Se a gente parar pra pensar, todo o software que existe hoje, de alguma maneira, ele vai acabar sendo repaginado, né?
O núcleo dele, o backend, o banco, as regras de negócio, isso tem 1 tendência de ficar como está. Agora, a forma como a gente interage, isso vai sofrer e já está sofrendo 1 disrupção muito grande. Cada vez mais você está começando a ver softwares que estão abrindo MCPs, certo? É a nova API, né?
O MCP é a nova API pra IA. Mas não só isso, você começa a ver cada vez mais suporte à linguagem natural, suporte a ações mais automatizadas, porque a maior dificuldade workflows, porque a maior dificuldade que existe em qualquer software hoje, é você fazer com que o usuário de fato extraia valor dele, concorda?
Imagina 1 RP, o quão fácil é você ler toda 1 documentação, você entender como todos aqueles fluxos funcionam, você conseguir de fato enquanto empresa, entregar 1 boa experiência sem deixar o teu usuário entediado, sem deixar o teu usuário frustrado.
Não é nada muito fácil.
Então a IA entra principalmente nessa substituição de alguma forma de processos que são difíceis, repetitivos, e que a gente pode sim, repensar a maneira como esse sistema proporciona interação. Então só por isso, a quantidade de software que vai precisar ser transformado nos próximos anos é imensa.
Coloca ainda tudo que está sendo criado, nunca se criou tanto software, nunca se jogou tanto software fora também, obviamente né?
Acho que nunca se teve tanto retrabalho, nunca se viu tanta purrie Quest sendo aberta, nunca se viu pessoas de outras áreas abrindo pro requests, esses dias eu vi 1 purrie Quest do CEO, então é 1 coisa meio preocupante, né? Quem vai revisar pro requests do CEO, né? Acho que é 1 briga grande.
E e hoje, eu queria falar de algo que eu tenho certeza que vai fazer com que a gente possa, não só ter mais produtividade, mas principalmente seguir 1 processo, né? E esse processo, ele obviamente demanda a 1 estruturação do que a gente chama de guias e sensores do seu projeto, né? Deixa eu compartilhar minha tela com vocês, aí a gente começa a colocar tudo isso aí na prática, tá? Deixa eu só clicar aqui no eu só clicar aqui no navegador, pronto.
Share.
Eu tenho 1 desenho aqui que eu costumo mostrar bastante, em aula, né? Dá pra ver bem aí, né pessoal?
Beleza.
O que acontece?
Quando a gente fala em agente, a gente está falando em LLM mais 1 rarness.
E o que que é o rarness? É tudo aquilo que está ao redor da LLM proporcionando não só contexto, né, quando a gente pensa em contexto, é responsável por manter essa janela, por manter toda essa interação com ferramentas, né, o processo de tool Call, todo o processo agêntico, é papel do Harness. Ele já traz muitas ferramentas biochain, permite que você interaja com sistema arquivo, com 1 série de coisas, então tudo isso aí obviamente é papel do Harness.
E aí, isso só não é suficiente porque obviamente 1 LLM, ela é 1 gerador de token, sabe Java, sabe JavaScript, sabe Rush, sabe Python, sabe React, sabe Angular, mas não sabe a forma como você na sua empresa trabalha.
Então pra você evitar frustração e retrabalho, você tem que tentar trazer o que a gente chama de guias, ou seja, roles, skills, coisas que vão entrar na sua janela de contexto, e dirigir a ALM de 1 certa maneira, pra que o código esteja dentro da tua expectativa. Agora, só isso também não é suficiente. Assim como você e eu não sabemos se aquelas linhas de código que a gente digita funcionam ou não, ninguém aqui tem 100 por 100 de certeza.
Você vai escrever 1 linha de código, você pode errar, 1.1 parêntese, 1 ponto e 0.1 chave, qualquer coisa você pode errar.
LLN também erra. E o que faz com que ela acerte mais, não é que ela vai acertar, ela vai descobrir que errou. O que vai fazer esse ciclo de feedback, o que vai fazer essa autocorreção, é o que a gente chama de sensores.
Em muitos projetos, tem sensores que são fáceis, por exemplo, 1 Browser era 1 sensor muito importante.
Então se eu estou desenvolvendo 1 projeto, que tem 1 interface na web, basta eu fornecer 1 playright, pra que a própria LLM saiba se o que ela construiu faz sentido de acordo com aquilo que foi planejado.
Se eu estou fazendo 1 projeto que envolve interação, com 1 cloud provider, como a AWS, ora basta eu instalar 1 CLI da AWS e fazer com que aconteça essa interação, se eu estou fazendo alguma coisa num banco, basta eu fornecer 1 acesso direto ao banco, não estou dizendo que é o banco de produção, que seja 1 banco local.
Se eu estou gerando log que eu provém, que eu possa prover acesso aos logs, testes automatizados são excelentes sensores, compiladores, transpiradores, então, se se tudo isso não estiver ao redor, do teu Harness, você obviamente vai ter, 1 trabalho braçal maior e com isso vem a frustração e a perda de produtividade. Então quando a gente consegue alinhar tudo isso, usar 1 LLM que faça sentido, pô eu não vou usar, de repente 1 GPT 4.1 mini pra programar porque não tem nexo.
Eu vou escolher lá 1 GPT 5.51 óculos 4.7.
Aí vai de você, 1 GLM 5.11 química 2.6, vai 1 pouco de acordo com o teu orçamento, com a ferramenta que você já utiliza.
Agora, só isso não é suficiente, eu vou ter que usar 1 bom Harness, bom Harness, Cloud Code, Codecs, Windsurf, Anti Gravity, Copilot, não, Copilot não, estou brincando. Hoje em dia os Harness estão muito nivelados, então o que a gente vê no mercado, óbvio, já vazaram o o código todo do Cloud Code, não tem mais muito o que falar a respeito de hardwares.
É claro que tem uns que se destacam, você pensa no Cloud Code, ele tem 1 suporte a subasgent que é muito legal, 1 suporte a skill que é muito legal, hoje isso já está em outros também, até 1 certo tempo atrás começou com ele, né? O cursor é 1 excelente. Open Code também? A maioria deles são excelente gente, não é isso que vai fazer a diferença hoje.
Modelos, posso citar 10 modelos aqui pra codificação que são muito nivelados.
Agora, o que que faz mais diferença? É a sua técnica, e é o tipo de informação que você consegue fornecer no contexto.
E quando a gente fala nisso, é muito importante, dentro da da engenharia de contexto né, que você forneça a informação que é suficiente, a informação que é necessária, no momento certo.
Porque tudo que a gente não quer, é estourar essa janela que está aqui.
Quem aí já viu a janela de contexto compactando?
Acontece muito pouco.
Isso acontece com 1 certa frequência né? Então quando a gente compacta 1 janela de contexto, basicamente o que acontece, é que a gente está chegando muito perto de 1 limite, e toda a LLM tem obviamente 1 limite daquilo que ela consegue assumir como entrada.
E você imagina que você está falando de 1 rede baseada numa arquitetura de transformer, que tem 1 densidade alta, e que no fim do dia, são milhares de matrizes interconectadas fazendo milhões de equações matemáticas com pesos sendo definidos ali de forma dinâmica rodando 1 mecanismo de atenção, calculando probabilidade pra saber qual é o próximo token.
E obviamente quanto mais coisa existe na entrada, mais esforço você demanda pra ter 1 boa saída.
Então, isso significa mais hardware, máquinas maiores, mais caras. Sabe quanto é que custa 1 máquina pra rodar 1 soné, 1 Opus, 1 GPT, mesmo talvez modelos bons modelos open source? Estamos falando aí talvez de centenas de milhares de dólares.
Então, isso é 1 esforço computacional muito grande, tanto que modelos que têm 1000000 de toucas no contexto são substancialmente mais caros que modelos que têm 200000.
É óbvio, porque o volume de memória que você precisa é muito maior também. Você tem hoje mecanismos de cash muito eficientes, mas ainda são operações muito pesadas.
E tudo que você não quer é queimar tokens. E queimar tokens significa queimar tempo também.
Então, o que a gente pode fazer pra tratar essa janela de 1 maneira racional, quando a gente fala em alucinação é 1 nome bonito pra dizer que existe 1 degradação, certo?
A gente falou que, os tokens que estão entrando, eles afetam o mecanismo de atenção.
Ora, se é 1 mecanismo de atenção, você consegue prestar mais atenção em 1 pessoa só ou em 10 pessoas falando pra você alguma coisa? É é óbvio que é em 1 pessoa só.
Então é muito mais fácil ter atenção em 100000 tokens do que em 900000 tokens.
Então isso significa que se você botar mais coisas do que você deveria nessa janela, isso vai prejudicar o seu processo e quando a gente fala em mais coisas, por exemplo todo projeto ele em geral tem 1 frontend 1 backend separado.
Quando eu falo separado é em termos não físicos, em termos lógicos.
O que que tem a ver com a a estilização de 1 componente React com a tabela do banco, tomara que não tenha a ver né gente, enfim.
Mas o que que tem a ver a estilização de 1, já viram esses dias fizeram 1 SQL misturado com Tail int para React, mas isso não vem ao caso agora. Mas o que que tem a ver, a estilização de 1 componente em React com a coluna da tabela do banco que você está fazendo a persistência?
Absolutamente nada.
Ah mas é da mesma tarefa, não interessa que é da mesma tarefa, se isso se misturar na janela, a atenção também vai acabar ficando dividida. Então o que a gente quer aqui é evitar esse tipo de cenário e a gente consegue fazer isso quebrando a tarefa em partes menores, é 1 coisa que a gente sempre fez, mesmo que mentalmente, né?
Ninguém aqui conseguia programar 3 coisas ao mesmo tempo, da forma tradicional, hoje consegue né? Com IA você até consegue.
Então, quando a gente pensa em Spectrem, basicamente o que a gente está falando é, eu vou pegar 1 ideia, né? Eu vou pegar 1 ideia, aqui essa ideia que eu estou listando aqui basicamente é 1 ideia real que eu trabalhei recentemente né? Eu trabalho numa plataforma americana que é como se fosse 1 Airbnb de coaches de esporte, então você aproxima quem quer fazer aula de golfe com quem dá aula de golfe, ou de tênis, ou de basquete, ou de futebol.
E pra isso, você tem instrutor, 1 professor, que não trabalha só numa plataforma, trabalha em 5 plataformas, em 3 clubes, tem seus alunos privados, e não adianta ele definir que a disponibilidade é de 8 às 18.
Sim, é de 8 às 18 mas, é compartilhado em vários lugares diferentes. Então 1 frustração muito grande que acontecia aqui na empresa, é que o aluno continuamente se cadastrava, pedia, pagava pra fazer aula num horário e o professor não podia, reagendava.
Reagendava de novo, não podia de novo, reagendava de novo, não podia de novo, e assim a empresa começou a perder muito faturamento.
Então, qual foi a saída que a gente encontrou? Vamos sincronizar o Google Calendar desse Coach, com a nossa plataforma, de forma de maneira bidirecional. Tudo que eu tiver de eventos, de aulas internas, eu levo pro calendário. O que é muito bom pra evitar que o coach esqueça 1 aula, o mesmo aluno.
E, vamos pegar os eventos externos e trazer pra dentro da plataforma.
Assim a gente consegue bloquear aqueles horários que já existem em agendamentos em outros lugares.
Você acha que dá pra fazer 1 1 tarefa dessa assim, inteira?
Jogando inteira no contexto?
Quando eu fiz essa tarefa é, ainda não tinha esses modelos com 1000000 de tokens, eram 200000, mas tudo bem. Mesmo com 1000000 não dá.
Porque a verdade é que aqui você vai ter que fazer muitos fluxos diferentes de infraestrutura, de frontend, de backend, tem todo 1, fluxo off pra ser seguido, tem 1 monte de tabela pra ser criada, tem 1 monte de coluna nova pra ser criada em vários lugares, você tem que fazer 1 processo de detecção de mudança, pra que você possa mandar essas mudanças pra lá cancelou 1 aula eu tiro o evento do calendário, eu tenho que detectar, de tempos em tempos se algo mudou refletir internamente liberar disponibilidade em calendário interno.
Então, é 1 coisa que é muito difícil de escrever 1 prompt aleatório e mandar fazer. Então quanto maior a tarefa, mais complexa a tarefa, mais você tem que seguir 1 bom processo. Pra coisas simples, eu vejo 3 níveis tá gente?
1 nível é, você faz o diretamente, mas sempre lembra referencie 1 arquivo específico, referencie 1 método específico olha eu quero fazer 1 alteração nesse método pra fazer isso.
Você vai permitir que a LM faça o mínimo de possíveis ela vai direto naquele arquivo lê trace pro contexto faz alteração chama o moto tool Call pra fazer a modificação.
Ah eu tenho algo que já mexe em 5 ou 6 arquivos legal vai pra 1 Play mode.
O Play mode, ele é fundamental porque ele separa a ideia de planejamento da ideia de execução.
Isso te dá oportunidade de entender primeiro entender o plano, né? Questionar o plano, modificar o plano.
Mas tem outra coisa bem importante.
Eu tenho falado muito sobre 1 conceito chamado de arrastar tokens. Tolkien é, em inglês é, tem 1 termo bonito pra isso que chama draging, você está arrastando tokens.
Quando você vai fazer 1 planejamento, independente de qual seja tá, você concorda que a LM faz tool pra fazer pesquisa, sim ou não?
Concordo que Existem tool calls sendo executadas para fazer pesquisas sobre aquilo que você quer resolver.
É normal você ler 5 fontes diferentes?
5 artigos diferentes?
Pesquisar informações de de outros projetos? Ler mais arquivos do que você precisaria modificar? É óbvio que é normal fazer isso. Você acha que essa informação vai parar onde?
Aonde vai parar essa informação? Eu não estou falando em execução.
Eu estou falando em planejamento.
Eu levanto esse monte de informação, e eu jogo na janela de contexto porque eu estou fazendo 1 análise, a janela é 1 só. Hoje está 1 pouco melhor que você tem sub a gente, mas ainda assim você congestiona essa janela de contexto.
Sabe o que acontece na sequência? Você vai executar.
Execução é 1 mundo à parte.
Execução envolve escrever muito arquivo, mas não é só escrever, eu tenho que testar o arquivo. Cada vez que eu testo, eu tenho 1 stack trace, eu boto stack trace dentro do contexto, eu corrijo stack trace, eu tenho outro erro. Eu fico num loop agente, que é o que eu o que eu coloquei aqui, de repente em 30 40 50 rodadas, em cada rodada eu faço a request. Você entendeu que, se eu arrastar, o token do planejamento para execução, você não tem o menor nexo fazer isso, eu é é é assim, não tem sentido.
Porque o resultado do planejamento, ele se dá em 3, 4000 tokens no máximo.
Mas pra chegar em 3, 4000 tokens, você gera 1 arrasto de 50, 100, 150000, você entende?
Você tem que quebrar, Você tem que quebrar esse fluxo.
Se você quebra esse fluxo, você começa a execução com 5000 tokens.
Então, isso os Play modees atuais já estão fazendo. É esse tipo de coisa já está acontecendo, não estou contando nada demais tá? Isso já está começando a acontecer, quando você faz 1 Play mode ele te fala você quer limpar o contexto? Pra poder seguir em frente? Então o speck driven ele vai, é, muito nessa linha tá? Só que obviamente ele te ele te coloca dentro de 1 fluxo, ele te coloca dentro de 1 fluxo, que, permite com que você explore certos aspectos.
Por exemplo, eu gosto de primeiro explorar o aspecto de negócio, aí você vai dizer assim, ai mas a minha tarefa não tem negócio, é é, assim, salvo pequenas tarefas muito simples, olha eu vou mudar o, sei lá, a label de 1 botão, a cor do celular de 1 fonte, tem negócio envolvido. Sabe por que que tem negócio? Quando você manda alguma coisa pra QA, o que que o Kiate pergunta?
O Kiate pergunta assim o que que você quer que eu teste?
O que que você quer que eu teste é 1 fluxo de negócio.
Então, eu não consigo rodar 1 agente de teste se eu não tiver 1 planejamento de negócio. Lembra que eu falei, guias e sensores?
Eu preciso guia.
Então eu vou explorar negócio, depois eu vou gerar 1 visão de design e arquitetura.
Design e arquitetura, gente, é fundamental, a gente vai fazer agora na sequência já, e entenda o seguinte, nenhuma LLM vai ler o seu projeto inteiro. Não sei se alguém aqui tem essa impressão, mas nenhuma LLM vai ler o seu projeto inteiro, não cabe. Você tem 1000000 de toucas no contexto.
Não cabe. Você pega 1 projeto com 1000000 de linhas de código, faz a multiplicação, é é humanamente inviável e nem é a proposta, porque, dando 1 projeto você tem features completamente diferentes, por que que você teria que ler isso pra gerar 1 divergência, 1 contradição, 1 degradação no fim das contas.
Então, essa ideia de que, ah o meu projeto tem, nossa eu sou especial, todo mundo se acha muito especial, o meu projeto é muito grande eu sou especial, não é. Tanto faz você ter 200000 linhas de código ou 100000000, é o o problema é o mesmo não cabe igual, entende?
Então quando você tem 1 especificação técnica, você está dizendo exatamente quais arquivos precisam ser lidos, entende?
Quais arquivos precisam ser modificados, quais arquivos têm que ser criados.
E eu estou falando de 1 conjunto de 20 e 30, não estou falando de 1 conjunto de 2500.
Não cabe.
Então, se não existe esse planejamento, você vai cair numa vala comum, de ficar fazendo 1 processo agente com meio descontrolado e é isso que vai te prender talvez num ciclo de ineficiência entendi quando a gente fala por exemplo a o grande fez a pergunta ali né quem arqueecture assim pessoal quem arqueecture nada mais é do que do meio modo, mas, arquitetura hexagonal com alguns design patterns, adapter, Strategy, eu vou fazer 1 inversão de dependência, Ken Architecture na essência é só a aplicação de algumas boas práticas de design e de arquitetura que outros autores já tinham, falado 20 anos antes talvez.
Então, orientação objeto é de 1968, tenho a premissa de quê?
De distribuir complexidade em objetos pra favorecer reuso, pra favorecer extensibilidade, certo? Qual é a moral de 1 objeto se não promover encapsulamento e com encapsulamento é o baixo acoplamento, certo intimidade, se eu encapsulo eu não exponho a minha estrutura interna.
Ah mas isso gasta mais token?
É, bom se isso gasta mais token então a Tommy que design gasta mais token, componização no frontend gasta mais token, microservice gasta mais token, tudo gasta mais token. Mas a verdade é que, é mais nocivo pra 1 pra 1 LLM ler 1 arquivo de 20000 linhas mal estruturado, do que ter 1 modelo de objeto bem distribuído com as responsabilidades bem definidas onde eu consigo ir direto onde eu preciso e posso reusar a parte do código. Eu tenho menos bug se eu concentro comportamento do que se eu distribuo comportamento.
Agora, tanto faz 1 caso ou outro, tudo depende de como você fez o planejamento.
Porque como eu falei, se eu souber onde eu estou mexendo, eu isolo a parte do projeto onde eu estou fazendo as modificações e com isso eu reduzo o arrasto de Tolkien.
E, obviamente se eu pegar o PRD, que é 1 documento de requisitos, o Patex pack é 1 documento de design arquitetura, ele também não vai caber no contexto, então eu vou quebrar isso aqui em tarefas menores, certo? E com essas tarefas menores eu consigo fazer as coisas passo a passo.
E aí entra também, geralmente 1 task looper que a gente vai começar a mostrar agora, pra quê?
Pra que eu possa pegar esse task looper e, não precisar ficar, existe 1, alguns níveis em adoção de AI, que eu que eu gosto de falar bastante, e vai do L 0 ao L 4, tá? O L 0 é o hater, é aquela pessoa que se sente insegura, obviamente não comprou ainda a transformação que já aconteceu e que não vai voltar mais, e fala mal e não usa e reluta, mas 1 hora vai ser obrigado a fazer. Então, todo mundo já passou por isso né? Principalmente pra quem veio lá do Coopilot usando autocomplete, ficava irritado com resultados, primeiras versões de ChatGPT, então obviamente todo mundo ficava chateado e e era hater, depois isso foi mudando né?
No L 1, eu vejo que existe o Copy paster, é aquela pessoa que ainda está copiando e colando o código do pro ChatGPT.
Fica ali copia e cola copia e cola. Não faz sentido. Você tem 1 monte de ferramenta hoje que já faz, obviamente, isso pra você por meio de, contexto.
Eu consigo usar 1 Harness que dá acesso ao File System então não tem que ter você ficar copiando e colando.
E existe o o talvez o, o nível que a maior parte das pessoas tão, que é o que eu chamo de babysitter JI, quando você fica provando cada etapa.
Ah eu vou criar 1 endpoint, ok. Hum vou criar 1 payload, não não gostei, faça assim. Vou criar 1 tabela no banco, vou adicionar numa coluna, vou criar 1 1 novo serviço no Docker Compose, caramba.
Você não tem como ter muita produtividade a mais dessa forma.
Entende?
E o nível que eu acho que todo mundo deveria caminhar, é o nível de gerente, de manager. Que é quando você se torna 1 espécie de líder técnico com, analista de negócio, analista de produto, você foca mais na solução do problema e no direcionamento técnico e menos em como aquilo ali está sendo feito. Obviamente existe 1 direcionamento técnico antes. E os taskloopers são fundamentais pra viabilizar isso porque você não deve interferir na execução.
Você não deve sequer ler o que está sendo executado.
Você deixa executando e vai fazer outra coisa.
Depois, você vai fazer 1 Code review, óbvio, faz primeiro 1 que é automatizado, 1 Code review automatizado, corrige bug, e faz 1 Code review humano final.
Mas você não deve interferir na execução, justamente porque porque o que você quer é trazer paralelismo.
Entende? Então a a grande tendência do mercado, e já é o que está acontecendo, é caminhar pra esse lado.
É caminhar pra que as pessoas consigam paralisar mais. O último nível, é é 1 pouco ainda talvez do Santo Graal dos CEOs, que é não precisar de dev.
Mas aí eu sinto muito em dizer que assim, não é muito fácil porque ainda é 1 atividade de natureza técnica. Então você automatizar todos os fluxos, todos os pipelines, eu quero que a pessoa do marketing, do financeiro crie software, não é muito a realidade.
Você pode ter tapas de prototipação, você pode ter as pessoas por exemplo, sugerindo, eu trabalho eu eu dou consultoria pra 1 empresa americana, e a gente implantou o Devem. O Devem é 1 ferramenta umCloud, que vai fornecer 1 sandbox completo do ambiente, permite que qualquer pessoa da empresa vá lá e crie software.
Então pessoas de todas as áreas começam a tentar resolver seus problemas.
Quando é 1 software interno, faz muito sentido tá? Quando é 1 software de mercado, eu acho que isso pode ser legal e positivo quanto às sugestões de melhoria, porque o Dev tem 1 problema, o Dev odeia o problema que ele está resolvendo, concorda?
O Dev se empolga primariamente com a tecnologia. A maior parte das pessoas se você perguntar assim, ah você trabalha com software pra área de direito, você agora eu odeio direito.
Eu por exemplo trabalhei muito tempo na área contábil.
Odeio contabilidade, óbvio. A maior parte dos devs não se importa com o problema que está resolvendo, se importa com a tecnologia.
E as pessoas que não são devs pelo contrário se importam com o problema. Então é óbvio que quando você habilita alguém de fora, essa pessoa, é, performa muito bem. Quando Quando eu falo contabilidade gente, é software pra contabilidade tá? Eu nunca fui contador e, assim, seria a última profissão que eu, que eu seguiria talvez tá?
Então, por trauma tá? Nada contra contabilidade.
Então assim, o que acontece?
Você começa a gerar muitas vezes boas ideias que faz a diferença pro teu cliente final.
Então, trazer esses pipelines é muito bom mas, sempre tentando balancear com as responsabilidades de cada 1 de cada 1. O dev segue sendo essencial pra decidir todo direcionamento técnico que não é pequeno dentro de 1 de 1 projeto, né? Então, por mais que a gente faça isso, eu acho que organizar o processo como 1 todo, de 1 forma que você consiga, fornecer pra organização a possibilidade de repente de, ter 1 pipeline de correção de defeito, automatizado, ligado por exemplo num linear, num Slack, ter muitas vezes processos também muito braçais sendo automatizados, conectar melhor as áreas.
Vib Code até quando você pensa o vibe Code é a nova planilha, Excel.
Quando você vai construir sistemas internos, pode fazer sentido, está sob o teu controle, o risco é teu. Quando você vai pro mercado com software escalável, que tem que ter segurança, usabilidade, acessibilidade, a coisa muda 1 pouco de figura, né? O Compose, gente, ele entra exatamente aqui, tá? Ele é 1 software que a gente idealizou há há mais de 1 ano, e ele começou como, ah, GitHub ponto com barra compôse barra compôse. Eu vou colocar aqui no chat, se puderem deixar 1 1 estar, como o Valdemar até, falou ali né? A gente tem 630, estamos em quantas pessoas aí? 3400 olha, dá pra dá pra dá dá pra passar de 1000 hoje hein gente, dá pra passar de 1000 Stars hoje. O que que 1 Pose faz? Ele começou como 1 software desktop, com Electron, rodava local, e e tinha 1 modelo de cobrança, ele era 1 software que o nosso objetivo na época era pra, realmente levar pro mercado e e conduzir como 1 ferramenta empresarial tal. Só que a gente percebeu que no fim das contas as pessoas querem usar e querem ter 1 experiência mais próxima do CAI, Querem ter 1 experiência mais próxima e mais bem controlada talvez daquilo que estão fazendo, usam ferramentas muito diferentes.
Então o CLI acaba, obviamente né, se encaixando muito melhor nisso. Então o Compose, ele vai trazer pra você, 1 série de skills, que eu vou começar a mostrar agora, nem vou mostrar muito no site, tá?
Eu vou compartilhar a minha tela Atualiza aí, Jones, atualize aí. Atualiza ali, atualize.
CAD stars.
Ah, para. Foi? É? Foi. Deixa eu ver? Os caras são bom hein. Máquina, mano. Aí 1.2 aí, olha, dá pra chegar, dá pra chegar, dá pra chegar em 2000, Rolema. Eu acho que está Aí vai ter que ver essa palestra aí cara o o o o Pedro vai chorar, cara, se vocês quiserem ser com ele. Porque o Pedro, o Pedro ele é 1 cara bem bem bem genial, assim, né? Ele é 1 cara que, a vida dele, cara, o Pedro é meu sócio, né, a gente dá curso junto e tal. A vida dele é criar, cara, a vida dele é dedicada a isso já há uns 2 anos, e aí ele não cria só esse, ele cria, tipo OpenClau, esse esse tipo de ferramenta e, e ele já criou n 8 n, OpenClau, só não acertou ainda a parte comercial, mas de resto, assim, as ferramentas são muito boas, né? E e aqui, como é que a gente vai começar?
Eu vou, deixa eu só botar a tela 1 pouquinho pro lado aqui que daí fica redimensionada, boa.
Eu vou entrar aqui num projeto, deixa eu entrar aqui olha.
Beleza.
Vamos ver se está rodando? Está 1 projeto vazio tá gente? E aí eu queria seguir algumas etapas com vocês.
Tá aparecendo aí? Blink Template? Só bota 1, 1 ok.
Tá né? Tá bom. Só pra garantir que eu estou na tela certa, né? Então aqui eu tenho 1 projeto é, é, backend frontend, ele não tem nada praticamente, tá?
O backend é só 1 barra Health, que é o que está aparecendo aqui.
Só, só tem esse arquivo, tá? E o frontend, ele só tem o componente principal, que é o que mostra lá a Blink Template. Então não tem nada além disso.
Então eu queria fazer com vocês agora 1 passo a passo, de como seria pra gente começar 1 projeto com AI, e, estruturar esse projeto minimamente e rodar 1 tasklooper usando o Composse, tá? Então vamos lá. Primeira coisa que a gente vai fazer aqui olha, é o seguinte, eu vou, instalar o Composse, então, depois eu mando pra vocês esses esses comandos tá, lá no site obviamente você vai conseguir ver mas você faz 1 IPM install menos g compôsse barra sei lá e, eu já tenho ele instalado então, não vai fazer muita diferença né?
E aí a gente vai fazer 1 compôs e setup né quando a gente chama compôs e setup ele vai dizer o seguinte olha essas são as essas são as skills que eu vou instalar. Por quê?
Você sabe que do pack Reven você tem lá, eu vou criar diversas etapas, então essas são as etapas sugeridas, você dá, basicamente aqui, deixa eu só mudar de tela, 1 enter, ele vai perguntar, pra qual, pra qual IDE você quer?
Sinceramente cara, pode deixar todas essas marcadas, porque tudo que vai acontecer, vou tirar só o Windsurf, é, ele, criar em pastas diferentes. Então se você falou que você quer Caio, ele vai criar a pasta ponto caro, se for cloud Code vai criar pasta ponto cloud, eu estou usando aqui pelo agent mesmo, porque a gente está usando, vou usar Codecs tá? Então eu vou tirar essas 2, mas está aqui as skills do Compose instaladas.
Eu sei que o Valdemar também tem 1 projeto no Valdemar com skills e tal, então até esse ponto é 1 coisa que você vai ver muito no mercado, você tem BEMAD, você tem speck kit, você tem diversos fornecedores diferentes desse tipo de skill, então, até certo ponto isso são as skills que a gente fez ao longo dos anos e que funcionaram bem, tá?
Falar mais 1 coisa pra vocês.
Só isso aqui gente não adianta, falta mais 1 coisa bem relevante, né? A gente precisa de, certo? Qual a diferença de skill e skill? Basicamente, é 1 coisa que sempre está no seu contexto.
Você vai sempre quando usar 1 Code é que se for qualquer hardware está cloud Code, essa é lida e colocada no seu contexto obrigatoriamente, é como se você copiasse e colasse isso no System prompt. A skill tem 1 lazy loading. Então, eu vou trazer aqui 1 conjunto pequeno de, não são não são muitas, não são muitas rous, só pra gente poder, de certa forma, ter, deixa eu só pegar aqui olha, control c control v, eu não vou obviamente entrar aqui em desenvolvimento de rous, mas são rous, sempre pensa que o que faz sentido ter em rous são coisas que você sempre aplica. Então Code standards, eu sempre quero que o código seja em inglês, eu sempre quero que métodos e variáveis usem que é meu case, eu sempre quero que, de repente eu evite números mágicos, Magic numbers, sempre, se é sempre é idiota fazer desde skill. Por que por que que você vai ter que fazer 1 lazy loading de algo que é sempre igual, entende? Então deixa pra skill coisas que fazem parte de 1 know how, ou seja, ah eu eu uso master, eu uso versel ISDK mas eu não uso sempre.
Quando eu uso eu quero que isso seja carregado, então isso é 1 skill.
Aquilo que sempre é verdade, você pode deixar em row, Só que dependendo do tipo de Harniss que você use, essa pasta roo não vai ser lida tá? Do jeito que está aqui ela não vai ser lida. Então, eu vou rodar aqui 1 Codex menos menos you on eleve once que é o Yolo mode né? Aliás se vocês não usam o Yolo mode começa a usar porque, a chave da produtividade é não ficar provando etapas tá?
Pode ser que apague a tua máquina e instale algum algum, algum vírus mas, é o risco, é o risco é a produtividade.
Então vou dizer o seguinte, olha, eu vou criar aqui 1 agent CMD, e tem 1 técnica que é é fazer pointer pra Rue. Então, vou dizer 2 coisas que eu acho que são muito relevantes, tá?
É, no agent CMD, deixe claro, que existem 2 projetos, frontend e backend, inclua os comandos para instalar dependências, rodar testes, rodar teste não porque não tem nada no estalo de teste ainda, a gente vai fazer agora. Instalar dependências, rodar o projeto, também as portas, onde cada 1 deles roda. Por que isso? Porque a LELEN é stateless, ela não sabe, ela esquece de 1 sessão pra outra que a porta que você usa 3000, então você deixa no a gente sempre está no contexto.
Além disso, crie 1 ponteiro, para cada e skill existente.
Elas estão, na pasta, ponto agens barra rues e ponto agens barra skills. Isso te dá essa liberdade de não ficar dependendo de regra do né, da onde é que vem, porque cada 1 literalmente se comporta de 1 forma 1 pouquinho diferente, tá? Aqui eu estou usando Codecs com o GPT 5.5, então, ele vai ler, vai vai incluir aqui e está tudo certo tá? Essas basicamente, além de Code Standards tem folder structure, então é outra que sempre é verdade tá?
Eu tenho 3 que poderiam, teste sempre é verdade em geral tá, mas React não. Então isso aqui poderia ser 1 skill tá gente?
E, a parte de endpoints, regras de Rest isso poderia ser 1 skill também então, daria pra melhorar 1 pouquinho esse aspecto tá? As skills estão as skills aqui basicamente do compôs.
Então, vamos começar enquanto está rodando ali enquanto está ajustando a gente vem pra cá tá?
Ah mas você está usando o Medium, está errado está errado.
Nível de risoning, quanto mais criativo for a a tarefa que você está fazendo e mais você precisar contar com a LLM pra que ela complemente, coloque as peças que você não sabe, mais alto é o reasoning, reasoning gera tokens intermediários no processo certo? Então você gasta muito mais token mas você tem respostas muito melhores né? Olha, aqui já criou tá gente? Fez o apontamento, fez tudo tá? Mas eu vou usar a mídia 1 pra acelerar 1 pouquinho também senão o o exame alto demora muito mais. E aí você vê quando eu boto barra aqui olha, e isso não é ainda o looper do compôs, são suas a as skills do compôs, eu tenho o create p r d.
E aí, nesse create PRD, eu tenho que definir 1 escopo que é o que a gente vai desenvolver, é, juntos aqui né?
E basicamente eu vou eu vou copiar aqui 1 1 1 prompt base que eu criei agora pouquinho, e fazer o seguinte, olha, vamos criar 1 aplicação frontend backend que seja capaz de exibir o horário em diferentes lugares do mundo, mostrando a partir de 1 cidade específica que horas são, e que horas são em outras cidades, permitindo que eu entenda diferenças de time zone.
Eu estou dando bastante aula pra pra Cingapura, Vietnã, Turquia, outros países, é a desgraça pra você poder marcar aula nesses lugares, porque você não sabe nunca que horas é.
Então eu combinei 1 calendário que as aulas seriam segunda quarta e sexta. Aí quando chegou o convite do Calendar, adivinha que dia que apareceu aula?
Cingapura tem 10 11 hora a mais. Que dia você acha que apareceu aula de segunda no meu calendário?
Apareceu domingo.
Então por exemplo amanhã eu tenho que dar aula, então, é, pode ser que seja interessante ter 1 ferramenta dessa né? E aí eu vou fazer o create PRD, vou dar enter.
É, o Compose, ele vai fazer o que tá?
Basicamente, ele vai construir 1 pasta aqui que ainda não não existe né? Então conforme ele vai começando a rodar, ele vai estruturar tudo numa pasta ponto com pose. Essa pasta ponto com pose ela vai, armazenar os prds, as, tudo isso, está falando aqui ó. Vou criar em ponto compose, ó. Então está começando a fazer tool call pra ver o que que tem no no file system, ó, criou, tá?
Isso é 1 coisa que gera muita discussão, que é o seguinte, né?
Aonde eu devo guardar esses arquivos?
Porque eu acabo no fim do dia quando eu uso espectro Drivion com 1 monte de arquivo de escopo só que isso não fica bem consolidado dentro da empresa né, a gente não acaba ou jogando isso fora ou perdendo, a gente não não sabe muito bem o que que acontece, né?
E aí existem algumas teorias.
1 que eu reforço é sim, os PRDs eles podem ser usados como documento de de escopo, óbvio, dentro da tua organização, mas na minha visão ele tem que ser levado pra alguma ferramenta externa ou pra 1 repositório centralizado. Então se você quiser fazer isso, você poderia fazer esse arranjo, senão, você pode tratar como sendo algo ignorado no Git, e aí você usa só pra desenvolver a tua tarefa.
Tem empresa que trabalha das 2 formas diferentes tá? É eu já trabalhei com os 2 modelos.
Quem é os olha que vamos priorizar? Pessoas em times remotos que têm que coordenar reuniões, beleza. Viajantes, aí, a gente escolhe a alternativa tá? Isso aqui são perguntas de clarificação, é o humano no loop.
Eu quero ver rapidamente que horas são, escolher o usuário, encontrar boas janelas pra reunião olha, isso que eu quero.
Não sei se encontrar boas janelas foi 1 boa ideia, pode ser. Nível de planejamento, mostrar horários e diferenças difuso.
Está vendo como você vai explorando os detalhes todos, em relação ao que vai ser feito? E aqui eu vou botar 1 coisa que é o seguinte, só só vou incluir aqui no Legends MD pra eu não esquecer, porque eu vou esquecer. Ó, você pode usar XML, tá?
Critical.
Gere todas as especs em português PTBR.
Ptbr. Vou botar, não vai dar tempo talvez da do Harnister ter lido isso aqui, mas eu vou deixar lá.
Como o usuário deve comparar horários na primeira versão?
Selecionar a cidade base, ã, e converter por horário específico, pode ser.
Você pode também obviamente limitar o número de perguntas né, como o usuário deve montar a lista de cidades, buscar cidade, adicionar e remover livremente, legal, pode ser.
Então estou colocando algumas coisas aqui, tá?
Qual o sinal de sucesso? O usuário compara várias cidades em menos de 1 minuto. Beleza.
Enquanto roda? Enquanto roda aqui olha, eu quero fazer 1 coisa importante.
Quem conhece o negócio chamado getdesign.MD?
Bota no, quem já usou aí, getdesign ponto MD.
Esse negócio aí é legal, vou mostrar na sequência. Qual abordagem devemos usar?
Cidadecidade, relógio mundial, planejador leve de reunião, pode ser aqui.
Vamos ver se, se essas respostas estão boas. Ah, ele vai criar ali, deixa criar, tá? Depois que a coisa é a gente dar 1 ajustada.
É, getdesign.MD.
Esse negócio aqui, é bem legal, ele traz 1 série de designs, por exemplo, a o Airbnb, ele te traz todo 1 esquema visual baseado numa especificação de cores e tal, que você pode colocar no teu projeto. Então eu vou pegar o design do, eu vou eu vou pegar do Cloud Code que é mais, olha só, e eu vou usar o do Cloud Code tá, vou dar 1 create aqui, e vou trazer o seguinte ó, adicionei, que que ele fez? Ele botou esse design MD no projeto, Tá vendo que eu tenho todas as definições de cores, fontes, tamanhos, espaçamento, etcetera? Então deixa aqui tá? Eu vou fazer mais 1 coisa aqui que é o seguinte olha, inclua noagentes MD que é para ler e usar o design ponto MD, só pra ele relacionar. Aqui ele está dizendo, ó, e aí gostou do meu PRD? Putz eu nem vi o teu PRD, deixa eu tentar olhar aqui, espera aí.
Segue o rascunho, olha, está aqui o PRD todo, eu vou pedir algumas coisinhas aqui que é o seguinte, crie esse PRD em português, porque como eu falei não deu tempo de ler o Age CMD, faça com que o frontend pegue os dados dos horários do backend, que é a fonte da verdade.
Só pra você entender que você pode, obviamente, ler o que foi sugerido e pedir alterações, Entende?
Então essas skills de PRD, de negócio, elas são legais pra isso, pra você estruturar o plano de negócio do que você vai desenvolver, e aí, o Compose especificamente, ele faz a geração também de ADR. ADR, basicamente, é 1 documento que vai fazer 1 registro, né?
Architecture Architections Record, que vai permitir que você consolide certas decisões, que você foi tomando ao longo do tempo, e tenha 1 grau de reuso também dessas decisões, pode futuramente também utilizar.
Perguntou se está aprovado? Vou vou dizer que está, vou confiar tá?
Mas obviamente no dia a dia você tem que ler o que está acontecendo, né?
E aí, esse PRD vai ser definido aqui dentro, tá?
Está lá fazendo, está criando, ó, está fazendo em português porque obviamente eu pedi, mas agora que está aqui no Critical, ele vai, cadê o Critical? Está aqui, ó. A tendência é ele ele fazer, tá? Gera todos os espectros em português, especs, eu vou botar as especs que vêm das skills do Compose, começam em C Y, tá?
Pronto, vou fazer aqui.
E aqui eu já tenho o PRD criado, tá? Vou dar 1, ai está criando aí.
Eu estou usando o cursor pra rodar o PRD, você pode usar qualquer coisa. Então, a gente vai executar em Codecs mas eu estou usando o cursor pra outra coisa.
Não é 1 problema tá? Pode fazer como você achar melhor.
Então o que que ele fez olha, definiu. Que que é o relógio mundial para conversão por cidade?
Está aqui explicando os objetivos, as histórias de usuário, olha lá, quero escolher a cidade base para ter 1 referência de comparação, como integrante de 1 time remoto quero buscar cidade adicionar para comparar locais onde meus colegas estão, e foi olha, definições né, em relação às funcionalidades, coisas que não são objetiva, é muito relevante, né?
Como é que são as métricas de sucesso, os riscos, mitigações, as ADR sendo referenciadas, certo? E algumas questões em aberto que, não são tão relevantes assim.
Agora, você vê que eu já rodei, eu já gastei certos tokens, eu crio 1 nova janela porque eu não quero reusar aquela janela, certo? Ali eu já tenho, eu já estou arrastando o token, e eu vou fazer 1 Create Tex pack, Create Tex pack de quê?
Cara, poderia dar 1 copy aqui, dar 1 paste, é, poderia, opa, não pegou, espera aí, eu vou dar 1 copy aqui nessa pasta?
Não, deixa eu arrastar.
Posso fazer assim?
Posso só escrever que é o World Time Clock?
Só dar 1 enter assim e ele já vai, já vai entender. Poderia escrever o nome, tanto faz tá? Já entendeu olha, vou criar o espec para isso aqui.
Então essas skills elas obviamente mandam você ler o PRD, olha como ela lê a a lê também a lê também a as ADRs né, então fica tudo lá. Quando ele está fazendo ali, olha, por que que isso aqui é legal?
Você tem vários design, olha que olha que massas, design por exemplo da, deixa eu ver aqui, olha, da Apple.
Então você tem 1 design mais minimalista, né?
Você tem então vários designs legais.
HP, Ferrari, Figma, ó.
Então fica tudo muito parecidinho, né? Então pode ser 1 pode ser 1 coisa legal pra você, aí vai gerar esse design MD e você adota, né?
Show de bola gente. Então ele está está começando a seguir em frente aqui.
1 coisa que você pode fazer se você for 1 pessoa inquieta né, você pode por exemplo fazer aqui 1 Codec menos menos miolo, e eu poderia começar a fazer 1 outra feature em paralelo, pode dizer olha, eu quero fazer 1 cliente prd, eu só vou mudar esse modelo aqui pra pra 1 medium aqui só pra não, não ficar muito tempo rodando, Deixa eu só ver 1 coisa aqui, espera aí, deixa eu ver o que que ele está fazendo, tá. Converter o horário.
Uhum. Vamos usar só API date, está vendo? Isso aqui é 1 decisão do dev, olha, vou usar API date, beleza.
Como a Tec Spec deve tratar a data da comparação considerando que, aham, incluir campo obrigatório, assumir sempre a data atual.
Beleza.
Então vamos começar a responder perguntinhas mais técnicas, olha.
Eu tenho medo de responder errado isso aqui.
Dá pra usar Open Meatu?
Vamos ver se vê se se essa p está disponível aqui.
Você vê que ele não pegou, você vê que ele não pegou, ele não pegou a, ele não pegou a a skill aqui olha.
Basicamente, deixa eu ver 1 coisa, espera aí.
Não, pegou assim, acha que não tinha pego mas aqui mudou a sintaxe, o Codex agora está usando o cifrão.
Você pode vir aqui em paralelo e já startar 1 outra se quiser, tá?
Vou usar Open Meet You Enquanto isso eu já vou deixar a nota rodando, olha, 24 horas, beleza.
Vamos criar 1 outro PRD, que se aplica ao, deixa eu ver o nome do outro.
Worldtime zone clock, para permitir que seja possível internalizar internar internacionalizar o idioma e exibir em português e inglês, beleza, fazendo com que o usuário possa trocar o idioma direto na tela beleza, deixa criando o PRD de 1 lado, vamos olhar, vamos olhar isso aqui do outro olha, já criou aqui né? Vai criar, está escrevendo Beleza. Deixa eu terminar de escrever aqui.
E você vê que tem 1 interoperabilidade, certas respostas que foram dadas terminar de criar.
Olha, começou a fazer pergunta. Você vê que o cursor ele suporta aquela aquele componente de interação de usuário, então você pode ir clicando.
Aqui ele já não suporta, então eu vou ter que dizer ah, detectar português padrão, olha.
Beleza.
Vou aprovar, tranquilo, e aqui eu vou dizer beleza, cara B, português padrão.
Deixa ele escrever aqui.
Troca de idioma deve ser lembrada quando o usuário voltar ao app? Não precisa. Volta pro português, beleza.
Quais partes da experiência deve mudar de idioma toda interface visível?
Ah, beleza. Eu estou respondendo aqui enquanto está gerando outro, tá?
Haja cabeça para ficar trocando de contexto, né?
1 tela dos olhos deve trocar o idioma, simples PTBR no topo, é, é isso aí que eu quero. Olha.
E nisso a gente já tem, a gente já tem aqui, olha, a nossa espec técnica feita.
Então, olha o que que é relevante da PEC técnica, gente.
Eu quero exatamente todos os componentes que eu vou mexer, que eu vou mudar, que eu vou criar. Então, é isso aqui que evita que você leia arquivo demais e que você gaste token demais.
Então aqui olha, deixa eu dar 1 Keep on, aqui você tem toda a definição do fluxo de dado, aonde que ele vai bater em termos de Spec, quais são as interfaces que vão ser criadas, os nomes dos componentes.
Em termos de API, data model, payload, Status Code, então olha como está tudo, payload, tudo bem definido.
Então, você concorda que, com isso, você pode usar 1 LLM mais barata, pra executar, que é a parte mais cara do processo? Você pode usar 1 nível de resorning mais baixo também, porque você já tem todo o plano devidamente criado e está tudo aqui. Fechou essa parte, tá?
Agora eu vou pras tasks aqui tá? Olha, c y create tasks e aí você pode fazer 1 coisa, eu posso vir aqui, pegar aqui o World Time Clock, arrastar, porque agora eu quero decompor as tarefas como eu montei antes, e em paralelo, eu tenho aqui já algumas coisas acontecendo, que é o seguinte, abordagens possíveis, olha que legal. Seletor, simples no topo, é isso que eu quero. Não quero preferência que seja lembrada nem de jogo automático, quero 1 task simples.
Então, rodando aqui com o GPT de 5.5 medium também, ele está seguindo adiante tá?
Beleza, vou usar o padrão, frontend Backend, 5 Adrs referenciadas, ele está agora lendo pra ter compor a Task, já temos a nossa PRD criada ou está criando na verdade, né, pra cá.
Se você ficar entediado você pode começar outra tarefa, entendeu?
Mas aí talvez confunda né? Vamos ver.
Tá, dá pra ter criado outra.
Que que ele falou pra mim aqui olha, ele ele sugeriu o seguinte olha, vamos criar de 1 a 8.
Eu acho muita tá? Eu vou dizer o seguinte, faça em apenas 3.
Não não quero 8.
O que que é muito o que que é pouco?
É, 1 tarefa só é pouco, porque ele vai usar muito contexto, vai arrastar muito token.
25 tarefas é muito, porque você vai ficar fazendo tarefinha e cada tarefinha tem vários critérios de validação, de teste, et cétera.
Então é feito 1 API, que que é melhor? 1 serviço só que traz tudo ou vários serviços pequenos? Tem 1 meio do caminho ali que é o ideal.
Então pra esse tipo de de execução, 3 tarefas pra mim está bom.
Eu vou deixar 3 tarefas aqui, pra fazer a decomposição.
Aqui eu vou aprovar.
Tachou, o que for sugerido aqui está legal pra mim.
Vou dizer aprovado. Porque ele falou, olha, está bom, a primeira tarefa é do backend, a segunda é backend, a terceira é frontend. Serve pra você? Serve, Apú.
Gera pra mim as tarefas a que ele está gerando a o PRD, o outro PRD. Então legal.
Vamos ver aqui o PRD da internacionalização, aí olha, permite alterar entre idiomas português e inglês, o objetivo é, né, eu como usuário quero poder abrir aplicação em português, quero poder trocar para inglês, e aí explicou tudo que está contemplado no negócio.
E aí gente, enquanto isso, vou gerar as tasks aqui, está finalizando, já vou abrir outro terminal aqui pra começar a rodar essas tasks, vamos ver o que que vai acontecer.
Ó, repara que a tarefa ela tem o passo a passo, está vendo?
Então isso faz com que você não tenha que dar muito espaço pra Reasoning do lado do modelo, o modelo vai ser 1 mero vai pegar exatamente você falou fazer isso isso isso dessa e dessa e dessa forma.
O nível de frustração baixa né?
Você consegue chegar num resultado muito mais fácil.
Então, está gerando aí as tarefas, vai terminar de gerar, olha, já gerou 2. A primeira é, a primeira é backend, na verdade. Segunda é backend também, porque tem 1 parte de de APIs, vai chamar cidade, vai analisar time zone, vai ver diferença.
E a terceira tarefa, ela é do frontend, então, tudo que vai ter que ser criado em termos de componentes, etcétera.
Vale dizer que a tarefa 3 provavelmente vai gastar mais, ela vai arrastar mais token, então às vezes compensa separar ou não, vai da tua experiência ali com o uso de perceber isso né?
Bom, aqui está finalizando já, eu já consigo startar, vamos botar aqui pro lado 1 pouquinho.
Compose ele já vem com esse task looper, né? Então eu vou dizer o seguinte, é, eu vou chamar o Compose o executável do Compose, e aí ele tem basicamente 1, 1 possibilidade aqui que é você escrever tasks run, e eu vou dizer qual que eu quero rodar, a que eu quero rodar é o World, timeson, clock, dá 1 enter.
Que que ele começou a fazer aqui gente? Dá 1 kip all.
Olha, então agora ele startou, o seguinte, vê que está parecendo o Codex né, porque na minha máquina eu já deixei o Codex como padrão, mas se não fosse Codex seria outro, o Compose ele tem 1 arquivo de configuração, enquanto ele está rodando aqui eu vou explicando.
Ele tem 1 arquivo de configuração, é, deHub com, Compose, compose, tá.
E está aqui embaixo olha.
Que aí você pode colocar no teu home, espera aí, deixa eu só caçar ele aqui, aqui olha.
Olha. Qualquer motivo o control f não pegou pra mim, está aqui olha, pronto.
Olha só, então está lá, ah eu vou usar a IDE Codex com o modelo GPT 5.5, com Efforthing ou não, Você pode você pode definir como vai ser a configuração dele, né, então você pode definir isso aí, tanto num home config quanto num projeto também, né? Se não tiver essa configuração criada, ele te pede, na hora que ele vai fazer a execução tá?
Então é isso.
Legal, então aqui olha, você pode navegar, ele vai rodar em cima do teu Codex instalado na máquina, entendeu? A camada em cima do teu Codex, do teu Cloud Code, ele suporta pelo menos uns 10 diferentes né?
E aí você não precisa se preocupar em passar de 1 task pra outra, ele vai ficar rodando as tasks lá, vai usar os seus MCP's, vai usar as skills que estiverem no projeto, vai usar todos os detalhes de design, tudo que tiver aqui, né a gente colocou, tudo vai ser utilizado de acordo com o que está aqui.
Obviamente, vai ficar rodando, vai rodar por 1 tempinho, está rodando teste por quê?
Porque tem 1 Rue explícita aqui de testes, né. E aí enquanto isso, né, quando a pessoa, por que por que que é relevante, agora vocês entenderam, a a chave 1 pouco da produtividade é é isso, né?
É você poder, de certa maneira, ó, ó, criou a DR, vou dar 1 barra Clear e vou fazer.
CXCreate, CI quer dizer, Create Xpec de quem?
De quem que é? É do, aqui olha, dezoiton.
Vou dar 1 enter.
Então eu estou sempre trabalhando no planejamento enquanto eu tenho 1 ou mais coisas sendo executadas. Entende por que que eu não não faz sentido eu ficar provando, pessoal, está muito claro isso? Por que que não faz sentido eu ficar provando cada etapa?
Ficando em L 2, aqui eu pulei pra L 3. Porque aonde que eu fiz essa aprovação? Ah mas você não sabe o que que vai ser criado. Não, eu sei exatamente o que vai ser criado, porque o que vai ser criado está aqui.
Está aqui na Anthexpec.
Eu sei cada detalhe de cada interface, de cada serviço, aí você vai dizer, está bom, mas a LLM ela é de ela não é determinística, ela pode não seguir alguma coisa. Claro, aí você faz 1 processo de Code review, 1 processo de qa, que pega o baseline que era esse, e compara em relação ao código que foi gerado. Faz sentido?
Deixa eu só fazer 1 1 Git Nietzsche aqui antes que seja tarde, pronto.
Esqueci.
É, porque ele ele no final ele dá uns comites ali. Você pode configurar né, se ele vai autocomitar cada tarefa ou não. Eu particularmente não faço questão de ter autocomite não tá? Particularmente eu prefiro, no final, olhar o código todo, depois de fazer que é automatizado, Code review, eu prefiro olhar o código todo decidir o que eu faço tá?
Aqui então olha, Olha que legal gente, está vendo que seguiu exatamente olha, porque aqui nas Roose tinha 1 folder structure que dizia, olha, para a data tem integrações, acesso a banco, persistência, et cétera.
Então se a gente observar, olha, aqui em Deira, eu tenho, tudo criado, o teste, e o código.
Eu tenho o Hauts, aqui, e o código.
Eu tenho o Services, teste código. Eu tenho os types, olha que lindo.
E aqui, eu tenho a home, a o componente principal, que vai inicializar e vai fazer o bind das rotas, então, lembra guias e sensores, guias são coisas que você direciona, como a gente fez aqui, eu defini rows, que tinham folder structure, tinham Code standard, tinham padrões de Rest, foi seguido.
E eu tenho sensores, ou seja, pra garantir que isso funciona, eu tenho testes sendo executados o tempo todo, as coisas vão acontecendo. É, tem muita gente usando composto tá gente? Bastante assim, a gente tem 1 grupo lá com mais de 500 pessoas usando, mas muitas empresas adotando e tal, porque esse looper, como eu falei, é, se tem 1 coisa que o Pedro é bom é nesse tipo de coisa, ele fica focado fazendo, é a obsessão da vida dele é fazer isso aqui.
É, então é muito redondo e já é o terceiro e o quarto. A a terceira ou quarta evolução em cima da ideia inicial. Então chega num ponto em que está bem redondo, 1 1 1 crítica que eu tinha à versão anterior era que cara, o processo era longo demais assim olha, então ele gastava muito e demorava muito por tarefa.
Você vê que agora ele rodou a tarefa em 3 minutos, não é muito, sabe?
E não é só rodar, é rodar, é rodar teste, é rodar check, é é rodar aqueles sensores todos que eu falei. Enquanto está rodando aqui, você está em outra janela respondendo, olha. Pergunta técnica, para o 18 n, como é que você quer fazer? Ah, vamos usar a biblioteca de 18 n do React.
Entendeu?
Aí eu estou respondendo aqui, eu estou focado aqui nesse planejamento, a solução do problema, estou lendo. Outra pergunta técnica, você quer padronizar o que exatamente?
É, pode ser use Translation, legal.
Segue em frente.
Quer mais? O frontend não exibe mensagem, cru do backend, o map estado, o backend passa a retornar mensagem localizada. Não, eu prefiro eu prefiro fazer no frontend, está o ar de novo.
Ele está me perguntando coisas, né? Qual é a estratégia de teste?
V teste e React Testing libre, pode ser? Beleza.
E aqui ele está tocando ficha.
Olha, está fazendo já run build, então já está rodando sensor, NPM teste, está rodando mais coisas. Você vê que ele já criou os endpoints de de time Comperizon, criou os timesone service, que legal.
E a gente está respondendo aqui, beleza.
Estamos registrando a d r, olha lá.
Está vindo pra cá já, ó. Já fez 1 DR aqui que era o quê? Vamos ver.
Decisão.
Vamos usar 1 controle simples PTBR no topo da tela.
Isso na hora de executar a tarefa é bem relevante, tá? Que a tarefa lê a DR e ela não tem tanta dúvida a respeito de decisões que são mais críticas, né?
Está lá, criou as ADRs todas, terminou, deixa eu ver.
Está gerando aqui a Texpec.
Deixa ele girando aí. Olha lá, gente, já está na última, hein?
Hein? Já está na última tarefa.
Deixa rolar, vamos ver o que vai acontecer.
Estamos acabando, hein?
Estamos estamos na última tarefa aí, mais 5 minutos, a gente já fecha.
Vou dar 1 aprovado aqui olha.
E o que eu quero tentar transmitir pra vocês principalmente é isso né, é é o quão legal é essa, esse paralelismo tá?
Essa sensação de paralelismo.
Então a gente já está na última tarefa aqui sendo executada, ele está lendo aqui, o frontend geralmente é rapidinho tá?
Já está começando a criála.
E aí olha, rodou o teste, o teste falhou, o sensor, vai voltar, vai instalar alguma coisa que esteja faltando.
Aqui olha, próximo passo usar CI CRATE Task a partir dessa Texpec legal, tá, tá fazendo aqui já fez já persistiu cadê deixa eu ver aqui ah tá com 2 3 ok ó limpa o contexto chama o Create Task arrasta a pasta dá enter.
Deixa fazendo aqui e vai para lá.
Deixa eu ver o que ele já fez no front.
Tá, já criou o serviço de API.
Já criou os tipos do time Zone, beleza, agora já deve estar já nos componentes visuais aí, olha.
Não sei se tem algumas perguntinhas da galera, Valdemar, se quiser já trazer, de repente enquanto a gente executa esse último aqui olha.
Cara, é, o pessoal já fala de Worktrip vai até que esqueci de falar se puder falar de Ah legal.
Como tu lida com Worktrip fazer coisas em paralelo é 1 conceito bem importante Exato exato. O Worktrip é fundamental, o Worktrip pra quem nunca usou é como se você colasse o projeto 2 3 vezes.
Quem nunca fez isso né? Eu já tenho arquivos que estão, modificados, eu não quero dar 1 teste, eu não quero perder aquilo ali, eu quero seguir trabalhando, mas eu quero fazer outra coisa em paralelo que não tem relação. Então a Worktruey é 1 maneira que o Git faz, nativamente, pra justamente criar esse outro clone, permitir que você trabalhe nele e aí você a partir dele crie 1 PR ou traz isso de volta pra 1 outra Branch, você tem essa liberdade, tá?
É fundamental quando você pensa em paralelismo de código, por que que acontece? Se eu abrir 2 instâncias desse tasklooper aqui mandando fazer coisas diferentes, entende que eles vão sair modificando eventualmente os mesmos arquivos.
E aí você pode ter 1 problemão, quer dizer 1 está criando 1 coisa outra desfazendo, porque você está carregando na memória estados diferentes dos mesmos arquivos. Então, pode ser 1 má, pode ser 1 má ideia, né? Então eu recomendo que você, de certa maneira, evite evite fazer isso, tá? Então o Worktrease for fazer implementação em paralelo. Eu gosto do primeiro nível de paralelismo ser 1 paralelismo tipo esse que eu estou fazendo olha, fazem 2 tarefas.
Planejamento e 1 execução, aí você vai levando 1 pouco ao teu nível de consciência, lida com 2 coisas, 1 em planejamento e 1 execução, aí daqui a pouco você consegue executar 2, vai aos pouquinhos entendeu? Olha, aprovado, mandou gerar, acompanha outra.
E aí você vai vai evoluindo olha, aquele já fez a tela tá gente?
Então está a tela até bonitinha olha, fez os testes olha, a Amazoni, ah está fazendo tudo Já botou botou algumas coisas visuais?
Que mais? Mais dúvidas?
O pessoal perguntou também se esses arquivos tu criou de Spec então autodeixa eles no repositório ou não. Boa.
Então, é como eu estava falando antes, essa questão dos arquivos de SP, você pode ou descartar, ou achar 1 metodologia que funcione tanto centralizando num rap só, quanto de repente você pode, se você quiser, subir isso numa plataforma feito 1 Gonfluence ou mesmo anexando num num linear sabe, num gira, você pode fazer isso mas é muito 1 governança da tua empresa, não é não vem tanto do Spectoriver não tá? O Spectoriver só está gerando conhecimento agora esse conhecimento não necessariamente na minha opinião, ele é igual.
Às vezes o que você tem numa numa Texpec não é a mesma coisa que você tem, quando você coloca isso numa plataforma centralizada porque aqui tem muito conhecimento, que é exclusivo e é específico daquilo que você está fazendo com o IA. A quebra, as quebras são todas muito orientadas ao LLM.
Talvez ter 1 processo que a gente, o que extrai o conhecimento mais puro, pega esse conhecimento e entregue numa base comum. Então aí talvez não seja tão fácil ou tão simples de fazer, tá? Mas no mínimo isso tá gente? No no no mínimo isso.
É usar 1 plataforma externa que seja capaz de te fornecer essa capacidade.
Mas tem mais 1 tem algumas pessoas perguntaram 1 coisa que a gente já falou aqui no workshop sobre adotar IA em projetos Brownfield assim ele fez eles falaram ai esse é 1 Greenfield como que fica no programa Brownfield esse gráfico é 1 pouco não muda muito né? E todo mundo se sente especial essa essa é a verdade assim, é sempre assim.
E eu falo isso cara, que eu dou aula pra milhares de pessoas assim, eu escuto todo tipo de pergunta o tempo inteiro, tá?
E todo mundo se sente especial, todo mundo tem que não, aqui no meu cenário não vai funcionar. Isso é 1 grande besteira.
A grande realidade é como eu expliquei, a ALLM não leu o seu projeto inteiro, ela não conhece o seu projeto todo. A diferença é que se você tem 1 projeto com muito débito técnico, esse débito técnico exagerado vai prejudicar os sensores que você tem, vai complicar os guias que você vai criar, então ele vai se manifestar dessa maneira. Se o seu projeto é grande ou pequeno, não importa, a ALLM vai ler partes muito específicas dele, o máximo que vai acontecer é você ter que direcionar bem pra que ele funcione, né, basicamente isso que vai acontecer.
Então, quanto mais dívida, mais você vai ter que se esforçar arquitetura, pra ter 1 resultado melhor. Se o seu código for muito pouco expressivo, a LDB vai ter dificuldade em entender. Se tiver muita duplicação ela vai mudar 1 coisa e quebrar outra, concorda? Por quê? Porque isso é 1 débito técnico que também ele ele iria, de certa maneira, prejudicar o ser humano, tá?
O o o ser humano acabaria tendo talvez o mesmo o mesmo problema.
Beleza?
Show de bola, que mais? Olha, acabou aqui tá gente, aqui já, já acabou tá? Então já está está rodando.
Então quando acabou Pode finalizar, pode finalizar da da overb Show de bola galera? Olha, vou dar 1 vou dar 1 aqui, Deixa eu só dar 1, dar 1 aqui, deixa eu ver, apesar que eu acho que ele já deixou rodando, deixa eu olhar, espera aí, só para eu não matar o servidor sem necessidade, deixa eu ver se ele deixou, vê se ele deixou rodando, espera aí.
Deixa eu só consultar as as portas aqui pra ver se ficou ou não ficou.
Aham, deixa eu ver, espera aí que ele largou tudo.
Deixa eu fechar os browsers aquele abriu aqui de os browsers aquele abriu deixa eu acharear minha outra janela espera aí só para não ficar nesse browser aqui calma calma lá, deixa eu abrir aqui o outro, pronto.
Tá, 5 1 7 3, está aí. Deixa eu tentar ver aqui, espera aí, Florianópolis.
Deixa eu colocar agora, olha lá, botar em cidades mais longe pra daí a gente fazer a comparação.
Estão vendo que o design parece o design do Cloud Code?
Deixa eu botar.
O design até fica parecidinho aí com o, com o Cloud Code, né? Então, é essa a ideia, tá gente? Essa essa a ideia. Você vê que assim, ficou bonitinho, a tela ficou a tela ficou bem ficou bem aceitável, tá? Não não está muito feio, mas não está também, né, não está maravilhoso, né, não está a coisa mais bonita do mundo.
Pra encerrar, deixa eu só voltar aqui pro pro código só pra concluir.
Então, oh, você vê, está aparecendo aí, né? Acho que está. Você vê que os componentes ficaram todos abaixo, oh, de de de 100 linhas, não ficaram muito grandes, tá?
Porque existiam luz, explicitamente, que pediam, ó, aqui no React e aqui nos nos Code Standards, falava muito sobre não ter componentes grandes, acho que está aqui no React.
Evite componentes, use mesmo, ó componentes size, ó.
Então nem sempre ele vai seguir à risca, né? Mas você vê que o código está todo em inglês, ele está bem está bem está bem organizado, tá? Deixa eu botar também aqui por último só contatos meus, então você quer, estamos encerrando né, encaminhando pro final, então quer ver mais conteúdos desse? Eu gravo bastante no Instagram tá gente? O Instagram aqui Rodrigo Branas barra, Instagram barra Rodrigo Branas, tem bastante coisa. Eu estou sempre gravando Reels, ou então stories mais curtas, né?
Youtube ponto com tem bastante coisa também em vídeos, não só de IA, como de arquitetura de software em geral.
Brana Zail tem muita informação também de curso, de outras coisas. Eu estou promovendo o evento em São Paulo, presencial, até esse que eu falei pro Valdemar.
Então, quem estiver em São Paulo e quiser participar, é 1 imersão que vai rolar no dia 30 de maio, tá? E a ideia é falar sobre várias tendências do momento, então, não só Contex e e Hardware engineer, mas arquitetura de solução, desenvolvimento autônomo, deving, a parte toda de OpenClauw, Hermes, second brain, migração de legado, então esse é 1 evento presencial, vai acontecer 1 vez só, tá? Lá em São Paulo. Então, se quiserem, lá em BranasIO, em imersão, você consegue se inscrever. A gente está, já com 60, 70 por 100 já dos ingressos vendidos, mas, se você às vezes está perto de São Paulo tal, não é 1 evento caro, então é num hotel, a gente vai conseguir interagir bastante, vai ser nesse auditório aqui. Já convido também Valdemar, Felipe, William, se estiverem lá por São Paulo também, quiserem participar ali vai ser 1 prazer imenso. E é isso gente, então, compôs e espero ter conseguido mostrar também a a ideia do spect driven, a ideia do tasklooper, a ideia do paralelismo, a mudança de mindset, os desafios, né? Claro que você no dia a dia vai ter que ler muito mais, questionar muito mais, criticar muito mais as especs, mas ter 1 tasklooper que fica ali rodando, promovendo os sensores, adequando os guias, tudo vai convergir para 1 resultado de muito mais qualidade.
Está bom meu povo? Quantas, olha, 1 pouco, quase, hein Valdemar?
Olha aí, hein, vou abrir aqui, abri, cadê, cadê, cadê?
Deixa eu dar o refresh aqui, vamos ver. O 2000, né gente? Está está ali né? Bora lá galera, 2000 vale 2000 vale 2000.
Se chegar, manda lá 2000 cara muito obrigado. Obrigado vou aparecer lá no evento também. Mas é imenso.
Massa demais.


> 🔗 **Links:** [#2 getdesign.md / awesome-design-md](http://getdesign.md/) · [#10 branas.io](http://branas.io/)