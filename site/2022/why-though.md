<!--data 2022-07-14 -->

# Why though?

I made two attempts to roll my own static site generator.
The first started with Ruby objects and worked back towards Rake.
The second started with Rake and let Ruby objects reveal their need to exist.
The second approach resulted in better organization and minimal abstractions.

Avdi's course on [Rake and Project Automation][] was invaluable to starting with Rake.
The [Rake documentation][] is pretty good.
Seeing it explained through examples was even better.

File tasks and rules are incredibly powerful.
Generating a list of files that need to exist is pretty simple.
Set up the rules, and the generation takes care of itself.

Even better—Rake conditionally generates files based on their dependencies.
So adding a new post doesn't rebuild the entire site.
It generates the newly introduced page, the index page, and the RSS feed.

The ideas behind [shinobi][] and [pblog][] were influential to me starting this project.
Both were discovered via the RSS feed of [their author](https://tdarb.org).

I don't have the appetite for doing all this scripting in bash.
I love Ruby too much.
If I'm scripting things, Ruby is what I want to be using.

An [index page](/).
An [RSS feed](/feed.xml).
The entries themselves.

Minimalism and control are valued.

[rake and project automation]: https://graceful.dev/courses/the-freebies/modules/rake-and-project-automation/
[rake documentation]: https://ruby.github.io/rake/doc/rakefile_rdoc.html
[shinobi]: https://shinobi.website
[pblog]: https://pblog.xyz