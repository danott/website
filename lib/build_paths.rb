module BuildPaths
  attr_reader :path

  def source_path
    path
  end

  def target_path
    extname = File.extname(path)
    segments =
      path
        .sub(Build.source_dir, Build.target_dir)
        .delete_suffix(extname)
        .split("/")
    segments.pop if segments.last(2).uniq.size == 1
    segments.pop if segments.last == "index"
    segments.push("index.html")
    segments.join("/")
  end

  def url
    target_path.delete_prefix(Build.target_dir).sub("/index.html", "/")
  end
end
