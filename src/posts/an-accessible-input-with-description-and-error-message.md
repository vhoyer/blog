---
isDraft: false
lang: en
title: An Accessible Input with Description and Error Message
description: How to flag to the input that those spans are errors and
  descriptions linked to itself using `aria-labelledby` and `aria-describedby`
author: Vinícius Hoyer
date: 2022-06-16T22:03:45.229Z
tags:
  - Tech
  - Accessibility
  - Links List
---
```html
<div>
  <label id="email-label" for={name}>
    Insert a date
  </label>

  <input
    id="date"
    name="date"
    aria-labelledby="date-label date-hint"
    aria-describedby="data-error"
  >

  <span id="date-hint">
    MM/YY
  </span>

  <span id="date-error">
    Must be future date!
  </span>
</div>
```

- `labeledby` for labels and descriptions/hints
- `describedby` for error messages

Reference:
- <https://www.w3.org/WAI/tutorials/forms/instructions/>
- <https://www.w3.org/WAI/tutorials/forms/notifications/>