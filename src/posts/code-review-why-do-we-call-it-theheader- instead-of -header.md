---
isDraft: false
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

This is to signal to other people that this component is a single instance component. That means that we shouldn't use more than one instance of this component. Think about it, does a site needs more than one main header? It does not.

This convention of using the `The` as a prefix to signal this comes from [Vue's style guide][1]. The name `TheHeaderHelp` follows the `The` prefix, not because of the "single instance" rule, but from the ["tightly coupled component" rule][2] again from Vue's style guide. It has the `The` prefix because it is tightly coupled to the `TheHeader`.

[1]: <https://vuejs.org/v2/style-guide/#Single-instance-component-names-strongly-recommended> "Single instance component names"
[2]: <https://vuejs.org/v2/style-guide/#Tightly-coupled-component-names-strongly-recommended> "Tightly coupled component names"