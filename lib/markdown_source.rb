class MarkdownSource
  include BuildPaths

  attr_reader :content

  def initialize(content:, path:)
    @content = content
    @path = path
  end

  def to_target
    next_content =
      Kramdown::Document.new(content, kramdown_options).to_html.strip
    next_content, data = hydrate_html_template_data(next_content)
    data = data.merge(infer_title_data(next_content))
    HtmlTarget.new(path: path, content: next_content, data: data)
  end

  private

  def kramdown_options
    {
      auto_ids: false,
      hard_wrap: false,
      input: "GFM",
      syntax_highlighter: "rouge",
      template: "document"
    }
  end

  def hydrate_html_template_data(content)
    data_regex = %r{<template data-parse.*?>(.*?)</template>}m

    if match = content.match(data_regex)
      data = parse_plaintext_data_line(match[1])
      content = content.sub(match[0], "")
      [content, data]
    else
      [content, {}]
    end
  end

  def infer_title_data(content)
    title_regex = %r{<title>(.*?)</title>}m

    if match = content.match(title_regex)
      { "title" => match[1].strip }
    else
      {}
    end
  end

  def parse_plaintext_data_line(line)
    line
      .split("#")
      .select(&:present?)
      .each_with_object({}) do |token, wip_data|
        parts = token.split(":", 2).map(&:strip)
        case parts.size
        when 2
          wip_data[parts.first] = parts.last
        when 1
          if parts.first.match(/\d\d\d\d-\d\d-\d\d/)
            wip_data["date"] = Date.parse(parts.first)
          else
            wip_data["tags"] ||= []
            wip_data["tags"] << parts.first
          end
        else
          fail "How is that possible?"
        end
      end
  end
end
