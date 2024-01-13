class MagicFileTest < Minitest::Test
  def test_path_with_no_magic
    path = "site/index.md"
    assert_equal File.read(path), MagicFile.read(path)
  end

  def test_path_with_magic
    path = "site/2024/weeknotes-01.md"
    content = File.read(path)
    magic_content = MagicFile.read(path)

    refute_equal content, magic_content
    assert_operator magic_content,
                    :starts_with?,
                    "<!--Include::PageDefaults-->\n\n"
  end
end
