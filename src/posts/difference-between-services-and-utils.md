---
lang: en
title: Difference between `services` and `utils`
description: My take on the difference between services and utils, this is just
  my opinion on understanding the topic, and also a place for me to come back as
  I need to recall this information again.
author: Vinícius Hoyer
date: 2021-04-19T21:27:49.697Z
tags:
  - English
  - Tech
---
If you are going to use this post to win a discussion, think again, this is just my take on this, you could use it to base a defense for your point being it a point in favor or against this view of mine, that being said, this post is being made to serve as a guide to myself whenever I feel the need to recall my own conclusions. Also, this post may change overtime whenever I change my mind on this topic. But anyway.

Being mostly from a front-end written in JavaScript background, I used to think that services were classes and utils were functions, and while this can serve as a not-terrible rule of thumb, it can lead to some weird "weird" unnatural interfaces.

// to do: maybe talk a bit about the weird interfaces? Maybe some other time.

What are services? They are usually: user tracking services, integrations with search services, monitoring services, storage services, ad services. All these have a big, clear scope to work with.

On the other hand, utils are generally: URL utils, Number utils, formatter utils, date utils, all of which don't have a clear scope and are in essence very generic that can be used in all sorts of scopes to help in a very specific task.

That being the case, it doesn't mean, only because it's scope is small, a util should be a function. Sometimes the feature do ask for a more complex implementation and a class might be one of the tools used to realize this solution. Same thing goes for a service sometimes one might need state, and inheritance, but sometimes not, and one should not feel forced into a pattern that does not exist like I was for some time.

Basically, the difference comes down solely to scope, be it a class or a function, if it has a clear scope it's a service, if it's for general use it's a utils.