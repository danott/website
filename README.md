# danott.website

This is the source code that generates my website.

- `site` is the input
- `_site` is the output
- `lib` contains all the code the transforms the input into the output
- `test` contains unit tests for any particularly tricky bits of the build process

## Approach

`Build` is a singleton. I've commited some inadvisable meta-programming so I can call `Build.sources` instead of `Build.instance.sources`.

1. `Source.gather` gathers sources from disk in `site`
2. `Source#hydrate` transforms the source into a target with data attached
3. `Target#hydrate` processes magic comments to fully compose the target
4. `Target#write` writes the target to disk in `_site`

## Magic comments

I've implmented a minimal set of magic comments. I'm leaning into the idea that composition is superior to inheritance. So I'm not *inheriting* from multiple "templates" or "layouts". I'm *composing* individual pages by injecting and/or replacing content.

Magic comments are deleted/replaced in the final output.

- `<template data-parse></template>` is processed during `Source#hydrate`. It has to be processed early because every call to `Target#hydrate` wants access to all the site data across all sources/targets.
- `<!--IncludeInHeader::Text:: [any text value] -->` injects `[any text value]` into the document head.
- `<!--IncludeInHeader::RegisteredIncludable-->` will look up `RegisteredIncludable`, render it, and inject the result into the document head.
- `<!--Include::RegisteredIncludable-->` will look up `RegisteredIncludable`, render it, and inject the result in palce of the comment.

### Not implemented ideas because they don't need to exist

- `<!--IncludeBeforeBody::RegisteredIncludable-->` because I don't have layers of nested layouts. If I want something at the beginning of the body I include the magic comment at the beginning of the body.
- `<!--IncludeAfterBody::RegisteredIncludable-->` for the same reasons.
- `<!--Include::Text:: something -->` because that's silly. Just write `something` and it's included, right there.

### Not implemented but maybe there's a use case but I'm resisting YAGNI

- `<!--Mutate::RegisteredMutation-->` for upgrading a `<h1>`, adding classnames to `<body>`, etc.

The beauty of magic comments is that they can be fractal.  `<!--Include::RegisteredIncludable-->` can be a hydra that generates other magic comments that will be recursively processed.

There's potential for infinite loops here. But who cares. I'm building my website. Not a generic tool for building any website.
