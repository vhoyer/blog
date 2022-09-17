---
isDraft: false
lang: pt-BR
title: Como eu estudei Kanji
description: RTK, SRS (Anki), Koohii, mnemônicos e o bom e velho papel e caneta,
  tudo que eu fiz pra dizer que eu "estudei kanji", espero ajudar
author: Vinícius Hoyer
date: 2022-09-17T16:46:28.549Z
tags:
  - Language Learning
  - japanese
  - kanji
---
Primeira coisa é que esse processo inteiro é bastante baseado no trabalho do James Heisig no livro RTK (_Remembering the Kanji_), que é um processo que pessoalmente eu comprei a ideia e gostei do resultado.

## O método

Eu acho que você precisa comprar o livro? Não, pessoalmente não acho, você pode, e tem [esse link na Amazon pra comprar o RTK][amazon-rtk], mas tudo que você precisa pra entender o processo que esse livro te ensina, você consegue ler no "da uma olhadinha" da Amazon que te deixa ver o preview do livro, você consegue ler as primeiras páginas, e é nelas que o Heisig ensina o método.

[amazon-rtk]: https://www.amazon.com.br/Remembering-Kanji-Complete-Japanese-Characters/dp/0824835921

Depois que você entendeu o método, você consegue ter acesso a lista e a ordem que o Heisig desenvolveu em outros lugares na internet, como o [Kanji Koohii][kanji-koohii], [o site do hochanh][hochanh], o RTK tem aplicativos oficiais (pagos, mas bem mais baratos que o livro) para [iOS][astore-rtk] e [Android][gplay-rtk], e se precisar, eu fiz esse [backup da lista de kanji][vhoyer-rtk], esse último que inclusive esta num formato ótimo pra ser importado no [Anki][anki], se você for usar.

[kanji-koohii]: https://kanji.koohii.com/
[hochanh]: https://hochanh.github.io/rtk/rtk1-v6/index.html
[gplay-rtk]: https://play.google.com/store/apps/details?id=com.mirai.rtk&hl=pt_BR&gl=US
[astore-rtk]: https://apps.apple.com/us/app/remembering-the-kanji/id424471278
[vhoyer-rtk]: https://github.com/vhoyer/anki-utils/blob/master/rtk-extractor/output.tsv
[anki]: https://apps.ankiweb.net/

Dito isso, se você precisar muito do livro em si, e outras formas de adquirir o livro não forem uma opção por qualquer motivo, a gente sempre (espero) tem [o RTK na z-library][zlib-rtk], que é esse projeto pra manter uma coleção de fácil acesso sobre publicações de interesse público como livros e publicações acadêmicas.

[zlib-rtk]: https://b-ok.lat/book/889250/889b8e
[wiki-zlib]: https://pt.wikipedia.org/wiki/Z-Library

Kanji Koohii é um site que você precisa logar, mas é gratuito e oferece toda uma interface e uma comunidade que ta imersa em passar por esse processo com você, então pode ser uma ótima opção pra você.

Eu recomendo dar uma olhada nesse material e se você tiver acesso ao livro inteiro, você ganha acesso aos comentários do Heisig que são bem úteis também, mas se você usar um dicionário junto com a lista de kanji, esses comentários não necessários, continuam interessantes, mas não necessários.

Se você não vai conseguir ter acesso ao livro de jeito nenhum, a ideia principal do método é: o nosso cérebro lembra melhor das coisas, se a gente usar a imaginação visual, então a ideia é inventar histórias e imagens mentais sobre os kanji e isso vai te dar um super poder em decorar as coisa. Outra coisa que o RTK fornece é uma única palavra (chamada de _keyword_ ou palavra chave) que correlaciona bem com o significado do kanji pra você lembrar, então sempre que você ver um kanji, você vai lembrar dessa palavra e sempre que você precisar lembrar de como que um kanji é escrito, você pode lembrar dessa palavra, e essa palavra vai te lembrar a história que você inventou, e a história vai te lembrar como que escreve o kanji. Essa lista de palavras pelo RTK esta em inglês, mas exitem na internet por ai pessoas que fizeram traduções não oficiais dessa lista e você pode procurar por ai.

Essas histórias inventadas sobre os kanji apoiam-se fortemente na técnica de [mnemônica][mnemonic].

[mnemonic]: https://pt.wikipedia.org/wiki/Mnem%C3%B3nica

## _Spaced Repetition System_ (SRS)

_Spaced repetition system_ (SRS), ou [sistema de repetição espaçada][wki-srs], é uma ideia que defende que a gente lembra melhor as coisas se a gente tiver um lembrete logo antes da gente esquecer de algo. A maioria das implementações dessa ideia usam o formato de [_flashcards_ (link em Inglês)][wiki-flashcards] que é basicamente um lado você apresenta algo que deve servir como gatilho, e do outro lado você coloca o que precisa ser lembrado dado o gatilho.

[wiki-srs]: https://pt.wikipedia.org/wiki/Repeti%C3%A7%C3%A3o_espa%C3%A7ada
[wiki-flashcards]: https://en.wikipedia.org/wiki/Flashcard

Quando a gente junta esses dois sistemas, o processo parece algo do tipo: pega um flashcard e olha o lado da frente, tenta lembrar o que tem atrás. Se você lembrar corretamente, você considera esse card "bom", e agenda esse cartão para ser revisado em, por exemplo, uma semana, se você não lembrar dele, considera ele "ruim", coloca ele no final da sua pilha de cartões do dia, da próxima vez que você pega ele no final da pilha, você olha, se você lembrar, agenda ele para o dia seguinte, se não, continua o processo até não ter nenhum card na sua pilha dos cards do dia.

