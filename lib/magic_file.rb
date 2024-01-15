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
      <<~HTML
        <eval-ruby>Includable::PAGE_DEFAULTS</eval-ruby>
        #{original_content}
        <eval-ruby>Includable::PostFooter.new(data: self.data)</eval-ruby>
      HTML
    else
      original_content
    end
  end
end
