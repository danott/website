PinboardBookmark =
  Struct.new(:href, :title, :commentary, :date, :tags, keyword_init: true) do
    PATH = "data/pinboard_bookmarks.yml".freeze

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
            date: Date.parse(record.fetch("time")),
            tags: tags.compact.uniq
          )
        end
    end

    def self.download
      File.write(PATH, YAML.dump(pull))
    end
  end
