class NoopSource
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def write
    puts "NoopSource#write: #{path}"
    self
  end

  def hydrate
    self
  end
end
