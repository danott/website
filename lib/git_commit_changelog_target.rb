class GitCommitChangelogTarget
  include Singleton

  TARGET_PATH = Build.target_dir + "/changelog.xml"
  AUTHOR = "Dan Ott".freeze
  TITLE = "Dan Ott's Website Changelog"
  URL = "https://danott.website"

  def to_target
    self
  end

  def hydrate
    self
  end

  def render
    RSS::Maker.make("2.0") do |maker|
      maker.channel.author = AUTHOR
      maker.channel.updated = commits.map(&:date).max.to_s
      maker.channel.about = URL
      maker.channel.title = TITLE
      maker.channel.link = URL
      maker.channel.description = TITLE

      commits.each do |commit|
        maker.items.new_item do |maker_item|
          maker_item.description = commit.description
          maker_item.link = commit.link
          maker_item.title = commit.title
          maker_item.updated = commit.updated
        end
      end
    end
  end

  def write
    File.write(TARGET_PATH, render)
    self
  end

  def commits
    GitCommitJson.generate.map do |commit|
      CommitRssItem.new(
        subject: commit.fetch("subject"),
        body: commit.fetch("body"),
        date: Time.parse(commit.fetch("date")),
        hash: commit.fetch("hash")
      )
    end
  end

  CommitRssItem =
    Struct.new(:subject, :body, :date, :hash, keyword_init: true) do
      def title
        subject
      end

      def description
        options = {
          auto_ids: false,
          hard_wrap: false,
          input: "GFM",
          syntax_highlighter: "rouge"
        }
        Kramdown::Document.new(body, options).to_html.strip
      end

      def link
        "https://github.com/danott/website/commit/" + hash
      end

      def updated
        date.to_s
      end
    end
end
