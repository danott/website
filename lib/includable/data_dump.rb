module Includable
  class DataDump
    attr_reader :everything

    def initialize(string:, data:)
      @everything =
        data.all.merge(
          posts_tagged_climbing: Build.data.posts_tagged("climbing")
        )
    end

    def render
      %Q[<pre timestamp="#{Time.now.to_i}">#{CGI.escapeHTML(JSON.pretty_generate(everything))}</pre>]
    end
  end
end
