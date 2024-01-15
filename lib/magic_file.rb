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
        <eval-ruby>Includable::PageDefaults.new(string: nil, data: nil).render</eval-ruby>
        #{original_content}
        <eval-ruby>Includable::PostFooter.new(string: nil, data: self.data).render</eval-ruby>
      HTML
    else
      original_content
    end
  end
end
