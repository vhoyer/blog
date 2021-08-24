---
lang: en
title: Functional components in Vue.js (2.x)
description: A little help for making basic stuff with functional components in
  vue, like running methods, where to find the listeners, classes and custom
  components inside the functional ones.
author: Vinícius Hoyer
date: 2019-08-30T22:38:57.603Z
tags:
  - Tech
  - Vue
---
Repost from [dev.to](https://dev.to/vhoyer/functional-components-in-vue-js-20fl) for historical reasons.

- - -

So, let's start from the beginning, what are functional components? Well, those are components that are more lightweight because they don't have any data, or computed, nor lifecycle events. They can be treated as just functions that are re-executed once the parameters passed down to it changes.

For more information you can read [the official docs for it](https://vuejs.org/v2/guide/render-function.html#Functional-Components), or this cool [blog post by Nora Brown](https://itnext.io/whats-the-deal-with-functional-components-in-vue-js-513a31eb72b0), or both. They also have a modified API, for reasons that I don't yet know, but now that I'm mentioning it, I got curious, so I might try checking it out afterwards.

But is it really that better? Honestly, I don't really know; I'm just trusting other people on this one. Since it doesn't have to manage reactivity it should be better, because its running less code to get the same results. But how much better? I don't know. I couldn't find an answer and I'm hoping someone will answer this question on the comments.

You know what? I'll tweet this post to the core team (aka [Sarah Drasner](https://sarah.dev/)), and we'll all hope together that we will get our answers, ok? :joy: :sweat_smile:

## The ugly parts of this

Ok, so functional components in vue are cool and all, but there are some problems with it, right? I mean, you could very well use the `render()` function to do it all and it be happy with it, because with the render function you can better organize your code.

> But the wall of learning this syntax when you are so used to the `<template>` is so high, let alone the fact that you'll be using this render function when everyone else on your project is used to the template, now we have two syntax in the project and its all your fault, you should be ashamed of yourself, you smarty pants.
> &mdash; read this very fast, for the aesthetics 😎

You could also try the React way and add to the project the JSX syntax of using html inside js, configuring webpack to understand this syntax, BUUUUT

> ...the wall of learning this syntax when you are so used to the `<template>` is **not so** high **compared to the other, but still**, let alone the fact that you'll be using this render function **with JSX** when everyone else on your project is used to the template, now we have two syntax in the project and its all your fault, you should be ashamed of yourself, you smarty pants.
> &mdash; read this very fast, for the aesthetics 😎

I know because I tried doing this (*cuz* I'm a smarty pants (is this slang still used? I learned this in the school :joy: (now I feel like I'm programming in lisp))) but my render function syntax didn't survived the code review.

So, we all hopefully agree that Vue is nice for the simplicity and we should stick with the template syntax because it's `s i m p l e r`. Now, if you have a team of smarty pants and you all like to work with template and render functions on the same project, then go ahead and be free, don't listen to me, ~~also, send me your recuiter's email~~.

- - -

That out of the way, I had some problems with functional components in Vue.js that I wanted to vent out here, and hopefully help anyone with the same problems:

* how on earth do you call a `method` from the template? Is it even possible?
* where are my props? And my `$listeners` and `$attrs`?
* why vue can't find my custom component inside the functional component despite it being registered with the `components` option?
* why the custom classes I put on the component from the outside don't get applied?

### Executing functions from the template

> "I received some data through props, but I want to format it nicely using a custom function. How do I do that? I'm getting an `undefined is not a function` error, I'll go crazy!"
> &mdash; Me before figuring it out

Consider the following `<script>` part of a component:

```html
<script>
export default {
  name: 'DisplayDate',
  props: {
    date: {
      type: String,
      required: true,
    },
  },
  methods: {
    format(date) {
      return new Date(date).toLocaleString()
    },
  },
}
</script>
```

For some reason, functional components don't have access to the vue instance, I suppose it's because there is no Vue instance to begin with, but I could be wrong. So, to access the methods we can't just:

```html
<template functional>
  <span>{{ format(date) }}</span>
</template>
```

We have to take another path, just `format` won't do, we have to do an `$options.methods.format(date)`. There, this works. It's ugly, but it works. Anyone has a suggestion to make this better?

```html
<template functional>
  <span>{{ $options.methods.format(date) }}</span>
</template>
```

