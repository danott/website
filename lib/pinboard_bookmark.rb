PinboardBookmark =
  Struct.new(:href, :title, :commentary, :date, :tags, keyword_init: true) do
    PINBOARD_BOOKMARKS_PATH = "data/pinboard_bookmarks.yml".freeze

    def self.pull
      auth_token = ENV["DANOTT_DOT_WEBSITE_PINBOARD_AUTH_TOKEN"]
      uri =
        URI(
          "https://api.pinboard.in/v1/posts/all?tag=danott.website&format=json&auth_token=#{auth_token}"
        )
      JSON
        .load(Net::HTTP.get(uri))
        .map do |record|
          tags = record.fetch("tags").split(" ") - ["danott.website"]
          new(
            href: record.fetch("href").strip,
            title: record.fetch("description").strip,
            commentary: record.fetch("extended").strip,
            date: Time.parse(record.fetch("time")),
            tags: tags.compact.uniq
          )
        end
    end

    def self.download
      pull.tap do |bookmarks|
        File.write(PINBOARD_BOOKMARKS_PATH, YAML.dump(bookmarks))
      end
    end

    def self.all
      if File.exists?(PINBOARD_BOOKMARKS_PATH)
        DataSet.new(PINBOARD_BOOKMARKS_PATH).data
      else
        []
      end
    end
  end
