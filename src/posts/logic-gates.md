---
title: Logic Gates
description: Esse é um projeto que eu fiz para a faculdade, porque não compartilhar, né?
author: Vinícius Hoyer
date: 2019-03-31T22:24:14.477Z
tags:
  - Tags
---
Esse é um repost do texto que eu postei originalmente no [medium](https://medium.com/@vhoyer/logic-gates-c0d5032fc5ac), estou repostando aqui por motivos históricos.

***

***1. Introdução***

Todo computador é composto de portas lógicas, ou, *logic gates*, será descrito o funcionamento e construção lógica com transistores das portas AND, OR, XOR, e NOT.

***2. Funcionamento***

A porta OR pode ser construída usando dois transistores em paralelo, com ambos os coletores com corrente, com suas saídas juntas conectadas a saída da porta, e suas bases conectadas cada uma a uma de suas entradas, assim, quando qualquer das entradas estiverem com ligadas, a saída também estará, e quando nenhuma estiver ligada, nenhum dos transistores vai permitir a corrente a fluir então estará desligado\[1].

Já a porta AND, diferente da porta OR, pode ser construída com dois transistores em sequência, sendo que o coletor do primeiro tem sempre corrente e seu emissor é conectado ao coletor do segundo e o emissor do segundo é conectado à saída da porta lógica, assim, a saída só estará ligada, quando suas duas entradas, as quais são conectadas nas bases dos dois transistores, permitirem que a corrente passe pelos dois transistores até a saída\[1].

Já uma porta NOT pode ser construída usando um transistor no qual a saída da porta está emitindo corrente por padrão mas na ramificação da saída, existe um transistor cuja base é controlada pela entrada dessa porta lógica, se o transistor estiver permitindo a passagem de corrente, ao invés de a corrente ir para a saída ela segue o transistor e vai para o terra\[2] como na figura 3.

E uma porta XOR, nada mais é que a junção dessas três portas, como evidenciado na figura 4, na qual as entradas da porta XOR são ligadas tanto numa porta OR quanto numa NAND (que nada mais é que uma porta AND com uma NOT depois dela) e a saída dessas duas portas lógicas são ligadas à uma outra porta AND cuja saída é a saída da porta XOR\[1].

O interessante é ver que a definição da porta XOR bate com o projeto, sendo uma porta lógica que permite a passagem da corrente quando a entrada A ou a entrada B estão ligadas, mas não quando as duas estão ligadas.

***3. Ilustrações***

![Image for post](https://miro.medium.com/max/30/0*IT7YVgcPRPsi4iuL?q=20)

![Image for post](https://miro.medium.com/max/1600/0*IT7YVgcPRPsi4iuL)

Figura 1 — diagrama ilustrativo de uma porta lógica OR\[1].

![Image for post](https://miro.medium.com/max/30/0*ll3615PwUeBQUSlo?q=20)

![Image for post](https://miro.medium.com/max/1600/0*ll3615PwUeBQUSlo)

Figura 2 — diagrama ilustrativo de uma porta lógica AND\[1].

![Image for post](https://miro.medium.com/max/30/0*0GI46iP57gs8rJvG?q=20)

![Image for post](https://miro.medium.com/max/559/0*0GI46iP57gs8rJvG)

Figura 3 — projeto lógico de uma porta lógica NOT\[2].

![Image for post](https://miro.medium.com/max/30/0*yx3dPsXuxtsupvf6?q=20)

![Image for post](https://miro.medium.com/max/316/0*yx3dPsXuxtsupvf6)

Figura 4 — projeto lógico de uma porta lógica XOR\[1].

***4. Conclusões***

Após essa jornada espero que você tenha aprendido algo novo hoje, já se pode colocar isso na lista do Today I Learned. Também espero não ter explicado nada de maneira errônea, mas caso tenha dúvidas, aposto que tu podes se referir aos dois vídeos nas referencias.

***5. Referências***

\[1]<https://www.youtube.com/watch?v=VBDoT8o4q00>\[2]<https://www.youtube.com/watch?v=dd4Ni-SFKX4>

Todas as imágens foram tiradas desses dois vídeos, não tenho direito algum sobre as mesmas, foram prints tirados desses vídeos.