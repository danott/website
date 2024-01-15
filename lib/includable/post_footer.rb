module Includable
  class PostFooter
    attr_reader :html_target_data

    def initialize(html_target_data)
      @html_target_data = html_target_data
    end

    def to_s
      ERB.new(template).result_with_hash(date: html_target_data.fetch("date"))
    end

    def template
      <<~HTML
        <hr />
        <p>Published: <%= date %></p>
        <p><a href="/">← Home</a></p>
      HTML
    end
  end
end
