module Includable
  class PostFooter
    attr_reader :data

    def initialize(data:)
      @data = data
    end

    def to_s
      ERB.new(template).result_with_hash(date: data.current_page.fetch("date"))
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
