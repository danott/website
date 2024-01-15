class MarkdownSourceTest < Minitest::Test
  PLAINTEXT = <<~TEXT.strip
    <template data-parse>
      2024-01-01 #tags #and #key:value #data #with #comment: Nothing better to say
    </template>

    # Markdown Title

    Markdown paragraph.
  TEXT

  def test_source_hydrate
    original_source =
      MarkdownSource.new(content: PLAINTEXT, path: "site/dummy.md")
    assert_equal PLAINTEXT, original_source.content
    assert_equal "site/dummy.md", original_source.path

    hydrated_source = original_source.hydrate

    # Avoid mutation of the original source. Generate new instances instead
    assert_equal PLAINTEXT, original_source.content
    assert_equal "site/dummy.md", original_source.path

    # Test hydrated source
    refute_equal PLAINTEXT, hydrated_source.content, "becomes html"
    refute_includes hydrated_source.content,
                    "<template data-parse",
                    "data comment has been hydrated into Source#data"
    assert_equal "site/dummy.md", hydrated_source.path, "unchanged in hydration"

    expected_data = {
      "date" => Date.parse("2024-01-01"),
      "tags" => %w[tags and data with],
      "key" => "value",
      "comment" => "Nothing better to say",
      "title" => "Markdown Title"
    }

    expected_data.each do |key, value|
      assert_equal value,
                   hydrated_source.data[key],
                   "data in #{key} does not match!"
    end
  end
end
