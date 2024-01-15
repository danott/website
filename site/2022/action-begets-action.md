<template data-parse>2022-10-13</template>

# Action Begets Action

I aspire to fully embrace the [indieweb](https://indieweb.org).
But I'm definitely coming from the [Publish Elsewhere, Syndicate (to your) Own Site](https://indieweb.org/PESOS) (PESOS) end of the spectrum.
As opposed to the more highly recommended [Publish (on your) Own Site, Syndicate Elsewhere](https://indieweb.org/POSSE) (POSSE) workflow.

I've authored content all over the place.
I'd like to get it all under one roof.
I need a way to syndicate (aka "import") all my old content.
I've done this before.

Way back when I had a Jekyll powered site.
Including a `_scripts` directory with Ruby code that did three things.

1. Fetch my my Pinboard bookmarks
2. Render a bookmark's JSON attributes as Markdown using ERB
3. Wrote that rendered Markdown to disc with a deterministic filename that Jekyll understands

The idea was novel at the time.
Automating that import never happened because I live on a laptop.
I didn't want to fuss with a server to setup the cron job.

[GitHub Actions](https://github.com/features/actions) are enabling the workflow I wanted years ago.
Using the [schedule trigger](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule) allows me to import my Pinboard bookmarks every night.

```yml
name: Import
on:
  schedule:
    - cron: "0 0 * * *"

jobs:
  import:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: ruby/setup-ruby@v1
      - run: rake import
      - run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add .
          git commit -m "Ran rake import in a GitHub Action"
          git push
```

My import task looks something like this

```ruby
task :import do
  PinboardPost.fetch.each(&:write!)
end
```

That's pretty neat.