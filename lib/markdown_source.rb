class MarkdownSource
  include BuildPaths

  attr_reader :content

  def initialize(content:, path:)
    @content = content
    @path = path
  end

  def hydrate
    next_content =
      Kramdown::Document.new(content, kramdown_options).to_html.strip
    data = {}
    next_content, data = hydrate_data_comment(next_content, data)
    next_content, data = hydrate_title_data(next_content, data)
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

  def hydrate_data_comment(content, data)
    data_regex = /<!--data(.*?)-->/m

    if match = content.match(data_regex)
      data.merge! parse_plaintext_data_line(match[1])
      content = content.sub(match[0], "")
    end

    [content, data]
  end

  def hydrate_title_data(content, data)
    title_regex = %r{<title>(.*?)</title>}m

    if match = content.match(title_regex)
      data.merge!("title" => match[1].strip)
    end

    [content, data]
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
