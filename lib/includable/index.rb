module Includable
  class Index
    Post = Struct.new(:title, :url, :date)

    def posts
      Build.data.posts.map do |p|
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
