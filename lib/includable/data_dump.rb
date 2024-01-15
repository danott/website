module Includable
  class DataDump
    attr_reader :everything

    def initialize
      @everything =
        Build.data.all.merge(
          posts_tagged_climbing: Build.data.posts_tagged("climbing")
        )
    end

    def to_s
      %Q[<pre timestamp="#{Time.now.to_i}">#{CGI.escapeHTML(JSON.pretty_generate(everything))}</pre>]
    end
  end
end
