module BuildPaths
  attr_reader :path

  def source_path
    path
  end

  def target_path
    path
      .sub(Build.source_dir, Build.target_dir)
      .sub(".md", "/index.html")
      .sub("/index/index.html", "/index.html")
  end

  def url
    target_path.delete_prefix(Build.target_dir).sub("/index.html", "/")
  end
end
