HeyWorldEntry =
  Struct.new(
    :id,
    :content,
    :published,
    :title,
    :updated,
    :url,
    keyword_init: true
  ) do
    HEY_WORLD_ENTRIES_PATH = "data/hey_world_entries.yml"

    def self.pull
      uri = URI("https://world.hey.com/danott/feed.atom")
      feed = RSS::Parser.parse(Net::HTTP.get(uri))

      feed.items.map do |item|
        new(
          id: item.id.content,
          url: item.link.href,
          title: item.title.content,
          content: item.content.content,
          published: item.published.content,
          updated: item.updated.content
        )
      end
    end

    def self.download
      existing = all
      incoming = pull
      merged = (incoming + existing).uniq(&:id).sort_by(&:published)
      File.write(HEY_WORLD_ENTRIES_PATH, YAML.dump(merged))
      merged
    end

    def self.all
      if File.exists?(HEY_WORLD_ENTRIES_PATH)
        DataSet.new(HEY_WORLD_ENTRIES_PATH).data
      else
        []
      end
    end
  end
