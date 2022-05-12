---
isDraft: true
lang: en
title: "Magic Numbers: how to discern between the good and the bad"
description: ...
author: Vinícius Hoyer
date: 2022-05-12T20:22:38.441Z
tags:
  - Tech
  - Code Review
---
[gabriel.gomes](https://app.slack.com/team/U01JEACQBS5)  [16:11](https://queroedu.slack.com/archives/D02FHP11ESH/p1652382715507709)

Cara, aquele banner lá da IES Page, pra centralizar eu botei uma utilit do zilla mesmo (z-mx-auto), só que pra conter o banner eu usei um max-width: 800px (que é o que tá no sketch). Só que esse 800px é meio que um magic number né? Ou não? Teria uma forma melhor de definir isso?



[vinicius.hoyer](https://app.slack.com/team/UCX9KSKNJ)

ótimo *spotado* ao pensar que isso é um magic number, é mesmo, mas as vezes a gente vai precisar usar esses magic numbers porque as vezes eles só são magic numbers mesmo, esse é um tamanho específico que o design criou e ele queria que aquele componente tivesse esse tamanho.

Tipo, magic numbers são números que saem do nada, eles não tem um porque e isso geralmente é um problema.

A chave de você saber se um magic number é ruim ou não é você pensar nesse "porque" do número, num handoff do design as coisas sempre tem um porque, o designer pode nem perceber na hora, mas todo espaçamento e tamanho das coisas no design que ele faz é por um motivo. O seu trampo como um bom front-end que sabe implementar os designs que são passados pra você é você conseguir desenterrar esse "porque" a partir do sketch da vida.(numeros aleatórios só pra servir um exemplo)

porque que esses input tem 321px?\
-> porque eles estão dividindo 1/4 do espaço pq essa linha ta dividida em 4 partes, 3 pra input e um pro botão de submit\
--> a maior pista nesse caso é que `321` não é um número muito natural pra você inventar ele, né?, é bem diferente desse 800px do `max-width` do banner, quando cê ve um número fechadinho assim, deve ser porque alguém digitou eles na mão

porque que esse paragrafo tem 114px de altura?\
-> porque ele na vdd tem o tamanho que ele precisar, ele ta expandindo verticalmente de acordo com o texto que tem dentro dele

porque que essa imagem tem altura de 80px e width de 125px?\
-> porque o designer quis que ela ocupasse 80px de altura, e ela ta ocupando 125px de width só pq esse é o aspec-ratio da imagem, e ela pra ela ocupar o maior espaço possível numa altura de 80px ela precisa de 125px de width

e por ai vai