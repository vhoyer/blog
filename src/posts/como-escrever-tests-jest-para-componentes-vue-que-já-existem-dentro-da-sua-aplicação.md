---
title: Como escrever tests (jest) para componentes (vue) que já existem dentro
  da sua aplicação
description: "Disclaimers: Além de tutorial o seguinte conteúdo é uma opnião
  minha e totalmente pessoal de como deixar seu código perfeitinho e bem
  organizado, siga por conta e risco. Ao escrever esse post eu estou assumindo
  que você sabe o que são testes unitários, sabe que testes são muito
  importantes para a saúde de uma code base, e sabe o que é o lance do
  Arange>Act>Assert"
author: Vinícius Hoyer
date: 2019-07-24T22:42:07.666Z
tags:
  - Tags
---
Repost from [dev.to](https://dev.to/vhoyer/como-escrever-tests-jest-para-componentes-vue-que-ja-existem-dentro-da-sua-aplicacao-2hhf) for historical reasons.

***

> Disclaimers:
> Além de tutorial o seguinte conteúdo é uma opnião minha e totalmente pessoal de como deixar seu código perfeitinho e bem organizado, siga por conta e risco. Ao escrever esse post eu estou assumindo que você sabe o que são testes unitários, sabe que testes são muito importantes para a saúde de uma _code base_, e sabe o que é o lance do Arange>Act>Assert

Para que todos estejam na mesma página durante a leitura, gostaria de exclarecer alguns termos que eu uso:
- componente: componente vue/react/web-componente/etc;
- elemento: elemento padrão do html, seja ele um elemento que está dentro ou fora de um elemento, ou de um documento .html.

Lendo esse post, acredito que você vai chegar à algumas conclusões sobre meus hábitos de teste, então para evitar o transtorno e tentar te ajudar a focar no que eu estou tentando dizer, eu gosto de:
- rodar os "_Arrange_" no `beforeEach` do primeiro `describe` e nos `beforeAll` quando necessários;
- rodar o "_Acts_" nos _befores_ da vida;
- agrupar todos os testes dentro de um describe "pai";
- agrupar interações do usuário dentro de describes.

Ok, suponhamos que você tenha o seguinte componente: 

```html
<template>
  <div
    ref="origin"
    class="button-link-selector"
  >
    <ButtonLink
      @click="openPopover"
      class="js-label"
    >
      {{ value.label }}
    </ButtonLink>

    <div
      v-if="isOpen"
      class="button-link-selector__background js-outside"
      @click="closePopover"
    />

    <div
      v-show="isOpen"
      class="button-link-selector__popover js-popover"
      :style="{ left: `${popoverX}px`, top: `${popoverY}px` }"
    >
      <Multiselect
        :allow-empty="false"
        :internal-search="false"
        :options="options"
        :value="value"
        deselect-label=""
        label="label"
        open-direction="bottom"
        placeholder="Selecione o campus"
        select-label=""
        selected-label=""
        track-by="id"
        @close="searchChange('')"
        @select="select"
      >
        <span slot="noResult">
          <span class="button-link-selector__no-result">
            Sem resultados para a pesquisa.
          </span>
        </span>
      </Multiselect>
    </div>
  </div>
</template>

<!--
  tô omitindo o style pq jest não testa css então
  não é importante pra esse contexto
-->

<script>
// this is a utility present on npm:
// https://www.npmjs.com/package/vue-prop-validation-helper
import {
  everyItemOfArrayShouldHave,
  objectShouldHave,
} from 'vue-prop-validation-helper';

// esse é um outro componente seu qualquer
import ButtonLink from '~/components/button-link';

// esse é um componente, também presente no npm:
// https://www.npmjs.com/package/vue-multiselect
import Multiselect from 'vue-multiselect';

export default {
  name: 'ButtonLinkSelector',
  components: {
    ButtonLink,
    Multiselect,
  },
  props: {
    options: {
      required: true,
      type: Array,
      validator: everyItemOfArrayShouldHave([
        'id',
        'label',
      ]),
    },
    value: {
      required: true,
      type: Object,
      validator: objectShouldHave([
        'id',
        'label',
      ]),
    },
  },
  data: () => ({
    isOpen: false,
    popoverX: 0,
    popoverY: 0,
  }),
  beforeDestroy() {
    document.removeEventListener('scroll', this.onWindowScroll);
  },
  methods: {
    closePopover() {
      this.isOpen = false;
    },
    openPopover() {
      this.isOpen = true;

      const boundings = this.$refs.origin.getBoundingClientRect();

      this.popoverX = boundings.x - 23;
      this.popoverY = boundings.y + 20;

      document.addEventListener('scroll', this.onWindowScroll);

      this.$nextTick(() => {
        this.$el.querySelector('.multiselect__input').focus();
      });
    },
    onWindowScroll() {
      this.closePopover();

      document.removeEventListener('scroll', this.onWindowScroll);
    },
    select(value) {
      this.closePopover();

      this.$emit('select', value);
    },
  },
};
</script>
```

Sendo totalmente opinativo, eu sempre começo pelo snapshot quando o componente já exite:

```js
import ButtonLinkSelector from '~/components/button-link-selector';
import { shallowMount } from '@vue/test-utils';

//para uso mais a frente no
const multiselectFocus = jest.fn();

describe('Components > ButtonLinkSelector', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallowMount(ButtonLinkSelector, {
      // só to fornecendo aqui o que o componente acima pede:
      propsData: {
        options: [
          { id: 0, label: 'minha mãe correu do boi' },
          { id: 1, label: 'minha vó correu do vô' },
          { id: 2, label: 'meu pai corre da mãe' },
          { id: 3, label: 'meu cachorro corre de mim' },
          { id: 4, label: 'eu corro de todo mundo' },
        ],
        value: {
          id: 0,
          label: 'minha mãe correu do boi',
        },
      },
    });
  });

  it('matches snapshot', () => {
    expect(wrapper.element).toMatchSnapshot();
  });
});

```

Depois eu digo que o comportamento padrão dele quando é montado, considerando as _props_ passadas para ele é mostrar o item selecionado (a.k.a.: `value`). No caso, estou passando aquele objeto pra ele:

```js
{
  id: 0,
  label: 'minha mãe correu do boi',
}
```

então, o valor que ele deve estar mostrando é:

```js
  it('displays selected item', () => {
    expect(wrapper.find('.js-label').text()).toBe('minha mãe correu do boi');
  });

```

Então eu começo a pensar nas interações que o usuário pode fazer com esse componente. Por exemplo, o usuário pode clicar na _label_ do componente:

```js
  describe('when user click in its label', () => {
    beforeEach(() => {
      wrapper.find('.js-label').vm.$emit('click');
    });
  });

```

Tá, beleza, mas quando o usuário clicar no componente, o que deve acontecer?

```js
    it('shows popover', () => {
      expect(wrapper.find('.js-popover').element).toBeVisible();
    });
```

Legal, então vamos rodar os tests. Ops, deu um errinho ali, porque ele não consegue encontrar aquela classe `.multiselect__input`, pois ela esta dentro do multiselect.

Existem dois jeitos, que eu conheço, de resolver isso. O primeiro é, ao invés de usar um `shallowMount` no componente, podemos usar um `mount`. Isso faz com que o `vue-test-utils` (que é a lib que te ajuda a testar _vue components_) renderize o componente que você esta pedindo pra montar; e todos os seus descendentes, que também são componentes, e todos os descendentes desses também, e assim por diante. Isso faz com que seus testes sejam mais pesados e demorem mais pra rodar. Por isso essa não é minha abordagem preferida. Eu prefiro o famoso e famigerado _mock_:

```js
  describe('when user click in its label', () => {
    beforeEach(() => {
      //mock multiselect
      wrapper.vm.$el.querySelector = jest.fn(() => ({ focus: multiselectFocus }));
      // p.s.: eu disse que o multiselectFocus ia voltar a aparecer, né? ta ele aí.

      wrapper.find('.js-label').vm.$emit('click');
    });
  });

```

Se você olhar a implementação do componente, vai ver que ele tenta procurar um elemento de classe `.multiselect__input` dentro do `this.$el` (que se refere à _root_ do seu componente, o único nó filho da tag `<template>` dentro do seu arquivo `*.vue`).

Só que, como o `multiselect` não está sendo renderizado pelo `vue-test-utils`, é de se esperar que o `querySelector` não consiga achar esse elemento mesmo. Então a gente mocka o query selector.

Agora podemos testar livremente. O teste passa e não aparece nenhum _warn_ no console. Seguindo em frente, o que deve acontecer quando o usuário clica na _label_ do componente?


```js
    it("focus on multiselect's input", () => {
      expect(multiselectFocus).toHaveBeenCalled();
    });
```

Vamos lá, a outra interação possível, agora que o _popover_ está aberto, é que o usuário pode clicar para fora do componente:

```js
    describe('when user clicks outside the popover', () => {
      beforeEach(() => {
        wrapper.find('.js-outside').element.click();
      });

      it('closes popover', () => {
        expect(wrapper.find('.js-popover').element).not.toBeVisible();
      });
    });
```

O usuário também, ao invés de fechar, pode selecionar um item através do `vue-multiselect` e como se espera que o `<Multiselect>` já esteja sendo bem testado nos arquivos de teste dele, podemos, teóricamente, confiar no que ele está fazendo. Então, quando um usuário seleciona um item dentro do _multiselect_, esse componente envia um evento `select`, e isso também pode simular isso também.

E quando o _multiselect_ emite esse evento, o que o nosso `ButtonLinkSelector` deve fazer é (_drum rolls_) ..... enviar outro evento!!

```js
    describe('when user selects another item through Multiselect', () => {
      beforeEach(() => {
        wrapper.find(Multiselect).vm.$emit('select', {
          id: 1,
          label: 'minha vó correu do vô',
        });
      });

      it('emits the select event once with the received payload', () => {
        // só emitiu uma vez
        expect(wrapper.emitted('select').length).toBe(1);

        // o primeiro argumento da primeira, e nesse caso, única
        // vez que esse evento foi disparado, é:
        expect(wrapper.emitted('select')[0][0]).toEqual({
          id: 1,
          label: 'minha vó correu do vô',
        });
      });
    });
  });

```

Outra interação que pode acontecer é: o usuário pode scrollar a página e se isso acontecer enquanto o popover estiver aberto, esse deve fechar. Mas como eu simulo um scroll dentro do jest? Você pode mockar o `addEventlistener` para ele expor o _callback_ que o componente passa pra essa função, fazendo com que você consiga chamá-lo.

Mas como _mockar_ o `addEventListener` dentro desse `describe` se evento de click, que chama o `addEventListener`, roda antes de chegar nesse describe (no 'when user click in its label')? Simples, você mocka o `addEventListener` no `beforeAll`, que vai rodar antes de qualquer `beforeEach` (até mesmo do primeiro, que monta o componente).

Outra coisa que tem que acontecer é: se o evento foi definido, o scroll listener deve ser removido, porque ele não é mais necessário. Então, o resultado final dessa interação é a seguinte:

```js
    describe('when user scrolls page', () => {
      let userScrolledPage;

      beforeAll(() => {
        document.removeEventListener = jest.fn();

        document.addEventListener = jest.fn((_event, callback) => {
          userScrolledPage = callback;
        });
      });

      beforeEach(() => {
        userScrolledPage();
      });

      it('hides popover', () => {
        expect(wrapper.find('.js-popover').element).not.toBeVisible();
      });

      it('removes scroll listener', () => {
        expect(document.removeEventListener)
          .toBeCalledWith('scroll', expect.any(Function));
      });
    });
```

Para terminar, e o _coverage_ ficar bonitinho, se o componente estiver com o _popover_ aberto e o componente for destruído, o _listener_ de _scroll_ tem que ser removido porque ele não estaria servindo pra nada.

```js
  describe('when component is destroyed', () => {
    beforeAll(() => {
      document.removeEventListener = jest.fn();
    });

    beforeEach(() => {
      wrapper.destroy();
    });

    it('removes scroll listener', () => {
      expect(document.removeEventListener)
        .toBeCalledWith('scroll', expect.any(Function));
    });
  });
```

Então, pronto. Os testes para esse componente estão concluídos num piscar de olhos. Segue o resultado final, o arquivo do jest:

```js
import ButtonLinkSelector from '~/components/button-link-selector';
import Multiselect from 'vue-multiselect';
import { shallowMount } from '@vue/test-utils';

const multiselectFocus = jest.fn();

describe('Components > ButtonLinkSelector', () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallowMount(ButtonLinkSelector, {
      propsData: {
        options: [
          { id: 0, label: 'minha mãe correu do boi' },
          { id: 1, label: 'minha vó correu do vô' },
          { id: 2, label: 'meu pai corre da mãe' },
          { id: 3, label: 'meu cachorro corre de mim' },
          { id: 4, label: 'eu corro de todo mundo' },
        ],
        value: {
          id: 0,
          label: 'minha mãe correu do boi',
        },
      },
    });
  });

  it('matches snapshot', () => {
    expect(wrapper.element).toMatchSnapshot();
  });

  it('displays selected item', () => {
    expect(wrapper.find('.js-label').text()).toBe('minha mãe correu do boi');
  });

  it('does not show popover', () => {
    expect(wrapper.find('.js-popover').element).not.toBeVisible();
  });

  describe('when user click in its label', () => {
    beforeEach(() => {
      //mock multiselect
      wrapper.vm.$el.querySelector = jest.fn(() => ({ focus: multiselectFocus }));

      wrapper.find('.js-label').vm.$emit('click');
    });

    it('shows popover', () => {
      expect(wrapper.find('.js-popover').element).toBeVisible();
    });

    it('focus on multiselect\'s input', () => {
      expect(multiselectFocus).toHaveBeenCalled();
    });

    describe('when user clicks outside the popover', () => {
      beforeEach(() => {
        wrapper.find('.js-outside').element.click();
      });

      it('closes popover', () => {
        expect(wrapper.find('.js-popover').element).not.toBeVisible();
      });
    });

    describe('when user selects another item through Multiselect', () => {
      beforeEach(() => {
        wrapper.find(Multiselect).vm.$emit('select', {
          id: 1,
          label: 'minha vó correu do vô',
        });
      });

      it('emits the select event once with the received payload', () => {
        expect(wrapper.emitted('select').length).toBe(1);

        expect(wrapper.emitted('select')[0][0]).toEqual({
          id: 1,
          label: 'minha vó correu do vô',
        });
      });
    });

    describe('when user scrolls page', () => {
      let userScrolledPage;

      beforeAll(() => {
        document.removeEventListener = jest.fn();

        document.addEventListener = jest.fn((_event, callback) => {
          userScrolledPage = callback;
        });
      });

      beforeEach(() => {
        userScrolledPage();
      });

      it('hides popover', () => {
        expect(wrapper.find('.js-popover').element).not.toBeVisible();
      });

      it('removes scroll listener', () => {
        expect(document.removeEventListener)
          .toBeCalledWith('scroll', expect.any(Function));
      });
    });
  });

  describe('when component is destroyed', () => {
    beforeAll(() => {
      document.removeEventListener = jest.fn();
    });

    beforeEach(() => {
      wrapper.destroy();
    });

    it('removes scroll listener', () => {
      expect(document.removeEventListener)
        .toBeCalledWith('scroll', expect.any(Function));
    });
  });
});
```

Isso é tudo pessoal, espero que tenha ajudado você a ter seu _Pull Request_ aprovado por aquele seu colega chato que está te cobrando testes (eu). Qualquer coisa, comenta aí embaixo para criar uma discussão legal 😊.