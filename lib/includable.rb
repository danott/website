module Includable
  PAGE_DEFAULTS = <<~HTML
    <include-in-header>
      <meta name="viewport" content="width=device-width, initial-scale=1">

      <meta name="description" content="The personal website of Dan Ott.">
      <meta name="author" content="Dan Ott">

      <link rel="stylesheet" href="/stylesheets/style.css">
      <link rel="stylesheet" href="/stylesheets/pygments-default.css" media="(prefers-color-scheme: light)">
      <link rel="stylesheet" href="/stylesheets/pygments-monokai.css" media="(prefers-color-scheme: dark)">

      <link rel="alternate" type="application/rss+xml" href="/feed.xml" title="Dan Ott's Website RSS Feed">
      <link rel="alternate" type="application/rss+xml" href="/changelog.xml" title="Dan Ott's Website Changelog">

      <script src="/javascripts/script.js"></script>
    </include-in-header>
  HTML
end
