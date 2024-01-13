class MagicCommentHydratorTest < Minitest::Test
  CONTENT = <<~HTML
    <html>
      <head>
        <title>Test</title>
      </head>
      <body>
        <!--IncludeInHeader::Text:: <meta name="single line text"> -->
        <!--IncludeInHeader::Text:: 
          <meta name="multi line text">
        -->
        <!--IncludeInHeader::DummyIntendedForHeader-->
        <h1>Test</h1>
        <!--Include::DummyIntendedForInline-->
        <!--Include::HydraIncludable-->
      </body>
    </html>
  HTML

  def test_everything
    hydrator =
      MagicCommentHydrator.new(
        content: CONTENT,
        includables: {
          "HydraIncludable" => HydraIncludable,
          "DummyIntendedForInline" => DummyIntendedForInline,
          "DummyIntendedForHeader" => DummyIntendedForHeader
        }
      )
    result = hydrator.hydrate

    refute_includes result.content, "<!--IncludeInHeader::Text::"
    assert_includes result.content, '<meta name="single line text">'
    assert_includes result.content, '<meta name="multi line text">'

    refute_includes result.content,
                    "<!--IncludeInHeader:DummyIntendedForHeader-->"
    assert_includes result.content, '<meta name="DummyIntendedForHeader">'

    refute_includes result.content, "<!--Include::DummyIntendedForInline-->"
    assert_includes result.content, "<h1>DummyIntendedForInline</h1>"

    refute_includes result.content, "<!--Include::HydraIncludable-->"
    assert_equal 2, result.content.scan("<h1>DummyIntendedForInline</h1>").size
  end

  class DummyIntendedForInline
    def render
      "<h1>DummyIntendedForInline</h1>"
    end
  end

  class DummyIntendedForHeader
    def render
      %Q[<meta name="DummyIntendedForHeader">]
    end
  end

  class HydraIncludable
    def render
      "<!--Include::DummyIntendedForInline-->"
    end
  end
end
