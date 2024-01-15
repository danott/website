class BuildData
  attr_reader :targets
  attr_reader :data_sets

  def initialize(targets, data_sets)
    @targets = targets
    @data_sets = data_sets
  end

  def all
    {
      "posts" => posts,
      "pages" => pages,
      "sets" => sets,
      "tags" => tags,
      "assets" => assets
    }
  end

  def posts
    targets
      .select { |t| t.is_a?(HtmlTarget) }
      .select { |t| t.data["date"].present? }
      .map { |t| t.data.merge("url" => t.url, "source_path" => t.source_path) }
      .sort_by { |t| t.fetch("date") }
      .reverse
  end

  def pages
    targets
      .select { |t| t.is_a?(HtmlTarget) }
      .select { |t| t.data["date"].blank? }
      .map { |t| t.data.merge("url" => t.url, "source_path" => t.source_path) }
  end

  def assets
    targets.select { |t| t.is_a?(FileCopier) }.map { |t| t.url }
  end

  def sets
    data_sets.map { |t| [t.name, t.data] }.to_h
  end

  def tags
    posts.flat_map { |t| t["tags"] }.uniq.compact.sort
  end

  def posts_tagged(tag)
    posts.select { |p| p.fetch("tags", []).include?(tag) }
  end
end
