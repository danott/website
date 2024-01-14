module Includable
  class PostFooter
    def initialize(string:, data:)
    end

    def render
      <<~HTML
        <a href="/">← Home</a>
      HTML
    end
  end
end
