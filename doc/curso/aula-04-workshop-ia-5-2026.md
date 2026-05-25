# Aula 04 — Workshop IA 5/2026 - Gravação

**URL:** https://www.techleads.club/c/workshop-ia-5-2026-gravacao/sections/1027866/lessons/3906408  
**Seção:** 1027866 | **Aula:** 3906408 | **Transcript ID:** 3915323  
**Duração aproximada:** 00:14:59

---


## Resumo

Case curto (~15 min) de empresa média (Velora, software para ONGs) adotando AI-first em toda a organização: AI champions, stack Cursor+Notion+Slack+Linear, tickets como 'slices' para agentes, abandono do Scrum tradicional, bot de PR review, protótipos no Cursor por PM/design, e desafios de padronização e segurança (SOC2).

**Palestrante:** Geovani (Staff Engineer, Velora — Canadá)

## Tópicos tratados

- Velora: contexto (Canadá, ~200 pessoas, 6 times de dev)
- AI-first company-wide, não só engenharia
- Time de AI champions e entrevistas com foco em IA
- Stack integrada: Notion Agents, Cursor, Slack, Linear
- CEO prototipa → devs+CTO entregam produto em ~3 meses
- Scrum → To Do / In Progress / Done; tickets 'slices' para agentes
- TDD humano + IA expandindo detalhes e protótipos
- 1–2 devs por projeto com autonomia ponta a ponta
- Bot interno de PR review com fallback humano (segurança)
- Design/produto saiu do Figma → protótipos no Cursor
- Fluxo: descoberta → PRD → TDD → slices → plan → PR → ship
- Desafios: padronização, homologação SOC2, volume de revisão
- Dicas: evangelizar, treinar, começar hoje

## Links compartilhados

Lista completa: [`aula-04-shared-files.md`](./aula-04-shared-files.md)

| # | Categoria | Recurso | URL |
|---|-----------|---------|-----|
| 1 | Skills e Agentes | 😎 awesome-tech-lead | https://github.com/tech-leads-club/awesome-tech-lead |
| 2 | Vídeos | 📹 Dev Lab Youtube | https://www.youtube.com/@waldemarnetodevlab |
| 3 | Canais TLC | Newsletter | https://techleadsclub.substack.com/?utm_source=community&utm_medium=header |
| 4 | Canais TLC | 🗞️ Newsletter Substack | https://techleadsclub.substack.com/?utm_source=circle |
| 5 | Canais TLC | 🖼 @waldemar.devlab Instagram | https://www.instagram.com/waldemar.devlab/ |
| 6 | Outros | Slides do case | https://tlc-workshop-ai.giovannymassuia.io/?slide=9 |
| 7 | Outros | Cursor | https://www.cursor.com/ |
| 8 | Outros | Linear | https://linear.app/ |
| 9 | Outros | Notion | https://www.notion.so/ |
| 10 | Outros | Slack | https://slack.com/ |

## Referências na fala

Cruzamento entre o que foi dito e os links da tabela acima:

- **Velora: contexto (Canadá, ~200 pessoas, 6 times de dev)**
- **AI-first company-wide, não só engenharia**
- **Time de AI champions e entrevistas com foco em IA**
- **Stack integrada: Notion Agents, Cursor, Slack, Linear** → links #4, #7, #8, #9, #10
- **CEO prototipa → devs+CTO entregam produto em ~3 meses**
- **Scrum → To Do / In Progress / Done; tickets 'slices' para agentes** → links #1
- **TDD humano + IA expandindo detalhes e protótipos**
- **1–2 devs por projeto com autonomia ponta a ponta**
- **Bot interno de PR review com fallback humano (segurança)**
- **Design/produto saiu do Figma → protótipos no Cursor** → links #7
- **Fluxo: descoberta → PRD → TDD → slices → plan → PR → ship**
- **Desafios: padronização, homologação SOC2, volume de revisão**
- **Dicas: evangelizar, treinar, começar hoje**


> **Como usar:** consulte o resumo e os tópicos para contexto rápido; use a tabela numerada e a seção *Referências na fala* para cruzar o conteúdo falado com os links em [`aula-04-shared-files.md`](./aula-04-shared-files.md).

---

## Transcrição

