module Includable
  class PageDefaults
    def initialize(string:, data:)
    end

    def render
      <<~HTML
        <!--IncludeInHeader::Text
          <meta name="viewport" content="width=device-width, initial-scale=1">

          <meta name="description" content="The personal website of Dan Ott.">
          <meta name="author" content="Dan Ott">

          <link rel="stylesheet" href="/style.css">
          <link rel="stylesheet" href="/pygments-default.css" media="(prefers-color-scheme: light)">
          <link rel="stylesheet" href="/pygments-monokai.css" media="(prefers-color-scheme: dark)">

          <link rel="alternate" type="application/rss+xml" href="/feed.xml" title="Dan Ott's RSS Feed">

          <script src="/script.js"></script>
        -->
      HTML
    end
  end
end