Como pode parecer fazer esse trabalho manualmente, é um trabalho por si só. Por isso, eu quero acreditar que a maior parte das pessoas que usam esse tipo de sistema, usam ele por meio de aplicativos, e um dos mais famosos é o [Anki][anki]. Pessoalmente eu gosto muito do Anki, ele é gratuito, altamente customizável, sincroniza entre vários dispositivos, tem uma comunidade bem grande pra tirar duvidas, fornecer plugins, e decks (como o Anki chama conjuntos de flashcards) prontos.

### RTK no Anki

Para usar o RTK junto com o Anki da forma mais básica possível é bem fácil, crie um deck, coloque a palavra chave na frente do card, coloque o kanji atras junto com sua história (possivelmente com a lista de partículas também), e a cada kanji que você for estudar, você cria um card pra ele, e começa a estudar depois.

Eu começaria a estudar com cinco cartões novos por dia e 999 cartões para revisar, e depois de uma ou duas semanas, troca para dois cartões novos por dia para não aumentar infinito o tempo que leva pra você revisar todos os cartões do dia. A ideia de usar 999 cartões para revisar no Anki é que por padrão esse numero é tipo, 50 ou algo do tipo, mas se você quiser usar o potencial inteiro do SRS, não faz muito sentido você deixar de ver algum cartão só porque passou do limite de review diário.

Essas são algumas das configurações que eu recomendo usar, mas aqui segue [um deck já configurado com as minhas recomendações][anki-rkt-deck] e as fontes que mostram os kanji com a ordem dos traços e algumas das fontes mais comuns que você vai ver por ai, já tem todos os kanji adicionados na ordem correta feito pra você só importar o deck no Anki, e começar a usar.

[anki-rkt-deck]: https://drive.google.com/file/d/1WMZrUN4aUW9azJpgZX4vTmtMVoWKykAn/view?usp=sharing

A única coisa que você vai precisar fazer nesse deck, é criar suas próprias histórias, eu acho importante que você crie suas próprias histórias por que quanto mais pessoais são as histórias mais fácil é pra você lembrar depois.

Pra você escrever as histórias eu recomendo que você pelo menos de uma lida em algumas das histórias que a comunidade do Kanji Koohii escreve, principalmente nos seus primeiros kanji, e especialmente se você não estiver acompanhando com o livro original.

Além disso, enquanto usando esse deck que eu fiz, é importante que, no Anki, você só aperte os botões bom/good/verde e bad/ruim/vermelho. [Isso faz com que o algorítimo de espaçamento do Anki funcione melhor segundo o site refold.la][refoldla-anki].

[refoldla-anki]: https://refold.la/roadmap/stage-1/a/anki-setup

### RTK no Kanji Koohii

Além da lista de kanji, e as histórias publicas dos usuários do Kanji Koohii, ele também oferece um sistema integrado de SRS pra estudar o RTK, pessoalmente, nunca usei, então não sei muito o que falar sobre além de: tem muita gente que usa, e me parece um programa bem bom.

## Um passo além dos flashcards

Além dos flashcards, o que eu fiz por muito tempo foi para cada revisão feita, eu escreveria num caderno com uma caneta mesmo o kanji que eu tava tentando lembrar, e eu só marcaria o cartão como "bom" se eu tivesse acertado como escreve o kanji. Da pra ver na [conta de Instagram que eu fiz pra postar em japonês][insta-vhoyaa] algumas dessas páginas nas postagens lá.

[insta-vhoyaa]: https://www.instagram.com/vhoyaa/

## Conclusão

Esse é um processo que eu fiz por uns seis meses quase todo dia, essa era uma das primeiras coisas que eu fazia de manhã e em alguns dias mais pro final da minha jornada, eu cheguei a levar coisa de umas duas horas para terminar minha "pilha de cartões" do dia no Anki enquanto escrevia os kanji. Eu passei por 1541/2200 kanji no RTK, esses 1500 kanji não estavam marcados no Anki como aprendidos, mas sim como "vistos", por muito tempo eu fiz essa rotina com dez cartões novos por dia, e por isso que eu recomendo dois cartões novos por dia, porque isso vai reduzir consideravelmente o tempo que você leva pra terminar os cartões do dia, mas também vai aumentar o tempo que te leva pra terminar o livro todo via RTK.

Esse processo do primeiro livro do RTK só passa pela identificação do significado do kanji, esse é um processo que existem pra deixar mais fácil de você reconhecer kanji nas palavras, e ficar mais fácil de associar eles a suas leituras quando você encontra eles no meio das palavras. É bastante contra produtivo você tentar decorar todos os significados e leituras de um kanji pra dizer que você "aprendeu" eles, por isso esse método propões essa técnica pra deixar-nos mais familiarizados com a escrita e mais fácil de "ingerir" as palavras conforme você encontra elas _"out in the wild"_ em textos nativos.

Aprender uma linguagem é um processo longo, poliglotas famosos, que são bons em estudar linguagem, estimam que leva de 6 a 18 meses de aprendizado (dependendo muito do tempo dedicado) e se você perguntar para qualquer um deles, eu imagino que eles vão dizer a mesma coisa que o aprendizado de uma língua é algo que nunca acaba, e é uma imersão na cultura do povo que fala ela, eu estudo de forma completamente indisciplinada japonês há oito anos já e me considero "um iniciante avançado", se é que essa categoria existe, o que eu tô querendo dizer com esse ultimo paragrafo é, não desista, pode demorar mais tempo do que você imagina.
