class MagicCommentHydratorTest < Minitest::Test
  CONTENT = <<~HTML
    <html>
      <head>
        <title>Test</title>
      </head>
      <body>
        <!--IncludeInHeader::Text <meta name="single line text"> -->
        <!--IncludeInHeader::Text
          <meta name="multi line text">
        -->
        <!--IncludeInHeader::DummyIntendedForHeader-->
        <h1>Test</h1>
        <!--Include::DummyIntendedForInline-->
        <!--Include::HydraIncludable-->

        <h2><eval-ruby>2 + 2</eval-ruby></h2>

        <include-in-header>
          <meta name="include-in-header">
          <eval-ruby>'<meta name="eval-ruby"' + ">"</eval-ruby>
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
        includables: {
          "Text" => Includable::Text,
          "HydraIncludable" => HydraIncludable,
          "DummyIntendedForInline" => DummyIntendedForInline,
          "DummyIntendedForHeader" => DummyIntendedForHeader
        }
      )
    result = hydrator.hydrate

    refute_includes result.content, "<!--IncludeInHeader::Text "
    assert_includes result.content, '<meta name="single line text">'
    assert_includes result.content, '<meta name="multi line text">'

    refute_includes result.content,
                    "<!--IncludeInHeader:DummyIntendedForHeader-->"
    assert_includes result.content, '<meta name="DummyIntendedForHeader">'

    refute_includes result.content, "<!--Include::DummyIntendedForInline-->"
    assert_includes result.content,
                    "<h1>DummyIntendedForInline Return that!</h1>"

    refute_includes result.content, "<!--Include::HydraIncludable-->"
    assert_equal 2,
                 result
                   .content
                   .scan("<h1>DummyIntendedForInline Return that!</h1>")
                   .size

    refute_includes result.content, "<eval-ruby>2 + 2</eval-ruby>"
    assert_includes result.content, "<h2>4</h2>"

    refute_includes result.content, "<include-in-header>"
    assert_includes result.content, '<meta name="include-in-header">'
    assert_includes result.content, '<meta name="eval-ruby">'
    assert result.content.index('name="eval-ruby"') <
             result.content.index("</head>"),
           "Should actually be injected into the head!"
  end

  class DummyIntendedForInline
    attr_reader :data

    def initialize(string:, data:)
      @data = data
    end

    def render
      "<h1>DummyIntendedForInline #{data.fetch("Fetch this!")}</h1>"
    end
  end

  class DummyIntendedForHeader
    def initialize(string:, data:)
    end

    def render
      %Q[<meta name="DummyIntendedForHeader">]
    end
  end

  class HydraIncludable
    def initialize(string:, data:)
    end

    def render
      "<!--Include::DummyIntendedForInline-->"
    end
  end
end
