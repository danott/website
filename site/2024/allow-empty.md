<template data-parse>2024-01-23 #blogging #git #github</template>

# Allow Empty

I read [The agile comms handbook](https://agilecommshandbook.com) by [Giles Turnbull](https://gilest.org) last fall. The book's ideas are compelling. It's worth a read.

The emphasis on blogging for broadcast got me wondering about minimum viable blogging environments in general. Much of the friction in maintaining a blog can be setting up (and endlessly tinkering with) a publishing environment. Readers of this RSS feed have been witness to this over the last few years.

I've come to accept that I *enjoy* the setup and the endless tinkering. The artifacts produced by writing are great. The process of writing is enjoyable all on it's own. The process of building the tooling that transforms markdown files into html files is fun all the same. The git commits that chronicle the deltas in the source code that transforms the markdown files into html files is even more fun. 

I noticed a different flow state when writing the git commits. Git commits *feel* permanent. They chronicle the points in time of commitment to ideas. 

This flow state inspired an idea. Making that flow state the primary writing environment. Creating a blog where git commits were the primary content. `git commit --allow-empty` is the entry point. `git log --format=pretty` is the immediately available reading environment. There's no edits because commits are permanent. 

I've been playing with these ideas on an experimental blog. It is called "allow-empty". I recently turned those git commits into a website with an RSS feed. The source code that turns the commits into a website lives in the repository where the commits are the content that is acted on by that source code. It's an inversion of creation, reflection, and documentation that is stretching my thinking in ways I'm having trouble articulating.

Follow along at <https://allow-empty.danott.website> and <https://github.com/danott/allow-empty> if you're interested in the explorations of a minimal blogging environment.