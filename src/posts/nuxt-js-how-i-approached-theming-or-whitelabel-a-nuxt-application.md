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

- **#1**. We don't want to force one system to download other systems data/components/logic/nothing. In production, one system have to be fully isolated from the others;
- **#2**. We don't want to treat the starting system (the original `midori` one) as a special case. If we are gonna do this, the original site has to fit in the new API, doing so, actually resulted in having from the get go all the flexibility we would ever need while developing other systems;
- **#3**. We have to code this solution imagining we can have N systems in the project, so if we had to make 50 systems, the work required to implement each would be the same as if we only had to build two systems; and
- **#4**. We want to, in each design decision, choose a sensible default, so that if anyone wants to create a new system in this same architecture, we don't want to force this person to write 500 configuration files just to start the new system, we want to provide a progressive experience to including new systems to the project.

Let's treat those as Axioms, because, why not? Also, I will be referring to those as numbers like "oh on the axiom#3 ..." just because I think it's funny. Deal with it.

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

To vary `meta` and `path` and other route object values, we added a custom API, where if there was a file named `router.js` inside a system folder, the `nuxt.config.js` file was configured to load this file and override the default values for the router -- this behavior is replicated with all kinds of files. For the route list we have defined a function which is also called `extendRoutes` but it receives a different signature with a util function called `editIfFound` to perform pin point editions on the routes.

```js
export default {
  extendRoutes({ editIfFound }) {
    editIfFound('product-page', (route) => {
      route.meta.breadcrumb.parent = 'another-route-name';
    });

    editIfFound([
      'plp-type-1',
      'plp-type-2',
      'plp-type-3',
      'plp-type-4',
    ], (route) => {
      route.path = route.path.replace(/^\//, '/custom-prefix/');
    });
  },
};
```

> The name `editIfFound` was originally `edit`, but we had some problems with tests where the function would just break because we had the route list mocked so some stuff would not be there.

### Text literals changes between systems

This was one of the easier changes to do, we didn't use any `i18n` library on this project, so we just... adopted it, and loaded a different source of text based on the current executing system.

```js
export const injectSystem = (systemName) => {
  const messages = lodash.merge(
    sharedI18n, // the default file
    requireIfExists(rootDir(`systems/${systemName}/i18n.json`)) || {}
  );

  // https://i18n.nuxtjs.org/options-reference.html
  return {
    // ...
    vueI18n: {
      // ...
      messages: {
        'pt-BR': messages,
      },
    },
  };
};

export default injectSystem(process.env.SYSTEM_NAME);
```

> `rootDir` and `requireIfExists` are both util functions written in-house which are "path transformations that points to the root of the project" and "try requiring a file, and if it doesn't exist return undefined" respectively. Those two only work properly on node environment, so be aware if you want to do it similarly.

Because of the Axiom#4, we have this `sharedI18n` which is a file that is sitting on the `src` directory that sets the baseline so that a new system doesn't necessarily need to add a custom messages file. And we are merging it with the default to be able to just override the stuff we need, not the stuff that is common between systems.

Also, we don't break the Axiom#1, because this file is ran only on build time, so the browser don't download useless `messages` on production.

### Actually changing themes for components

In our case, we already had a design system which were prepared to receive a `variables.scss` file with CSS custom properties that changes things like, `border-radius`, `color`s and... CSS properties 🤷.

Taking advantage of this fact and the `nuxt.config.js` option [`css`](https://nuxtjs.org/docs/2.x/configuration-glossary/configuration-css/) to add a extra file that points to a `theme.scss` file in the system folder.

```diff
 const { SYSTEM_NAME } = process.env;
 const globalCss = [
   // ...
+  `~~/systems/${SYSTEM_NAME}/assets/theme.scss`,
   // ...
 ];
 
 export default globalCss;
```

And yes, this file is required, and it kinda fails the Axiom#4, but you know what? I don't care, it's just one file and the systems would be identical if this file was optional.

### Customizing each system

So, as far as customization between systems go, we wanted to be able to:

- Show and hide different components in different systems;
- Changing images between systems (mainly like, logos and some svgs);
- Change the hole design/business logic of specific components between systems; and
- Changing the [copy](https://en.wikipedia.org/wiki/Copywriting) for each system (and this, we've already covered with the i18n section);

And to achieve those we adopted some of the following techniques, while those following practices cover a lot of the cases we need, there are some edge cases that are kinda more challenging to explain here without context, so I'm just gonna skip it, which is unfortunate, but if you wanna here my words out of those, hit me up on... email? Wherever you feel most comfortable using.

#### Show and hide different components in different systems

So, we decided on using this... feature flags system that, instead of using a server to provide the flags, as we didn't necessarily need the changes on the fly, only differences between systems, we could get away with having a JSON file on each system folder with a bunch of flags.

We add it as a [Vue plugins](https://vuejs.org/v2/guide/plugins.html) (those accessed by `this.$featureFlag`), as an util function, and as a "Higher Order Component" function (`withFeatureFlagEnabled`) function where we block a hole component with a feature flag.

#### Changing images between systems

To achieve this we added another Vue Plugin called `$asset`, which takes a `key` and returns an URL from another JSON file (we have a bunch of those) with the correct URL. Really, not much to say.

#### Change the hole design/business logic of specific components between systems

Now this, is where we added the the biggest game changer which mostly enables all of the above solutions to work properly. To override all the design/business logic of some component, the only thing you need to do, is to override the file which a given path returns. So if you have a `import something from 'path/to/something'`, we return actually `systems/aoi/path/to/something`.

To achieve this, we add a custom alias with fallback, which firstly tries to search the file at the system folder and then at the `src` default folder, and it makes all that at build time.

```js
const { systemName } = require('../system-current');

const AliasPlugin = require('enhanced-resolve/lib/AliasPlugin');
const path = require('path');

const rootDir = request => path.join(path.resolve(__dirname, '../../'), request || '');

const aliases = [{
  name: '%system',
  alias: [
    rootDir(`/systems/${systemName}/`),
    rootDir('/src/'),
  ],
}];

const aliasesPlugin = new AliasPlugin('described-resolve', aliases, 'resolve');

module.exports = {
  aliases,
  aliasesPlugin,
  rootDir,
};
```

> To make the alias work we had to choose a prefix to use in the paths, as we didn't want to enable this fallback import work by default for all imports to better describe when you read a file, which files are probably being overridden by the system.
>
> So we went with `%system` as we also did't want to use `@` as a prefix since it was too similar to the `@scope/package` syntax npm has gone for, and we didn't want people to thing that `@system/components/bla.vue` was a different package. We just really wanted to make it very obvious that something out of the ordinary was happening in that import.

Then we take this instance of the 'aliasesPlugin` and pass it down to webpack and it does it's magic.

## After thoughts

I'm not saying this is the bullet proof method of doing this, this is merely a report of how we managed to do it. Also, I'm increasingly hearing about how theming is coming to Nuxt 3, and I really don't know if some pre-made solution exists for Nuxt 2, and if it does, you probably should go for it instead of recreating this. At the time we had to implement these multi-system configuration for the project, we didn't find any tool that did the job for us, that's why we went for the in-house solution.