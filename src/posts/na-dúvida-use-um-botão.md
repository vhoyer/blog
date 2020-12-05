---
lang: pt-BR
title: Na dúvida, use um botão
description: Um básico sobre acessibilidade
author: Vinícius Hoyer
date: 2019-07-18T22:28:39.476Z
tags:
  - Portuguese
  - Tech
  - Accessibility
---
Repost from [dev.to](https://dev.to/vhoyer/na-duvida-use-um-botao-32gj), for historical reasons.

---

Tá, eu entendo você dizer que acessibilidade é difícil, é mesmo, mas eu acho que, mesmo sendo difícil, a gente tem que se atentar a isso, pois estamos fazendo com que informações não possam ser consumidas por certas pessoas; e porque você não quer que essas pessoas costumam seu conteúdo? Tu é preconceituoso, é? Eu espero que não 😅.

Então devemos sempre tentar dar o nosso máximo para deixar nossos sites o mais acessível que conseguirmos. Motivado por isso venho aqui aplicar todos os meus conhecimentos para tentar te ensinar a fazer um botão acessível!

## Eu tenho esse botão aqui, como eu deixo ele acessível?

```html
<style>
.my-button {
  outline: none;
  background: hsl(80deg, 50%, 50%);
  color: white;
  display: inline-block;
  padding: 4px 16px;
}
.my-button:hover {
  background: hsl(80deg, 50%, 30%);
}
.my-button:active {
  background: hsl(80deg, 50%, 60%);
}
</style>
<div class="my-button">
  Click me
</div>
<script>
document.querySelector(".my-button").addEventListener('click', () => alert("poke!"))
</script>
```

> Antes de qualquer coisa, eu queria só dar o _disclaimer_ de que o botão não é feio, você que não entende a sutil arte por traz do design dele, a arte de: escrever-o-código-chutando-números-e-só-ver-o-resultado-depois-de-terminar-de-escrever-seu-post, pode usar essa técnica, a licença dela é MIT.


### Antes de tudo!

Ih, rapaz, olha, é considerada **péssima** prática colocar `outline: none`. Se você não pode evitar, converse com o responsável por não deixar você tirar o `none` do `outline` no elemento, para essa pessoa achar um substituto bom o suficiente, com um contraste legal pra você colocar no lugar 😉.

```diff
@@ -1,6 +1,5 @@
 <style>
 .my-button {
-  outline: none;
   background: hsl(80deg, 50%, 50%);
   color: white;
   display: inline-block;
```

### Primeira coisa

O primeiro problema que eu noto é que: se o usuário estiver navegando no seu site exclusivamente com o teclado — seja por paralisia, braço quebrado ou porque ele tá segurando um sanduíche com a outra mão — esse usuário não vai conseguir apertar esse botão, porque ele não é _focável_. Tenta você selecionar esse botão só com <kbd>Tab</kbd>.

Para resolver esse problema, você pode definir explicitamente no HTML que o `.my-button` é focável com: `tabindex="0"`. O tal do [tabindex](https://developer.mozilla.org/pt-BR/docs/Web/HTML/Global_attributes/tabindex), com valor 0, serve pra dizer pro _browser_ que esse elemento pode **sim** ser focado, independentemente de qual _tag_ que você está usando.

```diff
@@ -11,6 +11,6 @@
   background: hsl(80deg, 50%, 60%);
 }
 </style>
-<div class="my-button">
+<div class="my-button" tabindex="0">
   Click me
 </div>
```

### Segunda coisa

Quando o leitor de tela estiver lendo esse elemento (agora que ele é focável), ele vai ler algo como "Click me, generic container", as vezes só "Click me". O porquê disso é que o elemento por traz desse botão é uma `div`, a técnica que da para a gente usar para contornar esse problema pode ser a seguinte:

```diff
@@ -11,6 +11,6 @@
   background: hsl(80deg, 50%, 60%);
 }
 </style>
-<div class="my-button" tabindex="0">
+<div class="my-button" tabindex="0" role="button">
   Click me
 </div>
```
Agora com o [atributo `role`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles/button_role) o leitor de tela consegue saber que essa `div`, na verdade, está cumprindo papel de botão e então vai ler: "Click me, button".

### Terceira coisa

Quando você coloca um `onClick` _handler_ na `div`, esse vai ser disparado quando um usuário clicar nele, mas se o usuário não estiver usando um mouse, ele vai esperar que a ação desse botão — que foi focado usando <kbd>Tab</kbd> — seja disparado usando uma das seguintes teclas:

- <kbd>Enter</kbd>
- <kbd>Espaço</kbd>

São expectativas que tem que ser cumpridas, caso contrario, o sistema pode se tornar impossível de ser utilizado. Então para corrigir isso a gente vai ter que disparar a ação desse botão no `keydown` dele:


```diff
@@ -17,5 +17,13 @@
   Click me
 </div>
 <script>
-document.querySelector(".my-button").addEventListener(() => alert("poke!"))
+const myButtonAction = () => alert("poke!")
+const myButton = document.querySelector(".my-button")
+
+myButton.addEventListener('click', myButtonAction)
+myButton.addEventListener('keydown', (event) => {
+  if (["Enter", " ", "Spacebar" /*ie11*/].includes(event.key)) {
+    event.preventDefault() // para evitar que a página seja scrollada (spacebar)
+    myButtonAction()
+  }
+})
 </script>
```

Tem uma página da WAI-ARIA, que lista todos os comportamentos que um dado elemento, seja ele um _button_, _checkbox_, _slider_, _list_, _toolbars_, e etc; devem cumprir para ir de encontro com a expectativa de um dado usuário, a [WCAG 1.1 authoring practices](https://www.w3.org/TR/wai-aria-practices-1.1), é um documento de 1999 que foi revisado diversas vezes, e acredito que continua, a WAI-ARIA já lançou um WCAG 2.0 e um WCAG 2.1, mas eles não necessariamente são melhores que o 1.1, pessoalmente eu acho que o 1.1 é melhor organizado.

Pra quem olha esses documentos com cara de especificação e tem um troço, existe esse outro site que é o [WebAIM: WCAG 2 Checklist](https://webaim.org/standards/wcag/checklist), que transforma o WCAG em algo mais amigável, apresentando seus critérios em forma de checklist.

Mesmo assim, na minha humilde opinião, o lugar mais fácil, estruturado, e completo, para se achar essas informações é o [MDN](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles), que acabei de descobrir que da exatamente o mesmo exemplo que eu to dando agora! Cara, MDN é incrível.

### No final a gente fica com isso:

```html
<style>
.my-button {
  background: hsl(80deg, 50%, 50%);
  color: white;
  display: inline;
  padding: 4px 16px;
}
.my-button:hover {
  background: hsl(80deg, 50%, 30%);
}
.my-button:active {
  background: hsl(80deg, 50%, 60%);
}
</style>
<div class="my-button" tabindex="0" role="button">
  Click me
</div>
<script>
const myButtonAction = () => alert("poke!")
const myButton = document.querySelector(".my-button")

myButton.addEventListener('click', myButtonAction)
myButton.addEventListener('keydown', (event) => {
  if (["Enter", " ", "Spacebar" /*ie11*/].includes(event.key)) {
    event.preventDefault() // para evitar que a página seja scrollada (spacebar)
    myButtonAction()
  }
})
</script>
```

## Tá, mas isso parece muito complicado!

E é mesmo! Mas sabe outro jeito de fazer um botão acessível com tudo o que foi citado acima? Assim:

```html
<style>
.my-button {
  background: hsl(80deg, 50%, 50%);
  border: none;
  color: white;
  padding: 4px 16px;
}
.my-button:hover {
  background: hsl(80deg, 50%, 30%);
}
.my-button:active {
  background: hsl(80deg, 50%, 60%);
}
</style>
<button class="my-button">
  Click me
</button>
<script>
document.querySelector(".my-button").addEventListener('click', () => alert("poke!"))
</script>
```

Tem tudo o que o botão de `div` lá em cima tem, só que você não precisa fazer nada de mais, hehe. E o _diff_ final fica assim:

```diff
@@ -1,21 +1,20 @@
 <style>
 .my-button {
-  outline: none;
   background: hsl(80deg, 50%, 50%);
+  border: none;
   color: white;
-  display: inline-block;
   padding: 4px 16px;
 }
 .my-button:hover {
   background: hsl(80deg, 50%, 30%);
 }
 .my-button:active {
   background: hsl(80deg, 50%, 60%);
 }
 </style>
-<div class="my-button">
+<button class="my-button">
   Click me
-</div>
+</button>
 <script>
 document.querySelector(".my-button").addEventListener('click', () => alert("poke!"))
 </script>

```

## Mas e se eu usar um `<a>`?

Se a _tag_ não tiver um atributo `href` ele é considerado, praticamente, uma _div_, então todo o trabalho que deu pra transformar uma `<div>` num botão, vai ser o mesmo para fazer com uma _tag_ `<a>`.
