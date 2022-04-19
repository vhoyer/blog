---
isDraft: false
lang: en
title: "Code Review: Naming convetions in BEM"
description: Common mistakes I've seen on code review where we were supposed to
  be using the BEM convention.
author: Vinícius Hoyer
date: 2022-04-19T20:54:05.406Z
tags:
  - Code Review
  - Tech
  - CSS
---
## Using modifiers alone

One common mistake I see often is around the use of the modifier classes. If you think a bit about what a modifier is I think it should be easy to understand my point here.

A modifier causes a modification, and a modification can only be applied to something that is already standard. Take the example bellow:

```css
.burger {
  top: sesame-seeded-bread;
  cheese: cheddar;
  salad: tomato lettuce; 
  burger: medium-rare;
  bottom: bottom-bread;
}
.burger--no-lettuce {
  salad: tomato;
}
.burger--no-cheese {
  cheese: none;
}
.burger--add-mustard {
  condiments: mustard;
}
```

I'd argue that this is a accurate example of how BEM should work (at least leaving `elements` aside for now). If we analyze the relationship between the blocks and its modifiers are, one can see that using only a modifier alone is nonsensical. Imagine someone in the kitchen receiving the `burger--no-cheese` request; what does this mean to them? how will they make this burger, they will slap a cheese piece on the table and then remove it and deliver an empty tray with a napkin?

I hope that this analogy serves well to explain the relationship between a block (or an element) and its modifier, basically it does not make sense using the modifier alone, if you need to create a class for only one instance of a div, for example, I think that that is a good contender for an element class, not a modifier alone (or even a utility class, but some BEM purists are not really ready to that conversation yet).

Reference:
- http://getbem.com/naming/