class HtmlTarget
  include BuildPaths

  attr_reader :content
  attr_reader :data

  def initialize(content:, path:, data:)
    @content = content
    @path = path
    @data = data
  end

  def hydrate
    hydrator =
      MagicCommentHydrator.new(content: content, includables: Build.includables)
    self.class.new(content: hydrator.hydrate.content, path: path, data: data)
  end

  def write
    FileUtils.mkdir_p(File.dirname(target_path))
    File.write(target_path, content)
    self
  end
end
