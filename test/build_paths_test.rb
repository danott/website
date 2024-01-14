class BuildPathsTest < Minitest::Test
  Dummy = Struct.new(:path).include(BuildPaths)

  def test_index_markdown_path
    dummy = Dummy.new("site/path/to/thing/index.md")
    assert_equal("site/path/to/thing/index.md", dummy.path)
    assert_equal("site/path/to/thing/index.md", dummy.source_path)
    assert_equal("_site/path/to/thing/index.html", dummy.target_path)
    assert_equal("/path/to/thing/", dummy.url)
  end

  def test_non_index_markdown_path
    dummy = Dummy.new("site/path/to/another-thing.md")
    assert_equal("site/path/to/another-thing.md", dummy.path)
    assert_equal("site/path/to/another-thing.md", dummy.source_path)
    assert_equal("_site/path/to/another-thing/index.html", dummy.target_path)
    assert_equal("/path/to/another-thing/", dummy.url)
  end

  def test_duplicate_identifier_path
    dummy = Dummy.new("site/path/to/another-thing/another-thing.md")
    assert_equal("site/path/to/another-thing/another-thing.md", dummy.path)
    assert_equal(
      "site/path/to/another-thing/another-thing.md",
      dummy.source_path
    )
    assert_equal("_site/path/to/another-thing/index.html", dummy.target_path)
    assert_equal("/path/to/another-thing/", dummy.url)
  end
end
