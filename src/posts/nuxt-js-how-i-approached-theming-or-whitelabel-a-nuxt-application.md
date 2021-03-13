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

To not trigger the gods of SEO, I'm gonna change the names of the systems to `midori`, `akai` and `aoi` respectively.

Also, on the README for the project we have documented that, whenever we mention "system folder" we are referring to folder where we put system specific files.

Also, going forward on this post, I'd like to create some more terminologies to help us describe more concisely describe stuff. So, when I say "application files" I mean all the files for components, pages, utils and stuff not like the: tests, docs, deploy scripts and project configurations.

Secondly, when I say "project" I'm referring to the git managed files, basically all the source code.

### The past

So, in this company. We already had one attempt at having a whitelabel project in this same website. But the approach was totally different. We had one server which, at request, determined which system was being requested and a bunch of ifs in every file determined  which system to render.

With that in mind we began this second whitelabel attempt with some rules to help us find the paths we wanted to go with. Those were the following (they are actually kinda obvious if you think about it, but you really have to keep it in mind):

- We don't want to force one system to download other systems data/components/logic/nothing. In production, one system have to be fully isolated from the others;
- We don't want to treat the starting system (the original `midori` one) as a special case. If we are gonna do this, the original site has to fit in the new API, doing so, actually resulted in having from the get go all the flexibility we would ever need while developing other systems;
- We have to code this solution imagining we can have N systems in the project, so if we had to make 50 systems, the work required to implement each would be the same as if we only had to build two systems; and
- We want to, in each design decision, choose a sensible default, so that if anyone wants to create a new system in this same architecture, we don't want to force this person to write 500 configuration files just to start the new system, we want to provide a progressive experience to including new systems to the project.

### How to choose which system to build

Every system has a name, right? It's a website in the end, right? So to choose which project to build we would transform the name of the website into a slug (you know? when you have the normal name like "Times New Roman" and you transform it into "times-new-roman") to use it as a global identifier across the project.

We had the development command be like `npm run dev` now the new command would be `npm run dev midori`, same thing for build command. This first argument we pass to the `dev` and `build` commands are set as environment variables which is then used to define the current executing system.

```diff
 cross-env \
   HOST=0.0.0.0 \
   PORT=3050 \
   NODE_ICU_DATA=node_modules/full-icu \
+  SYSTEM_NAME="${SYSTEM_NAME:=$1}" \
   nuxt
```

> This weird syntax like `${SYSTEM_NAME:=$1}` means that the value for the system env var `SYSTEM_NAME` will be used first, but if this variable doesn't exist, the `$1` will be used instead. And the `$1` represents the first argument passed to the script.

### How to structure the folders

Nuxt has a [default/recommended folder structure](https://nuxtjs.org/docs/2.x/get-started/directory-structure), which has like `pages`, `components`, `middleware` and so on, which are, by default, all placed on the root folder of the project. As we wanted to be able to customize every file in the project, we decided the best decision was to move all the current application files to a sub-folder called `src`, this allowed us to create another folder called `systems` which we added sub-folders for each system to hold system specific files. This is the system folder.

```
./
├── src/
│   ├── assets/
│   ├── components/
│   ├── ... application files
│   ├── store/
│   └── utils/
├── systems/
│   ├── midori/... application files
│   ├── akai/... application files
│   └── aoi/... application files
└── ...
```

### The routes

Ok, first problem was that: being an ongoing project, it had dozens of routes, but in the other systems we only wanted a few select routes, like, the search page one, at least at first.

The thing is that in this project we already had all the routes being configured manually via the `nuxt.config.js` option [`extendRoutes`](https://nuxtjs.org/docs/2.x/configuration-glossary/configuration-router#extendroutes) function. That being the case, we used the same big array with all the routes and added one extra property to the `vue-router` page object called `system`.

```diff
 export default [
   {
+    systems: ['midori'],
     name: 'home',
     path: '/',
     component: '~/pages/home',
   },
   {
+    systems: ['midori', 'akai'],
     name: 'product-listing-page',
     path: '/busca-cursos/resutados',
     component: '~/pages/offer-search.vue',
   },
   // ...
 ]
```

While executing the `extendRoutes` function, we would filter out the routes that weren't allowed for the current executing system and that one problem out.

To vary `meta` and `path` and other route object values, we added a custom 

### 
