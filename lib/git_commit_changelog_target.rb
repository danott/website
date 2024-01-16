class GitCommitChangelogTarget
  include Singleton

  TARGET_PATH = Build.target_dir + "/changelog.xml"
  AUTHOR = "Dan Ott".freeze
  TITLE = "Dan Ott's Website Changelog"
  URL = "https://danott.website/changelog.xml"

  def to_target
    self
  end

  def hydrate
    self
  end

  def render
    RSS::Maker.make("atom") do |maker|
      maker.channel.id = URL
      maker.channel.link = URL
      maker.channel.title = TITLE
      maker.channel.description = TITLE
      maker.channel.author = AUTHOR
      maker.channel.updated = commits.map(&:date).max.to_s

      commits.each do |commit|
        maker.items.new_item do |maker_item|
          maker_item.id = commit.link
          maker_item.link = commit.link
          maker_item.title = commit.title
          maker_item.summary = commit.summary
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

      def summary
        options = {
          auto_ids: false,
          hard_wrap: false,
          input: "GFM",
          syntax_highlighter: "rouge"
        }
        content = Kramdown::Document.new(body, options).to_html.strip.presence
        [content, github_footer].compact.join("<hr />")
      end

      def link
        "https://github.com/danott/website/commit/" + hash
      end

      def updated
        date.to_s
      end

      def github_footer
        address = %w[danott hey.com].join("@")
        link_without_protocol = link.delete_prefix("https://")

        <<~HTML
          <p>
            Thanks for reading via RSS! 
            Wanna talk about it? 
            You can <a href="#{link}">comment on GitHub</a> or <a href="mailto:#{address}?subject=Re: #{link_without_protocol}">reply via email</a>.
          </p>
        HTML
      end
    end
end
