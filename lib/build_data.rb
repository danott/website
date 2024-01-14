class BuildData
  attr_reader :targets
  attr_reader :current_page

  def initialize(targets, current_page = nil)
    @targets = targets
    @current_page = current_page
  end

  def for_current_page(next_current_page)
    self.class.new(targets, next_current_page)
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
    targets.select { |t| t.is_a?(DataSet) }.map { |t| [t.name, t.data] }.to_h
  end

  def tags
    posts.flat_map { |t| t["tags"] }.uniq.compact.sort
  end

  def posts_tagged(tag)
    posts.select { |p| p.fetch("tags", []).include?(tag) }
  end
end
