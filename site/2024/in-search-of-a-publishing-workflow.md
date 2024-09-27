<template data-parse>2024-09-27 #markdown #blogging #git</template>

# In Search of a Publishing Workflow

I have been working with `git`  so long that I've assumed it as a default. For both warehousing text and distributing it. It has has come to my attention that publishing to the web does not require a `git` based workflow. 

I don't long for the days of `sftp` or `scp`. Though I was productive with those tools decades ago, I also remember recovering from the oopses being particularly painful.

Derek Sivers talks (on a Podcast that I don't recall specifically) about just using `rsync` to manage everything. Jim Nielsen has shared about his strategy of [Dropbox for content and GitHub for code](https://blog.jim-nielsen.com/2024/notes-site-via-content-in-dropbox/).

Here's what I know. I love writing text in [iA Writer](https://ia.net/writer). I want that to be the place my workflow starts. I want to start a post by opening a markdown file without any `yaml` or other programatic nonsense. Just text.

```
2024-09-27 #markdown #blogging #git

# In Search of a Publishing Workflow

I have been working with `git`  so long that I've assumed it as a default.
```

I want posts for a link blog to be similar

```
#some #tags

# [Website Title](https://www.example.com)

> Pull out a quote

And add some commentary
```

This is all very doable. I can parse plaintext into a bespoke `Struct` of data.

Separating the code that generates the site from the content that flows through that code is feeling powerful as I scratch the surface of tinkering.

"The medium is the message" comes to mind. I want to build my indieweb medium to distribute my indieweb message. They're symbiotic, but they're also distinct. 

At the end of the day, having a folder of plaintext files for my own reference is fine. Distributing them with HTML to foster connection is a separate activity. 

Plaintext forever.