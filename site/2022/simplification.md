<template data-parse>2022-08-14 #ruby</template>

# Simplification

Jim Nielsen shared about transitioning to [Markdown Sans Front Matter](https://blog.jim-nielsen.com/2022/markdown-sans-front-matter/).
Upon reading I was instantly compelled to do the same.

There are no rules against it since I'm [rolling my own static site generator](https://www.danott.co/2022/bring-your-own-static-site-generator/).
With a little Ruby scripting—the deed was complete in an evening.

I took a three step approach.

1. Author a new post in the new format
2. Update my parsing of source files to handle both formats
3. Build a conversion script to idempotently reformat files

Something I'm enjoying about rolling my own `Rakefile` is the ability to drive this transition with tests.
Writing tests about plaintext is strait forward.
They looked something like this.

```ruby
class ConversionTest < Minitest::Test
  def test_removing_frontmatter
    input = <<~INPUT
      ---
      title: This is a title
      tags:
        - first
        - second
      ---

      This is a paragraph
    INPUT

    expected = <<~EXPECTED
      #first #second

      # This is a title

      This is a paragraph
    EXPECTED

    actual = Conversion.new(expected).output
    assert_equal expected, actual, "conversion should work"

    actual = Conversion.new(actual).output
    assert_equal expected, actual, "conversion should be idempotent"
  end
end
```

And just a note about testing.
I love so much about this.
I don't care how messy my `Conversion` code is. 
I'm going to use it once, and throw it away.
What I care about is that it's doing exactly what I expect it to.
There were more test cases for single tags, no tags, and some other bespoke data retention.
But that's the gist of it.

## Next Level

After simplifying markdown to an existence without front matter I considered the validities of other complexities.
Templating, specifically.
Conditional rendering?
Nested templates?
Calling helper methods within the ERB.
How much of this is necessary?
And how much was cruft and assumptions I was bringing in from more generalized tools?

Something I liked about my brief usage of `pandoc` was how limited its templating was.
There were three options.

- `--include-in-header`
- `--include-in-body`
- `--include-after-body`

So I pushed my little Ruby template renderer to the limits of logicless templating.
This is the file in its entirety.

```ruby
class Template
  attr_reader :body
  attr_reader :title
  attr_reader :include_in_header
  attr_reader :include_before_body
  attr_reader :include_after_body

  def initialize(
    body:,
    title:,
    include_in_header: [],
    include_before_body: [],
    include_after_body: []
  )
    @body = body
    @title = title
    @include_in_header = build_includes(include_in_header)
    @include_before_body = build_includes(include_before_body)
    @include_after_body = build_includes(include_after_body)
  end

  private

  def build_includes(list)
    Array(list).flatten.join
  end
end

ERB.new(File.read("lib/template.rhtml")).def_method(Template, "render")
```

`template.rhtml` looks like this:

```rhtml
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><%= title %></title>
    <%= include_in_header %>
  </head>
  <body>
    <%= include_before_body %>
    <main>
      <%= body %>
    </main>
    <%= include_after_body %>
  </body>
</html>
```

And some example usage:

```ruby
SourceRenderer =
  Struct.new(:source) do
    def render
      Template.new(
        body: Markdown.render(source.body),
        title: source.title,
        include_before_body: [Fragment.simple_back_button, date_fragment],
        include_in_header: [Fragment.feed_meta_tag, Fragment.styles]
      ).render
    end

    private

    def date_fragment
      return if source.date.nil?
      content_tag(:p, source.date)
    end

    def content_tag(name, content)
      "<#{name}>#{content}</#{name}>"
    end
  end
```

The `Fragment` class is a really small Ruby object that loads fragments of html.

```ruby
class Fragment
  REGISTRY =
    Dir
      .glob("lib/fragments/*.html")
      .map do |path|
        key = File.basename(path, ".html")
        value = File.read(path)
        [key, value]
      end
      .to_h
      .freeze

  def self.method_missing(name, *args)
    REGISTRY.fetch(name.to_s)
  end
end
```

While writing I realize this could be pushed even further.
`include_before_body` and `include_after_body` could be collapsed into `body` if I wanted to ditch the assumption of a `main` tag.
The special case `title` could be collapsed down into `include_in_header`...though I always want HTML documents to have a title.

What would that look like?

```diff
SourceRenderer =
  Struct.new(:source) do
    def render
      Template.new(
-       body: Markdown.render(source.body),
+       body: [
+         Fragment.simple_back_button, 
+         date_fragment,
+         Markdown.render(source.body)
+       ].join,
-       title: source.title,
-       include_before_body: [Fragment.simple_back_button, date_fragment],
-       include_in_header: [Fragment.feed_meta_tag, Fragment.styles]
+       include_in_header: [title_fragment, Fragment.feed_meta_tag, Fragment.styles]
      ).render
    end

    private

    def date_fragment
      return if source.date.nil?
      content_tag(:p, source.date)
    end
+
+   def title_fragment
+     content_tag(:title, source.title)
+   end

    def content_tag(name, content)
      "<#{name}>#{content}</#{name}>"
    end
  end
```

Maybe I'll do that.
Or not.
For today—I enjoy writing Ruby
And words about Ruby.
And getting rid of complexity.

I understand why the complexity exists.
Generalized tools want to solve every problem.

That's not the tool I want.
I don't have every problem.
I have my problems.
I want the minimal tool that solves my problems.
I want to build that tool to better understand my problems.
And grow.
It's for fun.