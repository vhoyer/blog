---
lang: en
title: How to make any component behaviorally accessible
description: Basically any component creates some expectation on the user. If
  you open a modal, you, as an user expect to be able to close it by clicking on
  the backdrop of that said modal. If you have a video focused and you press
  <kbd>Space</kbd>, you expect it to pause. If you tab into a button, you expect
  it to activate by either pressing <kbd>Enter</kbd> or <kdb>Space</kbd>.
author: Vinícius Hoyer
date: 2021-05-25T20:43:49.601Z
tags:
  - English
  - Tech
  - Accessibility
---
Basically any component creates some expectation on the user. If you open a modal, you, as an user expect to be able to close it by clicking on the backdrop of that said modal. If you have a video focused and you press <kbd>Space</kbd>, you expect it to pause. If you tab into a button, you expect it to activate by either pressing <kbd>Enter</kbd> or <kdb>Space</kbd>.

As a developer meeting those user expectations is a must do. That said, the list of expected behaviors is enormous, summed to the frequency of us having to create those kind of "basic" building blocks of a product being very low, the result is most often then not a not great experience for your user.

That's where the [WAI-ARIA Authoring Practices](https://www.w3.org/TR/wai-aria-practices-1.1/examples/) comes into play, this page is an extensive list of supported aria roles and a comprehensive guide on every micro interaction that any user might expect for a giving role. The work left for you to do is just identify which role fits your component better and implement the behaviors following this list.

Wanna make a button? They have it described; modal? You bet; maybe a toolbar? you're covered; Heck if you ever see yourself making a Windows 98 clone on `DOMElement`s, they have a description of how a `tree` view of your file system should work like.

I'm sure everyone using your website will be rejoiced with these interactions working properly. Those come a long long way into making your website more accessible.