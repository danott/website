# danott.website

This is the source code that generates my website.

- `site` is the input
- `_site` is the output
- `lib` contains all the code the transforms the input into the output
- `test` contains unit tests for any particularly tricky bits of the build process

## Approach

`Build` is a singleton. I've commited some inadvisable meta-programming so I can call `Build.sources` instead of `Build.instance.sources`.

1. `Source.gather` gathers sources from `site`
2. `Source#to_target` transforms the sources into targets with data attached
3. `Target#hydrate` processes magic elements with all source data to fully compose the target
4. `Target#write` writes the target to `_site`

## Attaching data

I use an inert HTML element to associate data with a source. It looks like`<template data-parse>[data string]</template>`.

Right now I use a bespoke data string format. I could imagine a future where I process other languages like `<template data-parse="(bespoke|json|yaml|toml)">`. But I'm avoiding YAGNI.

This parsing should happen before a source is turned into a target.

## Composing with "Magic Elements"

I've implmented a minimal set of magic elements. I'm leaning into the idea that composition is superior to inheritance. So I'm not *inheriting* from multiple "templates" or "layouts". I'm *composing* individual pages by injecting and/or replacing content.

Magic elements are deleted/replaced in the final output.

- `<include-in-header>children</include-in-header>` injects `children` into the document head.
- `<eval-ruby>"Any valid ruby code"</eval-ruby>` will evaluate the ruby. Eval is terrible and you should avoid it in production systems. I'm building my website so YOLO.

### Not implemented ideas because they don't need to exist

I really like `pandoc`. It has three options that inspire me. `--include-in-header`, `--include-before-body`, and `--include-after-body`. I've only implemented one.

- `<include-before-body>` isn't necessary because I don't have layers of nested layouts. If I want something at the beginning of the body I include the content at the beginning of the body.
- `<include-after-body>` for the same reasons.

### Ideas for the future

I have an idea that could be useful. But I haven't needed them yet.

- `<eval-ruby>` or a new custom element could be introduced for upgrading a `<h1>` to a `<header>` with sibling nodes, adding classnames to `<body>`, etc.

The beauty of magic elements is that they can be fractal. `<eval-ruby>` can be a hydra that generates other magic comments that will be recursively processed.

There's potential for infinite loops here. But who cares. I'm building my website. Not a generic tool for building any website.
