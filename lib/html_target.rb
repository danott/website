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
      MagicElementHydrator.new(
        content: content,
        data: Build.data.for_current_page(data)
      )
    self.class.new(content: hydrator.hydrate.content, path: path, data: data)
  end

  def write
    FileUtils.mkdir_p(File.dirname(target_path))
    File.write(target_path, content)
    self
  end
end
