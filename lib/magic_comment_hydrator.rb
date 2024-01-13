class MagicCommentHydrator
  attr_reader :content
  attr_reader :includables

  def initialize(content:, includables:)
    @content = content
    @includables = includables
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

    delete_at = content.index(current_magic_comment[0])
    insert_at =
      (
        if current_magic_comment[1] == "IncludeInHeader"
          content.index("</head>")
        else
          delete_at
        end
      )

    replacement =
      (
        if current_magic_comment[2].start_with?("Text::")
          current_magic_comment[2].delete_prefix("Text::")
        else
          includables.fetch(current_magic_comment[2]).new.render
        end
      )

    next_content =
      content.sub(current_magic_comment[0], "").insert(insert_at, replacement)
    self.class.new(content: next_content, includables: includables)
  end
end
