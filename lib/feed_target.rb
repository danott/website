class FeedTarget
  TARGET_PATH = Build.target_dir + "/feed.xml"
  AUTHOR = "Dan Ott".freeze
  TITLE = "Dan Ott's RSS Feed".freeze
  URL = "https://danott.website".freeze
  FIRST_DANOTT_WEBSITE_POST_DATE = Date.parse("2024-01-13")

  def to_target
    self
  end

  def hydrate
    self
  end

  def write
    File.write(TARGET_PATH, render)
    self
  end

  def items
    Build
      .data
      .posts
      .select { |p| p.fetch("date") >= FIRST_DANOTT_WEBSITE_POST_DATE }
      .map { |p| PostDataRssItem.new(p) }
  end

  def render
    RSS::Maker.make("2.0") do |maker|
      maker.channel.author = AUTHOR
      maker.channel.updated = items.map(&:date).max.to_s
      maker.channel.about = URL
      maker.channel.title = TITLE
      maker.channel.link = URL
      maker.channel.description = TITLE

      items.each do |item|
        maker.items.new_item do |maker_item|
          maker_item.description = item.description
          maker_item.link = item.link
          maker_item.title = item.title
          maker_item.updated = item.updated
        end
      end
    end
  end

  class PostDataRssItem
    attr_reader :post_data

    def initialize(post_data)
      @post_data = post_data
    end

    def link
      URL + post_data.fetch("url")
    end

    def date
      post_data.fetch("date")
    end

    def updated
      date.to_s
    end

    def description
      content = File.read(post_data.fetch("source_path"))
      content = Kramdown::Document.new(content, kramdown_options).to_html.strip
      content = remove_html_comments(content)
      content = remove_magic_elements(content)
      content = remove_html_title(content)
      content = make_urls_absolute(content)
      content = append_rss_footer(content)
      content.strip
    end

    def title
      post_data.fetch("title").to_s
    end

    private

    def kramdown_options
      {
        auto_ids: false,
        hard_wrap: false,
        input: "GFM",
        syntax_highlighter: "rouge"
      }
    end

    def remove_html_comments(content)
      content.gsub(/<!--.*?-->/m, "")
    end

    def remove_magic_elements(content)
      content
        .gsub(%r{<template data-parse.*?</template>}m, "")
        .gsub(%r{<include-in-header>.*?</include-in-header>}m, "")
        .gsub(%r{<eval-ruby>.*?</eval-ruby>}m, "")
    end

    def remove_html_title(content)
      content.sub(%r{<h1>.*?</h1>}m, "")
    end

    def make_urls_absolute(content)
      candidates = content.scan(/((src|href)="(.*?)")/)

      candidates.each do |prev_attr_and_value, attr, value|
        next if value.include?("://")

        if value.start_with?("/")
          next_value = URL + value
        else
          next_value = link + value
        end

        next_attr_and_value = %Q[#{attr}="#{next_value}"]
        content = content.sub(prev_attr_and_value, next_attr_and_value)
      end

      content
    end

    def append_rss_footer(content)
      address = %w[danott hey.com].join("@")
      link_without_protocol = link.delete_prefix("https://")
      content + <<~HTML
        <hr />
        <p>
          Thanks for reading via RSS! 
          Wanna talk about it? 
          You can <a href="mailto:#{address}?subject=Re: #{link_without_protocol}">reply via email</a>.
        </p>
      HTML
    end
  end
end
