<template data-parse>2022-09-14</template>

# My Bookmarking Bookmarklet

I iterated on [my bookmarklet for authoring a new post](https://www.danott.co/2022/my-own-bookmarklet/).
I've been sharing more links to other blogs with a few quotes or brief comments.
The process for this has been a slog.

With my new bookmarklet, the slog parts are mostly automated, with room for tweaks as I go.

- The title is automatically inferred from the current tab
- The slug is automatically generated from the title
- The selected text is automatically inserted as a blockquote

Here's the source, which I've also saved as [a GitHub gist](https://gist.github.com/danott/e0ff791aa8a2fb98b625037efea8c252) to track the diff over time.

```js
// https://bookmarklets.org/maker/
var date = new Date()
date.setHours(date.getHours() - date.getTimezoneOffset() / 60)
date = date.toISOString().split("T").at(0)
var title = window.prompt("What's a good starter title?", document.title)
var slug = window.prompt("what's a good slug?", title.toLowerCase().replace(/\s+/g, "-"))
var filename = "content/posts/" + date + "-" + slug +".md"
var value = "#bookmark\n\n# [" + title + "](" + window.location.toString() + ")\n\n" 
var quote = window.getSelection().toString()
if (quote) value += "> " + quote + "\n\n"

var url = new URL("https://github.com/danott/www.danott.co/new/main")
url.searchParams.append("filename", filename)
url.searchParams.append("value", value)
window.open(url)
```