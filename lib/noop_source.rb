class NoopSource
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def to_target
    self
  end

  def hydrate
    self
  end

  def write
    puts "NoopSource#write: #{path}"
    self
  end
end
