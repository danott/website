class FileCopier
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def write
    FileUtils.mkdir_p(File.dirname(target_path))
    FileUtils.cp(path, target_path)
  end

  def hydrate
    self
  end

  def target_path
    path.sub(Build.source_dir, Build.target_dir)
  end

  def url
    target_path.delete_prefix(Build.target_dir)
  end
end
