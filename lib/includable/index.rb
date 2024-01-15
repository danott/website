module Includable
  class Index
    attr_reader :posts

    Post = Struct.new(:title, :url, :date)

    def initialize
      @posts =
        Build
          .data
          .posts
          .reject { |p| p.fetch("tags", []).include?("noIndex") }
          .map do |p|
            Post.new(p.fetch("title"), p.fetch("url"), p.fetch("date"))
          end
    end

    def to_s
      ERB.new(template).result_with_hash({ "posts" => posts })
    end

    def template
      <<~HTML
        <ul>
          <% posts.each do |post| %>
            <li>
              <a href="<%= post.url %>"><%= post.title %></a>
            </li>
          <% end %>
        </ul>
      HTML
    end
  end
end
