class MagicFile
  attr_reader :path
  attr_reader :original_content

  def self.read(path)
    new(path, File.read(path)).content
  end

  def initialize(path, original_content)
    @path = path
    @original_content = original_content
  end

  def content
    if path.match(%r{site/\d\d\d\d/})
      "<!--Include::PageDefaults-->\n\n" + original_content
    else
      original_content
    end
  end
end
