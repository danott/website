<!--data 2022-08-10 #ruby #pandoc #kramdown #netlify -->

# Need for Speed

This site's dependency on `pandoc` lasted about a month.

The builds on Netlify were measured in minutes.
The majority of this time was spent installing `pandoc` via the `Brewfile.netlify` file.
This expensive install doesn't appear to be cache'able so it's paid every deploy.

I had aspirations of this site carrying minimal dependencies.
An ideal of not even having a `Gemfile`.
But it turns out that I have to have a `Gemfile` on Netlify.
Even a core utility like `rake` was unavailable without it making an appearance in the `Gemfile`.

So since I'm installing gems anyway—why not investigate alternatives to rendering markdown.

I created three renderers.

1. Ruby with one external dependency (`pandoc`)
2. Ruby standard library with zero dependencies (`RDoc::Markdown`)
3. Ruby with gem dependencies (`kramdown`)

I benchmarked my three renderers before making a decision.
The results were surprising.

```
pandoc
  0.029805   0.160651   2.808135 (  3.647894)
rdoc
  4.540228   0.046484   4.677953 (  4.722740)
kramdown
  0.126872   0.029985   0.269132 (  0.330185)
```

`pandoc` is a library written in Rust. 
I assumed it would be much faster than everything.
It was noticeably faster than `rdoc`.
It was an order-of-magnitude slower than `kramdown`.

So now I have a few external dependencies on Ruby gems.

- `kramdown` for rendering markdown
- `kramdown-parser-gfm` for parsing the GitHub Flavored Markdown dialect
- `rouge` for syntax highlighting in code examples

Three external dependencies were added.
Dependence on external binaries went to zero.
Local build times dropped by an order of magnitude.
The first deploy with a new `Gemfile` was a total of 23 seconds on Netlify.

Hooray for Ruby!

***

Update: the second deploy after this change (where gems were cached) had a build time of 12s, and a total deploy time of 16s. 📉