Anyway if you execute this, you will notice I just lied to you when I said it works...

### Accessing props, listeners and attrs?

The reason its not working is because, again, there is no Vue instance, so when the Vue Loader transforms your template into pure JavaScript, it just can't find the `date` you just typed. It needs a context, so you have to declare a path for Vue to find it, like we did with the method.

```html
<template functional>
  <span>{{ $options.methods.format(props.date) }}</span>
</template>
```

> "And the `$attrs` and `$listeners`, I really want to make a full extensible open-closed component, so I kinda need this"
> &mdash; also me

Those are available too, only in different places. The `$attrs` is now at `data.attrs` and the `$listeners` is at the `listeners` (which is an alias to `data.on`, but as a suggestion, I'd stick with the new `listeners`).

#### `$attrs`

For those who didn't even knew this was a thing, let me clarify. In non-functional components, `$attrs` is used to represent every attribute passed down to your component declared in props or not. That means, if we have the `DisplayDate` components called like the following:

```html
<div>
  <DisplayDate
    :date="'6 Dec 1999'"
    aria-label="6 of December of 1999 was a long time ago, but not so much"
  />
</div>
```

And we have the declaration like we already defined up there (`<span>{{ $options.methods.format(props.date) }}</span>`), The `aria-label` prop will be ignored. But if we declare the `DisplayDate` like the following, the extra attributes passed to the `DisplayDate` will be applied to the span, as we indicated.

```html
<template functional>
  <span v-bind="data.attrs">{{ $options.methods.format(props.date) }}</span>
</template>
```

But as of course we are in functional land; nothing is easy, and the API is different :man_shrugging:. When we are talking about functional components, now the `data.attrs` only contains the attributes passed down to the component but only the one not declared on the props, in the non-functional the `$attrs` have the value of `{ date: '...', ariaLabel: '...' }`, on the functional, the `data.attrs` have the value of `{ ariaLabel: '...' }` and the `props` have `{ date: '...' }`.

#### `$listeners`

Same thing with the `$listeners`, but for events. That means, when you try to apply `@click` event to a component, but you haven't declared this explicitly, it will not work, unless you use the `$listeners` to proxy the listeners handling to a different element or component.

```html
<!-- this is explicitly declaration -->
<button @click="$emit('click')">Click me</button>

<!-- this is the 'proxing' declaration -->
<button v-on="$listeners">Click me</button>

<!-- this is the 'proxing' declaration for functional components -->
<button v-on="listeners">Click me</button>
```

There is, once more, a different between the functional and non-functional components API for this. The non-functional components deal with `.native` events automagically, while the functional component is not sure if there's even a root element to apply the `.native` events, so Vue exposes the `data.nativeOn` property for you to handle the `.native` events the you want.

### Outside declared css classes on the component

<figcaption>
Passing a class to a custom component
</figcaption>

```html
<MyTitle
  title="Let's go to the mall, today!"
  class="super-bold-text"
/>
```

Another problem you may face, is about classes. Normally in Vue (as of today), when you pass a class to a custom component of yours, without explicitly configuring anything, it will be applied to the root element of your component, differently from react that it's explicit where the class is going.

Take the example above &mdash; assuming the css class does what it says it does and the title had no `text-weight` defined in the css and it is a non-functional component &mdash; the title would display as a **bold** text.

Now if we edit the `MyTitle` component like the following, transforming it to a functional component, the rendered text wouldn't be bold anymore, and that may feel very frustrating, I know because I felt it that way 😅.

```diff
-<template>
+<template functional>
   <span>
-    {{ title }}
+    {{ props.title }}
   </span>
 </template>

 <script>
 export default
   props: ['title'] // disclaimer: I don't recommend the array syntax for this
 }
 </script>
```

<figcaption>
No, it's not nice to have a title with an span tag, this is a mere example, just focus on the vue stuff, titles should more semantic tags like \`h1\`, \`h2\` or \`strong\`.
</figcaption>

And thats because... thats just because we are using functional components, and they are the way they are... :man_shrugging:. Now, serious, to make this work you will have to add a little more code, it's nothing, really:

```diff
@@ -0,5 +0,5 @@
 <template functional>
-  <span>
+  <span :class="data.staticClass">
     {{ props.title }}
   </span>
 </template>
```

<figcaption>
I'd advocate this syntax is better and it should be used in non-functional components too, but thats just a comment.
</figcaption>

The `data.staticClass` represents all the classes passed down to your component (I assume only the not dynamic ones, will check it later, hopefully I will remember to edit the post). So what you can do is use this variable to merge with other classes you may be declaring:

```html
<span
  :class="[data.staticClass, {
    'another-class': prop.someProp,
  }"
>
  {{ props.title }}
</span>
```

### Custom component inside the functional component

So here we have a problem. One that I don't know how to solve gracefully. Custom components can't be declared inside functional components, at least not in the way you'd expect. The `components` property on the vue export:

```html
<template functional>
  <MyCustomComponents1>
    I'd better be sailing
  </MyCustomComponents1>
</template>

<script>
export default {
  components: { // <- this here
    MyCustomComponents1,
  }
}
</script>
```

Just doesn't work. It would display the bare text "I'd better be sailing", because it cannot render an unknown component.

Despite it being declared down there, Vue just doesn't look to that property, and even worse, it doesn't even say anything, like a warning or an error: "Warning, components are not registrable on functional components" or something. The `components` property is useless.

Now, there are people who already raised [this issue and that come up with a workaround](https://github.com/vuejs/vue/issues/7492) to that problem, but I don't really like how it looks 😅, I mean, take a look at it:

```html
<template>
  <component :is="injections.components.MyCustomComponents1">
    I'd better be sailing
  </component>
</template>

<script>
import MyCustomComponents1 from '...'

export default {
  inject: {
    components: {
      default: {
        MyCustomComponents1,
      }
    }
  }
}
</script>
```

There is also the option to register all the components you'll need in the global scope or to register the components you need on the parent that will host your functional component.

The latter is not a sane option because it makes the two components &mdash; the parent and the functional component &mdash; very tightly coupled, which is generally a bad idea.

<figure>
<figcaption>
  Registering components in the global scope:
</figcaption>

```javascript
import Vue from 'vue'
import MyCustomComponents1 from '...'
// And so on...

Vue.component('MyCustomComponents1', MyCustomComponents1)
Vue.component('AndSoOn', AndSoOn)
//...

new Vue({
  el: '#app',
  // ...
});
```

</figure>

This problem leads me to think functional components weren't thought out to be used with the template syntax, because the only reasonable approach to use custom components inside functional ones is to use the render function, look at that, it's elegant:

```javascript
import MyCustomComponents1 from '...'
//...
render(h) {
  return h(MyCustomComponents1, {}, ['I\'d better be sailing'])
}
```

## What is wrong with all this?

What you have to imagine when you are doing functional template, is like you are writing a function that returns a JSX syntax, and the Vue Loader is calling your template more or less like this:

```jsx
render(h, { data, listeners, $options, /* the rest of the exposed variables...*/ }) {
  return (
    <template functional>
      <component
        :is="injections.components.MyCustomComponents1"
        v-bind="data.attrs"
        v-on="listeners"
        :class="data.staticClass"
      >
        {{ $options.methods.format(props.date) }}
      </component>
    </template>
  )
},
```

So we have access to those parameters, and nothing else. The problem with this is, when you are using a functional component with the render function syntax or with JSX, you have access to the body of the function to do destructuring, contextualization, separate things, process data, like the following.

```jsx
import MyCustomComponents1 from '...'
import { format } from '...'

render(h, { data, listeners }) {
  const { date } = data.props

  // this is not proper JSX, but I hope you get the point
  return (
    <template functional>
      <MyCustomComponents1
        v-bind="data.attrs"
        v-on="listeners"
        :class="data.staticClass"
      >
        {{ format(date) }}
      </MyCustomComponents1>
    </template>
  )
},
```

This is a very small example, but I hope I can get the idea through. And the component markup syntax went back to being simple and easy to read, but when you are using the template syntax with vue functional component, you don't have access to this part of the function.

## Future?

I really just hope that [that controversial Request for Comments](https://github.com/vuejs/rfcs/pull/42) (EDIT: this was updated and now we are talking about [this one](https://github.com/vuejs/rfcs/pull/78)) will live to see light and we get this better syntax that have all the benefits of performance and readability we all want.

Anyway, I hope I could help you with any problems you may be facing, I had a hard time searching for some information in there, I hope with this post you'll have less of a hard time. Thanks for reading till here, I hope you are having an awesome day, see you next time.
