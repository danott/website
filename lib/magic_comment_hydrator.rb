class MagicCommentHydrator
  attr_reader :content
  attr_reader :data

  def initialize(content:, data:)
    @content = content
    @data = data
  end

  def hydrate
    next_magic_element.present? ? self.next.hydrate : self
  end

  def next_magic_element
    eval_ruby_regex = %r{<(eval-ruby)>(.*?)</eval-ruby>}m
    include_in_header_regex =
      %r{<(include-in-header)>(.*?)</include-in-header>}m
    content.match(eval_ruby_regex) || content.match(include_in_header_regex)
  end

  def next
    fail "No more hydrating to do!" if next_magic_element.nil?

    entire_magic_element = next_magic_element[0]
    magic_element_name = next_magic_element[1]
    magic_element_children = next_magic_element[2]

    replacement =
      case magic_element_name
      when "eval-ruby"
        eval(magic_element_children).to_s.strip
      when "include-in-header"
        magic_element_children.to_s.strip
      else
        fail "Don't know how to handle #{magic_element_name}"
      end

    insert_at =
      case magic_element_name
      when "include-in-header"
        content.index("</head>")
      when "eval-ruby"
        content.index(entire_magic_element)
      else
        fail "Don't know how to handle #{magic_element_name}"
      end

    if insert_at > content.index(entire_magic_element)
      fail "Magic element cannot appear before the targeted replacement position, yet"
    end

    next_content =
      content.sub(entire_magic_element, "").insert(insert_at, replacement)

    self.class.new(content: next_content, data: data)
  end
end
