---
isDraft: false
lang: en
title: Naming color shading variables in CSS
description: I don't know where I saw this, but if you ever find yourself not
  knowing what naming give color shading on your css variables consider using
  these adjectives to amplify the range of your available shades of colors.
author: Vinícius Hoyer
date: 2023-06-30T18:36:41.941Z
tags:
  - Tech
  - CSS
---
I don't know where I saw this, but if you ever find yourself not knowing what naming give color shading on your css variables consider using these adjectives to amplify the range of your available shades of colors. I like using these because they all have 4 letters so they line up beautifuly on the code editor, it massages my OCT in all the right places.

```css
:root {
  --coal-pale: #333333;
  --coal-pure: #161616;
  --coal-deep: #191308;

  --cottom-pale: #FFFFFF;
  --cottom-pure: #F5F5F5;
  --cottom-deep: #EBEBEB;

  --primary-pale: #E13D66;
  --primary-pure: #D4214E;
  --primary-deep: #AF1B3F;

  --accent-pale: #D2B9F3;
  --accent-pure: #B388EB;
  --accent-deep: #792EDC;
}
```

A﻿s an additional note, `coal` and `cotton` are better names than `black` and `white` because they allow a bigger range of colors to be associated with that name intead of simply black and white.

A﻿lso `coal` and `cotton` can be used interchangeably as `color` and `background-color` depending on if the applied theme is a light or a dark one.