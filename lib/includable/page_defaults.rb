module Includable
  class PageDefaults
    def initialize(string:, data:)
    end

    def render
      <<~HTML
        <!--IncludeInHeader::Text
          <link rel="stylesheet" href="/style.css">
          <script src="/script.js"></script>
        -->
      HTML
    end
  end
end
