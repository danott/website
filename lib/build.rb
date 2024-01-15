class Build
  include Singleton

  def self.method_missing(name, *args, &block)
    if instance.respond_to?(name)
      instance.public_send(name, *args, &block)
    else
      super
    end
  end

  def source_dir
    "site"
  end

  def target_dir
    "_site"
  end

  def data_dir
    "data"
  end

  def dehydrated_sources
    @dehydrated_sources ||= Source.gather(source_dir)
  end

  def dehydrated_targets
    @dehydrated_targets ||= dehydrated_sources.map(&:hydrate)
  end

  def hydrated_targets
    @hydrated_targets ||= dehydrated_targets.map(&:hydrate)
  end

  def data_sets
    DataSet.gather(data_dir)
  end

  def data
    @data ||= BuildData.new(dehydrated_targets, data_sets)
  end

  def includables
    @includables ||= {
      "Text" => Includable::Text,
      "DataDump" => Includable::DataDump,
      "Index" => Includable::Index,
      "PageDefaults" => Includable::PageDefaults,
      "PostFooter" => Includable::PostFooter,
      "SixWords" => Includable::SixWords
    }
  end

  def write
    hydrated_targets.map(&:write)
  end
end
