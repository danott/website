module Includable
  class SixWords
    attr_reader :entries

    Entry = Struct.new(:date, :words)

    def initialize
      @entries =
        Build
          .data
          .sets
          .fetch("six_words")
          .map { |e| Entry.new(e.fetch("date"), e.fetch("words")) }
          .sort_by(&:date)
          .reverse
    end

    def to_s
      ERB.new(template).result_with_hash({ entries: entries })
    end

    def template
      <<~HTML
        <ul>
          <% entries.each do |entry| %>
            <li><%= entry.date %>: <%= entry.words %></li>
          <% end %>
        </ul>
      HTML
    end
  end
end
