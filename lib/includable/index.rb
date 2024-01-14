module Includable
  class Index
    attr_reader :posts

    Post = Struct.new(:title, :url, :date)

    def initialize(string:, data:)
      @posts =
        data
          .posts
          .select { |p| p.fetch("date") > Date.parse("2023-12-01") }
          .map do |p|
            Post.new(p.fetch("title"), p.fetch("url"), p.fetch("date"))
          end
    end

    def render
      ERB.new(template).result_with_hash({ "posts" => posts })
    end

    def template
      <<~HTML
        <ul>
          <% posts.each do |post| %>
            <li>
              <a href="<%= post.url %>"><%= post.date %>: <%= post.title %></a>
            </li>
          <% end %>
        </ul>
      HTML
    end
  end
end
