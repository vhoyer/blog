---
lang: en
title: Line debugging on JS trick
description: A trick that will help you debug code changing minimally your code
author: Vinícius Hoyer
date: 2020-11-18T14:41:42.525Z
tags:
  - Tech
---
So, supposing you have the following code:

```js
Object.entries({
  apple: { pt: 'maça', color: 'red' },
  lime: { pt: 'limão', color: 'green' },
})
  .filter(([_key, value]) => value.color === 'red')
  .map(([key, value]) => `${key} in Portuguese is ${value.pt}`)
  .join(';\n ')
```

and you want to check the value of of the filtered array, you can do so using the [comma operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comma_Operator), like so:

```js
Object.entries({
  apple: { pt: 'maça', color: 'red' },
  lime: { pt: 'limão', color: 'green' },
})
  .filter(([_key, value]) => value.color === 'red')
  .map(([key, value], i, a) => (console.log(a), `${key} in Portuguese is ${value.pt}`))
  .join(';\n ')
```

because the comma operator evaluates and executes the code on the left of the comma, but only returns the value on the right side of the comma, cheers :tada:.

I think that was a terrible example, but we will roll with it for now. Just so you know, this work anywhere, so use your creativity.
