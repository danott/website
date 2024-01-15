class MagicCommentHydratorTest < Minitest::Test
  CONTENT = <<~HTML
    <html>
      <head>
        <title>Test</title>
      </head>
      <body>
        <h1>Test</h1>
        <h2><eval-ruby>2 + 2</eval-ruby></h2>
        <h2><eval-ruby>self.data.fetch("Fetch this!")</eval-ruby></h2>

        <include-in-header>
          <meta name="include-in-header">
          <eval-ruby>
            %Q[<meta name="\#{data.fetch("Fetch this!")}">]
          </eval-ruby>
        </include-in-header>
      </body>
    </html>
  HTML

  def test_everything
    hydrator =
      MagicCommentHydrator.new(
        content: CONTENT,
        data: {
          "Fetch this!" => "Return that!"
        },
        includables: []
      )
    result = hydrator.hydrate

    refute_includes result.content, "Fetch this!"
    refute_includes result.content, "2 + 2"
    refute_includes result.content, "<eval-ruby>"
    refute_includes result.content, "</eval-ruby>"
    refute_includes result.content, "<include-in-header>"
    refute_includes result.content, "</include-in-header>"

    assert_body_includes result.content, "<h2>4</h2>"
    assert_body_includes result.content, "<h2>Return that!</h2>"

    assert_head_includes result.content, '<meta name="include-in-header">'
    assert_head_includes result.content, '<meta name="Return that!">'
  end

  def assert_body_includes(haystack, needle)
    body = haystack.split("<body>").last.split("</body>").first
    assert_includes body, needle
  end

  def assert_head_includes(haystack, needle)
    head = haystack.split("<head>").last.split("</head>").first
    assert_includes head, needle
  end
end
