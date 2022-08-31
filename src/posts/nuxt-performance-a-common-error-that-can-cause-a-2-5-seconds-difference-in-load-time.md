---
isDraft: false
lang: en
title: "Nuxt Performance: A common error that can cause a 2.5 seconds difference
  in load time"
description: The infamous "The client-side rendered virtual DOM tree is not
  matching server-rendered content." error causes a significantly bigger impact
  than I imagined.
author: Vinícius Hoyer
date: 2021-02-23T20:40:39.978Z
tags:
  - Vue
  - Performance
  - Tech
---
Quick post just to share my findings. So I've been working for a while now in improving the company's website performance. And I always knew that the <abbr title="server-side render">SSR</abbr> vs. <abbr title="client-side render">CSR</abbr> difference error caused a performance issue, but the I thought that the difference I found was impressive nonetheless.

## What is the SSR vs. CSR difference error?

If you know what I'm talking about, you should really skip this section. Anyway, this is the way I generally refer to the following error.

![The client-side rendered virtual DOM tree is not matching server-rendered content.](/static/img/uploads/screenshot-from-2021-02-23-17-52-26.png)

This error happens when the HTML that the server has generated, differs from the HTML that the client Vue.js library wants to generate. Sometimes it's due to invalid HTML like the error message suggests, but sometimes it happens because we are stupid and we make mistakes. Most of the time I encountered this error, the reason was the latter.

An example of stupidity that we can commit: if we have a `div` and we want to display that `div` in mobile, but not in the desktop, and we decided to use `v-if` for doing so, we will most definitely run into this error.

```html
<template>
  <div class="carousel">
    <div class="carousel__stuff"></div>

    <div
      v-if="displayPagination()"
      class="carousel__pagination"
    ></div>
  </div>
</template>

<script>
export default {
  methods: {
    displayPagination() {
      return (typeof window !== 'undefined' && window.innerWidth <= 480)
    },
  },
};
</script>
```

In this case, when executing on the server, as the window has no value and as such, the server renders this template with `displayPagination` returning `true`. But when this code gets to the client, it runs `displayPagination` again, and returns `false`, because it's running on a desktop (and so the window.innerWidth is bigger than 480).

So in this case the server thinks it should render the `.carousel__pagination` but the client thinks it shouldn't, hence the error.

## The difference in performance

So, when this error happens (as far as I am aware), what the Vue.js in the client does is: recalculate everything and regenerate the DOM based on what it thinks is correct. This wastes precious startup time that should have been already done by the server.

Ok, so I always knew that this happened and always said "hey, don't ignore this error as it's bad for performance", but I had never measured the actual difference it makes... until today, and here are the summary:

![#10 11.40s; #9 11.03s; #8 14.29s; #7 14.26s; #5 14.24s](/static/img/uploads/performance.png)

In the results number #10 and #9 there was no CSR/SSR error, but in results number #8, #7, and #5 the error was present. This is a difference of roughly 2.5 seconds in load time.

That being said, the measured site already has a poor performance, and I'd be willing to bet that the impact of this on a more performant website will be less then 2.5 seconds, but the point stands, it is very important to fix this problems and I'm gonna start linking people to this article when I see this error on code review haha.

Have a good day :D.
