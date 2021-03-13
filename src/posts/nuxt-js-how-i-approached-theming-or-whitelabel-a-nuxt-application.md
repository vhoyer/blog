---
lang: en
title: "[nuxt.js] How I approached Theming or Whitelabel a nuxt application"
description: All the solutions for the problems I encountered while working on
  making a ongoing project, transform itself from 1 website to 4 websites with
  different builds and a sensible API to control it all.
author: Vinícius Hoyer
date: 2021-03-13T17:22:01.783Z
tags:
  - English
  - Tech
  - Vue
---
This post will go through all the solutions I came up with while working on making the project of the main website from [Quero Education](http://quero.education/) (the product named [Quero Bolsa](https://querobolsa.com.br/)), an ongoing project, and transform the project source to generate, not only the main site, but other three websites with different builds and a sensible API to control it all.

## What is a whitelabel project?

// TODO

## The process

Cool, first as we were starting planning this set of changes, we had to come up with some terminologies. Each theme for the project was called a `system`. So the main site, being `quero-bolsa`, this is a system, the other ones, were like `mundo-vestibular`, another system, `ead` another system, and so on. So we had one system and wanted to make it generate 4 systems.

In this company. We already had one attempt at having a whitelabel project in this same website. But the approach was totally different. We had one server which, at request, determined which system was being requested and a bunch of ifs in every file determined  which system to render.

With that in mind we began this second whitelabel attempt with some rules to help us find the paths we wanted to go with. Those were the following (they are actually kinda obvious if you think about it, but you really have to keep it in mind):

- We don't want to force one system to download other systems data/components/logic/nothing. In production, one system have to be fully isolated from the others;
- We don't want to treat the starting system (the original `quero-bolsa` one) as a special case. If we are gonna do this, the original site has to fit in the new API, doing so, actually resulted in having from the get go all the flexibility we would ever need while developing other systems;
- We have to code this solution imagining we can have N systems in the project, so if we had to make 50 systems, the work required to implement each would be the same as if we only had to build two systems; and
- We want to, in each design decision, choose a sensible default, so that if anyone wants to create a new system in this same architecture, we don't want to force this person to write 500 configuration files just to start the new system, we want to provide a progressive experience to including new systems to the project.

### The routes

Ok, first problem was that: being an ongoing project, it had dozens of routes, but in the other systems we only wanted a few select routes, like, the search page one, at least at first.

The thing is that in this project we already had all the routes being configured manually via the `nuxt.config.js` option [`extendRoutes`](https://nuxtjs.org/docs/2.x/configuration-glossary/configuration-router#extendroutes) function. That being the case, we