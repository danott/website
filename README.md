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
3. `Target#hydrate` processes magic comments with all source data to fully compose the target
4. `Target#write` writes the target to `_site`

## Attaching data

I use an inert HTML element to associate data with a source. It looks like`<template data-parse>[data string]</template>`.

Right now I use a bespoke data string format. I could imagine a future where I process other languages like `<template data-parse="(bespoke|json|yaml|toml)">`. But I'm avoiding YAGNI.

This parsing should happen before a source is turned into a target.

## Composing with "Magic Comments"

I've implmented a minimal set of magic comments. I'm leaning into the idea that composition is superior to inheritance. So I'm not *inheriting* from multiple "templates" or "layouts". I'm *composing* individual pages by injecting and/or replacing content.

Magic comments are deleted/replaced in the final output.

- `<!--IncludeInHeader::Text [string] -->` injects `[string]` into the document head.
- `<!--IncludeInHeader::RegisteredIncludable-->` will look up `RegisteredIncludable`, render it, and inject the result into the document head.
- `<!--Include::RegisteredIncludable-->` will look up `RegisteredIncludable`, render it, and inject the result in place of the comment.

### Not implemented ideas because they don't need to exist

I really like `pandoc`. It has three options that inspire me. `--include-in-header`, `--include-before-body`, and `--include-after-body`. I've only implemented one.

- `<!--IncludeBeforeBody::RegisteredIncludable-->` isn't necessary because I don't have layers of nested layouts. If I want something at the beginning of the body I include the magic comment at the beginning of the body.
- `<!--IncludeAfterBody::RegisteredIncludable-->` for the same reasons.
- `<!--Include::Text something -->` works by accident. It's not necessary though...just type `something` directly!

### Ideas for the future

I have an idea that could be useful. But I haven't needed it yet.

- `<!--Mutate::RegisteredMutation-->` for upgrading a `<h1>` to a `<header>` with sibling nodes, adding classnames to `<body>`, etc.

The beauty of magic comments is that they can be fractal.  `<!--Include::RegisteredIncludable-->` can be a hydra that generates other magic comments that will be recursively processed.

There's potential for infinite loops here. But who cares. I'm building my website. Not a generic tool for building any website.

I do wonder if it'd be worth using something besides a comment for this. Something like custom elements?

```html
<include-in-header includable="Text">Some text value</include-in-header>
<include-here includable="RegisteredIncludable"></include-here>
```

I could even implement these custom elements in JavaScript. If they show up it could be noisy and throw errors. I could make an XHR to a bespoke netlify endpoint to notify myself of the error. I could write tests that fail if anything in `_site` includes these custom elements.

Maybe someday.
