---
isDraft: true
lang: en
title: "Code Review: Why do we call it `TheHeader` instead of `Header`?"
description: "TL;DR: To comply with Vue.js default style guide"
author: Vinícius Hoyer
date: 2021-11-17T15:21:29.692Z
tags:
  - Code Review
  - Tech
  - Vue
---
Comment on `.../components/the-header/the-header.vue`

```diff
-  />
+  >
+    <template #afterLogo>
+      <TheHeaderHelp />
```

> Why do we call it `TheHeader` instead of `Header`?

---



Reference:
- <https://vuejs.org/v2/style-guide/#Single-instance-component-names-strongly-recommended>
- <https://vuejs.org/v2/style-guide/#Tightly-coupled-component-names-strongly-recommended>