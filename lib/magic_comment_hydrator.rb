class MagicCommentHydrator
  attr_reader :content
  attr_reader :includables
  attr_reader :data

  def initialize(content:, includables:, data:)
    @content = content
    @includables = includables
    @data = data
  end

  def hydrate
    next_magic_comment.present? ? self.next.hydrate : self
  end

  def next_magic_comment
    magic_comment_regex = /<!--(Include|IncludeInHeader)::(.*?)-->/m
    content.match(magic_comment_regex)
  end

  def next
    fail "No more hyddrating to do!" if next_magic_comment.nil?

    current_magic_comment = next_magic_comment

    insert_at =
      case current_magic_comment[1]
      when "IncludeInHeader"
        content.index("</head>")
      when "Include"
        content.index(current_magic_comment[0])
      else
        fail "Don't know how to handle #{current_magic_comment[1]}"
      end

    includable, maybe_string = current_magic_comment[2].split(/\s/m, 2)
    replacement =
      includables
        .fetch(includable)
        .new(string: maybe_string.to_s.strip, data: data)
        .render

    next_content =
      content.sub(current_magic_comment[0], "").insert(insert_at, replacement)
    self.class.new(content: next_content, includables: includables, data: data)
  end
end
