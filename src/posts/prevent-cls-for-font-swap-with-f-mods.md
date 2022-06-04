---
isDraft: false
lang: en
title: Prevent CLS for font swap with f-mods
description: CLS Optimization for font swap using font metrics override
  descriptors (f-mods).
author: Vinícius Hoyer
date: 2021-02-16T02:05:46.056Z
tags:
  - Performance
  - Tech
---
Font metrics override descriptors, f-mods for short. Some new CSS properties for optimizing *font loading* and reduce CLS due to `font-display: swap`. So, the properties added in this draft are: `ascent-override`, `descent-override`, and `line-gap-override`, which are all percentage values.

If you are like me you are already typing at google "how to get font metrics descriptors" or something like that. So I will help you: I've found this tool searching for "[font metrics inspector](https://opentype.js.org/font-inspector.html)" which is great and returns far more information than I needed! Yay great!

Except, not great, I don't know how to proceed since no one of this properties are in percentage! As established before, I know your are already typing "How to convert metrics descriptors to percentage", don't fear, I've already figured this one out for you.

To convert the metrics giving by the metrics inspector into values compatible with the new f-mods properties for the FontFace API, you have to take four (4) numbers out of the inspector:

* `ascender`: to use at the `ascent-override`
* `descender`: for `descent-override`
* `lineGap`: for `line-gap-override`; and
* `unitsPerEm`: which is our reference for 100%

so you can have something like

```css
@font-face {
  /* which font to apply to*/
  font-family: 'Liberation Sans'
  src: local('Liberation Sans');

  /* the values we need */
  --unitsPerEm: 1000;
  --lineGap: 0;
  --descender: -500;
  --ascender: 1900;

  /* applied to the properties */
  ascent-override: calc(var(--ascender) / var(--unitsPerEm) * 100%);
  descent-override: calc(var(--descender) / var(--unitsPerEm) * 100%);
  line-gap-override: calc(var(--lineGap) / var(--unitsPerEm) * 100%);
}
```

* Explainer & demos → <https://goo.gle/2J0xH4J>
* Spec → <https://goo.gle/370XDFP>
* How to get f-mods for a given font:

  * <http://westonthayer.com/writing/intro-to-font-metrics/>
  * <https://opentype.js.org/font-inspector.html>
  * <https://web.dev/css-size-adjust/>

* browser compatibility: <https://caniuse.com/?search=FontFace%20API%20override>
* Good explanation: <https://simonhearne.com/2021/layout-shifts-webfonts/#reduce-layout-shift-with-f-mods>
  * <https://www.zachleat.com/web/comprehensive-webfonts/>

On a side note, if you are smirking to yourself thinking "aah, cheap SEO tatics literally inserting common search queries in the article body", I'd say you are right, that was the point and I'm not ashamed of doing so :joy:. This is to help people, and if people don't find the text, there is no point in writing, is there? anyway.