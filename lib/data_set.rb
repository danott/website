class DataSet
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def data
    YAML.safe_load(
      File.read(path),
      permitted_classes: [Date, PinboardBookmark, Symbol]
    )
  end

  def name
    path.delete_prefix(Build.source_dir).delete_prefix("/_").delete(".yml")
  end

  def hydrate
    self
  end

  def write
    self
  end
end
