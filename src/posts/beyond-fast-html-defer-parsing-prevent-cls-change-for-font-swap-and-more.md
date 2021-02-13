---
lang: en
title: "Beyond fast: HTML defer parsing, prevent CLS change for font swap and more"
description: HTML defer parsing, prevent CLS change for font swap with f-mods
  font loading strategies, Portals, caching polices, and yet more. This are more
  links that I don't want to loose ;) check them out, they are great.
author: Vinícius Hoyer
date: 2021-01-28T20:28:07.138Z
tags:
  - English
  - Tech
  - Performance
---
Sincerely, to make your site faster:

## `content-visibility`

- web.dev article: <https://goo.gle/3digQ8y>
- HTTP 203 episode → <https://goo.gle/3pXaKR6>
- HTML spec demo → <https://goo.gle/34QX5B1>
- Spec → <https://goo.gle/371HLmh>
- <https://www.terluinwebdesign.nl/en/css/calculating-contain-intrinsic-size-for-content-visibility/>

## F-mods:

Font metrics override descriptors, f-mods for short. Some new CSS properties for optimizing *font loading* and reduce CLS due to `font-display: swap`. So, the properties added in this draft are: `ascent-override`, `descent-override`, and `line-gap-override`, which are all percentage values.

If you are like me you are already typing at google "how to get font metrics descriptors" or something like that. So I will help you: I've found this tool searching for "[font metrics inspector](https://opentype.js.org/font-inspector.html)" which is great and returns far more information than I needed! Yay great!

Except, not great, I don't know how to proceed since no one of this properties are in percentage! As established before, I know your are already typing "How to convert metrics descriptors to percentage", don't fear, I've already figured this one out for you.

To convert the metrics giving by the metrics inspector into values compatible with the new f-mods properties for the FontFace API, you have to take four (4) numbers out of the inspector:

- `ascender`: to use at the `ascent-override`
- `descender`: for `descent-override`
- `lineGap`: for `line-gap-override`; and
- `unitsPerEm`: which is our reference for 100%

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

- Explainer & demos → <https://goo.gle/2J0xH4J>
- Spec → <https://goo.gle/370XDFP>
- How to get f-mods for a given font:
  - <http://westonthayer.com/writing/intro-to-font-metrics/>
  - <https://opentype.js.org/font-inspector.html>
- browser compatibility: <https://caniuse.com/?search=FontFace%20API%20override>
- Good explanation: <https://simonhearne.com/2021/layout-shifts-webfonts/#reduce-layout-shift-with-f-mods>

On a side note, if you are smirking to yourself thinking "aah, cheap SEO tatics literally inserting common search queries in the article body", I'd say you are right, that was the point and I'm not ashamed of doing so :joy:. This is to help people, and if people don't find the text, there is no point in writing, is there? anyway.

## BFCache:

- Dos and don't → <https://goo.gle/3mGTSfr>

## Portals:

- Explainer → <https://goo.gle/338db9B>
- The flags are #enable-portals, and #enable-portals-cross-origin

## Misc:

- Third party storage → <https://goo.gle/2KxG88l>
- Preloading → <https://goo.gle/2UYko7v>
- Quicklink → <https://goo.gle/3mddrLK>

## References
- <https://www.youtube.com/watch?v=Z6wjUOSh9Tk>
