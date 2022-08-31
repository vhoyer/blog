---
isDraft: false
lang: en
title: "[nuxt.js] Scss using custom alias failed"
description: How I debugged my way through the custom alias error, and how to
  resolve it yourself.
author: Vinícius Hoyer
date: 2020-11-24T15:19:02.071Z
tags:
  - Vue
  - Tech
---
## TL;DR

```js
// nuxt.config.js
export default {
  alias: {
    '~swiper': path.resolve(__dirname, './node_modules/swiper'),
  },
};
```

## The problem

So, in the company I work in, we use a internal library for components called Zilla, because of reasons I'm not willing to discourse here, we separate this library into Vue and Sass which end up being, both, loaded on the final project.

Inside the Zilla Core, the Sass one, we use as a dependency a library called `swiper`. So, naturally, inside one of the files we have a `@import` rule that follows:

```scss
@import '~swiper/css/swiper.min.css';
```

And this time, for reasons that I really don't have a clue why this was happening, when we imported this file into one of our projects (and only this one), the import would fail saying it couldn't find `~swiper/css/swiper.min.css` inside `node_modules/<package_name>/src`.

```
[ERROR] in ./node_modules/<package_name>/src/zilla.scss

Module build failed (from ./node_modules/postcss-loader/src/index.js):
Error: Can't resolve '~swiper/css/swiper.min.css' in '/home/<project path>/node_modules/<package_name>/src'
    at /home/<project path>/node_modules/postcss-import-resolver/node_modules/enhanced-resolve/lib/Resolver.js:209:21
...
and a long ass stack trace here.
```

So naturally, one conclusion we can draw from this error message is that the package is not being properly resolved into the `node_modules` folder, since it looks like the resolver is trying to find a folder called `~swiper` inside the `node_module/<>/src`, which shouldn't really happen.

My manager, figuring it would be a super simple 5 minutes solved bug, sends me this link: https://github.com/nuxt/nuxt.js/issues/406. Which probably lead me into the right track. And having fixed this bug with our project I would really like to add a comment on that issue so I could hopefully help someone out there, but since the issue is locked, I'm writing this post.

## The exploration

> Ok, I spent a hole day and then some trying to figure this one out, but I'm only gonna post the right paths I took here to be concise, just don't think you can't do it yourself or anything like that, everyone can do those things given the right time.

My first step was to look for the package in the stack trace `postcss-import-resolver`. Looking at the the [code for this package on github](https://github.com/nuxt-contrib/postcss-import-resolver) I noticed it used [webpacks' enhanced resolve library](https://github.com/webpack/enhanced-resolve), which I know from other battles, so I new it supported aliases.

So after looking for documentations about this, I decided to, once again, search code on github, but this time I crawled through [Nuxt's code](https://github.com/nuxt/nuxt.js/tree/dev), and found [where the postcss plugin was being initialized](https://github.com/nuxt/nuxt.js/blob/e934da3c36c5fcfe1f6061fd65eefa8af9ea1db1/packages/webpack/src/utils/postcss.js#L70), as well as a hint [where I could configure my failed alias](https://github.com/nuxt/nuxt.js/blob/e934da3c36c5fcfe1f6061fd65eefa8af9ea1db1/packages/webpack/src/utils/postcss.js#L49).

After this, I opened my project's node_modules folder and began adding `debugger` commands inside nuxt's code, the first stop was the function [`postcssImportAlias`](https://github.com/nuxt/nuxt.js/blob/e934da3c36c5fcfe1f6061fd65eefa8af9ea1db1/packages/webpack/src/utils/postcss.js#L48), there I used the chrome inspector (running nuxt with using `npx --node-arg="--inspect" nuxt`) to add manually my custom alias to `buildContext.options.alias`. After the alias was inserted, and the rest of the build process finished, I could verify that this approach really worked, so now I only had to discover which public API nuxt offered me to properly add this value to the, now infamous, `buildContext.options.alias`.

To find this out, I again tried to search the Nuxt documentation, but apparently I'm bad at searching because I couldn't find any details about this. The only option left for me was to keep adding `debugger` statements inside nuxt's code to find out where I could insert my alias.

After some long stack trace explorations I found out the `StyleLoader` was being invoked by `WebpackBaseConfig` which was extended by `WebpackClientConfig` which was instantiated by `WebpackBuilder` which used `BuilderConfig` which received as argument the `loadNuxtConfig` return value which passed through a `defu` function which fiiinally required the `nuxt.config.js` file (which you can change the location, but in our case we didn't and I think you should avoid changing it too, but that is besides the point here).

Well, I could have figured it just by brute forcing through some common places for this configurations, but I didn't, I tried for a while, but I was complicating things trying to add the alias object deeply nested inside other configurations, but in fact it was just adding an `alias` object to the root of the `nuxt.config` file.

## The solution

So the conclusion is that we can just add an alias onto the `nuxt.config.js` file and we are good to go.

```js
// nuxt.config.js
export default {
  alias: {
    '~swiper': path.resolve(__dirname, './node_modules/swiper'),
  },
};
```

This is so because this value is then imported by the builder, which formats the main configuration object for Nuxt, which then is passed into [`postcss-import-resolver`](https://github.com/nuxt/nuxt.js/blob/e934da3c36c5fcfe1f6061fd65eefa8af9ea1db1/packages/webpack/src/utils/postcss.js#L49) which is responsible for resolving the `@import` rules, and now it has the knowledge for where to look at whenever it sees a `~swiper` import.

While I do believe this could be resolved in a more generic way, I figured this was good enough. Anyway, hope this helps someone out there. Also, I added a [pull request to nuxt.org](https://github.com/nuxt/nuxtjs.org/pull/1025) to include this `alias` object in the documentation as I couldn't find it.