O Valdemar falou pediu pra eu compartilhar 1 pouco da do que está acontecendo na empresa, aí eu tinha feito umas notas aqui eu falei ah mas espera aí a gente está numa coisa de aí ah deixa vai dar uns slide aqui.
E curiosamente fiz isso agora durante o o evento então, é bem novo. Ah se começar desculpa, tem como dar 1 zunzinho aí pro pessoal tentar mais por favor.
Será que é responsivo agora pô?
Ah agora eu até chegar lá. Boa valeu.
Se quebrar a culpa é do Claudio, não minha.
Beleza. Bom, vou compartilhar aqui 1 pouco com vocês o que está acontecendo na na empresa, e eu estou bem contente que tudo que foi falado até agora o Valdemar falou, o Felipe também entrou em detalhes, está acontecendo no nosso dia a dia. Não foi combinado o que eu tenho escrito aqui, mas eu vou ver que vai bater bastante com o conteúdo. Achei isso bem interessante, estou bem feliz com isso.
Mas vamos lá.
Frase de impacto do da AI né? Que a gente não escreve mais código, a gente só gera código agora.
E só pra dar 1 contexto pra vocês, meu nome é Geovani, eu trabalho como staff aqui no no Canadá pra essa empresa que chama Velora, provavelmente vocês nunca ouviram falar dela, mas é 1 empresa que é especializada em prover software pra ONGs, pra igrejas, pra empresas com sem fins lucrativos, então ela provê todo o ecossistema necessário pra você operar 1 ONG, né? Então desde captação de de doações, o gerenciamento de doadores, e também a contabilidade disso.
A empresa não é é big tech não é grande, mas ali tem mais ou menos uns 6 times de dev com mais ou menos 5 devs por time, tá?
E aí tem mais tem DevOps, tem produto, tem toda a parte de Business também, no total não passa muito de 200 pessoas na empresa então não é 1 empresa grande, considerar médio porte.
Igual como eu falei o coronel falou também, estou no Canadá, sou dev aí há 1 bom tempo já, e, e é isso.
Na empresa, a gente está se posicionando como a a inative agora ou a a I first essa nova palavrinha e o interessante que lá na empresa não está sendo só engenharia, é a empresa inteira que está a I first então desde do suporte do até engenharia e eu arrisco dizer que o pessoal não da não engenharia está mais engajado do que a própria engenharia nisso tudo tá? E o que está sendo bem bem interessante.
A empresa como 1 todo criou 1 time de a I champions, que a gente chama, que desde acho que começou no começo do ano se eu não me engano, que tem pessoas de cada departamento ali dentro, trazendo os problemas, trazendo novidades, testando coisas novas pra espalhar pela empresa então tem 1 time ali que está sempre à frente, evangelizando AI.
Entrevistas a gente está cobrando que os candidatos conversem com a gente, o que eles estão usando de AI, obviamente não precisa ser expert, mas a gente está querendo que, então eu estava falando que o as entrevistas a gente está pedindo que os candidatos falem pra gente sobre AI e como eles estão usando.
No dia a dia, a gente está bem ativo com notion, especialmente notion agens, o virou nosso padrão pra IDEs, o Slack e o Linear também fazem parte desse sistema de AI então entre esses 4 produtos aqui tem 1 integração muito próxima de o cursor no no no no no buscar contexto, o criando código, o slack conectado com os criando o fazendo todo 1 processo, então tem todo 1 1 acontecendo bem complexo e não só engenharia, igual eu falei, a empresa toda está nesse nessa pegada. E ali na empresa a gente está com 1 teve 1 sorte muito grande que o nosso CTO está puxando isso bem forte, ele está trazendo pra gente treinamentos direto do do cursor do notion, a gente teve 2 do notion já e 1 do cursor, lá pra empresa, e ele está sempre ativamente incentivando todo mundo a usar, engajar, de qualquer forma que seja do mais simples ao mais avançado, então isso eu achei muito interessante ter essa, esse ali do do CTO pra gente né? E aqui 1 caso interessante que acabou de acontecer, teve 1 novo produto que o CEO criou 1 protótipo, e 2 devs mais o CTO entregou em coisa de 3 meses 1 projeto completo que é 1 novo produto pra empresa até.
Foi 1 1 que eles usaram AI do 0 até a entrega e foi muito sucesso porque eles conseguiram entregar muita coisa em muito pouco tempo.
Então está acontecendo.
Isso.
No fluxo de desenvolvimento, mais especificamente, a gente saiu, tá quase saindo completamente do scram e passando a ter basicamente, a gente costumava ter o ali com status agora só tem to doo, in progress e done só isso não tem nem mais pra você noção nossos tickets estão virando slices que a gente está chamando que é basicamente são maiores, mais ricos, e que alimenta o agente e não o humano. Então está sendo quebrado os tickets em tamanhos maiores com o objetivo de usar no né?
Esse é o o laitest, a última notícia que a gente tem assim de de fluxo.
O nossos tdd's ainda estão sendo escritos por humanos obviamente, mas a IAI está ajudando a expandir os detalhes absurdamente. E também as pesquisas protótipos e coisa e tal então, eu estou anotando que durante o TDD as pessoas estão conseguindo testar muito mais rápido e já ter protótipos que eles conseguem até incluir como parte do projeto em si, né.
Os projetos, eles cresceram, tem mais projeto em paralelo como nunca agora.
A gente acabou diminuindo quantos devs tem por projeto, então está na média de 1 ou 2 devs por projeto, às vezes tem 3 quando o projeto é maior ou tem mais urgência, mas isso também vem com autonomia dos devs, então a gente teve que dar mais autonomia pros devs, e e trabalhar nesse tudo. Pros devs acabam que é menos ali pra eles trocam menos de problema, mas eles estão com projeto de ponto a ponto para entregar. Isso não está só com o seniores, tá? Isso está até os intermediários estão tocando projetos também.
1 coisa interessante que está tendo lá que o Valdemar comentou anteriormente, a gente tem 1 bot interno que trabalha ali em conjunto com o e mais algumas outras métricas, na revisão da PR e esse bot ele pode ir lá e falar PR está aprovada. E aí você pode ir e só mandar o código pra frente.
É claro que isso fica a julgamento do desenvolvedor, que é dono daquela PR, né? Obviamente ninguém vai só clicar lá e avançar 1 coisa que não faz sentido, mas, se o desenvolvedor olhar e falar assim não beleza, o bot falou está com certinho, ele pode avançar sozinho com a pr.
E se o bot tem algumas métricas dele lá de segurança, a gente usa o uís pra detectar algumas falhas de segurança e coisa e tal, se ele ver que não teve suficiente, ele pede a revisão de 1 humano, ele obriga 1 humano a ir lá e revisar. Mas, a gente está testando, está sendo bem positivo até agora.
Eu acho que especialmente porque os devs estão conscientes de que não é porque o bot aprovou que está tudo certo, né então eles estão fazendo 1 double checker em cima.
E outra coisa também está acontecendo bastante, produto e design, basicamente saiu do Figma, faz meses que eu não vejo alguma coisa no Figma.
Se eu vi alguma coisa foi porque ele estava usando o Figma como se fosse 1 Miro de desenhar uns fluxo ou alguma coisa assim, mas usar o Figma como protótipo ou layout não está acontecendo. Produto, design, tão usando o cursor direto, criando protótipos, às vezes mais fiel ao produto, às vezes menos fiel, mas no geral eles querem testar a ux, o produto, a ideia, o fluxo ali e aí esse protótipo é passado pros desenvolvedores que traduzem isso no sistema de verdade.
Então isso está acontecendo bastante e interessante é que não está tão problemático quando eu achei eu achei que seria, eu achei que isso aqui ia começar a dar problema, o produto queria shippar o que eles os protótipos estão criando, mas até o momento está bem saudável essa comunicação e está bem interessante você ter ali os protótipos com o cursor porque ele é muito mais sofisticado e avançado dos que você consegue criar no Figma, né? Então está bem interessante.
Esse aqui é o fluxo nesse momento, obviamente a empresa inteira não está nesse nível ainda, mas no geral esse é o a última tecnologia que a gente tem de fluxo acontecendo, né? E está bem perto do que a gente veio conversando até agora.
A gente tem aqui, como se fosse 1 parte de planejamento, é 1 parte de execução, então tem toda a descoberta, o produto vai atrás, cria protótipo, conversa com com o cliente, conversa com todo mundo e coisa e tal.
PRD é gerado, depois o TDD é gerado, pra projetos maiores, tem bastante interação aqui entre o produto e os desenvolvedores.
Esse TDD é quebrado em, no que eu falei anteriormente, linear slices, que seria esses tíquetes maiores, umas features bem grandes.
E na execução, basicamente a ideia é você pegar esse tíquete, você planeja ele, aí você pode quebrar aí mais tickets pequenos se você precisar e aí vai do da forma que o desenvolvedor se acha mais eficiente trabalhando.
Né? Aí implementa pr e shippa o o código né? Os slides aqui, é interessante que eles de fato podem gerar PRs maiores, obviamente, mas obviamente o o o desenvolvedor consegue ir lá e criar várias prs talvez fazer 1 de PR de não não importa aqui a ideia, a ideia é aquele shipp mais rápido, né o ciclo ali de desenvolvimento seja bem eficiente.
Outra fase de impacto do que o que o Cláudio colocou aqui mas, meu trabalho hoje não está sendo mais está sendo mais orquestrais dos agentes, revisar o contexto e desenhar os sistemas né?
Então hoje o foco está em gerar código, mas obviamente que existem existem tarefas, especialmente ali no no domínio de pagamentos, na parte que é bem crítica ali do sistema, você ainda quer talvez ir mais na mão, fazer 1 coisa mais assistida com a IA e 1 pouco passar mais tempo ali, mas no geral, mesmo pra coisa muito pequena, escrever o código em si não está acontecendo isso pra maioria das pessoas, tá?
Obviamente que nem tudo são flores, e e tem vários desafios que a empresa precisa passar pra conseguir chegar nesse nível em maturidade mais alta. A empresa ali começou muito aberta, foi muito legal lá pro começo do meio do ano passado mais ou menos, começouse a a querer usar AI, todo mundo queria usar, podia usar qualquer coisa kitHub, tudo essas coisas. Eventualmente a gente conseguiu padronizar, que eu acho que esse é 1 dos dos maiores desafios, e a padronização é interessante, por mais que nem todo mundo goste de cursor nem que não gosta de cloud, você ter 1 ferramenta facilita muito a o treinamento e todo mundo seguir 1 o mesmo fluxo, de 1 forma mais fluida, né?
Segurança, homologação, isso aqui também é 1 1 preocupação, e então tem 1 processo todo ali a gente foi entre as ferramentas acabou homologando o notion, o cursor, o Slack, o Lineer, é porque eles têm soc 2 né, eles têm todo as os padrões de segurança que enterprise exige, então foi 1 processo interessante.
O volume e revisão aqui está sendo gerado muito mais coisas com o AI obviamente, tem muito mais texto pra ler, tem muito mais coisas pra acontecendo em paralelo, então existe 1 adaptação ali, e tem que ter mudanças agressivas no processo. Não adianta mudar só 1 negocinho provavelmente não vai fazer efeito, tem que ser mais radical ali na mudança igual a gente eu estava comentando a gente tirou nosso processo de 7 Sato's pra 3, né? Então esse tipo de coisa tem que acontecer.
E obviamente, os deadlines estão mais agressivos, a expectativa é que entregue mais rápido, então o fluxo de ponta a ponta tem que ser mais eficiente, não adianta só os devs serem mais eficientes, todo mundo tem que acabar sendo mais eficiente. Então por isso que é interessante a empresa ser e e first não só o departamento de engenharia né que é o que cabe com o que o Felipe estava falando anteriormente né? Tem tem muito mais coisa acontecendo além da do time de engenharia.
É como o Valer falou, eu faço parte do levante com o pessoal, que a gente tá bem focado em, em fluxos do dia a dia e coisa e tal.
Está sendo 1 experiência bem bacana. Eu valorizo muito essa troca de experiência e saber como as pessoas estão resolvendo os meus problemas e os mesmos desafios que a gente tem.
Então está bem bacana.
Convido todos a já fazer o Jabá antecipado, né? A participarem é bem legal conhecer e entender o quantas pessoas estão tão fazendo.
Tem gente de tudo quanto é lado ali então essa troca ela é muito muito rica.
Finalizando, dicas pra quem está aí, começa hoje, não deixa nem pra segundafeira, começa hoje, né? Tenha 1 time que evangelize isso na sua empresa, tenha pessoas que incentivam as outras, invista em treinamento e tente criar pra todo mundo e transcende só você, né? Obviamente isso faz parte dos desafios, mas essas dicas são principais aí pra quem ainda não tá fazendo, faça porque essa outra fase de paga é interessante que sei lá de onde o Cláudio tirou mas é o que está acontecendo isso vem de business também a pergunta é mais se é possível fazer alguma coisa é o quão rápido você vai entregar tal coisa né?
Então fica aí a, a experiência, se quem quiser conversar mais me encontra na comunidade, também pode conectar ali no no LinkedIn.
Talvez de compartilhar os slides também se vocês quiserem dar 1 olhada depois, mas é isso. Acho que foi 1 pouquinho acima do tempo, eu vou demorar mais.


> 🔗 **Links:** [#6 Slides do case (Geovani)](https://tlc-workshop-ai.giovannymassuia.io/?slide=9) · [#7 Cursor](https://www.cursor.com/) · [#8 Linear](https://linear.app/) · [#9 Notion](https://www.notion.so/) · [#10 Slack](https://slack.com/) · [#1 Formação Elevate (TLC)](https://github.com/tech-leads-club/awesome-tech-lead)