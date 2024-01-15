<template data-parse>2022-07-11</template>

# Bring your own static site generator

Configuration.
Who wants it?
Not me!

Eleventy is great.
Jekyll is great.
All the static-site-generators are great.

I don't want to configure them.
I don't want to maintain the configuration of them.
I don't want to upgrade them over time.

I do want to control my own little system from end-to-end.

Call it procrastination.
Call it [having fun][].
At the end of the day, I know my sensibilities.
I don't want dependencies.
I want a feature-light, do-it-yourself website.

So that's what I'm building.

My static site generator is a [Rakefile][].
It mostly invokes [pandoc][] to transform Markdown into HTML.
[RSS::Maker.make][] builds the [RSS feed][].
One special task generates the [index page][].
A little bit of Ruby glues it all together.

No `Gemfile`.
No `package.json`.
There's two dependencies.
The Ruby standard library and pandoc.
I'm optimistic that I can replace pandoc with [RDoc::Markdown][] and [ERB][] templates.
Maybe—someday—if the pandoc dependency proves too heavy.

It's not much.
I like it. 
And I'll sleep easy knowing that I'll never have to run `bundle update` or `npm update` again.

[erb]: https://ruby-doc.org/stdlib/libdoc/erb/rdoc/ERB.html
[having fun]: https://justforfunnoreally.dev
[index page]: /
[pandoc]: https://pandoc.org
[rakefile]: https://ruby.github.io/rake/doc/rakefile_rdoc.html
[rdoc::markdown]: https://ruby-doc.org/stdlib/libdoc/rdoc/rdoc/RDoc/Markdown.html
[rss feed]: /feed.xml
[rss::maker.make]: https://ruby-doc.com/stdlib/libdoc/rss/rdoc/RSS/Maker.html#method-c-make