class DataSet
  attr_reader :path

  def self.gather(dir)
    Dir
      .glob("#{dir}/*")
      .reject { |path| File.directory?(path) }
      .map { |path| new(path) }
  end

  def initialize(path)
    @path = path
  end

  def data
    @data ||=
      YAML.safe_load(
        File.read(path),
        permitted_classes: [Date, HeyWorldEntry, Time, PinboardBookmark, Symbol]
      )
  end

  def name
    extname = File.extname(path)
    File.basename(path, extname)
  end
end
