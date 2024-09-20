class Source
  def self.gather(dir)
    Dir
      .glob("#{dir}/**/*")
      .reject { |path| File.directory?(path) }
      .map { |path| self.for(path) }
  end

  def self.for(path)
    extname = File.extname(path)
    case extname
    when ".md"
      MarkdownSource.new(path: path, content: MagicFile.read(path))
    when ".css", ".jpg", ".js", ".png", ".html"
      FileCopier.new(path)
    when ".rb"
      eval(File.read(path))
    else
      NoopSource.new(path)
    end
  end
end
