<template data-parse>2024-01-14 #noIndex #rssClub</template>

# Welcome to RSS Club!

<p style="font-family:monospace;">This post is a secret to everyone! <a href="https://daverupert.com/rss-club/">Read more about RSS Club.</a></p>

You're in! A thrill, I know. That RSS high comes every time I read about RSS Club. RSS feeds from [Jim Nielsen][] and [Dave Rupert][] inducted me. Now my RSS feed had inducted you.

This first foray into the RSS Club is a proof-of-concept. I had to prove the concept because I have a bespoke toolset for developing my site.

My strategy is using tags. I tag content `#noIndex` to keep it from showing up on my site's index. I tag content `#rssClub` for future reference. I'm not doing any magic to inject the leading paragraph. I'll copy/paste that until it's too annoying to maintain.

Why tell you when I can show you? This evening I made [github.com/danott/website](https://github.com/danott/website) publicly accessible. Browsers have "View Source". I consider sharing the code that generates the site as "View Source+".

I've had a few false starts on sharing the source to my website. I had an epiphany about this struggle the other night.

My goal isn’t to build a static site generator. My goal is to build my website. How it is generated does not have to be generic. Or elegant. Or transferable. Or scaleable. Or use established patterns. I've moved the focus from building a franchise concept restaurant to making a home cooked meal. 

YAML frontmatter? Nope. I use an HTML template. It looks like this:

```html
<template data-parse>2024-01-14 #noIndex #rssClub</template>
```

This is great! [iA Writer](https://ia.net/writer) finds these tags. And it is clear while writing/previewing that they are not part of the to-be-rendered content. This was an iteration on top of the [simplification](/2022/simplification/) of ditching YAML frontmatter in 2022.

Nested layouts in ERB, Liquid, Nunjucks, or similar?  Nope.
I have one template that creates wrapping HTML. It's the default template provided by `kramdown`. No Russian-doll layouts necessary. I use "magic comments" to compose pages. "Prefer composition over inheritance." I'm gonna give it a shot.

I see a path to resurrecting old content that sits dormant on hard drives. I see a path for adding quick notes and thoughts without a title. I see a path for iterating on a bespoke website that's not trying to be anything more than that.

There's another thing I ditched from static site generators. There's no fancy or configurable path transformations. `site/2023/post-name.md` should become `_site/2023/post-name/index.html`. That’s as far as it should go. That way everything is linkable right within iA Writer. 

That's the goal. Get the tooling out of the way. Be able to focus on the writing. Reduce the friction from ideation to publishing.

Welcome to RSS Club!

[jim nielsen]: https://blog.jim-nielsen.com
[dave rupert]: https://daverupert.com
